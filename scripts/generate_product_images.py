"""
FitFlavor — Automated Product Image Generator
==============================================
Pipeline:
  1. Fetch all products (+ brand name) from Supabase that have no image
  2. Search DuckDuckGo Images for "[brand] [product] pre-workout"
  3. Download the best result
  4. Remove background with rembg (local AI, free)
  5. Composite onto a branded dark card (matches app's --bg-card)
  6. Upload to Supabase Storage bucket "product-images"
  7. Update products.image_url in the DB

Requirements:
  pip install rembg pillow requests supabase duckduckgo-search

Usage:
  SUPABASE_SERVICE_KEY=your_key python scripts/generate_product_images.py

  # Dry run (search + download only, no upload):
  DRY_RUN=1 SUPABASE_SERVICE_KEY=your_key python scripts/generate_product_images.py

  # Force-regenerate even products that already have an image:
  FORCE=1 SUPABASE_SERVICE_KEY=your_key python scripts/generate_product_images.py
"""

import io
import os
import sys
import time
import hashlib
import traceback
from pathlib import Path

import requests
from PIL import Image, ImageFilter, ImageDraw, ImageChops
from rembg import remove as rembg_remove
from supabase import create_client, Client
from duckduckgo_search import DDGS

# ── Config ────────────────────────────────────────────────────────────────────

SUPABASE_URL  = "https://jzgkjwjjpymjnznkktaq.supabase.co"
SUPABASE_KEY  = os.environ.get("SUPABASE_SERVICE_KEY", "")
BUCKET        = "product-images"
DRY_RUN       = os.environ.get("DRY_RUN", "0") == "1"
FORCE         = os.environ.get("FORCE", "0") == "1"

# Card dimensions (square, matches mobile card ratio)
CARD_W, CARD_H = 600, 600

# App's --bg-card colour
BG_COLOR = (15, 20, 32)        # #0F1420
GLOW_COLOR = (61, 142, 255)    # --accent #3D8EFF

# Delay between DDG searches (be polite)
SEARCH_DELAY = 2.0

# Max image download size (skip huge originals)
MAX_BYTES = 8 * 1024 * 1024  # 8 MB

# ── Card compositor ───────────────────────────────────────────────────────────

def build_card(product_png: bytes) -> bytes:
    """
    Places a background-removed product image on the branded dark card.
    Returns JPEG bytes ready for upload.
    """
    # ── Base layer: dark background
    card = Image.new("RGBA", (CARD_W, CARD_H), (*BG_COLOR, 255))

    # ── Mid layer: subtle radial glow (accent colour, very transparent)
    glow = Image.new("RGBA", (CARD_W, CARD_H), (0, 0, 0, 0))
    glow_draw = ImageDraw.Draw(glow)
    cx, cy = CARD_W // 2, CARD_H // 2
    radius = CARD_W * 0.55
    for r in range(int(radius), 0, -1):
        alpha = int(30 * (1 - r / radius) ** 2)  # soft quadratic falloff
        glow_draw.ellipse(
            [cx - r, cy - r, cx + r, cy + r],
            fill=(*GLOW_COLOR, alpha),
        )
    card = Image.alpha_composite(card, glow)

    # ── Product layer: bg-removed image, scaled to fill ~92% of card
    product = Image.open(io.BytesIO(product_png)).convert("RGBA")
    target = int(CARD_W * 0.92)
    # Scale so the longest side equals target (never downsample below target)
    scale = target / max(product.width, product.height)
    new_w = max(int(product.width * scale), 1)
    new_h = max(int(product.height * scale), 1)
    product = product.resize((new_w, new_h), Image.LANCZOS)

    # Centre the product on the card
    px = (CARD_W - product.width) // 2
    py = (CARD_H - product.height) // 2
    card.paste(product, (px, py), mask=product)

    # ── Drop shadow (fake depth under the product)
    shadow_layer = Image.new("RGBA", (CARD_W, CARD_H), (0, 0, 0, 0))
    shadow_alpha = product.getchannel("A").filter(ImageFilter.GaussianBlur(18))
    shadow_img = Image.new("RGBA", product.size, (0, 0, 0, 90))
    shadow_img.putalpha(shadow_alpha)
    # Offset shadow slightly down
    shadow_layer.paste(shadow_img, (px + 4, py + 10), mask=shadow_img)
    card = Image.alpha_composite(card, shadow_layer)
    # Re-paste product on top of shadow
    card.paste(product, (px, py), mask=product)

    # ── Convert to JPEG for upload (smaller, browser-safe)
    out = io.BytesIO()
    card.convert("RGB").save(out, format="JPEG", quality=92, optimize=True)
    return out.getvalue()


# ── Image search ──────────────────────────────────────────────────────────────

def score_result(r: dict) -> int:
    """
    Score a DDG image result — higher is better.
    Penalises portrait images (label shots).
    Rewards square/landscape images from known supplement retailers.
    Only applies size/ratio checks when dimensions are actually provided.
    """
    score = 0
    url = (r.get("image") or "").lower()
    w   = r.get("width", 0) or 0
    h   = r.get("height", 0) or 0

    # Only apply dimension checks when DDG provides them
    if w > 0 and h > 0:
        # Strong penalty for very tall portrait (back-label shots)
        if w / h < 0.6:
            score -= 80
        # Reward square-ish images (front-facing product shots)
        ratio = w / h
        if 0.75 <= ratio <= 1.35:
            score += 40
        # Reward large images
        if w >= 500 and h >= 500:
            score += 20

    # Reward direct image file extensions
    if any(url.endswith(ext) for ext in (".jpg", ".jpeg", ".png", ".webp")):
        score += 15

    # Reward known supplement retail domains
    good_domains = ("iherb", "bodybuilding.com", "gnc.com", "amazon", "vitaminworld",
                    "supplementwarehouse", "strongsupplementshop", "tigerfitness")
    if any(d in url for d in good_domains):
        score += 30

    return score


def search_product_image(brand: str, product: str) -> str | None:
    """
    Returns the best image URL from DuckDuckGo Images.
    Uses retail-oriented queries to get front-facing product shots.
    Scores all candidates and picks the highest-quality one.
    """
    queries = [
        f"{brand} {product} pre-workout buy",           # retail listings = front shots
        f"{brand} {product} pre workout supplement",
        f"{product} pre-workout buy supplement",
    ]
    with DDGS() as ddgs:
        for query in queries:
            try:
                results = list(ddgs.images(query, max_results=12))
                if not results:
                    time.sleep(SEARCH_DELAY)
                    continue

                # Score all candidates and take the best
                scored = [(score_result(r), r) for r in results]
                scored.sort(key=lambda x: x[0], reverse=True)
                best_score, best = scored[0]

                if best_score > -999:
                    return best.get("image")
            except Exception:
                pass
            time.sleep(SEARCH_DELAY)
    return None


def download_image(url: str, min_dim: int = 250) -> bytes | None:
    """
    Downloads an image URL, returns raw bytes or None on failure.
    Rejects images smaller than min_dim on either side.
    """
    try:
        resp = requests.get(url, timeout=15, headers={
            "User-Agent": "Mozilla/5.0 (compatible; FitFlavor-ImageBot/1.0)"
        })
        resp.raise_for_status()
        if int(resp.headers.get("content-length", 0) or 0) > MAX_BYTES:
            return None
        if len(resp.content) > MAX_BYTES:
            return None
        # Validate it's actually an image and meets minimum size
        img = Image.open(io.BytesIO(resp.content))
        if img.width < min_dim or img.height < min_dim:
            return None
        return resp.content
    except Exception:
        return None


# ── Supabase helpers ──────────────────────────────────────────────────────────

def ensure_bucket(sb: Client):
    """Creates the storage bucket if it doesn't already exist."""
    try:
        sb.storage.get_bucket(BUCKET)
    except Exception:
        sb.storage.create_bucket(BUCKET, options={"public": True})
        print(f"  ✓ Created storage bucket '{BUCKET}'")


def upload_image(sb: Client, product_id: str, jpeg_bytes: bytes) -> str:
    """
    Uploads JPEG bytes to Supabase Storage.
    Returns the public URL.
    """
    path = f"{product_id}.jpg"
    sb.storage.from_(BUCKET).upload(
        path,
        jpeg_bytes,
        file_options={"content-type": "image/jpeg", "upsert": "true"},
    )
    return f"{SUPABASE_URL}/storage/v1/object/public/{BUCKET}/{path}"


def update_product_image(sb: Client, product_id: str, url: str):
    sb.table("products").update({"image_url": url}).eq("id", product_id).execute()


# ── Main ──────────────────────────────────────────────────────────────────────

def main():
    if not SUPABASE_KEY:
        print("ERROR: Set SUPABASE_SERVICE_KEY env var (grab it from supabase.com → Settings → API)")
        sys.exit(1)

    sb = create_client(SUPABASE_URL, SUPABASE_KEY)

    if not DRY_RUN:
        ensure_bucket(sb)

    # Fetch all products with their brand name
    resp = (
        sb.table("products")
        .select("id, name, image_url, brands(name)")
        .execute()
    )
    products = resp.data or []

    if not FORCE:
        products = [p for p in products if not p.get("image_url")]

    total = len(products)
    print(f"\n{'DRY RUN — ' if DRY_RUN else ''}Processing {total} product(s)...\n")

    success = 0
    fail = 0

    for i, product in enumerate(products, 1):
        pid   = product["id"]
        name  = product["name"]
        brand = (product.get("brands") or {}).get("name", "")
        label = f"[{i}/{total}] {brand} — {name}"

        print(f"{label}")

        # ── 1. Search for image
        print("  → Searching for image...")
        img_url = search_product_image(brand, name)
        if not img_url:
            print("  ✗ No image found — skipping\n")
            fail += 1
            continue
        print(f"  → Found: {img_url[:80]}...")

        # ── 2. Download
        raw = download_image(img_url)
        if not raw:
            print("  ✗ Download failed — skipping\n")
            fail += 1
            continue
        print(f"  → Downloaded {len(raw) // 1024} KB")

        # ── 3. Remove background
        try:
            print("  → Removing background (rembg)...")
            no_bg = rembg_remove(raw)
        except Exception as e:
            print(f"  ✗ rembg failed: {e} — skipping\n")
            fail += 1
            continue

        # ── 4. Composite onto branded card
        try:
            card_jpeg = build_card(no_bg)
            print(f"  → Card built ({len(card_jpeg) // 1024} KB JPEG)")
        except Exception as e:
            print(f"  ✗ Compositing failed: {e} — skipping\n")
            fail += 1
            continue

        if DRY_RUN:
            # Save locally for preview
            out_dir = Path("scripts/preview_images")
            out_dir.mkdir(exist_ok=True)
            safe_name = "".join(c if c.isalnum() else "_" for c in f"{brand}_{name}")[:60]
            out_path = out_dir / f"{safe_name}.jpg"
            out_path.write_bytes(card_jpeg)
            print(f"  ✓ DRY RUN — saved to {out_path}\n")
            success += 1
            continue

        # ── 5. Upload to Supabase Storage
        try:
            public_url = upload_image(sb, pid, card_jpeg)
            print(f"  → Uploaded: {public_url}")
        except Exception as e:
            print(f"  ✗ Upload failed: {e} — skipping\n")
            fail += 1
            continue

        # ── 6. Update DB
        try:
            update_product_image(sb, pid, public_url)
            print(f"  ✓ Done\n")
            success += 1
        except Exception as e:
            print(f"  ✗ DB update failed: {e}\n")
            fail += 1

        # Polite delay between products
        time.sleep(1.0)

    print(f"\n{'─' * 50}")
    print(f"Complete: {success} success, {fail} failed out of {total} total")
    if DRY_RUN:
        print(f"Preview images saved to scripts/preview_images/")


if __name__ == "__main__":
    main()

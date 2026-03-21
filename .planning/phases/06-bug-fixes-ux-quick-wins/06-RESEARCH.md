# Phase 6: Bug Fixes & UX Quick Wins - Research

**Researched:** 2026-03-22
**Domain:** Frontend bug fixes (React/Next.js), CSS theming, navigation layout
**Confidence:** HIGH

## Summary

Phase 6 addresses five discrete, well-scoped issues: a username validation regex bug, a hardcoded color causing light-theme readability issues, inconsistent taste tag display, an unwanted Browse tab in bottom navigation, and adding a hero image to the landing page. All five fixes are frontend-only with no database migrations required.

Every fix has been verified against the actual source code. The username DB column has no CHECK constraint (just `TEXT UNIQUE NOT NULL`), so only the client-side regex needs updating. The email visibility bug is a single hardcoded `text-white` class on line 48 of signup/page.tsx. The taste tag pattern (`flavor.tags && flavor.tags.length > 0`) is already used correctly in most places but needs consistency audit across all display surfaces. The BottomNav Browse tab removal is straightforward -- delete the Browse `<Link>` block and the `browseActive` variable, leaving 4 tabs with the centered Rate button. The hero image goes into the existing `{!user && (...)}` hero card block on page.tsx.

**Primary recommendation:** Execute as five independent, small tasks -- one per fix. Each is isolated with no cross-dependencies.

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions
- Landing page hero image: A gym supplement product shot (pre-workout or protein tub -- generic, brand-agnostic)
- Use a placeholder image for now (user will provide final asset later)
- Image sits **above** the tagline -- fills the top of the hero card, text + CTAs below
- Style: **full-width, rounded top corners** matching the existing card border-radius -- no padding around image, edge-to-edge

### Claude's Discretion
- FIX-01: Username regex fix -- update `/^[a-z0-9_]+$/` to `/^[a-z0-9_.]+$/` in both `src/app/signup/page.tsx` and `src/app/settings/page.tsx`. Also check if Supabase DB has a column constraint that needs updating.
- FIX-02: Email display fix -- replace hardcoded `text-white` class on `<span>` in `src/app/signup/page.tsx:48` with a theme-aware color (use `var(--text)` or `var(--accent)`)
- FIX-03: Taste tag consistency -- hide the tags section when `flavor.tags` is empty/null (consistent absence is better than showing an empty widget). Apply this consistently across all product cards and flavor pages.
- FIX-04: Remove Browse tab from BottomNav -- the 4 remaining tabs (Home, Rate, Top, Profile) should be evenly redistributed. The Browse active state paths (`/products`, `/flavors`, `/brands`) can be left unmatched or redirected. Claude decides the cleanest layout for 4 tabs with the center Rate button.

### Deferred Ideas (OUT OF SCOPE)
None -- discussion stayed within phase scope.
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| FIX-01 | Username field allows `.` (dot) character | Regex update in 2 files; DB has no constraint to update; hint text update needed |
| FIX-02 | Email text is visible on light theme (not white on white) | Replace `text-white` class with inline style using `var(--text)` on signup success page |
| FIX-03 | All products consistently show taste/flavor tags (or none if not applicable) | Guard pattern `flavor.tags && flavor.tags.length > 0` already used in most places; audit all surfaces |
| FIX-04 | Browse/search button removed from bottom navigation | Delete Browse Link block + browseActive variable from BottomNav.tsx; 4 tabs redistribute via flex:1 |
| FIX-05 | Landing page displays a hero image | Add `next/image` to hero card in page.tsx above the h1 tagline; placeholder image with easy swap path |
</phase_requirements>

## Architecture Patterns

### Files to Modify (Complete Map)

```
src/app/signup/page.tsx          # FIX-01 (regex L25) + FIX-02 (text-white L48)
src/app/settings/page.tsx        # FIX-01 (regex L45)
src/components/layout/BottomNav.tsx  # FIX-04 (remove Browse tab)
src/app/page.tsx                 # FIX-05 (hero image in mobile hero card, L92-L144)
src/app/products/[slug]/page.tsx # FIX-03 (tags already guarded correctly -- verify only)
src/app/flavors/[slug]/page.tsx  # FIX-03 (tags already guarded correctly -- verify only)
src/components/feed/FeedCard.tsx # FIX-03 (context_tags already guarded -- verify only)
```

### Pattern: Theme-Aware Colors
**What:** Never use Tailwind color utilities like `text-white` or `text-black` for text that appears on theme-dependent backgrounds. Always use CSS custom properties.
**When to use:** Any text that must be readable in both dark and light themes.
**Example:**
```tsx
// BAD -- hardcoded color breaks on light theme
<span className="text-white font-medium">{form.email}</span>

// GOOD -- uses theme-aware CSS variable
<span style={{ color: 'var(--text)', fontWeight: 500 }}>{form.email}</span>
```

### Pattern: Conditional Tag Display
**What:** Guard tag sections with `tags && tags.length > 0` check before rendering.
**When to use:** Any place flavor tags or context tags are displayed.
**Example:**
```tsx
// Correct pattern (already used in most places)
{flavor.tags && flavor.tags.length > 0 && (
  <div style={{ display: 'flex', gap: '6px', flexWrap: 'wrap' }}>
    {flavor.tags.map((tag) => (
      <span key={tag.id} className="tag">{tag.name}</span>
    ))}
  </div>
)}
```

### Pattern: Hero Image with next/image
**What:** Use `next/image` for the hero image with a placeholder src that is easy to swap later.
**When to use:** Landing page hero card.
**Example:**
```tsx
// Inside the hero card div, BEFORE the h1 tagline
// The card needs overflow: 'hidden' to clip rounded top corners
<div style={{
  borderRadius: 'var(--radius-lg)',
  backgroundColor: 'var(--bg-card)',
  border: '1px solid var(--border)',
  overflow: 'hidden',  // clips the image to card border-radius
  textAlign: 'center',
  boxSizing: 'border-box',
  marginBottom: '24px',
}}>
  {/* Hero image -- full-width, no padding */}
  <Image
    src="/hero-placeholder.jpg"  // easy to swap later
    alt="Pre-workout supplement"
    width={800}
    height={400}
    style={{
      width: '100%',
      height: 'auto',
      maxHeight: '200px',
      objectFit: 'cover',
      display: 'block',
    }}
    priority
  />
  {/* Text content with padding below image */}
  <div style={{ padding: '28px 20px' }}>
    <h1>...</h1>
    <p>...</p>
    {/* CTAs */}
  </div>
</div>
```

### Anti-Patterns to Avoid
- **Hardcoded Tailwind colors for themed text:** Using `text-white`, `text-black`, `text-gray-500` etc. for text on theme-variable backgrounds. Always use `var(--text)`, `var(--text-dim)`, etc.
- **Empty tag sections:** Rendering an empty flex container when tags array is null/empty. Always guard with the length check.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Image optimization | Manual resize/format | `next/image` component | Automatic WebP, lazy loading, responsive sizing |
| Placeholder images | Download/bundle large files | Unsplash URL or gradient div | Temporary asset, easy to swap |

## Common Pitfalls

### Pitfall 1: Forgetting the Settings Page Regex
**What goes wrong:** Username regex is updated in signup but not settings, creating inconsistency where users can sign up with dots but get validation errors when editing.
**Why it happens:** Two separate files with duplicated validation logic.
**How to avoid:** Update both `src/app/signup/page.tsx` (line 25) and `src/app/settings/page.tsx` (line 45) simultaneously.
**Warning signs:** Grep for `/^[a-z0-9_]+$/` should return zero results after the fix.

### Pitfall 2: Hint Text Not Updated
**What goes wrong:** Regex allows dots but hint still says "Lowercase letters, numbers, underscores only."
**Why it happens:** Hint text is a separate string from the regex.
**How to avoid:** Update hint text in both signup (line 78) and settings (line 193) to include "dots" or "periods."
**Warning signs:** Hint text doesn't match allowed characters.

### Pitfall 3: Hero Image Card Layout Change
**What goes wrong:** Adding the image above text but keeping the existing padding on the card container causes a gap between image and card edge.
**Why it happens:** The current hero card has `padding: '28px 20px'` on the outer div.
**How to avoid:** Move padding to an inner wrapper below the image, and set `overflow: 'hidden'` on the outer card div. The image div should have zero padding.
**Warning signs:** Visible gap between image and card border.

### Pitfall 4: BottomNav Browse Paths Orphaned
**What goes wrong:** After removing Browse tab, routes like `/products`, `/flavors`, `/brands` no longer highlight any nav tab.
**Why it happens:** `browseActive` was matching those paths.
**How to avoid:** This is acceptable behavior per CONTEXT.md -- these paths can be left unmatched. The user navigates via links in the feed/pages, not the bottom nav.
**Warning signs:** None -- this is expected.

### Pitfall 5: Rate Button Centering After 4 Tabs
**What goes wrong:** The floating Rate button may shift position with 4 tabs instead of 5.
**Why it happens:** The Rate button uses `flex: 1` like other tabs and `position: absolute` centering.
**How to avoid:** With 4 tabs (Home, Rate-spacer, Top, Profile), each gets `flex: 1` = 25% width. The Rate button is absolutely positioned at `left: 50%` within its container, so it will naturally center within its flex cell. This should work correctly without changes to the Rate button itself.
**Warning signs:** Rate button not visually centered -- test on mobile viewport.

## Code Examples

### FIX-01: Username Regex Update
```tsx
// BEFORE (both files):
if (!/^[a-z0-9_]+$/.test(form.username))
  return setError('Username can only contain lowercase letters, numbers, and underscores.')

// AFTER (both files):
if (!/^[a-z0-9_.]+$/.test(form.username))
  return setError('Username can only contain lowercase letters, numbers, underscores, and dots.')
```

### FIX-02: Email Text Color Fix
```tsx
// BEFORE (signup/page.tsx line 48):
<span className="text-white font-medium">{form.email}</span>

// AFTER:
<span style={{ color: 'var(--text)', fontWeight: 500 }}>{form.email}</span>
```

### FIX-04: BottomNav Browse Removal
```tsx
// DELETE: The entire Browse Link block (lines 76-83)
// DELETE: The browseActive variable (line 14)
// KEEP: Home, Rate (center), Top, Profile -- all with flex: 1
```

## Specific Findings

### FIX-01: Database Has No Username Constraint
**Confidence: HIGH** (verified from `supabase/migrations/001_initial_schema.sql`)

The `users` table defines username as `TEXT UNIQUE NOT NULL` with no CHECK constraint on allowed characters. Only the frontend regex needs updating. No migration required.

### FIX-02: Exact Bug Location
**Confidence: HIGH** (verified from source)

Line 48 of `src/app/signup/page.tsx`:
```tsx
<span className="text-white font-medium">{form.email}</span>
```
This appears in the success screen after signup ("Check your email"). On light theme, the surrounding text uses `text-[#A0A0A0]` (gray) but the email uses `text-white` which is invisible on the light theme's white/cream background.

### FIX-03: Tag Display Audit Results
**Confidence: HIGH** (verified from source)

All three display surfaces already use the correct guard pattern:
- `src/app/products/[slug]/page.tsx` line 258: `{flavor.tags && flavor.tags.length > 0 && (...)}` -- CORRECT
- `src/app/flavors/[slug]/page.tsx` line 98: `{flavor.tags && flavor.tags.length > 0 && (...)}` -- CORRECT
- `src/components/feed/FeedCard.tsx` line 340: `{ratingData.context_tags && ratingData.context_tags.length > 0 && (...)}` -- CORRECT
- `src/app/page.tsx` line 569: `{item.tags && item.tags.length > 0 && (...)}` -- CORRECT (desktop leaderboard)

The tag display may already be consistent. The implementer should verify at runtime whether any data-level inconsistency exists (e.g., some flavors have `tags: []` vs `tags: null`). If so, the guard handles both cases. This may be a "verify and confirm fixed" task rather than a code change.

### FIX-04: BottomNav Current Structure
**Confidence: HIGH** (verified from source)

Current 5 tabs: Home | Browse | Rate (center) | Top | Profile
After removal: Home | Rate (center) | Top | Profile (4 tabs)

The flex layout with `flex: 1` on each tab will auto-redistribute. The Rate button's container div is a flex item too, so the layout becomes 4 equal columns. The floating Rate button is absolutely positioned within its container and self-centers.

### FIX-05: Hero Card Structure
**Confidence: HIGH** (verified from source)

The mobile hero card (lines 92-144 of page.tsx) currently has:
- Outer div: `padding: '28px 20px'`, `borderRadius: 'var(--radius-lg)'`
- No `overflow: 'hidden'` (needs adding)
- Content: h1 tagline, description p, two CTA links

To add the hero image above the tagline:
1. Move `padding` from outer div to an inner content wrapper
2. Add `overflow: 'hidden'` to outer div
3. Add Image component as first child of outer div
4. Place a placeholder image in `/public/hero-placeholder.jpg` or use an Unsplash URL

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | None (test suite deferred to v2) |
| Config file | N/A |
| Quick run command | N/A |
| Full suite command | N/A |

### Phase Requirements -> Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| FIX-01 | Username accepts dots | manual-only | Visual test in browser | N/A |
| FIX-02 | Email readable on light theme | manual-only | Toggle theme after signup | N/A |
| FIX-03 | Tags display consistently | manual-only | Browse product/flavor pages | N/A |
| FIX-04 | No Browse tab in BottomNav | manual-only | Check mobile nav | N/A |
| FIX-05 | Hero image displays on landing | manual-only | Visit / as logged-out user | N/A |

**Justification for manual-only:** Project has zero test infrastructure (deferred to v2 per STATE.md). All fixes are visual/UI and best verified by inspection.

### Sampling Rate
- **Per task commit:** Visual verification in browser (dev server)
- **Per wave merge:** Full manual walkthrough of all 5 fixes
- **Phase gate:** All 5 acceptance criteria met visually

### Wave 0 Gaps
None applicable -- no test infrastructure exists or is expected for this phase.

## Sources

### Primary (HIGH confidence)
- `src/app/signup/page.tsx` - Verified regex on line 25, text-white on line 48
- `src/app/settings/page.tsx` - Verified regex on line 45, hint on line 193
- `src/components/layout/BottomNav.tsx` - Verified Browse tab structure
- `src/app/page.tsx` - Verified hero card structure (lines 92-144)
- `supabase/migrations/001_initial_schema.sql` - Verified no CHECK constraint on username
- `src/app/globals.css` - Verified CSS custom properties for theming
- `src/app/products/[slug]/page.tsx` - Verified tag guard pattern
- `src/app/flavors/[slug]/page.tsx` - Verified tag guard pattern
- `src/components/feed/FeedCard.tsx` - Verified context_tags guard pattern

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH - No new libraries needed, all fixes use existing patterns
- Architecture: HIGH - All file locations and code patterns verified against source
- Pitfalls: HIGH - Each pitfall identified from actual code structure

**Research date:** 2026-03-22
**Valid until:** 2026-04-22 (stable -- bug fixes against existing code)

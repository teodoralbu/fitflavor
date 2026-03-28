-- =============================================================================
-- GymTaste — Seed Expansion Batch 4: Budget, Nootropic & Extreme
-- Run AFTER seed_expansion_batch3.sql
-- Safe to re-run: all inserts use ON CONFLICT DO NOTHING
-- Brands:   b1000000-...-000000000026 → 000000000030
-- Products: a1000000-...-000000000083 → 000000000091
-- Flavors:  f1000000-...-000000000241 → 000000000261
-- =============================================================================

BEGIN;

-- =============================================================================
-- SECTION 1: New Brands
-- =============================================================================
INSERT INTO brands (id, name, slug) VALUES
  ('b1000000-0000-0000-0000-000000000026', 'Evlution Nutrition', 'evlution-nutrition'),
  ('b1000000-0000-0000-0000-000000000027', 'Six Star',           'six-star'),
  ('b1000000-0000-0000-0000-000000000028', 'Performix',          'performix'),
  ('b1000000-0000-0000-0000-000000000029', 'Genius Brand',       'genius-brand'),
  ('b1000000-0000-0000-0000-000000000030', 'Apollon Nutrition',  'apollon-nutrition')
ON CONFLICT DO NOTHING;

-- =============================================================================
-- SECTION 2: New Products
-- =============================================================================
INSERT INTO products (id, brand_id, category_id, name, slug, caffeine_mg, citrulline_g, beta_alanine_g, price_per_serving, servings_per_container, is_approved) VALUES

  -- ── Evlution Nutrition (brand b26) ────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000083', 'b1000000-0000-0000-0000-000000000026', 'c1000000-0000-0000-0000-000000000001',
   'ENGN', 'evl-engn', 250, 0, 1.6, 0.83, 30, true),
  ('a1000000-0000-0000-0000-000000000084', 'b1000000-0000-0000-0000-000000000026', 'c1000000-0000-0000-0000-000000000001',
   'ENGN Shred', 'evl-engn-shred', 250, 0, 1.6, 1.00, 30, true),

  -- ── Six Star (brand b27) ──────────────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000085', 'b1000000-0000-0000-0000-000000000027', 'c1000000-0000-0000-0000-000000000001',
   'Pre-Workout Explosion', 'six-star-explosion', 200, 0, 1.6, 0.50, 30, true),

  -- ── Performix (brand b28) ─────────────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000086', 'b1000000-0000-0000-0000-000000000028', 'c1000000-0000-0000-0000-000000000001',
   'SST Pre-Workout', 'performix-sst', 250, 0, 0, 1.67, 45, true),
  ('a1000000-0000-0000-0000-000000000087', 'b1000000-0000-0000-0000-000000000028', 'c1000000-0000-0000-0000-000000000001',
   'ION Pre-Workout', 'performix-ion', 200, 4.0, 1.6, 1.33, 20, true),

  -- ── Genius Brand (brand b29) ──────────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000088', 'b1000000-0000-0000-0000-000000000029', 'c1000000-0000-0000-0000-000000000001',
   'Genius Pre', 'genius-pre', 200, 6.0, 2.0, 1.50, 20, true),

  -- ── Apollon Nutrition (brand b30) ─────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000089', 'b1000000-0000-0000-0000-000000000030', 'c1000000-0000-0000-0000-000000000001',
   'Hooligan', 'apollon-hooligan', 600, 9.0, 3.5, 2.50, 20, true),
  ('a1000000-0000-0000-0000-000000000090', 'b1000000-0000-0000-0000-000000000030', 'c1000000-0000-0000-0000-000000000001',
   'Bare Knuckle', 'apollon-bare-knuckle', 0, 8.0, 0, 1.67, 25, true),
  ('a1000000-0000-0000-0000-000000000091', 'b1000000-0000-0000-0000-000000000030', 'c1000000-0000-0000-0000-000000000001',
   'Assassin', 'apollon-assassin', 400, 6.0, 3.2, 2.00, 20, true)

ON CONFLICT DO NOTHING;

-- =============================================================================
-- SECTION 3: Region + Stim Type
-- =============================================================================
-- Evlution Nutrition
UPDATE products SET region = ARRAY['US','EU'], stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000083'; -- ENGN
UPDATE products SET region = ARRAY['US','EU'], stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000084'; -- ENGN Shred
-- Six Star
UPDATE products SET region = ARRAY['US','EU'], stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000085'; -- Explosion
-- Performix
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000086'; -- SST
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000087'; -- ION
-- Genius Brand
UPDATE products SET region = ARRAY['US','EU'], stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000088'; -- Genius Pre
-- Apollon Nutrition
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000089'; -- Hooligan
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim-free' WHERE id = 'a1000000-0000-0000-0000-000000000090'; -- Bare Knuckle
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000091'; -- Assassin

-- =============================================================================
-- SECTION 4: Flavors
-- =============================================================================
INSERT INTO flavors (id, product_id, name, slug) VALUES

  -- ENGN (a83)
  ('f1000000-0000-0000-0000-000000000241', 'a1000000-0000-0000-0000-000000000083', 'Blue Raz',            'engn-blue-raz'),
  ('f1000000-0000-0000-0000-000000000242', 'a1000000-0000-0000-0000-000000000083', 'Furious Grape',       'engn-furious-grape'),
  ('f1000000-0000-0000-0000-000000000243', 'a1000000-0000-0000-0000-000000000083', 'Cherry Limeade',      'engn-cherry-limeade'),

  -- ENGN Shred (a84)
  ('f1000000-0000-0000-0000-000000000244', 'a1000000-0000-0000-0000-000000000084', 'Watermelon',          'engn-shred-watermelon'),
  ('f1000000-0000-0000-0000-000000000245', 'a1000000-0000-0000-0000-000000000084', 'Cherry Limeade',      'engn-shred-cherry-limeade'),

  -- Six Star Explosion (a85)
  ('f1000000-0000-0000-0000-000000000246', 'a1000000-0000-0000-0000-000000000085', 'Fruit Punch',         'six-star-explosion-fruit-punch'),
  ('f1000000-0000-0000-0000-000000000247', 'a1000000-0000-0000-0000-000000000085', 'Icy Grape',           'six-star-explosion-icy-grape'),
  ('f1000000-0000-0000-0000-000000000248', 'a1000000-0000-0000-0000-000000000085', 'Blue Raspberry',      'six-star-explosion-blue-raspberry'),

  -- Performix SST (a86)
  ('f1000000-0000-0000-0000-000000000249', 'a1000000-0000-0000-0000-000000000086', 'Blue Raspberry Lemonade','performix-sst-blue-raspberry-lemonade'),
  ('f1000000-0000-0000-0000-000000000250', 'a1000000-0000-0000-0000-000000000086', 'Passion Fruit',       'performix-sst-passion-fruit'),

  -- Performix ION (a87)
  ('f1000000-0000-0000-0000-000000000251', 'a1000000-0000-0000-0000-000000000087', 'Wild Berry',          'performix-ion-wild-berry'),
  ('f1000000-0000-0000-0000-000000000252', 'a1000000-0000-0000-0000-000000000087', 'Lemon Lime',          'performix-ion-lemon-lime'),

  -- Genius Pre (a88)
  ('f1000000-0000-0000-0000-000000000253', 'a1000000-0000-0000-0000-000000000088', 'Blue Raspberry',      'genius-pre-blue-raspberry'),
  ('f1000000-0000-0000-0000-000000000254', 'a1000000-0000-0000-0000-000000000088', 'Watermelon',          'genius-pre-watermelon'),
  ('f1000000-0000-0000-0000-000000000255', 'a1000000-0000-0000-0000-000000000088', 'Lemon Lime',          'genius-pre-lemon-lime'),

  -- Apollon Hooligan (a89)
  ('f1000000-0000-0000-0000-000000000256', 'a1000000-0000-0000-0000-000000000089', 'Raspberry Lemonade',  'hooligan-raspberry-lemonade'),
  ('f1000000-0000-0000-0000-000000000257', 'a1000000-0000-0000-0000-000000000089', 'Passion Fruit',       'hooligan-passion-fruit'),

  -- Apollon Bare Knuckle (a90)
  ('f1000000-0000-0000-0000-000000000258', 'a1000000-0000-0000-0000-000000000090', 'Strawberry Kiwi',     'bare-knuckle-strawberry-kiwi'),
  ('f1000000-0000-0000-0000-000000000259', 'a1000000-0000-0000-0000-000000000090', 'Orange Mango',        'bare-knuckle-orange-mango'),

  -- Apollon Assassin (a91)
  ('f1000000-0000-0000-0000-000000000260', 'a1000000-0000-0000-0000-000000000091', 'Watermelon',          'assassin-watermelon'),
  ('f1000000-0000-0000-0000-000000000261', 'a1000000-0000-0000-0000-000000000091', 'Blue Raspberry',      'assassin-blue-raspberry')

ON CONFLICT DO NOTHING;

COMMIT;

-- =============================================================================
-- Summary
-- Brands added:    5  (Evlution Nutrition, Six Star, Performix, Genius Brand, Apollon Nutrition)
-- Products added:  9  (a83–a91)
-- Flavors added:  21  (f241–f261)
-- Next batch starts:
--   Brands:   b1000000-0000-0000-0000-000000000031
--   Products: a1000000-0000-0000-0000-000000000092
--   Flavors:  f1000000-0000-0000-0000-000000000262
-- =============================================================================

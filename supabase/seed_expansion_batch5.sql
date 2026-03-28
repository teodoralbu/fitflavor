-- =============================================================================
-- GymTaste — Seed Expansion Batch 5: Extreme, Underground & Budget
-- Run AFTER seed_expansion_batch4.sql
-- Safe to re-run: all inserts use ON CONFLICT DO NOTHING
-- Brands:   b1000000-...-000000000031 → 000000000035
-- Products: a1000000-...-000000000092 → 000000000100
-- Flavors:  f1000000-...-000000000262 → 000000000284
-- =============================================================================

BEGIN;

-- =============================================================================
-- SECTION 1: New Brands
-- =============================================================================
INSERT INTO brands (id, name, slug) VALUES
  ('b1000000-0000-0000-0000-000000000031', 'Dark Labs',              'dark-labs'),
  ('b1000000-0000-0000-0000-000000000032', 'Condemned Labz',         'condemned-labz'),
  ('b1000000-0000-0000-0000-000000000033', 'Hi-Tech Pharmaceuticals','hi-tech-pharmaceuticals'),
  ('b1000000-0000-0000-0000-000000000034', 'Inspired Nutraceuticals','inspired-nutraceuticals'),
  ('b1000000-0000-0000-0000-000000000035', 'Nutricost',              'nutricost')
ON CONFLICT DO NOTHING;

-- =============================================================================
-- SECTION 2: New Products
-- =============================================================================
INSERT INTO products (id, brand_id, category_id, name, slug, caffeine_mg, citrulline_g, beta_alanine_g, price_per_serving, servings_per_container, is_approved) VALUES

  -- ── Dark Labs (brand b31) ─────────────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000092', 'b1000000-0000-0000-0000-000000000031', 'c1000000-0000-0000-0000-000000000001',
   'Crack', 'dark-labs-crack', 400, 6.0, 3.2, 2.50, 25, true),
  ('a1000000-0000-0000-0000-000000000093', 'b1000000-0000-0000-0000-000000000031', 'c1000000-0000-0000-0000-000000000001',
   'Crack Gold', 'dark-labs-crack-gold', 500, 8.0, 3.2, 3.00, 20, true),

  -- ── Condemned Labz (brand b32) ────────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000094', 'b1000000-0000-0000-0000-000000000032', 'c1000000-0000-0000-0000-000000000001',
   'Convict', 'condemned-convict', 300, 4.0, 3.2, 1.67, 30, true),
  ('a1000000-0000-0000-0000-000000000095', 'b1000000-0000-0000-0000-000000000032', 'c1000000-0000-0000-0000-000000000001',
   'Convict Stim-Free', 'condemned-convict-stim-free', 0, 6.0, 0, 1.50, 30, true),

  -- ── Hi-Tech Pharmaceuticals (brand b33) ───────────────────────────────────
  ('a1000000-0000-0000-0000-000000000096', 'b1000000-0000-0000-0000-000000000033', 'c1000000-0000-0000-0000-000000000001',
   'Jack''d Up', 'hi-tech-jackd-up', 300, 0, 0, 1.00, 45, true),
  ('a1000000-0000-0000-0000-000000000097', 'b1000000-0000-0000-0000-000000000033', 'c1000000-0000-0000-0000-000000000001',
   'Jack3d', 'hi-tech-jack3d', 150, 0, 0, 0.83, 45, true),

  -- ── Inspired Nutraceuticals (brand b34) ───────────────────────────────────
  ('a1000000-0000-0000-0000-000000000098', 'b1000000-0000-0000-0000-000000000034', 'c1000000-0000-0000-0000-000000000001',
   'DVST8 OF THE UNION', 'inspired-dvst8-of-the-union', 300, 6.0, 3.2, 2.00, 30, true),
  ('a1000000-0000-0000-0000-000000000099', 'b1000000-0000-0000-0000-000000000034', 'c1000000-0000-0000-0000-000000000001',
   'DVST8 BBD', 'inspired-dvst8-bbd', 350, 8.0, 3.2, 2.50, 20, true),

  -- ── Nutricost (brand b35) ─────────────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000100', 'b1000000-0000-0000-0000-000000000035', 'c1000000-0000-0000-0000-000000000001',
   'Pre-Workout Complex', 'nutricost-pre-workout', 200, 0, 1.5, 0.50, 30, true)

ON CONFLICT DO NOTHING;

-- =============================================================================
-- SECTION 3: Region + Stim Type
-- =============================================================================
-- Dark Labs
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000092'; -- Crack
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000093'; -- Crack Gold
-- Condemned Labz
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000094'; -- Convict
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim-free' WHERE id = 'a1000000-0000-0000-0000-000000000095'; -- Convict SF
-- Hi-Tech Pharmaceuticals
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000096'; -- Jack'd Up
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000097'; -- Jack3d
-- Inspired Nutraceuticals
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000098'; -- DVST8 OF THE UNION
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000099'; -- DVST8 BBD
-- Nutricost
UPDATE products SET region = ARRAY['US','EU'], stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000100'; -- Pre-Workout Complex

-- =============================================================================
-- SECTION 4: Flavors
-- =============================================================================
INSERT INTO flavors (id, product_id, name, slug) VALUES

  -- Dark Labs Crack (a92)
  ('f1000000-0000-0000-0000-000000000262', 'a1000000-0000-0000-0000-000000000092', 'Cherry Cola',         'crack-cherry-cola'),
  ('f1000000-0000-0000-0000-000000000263', 'a1000000-0000-0000-0000-000000000092', 'Lychee',              'crack-lychee'),
  ('f1000000-0000-0000-0000-000000000264', 'a1000000-0000-0000-0000-000000000092', 'Mango',               'crack-mango'),

  -- Dark Labs Crack Gold (a93)
  ('f1000000-0000-0000-0000-000000000265', 'a1000000-0000-0000-0000-000000000093', 'Watermelon',          'crack-gold-watermelon'),
  ('f1000000-0000-0000-0000-000000000266', 'a1000000-0000-0000-0000-000000000093', 'Strawberry Lemonade', 'crack-gold-strawberry-lemonade'),

  -- Condemned Convict (a94)
  ('f1000000-0000-0000-0000-000000000267', 'a1000000-0000-0000-0000-000000000094', 'Blue Raspberry',      'convict-blue-raspberry'),
  ('f1000000-0000-0000-0000-000000000268', 'a1000000-0000-0000-0000-000000000094', 'Fruit Punch',         'convict-fruit-punch'),
  ('f1000000-0000-0000-0000-000000000269', 'a1000000-0000-0000-0000-000000000094', 'Watermelon',          'convict-watermelon'),

  -- Condemned Convict Stim-Free (a95)
  ('f1000000-0000-0000-0000-000000000270', 'a1000000-0000-0000-0000-000000000095', 'Strawberry Kiwi',     'convict-sf-strawberry-kiwi'),
  ('f1000000-0000-0000-0000-000000000271', 'a1000000-0000-0000-0000-000000000095', 'Lemonade',            'convict-sf-lemonade'),

  -- Hi-Tech Jack'd Up (a96)
  ('f1000000-0000-0000-0000-000000000272', 'a1000000-0000-0000-0000-000000000096', 'Fruit Punch',         'jackd-up-fruit-punch'),
  ('f1000000-0000-0000-0000-000000000273', 'a1000000-0000-0000-0000-000000000096', 'Blue Raspberry',      'jackd-up-blue-raspberry'),
  ('f1000000-0000-0000-0000-000000000274', 'a1000000-0000-0000-0000-000000000096', 'Watermelon',          'jackd-up-watermelon'),

  -- Hi-Tech Jack3d (a97)
  ('f1000000-0000-0000-0000-000000000275', 'a1000000-0000-0000-0000-000000000097', 'Fruit Punch',         'jack3d-fruit-punch'),
  ('f1000000-0000-0000-0000-000000000276', 'a1000000-0000-0000-0000-000000000097', 'Grape Bubblegum',     'jack3d-grape-bubblegum'),

  -- Inspired DVST8 OF THE UNION (a98)
  ('f1000000-0000-0000-0000-000000000277', 'a1000000-0000-0000-0000-000000000098', 'Freedom Rings',       'dvst8-union-freedom-rings'),
  ('f1000000-0000-0000-0000-000000000278', 'a1000000-0000-0000-0000-000000000098', 'Purple Rain',         'dvst8-union-purple-rain'),
  ('f1000000-0000-0000-0000-000000000279', 'a1000000-0000-0000-0000-000000000098', 'Miami Ice',           'dvst8-union-miami-ice'),

  -- Inspired DVST8 BBD (a99)
  ('f1000000-0000-0000-0000-000000000280', 'a1000000-0000-0000-0000-000000000099', 'Black Cherry',        'dvst8-bbd-black-cherry'),
  ('f1000000-0000-0000-0000-000000000281', 'a1000000-0000-0000-0000-000000000099', 'Peach Mango',         'dvst8-bbd-peach-mango'),

  -- Nutricost Pre-Workout (a100)
  ('f1000000-0000-0000-0000-000000000282', 'a1000000-0000-0000-0000-000000000100', 'Fruit Punch',         'nutricost-pre-fruit-punch'),
  ('f1000000-0000-0000-0000-000000000283', 'a1000000-0000-0000-0000-000000000100', 'Blue Raspberry',      'nutricost-pre-blue-raspberry'),
  ('f1000000-0000-0000-0000-000000000284', 'a1000000-0000-0000-0000-000000000100', 'Watermelon',          'nutricost-pre-watermelon')

ON CONFLICT DO NOTHING;

COMMIT;

-- =============================================================================
-- Summary
-- Brands added:    5  (Dark Labs, Condemned Labz, Hi-Tech Pharmaceuticals, Inspired Nutraceuticals, Nutricost)
-- Products added:  9  (a92–a100)
-- Flavors added:  23  (f262–f284)
-- Next batch starts:
--   Brands:   b1000000-0000-0000-0000-000000000036
--   Products: a1000000-0000-0000-0000-000000000101
--   Flavors:  f1000000-0000-0000-0000-000000000285
-- =============================================================================

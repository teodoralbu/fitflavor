-- =============================================================================
-- GymTaste — Seed Expansion Batch 3: Underground & Mid-Tier
-- Run AFTER seed_expansion_batch2.sql
-- Safe to re-run: all inserts use ON CONFLICT DO NOTHING
-- Brands:   b1000000-...-000000000021 → 000000000025
-- Products: a1000000-...-000000000071 → 000000000082
-- Flavors:  f1000000-...-000000000210 → 000000000240
-- =============================================================================

BEGIN;

-- =============================================================================
-- SECTION 1: New Brands
-- =============================================================================
INSERT INTO brands (id, name, slug) VALUES
  ('b1000000-0000-0000-0000-000000000021', 'Axe & Sledge',      'axe-and-sledge'),
  ('b1000000-0000-0000-0000-000000000022', 'Huge Supplements',  'huge-supplements'),
  ('b1000000-0000-0000-0000-000000000023', 'Jacked Factory',    'jacked-factory'),
  ('b1000000-0000-0000-0000-000000000024', 'Pro Supps',         'pro-supps'),
  ('b1000000-0000-0000-0000-000000000025', 'Universal Nutrition','universal-nutrition')
ON CONFLICT DO NOTHING;

-- =============================================================================
-- SECTION 2: New Products
-- =============================================================================
INSERT INTO products (id, brand_id, category_id, name, slug, caffeine_mg, citrulline_g, beta_alanine_g, price_per_serving, servings_per_container, is_approved) VALUES

  -- ── Axe & Sledge (brand b21) ──────────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000071', 'b1000000-0000-0000-0000-000000000021', 'c1000000-0000-0000-0000-000000000001',
   'Seventh Gear', 'axe-sledge-seventh-gear', 350, 6.0, 3.2, 2.00, 20, true),
  ('a1000000-0000-0000-0000-000000000072', 'b1000000-0000-0000-0000-000000000021', 'c1000000-0000-0000-0000-000000000001',
   'Hydraulic', 'axe-sledge-hydraulic', 0, 6.0, 0, 1.50, 30, true),
  ('a1000000-0000-0000-0000-000000000073', 'b1000000-0000-0000-0000-000000000021', 'c1000000-0000-0000-0000-000000000001',
   'Demo Day', 'axe-sledge-demo-day', 150, 4.0, 1.6, 1.25, 30, true),

  -- ── Huge Supplements (brand b22) ──────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000074', 'b1000000-0000-0000-0000-000000000022', 'c1000000-0000-0000-0000-000000000001',
   'Wrecked', 'huge-wrecked', 250, 9.0, 3.5, 1.67, 40, true),
  ('a1000000-0000-0000-0000-000000000075', 'b1000000-0000-0000-0000-000000000022', 'c1000000-0000-0000-0000-000000000001',
   'Wrecked Enraged', 'huge-wrecked-enraged', 400, 9.0, 3.5, 2.00, 25, true),
  ('a1000000-0000-0000-0000-000000000076', 'b1000000-0000-0000-0000-000000000022', 'c1000000-0000-0000-0000-000000000001',
   'Pump Serum', 'huge-pump-serum', 0, 8.0, 0, 1.50, 40, true),

  -- ── Jacked Factory (brand b23) ────────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000077', 'b1000000-0000-0000-0000-000000000023', 'c1000000-0000-0000-0000-000000000001',
   'Altius', 'jacked-factory-altius', 325, 8.0, 4.0, 1.50, 20, true),
  ('a1000000-0000-0000-0000-000000000078', 'b1000000-0000-0000-0000-000000000023', 'c1000000-0000-0000-0000-000000000001',
   'Build-XT', 'jacked-factory-build-xt', 0, 5.0, 0, 1.00, 30, true),

  -- ── Pro Supps (brand b24) ─────────────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000079', 'b1000000-0000-0000-0000-000000000024', 'c1000000-0000-0000-0000-000000000001',
   'Mr. Hyde Signature', 'pro-supps-mr-hyde-signature', 420, 0, 2.5, 1.17, 30, true),
  ('a1000000-0000-0000-0000-000000000080', 'b1000000-0000-0000-0000-000000000024', 'c1000000-0000-0000-0000-000000000001',
   'Mr. Hyde NITRO X', 'pro-supps-mr-hyde-nitro-x', 300, 0, 2.5, 1.00, 30, true),

  -- ── Universal Nutrition (brand b25) ───────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000081', 'b1000000-0000-0000-0000-000000000025', 'c1000000-0000-0000-0000-000000000001',
   'Animal Fury', 'universal-animal-fury', 350, 6.0, 2.0, 1.67, 20, true),
  ('a1000000-0000-0000-0000-000000000082', 'b1000000-0000-0000-0000-000000000025', 'c1000000-0000-0000-0000-000000000001',
   'Animal Pump Pro', 'universal-animal-pump-pro', 0, 8.0, 0, 1.50, 20, true)

ON CONFLICT DO NOTHING;

-- =============================================================================
-- SECTION 3: Region + Stim Type
-- =============================================================================
-- Axe & Sledge
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000071'; -- Seventh Gear
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim-free' WHERE id = 'a1000000-0000-0000-0000-000000000072'; -- Hydraulic
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000073'; -- Demo Day
-- Huge Supplements
UPDATE products SET region = ARRAY['US','EU'], stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000074'; -- Wrecked
UPDATE products SET region = ARRAY['US','EU'], stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000075'; -- Wrecked Enraged
UPDATE products SET region = ARRAY['US','EU'], stim_type = 'stim-free' WHERE id = 'a1000000-0000-0000-0000-000000000076'; -- Pump Serum
-- Jacked Factory
UPDATE products SET region = ARRAY['US','EU'], stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000077'; -- Altius
UPDATE products SET region = ARRAY['US','EU'], stim_type = 'stim-free' WHERE id = 'a1000000-0000-0000-0000-000000000078'; -- Build-XT
-- Pro Supps
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000079'; -- Mr. Hyde Signature
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000080'; -- Mr. Hyde NITRO X
-- Universal Nutrition
UPDATE products SET region = ARRAY['US','EU'], stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000081'; -- Animal Fury
UPDATE products SET region = ARRAY['US','EU'], stim_type = 'stim-free' WHERE id = 'a1000000-0000-0000-0000-000000000082'; -- Animal Pump Pro

-- =============================================================================
-- SECTION 4: Flavors
-- =============================================================================
INSERT INTO flavors (id, product_id, name, slug) VALUES

  -- Seventh Gear (a71)
  ('f1000000-0000-0000-0000-000000000210', 'a1000000-0000-0000-0000-000000000071', 'Margarita',           'seventh-gear-margarita'),
  ('f1000000-0000-0000-0000-000000000211', 'a1000000-0000-0000-0000-000000000071', 'Raspberry Lemonade',  'seventh-gear-raspberry-lemonade'),
  ('f1000000-0000-0000-0000-000000000212', 'a1000000-0000-0000-0000-000000000071', 'Strawberry Lemonade', 'seventh-gear-strawberry-lemonade'),

  -- Hydraulic (a72)
  ('f1000000-0000-0000-0000-000000000213', 'a1000000-0000-0000-0000-000000000072', 'Raspberry Lemonade',  'hydraulic-raspberry-lemonade'),
  ('f1000000-0000-0000-0000-000000000214', 'a1000000-0000-0000-0000-000000000072', 'Pineapple Colada',    'hydraulic-pineapple-colada'),
  ('f1000000-0000-0000-0000-000000000215', 'a1000000-0000-0000-0000-000000000072', 'Sour Gummy',          'hydraulic-sour-gummy'),

  -- Demo Day (a73)
  ('f1000000-0000-0000-0000-000000000216', 'a1000000-0000-0000-0000-000000000073', 'Strawberry Lemonade', 'demo-day-strawberry-lemonade'),
  ('f1000000-0000-0000-0000-000000000217', 'a1000000-0000-0000-0000-000000000073', 'Blue Raspberry',      'demo-day-blue-raspberry'),

  -- Wrecked (a74)
  ('f1000000-0000-0000-0000-000000000218', 'a1000000-0000-0000-0000-000000000074', 'Bomb Popsicle',       'wrecked-bomb-popsicle'),
  ('f1000000-0000-0000-0000-000000000219', 'a1000000-0000-0000-0000-000000000074', 'Peach Rings',         'wrecked-peach-rings'),
  ('f1000000-0000-0000-0000-000000000220', 'a1000000-0000-0000-0000-000000000074', 'Raspberry Lemonade',  'wrecked-raspberry-lemonade'),
  ('f1000000-0000-0000-0000-000000000221', 'a1000000-0000-0000-0000-000000000074', 'Orange Burst',        'wrecked-orange-burst'),

  -- Wrecked Enraged (a75)
  ('f1000000-0000-0000-0000-000000000222', 'a1000000-0000-0000-0000-000000000075', 'Bomb Popsicle',       'wrecked-enraged-bomb-popsicle'),
  ('f1000000-0000-0000-0000-000000000223', 'a1000000-0000-0000-0000-000000000075', 'Peach Rings',         'wrecked-enraged-peach-rings'),

  -- Pump Serum (a76)
  ('f1000000-0000-0000-0000-000000000224', 'a1000000-0000-0000-0000-000000000076', 'Rainbow Candy',       'pump-serum-rainbow-candy'),
  ('f1000000-0000-0000-0000-000000000225', 'a1000000-0000-0000-0000-000000000076', 'Peach Rings',         'pump-serum-peach-rings'),

  -- Altius (a77)
  ('f1000000-0000-0000-0000-000000000226', 'a1000000-0000-0000-0000-000000000077', 'Blue Raspberry',      'altius-blue-raspberry'),
  ('f1000000-0000-0000-0000-000000000227', 'a1000000-0000-0000-0000-000000000077', 'Fruit Punch',         'altius-fruit-punch'),
  ('f1000000-0000-0000-0000-000000000228', 'a1000000-0000-0000-0000-000000000077', 'Cherry Limeade',      'altius-cherry-limeade'),

  -- Build-XT (a78)
  ('f1000000-0000-0000-0000-000000000229', 'a1000000-0000-0000-0000-000000000078', 'Fruit Punch',         'build-xt-fruit-punch'),
  ('f1000000-0000-0000-0000-000000000230', 'a1000000-0000-0000-0000-000000000078', 'Watermelon',          'build-xt-watermelon'),

  -- Mr. Hyde Signature (a79)
  ('f1000000-0000-0000-0000-000000000231', 'a1000000-0000-0000-0000-000000000079', 'Blue Raspberry',      'mr-hyde-sig-blue-raspberry'),
  ('f1000000-0000-0000-0000-000000000232', 'a1000000-0000-0000-0000-000000000079', 'Green Apple',         'mr-hyde-sig-green-apple'),
  ('f1000000-0000-0000-0000-000000000233', 'a1000000-0000-0000-0000-000000000079', 'Fruit Punch',         'mr-hyde-sig-fruit-punch'),

  -- Mr. Hyde NITRO X (a80)
  ('f1000000-0000-0000-0000-000000000234', 'a1000000-0000-0000-0000-000000000080', 'Blue Raspberry',      'mr-hyde-nitrox-blue-raspberry'),
  ('f1000000-0000-0000-0000-000000000235', 'a1000000-0000-0000-0000-000000000080', 'Watermelon',          'mr-hyde-nitrox-watermelon'),

  -- Animal Fury (a81)
  ('f1000000-0000-0000-0000-000000000236', 'a1000000-0000-0000-0000-000000000081', 'Watermelon',          'animal-fury-watermelon'),
  ('f1000000-0000-0000-0000-000000000237', 'a1000000-0000-0000-0000-000000000081', 'Blue Raspberry',      'animal-fury-blue-raspberry'),
  ('f1000000-0000-0000-0000-000000000238', 'a1000000-0000-0000-0000-000000000081', 'Strawberry Lemonade', 'animal-fury-strawberry-lemonade'),

  -- Animal Pump Pro (a82)
  ('f1000000-0000-0000-0000-000000000239', 'a1000000-0000-0000-0000-000000000082', 'Watermelon',          'animal-pump-pro-watermelon'),
  ('f1000000-0000-0000-0000-000000000240', 'a1000000-0000-0000-0000-000000000082', 'Orange',              'animal-pump-pro-orange')

ON CONFLICT DO NOTHING;

COMMIT;

-- =============================================================================
-- Summary
-- Brands added:    5  (Axe & Sledge, Huge Supplements, Jacked Factory, Pro Supps, Universal Nutrition)
-- Products added: 12  (a71–a82)
-- Flavors added:  31  (f210–f240)
-- Next batch starts:
--   Brands:   b1000000-0000-0000-0000-000000000026
--   Products: a1000000-0000-0000-0000-000000000083
--   Flavors:  f1000000-0000-0000-0000-000000000241
-- =============================================================================

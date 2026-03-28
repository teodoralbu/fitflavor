-- =============================================================================
-- GymTaste — Seed Expansion Batch 2: More Mainstream US
-- Run AFTER seed_expansion_batch1.sql
-- Safe to re-run: all inserts use ON CONFLICT DO NOTHING
-- Brands:   b1000000-...-000000000016 → 000000000020
-- Products: a1000000-...-000000000059 → 000000000069
-- Flavors:  f1000000-...-000000000174 → 000000000203
-- =============================================================================

BEGIN;

-- =============================================================================
-- SECTION 1: New Brands
-- =============================================================================
INSERT INTO brands (id, name, slug) VALUES
  ('b1000000-0000-0000-0000-000000000016', 'Redcon1',      'redcon1'),
  ('b1000000-0000-0000-0000-000000000017', 'NutraBio',     'nutrabio'),
  ('b1000000-0000-0000-0000-000000000018', '1st Phorm',    '1st-phorm'),
  ('b1000000-0000-0000-0000-000000000019', 'GAT Sport',    'gat-sport'),
  ('b1000000-0000-0000-0000-000000000020', 'Alpha Lion',   'alpha-lion')
ON CONFLICT DO NOTHING;

-- =============================================================================
-- SECTION 2: New Products
-- =============================================================================
INSERT INTO products (id, brand_id, category_id, name, slug, caffeine_mg, citrulline_g, beta_alanine_g, price_per_serving, servings_per_container, is_approved) VALUES

  -- ── Redcon1 (brand b16) ───────────────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000059', 'b1000000-0000-0000-0000-000000000016', 'c1000000-0000-0000-0000-000000000001',
   'Total War', 'redcon1-total-war', 320, 6.0, 3.2, 1.50, 30, true),
  ('a1000000-0000-0000-0000-000000000060', 'b1000000-0000-0000-0000-000000000016', 'c1000000-0000-0000-0000-000000000001',
   'Big Noise', 'redcon1-big-noise', 0, 4.0, 0, 1.25, 30, true),
  ('a1000000-0000-0000-0000-000000000061', 'b1000000-0000-0000-0000-000000000016', 'c1000000-0000-0000-0000-000000000001',
   'Double Tap', 'redcon1-double-tap', 200, 0, 0, 1.33, 30, true),

  -- ── NutraBio (brand b17) ──────────────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000062', 'b1000000-0000-0000-0000-000000000017', 'c1000000-0000-0000-0000-000000000001',
   'PRE', 'nutrabio-pre', 325, 8.0, 2.0, 1.83, 20, true),
  ('a1000000-0000-0000-0000-000000000063', 'b1000000-0000-0000-0000-000000000017', 'c1000000-0000-0000-0000-000000000001',
   'PRE Stim-Free', 'nutrabio-pre-stim-free', 0, 8.0, 2.0, 1.67, 20, true),

  -- ── 1st Phorm (brand b18) ─────────────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000064', 'b1000000-0000-0000-0000-000000000018', 'c1000000-0000-0000-0000-000000000001',
   'Project-1', '1st-phorm-project-1', 250, 6.0, 3.2, 2.00, 20, true),
  ('a1000000-0000-0000-0000-000000000065', 'b1000000-0000-0000-0000-000000000018', 'c1000000-0000-0000-0000-000000000001',
   'Megawatt V2', '1st-phorm-megawatt-v2', 300, 0, 3.2, 1.67, 20, true),

  -- ── GAT Sport (brand b19) ─────────────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000066', 'b1000000-0000-0000-0000-000000000019', 'c1000000-0000-0000-0000-000000000001',
   'Nitraflex', 'gat-nitraflex', 325, 0, 2.5, 0.83, 30, true),
  ('a1000000-0000-0000-0000-000000000067', 'b1000000-0000-0000-0000-000000000019', 'c1000000-0000-0000-0000-000000000001',
   'Nitraflex Advanced', 'gat-nitraflex-advanced', 350, 5.0, 3.2, 1.33, 30, true),

  -- ── Alpha Lion (brand b20) ────────────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000068', 'b1000000-0000-0000-0000-000000000020', 'c1000000-0000-0000-0000-000000000001',
   'Superhuman Supreme', 'alpha-lion-superhuman-supreme', 400, 6.0, 3.2, 2.00, 21, true),
  ('a1000000-0000-0000-0000-000000000069', 'b1000000-0000-0000-0000-000000000020', 'c1000000-0000-0000-0000-000000000001',
   'Superhuman', 'alpha-lion-superhuman', 300, 4.0, 3.2, 1.67, 21, true),
  ('a1000000-0000-0000-0000-000000000070', 'b1000000-0000-0000-0000-000000000020', 'c1000000-0000-0000-0000-000000000001',
   'Superhuman Pump', 'alpha-lion-superhuman-pump', 0, 8.0, 0, 1.67, 21, true)

ON CONFLICT DO NOTHING;

-- =============================================================================
-- SECTION 3: Region + Stim Type
-- =============================================================================
-- Redcon1
UPDATE products SET region = ARRAY['US','EU'], stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000059'; -- Total War
UPDATE products SET region = ARRAY['US','EU'], stim_type = 'stim-free' WHERE id = 'a1000000-0000-0000-0000-000000000060'; -- Big Noise
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000061'; -- Double Tap
-- NutraBio
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000062'; -- PRE
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim-free' WHERE id = 'a1000000-0000-0000-0000-000000000063'; -- PRE Stim-Free
-- 1st Phorm
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000064'; -- Project-1
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000065'; -- Megawatt V2
-- GAT Sport
UPDATE products SET region = ARRAY['US','EU'], stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000066'; -- Nitraflex
UPDATE products SET region = ARRAY['US','EU'], stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000067'; -- Nitraflex Advanced
-- Alpha Lion
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000068'; -- Superhuman Supreme
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000069'; -- Superhuman
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim-free' WHERE id = 'a1000000-0000-0000-0000-000000000070'; -- Superhuman Pump

-- =============================================================================
-- SECTION 4: Flavors
-- =============================================================================
INSERT INTO flavors (id, product_id, name, slug) VALUES

  -- Total War (a59)
  ('f1000000-0000-0000-0000-000000000174', 'a1000000-0000-0000-0000-000000000059', 'Blue Lemonade',       'total-war-blue-lemonade'),
  ('f1000000-0000-0000-0000-000000000175', 'a1000000-0000-0000-0000-000000000059', 'Sour Gummy Bear',     'total-war-sour-gummy-bear'),
  ('f1000000-0000-0000-0000-000000000176', 'a1000000-0000-0000-0000-000000000059', 'Watermelon',          'total-war-watermelon'),
  ('f1000000-0000-0000-0000-000000000177', 'a1000000-0000-0000-0000-000000000059', 'Strawberry Kiwi',     'total-war-strawberry-kiwi'),
  ('f1000000-0000-0000-0000-000000000178', 'a1000000-0000-0000-0000-000000000059', 'Pineapple Juice',     'total-war-pineapple-juice'),

  -- Big Noise (a60)
  ('f1000000-0000-0000-0000-000000000179', 'a1000000-0000-0000-0000-000000000060', 'Strawberry Kiwi',     'big-noise-strawberry-kiwi'),
  ('f1000000-0000-0000-0000-000000000180', 'a1000000-0000-0000-0000-000000000060', 'Pineapple Mango',     'big-noise-pineapple-mango'),
  ('f1000000-0000-0000-0000-000000000181', 'a1000000-0000-0000-0000-000000000060', 'Watermelon',          'big-noise-watermelon'),

  -- Double Tap (a61)
  ('f1000000-0000-0000-0000-000000000182', 'a1000000-0000-0000-0000-000000000061', 'Watermelon',          'double-tap-watermelon'),
  ('f1000000-0000-0000-0000-000000000183', 'a1000000-0000-0000-0000-000000000061', 'Blue Raspberry',      'double-tap-blue-raspberry'),
  ('f1000000-0000-0000-0000-000000000184', 'a1000000-0000-0000-0000-000000000061', 'Strawberry Mango',    'double-tap-strawberry-mango'),

  -- NutraBio PRE (a62)
  ('f1000000-0000-0000-0000-000000000185', 'a1000000-0000-0000-0000-000000000062', 'Strawberry Kiwi',     'nutrabio-pre-strawberry-kiwi'),
  ('f1000000-0000-0000-0000-000000000186', 'a1000000-0000-0000-0000-000000000062', 'Green Apple',         'nutrabio-pre-green-apple'),
  ('f1000000-0000-0000-0000-000000000187', 'a1000000-0000-0000-0000-000000000062', 'Blue Raspberry',      'nutrabio-pre-blue-raspberry'),
  ('f1000000-0000-0000-0000-000000000188', 'a1000000-0000-0000-0000-000000000062', 'Fruit Punch',         'nutrabio-pre-fruit-punch'),

  -- NutraBio PRE Stim-Free (a63)
  ('f1000000-0000-0000-0000-000000000189', 'a1000000-0000-0000-0000-000000000063', 'Strawberry Kiwi',     'nutrabio-pre-sf-strawberry-kiwi'),
  ('f1000000-0000-0000-0000-000000000190', 'a1000000-0000-0000-0000-000000000063', 'Blue Raspberry',      'nutrabio-pre-sf-blue-raspberry'),

  -- 1st Phorm Project-1 (a64)
  ('f1000000-0000-0000-0000-000000000191', 'a1000000-0000-0000-0000-000000000064', 'Lemon Drop',          '1st-phorm-project1-lemon-drop'),
  ('f1000000-0000-0000-0000-000000000192', 'a1000000-0000-0000-0000-000000000064', 'Blueberry Lemonade',  '1st-phorm-project1-blueberry-lemonade'),
  ('f1000000-0000-0000-0000-000000000193', 'a1000000-0000-0000-0000-000000000064', 'Strawberry Watermelon','1st-phorm-project1-strawberry-watermelon'),

  -- 1st Phorm Megawatt V2 (a65)
  ('f1000000-0000-0000-0000-000000000194', 'a1000000-0000-0000-0000-000000000065', 'Cherry Limeade',      '1st-phorm-megawatt-cherry-limeade'),
  ('f1000000-0000-0000-0000-000000000195', 'a1000000-0000-0000-0000-000000000065', 'Fruit Punch',         '1st-phorm-megawatt-fruit-punch'),

  -- GAT Nitraflex (a66)
  ('f1000000-0000-0000-0000-000000000196', 'a1000000-0000-0000-0000-000000000066', 'Fruit Punch',         'gat-nitraflex-fruit-punch'),
  ('f1000000-0000-0000-0000-000000000197', 'a1000000-0000-0000-0000-000000000066', 'Blue Raspberry',      'gat-nitraflex-blue-raspberry'),
  ('f1000000-0000-0000-0000-000000000198', 'a1000000-0000-0000-0000-000000000066', 'Watermelon',          'gat-nitraflex-watermelon'),
  ('f1000000-0000-0000-0000-000000000199', 'a1000000-0000-0000-0000-000000000066', 'Pineapple',           'gat-nitraflex-pineapple'),

  -- GAT Nitraflex Advanced (a67)
  ('f1000000-0000-0000-0000-000000000200', 'a1000000-0000-0000-0000-000000000067', 'Blue Raspberry',      'gat-nitraflex-adv-blue-raspberry'),
  ('f1000000-0000-0000-0000-000000000201', 'a1000000-0000-0000-0000-000000000067', 'Fruit Punch',         'gat-nitraflex-adv-fruit-punch'),

  -- Alpha Lion Superhuman Supreme (a68)
  ('f1000000-0000-0000-0000-000000000202', 'a1000000-0000-0000-0000-000000000068', 'Miami Vice',          'superhuman-supreme-miami-vice'),
  ('f1000000-0000-0000-0000-000000000203', 'a1000000-0000-0000-0000-000000000068', 'Witch Lemonade',      'superhuman-supreme-witch-lemonade'),
  ('f1000000-0000-0000-0000-000000000204', 'a1000000-0000-0000-0000-000000000068', 'Cotton Candy Grape',  'superhuman-supreme-cotton-candy-grape'),

  -- Alpha Lion Superhuman (a69)
  ('f1000000-0000-0000-0000-000000000205', 'a1000000-0000-0000-0000-000000000069', 'Miami Vice',          'superhuman-miami-vice'),
  ('f1000000-0000-0000-0000-000000000206', 'a1000000-0000-0000-0000-000000000069', 'Witch Lemonade',      'superhuman-witch-lemonade'),
  ('f1000000-0000-0000-0000-000000000207', 'a1000000-0000-0000-0000-000000000069', 'Lemon Mango Hustle',  'superhuman-lemon-mango-hustle'),

  -- Alpha Lion Superhuman Pump (a70)
  ('f1000000-0000-0000-0000-000000000208', 'a1000000-0000-0000-0000-000000000070', 'Miami Vice',          'superhuman-pump-miami-vice'),
  ('f1000000-0000-0000-0000-000000000209', 'a1000000-0000-0000-0000-000000000070', 'Tropical Hustle',     'superhuman-pump-tropical-hustle')

ON CONFLICT DO NOTHING;

COMMIT;

-- =============================================================================
-- Summary
-- Brands added:    5  (Redcon1, NutraBio, 1st Phorm, GAT Sport, Alpha Lion)
-- Products added: 12  (a59–a70)
-- Flavors added:  36  (f174–f209)
-- Next batch starts:
--   Brands:   b1000000-0000-0000-0000-000000000021
--   Products: a1000000-0000-0000-0000-000000000071
--   Flavors:  f1000000-0000-0000-0000-000000000210
-- =============================================================================

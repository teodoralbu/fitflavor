-- =============================================================================
-- GymTaste — Seed Expansion Batch 7 (Final): EU/Global + Remaining US/AU/CA
-- Run AFTER seed_expansion_batch6.sql
-- Safe to re-run: all inserts use ON CONFLICT DO NOTHING
-- Brands:   b1000000-...-000000000041 → 000000000060
-- Products: a1000000-...-000000000111 → 000000000139
-- Flavors:  f1000000-...-000000000308 → 000000000369
-- =============================================================================

BEGIN;

-- =============================================================================
-- SECTION 1: New Brands
-- =============================================================================
INSERT INTO brands (id, name, slug) VALUES
  ('b1000000-0000-0000-0000-000000000041', 'Myprotein',           'myprotein'),
  ('b1000000-0000-0000-0000-000000000042', 'Applied Nutrition',   'applied-nutrition'),
  ('b1000000-0000-0000-0000-000000000043', 'Grenade',             'grenade'),
  ('b1000000-0000-0000-0000-000000000044', 'Bulk Powders',        'bulk-powders'),
  ('b1000000-0000-0000-0000-000000000045', 'PhD Nutrition',       'phd-nutrition'),
  ('b1000000-0000-0000-0000-000000000046', 'Reflex Nutrition',    'reflex-nutrition'),
  ('b1000000-0000-0000-0000-000000000047', 'PEScience',           'pescience'),
  ('b1000000-0000-0000-0000-000000000048', 'Dymatize',            'dymatize'),
  ('b1000000-0000-0000-0000-000000000049', 'Scivation',           'scivation'),
  ('b1000000-0000-0000-0000-000000000050', 'VMI Sports',          'vmi-sports'),
  ('b1000000-0000-0000-0000-000000000051', 'Betancourt Nutrition','betancourt-nutrition'),
  ('b1000000-0000-0000-0000-000000000052', 'Controlled Labs',     'controlled-labs'),
  ('b1000000-0000-0000-0000-000000000053', 'Rivalus',             'rivalus'),
  ('b1000000-0000-0000-0000-000000000054', 'Pre Lab Pro',         'pre-lab-pro'),
  ('b1000000-0000-0000-0000-000000000055', 'Rule 1',              'rule-1'),
  ('b1000000-0000-0000-0000-000000000056', 'EHP Labs',            'ehp-labs'),
  ('b1000000-0000-0000-0000-000000000057', 'Faction Labs',        'faction-labs'),
  ('b1000000-0000-0000-0000-000000000058', 'Allmax Nutrition',    'allmax-nutrition'),
  ('b1000000-0000-0000-0000-000000000059', 'Magnum Nutraceuticals','magnum-nutraceuticals'),
  ('b1000000-0000-0000-0000-000000000060', 'Scitec Nutrition',    'scitec-nutrition')
ON CONFLICT DO NOTHING;

-- =============================================================================
-- SECTION 2: New Products
-- =============================================================================
INSERT INTO products (id, brand_id, category_id, name, slug, caffeine_mg, citrulline_g, beta_alanine_g, price_per_serving, servings_per_container, is_approved) VALUES

  -- ── Myprotein (brand b41) ─────────────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000111', 'b1000000-0000-0000-0000-000000000041', 'c1000000-0000-0000-0000-000000000001',
   'THE Pre-Workout', 'myprotein-the-pre-workout', 200, 4.0, 1.6, 1.00, 30, true),
  ('a1000000-0000-0000-0000-000000000112', 'b1000000-0000-0000-0000-000000000041', 'c1000000-0000-0000-0000-000000000001',
   'THE Pre-Workout Advanced', 'myprotein-the-pre-workout-advanced', 250, 6.0, 3.2, 1.33, 20, true),

  -- ── Applied Nutrition (brand b42) ────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000113', 'b1000000-0000-0000-0000-000000000042', 'c1000000-0000-0000-0000-000000000001',
   'ABE Pre-Workout', 'applied-abe', 200, 0, 1.6, 1.00, 30, true),
  ('a1000000-0000-0000-0000-000000000114', 'b1000000-0000-0000-0000-000000000042', 'c1000000-0000-0000-0000-000000000001',
   'ABE Ultimate Pre-Workout', 'applied-abe-ultimate', 250, 4.0, 3.2, 1.33, 30, true),

  -- ── Grenade (brand b43) ───────────────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000115', 'b1000000-0000-0000-0000-000000000043', 'c1000000-0000-0000-0000-000000000001',
   '.50 Calibre', 'grenade-50-calibre', 200, 0, 1.6, 1.17, 50, true),

  -- ── Bulk Powders (brand b44) ──────────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000116', 'b1000000-0000-0000-0000-000000000044', 'c1000000-0000-0000-0000-000000000001',
   'Complete Pre-Workout', 'bulk-powders-complete-pre', 200, 0, 1.6, 0.83, 30, true),
  ('a1000000-0000-0000-0000-000000000117', 'b1000000-0000-0000-0000-000000000044', 'c1000000-0000-0000-0000-000000000001',
   'Informed Pre-Workout+', 'bulk-powders-informed-pre', 175, 4.0, 1.6, 1.00, 20, true),

  -- ── PhD Nutrition (brand b45) ─────────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000118', 'b1000000-0000-0000-0000-000000000045', 'c1000000-0000-0000-0000-000000000001',
   'Pre-Workout', 'phd-pre-workout', 200, 0, 1.6, 1.17, 20, true),

  -- ── Reflex Nutrition (brand b46) ──────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000119', 'b1000000-0000-0000-0000-000000000046', 'c1000000-0000-0000-0000-000000000001',
   'Instant Pre-Workout', 'reflex-instant-pre', 200, 0, 1.6, 1.00, 20, true),

  -- ── PEScience (brand b47) ─────────────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000120', 'b1000000-0000-0000-0000-000000000047', 'c1000000-0000-0000-0000-000000000001',
   'Prolific', 'pescience-prolific', 200, 4.5, 1.6, 1.67, 40, true),
  ('a1000000-0000-0000-0000-000000000121', 'b1000000-0000-0000-0000-000000000047', 'c1000000-0000-0000-0000-000000000001',
   'High Volume', 'pescience-high-volume', 0, 4.0, 0, 1.33, 25, true),

  -- ── Dymatize (brand b48) ──────────────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000122', 'b1000000-0000-0000-0000-000000000048', 'c1000000-0000-0000-0000-000000000001',
   'Pre W.O.', 'dymatize-pre-wo', 300, 0, 3.2, 1.33, 30, true),

  -- ── Scivation (brand b49) ─────────────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000123', 'b1000000-0000-0000-0000-000000000049', 'c1000000-0000-0000-0000-000000000001',
   'Xtend Sport', 'scivation-xtend-sport', 100, 0, 0, 0.83, 30, true),

  -- ── VMI Sports (brand b50) ────────────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000124', 'b1000000-0000-0000-0000-000000000050', 'c1000000-0000-0000-0000-000000000001',
   'K-XR', 'vmi-k-xr', 300, 6.0, 3.2, 1.67, 30, true),
  ('a1000000-0000-0000-0000-000000000125', 'b1000000-0000-0000-0000-000000000050', 'c1000000-0000-0000-0000-000000000001',
   'Barbarian', 'vmi-barbarian', 400, 8.0, 3.2, 2.00, 25, true),

  -- ── Betancourt Nutrition (brand b51) ──────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000126', 'b1000000-0000-0000-0000-000000000051', 'c1000000-0000-0000-0000-000000000001',
   'B-Nox Androrush', 'betancourt-b-nox', 220, 0, 1.6, 1.00, 35, true),

  -- ── Controlled Labs (brand b52) ───────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000127', 'b1000000-0000-0000-0000-000000000052', 'c1000000-0000-0000-0000-000000000001',
   'White Rapids', 'controlled-labs-white-rapids', 200, 0, 0, 1.00, 30, true),
  ('a1000000-0000-0000-0000-000000000128', 'b1000000-0000-0000-0000-000000000052', 'c1000000-0000-0000-0000-000000000001',
   'Orange Brainwash', 'controlled-labs-orange-brainwash', 200, 4.0, 0, 1.33, 30, true),

  -- ── Rivalus (brand b53) ───────────────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000129', 'b1000000-0000-0000-0000-000000000053', 'c1000000-0000-0000-0000-000000000001',
   'Encharge', 'rivalus-encharge', 225, 0, 1.6, 1.17, 30, true),

  -- ── Pre Lab Pro (brand b54) ───────────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000130', 'b1000000-0000-0000-0000-000000000054', 'c1000000-0000-0000-0000-000000000001',
   'Pre Lab Pro', 'pre-lab-pro', 200, 6.0, 0, 2.33, 20, true),

  -- ── Rule 1 (brand b55) ────────────────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000131', 'b1000000-0000-0000-0000-000000000055', 'c1000000-0000-0000-0000-000000000001',
   'R1 Pre-Workout', 'rule1-r1-pre', 200, 0, 1.6, 1.00, 30, true),
  ('a1000000-0000-0000-0000-000000000132', 'b1000000-0000-0000-0000-000000000055', 'c1000000-0000-0000-0000-000000000001',
   'R1 Train All Day', 'rule1-r1-train-all-day', 125, 0, 0, 0.83, 30, true),

  -- ── EHP Labs (brand b56) ──────────────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000133', 'b1000000-0000-0000-0000-000000000056', 'c1000000-0000-0000-0000-000000000001',
   'OxyShred', 'ehp-oxyshred', 150, 0, 0, 1.17, 60, true),
  ('a1000000-0000-0000-0000-000000000134', 'b1000000-0000-0000-0000-000000000056', 'c1000000-0000-0000-0000-000000000001',
   'Blessed Pre-Workout', 'ehp-blessed-pre', 200, 4.0, 0, 1.50, 25, true),

  -- ── Faction Labs (brand b57) ──────────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000135', 'b1000000-0000-0000-0000-000000000057', 'c1000000-0000-0000-0000-000000000001',
   'Deficit', 'faction-labs-deficit', 300, 6.0, 3.2, 1.67, 30, true),

  -- ── Allmax Nutrition (brand b58) ──────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000136', 'b1000000-0000-0000-0000-000000000058', 'c1000000-0000-0000-0000-000000000001',
   'Razor8 Blast Powder', 'allmax-razor8', 350, 0, 1.6, 1.33, 20, true),
  ('a1000000-0000-0000-0000-000000000137', 'b1000000-0000-0000-0000-000000000058', 'c1000000-0000-0000-0000-000000000001',
   'IMPACT Igniter', 'allmax-impact-igniter', 200, 4.0, 1.6, 1.17, 30, true),

  -- ── Magnum Nutraceuticals (brand b59) ─────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000138', 'b1000000-0000-0000-0000-000000000059', 'c1000000-0000-0000-0000-000000000001',
   'Opus', 'magnum-opus', 200, 0, 1.6, 1.50, 20, true),

  -- ── Scitec Nutrition (brand b60) ──────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000139', 'b1000000-0000-0000-0000-000000000060', 'c1000000-0000-0000-0000-000000000001',
   'Hot Blood Hardcore', 'scitec-hot-blood-hardcore', 200, 0, 3.2, 0.83, 25, true)

ON CONFLICT DO NOTHING;

-- =============================================================================
-- SECTION 3: Region + Stim Type
-- =============================================================================
-- Myprotein
UPDATE products SET region = ARRAY['US','EU'], stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000111'; -- THE Pre-Workout
UPDATE products SET region = ARRAY['US','EU'], stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000112'; -- THE Pre-Workout Advanced
-- Applied Nutrition
UPDATE products SET region = ARRAY['EU'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000113'; -- ABE
UPDATE products SET region = ARRAY['EU'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000114'; -- ABE Ultimate
-- Grenade
UPDATE products SET region = ARRAY['EU'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000115'; -- .50 Calibre
-- Bulk Powders
UPDATE products SET region = ARRAY['EU'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000116'; -- Complete Pre-Workout
UPDATE products SET region = ARRAY['EU'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000117'; -- Informed Pre-Workout+
-- PhD Nutrition
UPDATE products SET region = ARRAY['EU'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000118'; -- Pre-Workout
-- Reflex Nutrition
UPDATE products SET region = ARRAY['EU'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000119'; -- Instant Pre-Workout
-- PEScience
UPDATE products SET region = ARRAY['US','EU'], stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000120'; -- Prolific
UPDATE products SET region = ARRAY['US','EU'], stim_type = 'stim-free' WHERE id = 'a1000000-0000-0000-0000-000000000121'; -- High Volume
-- Dymatize
UPDATE products SET region = ARRAY['US','EU'], stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000122'; -- Pre W.O.
-- Scivation
UPDATE products SET region = ARRAY['US','EU'], stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000123'; -- Xtend Sport
-- VMI Sports
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000124'; -- K-XR
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000125'; -- Barbarian
-- Betancourt Nutrition
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000126'; -- B-Nox
-- Controlled Labs
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000127'; -- White Rapids
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000128'; -- Orange Brainwash
-- Rivalus
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000129'; -- Encharge
-- Pre Lab Pro
UPDATE products SET region = ARRAY['EU'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000130'; -- Pre Lab Pro
-- Rule 1
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000131'; -- R1 Pre-Workout
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000132'; -- R1 Train All Day
-- EHP Labs
UPDATE products SET region = ARRAY['US','EU'], stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000133'; -- OxyShred
UPDATE products SET region = ARRAY['US','EU'], stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000134'; -- Blessed Pre
-- Faction Labs
UPDATE products SET region = ARRAY['US','EU'], stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000135'; -- Deficit
-- Allmax Nutrition
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000136'; -- Razor8
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000137'; -- IMPACT Igniter
-- Magnum Nutraceuticals
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000138'; -- Opus
-- Scitec Nutrition
UPDATE products SET region = ARRAY['EU'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000139'; -- Hot Blood Hardcore

-- =============================================================================
-- SECTION 4: Flavors
-- =============================================================================
INSERT INTO flavors (id, product_id, name, slug) VALUES

  -- Myprotein THE Pre-Workout (a111)
  ('f1000000-0000-0000-0000-000000000308', 'a1000000-0000-0000-0000-000000000111', 'Blue Raspberry',       'myp-pre-blue-raspberry'),
  ('f1000000-0000-0000-0000-000000000309', 'a1000000-0000-0000-0000-000000000111', 'Watermelon',           'myp-pre-watermelon'),

  -- Myprotein THE Pre-Workout Advanced (a112)
  ('f1000000-0000-0000-0000-000000000310', 'a1000000-0000-0000-0000-000000000112', 'Cherry Bomb',          'myp-pre-adv-cherry-bomb'),
  ('f1000000-0000-0000-0000-000000000311', 'a1000000-0000-0000-0000-000000000112', 'Pink Lemonade',        'myp-pre-adv-pink-lemonade'),

  -- Applied Nutrition ABE (a113)
  ('f1000000-0000-0000-0000-000000000312', 'a1000000-0000-0000-0000-000000000113', 'Blue Raspberry',       'abe-blue-raspberry'),
  ('f1000000-0000-0000-0000-000000000313', 'a1000000-0000-0000-0000-000000000113', 'Fruit Punch',          'abe-fruit-punch'),
  ('f1000000-0000-0000-0000-000000000314', 'a1000000-0000-0000-0000-000000000113', 'Tropical',             'abe-tropical'),

  -- Applied Nutrition ABE Ultimate (a114)
  ('f1000000-0000-0000-0000-000000000315', 'a1000000-0000-0000-0000-000000000114', 'Watermelon',           'abe-ultimate-watermelon'),
  ('f1000000-0000-0000-0000-000000000316', 'a1000000-0000-0000-0000-000000000114', 'Sour Apple',           'abe-ultimate-sour-apple'),

  -- Grenade .50 Calibre (a115)
  ('f1000000-0000-0000-0000-000000000317', 'a1000000-0000-0000-0000-000000000115', 'Berry Blast',          'grenade-50cal-berry-blast'),
  ('f1000000-0000-0000-0000-000000000318', 'a1000000-0000-0000-0000-000000000115', 'Killa Cola',           'grenade-50cal-killa-cola'),
  ('f1000000-0000-0000-0000-000000000319', 'a1000000-0000-0000-0000-000000000115', 'Tropical',             'grenade-50cal-tropical'),

  -- Bulk Powders Complete Pre (a116)
  ('f1000000-0000-0000-0000-000000000320', 'a1000000-0000-0000-0000-000000000116', 'Blue Raspberry',       'bulk-complete-pre-blue-raspberry'),
  ('f1000000-0000-0000-0000-000000000321', 'a1000000-0000-0000-0000-000000000116', 'Watermelon',           'bulk-complete-pre-watermelon'),

  -- Bulk Powders Informed Pre+ (a117)
  ('f1000000-0000-0000-0000-000000000322', 'a1000000-0000-0000-0000-000000000117', 'Fruit Punch',          'bulk-informed-pre-fruit-punch'),
  ('f1000000-0000-0000-0000-000000000323', 'a1000000-0000-0000-0000-000000000117', 'Berry',                'bulk-informed-pre-berry'),

  -- PhD Nutrition Pre-Workout (a118)
  ('f1000000-0000-0000-0000-000000000324', 'a1000000-0000-0000-0000-000000000118', 'Blue Raspberry',       'phd-pre-blue-raspberry'),
  ('f1000000-0000-0000-0000-000000000325', 'a1000000-0000-0000-0000-000000000118', 'Tropical',             'phd-pre-tropical'),

  -- Reflex Instant Pre-Workout (a119)
  ('f1000000-0000-0000-0000-000000000326', 'a1000000-0000-0000-0000-000000000119', 'Fruit Punch',          'reflex-pre-fruit-punch'),
  ('f1000000-0000-0000-0000-000000000327', 'a1000000-0000-0000-0000-000000000119', 'Berry',                'reflex-pre-berry'),

  -- PEScience Prolific (a120)
  ('f1000000-0000-0000-0000-000000000328', 'a1000000-0000-0000-0000-000000000120', 'Peach Rings',          'prolific-peach-rings'),
  ('f1000000-0000-0000-0000-000000000329', 'a1000000-0000-0000-0000-000000000120', 'Cotton Candy',         'prolific-cotton-candy'),
  ('f1000000-0000-0000-0000-000000000330', 'a1000000-0000-0000-0000-000000000120', 'Blue Slushie',         'prolific-blue-slushie'),

  -- PEScience High Volume (a121)
  ('f1000000-0000-0000-0000-000000000331', 'a1000000-0000-0000-0000-000000000121', 'Sour Green Apple',     'high-volume-sour-green-apple'),
  ('f1000000-0000-0000-0000-000000000332', 'a1000000-0000-0000-0000-000000000121', 'Tropical Twist',       'high-volume-tropical-twist'),

  -- Dymatize Pre W.O. (a122)
  ('f1000000-0000-0000-0000-000000000333', 'a1000000-0000-0000-0000-000000000122', 'Blue Raspberry',       'dymatize-pre-wo-blue-raspberry'),
  ('f1000000-0000-0000-0000-000000000334', 'a1000000-0000-0000-0000-000000000122', 'Fruit Punch',          'dymatize-pre-wo-fruit-punch'),

  -- Scivation Xtend Sport (a123)
  ('f1000000-0000-0000-0000-000000000335', 'a1000000-0000-0000-0000-000000000123', 'Watermelon',           'xtend-sport-watermelon'),
  ('f1000000-0000-0000-0000-000000000336', 'a1000000-0000-0000-0000-000000000123', 'Lemon Lime',           'xtend-sport-lemon-lime'),

  -- VMI K-XR (a124)
  ('f1000000-0000-0000-0000-000000000337', 'a1000000-0000-0000-0000-000000000124', 'Lemon Lime Twist',     'vmi-kxr-lemon-lime-twist'),
  ('f1000000-0000-0000-0000-000000000338', 'a1000000-0000-0000-0000-000000000124', 'Mango Sunrise',        'vmi-kxr-mango-sunrise'),

  -- VMI Barbarian (a125)
  ('f1000000-0000-0000-0000-000000000339', 'a1000000-0000-0000-0000-000000000125', 'Blue Raspberry',       'vmi-barbarian-blue-raspberry'),
  ('f1000000-0000-0000-0000-000000000340', 'a1000000-0000-0000-0000-000000000125', 'Strawberry Watermelon','vmi-barbarian-strawberry-watermelon'),

  -- Betancourt B-Nox (a126)
  ('f1000000-0000-0000-0000-000000000341', 'a1000000-0000-0000-0000-000000000126', 'Fruit Punch',          'b-nox-fruit-punch'),
  ('f1000000-0000-0000-0000-000000000342', 'a1000000-0000-0000-0000-000000000126', 'Watermelon',           'b-nox-watermelon'),

  -- Controlled Labs White Rapids (a127)
  ('f1000000-0000-0000-0000-000000000343', 'a1000000-0000-0000-0000-000000000127', 'Watermelon Candy',     'white-rapids-watermelon-candy'),
  ('f1000000-0000-0000-0000-000000000344', 'a1000000-0000-0000-0000-000000000127', 'Blue Raspberry',       'white-rapids-blue-raspberry'),

  -- Controlled Labs Orange Brainwash (a128)
  ('f1000000-0000-0000-0000-000000000345', 'a1000000-0000-0000-0000-000000000128', 'Orange Creamsicle',    'orange-brainwash-orange-creamsicle'),
  ('f1000000-0000-0000-0000-000000000346', 'a1000000-0000-0000-0000-000000000128', 'Mango Peach',          'orange-brainwash-mango-peach'),

  -- Rivalus Encharge (a129)
  ('f1000000-0000-0000-0000-000000000347', 'a1000000-0000-0000-0000-000000000129', 'Blue Raspberry',       'encharge-blue-raspberry'),
  ('f1000000-0000-0000-0000-000000000348', 'a1000000-0000-0000-0000-000000000129', 'Fruit Punch',          'encharge-fruit-punch'),

  -- Pre Lab Pro (a130)
  ('f1000000-0000-0000-0000-000000000349', 'a1000000-0000-0000-0000-000000000130', 'Natural Berry',        'pre-lab-pro-natural-berry'),
  ('f1000000-0000-0000-0000-000000000350', 'a1000000-0000-0000-0000-000000000130', 'Natural Tropical',     'pre-lab-pro-natural-tropical'),

  -- Rule 1 R1 Pre (a131)
  ('f1000000-0000-0000-0000-000000000351', 'a1000000-0000-0000-0000-000000000131', 'Blue Raspberry',       'r1-pre-blue-raspberry'),
  ('f1000000-0000-0000-0000-000000000352', 'a1000000-0000-0000-0000-000000000131', 'Fruit Punch',          'r1-pre-fruit-punch'),

  -- Rule 1 R1 Train All Day (a132)
  ('f1000000-0000-0000-0000-000000000353', 'a1000000-0000-0000-0000-000000000132', 'Watermelon',           'r1-train-watermelon'),
  ('f1000000-0000-0000-0000-000000000354', 'a1000000-0000-0000-0000-000000000132', 'Tropical',             'r1-train-tropical'),

  -- EHP Labs OxyShred (a133)
  ('f1000000-0000-0000-0000-000000000355', 'a1000000-0000-0000-0000-000000000133', 'Guava Paradise',       'oxyshred-guava-paradise'),
  ('f1000000-0000-0000-0000-000000000356', 'a1000000-0000-0000-0000-000000000133', 'Wild Melon',           'oxyshred-wild-melon'),
  ('f1000000-0000-0000-0000-000000000357', 'a1000000-0000-0000-0000-000000000133', 'Passionfruit',         'oxyshred-passionfruit'),

  -- EHP Labs Blessed Pre (a134)
  ('f1000000-0000-0000-0000-000000000358', 'a1000000-0000-0000-0000-000000000134', 'Strawberry Kiwi',      'blessed-pre-strawberry-kiwi'),
  ('f1000000-0000-0000-0000-000000000359', 'a1000000-0000-0000-0000-000000000134', 'Pineapple Mango',      'blessed-pre-pineapple-mango'),

  -- Faction Labs Deficit (a135)
  ('f1000000-0000-0000-0000-000000000360', 'a1000000-0000-0000-0000-000000000135', 'Raspberry Lemonade',   'deficit-raspberry-lemonade'),
  ('f1000000-0000-0000-0000-000000000361', 'a1000000-0000-0000-0000-000000000135', 'Peach Mango',          'deficit-peach-mango'),

  -- Allmax Razor8 (a136)
  ('f1000000-0000-0000-0000-000000000362', 'a1000000-0000-0000-0000-000000000136', 'Fruit Punch',          'razor8-fruit-punch'),
  ('f1000000-0000-0000-0000-000000000363', 'a1000000-0000-0000-0000-000000000136', 'Grape',                'razor8-grape'),

  -- Allmax IMPACT Igniter (a137)
  ('f1000000-0000-0000-0000-000000000364', 'a1000000-0000-0000-0000-000000000137', 'Watermelon',           'impact-igniter-watermelon'),
  ('f1000000-0000-0000-0000-000000000365', 'a1000000-0000-0000-0000-000000000137', 'Blue Raspberry',       'impact-igniter-blue-raspberry'),

  -- Magnum Opus (a138)
  ('f1000000-0000-0000-0000-000000000366', 'a1000000-0000-0000-0000-000000000138', 'Fruit Punch',          'magnum-opus-fruit-punch'),
  ('f1000000-0000-0000-0000-000000000367', 'a1000000-0000-0000-0000-000000000138', 'Strawberry Lemonade',  'magnum-opus-strawberry-lemonade'),

  -- Scitec Hot Blood Hardcore (a139)
  ('f1000000-0000-0000-0000-000000000368', 'a1000000-0000-0000-0000-000000000139', 'Fruit Punch',          'hot-blood-fruit-punch'),
  ('f1000000-0000-0000-0000-000000000369', 'a1000000-0000-0000-0000-000000000139', 'Orange',               'hot-blood-orange')

ON CONFLICT DO NOTHING;

COMMIT;

-- =============================================================================
-- Summary
-- Brands added:   20  (Myprotein, Applied Nutrition, Grenade, Bulk Powders, PhD Nutrition,
--                      Reflex Nutrition, PEScience, Dymatize, Scivation, VMI Sports,
--                      Betancourt Nutrition, Controlled Labs, Rivalus, Pre Lab Pro, Rule 1,
--                      EHP Labs, Faction Labs, Allmax Nutrition, Magnum Nutraceuticals, Scitec Nutrition)
-- Products added: 29  (a111–a139)
-- Flavors added:  62  (f308–f369)
-- =============================================================================
-- GRAND TOTAL ACROSS ALL BATCHES (seed.sql + batches 1–7):
--   Brands:   60
--   Products: 139
--   Flavors:  369
-- =============================================================================

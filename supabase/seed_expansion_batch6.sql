-- =============================================================================
-- GymTaste — Seed Expansion Batch 6: Hardcore & Mid-Market
-- Run AFTER seed_expansion_batch5.sql
-- Safe to re-run: all inserts use ON CONFLICT DO NOTHING
-- Brands:   b1000000-...-000000000036 → 000000000040
-- Products: a1000000-...-000000000101 → 000000000110
-- Flavors:  f1000000-...-000000000285 → 000000000307
-- =============================================================================

BEGIN;

-- =============================================================================
-- SECTION 1: New Brands
-- =============================================================================
INSERT INTO brands (id, name, slug) VALUES
  ('b1000000-0000-0000-0000-000000000036', 'Chaos and Pain',   'chaos-and-pain'),
  ('b1000000-0000-0000-0000-000000000037', 'Blackstone Labs',  'blackstone-labs'),
  ('b1000000-0000-0000-0000-000000000038', 'RSP Nutrition',    'rsp-nutrition'),
  ('b1000000-0000-0000-0000-000000000039', 'MAN Sports',       'man-sports'),
  ('b1000000-0000-0000-0000-000000000040', 'BPI Sports',       'bpi-sports')
ON CONFLICT DO NOTHING;

-- =============================================================================
-- SECTION 2: New Products
-- =============================================================================
INSERT INTO products (id, brand_id, category_id, name, slug, caffeine_mg, citrulline_g, beta_alanine_g, price_per_serving, servings_per_container, is_approved) VALUES

  -- ── Chaos and Pain (brand b36) ────────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000101', 'b1000000-0000-0000-0000-000000000036', 'c1000000-0000-0000-0000-000000000001',
   'Cannibal Ferox', 'chaos-cannibal-ferox', 400, 4.0, 3.2, 2.00, 25, true),
  ('a1000000-0000-0000-0000-000000000102', 'b1000000-0000-0000-0000-000000000036', 'c1000000-0000-0000-0000-000000000001',
   'Cannibal Riot', 'chaos-cannibal-riot', 300, 6.0, 3.2, 1.83, 25, true),

  -- ── Blackstone Labs (brand b37) ───────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000103', 'b1000000-0000-0000-0000-000000000037', 'c1000000-0000-0000-0000-000000000001',
   'Dust X', 'blackstone-dust-x', 400, 6.0, 3.2, 2.00, 25, true),
  ('a1000000-0000-0000-0000-000000000104', 'b1000000-0000-0000-0000-000000000037', 'c1000000-0000-0000-0000-000000000001',
   'Dust Extreme', 'blackstone-dust-extreme', 500, 8.0, 3.2, 2.50, 20, true),
  ('a1000000-0000-0000-0000-000000000105', 'b1000000-0000-0000-0000-000000000037', 'c1000000-0000-0000-0000-000000000001',
   'Dust Pump', 'blackstone-dust-pump', 0, 8.0, 0, 1.50, 25, true),

  -- ── RSP Nutrition (brand b38) ─────────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000106', 'b1000000-0000-0000-0000-000000000038', 'c1000000-0000-0000-0000-000000000001',
   'AminoLean', 'rsp-aminolean', 125, 0, 0, 0.83, 30, true),
  ('a1000000-0000-0000-0000-000000000107', 'b1000000-0000-0000-0000-000000000038', 'c1000000-0000-0000-0000-000000000001',
   'Pump Boost', 'rsp-pump-boost', 0, 4.0, 0, 1.00, 30, true),

  -- ── MAN Sports (brand b39) ────────────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000108', 'b1000000-0000-0000-0000-000000000039', 'c1000000-0000-0000-0000-000000000001',
   'Game Day', 'man-sports-game-day', 300, 6.0, 3.2, 1.50, 25, true),

  -- ── BPI Sports (brand b40) ────────────────────────────────────────────────
  ('a1000000-0000-0000-0000-000000000109', 'b1000000-0000-0000-0000-000000000040', 'c1000000-0000-0000-0000-000000000001',
   '1MR Vortex', 'bpi-1mr-vortex', 200, 0, 1.6, 0.83, 25, true),
  ('a1000000-0000-0000-0000-000000000110', 'b1000000-0000-0000-0000-000000000040', 'c1000000-0000-0000-0000-000000000001',
   'Best Pre Workout', 'bpi-best-pre-workout', 250, 0, 1.6, 1.00, 25, true)

ON CONFLICT DO NOTHING;

-- =============================================================================
-- SECTION 3: Region + Stim Type
-- =============================================================================
-- Chaos and Pain
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000101'; -- Cannibal Ferox
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000102'; -- Cannibal Riot
-- Blackstone Labs
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000103'; -- Dust X
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000104'; -- Dust Extreme
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim-free' WHERE id = 'a1000000-0000-0000-0000-000000000105'; -- Dust Pump
-- RSP Nutrition
UPDATE products SET region = ARRAY['US','EU'], stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000106'; -- AminoLean
UPDATE products SET region = ARRAY['US','EU'], stim_type = 'stim-free' WHERE id = 'a1000000-0000-0000-0000-000000000107'; -- Pump Boost
-- MAN Sports
UPDATE products SET region = ARRAY['US'],      stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000108'; -- Game Day
-- BPI Sports
UPDATE products SET region = ARRAY['US','EU'], stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000109'; -- 1MR Vortex
UPDATE products SET region = ARRAY['US','EU'], stim_type = 'stim'      WHERE id = 'a1000000-0000-0000-0000-000000000110'; -- Best Pre Workout

-- =============================================================================
-- SECTION 4: Flavors
-- =============================================================================
INSERT INTO flavors (id, product_id, name, slug) VALUES

  -- Cannibal Ferox (a101)
  ('f1000000-0000-0000-0000-000000000285', 'a1000000-0000-0000-0000-000000000101', 'Blue Raspberry',      'cannibal-ferox-blue-raspberry'),
  ('f1000000-0000-0000-0000-000000000286', 'a1000000-0000-0000-0000-000000000101', 'Strawberry Lemonade', 'cannibal-ferox-strawberry-lemonade'),

  -- Cannibal Riot (a102)
  ('f1000000-0000-0000-0000-000000000287', 'a1000000-0000-0000-0000-000000000102', 'Peach Mango',         'cannibal-riot-peach-mango'),
  ('f1000000-0000-0000-0000-000000000288', 'a1000000-0000-0000-0000-000000000102', 'Watermelon',          'cannibal-riot-watermelon'),

  -- Dust X (a103)
  ('f1000000-0000-0000-0000-000000000289', 'a1000000-0000-0000-0000-000000000103', 'Strawberry Kiwi',     'dust-x-strawberry-kiwi'),
  ('f1000000-0000-0000-0000-000000000290', 'a1000000-0000-0000-0000-000000000103', 'Peach Rings',         'dust-x-peach-rings'),
  ('f1000000-0000-0000-0000-000000000291', 'a1000000-0000-0000-0000-000000000103', 'Blue Raspberry',      'dust-x-blue-raspberry'),

  -- Dust Extreme (a104)
  ('f1000000-0000-0000-0000-000000000292', 'a1000000-0000-0000-0000-000000000104', 'Sour Gummy Bear',     'dust-extreme-sour-gummy-bear'),
  ('f1000000-0000-0000-0000-000000000293', 'a1000000-0000-0000-0000-000000000104', 'Watermelon',          'dust-extreme-watermelon'),

  -- Dust Pump (a105)
  ('f1000000-0000-0000-0000-000000000294', 'a1000000-0000-0000-0000-000000000105', 'Strawberry Kiwi',     'dust-pump-strawberry-kiwi'),
  ('f1000000-0000-0000-0000-000000000295', 'a1000000-0000-0000-0000-000000000105', 'Lemonade',            'dust-pump-lemonade'),

  -- RSP AminoLean (a106)
  ('f1000000-0000-0000-0000-000000000296', 'a1000000-0000-0000-0000-000000000106', 'Watermelon',          'rsp-aminolean-watermelon'),
  ('f1000000-0000-0000-0000-000000000297', 'a1000000-0000-0000-0000-000000000106', 'Pink Lemonade',       'rsp-aminolean-pink-lemonade'),
  ('f1000000-0000-0000-0000-000000000298', 'a1000000-0000-0000-0000-000000000106', 'Mango',               'rsp-aminolean-mango'),

  -- RSP Pump Boost (a107)
  ('f1000000-0000-0000-0000-000000000299', 'a1000000-0000-0000-0000-000000000107', 'Strawberry Kiwi',     'rsp-pump-boost-strawberry-kiwi'),
  ('f1000000-0000-0000-0000-000000000300', 'a1000000-0000-0000-0000-000000000107', 'Blue Raspberry',      'rsp-pump-boost-blue-raspberry'),

  -- MAN Game Day (a108)
  ('f1000000-0000-0000-0000-000000000301', 'a1000000-0000-0000-0000-000000000108', 'Sour Apple',          'man-game-day-sour-apple'),
  ('f1000000-0000-0000-0000-000000000302', 'a1000000-0000-0000-0000-000000000108', 'Orange Mango',        'man-game-day-orange-mango'),
  ('f1000000-0000-0000-0000-000000000303', 'a1000000-0000-0000-0000-000000000108', 'Blue Raspberry',      'man-game-day-blue-raspberry'),

  -- BPI 1MR Vortex (a109)
  ('f1000000-0000-0000-0000-000000000304', 'a1000000-0000-0000-0000-000000000109', 'Fruit Punch',         'bpi-1mr-fruit-punch'),
  ('f1000000-0000-0000-0000-000000000305', 'a1000000-0000-0000-0000-000000000109', 'Watermelon',          'bpi-1mr-watermelon'),

  -- BPI Best Pre Workout (a110)
  ('f1000000-0000-0000-0000-000000000306', 'a1000000-0000-0000-0000-000000000110', 'Blue Raspberry',      'bpi-best-pre-blue-raspberry'),
  ('f1000000-0000-0000-0000-000000000307', 'a1000000-0000-0000-0000-000000000110', 'Fruit Punch',         'bpi-best-pre-fruit-punch')

ON CONFLICT DO NOTHING;

COMMIT;

-- =============================================================================
-- Summary
-- Brands added:    5  (Chaos and Pain, Blackstone Labs, RSP Nutrition, MAN Sports, BPI Sports)
-- Products added: 10  (a101–a110)
-- Flavors added:  23  (f285–f307)
-- Next batch starts:
--   Brands:   b1000000-0000-0000-0000-000000000041
--   Products: a1000000-0000-0000-0000-000000000111
--   Flavors:  f1000000-0000-0000-0000-000000000308
-- =============================================================================

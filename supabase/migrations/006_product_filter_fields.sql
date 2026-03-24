-- =============================================================================
-- Migration 006: Product filter fields — region & stim_type
-- =============================================================================

ALTER TABLE products
  ADD COLUMN IF NOT EXISTS region TEXT[] DEFAULT '{}' NOT NULL,
  ADD COLUMN IF NOT EXISTS stim_type TEXT CHECK (stim_type IN ('stim', 'stim-free'));

-- Back-fill stim_type from caffeine_mg for existing rows
UPDATE products SET stim_type = CASE
  WHEN caffeine_mg IS NOT NULL AND caffeine_mg = 0 THEN 'stim-free'
  WHEN caffeine_mg IS NOT NULL AND caffeine_mg > 0  THEN 'stim'
  ELSE NULL
END
WHERE stim_type IS NULL;

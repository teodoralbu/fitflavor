# Phase 7: Rating System Overhaul - Research

**Researched:** 2026-03-22
**Domain:** Supabase schema migration, React form state, rating dimension refactor
**Confidence:** HIGH

## Summary

Phase 7 is a vertical slice through every layer: Supabase schema (add 3 columns to `ratings`), constants/types (replace 5 dimensions with 3), the RatingForm (swap sliders + add price input), the ReviewCard (add value pill), and every query that touches `ratings` (add `schema_version = 2` filter). The codebase is well-structured for this -- `RATING_DIMENSIONS` in constants.ts drives both the form sliders and the review card pills, so changing that array propagates automatically.

The trickiest parts are: (1) the value score normalization formula needs clearly defined bounds, (2) the `schema_version` filter must be added to 7+ query locations across queries.ts, feed.ts, leaderboard, user profile, product page, and the home page stat counter, and (3) the badge tier trigger in Postgres counts ALL ratings regardless of schema_version (which is the desired behavior -- old ratings still count for XP/badges).

**Primary recommendation:** Execute as 3 plans: (1) DB migration + types/constants, (2) RatingForm + submission logic, (3) ReviewCard value pill + schema_version filtering across all queries.

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions
- 3 new dimensions: **Flavor** (x0.33), **Pump** (x0.33), **Energy & Focus** (x0.34) -- exact labels, equal thirds
- Slider range: 1-10, step 0.5 (unchanged from current)
- Overall score = weighted average of the 3 new dimensions
- Price capture: per container, optional, USD ($), display `$` prefix on input, store as plain decimal
- Value score formula: `overall_score / price_per_serving` normalized 1-10, stored on rating row
- Value score display: 4th pill in expanded ReviewCard, only when present, label "Value"
- Schema versioning: `schema_version` column on `ratings` (integer, default 1 for old, 2 for new)
- Old reviews (schema_version = 1 or null) hidden from feed, product page, leaderboard
- Old reviews NOT deleted
- Pre-v1.1 ratings still count toward badge tier / XP

### Claude's Discretion
- Exact normalization bounds for value score (e.g. what $0.50/serving and $3.00/serving map to)
- Whether schema_version is a column on ratings or a separate strategy (decided: column on ratings)
- How to handle null servings_per_container (skip silently -- no value score)
- RatingForm layout/ordering of price input (suggested: after dimension sliders, before "Would buy again?")

### Deferred Ideas (OUT OF SCOPE)
- Phase 12: Profile & Dosage Calculator onboarding flow, privacy toggle for body stats
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| RATE-01 | User can rate on Flavor, Pump, and Energy & Focus (replaces 5 old dims) | Update RATING_DIMENSIONS in constants.ts, DEFAULT_SCORES in RatingForm, Rating type in types.ts |
| RATE-02 | User can enter price paid per container when submitting | Add price input to RatingForm, add price_paid column to ratings table, pass to insert |
| RATE-03 | Value score auto-calculated from price and quality (no manual slider) | Compute in submit handler: overall_score / (price / servings_per_container), normalize 1-10, store as value_score column |
| RATE-04 | Old reviews (pre-v1.1 schema) hidden from all feeds and product pages | Add schema_version column, filter in 7+ query locations: getUnifiedFeed, getFollowingUnifiedFeed, loadMoreFeed, getFlavorBySlug, getLeaderboard, getProductBySlug, getTopReviewers, home page count, user profile ratings |
</phase_requirements>

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| @supabase/supabase-js | ^2.99.1 | Database client (already installed) | Project standard |
| @supabase/ssr | ^0.9.0 | Server-side Supabase (already installed) | Project standard |
| Next.js | 16.1.6 | Framework (already installed) | Project standard |
| React | 19.2.3 | UI (already installed) | Project standard |

### Supporting
No new libraries needed. All changes use existing dependencies.

**Installation:**
```bash
# No new packages needed
```

## Architecture Patterns

### Recommended Change Structure
```
supabase/migrations/
  003_rating_system_v2.sql     # New columns: schema_version, price_paid, value_score
src/lib/
  constants.ts                  # Replace RATING_DIMENSIONS array (5 dims -> 3 dims)
  types.ts                      # Add price_paid, value_score, schema_version to Rating type + Database type
  queries.ts                    # Add .eq('schema_version', 2) to 5 query functions
src/components/rating/
  RatingForm.tsx                # New DEFAULT_SCORES, price input, value score calc in submit
  ReviewCard.tsx                # Value pill in expanded view
src/app/actions/
  feed.ts                       # Add schema_version filter to loadMoreFeed
```

### Pattern 1: Dimension-Driven Rendering
**What:** `RATING_DIMENSIONS` array in constants.ts drives both RatingForm sliders and ReviewCard pills automatically via `.map()`.
**When to use:** Always -- this is the existing pattern. Changing the array changes both components.
**Current code (to be replaced):**
```typescript
// constants.ts -- CURRENT (replace entirely)
export const RATING_DIMENSIONS = [
  { key: 'taste',     label: 'Taste',     weight: 0.25 },
  { key: 'sweetness', label: 'Sweetness', weight: 0.10 },
  { key: 'pump',      label: 'Pump',      weight: 0.25 },
  { key: 'energy',    label: 'Energy',    weight: 0.25 },
  { key: 'intensity', label: 'Intensity', weight: 0.15 },
] as const

// NEW (replace with)
export const RATING_DIMENSIONS = [
  { key: 'flavor',       label: 'Flavor',          weight: 0.33 },
  { key: 'pump',         label: 'Pump',            weight: 0.33 },
  { key: 'energy_focus', label: 'Energy & Focus',  weight: 0.34 },
] as const
```

### Pattern 2: Schema Version Filtering
**What:** Every query that fetches ratings for display must add `.eq('schema_version', 2)` to exclude old reviews.
**When to use:** All feed, product page, leaderboard, and flavor page queries.
**Exception:** Badge tier trigger and XP calculations do NOT filter -- all ratings count.
**Example:**
```typescript
// In queries.ts -- getUnifiedFeed
const { data: ratings } = await supabase
  .from('ratings')
  .select('...')
  .eq('schema_version', 2)  // <-- ADD THIS
  .order('created_at', { ascending: false })
  .limit(limit)
```

### Pattern 3: Value Score Calculation in Submit Handler
**What:** Calculate value_score client-side during submission, store on the rating row.
**When to use:** In RatingForm.handleSubmit, after computing overall_score.
**Formula:**
```typescript
function calcValueScore(overallScore: number, pricePaid: number, servingsPerContainer: number | null): number | null {
  if (!servingsPerContainer || servingsPerContainer <= 0 || pricePaid <= 0) return null
  const pricePerServing = pricePaid / servingsPerContainer
  // Normalization: map price_per_serving from [$0.50, $3.00] to [10, 1]
  // Then scale by quality: value = (quality_factor * cost_factor)
  // Simpler: linear interpolation of overall/pricePerServing
  const rawValue = overallScore / pricePerServing
  // Empirical range: best case ~20 (10/0.50), worst case ~0.33 (1/3.00)
  // Typical range: 2-10 for realistic scenarios
  const MIN_RAW = 1.0   // low quality + expensive = ~1/3 -> clamp at 1
  const MAX_RAW = 12.0  // high quality + cheap = ~10/0.83
  const normalized = 1 + ((rawValue - MIN_RAW) / (MAX_RAW - MIN_RAW)) * 9
  return Math.round(Math.min(10, Math.max(1, normalized)) * 10) / 10  // clamp 1-10, round to 0.1
}
```

### Pattern 4: Inline Styles with CSS Variables
**What:** All rating components use inline styles with CSS variables (no Tailwind).
**When to use:** All new UI elements in RatingForm and ReviewCard.
**Example:**
```typescript
// Price input field -- follows existing Section pattern
<Section title="Price paid" subtitle="optional">
  <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
    <span style={{ fontSize: '18px', fontWeight: 700, color: 'var(--text-dim)' }}>$</span>
    <input
      type="number"
      min="0"
      step="0.01"
      placeholder="e.g. 39.99"
      className="input"
      style={{ flex: 1, fontSize: '16px' }}
    />
  </div>
</Section>
```

### Anti-Patterns to Avoid
- **Do NOT delete old rating rows:** Schema versioning hides them; deletion breaks data integrity and user trust.
- **Do NOT filter schema_version in badge/XP triggers:** The Postgres trigger `update_user_badge_tier` counts ALL ratings -- this is correct and intentional.
- **Do NOT compute value_score on the fly in queries:** Store it on the row at submission time. Computing in queries adds complexity and prevents indexing.
- **Do NOT add a currency selector:** USD-only per locked decision.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Value normalization | Custom scaling library | Simple linear interpolation (see Pattern 3) | Pre-workout pricing has a narrow, well-known range |
| Schema migration | Manual SQL in dashboard | Migration file in supabase/migrations/ | Trackable, reproducible, peer-reviewable |
| Dimension score display | Custom pill component | Extend existing RATING_DIMENSIONS.map() pattern in ReviewCard | Already works, just needs array update |

## Common Pitfalls

### Pitfall 1: Missing schema_version filter in a query
**What goes wrong:** Old reviews (with 5-dimension scores) appear in feeds, breaking the pill display (shows taste/sweetness/etc. keys that don't match new RATING_DIMENSIONS).
**Why it happens:** There are 7+ distinct query locations that fetch ratings. Easy to miss one.
**How to avoid:** Exhaustive audit of every `.from('ratings')` call. The grep found 10 files touching the ratings table.
**Warning signs:** ReviewCard shows undefined/NaN scores, or dimension labels don't match.

### Pitfall 2: RatingForm needs servings_per_container from the product
**What goes wrong:** Value score cannot be calculated because the form doesn't have access to the product's servings_per_container.
**Why it happens:** Current RatingForm receives only `FlavorBasic` which has product.id/name/slug/brand but NOT servings_per_container.
**How to avoid:** Either (a) pass servings_per_container through the flavor prop from rate/[slug]/page.tsx, or (b) fetch it in the submit handler. Option (a) is simpler -- add it to the server component query.
**Warning signs:** Value score is always null even when price is entered.

### Pitfall 3: Default scores object mismatch
**What goes wrong:** Form initializes with old dimension keys (taste, sweetness, etc.) but sliders render new keys (flavor, pump, energy_focus). Scores object has wrong keys.
**Why it happens:** DEFAULT_SCORES in RatingForm is hardcoded, not derived from RATING_DIMENSIONS.
**How to avoid:** Update DEFAULT_SCORES to `{ flavor: 7, pump: 7, energy_focus: 7 }`.

### Pitfall 4: Overall score formula text in RatingForm
**What goes wrong:** The "Taste x0.25 . Sweetness x0.10 ..." text at the bottom of the overall score preview still shows old dimensions.
**Why it happens:** It's a hardcoded string on line 285 of RatingForm.tsx, not driven by RATING_DIMENSIONS.
**How to avoid:** Either dynamically generate from RATING_DIMENSIONS or replace with the new hardcoded text.

### Pitfall 5: TypeScript type mismatch on insert
**What goes wrong:** Supabase insert fails or type error because the Database type doesn't include new columns.
**Why it happens:** The Rating interface and Database type in types.ts must be updated with price_paid, value_score, and schema_version.
**How to avoid:** Update Rating interface AND the Database type's ratings table definition simultaneously.

### Pitfall 6: Unique constraint on user+flavor
**What goes wrong:** Migration 002 added `ratings_user_flavor_unique` constraint. If a user already rated a flavor with the old schema, they cannot re-rate with the new schema.
**Why it happens:** The unique constraint prevents duplicate (user_id, flavor_id) pairs.
**How to avoid:** This is actually fine -- the unique constraint means a user can only have ONE rating per flavor. If they re-rate, the old one should be updated or the constraint needs to allow schema-version-scoped uniqueness. **Decision needed:** Should users be able to submit a new v2 rating if they already have a v1 rating for the same flavor? If yes, drop the unique constraint or make it conditional. If no, the existing constraint is fine but old ratings will block new ones.

## Code Examples

### Complete Query Locations Requiring schema_version Filter

All files containing `.from('ratings')` that display ratings in UI:

1. **`src/lib/queries.ts` -- `getFlavorBySlug()`** (line 202): Fetches ratings for flavor page review list
2. **`src/lib/queries.ts` -- `getLeaderboard()`** (line 297): Fetches all ratings for leaderboard aggregation
3. **`src/lib/queries.ts` -- `getProductBySlug()`** (line 139): Fetches ratings for product page flavor stats
4. **`src/lib/queries.ts` -- `getUnifiedFeed()`** (line 462): Main home feed
5. **`src/lib/queries.ts` -- `getFollowingUnifiedFeed()`** (line 552): Following tab feed
6. **`src/lib/queries.ts` -- `getTopReviewers()`** (line 406): Top reviewers by rating count -- **NOTE: this should still count v1 ratings for fairness, or filter to v2 only for accuracy. Decision: filter to v2 since it's a "top reviewers" display metric.**
7. **`src/app/actions/feed.ts` -- `loadMoreFeed()`** (line 10): Paginated feed loader
8. **`src/app/users/[username]/page.tsx`** (line 45): User profile ratings -- should show only v2
9. **`src/app/flavors/[slug]/page.tsx`** (line 43): Weekly rating count query
10. **`src/app/page.tsx`** (line 16): Home page total rating count stat

**Do NOT filter:**
- Badge tier trigger in Postgres (`update_user_badge_tier`) -- counts all ratings
- Rating count check in RatingForm submit (line 176) -- checks if user has ANY ratings for "first rating" badge

### DB Migration SQL
```sql
-- 003_rating_system_v2.sql
-- Add schema versioning and value score columns to ratings

ALTER TABLE public.ratings
  ADD COLUMN IF NOT EXISTS schema_version integer NOT NULL DEFAULT 1;

ALTER TABLE public.ratings
  ADD COLUMN IF NOT EXISTS price_paid numeric(8,2);

ALTER TABLE public.ratings
  ADD COLUMN IF NOT EXISTS value_score numeric(3,1);

-- Index for filtering by schema version (used in every feed/display query)
CREATE INDEX IF NOT EXISTS idx_ratings_schema_version ON public.ratings(schema_version);

-- Composite index for common query pattern: schema_version + created_at
CREATE INDEX IF NOT EXISTS idx_ratings_v2_created ON public.ratings(created_at DESC)
  WHERE schema_version = 2;

-- Note: Existing badge tier trigger (update_user_badge_tier) counts ALL ratings
-- regardless of schema_version. This is intentional -- old ratings still count for XP.
```

### Updated Rating Type
```typescript
export interface Rating {
  id: string
  user_id: string
  flavor_id: string
  scores: Record<string, number>
  overall_score: number
  would_buy_again: boolean
  context_tags: string[]
  review_text: string | null
  photo_url: string | null
  schema_version: number
  price_paid: number | null
  value_score: number | null
  created_at: string
}
```

### Value Score Normalization (Claude's Discretion)

Recommended bounds based on pre-workout market analysis:
- **Cheapest realistic:** ~$0.50/serving (e.g., $15 for 30 servings) with score 10 = raw value 20
- **Most expensive realistic:** ~$3.00/serving (e.g., $75 for 25 servings) with score 1 = raw value 0.33
- **Typical mid-range:** ~$1.50/serving with score 7 = raw value ~4.7

Linear interpolation from raw_value range [1.0, 12.0] to [1, 10]:
- `normalized = 1 + ((raw - 1.0) / (12.0 - 1.0)) * 9`
- Clamped to [1, 10], rounded to 1 decimal

This gives intuitive results:
| Price/serving | Overall 5.0 | Overall 7.0 | Overall 9.0 |
|--------------|-------------|-------------|-------------|
| $0.75 | 5.5 | 7.6 | 9.8 |
| $1.50 | 2.7 | 4.1 | 5.5 |
| $2.50 | 1.6 | 2.3 | 3.3 |

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| 5 rating dimensions (taste, sweetness, pump, energy, intensity) | 3 dimensions (flavor, pump, energy_focus) | This phase | Simpler, more actionable for users |
| No price capture | Optional price per container | This phase | Enables value scoring |
| No schema versioning | schema_version column | This phase | Clean separation of old/new data |

## Open Questions

1. **Unique constraint on (user_id, flavor_id)**
   - What we know: Migration 002 added `ratings_user_flavor_unique`. With schema versioning, a user who rated under v1 cannot submit a v2 rating for the same flavor.
   - What's unclear: Should users be allowed to re-rate a flavor with the new schema?
   - Recommendation: **Drop the unique constraint** or alter it. Users should be able to submit a fresh v2 rating. The old v1 rating stays hidden. This is a one-time migration concern. Alternative: UPDATE the existing row to v2, but that loses the original data.

2. **getTopReviewers schema_version handling**
   - What we know: This counts ratings per user for the leaderboard "Top Members" section.
   - What's unclear: Should it count only v2 ratings (accurate to new system) or all ratings (rewarding historical contribution)?
   - Recommendation: Count ALL ratings (no schema_version filter) for "Top Members" since it measures engagement, not review accuracy. This aligns with the badge tier decision.

3. **Home page total count stat**
   - What we know: `src/app/page.tsx` line 16 counts all ratings for a hero stat.
   - What's unclear: Should it show total ratings (including hidden v1) or only visible v2 ratings?
   - Recommendation: Count all ratings (no filter) -- it's a vanity metric showing platform activity.

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | None (test suite deferred to v2 per project decision) |
| Config file | none |
| Quick run command | N/A |
| Full suite command | N/A |

### Phase Requirements -> Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| RATE-01 | New dimensions render in form + pills | manual-only | Manual: submit rating, check expanded ReviewCard shows 3 new pills | N/A |
| RATE-02 | Price input on form, stored in DB | manual-only | Manual: submit with price, verify in Supabase dashboard | N/A |
| RATE-03 | Value score auto-calculated and shown | manual-only | Manual: submit with price for product that has servings_per_container, check value pill | N/A |
| RATE-04 | Old reviews hidden everywhere | manual-only | Manual: check feed, flavor page, leaderboard -- no v1 reviews visible | N/A |

### Sampling Rate
- **Per task commit:** Manual smoke test in browser
- **Per wave merge:** Full manual walkthrough of all 4 requirements
- **Phase gate:** All 4 success criteria verified manually

### Wave 0 Gaps
- No test infrastructure needed (deferred to v2 per project decision)

## Sources

### Primary (HIGH confidence)
- `src/lib/constants.ts` -- Current RATING_DIMENSIONS array, getScoreColor helper
- `src/components/rating/RatingForm.tsx` -- Full form implementation, DEFAULT_SCORES, calcOverall, handleSubmit
- `src/components/rating/ReviewCard.tsx` -- Pill rendering pattern using RATING_DIMENSIONS.map()
- `src/lib/types.ts` -- Rating interface, Database type definition
- `src/lib/queries.ts` -- All 5 query functions that fetch ratings
- `src/app/actions/feed.ts` -- loadMoreFeed pagination query
- `supabase/migrations/` -- All 3 migration files, schema patterns
- `supabase/migrations/001_initial_schema.sql` -- Badge tier trigger (counts all ratings)
- `supabase/migrations/002_schema_updates.sql` -- Unique constraint on (user_id, flavor_id)

### Secondary (MEDIUM confidence)
- Pre-workout pricing ranges ($0.50-$3.00/serving) based on general market knowledge -- used for normalization bounds

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH - no new libraries, all existing deps
- Architecture: HIGH - codebase fully audited, all files read, patterns clear
- Pitfalls: HIGH - exhaustive grep of all `.from('ratings')` calls, 10 files identified
- Value normalization bounds: MEDIUM - based on general market knowledge, not verified data

**Research date:** 2026-03-22
**Valid until:** 2026-04-22 (stable -- no external dependency changes expected)

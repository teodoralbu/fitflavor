# Phase 10: Product Page Upgrade - Research

**Researched:** 2026-03-23
**Domain:** Product page UI, nutritional data modeling, swipeable controls
**Confidence:** HIGH

## Summary

Phase 10 upgrades the product page from a basic specs + flavor list into a visually compelling page with hero image, ingredient label viewer, and switchable nutritional value displays. The primary technical challenge is that the current database schema lacks columns for full nutritional data (calories, protein, carbs, fat, ingredients list, sweeteners, chemicals) -- only pre-workout-specific fields exist (caffeine_mg, citrulline_g, beta_alanine_g). A schema migration is required before the UI work can begin.

The UI work itself is straightforward given existing project patterns. The hero image (PROD-01) is a layout change to the existing page. The label viewer (PROD-02) can use the existing `Modal` component. The nutritional unit switcher (PROD-03) uses the existing `m-segment` CSS pattern. The visual polish (PROD-04) is inline styling consistent with the rest of the app.

**Primary recommendation:** Split into two plans: (1) DB migration adding nutritional/ingredient columns to the products table, (2) product page UI rebuild with hero image, label modal, and segmented nutritional switcher.

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| PROD-01 | Product page shows a large hero image at the top | Layout change -- enlarge existing 128x128 image to full-width hero. No new data needed, uses existing `image_url` column. |
| PROD-02 | User can open a product label view with full ingredients, sweeteners, and chemicals | **Requires DB migration** -- products table needs `ingredients` (text[]), `sweeteners` (text[]), `chemicals` (text[]) columns. UI uses existing `Modal` component for overlay. |
| PROD-03 | Nutritional values can be viewed per scoop / per serving / per 100g (swipeable) | **Requires DB migration** -- products table needs nutritional columns (calories, protein, carbs, fat, sugar, sodium, plus scoop_weight_g, serving_weight_g for unit conversion). UI uses existing `m-segment` CSS pattern for tab switcher. |
| PROD-04 | Nutritional values display has an improved visual design | Styling-only task. Uses existing CSS variable system and card patterns. Applied during PROD-03 implementation. |
</phase_requirements>

## Standard Stack

### Core (already in project)
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| Next.js | 16.1.6 | App framework, server components | Already in project |
| React | 19.2.3 | UI rendering | Already in project |
| Supabase JS | 2.99.1 | Database queries | Already in project |
| Tailwind CSS | 4.x | Utility styles + CSS variables | Already in project |

### Supporting (no new dependencies needed)
This phase requires **zero new npm packages**. All UI patterns exist in the codebase:
- `Modal` component for label viewer overlay
- `m-segment` / `m-segment-tab` CSS classes for the nutritional unit switcher
- Inline styles + CSS variables for visual polish
- Server components for data fetching, client components for interactive elements

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Custom m-segment tabs | Swiper.js / external carousel | Overkill -- 3 static tabs don't need a swipe library. The m-segment pattern already handles this. |
| Modal for label view | Full page route | Modal is lighter, keeps user on product page, and the existing Modal component is ready. |
| JSONB for nutritional data | Separate nutrition table | JSONB loses type safety; separate table adds join complexity. Flat columns on products table are simplest for this fixed schema. |

## Architecture Patterns

### Schema Migration Pattern

The project uses numbered SQL migrations in `supabase/migrations/`. The next migration will be `005_product_nutritional_data.sql`.

**New columns needed on `products` table:**

```sql
-- Nutritional values (per serving basis, stored as canonical)
ALTER TABLE products ADD COLUMN IF NOT EXISTS calories integer;
ALTER TABLE products ADD COLUMN IF NOT EXISTS protein_g decimal(5,1);
ALTER TABLE products ADD COLUMN IF NOT EXISTS carbs_g decimal(5,1);
ALTER TABLE products ADD COLUMN IF NOT EXISTS fat_g decimal(5,1);
ALTER TABLE products ADD COLUMN IF NOT EXISTS sugar_g decimal(5,1);
ALTER TABLE products ADD COLUMN IF NOT EXISTS sodium_mg integer;

-- Serving size info for unit conversion
ALTER TABLE products ADD COLUMN IF NOT EXISTS scoop_weight_g decimal(5,1);
ALTER TABLE products ADD COLUMN IF NOT EXISTS serving_weight_g decimal(5,1);

-- Label data
ALTER TABLE products ADD COLUMN IF NOT EXISTS ingredients text[];
ALTER TABLE products ADD COLUMN IF NOT EXISTS sweeteners text[];
ALTER TABLE products ADD COLUMN IF NOT EXISTS chemicals text[];
```

**Unit conversion logic:**
- **Per serving** = stored value (canonical)
- **Per scoop** = stored value * (scoop_weight_g / serving_weight_g) -- only if both weights exist
- **Per 100g** = stored value * (100 / serving_weight_g) -- only if serving_weight_g exists

### Page Structure

```
src/app/products/[slug]/
  page.tsx              -- Server component (existing, to be rebuilt)
  loading.tsx           -- Loading skeleton (existing)
  NutritionSwitcher.tsx -- NEW client component for per-scoop/serving/100g tabs
  LabelModal.tsx        -- NEW client component for ingredients/sweeteners/chemicals overlay
```

### Pattern: Server Component with Client Islands

The product page remains a server component for data fetching. Interactive pieces (nutrition switcher, label modal trigger) are client components receiving data as props.

```typescript
// page.tsx (server)
export default async function ProductPage({ params }) {
  const data = await getProductBySlug(slug)
  return (
    <div>
      {/* Hero image -- server rendered */}
      <HeroImage src={product.image_url} alt={...} />

      {/* Nutrition -- client component for tab switching */}
      <NutritionSwitcher product={product} />

      {/* Label -- client component for modal open/close */}
      <LabelModal
        ingredients={product.ingredients}
        sweeteners={product.sweeteners}
        chemicals={product.chemicals}
      />

      {/* Flavors list -- server rendered */}
      {/* ... existing flavor list ... */}
    </div>
  )
}
```

### Pattern: Segmented Control for Nutritional Units

Use the existing `m-segment` CSS pattern already defined in globals.css:

```typescript
// NutritionSwitcher.tsx
'use client'
import { useState } from 'react'

type Unit = 'scoop' | 'serving' | '100g'

export function NutritionSwitcher({ product }) {
  const [unit, setUnit] = useState<Unit>('serving')

  const multiplier = getMultiplier(unit, product.scoop_weight_g, product.serving_weight_g)

  return (
    <div>
      <div className="m-segment">
        {(['scoop', 'serving', '100g'] as const).map(u => (
          <button
            key={u}
            className={`m-segment-tab ${unit === u ? 'active' : ''}`}
            onClick={() => setUnit(u)}
          >
            {u === '100g' ? 'Per 100g' : `Per ${u}`}
          </button>
        ))}
      </div>
      {/* Nutritional grid */}
    </div>
  )
}
```

### Anti-Patterns to Avoid
- **Don't fetch nutritional data client-side**: The product page is a server component. Pass all data as props to client components. No useEffect data fetching.
- **Don't create a separate nutritional_data table**: The data is 1:1 with products. Flat columns are simpler and avoid unnecessary joins.
- **Don't use swipe gesture libraries**: The "swipeable" requirement means a tappable segmented control, not a literal swipe carousel. Three tabs with instant switching is the right UX.
- **Don't hardcode colors**: Use CSS variables (var(--text), var(--bg-card), etc.) for theme compatibility.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Modal overlay | Custom portal/backdrop | Existing `Modal` component at `src/components/ui/Modal.tsx` | Already handles escape key, backdrop click, body scroll lock |
| Segmented control | Custom tab component | Existing `m-segment` CSS pattern in globals.css | Already styled, theme-aware, mobile-optimized |
| Score coloring | Manual color logic | Existing `getScoreColor()` from `src/lib/constants.ts` | Consistent across app |
| Image display | Custom image component | Native `<img>` tag (project pattern) | Project uses native img tags with eslint-disable, not next/image |

## Common Pitfalls

### Pitfall 1: Missing Nutritional Data Handling
**What goes wrong:** Product pages crash or show ugly empty states when nutritional data is null (most products won't have it populated initially).
**Why it happens:** Schema adds nullable columns, but UI doesn't guard against nulls.
**How to avoid:** Every nutritional display must check for null data. Show a "Nutrition data not yet available" placeholder. The segmented switcher should be hidden entirely if no nutritional data exists. Per-scoop tab should be hidden if scoop_weight_g is null.
**Warning signs:** NaN values appearing in the UI, empty grids.

### Pitfall 2: Division by Zero in Unit Conversion
**What goes wrong:** Per-100g calculation divides by serving_weight_g which could be 0 or null.
**Why it happens:** Weight columns are nullable and could have bad data.
**How to avoid:** Guard all division with null/zero checks. If serving_weight_g is null or 0, hide the per-100g tab entirely. Same for scoop_weight_g and per-scoop tab.
**Warning signs:** Infinity or NaN in displayed values.

### Pitfall 3: Hero Image Aspect Ratio
**What goes wrong:** Product images have inconsistent aspect ratios, causing layout shifts or awkward whitespace.
**Why it happens:** Product images come from various sources with different dimensions.
**How to avoid:** Use a fixed-height hero container with `object-fit: contain` and a background color matching the card background. This is consistent with the existing 128x128 image treatment, just larger.
**Warning signs:** Images stretched, squished, or causing layout jumps.

### Pitfall 4: Label Modal Content Overflow
**What goes wrong:** Long ingredient lists overflow the modal on mobile screens.
**Why it happens:** Some pre-workout labels have 30+ ingredients.
**How to avoid:** Make the modal content scrollable with max-height. The existing Modal component wraps content in a div -- add overflow-y: auto with a max-height constraint.
**Warning signs:** Modal content extending below viewport on mobile.

### Pitfall 5: Type Updates Forgotten
**What goes wrong:** TypeScript errors because Product type doesn't include new columns.
**Why it happens:** Schema migration adds DB columns but types.ts isn't updated.
**How to avoid:** Update the `Product` interface in `src/lib/types.ts` AND the `Database` type in the same file. Also update `ProductWithBrandRow` interface in `src/lib/queries.ts`.
**Warning signs:** TypeScript compile errors, need for `as any` casts.

## Code Examples

### Hero Image Section
```typescript
// Full-width hero with contained image
{product.image_url && (
  <div style={{
    width: '100%',
    height: 'clamp(200px, 40vw, 320px)',
    borderRadius: 'var(--radius-xl)',
    backgroundColor: 'var(--bg-card)',
    border: '1px solid var(--border)',
    overflow: 'hidden',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: '24px',
    boxShadow: 'var(--shadow-md)',
  }}>
    <img
      src={product.image_url}
      alt={`${product.name} by ${brand?.name}`}
      style={{
        maxWidth: '80%',
        maxHeight: '85%',
        objectFit: 'contain',
      }}
    />
  </div>
)}
```

### Nutritional Value Grid
```typescript
// Clean grid layout for nutritional values
const nutrients = [
  { label: 'Calories', value: product.calories, unit: '', decimals: 0 },
  { label: 'Protein', value: product.protein_g, unit: 'g', decimals: 1 },
  { label: 'Carbs', value: product.carbs_g, unit: 'g', decimals: 1 },
  { label: 'Fat', value: product.fat_g, unit: 'g', decimals: 1 },
  { label: 'Sugar', value: product.sugar_g, unit: 'g', decimals: 1 },
  { label: 'Sodium', value: product.sodium_mg, unit: 'mg', decimals: 0 },
].filter(n => n.value != null) // Only show populated values

// Apply multiplier based on selected unit
const display = nutrients.map(n => ({
  ...n,
  displayValue: (n.value * multiplier).toFixed(n.decimals) + n.unit,
}))
```

### Unit Conversion Helper
```typescript
function getMultiplier(
  unit: 'scoop' | 'serving' | '100g',
  scoopWeightG: number | null,
  servingWeightG: number | null
): number {
  switch (unit) {
    case 'serving': return 1 // canonical
    case 'scoop':
      if (!scoopWeightG || !servingWeightG || servingWeightG === 0) return 1
      return scoopWeightG / servingWeightG
    case '100g':
      if (!servingWeightG || servingWeightG === 0) return 1
      return 100 / servingWeightG
  }
}
```

### Available Unit Tabs (hide unavailable)
```typescript
function getAvailableUnits(product: Product): Unit[] {
  const units: Unit[] = ['serving']
  if (product.scoop_weight_g && product.serving_weight_g) {
    units.unshift('scoop') // scoop first if available
  }
  if (product.serving_weight_g) {
    units.push('100g')
  }
  return units
}
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| 128x128 product thumbnail | Full-width hero image | This phase | PROD-01: Strong visual first impression |
| Inline specs row only | Full nutritional grid with unit switching | This phase | PROD-03/04: Detailed scannable data |
| No ingredient visibility | Modal label viewer | This phase | PROD-02: Transparency for ingredient-conscious users |

## Open Questions

1. **Data population strategy**
   - What we know: Schema migration adds nullable columns. Existing products have no nutritional data.
   - What's unclear: How/when will nutritional data be populated for existing products? Manual admin entry? CSV import?
   - Recommendation: Build the UI to gracefully handle missing data (show/hide sections). Data population is an admin/content task outside this phase's scope.

2. **Scoop vs serving distinction**
   - What we know: Some pre-workouts have 1 scoop = 1 serving, others have 2 scoops = 1 serving.
   - What's unclear: Whether the distinction matters for all current products.
   - Recommendation: Store both `scoop_weight_g` and `serving_weight_g`. If they're equal, only show "Per serving" and "Per 100g" tabs (hide redundant "Per scoop" tab).

3. **Chemicals column semantics**
   - What we know: PROD-02 mentions "chemicals" alongside ingredients and sweeteners.
   - What's unclear: What constitutes a "chemical" vs an ingredient in supplement context.
   - Recommendation: Use `chemicals` column for notable compounds/additives (e.g., artificial colors, preservatives, fillers) -- distinct from active ingredients. Label it as "Other Additives" in the UI to be less alarming.

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | None (tests deferred to v2 per project decision) |
| Config file | N/A |
| Quick run command | `npm run build` (type-check + build) |
| Full suite command | `npm run build` |

### Phase Requirements -> Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| PROD-01 | Hero image renders at top of product page | manual-only | Visual check on product page | N/A |
| PROD-02 | Label modal shows ingredients, sweeteners, chemicals | manual-only | Visual check: click label button, verify content | N/A |
| PROD-03 | Nutritional switcher changes values per unit | manual-only | Visual check: tap each tab, verify math | N/A |
| PROD-04 | Nutritional display is visually polished | manual-only | Visual check on mobile viewport | N/A |

**Justification for manual-only:** Project decision is zero test coverage until v2 (see STATE.md). Build succeeding confirms no TypeScript errors.

### Sampling Rate
- **Per task commit:** `npm run build`
- **Per wave merge:** `npm run build` + manual visual check
- **Phase gate:** Build green + visual verification of all 4 success criteria

### Wave 0 Gaps
None -- no test infrastructure needed per project convention.

## Sources

### Primary (HIGH confidence)
- `src/app/products/[slug]/page.tsx` -- current product page implementation
- `src/lib/types.ts` -- Product interface (lines 48-65), shows current columns
- `src/lib/queries.ts` -- getProductBySlug (lines 105-181), current data fetching
- `supabase/migrations/001_initial_schema.sql` -- products table schema (lines 128-145)
- `src/app/globals.css` -- m-segment pattern (lines 263-293), card system, theme variables
- `src/components/ui/Modal.tsx` -- existing modal component

### Secondary (MEDIUM confidence)
- `src/lib/constants.ts` -- scoring/color utilities
- Prior phase patterns (07, 08, 09) -- migration + type + UI update flow

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH - no new dependencies, all patterns exist in codebase
- Architecture: HIGH - direct codebase inspection, clear migration pattern from prior phases
- Pitfalls: HIGH - null handling is observable from schema, division-by-zero is mathematical certainty
- Schema design: MEDIUM - column choices are reasonable but "chemicals" semantics need user clarification

**Research date:** 2026-03-23
**Valid until:** 2026-04-23 (stable -- no external dependency changes expected)

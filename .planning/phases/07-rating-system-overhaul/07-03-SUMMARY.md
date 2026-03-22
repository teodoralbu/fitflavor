---
phase: 07-rating-system-overhaul
plan: 03
subsystem: ui, api
tags: [supabase, react, schema-version, rating-display, value-score]

requires:
  - phase: 07-rating-system-overhaul
    provides: "schema_version column and v2 rating form (plans 01-02)"
provides:
  - "Value pill on ReviewCard for value_score display"
  - "schema_version=2 filter on all 8 display query locations"
  - "value_score flowing through feed queries to ReviewCard"
affects: [rating-display, feed, leaderboard, user-profile, flavor-page]

tech-stack:
  added: []
  patterns: ["schema_version filter on display queries", "conditional pill rendering for optional scores"]

key-files:
  created: []
  modified:
    - src/components/rating/ReviewCard.tsx
    - src/lib/queries.ts
    - src/app/actions/feed.ts
    - src/app/users/[username]/page.tsx
    - src/app/flavors/[slug]/page.tsx

key-decisions:
  - "Value pill uses != null (not !== null) to handle both null and undefined"
  - "Home page total count and getTopReviewers excluded from schema_version filter (vanity/engagement metrics)"

patterns-established:
  - "schema_version filter: all user-facing rating queries must include .eq('schema_version', 2)"
  - "Optional score pill: conditional rendering with != null guard and getScoreColor for theming"

requirements-completed: [RATE-03, RATE-04]

duration: 2min
completed: 2026-03-22
---

# Phase 07 Plan 03: Display Filters & Value Pill Summary

**Value pill on ReviewCard and schema_version=2 filter on all 8 display queries hiding v1 ratings from users**

## Performance

- **Duration:** 2 min
- **Started:** 2026-03-22T10:35:48Z
- **Completed:** 2026-03-22T10:38:00Z
- **Tasks:** 2
- **Files modified:** 5

## Accomplishments
- ReviewCard displays 4th "Value" pill when value_score is non-null, hidden when null
- All 8 display query locations filter by schema_version = 2 (getFlavorBySlug, getLeaderboard, getProductBySlug, getUnifiedFeed, getFollowingUnifiedFeed, loadMoreFeed, user profile, weekly count)
- value_score flows through FeedRatingRow interface, select strings, and return mappings to ReviewCard
- Home page stats and getTopReviewers deliberately excluded from filtering

## Task Commits

Each task was committed atomically:

1. **Task 1: Add Value pill to ReviewCard** - `8be54e3` (feat)
2. **Task 2: Add schema_version filter to all display queries and pass value_score** - `ad0fee6` (feat)

## Files Created/Modified
- `src/components/rating/ReviewCard.tsx` - Added value_score to props, conditional Value pill in expanded panel
- `src/lib/queries.ts` - FeedRatingRow value_score field, schema_version filter on 5 queries, value_score in select/return mappings
- `src/app/actions/feed.ts` - schema_version filter and value_score on loadMoreFeed
- `src/app/users/[username]/page.tsx` - schema_version filter on user profile ratings
- `src/app/flavors/[slug]/page.tsx` - schema_version filter on weekly rating count

## Decisions Made
- Used `!= null` (not `!== null`) for value_score check to handle both null and undefined cleanly
- Excluded home page getStats() and getTopReviewers() from schema_version filtering as they are vanity/engagement metrics that should count all ratings

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- Rating system overhaul (Phase 07) is now complete across all 3 plans
- Schema foundation, form overhaul, and display filters all shipped
- v1 ratings are hidden from all user-facing surfaces
- Value score pill renders when price data is available

---
*Phase: 07-rating-system-overhaul*
*Completed: 2026-03-22*

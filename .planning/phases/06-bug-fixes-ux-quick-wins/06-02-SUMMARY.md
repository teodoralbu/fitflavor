---
phase: 06-bug-fixes-ux-quick-wins
plan: 02
subsystem: ui
tags: [next-image, bottom-nav, hero-image, mobile-ux]

# Dependency graph
requires: []
provides:
  - 4-tab bottom navigation (Home, Rate, Top, Profile)
  - Landing page hero card with full-width image
affects: []

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "overflow:hidden on card for image corner clipping"
    - "next/image with priority prop for LCP hero images"

key-files:
  created:
    - public/hero-placeholder.jpg
  modified:
    - src/components/layout/BottomNav.tsx
    - src/app/page.tsx

key-decisions:
  - "Used alternative Unsplash gym photo since original URL returned 404"
  - "Kept padding on inner text wrapper div, not outer card, for edge-to-edge image"

patterns-established:
  - "Hero images use overflow:hidden on parent card for rounded corner clipping"

requirements-completed: [FIX-04, FIX-05]

# Metrics
duration: 2min
completed: 2026-03-22
---

# Phase 06 Plan 02: Nav Cleanup and Hero Image Summary

**Removed Browse tab from 5-tab bottom nav (now 4 tabs) and added full-width hero image to landing page hero card using next/image**

## Performance

- **Duration:** 2 min
- **Started:** 2026-03-22T09:39:53Z
- **Completed:** 2026-03-22T09:41:39Z
- **Tasks:** 2
- **Files modified:** 3

## Accomplishments
- Bottom navigation reduced from 5 tabs to 4 (Home, Rate, Top, Profile) -- Browse tab removed entirely
- Landing page hero card now displays a full-width placeholder image above the tagline
- Hero image uses overflow:hidden for rounded top corners, priority loading for LCP

## Task Commits

Each task was committed atomically:

1. **Task 1: Remove Browse tab from BottomNav** - `ad92253` (fix)
2. **Task 2: Add hero image to landing page** - `5d351ff` (feat)

## Files Created/Modified
- `src/components/layout/BottomNav.tsx` - Removed browseActive variable and Browse tab Link block
- `src/app/page.tsx` - Added Image import, restructured hero card with image above text
- `public/hero-placeholder.jpg` - Placeholder hero image (Unsplash gym photo, 76KB)

## Decisions Made
- Used alternative Unsplash image (photo-1534438327276) since the plan's original URL (photo-1593095948071) returned 404
- Kept text content padding on inner wrapper div rather than outer card div, enabling edge-to-edge image display

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Used alternative Unsplash image URL**
- **Found during:** Task 2 (hero image download)
- **Issue:** Plan's specified Unsplash URL returned HTTP 404
- **Fix:** Used alternative gym-themed Unsplash photo (photo-1534438327276)
- **Files modified:** public/hero-placeholder.jpg
- **Verification:** File downloaded successfully at 76KB, build passes
- **Committed in:** 5d351ff (Task 2 commit)

---

**Total deviations:** 1 auto-fixed (1 blocking)
**Impact on plan:** Minor -- same type of placeholder image, just different Unsplash source. No scope creep.

## Issues Encountered
None beyond the image URL 404 documented above.

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- Navigation and hero image fixes complete
- Hero placeholder image ready to be swapped for branded imagery when available

## Self-Check: PASSED

All files exist. All commits verified.

---
*Phase: 06-bug-fixes-ux-quick-wins*
*Completed: 2026-03-22*

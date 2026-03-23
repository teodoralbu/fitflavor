---
phase: 11-nav-restructure
plan: 01
subsystem: navigation
tags: [bottom-nav, labels, tab-order, ux]
dependency_graph:
  requires: []
  provides: [reordered-bottom-nav]
  affects: [BottomNav]
tech_stack:
  added: []
  patterns: [pathname-based active state]
key_files:
  created: []
  modified:
    - src/components/layout/BottomNav.tsx
decisions:
  - "`homeActive` now binds to `/leaderboard`; `feedActive` binds to `/` — semantics match the new tab labels"
metrics:
  duration: "~5 minutes"
  completed: "2026-03-23"
  tasks_completed: 1
  files_changed: 1
---

# Phase 11 Plan 01: Nav Restructure — Rename and Reorder Bottom Tabs Summary

**One-liner:** Bottom nav reordered so Home (bar chart, /leaderboard) is tab 1 and Feed (house, /) is tab 2, with active state variables renamed to match new semantics.

## What Changed

Single file modified: `src/components/layout/BottomNav.tsx`

### Active state variable renames

| Old name      | New name      | Route binding                          |
|---------------|---------------|----------------------------------------|
| `homeActive`  | `feedActive`  | `pathname === '/'`                     |
| `topActive`   | `homeActive`  | `pathname.startsWith('/leaderboard')`  |

`rateActive`, `notifActive`, and `profileActive` are unchanged.

### JSX tab order (inside the nav flex container)

| Position | Tab     | Route         | Icon      |
|----------|---------|---------------|-----------|
| 1        | Home    | /leaderboard  | bar chart |
| 2        | Feed    | /             | house     |
| 3        | spacer  | —             | —         |
| 4        | Alerts  | /notifications| bell      |
| 5        | Profile | /users/…      | person    |
| FAB      | Rate    | /rate         | plus      |

### Label changes

- `/leaderboard` tab: "Top" → "Home"
- `/` tab: "Home" → "Feed"

## Files Not Touched

- `src/components/layout/Navbar.tsx` — desktop navbar unchanged
- All route files, page components, and other layouts unchanged

## Verification

- `npx tsc --noEmit` — zero errors
- Zero occurrences of `topActive` remain in BottomNav.tsx
- `homeActive` is bound to `pathname.startsWith('/leaderboard')`
- `feedActive` is bound to `pathname === '/'`
- /leaderboard Link block appears before / Link block in JSX
- Center spacer div remains in position 3

## Deviations from Plan

None — plan executed exactly as written.

## Known Stubs

None.

## Commits

| Hash      | Message                                              |
|-----------|------------------------------------------------------|
| e4bbefb   | feat(11-01): rename and reorder bottom nav tabs      |

## Self-Check: PASSED

- `src/components/layout/BottomNav.tsx` exists and contains `feedActive`, `homeActive` (leaderboard), zero `topActive`
- Commit e4bbefb exists in git log

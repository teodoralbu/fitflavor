---
phase: 02-bug-hunt-fixes
plan: 01
subsystem: auth
tags: [supabase, ssr, middleware, next.js, session, cookies]

# Dependency graph
requires: []
provides:
  - Supabase SSR middleware that refreshes session cookies on every non-static request
  - Sign-out handler that invalidates Next.js Server Component cache via router.refresh()
affects: [all-authenticated-routes, settings, server-components]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "@supabase/ssr createServerClient middleware pattern with getAll/setAll cookie handlers"
    - "router.refresh() after router.push() for cache invalidation on auth state change"

key-files:
  created:
    - src/middleware.ts
  modified:
    - src/app/settings/page.tsx

key-decisions:
  - "Used direct createServerClient in middleware (not the createServerSupabaseClient helper) — middleware needs direct NextRequest cookie access to properly write response cookies"
  - "router.refresh() placed after router.push('/') in handleSignOut — push navigates, refresh then invalidates SSR cache for the new page"

patterns-established:
  - "Supabase middleware pattern: getAll reads from request.cookies, setAll writes to both request and supabaseResponse to ensure cookie propagation"

requirements-completed: [BUG-03]

# Metrics
duration: 2min
completed: 2026-03-19
---

# Phase 02 Plan 01: Auth Session Fix Summary

**Supabase SSR middleware added to refresh session cookies on every request, plus router.refresh() on logout to clear stale server-rendered authenticated content**

## Performance

- **Duration:** 2 min
- **Started:** 2026-03-19T14:59:07Z
- **Completed:** 2026-03-19T15:00:39Z
- **Tasks:** 2
- **Files modified:** 2

## Accomplishments
- Created `src/middleware.ts` using the `@supabase/ssr` documented middleware pattern — every non-static request now refreshes the Supabase session cookie so users stay logged in across reloads and long sessions
- Fixed `handleSignOut` in settings page to call `router.refresh()` after `router.push('/')`, forcing Next.js to invalidate its Server Component cache and preventing stale authenticated content from appearing post-logout

## Task Commits

Each task was committed atomically:

1. **Task 1: Add Supabase SSR session-refresh middleware** - `debf784` (feat)
2. **Task 2: Fix logout to call router.refresh() after push** - `fc5a870` (fix)

**Plan metadata:** (docs commit to follow)

## Files Created/Modified
- `src/middleware.ts` - New Supabase SSR middleware; calls `supabase.auth.getUser()` on every non-static request to refresh the session cookie
- `src/app/settings/page.tsx` - Added `router.refresh()` after `router.push('/')` in `handleSignOut`

## Decisions Made
- Used direct `createServerClient` in middleware rather than the project's `createServerSupabaseClient` helper, because middleware must operate on `NextRequest`/`NextResponse` cookies directly — the helper uses `next/headers` which is not available in middleware context.
- `router.refresh()` is placed after `router.push('/')` so navigation happens first and the subsequent cache invalidation applies to the destination page rendering.

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness
- Auth session foundation is now correct; sessions persist properly and logout is clean
- Both files pass automated verification checks
- Manual smoke test recommended: sign in, hard reload (should stay logged in), sign out (should see no authenticated content)

---
*Phase: 02-bug-hunt-fixes*
*Completed: 2026-03-19*

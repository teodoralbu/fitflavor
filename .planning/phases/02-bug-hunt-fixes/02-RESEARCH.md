# Phase 2: Bug Hunt & Fixes - Research

**Researched:** 2026-03-18
**Domain:** Next.js 16 App Router + Supabase SSR — full-stack bug audit and repair
**Confidence:** HIGH (all findings based on direct codebase inspection)

## Summary

Phase 2 is a systematic audit-and-fix phase across six user-facing flows: auth, rating submission, comments, likes, avatar upload, and follow. This research is primarily codebase-driven — the bugs are in the existing source, not in uncertain external libraries. Every finding below is grounded in direct code inspection rather than speculation.

The stack is Next.js 16 App Router with Supabase `@supabase/ssr` for session management. The client uses `createBrowserClient` and the server uses `createServerClient` with cookie forwarding. Auth state is managed by a custom `AuthContext` in `src/context/auth-context.tsx`. All interactive components are client components (`'use client'`). The `as any` cast pattern is pervasive throughout and masks type safety entirely.

**Primary recommendation:** Conduct the audit flow-by-flow (auth → rating → comments/likes → avatar → follow), fix each broken behavior at its source, then verify end-to-end. No new libraries are needed — all fixes are within existing patterns.

---

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| BUG-01 | Systematically audit all user-facing flows for broken behavior (auth, rating, feed, profile, comments, likes, follow) | Audit must be code-level: inspect each flow's component + server query for mismatches, stale data, missing error handling |
| BUG-02 | Fix all broken flows discovered in audit — each bug documented and resolved | Fixes applied in-place; existing patterns re-used (Supabase client, AuthContext, router.refresh()) |
| BUG-03 | Auth flow works correctly end-to-end on mobile (login, signup, session persistence, logout) | See Auth Flow findings: session persistence via SSR cookie, signUp does not auto-login, race condition between getUser + onAuthStateChange |
| BUG-04 | Rating submission flow completes without errors and shows correct success state | See Rating Submission findings: isFirst count bug, no duplicate-submission guard, success page uses `(product as any).brands` which can be null |
| BUG-05 | Comment and like actions work reliably without stale state or UI glitches | See Comments/Likes findings: comment count on FeedCard never increments after post, FollowButton has no optimistic update and no error handling |
| BUG-06 | Avatar upload completes successfully and reflects immediately in UI | See Avatar findings: AvatarUpload on profile page updates local state but Settings page does not update the displayed avatar without a page reload |
</phase_requirements>

---

## Standard Stack

### Core (already in project — no changes needed)
| Library | Version | Purpose | Notes |
|---------|---------|---------|-------|
| next | 16.1.6 | App Router, Server Components, routing | Already installed |
| @supabase/ssr | ^0.9.0 | SSR-safe Supabase client (browser + server) | Already installed |
| @supabase/supabase-js | ^2.99.1 | Supabase JS SDK | Already installed |
| react | 19.2.3 | UI rendering | Already installed |

No new libraries are required for this phase. All bug fixes are within the existing stack.

**Installation:** None needed.

---

## Architecture Patterns

### How Auth Session Works in This App

The app uses `@supabase/ssr` with two client factories:

- `src/lib/supabase.ts` — `createBrowserClient` for use in Client Components
- `src/lib/supabase-server.ts` — `createServerClient` with `cookies()` for Server Components and queries

Session persistence relies on the Supabase cookie being set by the server client. The `setAll` method in `supabase-server.ts` has a silent `try/catch` for Server Component use — this is intentional and correct. Session cookies are read/written automatically.

`AuthContext` (`src/context/auth-context.tsx`) manages client-side auth state via:
1. Initial `supabase.auth.getUser()` call on mount
2. `supabase.auth.onAuthStateChange` listener for all subsequent changes

After `signIn`, the code calls `router.push(redirect)` and `router.refresh()`. The `router.refresh()` forces Next.js to re-run Server Components with the new session cookie — this is the correct pattern for App Router.

### Pattern: Optimistic UI for Likes
`LikeButton` already implements correct optimistic update with revert-on-failure. This is the established pattern to follow for any other interactive toggles that need the same treatment.

### Pattern: Local State + refreshProfile for Avatar
`AvatarUpload` updates `avatarUrl` local state immediately after upload, then calls `refreshProfile()` to sync the auth context. This is the correct two-step pattern: local state for immediate visual update, context refresh for persistence.

### Pattern: Comment Count Sync Gap
`CommentsSection` keeps `count` as local state seeded from `initialCount`. When a new comment is posted inside the bottom sheet, `loadComments()` refreshes the comment list but `count` in the parent `CommentsSection` is never incremented. The parent does not receive a callback from the child sheet. This is a stale-count bug.

### Project Structure (relevant to this phase)
```
src/
├── app/
│   ├── login/page.tsx          # Login form — auth BUG-03
│   ├── signup/page.tsx         # Signup form — auth BUG-03
│   ├── rate/[slug]/page.tsx    # Rating page
│   ├── rate/[slug]/success/    # Success page — BUG-04
│   └── settings/page.tsx       # Settings + avatar — BUG-06
├── components/
│   ├── feed/FeedCard.tsx       # Like + comment entry — BUG-05
│   ├── rating/CommentsSection.tsx  # Comment sheet — BUG-05
│   ├── rating/LikeButton.tsx   # Like toggle — BUG-05
│   ├── rating/RatingForm.tsx   # Rating submission — BUG-04
│   └── user/
│       ├── AvatarUpload.tsx    # Profile page avatar — BUG-06
│       └── FollowButton.tsx    # Follow toggle — BUG-01/02
├── context/
│   └── auth-context.tsx        # Auth state + session — BUG-03
└── lib/
    ├── queries.ts              # Server-side data fetching
    └── supabase-server.ts      # Server client factory
```

### Anti-Patterns to Avoid
- **`as any` to bypass errors:** The codebase uses `db = supabase as any` everywhere to work around missing Supabase types. Do not introduce new instances of this in bug fixes. Work within existing `as any` patterns when necessary, but do not expand them.
- **`router.refresh()` without `router.push()` for auth redirects:** `router.refresh()` alone does not navigate. After login, `router.push(redirect)` + `router.refresh()` is the correct sequence (already used in login page).
- **Silent error swallowing in follow/comment actions:** `FollowButton` does not handle database errors — it silently succeeds or fails. Fix should mirror `LikeButton`'s revert-on-failure pattern.

---

## Bug Inventory (from direct code inspection)

This is the definitive list derived from reading every relevant file. The planner should convert these into concrete tasks.

### BUG-03: Auth Flow

**Finding 1 — Signup does not auto-login the user (HIGH confidence)**
- Location: `src/app/signup/page.tsx`, `src/context/auth-context.tsx`
- What happens: `signUp` calls `supabase.auth.signUp()`. Supabase by default requires email confirmation. After successful signup, the app shows "Check your email" — this is intentional behavior, NOT a bug.
- Status: WORKING AS INTENDED. No fix needed for the signup confirmation flow itself.
- Potential issue: If email confirmation is disabled in the Supabase project settings, `signUp` returns a session immediately, but `AuthContext.signUp` does not call `fetchProfile` or set user state. The `onAuthStateChange` listener should handle this automatically. **Audit needed:** verify `onAuthStateChange` fires after signup when confirmation is off.

**Finding 2 — Session persistence: no middleware for cookie refresh (MEDIUM confidence)**
- Location: No `middleware.ts` file exists in the project
- What happens: `@supabase/ssr` documentation recommends a middleware that calls `supabase.auth.getUser()` on every request to refresh the session token. Without it, the session cookie can expire mid-session without being refreshed.
- Risk: Long-lived sessions may silently expire. User appears logged in on client but server sees them as logged out.
- Fix: Add `src/middleware.ts` using the standard `@supabase/ssr` pattern.

**Finding 3 — Double auth check on page load (LOW confidence — may be fine)**
- Location: `src/context/auth-context.tsx` lines 44-64
- What happens: `getUser()` is called first, then `onAuthStateChange` fires immediately with the current session, calling `fetchProfile` a second time.
- Risk: Redundant network request. Not a correctness bug, but a `SIGNED_IN` event fires on initial load.
- Fix: Low priority — can be addressed if it causes observable issues.

**Finding 4 — Logout does not call router.refresh() (HIGH confidence)**
- Location: `src/app/settings/page.tsx` line 138: `await signOut(); router.push('/')`
- The `signOut` in `AuthContext` calls `supabase.auth.signOut()` which clears the session, but the server-side cache is not invalidated immediately. Without `router.refresh()` after `router.push('/')`, server components may briefly render stale authenticated content.
- Fix: Add `router.refresh()` after the `router.push('/')` in the sign-out handler.

### BUG-04: Rating Submission

**Finding 5 — isFirst rating count is unreliable (HIGH confidence)**
- Location: `src/components/rating/RatingForm.tsx` lines 194-200
- What happens: After insert succeeds, the code queries `count` of ratings for the user. If `totalRatings === 1`, it assumes this is the first rating and appends `&first=1` to the redirect. However, the count query runs after the insert has already succeeded, and uses `head: true` (no row data returned). Due to database latency or RLS policies, the count might not immediately reflect the newly inserted row.
- Fix: Pass `isFirst` from the insert response or restructure: check count BEFORE insert, then set `isFirst = prevCount === 0`.

**Finding 6 — No duplicate submission guard (HIGH confidence)**
- Location: `src/components/rating/RatingForm.tsx` — `submitting` state used for button disabled, but the form `onSubmit` is not guarded
- What happens: `submitting` is set to `true` but the form can still be submitted if the user rapidly double-taps or if `submitting` state update races with the second submit event.
- Fix: Add an early return at the top of `handleSubmit` if `submitting` is true.

**Finding 7 — Success page brand access can be null (HIGH confidence)**
- Location: `src/app/rate/[slug]/success/page.tsx` line 37: `const brand = (product as any).brands`
- The `getFlavorBySlug` query selects `products(*, brands(*))`. The join alias used in the query is `brands` (through `products`) but in the success page, `product` is `flavor.products` and `brand` is `(product as any).brands`. If the join structure differs from how the success page accesses it, `brand` can be `undefined`, causing `brand?.name` to render nothing or crash.
- Fix: Audit the exact shape returned by `getFlavorBySlug` and ensure the success page accesses the brand name correctly. Compare with how `queries.ts` structures the return object.

### BUG-05: Comments and Likes

**Finding 8 — Comment count does not update after posting (HIGH confidence)**
- Location: `src/components/rating/CommentsSection.tsx` lines 307-346
- What happens: `CommentsSection` renders a trigger button showing `count`. The `CommentBottomSheet` is rendered as a child and manages its own `comments` state. When a comment is posted, `loadComments()` refreshes the sheet's list — but the parent `CommentsSection.count` state is never incremented.
- Fix: Pass a `onCommentPosted` callback from `CommentsSection` to `CommentBottomSheet`. Increment `count` in the parent when the callback fires.

**Finding 9 — FollowButton has no error handling or optimistic update (HIGH confidence)**
- Location: `src/components/user/FollowButton.tsx`
- What happens: The button toggles `following` state AFTER the database call succeeds (not optimistically). If the database call fails, there is no user feedback and no error display. The pattern is opposite to `LikeButton` which uses optimistic update with revert-on-failure.
- Fix: Mirror the `LikeButton` pattern: optimistic state update first, then revert on error with a toast notification via `useToast`.

**Finding 10 — LikeButton initialLiked/initialCount in FeedCard is hardcoded to 0/false (HIGH confidence)**
- Location: `src/app/page.tsx` line 323:
  ```tsx
  <FeedCard key={feedItem.id} item={feedItem} initialLikeCount={0} initialLiked={false} index={idx} />
  ```
- But `FeedCard` already reads `ratingData.like_count` and `ratingData.user_has_liked` from the item object (lines 394-395), so the hardcoded props are overridden. This is actually fine — the fallback `?? initialLikeCount` means the item-level values win. **Not a bug.** Confirm this during audit.

### BUG-06: Avatar Upload

**Finding 11 — AvatarUpload and Settings page use different buckets/paths (verify needed)**
- `AvatarUpload.tsx` (profile page): uploads to `review-photos` bucket at `avatars/${user.id}/avatar.jpg`
- `settings/page.tsx` `handleAvatarUpload`: also uploads to `review-photos` bucket at `avatars/${user.id}/avatar.jpg`
- Both use `upsert: true` — same path, same bucket. The paths match. **Not a divergence bug.**

**Finding 12 — Settings page avatar display does not update after upload without page reload (HIGH confidence)**
- Location: `src/app/settings/page.tsx` lines 151-161
- What happens: The avatar `<img>` in the settings page renders `profile.avatar_url` from the auth context. After a successful upload, `refreshProfile()` is called, which re-fetches the profile from the database. The DB record is updated with the new URL. However, the `profile.avatar_url` used in the settings avatar display comes from `useAuth().profile`, which SHOULD update when `refreshProfile()` resolves.
- Root cause: The Settings page avatar display uses `profile.avatar_url` from auth context — this should update after `refreshProfile()`. Audit this carefully: if `refreshProfile()` correctly updates `profile` state in `AuthContext`, the UI should re-render. If it does not, the fetch in `fetchProfile` may be returning stale data.
- Fix path: Verify `refreshProfile()` → `fetchProfile()` → `setProfile(data)` chain actually updates the React state and triggers a re-render of the settings avatar. If not, add local `avatarUrl` state in settings page (same as `AvatarUpload` component does).

**Finding 13 — AvatarUpload.tsx missing file type validation before compress (MEDIUM confidence)**
- Location: `src/components/user/AvatarUpload.tsx` line 39
- The `compress` function calls `URL.createObjectURL(file)` and attempts canvas operations. If the file is not a valid image (e.g., a PDF), `img.onload` may not fire or may produce a broken canvas. The `accept` attribute on the input restricts to `image/jpeg,image/png,image/webp` but this is bypassable.
- Note: Settings page DOES validate file type and size before processing (lines 100-102). AvatarUpload on the profile page does NOT. This is a gap.
- Fix: Add MIME type check in `AvatarUpload.handleFile` before calling `compress`.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Session cookie refresh | Custom cookie management | `@supabase/ssr` middleware pattern | Handles token rotation, secure cookie flags, all edge cases |
| Toast/notification UI | Custom toast component | Existing `ToastContext` / `useToast()` | Already in the app (`src/context/ToastContext.tsx`), used by `LikeButton` |
| Optimistic UI for follow | Custom state rollback | Mirror existing `LikeButton` pattern | Already proven in the codebase |

---

## Common Pitfalls

### Pitfall 1: Middleware Missing — Session Silently Expires
**What goes wrong:** Without `src/middleware.ts`, the Supabase session token is not refreshed on each request. After the JWT expires, server-side `auth.getUser()` returns null even though the client still has a valid refresh token.
**Why it happens:** `@supabase/ssr` requires middleware to call `supabase.auth.getUser()` on every request so it can set the refreshed `Set-Cookie` header. Without this, the cookie expires and is not renewed.
**How to avoid:** Add `src/middleware.ts` using the standard pattern from `@supabase/ssr` docs. The middleware must match all routes (or at minimum, exclude only static assets).
**Warning signs:** User is suddenly logged out mid-session. `supabase.auth.getUser()` on the server returns null despite the client still showing as logged in.

### Pitfall 2: router.refresh() Required After Auth State Changes
**What goes wrong:** After login/logout, client-side state updates but server-rendered content (Server Components) still reflects the old session until a fresh server render is triggered.
**Why it happens:** Next.js App Router caches Server Component renders. `router.push()` alone navigates but may serve a cached render. `router.refresh()` invalidates the cache and forces a fresh server render.
**How to avoid:** Always call both `router.push(destination)` and `router.refresh()` after login and logout.
**Warning signs:** After logging out, the user is on the home page but still sees their "logged in" UI briefly, or protected server content is still visible.

### Pitfall 3: Supabase Count Query Latency After Insert
**What goes wrong:** Querying `count` immediately after an `insert` may return the pre-insert count due to read-after-write latency or connection pool routing.
**Why it happens:** Supabase uses connection pooling (PgBouncer by default). A count query may route to a different connection that hasn't seen the just-committed write.
**How to avoid:** Determine `isFirst` BEFORE the insert (check if count is 0), not after.
**Warning signs:** The first-rating banner appears on a user's second rating, or never appears on the first.

### Pitfall 4: Comment Count Stale in UI
**What goes wrong:** User posts a comment, sees their comment in the sheet, closes the sheet, and the card still shows the old comment count.
**Why it happens:** The comment count in the trigger button is local React state seeded from server-rendered `initialCount`. Adding a comment refreshes the sheet's internal list but does not propagate back to the parent's count state.
**How to avoid:** Pass a callback (`onCommentAdded`) from parent to the bottom sheet. Increment the count in the parent when called.
**Warning signs:** Comment count on feed cards is always stale after the user posts.

### Pitfall 5: Avatar URL Cache-Busting Timestamp Stored in DB
**What goes wrong:** `AvatarUpload` appends `?t=Date.now()` to the URL and stores this timestamped URL in the database. Every upload creates a permanently unique URL. Future reads of the DB will return the timestamped URL, which is valid and points to the current file, but the timestamp accumulates in the database permanently.
**Why it happens:** Cache-busting is applied at write time rather than read time.
**How to avoid:** This is the existing pattern and is functionally correct for now. The `upsert: true` on the storage upload means the underlying file is replaced. The only consequence is that old timestamps pile up in the URL — not a correctness bug.

---

## Code Examples

Verified patterns from codebase inspection:

### Standard Supabase Middleware (MISSING — needs to be added for BUG-03)
```typescript
// src/middleware.ts — to be created
import { createServerClient } from '@supabase/ssr'
import { NextResponse, type NextRequest } from 'next/server'

export async function middleware(request: NextRequest) {
  let supabaseResponse = NextResponse.next({ request })
  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() { return request.cookies.getAll() },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value }) => request.cookies.set(name, value))
          supabaseResponse = NextResponse.next({ request })
          cookiesToSet.forEach(({ name, value, options }) =>
            supabaseResponse.cookies.set(name, value, options)
          )
        },
      },
    }
  )
  await supabase.auth.getUser()
  return supabaseResponse
}

export const config = {
  matcher: ['/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)'],
}
```

### Correct isFirst Check (before insert, not after)
```typescript
// In RatingForm.handleSubmit — check BEFORE insert
const { count: existingCount } = await db
  .from('ratings')
  .select('id', { count: 'exact', head: true })
  .eq('user_id', user.id)
const isFirst = existingCount === 0
// ... then do the insert ...
router.push(`/rate/${flavor.slug}/success?score=${overall.toFixed(1)}${isFirst ? '&first=1' : ''}`)
```

### Comment Count Callback Pattern
```typescript
// CommentsSection parent — expose onCommentPosted to increment count
const [count, setCount] = useState(initialCount)
// Pass to sheet:
<CommentBottomSheet
  open={open}
  onClose={handleClose}
  ratingId={ratingId}
  onCommentPosted={() => setCount(c => c + 1)}
/>
// In CommentBottomSheet.handleSubmit, after successful insert:
if (!error) {
  setText('')
  await loadComments()
  onCommentPosted?.()
}
```

### FollowButton Optimistic Pattern (mirrors LikeButton)
```typescript
// Optimistic update first, revert on error
const wasFollowing = following
setFollowing(!following)
setLoading(true)
const { error } = following
  ? await db.from('follows').delete()...
  : await db.from('follows').insert(...)
if (error) {
  setFollowing(wasFollowing)
  showToast('Action failed')
}
setLoading(false)
router.refresh()
```

---

## State of the Art

| Old Approach | Current Approach | Impact |
|--------------|------------------|--------|
| Manual cookie handling for Supabase auth | `@supabase/ssr` browser/server clients | Current app already uses this correctly — just missing middleware |
| `supabase-js` v1 client | `@supabase/ssr` with `createBrowserClient` / `createServerClient` | Current app is on v2 with SSR package |

---

## Open Questions

1. **Email confirmation: is it enabled or disabled in the Supabase project?**
   - What we know: Signup shows "Check your email" on success — implies confirmation is ON
   - What's unclear: If confirmation is off, `onAuthStateChange` must handle the immediate session, and `signUp` in AuthContext does not call `fetchProfile` — this would be a bug
   - Recommendation: Confirm via Supabase dashboard. If confirmation is off, add `fetchProfile` call after successful signup.

2. **What database errors can rating insert return (duplicate key, RLS)?**
   - What we know: `insertError` is caught and shown to the user
   - What's unclear: If RLS policy blocks a user from rating the same flavor twice, the error message "Could not submit rating" is not specific enough
   - Recommendation: Audit RLS policy on `ratings` table. If unique constraint exists (user_id + flavor_id), surface a specific "You've already rated this flavor" message.

3. **Does `refreshProfile()` reliably cause a re-render in Settings page avatar?**
   - What we know: `refreshProfile()` calls `fetchProfile()` which calls `setProfile(data)` in AuthContext
   - What's unclear: React's context update batching could cause the avatar display to lag one render cycle, but this should self-resolve
   - Recommendation: Test empirically. If the avatar doesn't update immediately, add local `avatarUrl` state to the Settings page (same as the AvatarUpload component pattern).

---

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | None — zero test coverage (accepted risk per STATE.md) |
| Config file | None |
| Quick run command | N/A — no test suite |
| Full suite command | N/A |

Per `STATE.md`: "Zero test coverage — accepted risk for this milestone." Per `REQUIREMENTS.md`: Test suite setup is deferred to v2. Nyquist validation is enabled in `config.json` but there is no test infrastructure to reference.

### Phase Requirements → Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| BUG-01 | All flows audited | manual | N/A | N/A |
| BUG-02 | All bugs fixed | manual | N/A | N/A |
| BUG-03 | Auth flow end-to-end | manual smoke | N/A — no test infra | N/A |
| BUG-04 | Rating submission | manual smoke | N/A | N/A |
| BUG-05 | Comments + likes | manual smoke | N/A | N/A |
| BUG-06 | Avatar upload | manual smoke | N/A | N/A |

### Sampling Rate
- **Per task:** Manual browser verification of the specific flow fixed
- **Per wave:** Manual walkthrough of all BUG-0x flows on mobile viewport
- **Phase gate:** All 6 success criteria verified manually before `/gsd:verify-work`

### Wave 0 Gaps
None — there is no test infrastructure to create. Verification is manual per project decision.

---

## Sources

### Primary (HIGH confidence — direct code inspection)
- `src/context/auth-context.tsx` — auth state management, signIn, signUp, signOut, session listener
- `src/components/rating/RatingForm.tsx` — submission flow, isFirst logic, duplicate guard gap
- `src/components/rating/CommentsSection.tsx` — comment count stale bug
- `src/components/rating/LikeButton.tsx` — reference implementation for optimistic UI pattern
- `src/components/user/AvatarUpload.tsx` — avatar upload flow, missing file validation
- `src/components/user/FollowButton.tsx` — missing optimistic update and error handling
- `src/app/settings/page.tsx` — Settings avatar display, signOut without refresh
- `src/app/rate/[slug]/success/page.tsx` — isFirst rendered, brand null risk
- `src/app/page.tsx` — FeedCard like_count/user_has_liked passthrough (confirmed correct)
- `src/lib/supabase-server.ts` — SSR client pattern, no middleware file found
- `src/lib/queries.ts` — server query shapes for audit

### Secondary (MEDIUM confidence — pattern knowledge)
- `@supabase/ssr` middleware pattern: standard documented approach for session refresh in Next.js App Router

### Tertiary (LOW confidence)
- None

---

## Metadata

**Confidence breakdown:**
- Bug inventory: HIGH — all findings from direct code inspection
- Fix patterns: HIGH — LikeButton and existing patterns are the reference
- Middleware gap: HIGH — no `middleware.ts` file exists, confirmed via file listing
- Open questions: MEDIUM — require empirical verification or Supabase dashboard access

**Research date:** 2026-03-18
**Valid until:** 2026-04-17 (stable stack, findings are code-level facts not ecosystem opinions)

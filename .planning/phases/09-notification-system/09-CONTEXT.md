# Phase 9: Notification System - Context

**Gathered:** 2026-03-23
**Status:** Ready for planning

<domain>
## Phase Boundary

Add unread notification badge to the nav bell icon, and add followers/following list access from profile pages. The notification display page (`/notifications`) already exists and works — no redesign needed. DB changes are lightweight: a `last_seen_at` timestamp on the user to track what's new.

</domain>

<decisions>
## Implementation Decisions

### Unread tracking approach
- Use `last_notifications_seen_at` timestamptz column on the `users` table (lightweight — no new notifications table)
- Unread count = number of computed notification items newer than `last_notifications_seen_at`
- On page visit to `/notifications`, update this timestamp via a server action or API route
- Badge shows count if unread > 0, clears when user visits notifications page

### Badge appearance and clearing
- Small red dot or number badge overlaid on the bell icon in `BottomNav.tsx`
- Auto-clears on visiting `/notifications` (update `last_notifications_seen_at` to now)
- If unread count > 9, show "9+" to keep badge compact
- Badge fetched via a lightweight server component or layout-level data fetch

### Followers/Following lists
- Separate pages: `/users/[username]/followers` and `/users/[username]/following`
- The follower/following count stats on the profile page become tappable links to these pages
- Each page shows a list of users with avatar + username + follow button (reuse `FollowButton` component)
- Back navigation returns to the profile page

### Notification scope
- Keep all three types from the existing page: likes, comments, and follows
- Requirements only mandate likes and follows (NOTIF-01, NOTIF-02) — comments are a bonus already built
- No changes to the notification display logic — existing page is correct

### Claude's Discretion
- Exact badge position on the bell icon (top-right corner overlay, typical convention)
- Badge color (use `var(--accent)` or standard red — whichever reads better against the nav background)
- Pagination or infinite scroll for followers/following lists (simple load-all is fine at current scale)
- Layout of followers/following list items (avatar left, username, follow button right)

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Existing notification infrastructure
- `src/app/notifications/page.tsx` — full notification page, data fetching pattern, NotificationItem interface, grouping logic (Today/Earlier)
- `src/components/layout/BottomNav.tsx` — bell icon tab with no badge yet; badge must be added here

### Profile and social
- `src/app/users/[username]/page.tsx` — profile page; follower/following counts are rendered as stats; these need to become tappable links
- `src/components/user/FollowButton.tsx` — reusable follow/unfollow button; use on followers/following list pages

### Data layer
- `src/lib/types.ts` — User interface (needs `last_notifications_seen_at` field)
- `src/lib/queries.ts` — existing query patterns; any new query for unread count should follow the same style

### Requirements
- `.planning/REQUIREMENTS.md` — NOTIF-01, NOTIF-02, NOTIF-03, NOTIF-04 acceptance criteria

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `src/app/notifications/page.tsx`: Server component with full notification rendering — no changes needed to this file except possibly triggering `last_notifications_seen_at` update on load
- `src/components/user/FollowButton.tsx`: Client component for follow/unfollow — reuse on followers/following list pages
- `BottomNav.tsx`: Already has the bell icon and `notifActive` state — badge is an overlay on top of the existing SVG

### Established Patterns
- Inline CSS with `var(--*)` CSS variables — no Tailwind in layout/component files
- 44px minimum touch targets on all interactive elements (required for follower list rows)
- Server components for data fetching, client components for interactivity
- `createServerSupabaseClient()` for server-side queries; client-side `supabase` for mutations
- `force-dynamic` export on pages that need fresh data per request

### Integration Points
- `users` table: add `last_notifications_seen_at timestamptz` column (DB migration needed)
- `BottomNav.tsx`: needs unread count passed in or fetched — currently a client component with no data access; may need a wrapper server component or a lightweight API route
- Profile page stat row: follower/following counts must link to `/users/[username]/followers` and `/users/[username]/following`
- New pages: `/users/[username]/followers/page.tsx` and `/users/[username]/following/page.tsx`

</code_context>

<specifics>
## Specific Ideas

- BottomNav is currently a pure client component (uses `usePathname`, `useAuth`) — the unread badge count will need to come from a server wrapper or a small API call; the simplest approach is a server layout component that fetches the count and passes it as a prop to BottomNav
- The `last_notifications_seen_at` update should happen on the server (server action called from the notifications page on mount, or triggered in the page's server component via a response cookie/header approach)

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope.

</deferred>

---

*Phase: 09-notification-system*
*Context gathered: 2026-03-23*

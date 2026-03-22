# Phase 8: Comment System Upgrade - Context

**Gathered:** 2026-03-22
**Status:** Ready for planning

<domain>
## Phase Boundary

Add edit, delete, and single-level threaded replies to the existing comment bottom sheet (`CommentsSection.tsx`). No new surfaces — all interactions live within the existing `CommentBottomSheet`. Schema changes required to support `parent_comment_id`, `is_deleted`, and `is_edited` on `review_comments`.

</domain>

<decisions>
## Implementation Decisions

### Edit/delete access
- Both **three-dot menu (⋮ button)** on the comment row AND **long-press** trigger edit/delete options — visible only on the user's own comments
- **Inline edit**: the comment bubble transforms into an editable text field in place, with Save/Cancel buttons below it. No modal or second sheet.
- **"edited" marker**: small lowercase `edited` text appended after the timestamp — e.g. `2h · edited`. Same dim color as the timestamp.
- **Delete with no replies**: comment removed immediately (optimistic removal from local state, then DB delete)

### Delete with replies
- When a deleted comment has replies, the row shows the placeholder **`[Comment deleted]`** — no username exposed
- Stored as a **soft delete**: add `is_deleted boolean default false` to `review_comments`. Text is cleared/nulled on delete, replies remain attached via `parent_comment_id`. Placeholder rendered client-side when `is_deleted = true`.

### Reply threading UI
- Replies appear **indented under the parent** with a left border/accent line and smaller avatars (20–24px). Consistent with Instagram-style single-level threading.
- Each top-level comment has a small **"Reply" text button** below it. Tapping focuses the main input bar.
- When reply mode is active, a **dismissable chip** appears above the input: `Replying to @username ×`. Tapping ✕ cancels reply mode and returns to top-level posting.
- Single level only — replies cannot be replied to (COMM-03, fixed).

### Comment load limits
- **20 top-level comments** loaded on sheet open (unchanged from current)
- **Up to 5 replies** per top-level comment loaded inline with the initial fetch
- If a comment has more than 5 replies, show a `View N more replies` link below the visible replies

### Claude's Discretion
- Exact left-indent size and border style for reply nesting (suggest 20–24px indent with a 2px accent-colored left border)
- Confirmation dialog before delete (suggested: yes, a small inline confirm — "Delete?" with Delete/Cancel — to prevent accidental deletes)
- Whether `is_edited` is a boolean or a timestamp (`edited_at`) — either works, timestamp is richer
- Three-dot menu position and popover style within the comment row

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Existing comment implementation
- `src/components/rating/CommentsSection.tsx` — full bottom sheet, current comment fetch/post logic, `Comment` interface (needs `parent_comment_id`, `is_deleted`, `is_edited` fields)
- `src/lib/types.ts` — `ReviewComment` interface (needs `parent_comment_id`, `is_deleted`, `is_edited`/`edited_at`)
- `src/lib/queries.ts` — comment count queries in `getUnifiedFeed` and `getFollowingUnifiedFeed` (comment counts should exclude `is_deleted` rows)

### Requirements
- `.planning/REQUIREMENTS.md` — COMM-01, COMM-02, COMM-03 acceptance criteria

No external specs — requirements fully captured in decisions above.

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `CommentBottomSheet` in `CommentsSection.tsx`: existing bottom sheet with body scroll lock, portal rendering, handle bar, header, scrollable comment list, sticky input — all reusable; edit/delete/reply adds to this structure
- `loadComments` callback: already fetches comments + user data; will need to be updated to fetch replies and `is_deleted`/`is_edited` fields
- Avatar rendering pattern (28px with image or initials fallback): reuse at 20–24px for reply avatars

### Established Patterns
- Inline styles with CSS variables (`var(--bg-card)`, `var(--text)`, `var(--accent)`, `var(--border)`) — no Tailwind in comment components
- `minHeight: '44px'` touch targets on all interactive elements — required for new Reply/edit/delete buttons
- Optimistic UI: `loadComments()` called after post to refresh — same approach for post-edit and post-delete
- Client-side Supabase calls (not via `queries.ts`) for all comment operations — keep consistent

### Integration Points
- `review_comments` table: needs `parent_comment_id uuid references review_comments(id)`, `is_deleted boolean default false`, `is_edited boolean default false` (or `edited_at timestamptz`) — DB migration required
- Comment count queries in `src/lib/queries.ts`: `getUnifiedFeed` and `getFollowingUnifiedFeed` fetch all rows from `review_comments` for count — filter out `is_deleted = true` rows so deleted comments don't inflate the count
- `ReviewComment` type in `src/lib/types.ts`: add the new columns so client code is typed

</code_context>

<specifics>
## Specific Ideas

- The `[Comment deleted]` placeholder should be visually dim (use `var(--text-faint)`) and italic to distinguish from real content
- The "Replying to @username ×" chip should sit between the scrollable comment list and the input row — same sticky footer area as the input, but above it
- Three-dot menu (⋮) should only render on the current user's own comments — non-owners see no menu

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope.

</deferred>

---

*Phase: 08-comment-system-upgrade*
*Context gathered: 2026-03-22*

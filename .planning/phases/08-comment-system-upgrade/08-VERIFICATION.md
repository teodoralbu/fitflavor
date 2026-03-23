---
phase: 08-comment-system-upgrade
verified: 2026-03-23T00:00:00Z
status: human_needed
score: 7/7 must-haves verified
human_verification:
  - test: "Edit a comment in browser"
    expected: "Three-dot menu appears on own comments, tapping Edit shows inline textarea, saving updates text and shows 'edited' marker after timestamp"
    why_human: "Visual rendering of inline edit mode and 'edited' marker cannot be confirmed programmatically"
  - test: "Delete a comment with no replies"
    expected: "Comment disappears immediately from the list"
    why_human: "Hard-delete behavior and immediate UI removal requires browser interaction"
  - test: "Delete a comment that has replies"
    expected: "Comment row shows '[Comment deleted]' in italic dim text, replies remain visible underneath"
    why_human: "Soft-delete placeholder rendering requires visual confirmation"
  - test: "Tap Reply on a top-level comment"
    expected: "'Replying to @username X' chip appears above the input; posting sends an indented reply with left accent border and smaller avatar"
    why_human: "Reply chip, indentation, accent border, and avatar sizing require visual confirmation"
  - test: "Confirm Reply button does NOT appear on reply comments"
    expected: "Replies have no Reply button — only top-level comments do"
    why_human: "Requires visual inspection in the rendered comment list"
  - test: "View another user's comment"
    expected: "No three-dot menu appears — owner-only guard enforced"
    why_human: "Requires two-account testing or viewing a comment from a different user"
  - test: "Close the bottom sheet while in edit mode, then reopen"
    expected: "Edit mode is gone — state fully reset on sheet close"
    why_human: "State reset behavior requires interactive testing"
  - test: "Feed comment count after deleting a comment"
    expected: "Count on feed card does not include soft-deleted comments"
    why_human: "Requires observing the feed count update after a soft-delete action"
---

# Phase 8: Comment System Upgrade Verification Report

**Phase Goal:** Users can manage their comments and engage in threaded conversations
**Verified:** 2026-03-23
**Status:** human_needed — all automated checks pass; 8 items require browser verification
**Re-verification:** No — initial verification

---

## Goal Achievement

### Observable Truths

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | review_comments table has parent_comment_id, is_deleted, and edited_at columns | VERIFIED | `004_comment_threading.sql` lines 12-23: all three ADD COLUMN statements present and correct |
| 2 | RLS UPDATE policy exists for comment owners | VERIFIED | `004_comment_threading.sql` line 39-41: `CREATE POLICY "review_comments: owner update" ... USING (auth.uid() = user_id)` |
| 3 | ReviewComment TypeScript interface includes new columns | VERIFIED | `src/lib/types.ts` lines 112-114: `parent_comment_id: string | null`, `is_deleted: boolean`, `edited_at: string | null` all present |
| 4 | Feed comment counts exclude soft-deleted comments | VERIFIED | `src/lib/queries.ts` lines 486 and 580: `.eq('is_deleted', false)` on both `getUnifiedFeed` and `getFollowingUnifiedFeed` count queries |
| 5 | User can edit their comment with inline textarea and "edited" marker | VERIFIED | CommentsSection.tsx: `editingId` state, textarea at `editingId === comment.id`, UPDATE with `edited_at: new Date().toISOString()`, `comment.edited_at && ' · edited'` rendered |
| 6 | User can delete their comment (hard or soft depending on replies) | VERIFIED | CommentsSection.tsx lines 211-215: `hasReplies` check, soft-delete via `.update({ is_deleted: true, text: null })`, hard-delete via `.delete()`, `[Comment deleted]` placeholder at line 279 |
| 7 | User can reply to a comment with single-level threading | VERIFIED | CommentsSection.tsx: `replyingTo` state, `repliesByParent` useMemo grouping, `parent_comment_id` sent on insert, Reply button gated to `!isReply && !comment.is_deleted`, reply mode chip with `Replying to @{replyingTo.username}` |

**Score:** 7/7 truths verified (automated)

---

## Required Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `supabase/migrations/004_comment_threading.sql` | Schema: 3 columns, NOT NULL drop, partial index, RLS UPDATE | VERIFIED | All 6 statements present; 46-line file with complete migration |
| `src/lib/types.ts` | ReviewComment interface with new fields; Insert type updated | VERIFIED | Lines 112-114 have all 3 new fields; line 287 has correct Insert omissions with optional `parent_comment_id` |
| `src/lib/queries.ts` | Both comment count queries filter `is_deleted = false` | VERIFIED | Lines 486 and 580 both have `.eq('is_deleted', false)` |
| `src/components/rating/CommentsSection.tsx` | Full edit/delete/reply UI, min 500 lines | VERIFIED | 800 lines; all required state, handlers, and rendering patterns confirmed |

---

## Key Link Verification

| From | To | Via | Status | Details |
|------|----|-----|--------|---------|
| `src/lib/types.ts` | `004_comment_threading.sql` | TypeScript interface mirrors DB columns | VERIFIED | All 3 new columns reflected in ReviewComment interface |
| `src/lib/queries.ts` | `review_comments` | `is_deleted` filter on count queries | VERIFIED | Both feed functions have `.eq('is_deleted', false)` |
| `CommentsSection.tsx` | `review_comments` | Supabase UPDATE for edit | VERIFIED | Line 202-203: `.from('review_comments').update({ text: ..., edited_at: ... })` |
| `CommentsSection.tsx` | `review_comments` | Supabase UPDATE for soft-delete | VERIFIED | Line 213: `.from('review_comments').update({ is_deleted: true, text: null })` |
| `CommentsSection.tsx` | `review_comments` | Hard delete | VERIFIED | Line 215: `.from('review_comments').delete()` |
| `CommentsSection.tsx` | `review_comments` | INSERT with `parent_comment_id` for replies | VERIFIED | Lines 226-233: conditional `insertPayload.parent_comment_id = replyingTo.commentId` |
| `CommentsSection.tsx` | `review_comments` | SELECT includes new columns | VERIFIED | Line 102: `.select('id, text, created_at, user_id, parent_comment_id, is_deleted, edited_at')` |

---

## Requirements Coverage

| Requirement | Source Plan | Description | Status | Evidence |
|-------------|------------|-------------|--------|----------|
| COMM-01 | 08-01, 08-02 | User can edit their own comment (shows "edited" marker after edit) | VERIFIED | UPDATE with `edited_at`, RLS UPDATE policy, `edited_at && ' · edited'` rendered in CommentsSection.tsx |
| COMM-02 | 08-01, 08-02 | User can delete their own comment | VERIFIED | Hard-delete and soft-delete paths both present; `[Comment deleted]` placeholder for soft-delete |
| COMM-03 | 08-01, 08-02 | User can reply to a comment (single-level threading, Instagram style) | VERIFIED | `parent_comment_id` schema column, INSERT payload with parent_comment_id, `repliesByParent` grouping, Reply button on top-level only, indented reply rows with accent border |

All 3 phase requirements (COMM-01, COMM-02, COMM-03) are claimed by plans 08-01 and 08-02 and have supporting implementation evidence.

No orphaned requirements — REQUIREMENTS.md traceability table maps only COMM-01, COMM-02, COMM-03 to Phase 8, all accounted for.

---

## Anti-Patterns Found

No blockers or stubs detected.

| File | Pattern | Severity | Impact |
|------|---------|----------|--------|
| None | — | — | — |

CommentsSection.tsx at 800 lines is substantive (plan required min 500). No `TODO`, `FIXME`, `placeholder`, `return null`, or stub implementations found in the critical paths.

---

## Human Verification Required

### 1. Edit flow

**Test:** Open a review with your own comment. Tap the three-dot menu. Tap Edit. Modify the text. Tap Save.
**Expected:** Comment text updates immediately; timestamp area shows " · edited" after save.
**Why human:** Inline textarea rendering and "edited" marker placement require visual confirmation.

### 2. Delete (no replies)

**Test:** Post a fresh comment with no replies. Tap three-dot, Delete, confirm.
**Expected:** Comment disappears from the list immediately (hard delete path).
**Why human:** UI removal behavior requires interactive testing.

### 3. Delete (with replies)

**Test:** Find or create a comment that has at least one reply. Delete the parent comment.
**Expected:** Row stays in the list showing "[Comment deleted]" in italic, dim text. Replies remain visible underneath.
**Why human:** Soft-delete placeholder and reply persistence require visual confirmation.

### 4. Reply flow

**Test:** Tap Reply on a top-level comment. Type a reply and post.
**Expected:** "Replying to @username X" chip appears above input while composing. After posting, reply appears indented under the parent with a left accent border and a smaller avatar (22px vs 28px).
**Why human:** Visual styling of reply chip, indentation, border, and avatar size cannot be confirmed from code alone.

### 5. Single-level enforcement

**Test:** Look at a reply comment in the list.
**Expected:** No Reply button appears on reply rows — only top-level comments have the Reply button.
**Why human:** Requires visual inspection of rendered reply rows.

### 6. Owner-only three-dot menu

**Test:** View a review comment posted by a different user.
**Expected:** No three-dot menu or long-press menu appears on their comment.
**Why human:** Requires testing with a comment that belongs to another account.

### 7. State reset on sheet close

**Test:** Start editing a comment (edit mode active). Close the bottom sheet. Reopen the same review's comments.
**Expected:** Edit mode is gone — no textarea visible, no stale state.
**Why human:** Sheet close/open lifecycle behavior requires interactive testing.

### 8. Feed count excludes deleted comments

**Test:** Note the comment count on a feed card. Delete one of the review's comments (hard or soft). Return to the feed.
**Expected:** The count decreases by 1 (or refreshes to the correct lower number).
**Why human:** Requires observing the feed count update after a mutation.

---

## Summary

Phase 8 goal is structurally achieved. The schema foundation (migration 004), TypeScript types, query filters, and the full CommentsSection.tsx UI (edit, delete, reply) are all present, substantive, and correctly wired. All three COMM requirements have complete implementation evidence.

No gaps were found in the automated verification. The remaining open items are visual and interactive behaviors that cannot be confirmed from static code analysis. All 8 human verification items are standard browser tests — none represent missing code.

---

_Verified: 2026-03-23_
_Verifier: Claude (gsd-verifier)_

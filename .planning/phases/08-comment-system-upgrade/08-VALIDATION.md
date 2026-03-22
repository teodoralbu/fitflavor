---
phase: 8
slug: comment-system-upgrade
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-22
---

# Phase 8 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | none — zero test coverage (accepted tech debt) |
| **Config file** | none |
| **Quick run command** | `npx tsc --noEmit` |
| **Full suite command** | `npx tsc --noEmit && npx next build` |
| **Estimated runtime** | ~30 seconds |

---

## Sampling Rate

- **After every task commit:** Run `npx tsc --noEmit`
- **After every plan wave:** Run `npx tsc --noEmit && npx next build`
- **Before `/gsd:verify-work`:** Full suite must be green
- **Max feedback latency:** 30 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 08-01-01 | 01 | 1 | COMM-01, COMM-02, COMM-03 | type-check | `npx tsc --noEmit` | ✅ | ⬜ pending |
| 08-01-02 | 01 | 1 | COMM-01, COMM-02, COMM-03 | type-check | `npx tsc --noEmit` | ✅ | ⬜ pending |
| 08-02-01 | 02 | 2 | COMM-01, COMM-02 | type-check | `npx tsc --noEmit` | ✅ | ⬜ pending |
| 08-02-02 | 02 | 2 | COMM-03 | type-check | `npx tsc --noEmit` | ✅ | ⬜ pending |
| 08-03-01 | 03 | 3 | COMM-01, COMM-02, COMM-03 | type-check | `npx tsc --noEmit` | ✅ | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

Existing infrastructure covers all phase requirements — no new test framework needed. TypeScript type-check (`npx tsc --noEmit`) is the automated feedback mechanism for every task.

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Edit own comment inline | COMM-01 | No test suite | Open review, tap ⋮ on own comment, verify bubble becomes editable text field, save, verify "edited" marker appears after timestamp |
| Delete comment with no replies | COMM-02 | No test suite | Post a comment, tap ⋮, delete, verify comment disappears from list immediately |
| Delete comment with replies | COMM-02 | No test suite | Post a comment, reply to it, delete parent, verify "[Comment deleted]" placeholder shows while replies remain |
| Reply to top-level comment | COMM-03 | No test suite | Tap "Reply" on a comment, verify "Replying to @username ×" chip appears, post reply, verify it appears indented under parent |
| Three-dot menu owner-only | COMM-01, COMM-02 | No test suite | View another user's comment, verify no ⋮ button appears |
| Long-press to edit/delete | COMM-01, COMM-02 | No test suite | Long-press own comment bubble, verify options appear |
| Supabase RLS: edit own comment | COMM-01 | DB-level auth | Use Supabase dashboard or anon client to attempt editing another user's comment — should fail with RLS policy error |
| Supabase RLS: delete own comment | COMM-02 | DB-level auth | Attempt soft-delete of another user's comment via direct Supabase call — should fail |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 30s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending

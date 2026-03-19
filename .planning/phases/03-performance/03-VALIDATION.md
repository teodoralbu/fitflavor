---
phase: 03
slug: performance
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-19
---

# Phase 03 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | None (zero test coverage, accepted for this milestone) |
| **Config file** | none |
| **Quick run command** | `npm run build` |
| **Full suite command** | `npm run build && npm run lint` |
| **Estimated runtime** | ~30-60 seconds |

> Build check catches type errors from refactoring. Manual verification covers runtime behavior.

---

## Sampling Rate

- **After every task commit:** `npm run build` (ensures no TypeScript errors from refactoring)
- **After every plan wave:** `npm run build && npm run lint`
- **Before `/gsd:verify-work`:** Build green + manual verification of all 5 PERF requirements
- **Max feedback latency:** ~60 seconds (build time)

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 03-01-01 | 01 | 1 | PERF-04 | build | `npm run build` | ✅ | ⬜ pending |
| 03-01-02 | 01 | 1 | PERF-01 | build | `npm run build` | ✅ | ⬜ pending |
| 03-02-01 | 02 | 1 | PERF-02 | build | `npm run build` | ✅ | ⬜ pending |
| 03-03-01 | 03 | 2 | PERF-05 | build | `npm run build` | ✅ | ⬜ pending |
| 03-03-02 | 03 | 2 | PERF-03 | build | `npm run build` | ✅ | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

None — no test infrastructure in this milestone by design (deferred to next milestone). Validation is build-check + manual verification.

*Existing infrastructure: `npm run build` covers TypeScript and compilation correctness.*

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Feed loads faster | PERF-01 | Runtime performance — no automated benchmark | Compare dev server response time before/after in Network tab |
| No layout shift on images | PERF-02 | Visual CLS — cannot be asserted via grep | Open feed in Chrome, check no image placeholder jumps |
| No N+1 queries | PERF-04 | Requires Supabase dashboard logs | Check query count in Supabase logs after loading feed |
| Pagination loads more | PERF-05 | Runtime scroll behavior | Scroll to bottom of feed, verify new items appear |
| No layout thrash | PERF-03 | Chrome DevTools Performance tab | Record feed scroll, verify no forced reflows |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 60s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending

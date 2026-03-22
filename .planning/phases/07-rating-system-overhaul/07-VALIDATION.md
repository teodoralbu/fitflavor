---
phase: 7
slug: rating-system-overhaul
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-22
---

# Phase 7 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | None — test suite deferred to v2 per project decision |
| **Config file** | none |
| **Quick run command** | Manual browser smoke test |
| **Full suite command** | Manual walkthrough of all 4 RATE requirements |
| **Estimated runtime** | ~10 minutes manual |

---

## Sampling Rate

- **After every task commit:** Manual smoke test in browser (submit a rating, check the relevant screen)
- **After every plan wave:** Full manual walkthrough of all 4 requirements
- **Before `/gsd:verify-work`:** All 4 success criteria verified manually

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Manual Steps | Status |
|---------|------|------|-------------|-----------|--------------|--------|
| DB migration | 01 | 1 | RATE-01/02/03/04 | manual | Check Supabase: ratings table has schema_version, price_paid, value_score columns | ⬜ pending |
| Constants update | 01 | 1 | RATE-01 | manual | RatingForm shows 3 sliders: Flavor, Pump, Energy & Focus (not 5 old dims) | ⬜ pending |
| Types update | 01 | 1 | RATE-01/02/03/04 | manual | TypeScript build passes with no type errors | ⬜ pending |
| RatingForm sliders | 02 | 2 | RATE-01 | manual | Submit rating with 3 new sliders; check Supabase row has scores: {flavor, pump, energy_focus} | ⬜ pending |
| RatingForm price input | 02 | 2 | RATE-02 | manual | Price field visible on form; submit with price; check Supabase row has price_paid | ⬜ pending |
| Value score calc | 02 | 2 | RATE-03 | manual | Submit with price for product with servings_per_container; check Supabase row has value_score (non-null) | ⬜ pending |
| ReviewCard value pill | 03 | 3 | RATE-03 | manual | Expand a v2 review card; see 4 pills: Flavor, Pump, Energy & Focus, Value | ⬜ pending |
| Feed filtering | 03 | 3 | RATE-04 | manual | Home feed shows no old reviews (pills only show 3 new dimensions) | ⬜ pending |
| Flavor page filtering | 03 | 3 | RATE-04 | manual | Flavor/product page reviews section empty or shows only v2 reviews | ⬜ pending |
| Leaderboard filtering | 03 | 3 | RATE-04 | manual | Leaderboard scores derived only from v2 ratings | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

No test infrastructure needed — test suite deferred to v2 per project decision. All verification is manual.

*Existing infrastructure covers all phase requirements (manual verification only).*

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| 3 new dimension sliders render | RATE-01 | No test suite | Open /rate/[any-slug], verify 3 sliders: Flavor, Pump, Energy & Focus |
| Old 5 dimensions gone from form | RATE-01 | No test suite | Open /rate/[any-slug], confirm no taste/sweetness/intensity sliders |
| Price input field present | RATE-02 | No test suite | Open /rate/[any-slug], verify $ price field after dimension sliders |
| Price stored in DB | RATE-02 | No test suite | Submit rating with price; check Supabase ratings row for price_paid value |
| Value score calculated on submit | RATE-03 | No test suite | Submit rating with price for product that has servings_per_container; verify value_score non-null in DB |
| Value pill in ReviewCard | RATE-03 | No test suite | Expand a v2 review in feed; see Value pill after Flavor/Pump/Energy & Focus |
| No value pill without price | RATE-03 | No test suite | Expand a v2 review submitted without price; confirm no Value pill shown |
| Old reviews hidden from feed | RATE-04 | No test suite | Check home feed — no reviews with taste/sweetness/intensity pills visible |
| Old reviews hidden from flavor page | RATE-04 | No test suite | Open any flavor page — reviews section shows no v1 reviews |
| Old reviews hidden from leaderboard | RATE-04 | No test suite | Check leaderboard — scores reflect only v2 ratings |
| Badge count unchanged | (XP) | No test suite | Check user profile badge tier — still counts all ratings including v1 |

---

## Validation Sign-Off

- [ ] All tasks have manual verification steps defined
- [ ] All 4 RATE requirement IDs verified manually before phase completion
- [ ] No v1 reviews visible in any display surface (feed, flavor page, leaderboard)
- [ ] TypeScript build passes (no type errors from new columns)
- [ ] Value score nil when price not entered or servings_per_container is null
- [ ] `nyquist_compliant: true` set in frontmatter when all checks pass

**Approval:** pending

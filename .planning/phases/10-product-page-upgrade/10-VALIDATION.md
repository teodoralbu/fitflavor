---
phase: 10
slug: product-page-upgrade
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-23
---

# Phase 10 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | vitest (existing) |
| **Config file** | vitest.config.ts (or equivalent in project root) |
| **Quick run command** | `npm run test` |
| **Full suite command** | `npm run test` |
| **Estimated runtime** | ~30 seconds |

---

## Sampling Rate

- **After every task commit:** Run `npm run test`
- **After every plan wave:** Run `npm run test`
- **Before `/gsd:verify-work`:** Full suite must be green
- **Max feedback latency:** 30 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 10-01-01 | 01 | 1 | PROD-01 | migration | `npx prisma migrate dev --name add_nutrition_fields` | ✅ | ⬜ pending |
| 10-01-02 | 01 | 1 | PROD-01 | unit | `npm run test` | ✅ | ⬜ pending |
| 10-02-01 | 02 | 2 | PROD-02 | manual | visual inspection | ❌ W0 | ⬜ pending |
| 10-02-02 | 02 | 2 | PROD-03 | manual | visual inspection | ❌ W0 | ⬜ pending |
| 10-02-03 | 02 | 2 | PROD-04 | manual | visual inspection | ❌ W0 | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- Existing test infrastructure covers automated checks (migration, type safety)
- UI/visual behaviors require manual verification (hero image, label modal, nutrition switcher)

*If none: "Existing infrastructure covers all phase requirements."*

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Hero image displays at top of product page | PROD-02 | Visual layout | Open product page, verify large image at top |
| Label modal shows ingredients/sweeteners/chemicals | PROD-03 | UI interaction | Tap label button, verify modal opens with full details |
| Nutrition switcher toggles per scoop/serving/100g | PROD-04 | UI interaction | Tap each segment, verify values update correctly |
| Nutritional display is polished and scannable | PROD-04 | Subjective visual | Review layout, spacing, and readability |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 30s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending

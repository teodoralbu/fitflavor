# GymTaste

## What This Is

GymTaste is a gym supplement review platform where users rate and review protein powders, pre-workouts, and other gym products by flavor. Users build reputation through reviews, follow other reviewers, like and comment on reviews, and browse an infinite-scroll feed of community ratings.

v1.0 shipped a full mobile-first polish pass: touch targets, bug fixes, query optimization, image performance, infinite scroll pagination, skeleton loading states, keyboard accessibility, WCAG AA contrast, and upload security hardening.

## Core Value

Users can confidently discover and rate gym supplement flavors through a fast, polished mobile experience — so every interaction feels intentional, not broken.

## Requirements

### Validated

- ✓ Core rating flow (rate a product flavor with scores) — existing
- ✓ Feed of community reviews — existing
- ✓ User profiles and reputation system — existing
- ✓ Follow system — existing
- ✓ Comments and likes on reviews — existing
- ✓ Product/brand/flavor detail pages — existing
- ✓ Auth (login, signup, session management) — existing
- ✓ Avatar upload and settings — existing
- ✓ Admin product management — existing
- ✓ Leaderboard (products and users) — existing
- ✓ Dark/light theme — existing
- ✓ Mobile UX overhaul — 44px touch targets, feed overflow, rating form layout — v1.0
- ✓ Systematic bug fixes — auth middleware, rating dedup, comment count, avatar upload — v1.0
- ✓ Performance — parallelized queries, next/image, cursor-based infinite scroll — v1.0
- ✓ Code quality — as-any removed from critical paths, error handling in queries.ts — v1.0 (partial)
- ✓ UX/accessibility — skeleton states, empty states, focus rings, WCAG AA contrast, alt text — v1.0
- ✓ Upload security — MIME type + size validation on RatingForm and AvatarUpload — v1.0

### Active

- [ ] Profile/settings mobile layout polish (MOB-04) — deferred from v1.0
- [ ] Page transition smoothness (MOB-05) — deferred from v1.0
- [ ] Remove remaining `as any` casts (26 total, mostly feed/admin/sitemap) — deferred from v1.0
- [ ] Standardize error handling across all pages — deferred from v1.0

### Out of Scope

- New features (social sharing, notifications, etc.) — focus is quality, not scope
- Test suite setup — deferred, not blocking launch
- Search indexing — deferred
- Offline/PWA support — deferred
- Leaderboard materialized view — deferred (bounded query in place as stopgap)

## Context

- v1.0 shipped 2026-03-21 — 5 phases, 15 plans, 115 files changed
- Next.js 16 App Router + Supabase (no framework changes planned)
- 26 remaining `as any` casts — down from 111+; critical paths are now typed
- Zero test coverage — accepted tech debt for launch
- Feed uses cursor-based infinite scroll with skeleton loading
- All file uploads validated (MIME type + size) before reaching Supabase Storage

## Constraints

- **Tech stack**: Next.js 16 + Supabase — no framework changes
- **Deployment**: Vercel — no infrastructure changes
- **Scope**: Polish and fix existing features only — no new features until v1.1

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Mobile UX first | Pre-launch priority; most users will be on mobile | ✓ Good — set the right foundation |
| Skip test suite for now | Not blocking launch; address in next milestone | ✓ Good — shipped faster, debt is contained |
| Quality model profile | Auditing/debugging benefits from deeper analysis | ✓ Good — caught subtle issues |
| Bounded leaderboard query (2000 rows) | Quick stopgap instead of materialized view | ⚠ Revisit — will degrade at scale |
| Skip MOB-04/05, QUAL-01/02 for v1.0 | Not blocking launch, cosmetic/dev-hygiene | ✓ Good — right call, ship now |

---
*Last updated: 2026-03-21 after v1.0 milestone*

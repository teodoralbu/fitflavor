# GymTaste — Pre-Launch Quality Milestone

## What This Is

GymTaste is a gym supplement review platform where users rate and review protein powders, pre-workouts, and other gym products by flavor. Users build reputation through reviews, follow other reviewers, like and comment on reviews, and browse a feed of community ratings.

This milestone focuses on getting the app production-ready before launch: overhauling the mobile experience, systematically hunting and fixing bugs, improving performance, and auditing code quality.

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

### Active

- [ ] Mobile UX overhaul — all mobile surfaces feel polished (navigation, layout, onboarding, performance)
- [ ] Systematic bug hunt — discover and fix all broken flows across the app
- [ ] Performance improvements — fix slow pages, N+1 queries, missing pagination
- [ ] Code quality — reduce `as any` type casts, improve TypeScript safety
- [ ] UX/accessibility audit — identify and fix usability and a11y issues

### Out of Scope

- New features (social sharing, notifications, etc.) — focus is quality, not scope
- Test suite setup — deferred, not blocking launch
- Search indexing — deferred
- Offline/PWA support — deferred

## Context

- App is not yet live; no real users
- Codebase is brownfield Next.js 16 App Router + Supabase
- 111+ `as any` type assertions — TypeScript safety largely bypassed
- Zero test coverage across 62 source files
- Known performance issues: leaderboard full-table scans, no feed pagination
- Missing file upload validation on avatar upload
- Mobile UX is the top priority — fix mobile first, then bugs and performance

## Constraints

- **Tech stack**: Next.js 16 + Supabase — no framework changes
- **Deployment**: Vercel (assumed) — no infrastructure changes
- **Scope**: Polish and fix existing features only — no new features

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Mobile UX first | Pre-launch priority; most users will be on mobile | — Pending |
| Skip test suite for now | Not blocking launch; address in next milestone | — Pending |
| Quality model profile | Auditing/debugging benefits from deeper analysis | — Pending |

---
*Last updated: 2026-03-18 after initialization*

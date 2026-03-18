# Testing: GymTaste

## Current Status

**No testing framework implemented.**

- 62 source files, 0 test files
- No Jest, Vitest, Playwright, or Testing Library installed
- No test script in `package.json`
- Quality relies on: TypeScript strict mode + ESLint + Next.js build validation

## High-Risk Untested Areas

| File | Lines | Risk |
|------|-------|------|
| `src/app/page.tsx` | ~761 | Main feed — complex query + rendering |
| `src/components/RatingForm.tsx` | ~523 | Core user action — form validation, submission |
| `src/lib/queries.ts` | ~420 | All DB queries — data integrity |
| `src/components/CommentSection.tsx` | ~344 | Comments CRUD |
| `src/components/FeedCard.tsx` | ~403 | Feed rendering |
| `src/context/AuthContext.tsx` | — | Auth state — sign-in/sign-up flows |

## Recommended Testing Approach (if added)

### Unit Tests
- Pure functions in `src/lib/utils.ts` (e.g., `timeAgo`, score calculations)
- Constants and config in `src/lib/constants.ts`
- Badge tier logic in `src/lib/badges.ts`

### Component Tests
- `RatingForm` — form validation, submission states
- `FeedCard` — rendering with various data shapes
- `CommentSection` — add/delete comment flows

### Context Tests
- `AuthContext` — sign in, sign out, session persistence
- `ThemeContext` — theme switching

### Integration Tests
- DB queries in `src/lib/queries.ts` against test Supabase instance
- Server actions end-to-end

## Recommended Stack

```
vitest + @testing-library/react + @testing-library/user-event
playwright (E2E)
```

---
*Mapped: 2026-03-18*

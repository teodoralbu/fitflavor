# Technical Concerns: GymTaste

## Tech Debt

### TypeScript Safety — HIGH
- **111+ instances** of `as any` type assertions throughout the codebase
- Disables type checking on Supabase query results
- Fragile: runtime errors won't be caught at compile time
- **Files affected:** `src/lib/queries.ts`, `src/components/rating/RatingForm.tsx`, most page components
- **Fix:** Generate typed Supabase client from schema; use proper return types

### Untyped Error Handling
- Error values caught as `unknown` then cast to `any`
- No consistent error type across the app
- `src/lib/queries.ts` returns `{ error: string | null, data?: T }` inconsistently

### Loose Null Coalescing
- Excessive `??` with empty-string defaults masks missing data
- Should distinguish "not loaded" from "empty"

---

## Security

### Missing File Upload Validation — MEDIUM
- `src/components/user/AvatarUpload.tsx` — no file type/size validation before upload
- Users could upload non-image files to storage
- **Fix:** Validate MIME type and size client-side before sending to Supabase

### Unvalidated Redirect Parameters — MEDIUM
- Login/signup redirects may pass `next` param without sanitization
- **File:** `src/app/login/page.tsx`, `src/app/signup/page.tsx`
- **Fix:** Whitelist allowed redirect paths

### Hardcoded Storage Bucket Names
- Storage bucket names hardcoded as strings across components
- Any rename breaks silently at runtime
- **Fix:** Centralize in `src/lib/constants.ts`

### No Rate Limiting
- Rating form, comments, and auth endpoints have no rate limiting
- Abuse possible via repeated rapid submissions
- **Fix:** Supabase RLS policies + server-side throttling

---

## Performance

### Full Table Scans for Leaderboard — HIGH
- `src/app/leaderboard/page.tsx` aggregates ratings in-memory
- Will degrade significantly beyond ~10k records
- **Fix:** Materialized view or pre-computed scores in DB

### N+1 Query Patterns — MEDIUM
- Feed fetching in `src/app/page.tsx` may make per-card queries
- **Fix:** Join queries in `src/lib/queries.ts`

### Sitemap Generation at Scale
- `src/app/sitemap.ts` fetches up to 1000 records per request
- No caching; regenerates on each crawl
- **Fix:** Cache sitemap or generate statically

### No Pagination on Main Feed
- `src/app/page.tsx` loads all feed items
- Will become slow as data grows
- **Fix:** Cursor-based pagination or infinite scroll

### Avatar Compression on Main Thread
- `src/components/user/AvatarUpload.tsx` compresses images synchronously
- May block UI on low-end devices
- **Fix:** Web Worker or server-side resizing

---

## Fragile Areas

### RatingForm (~523 lines) — HIGH RISK
- Core user action with no tests
- Complex form state with multiple scoring dimensions
- Submission failure leaves no recovery path for user

### Auth Context
- `src/context/auth-context.tsx` — session state shared app-wide
- Auth errors may not surface clearly to users
- No session refresh handling visible

### CommentsSection / FeedCard
- Large components with no tests
- Mixed concerns (data fetching + rendering)

---

## Scaling Limits

| Concern | Limit | Fix |
|---------|-------|-----|
| Leaderboard aggregation | ~200k ratings before timeout | Materialized view |
| Single Supabase instance | Connection pool limits | Read replicas |
| Image storage | No CDN in front | Cloudflare or Supabase CDN |
| Feed pagination | Not implemented | Cursor pagination |

---

## Missing Infrastructure

- **No monitoring:** No error tracking (Sentry, etc.), no analytics
- **No logging:** Server errors not captured
- **No offline support:** No service worker / PWA caching
- **No search indexing:** Search is likely full-text scan

---

## Zero Test Coverage

- 62 source files, 0 test files
- See TESTING.md for full assessment and recommended approach

---
*Mapped: 2026-03-18*

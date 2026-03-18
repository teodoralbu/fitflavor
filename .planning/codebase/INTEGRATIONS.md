# External Integrations

**Analysis Date:** 2026-03-18

## APIs & External Services

**Supabase (Primary Backend):**
- Real-time PostgreSQL database
- Authentication (email/password)
- File storage (buckets for images)
- Full integration across application

## Data Storage

**Databases:**
- PostgreSQL via Supabase
  - Connection: Environment variables `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY`
  - Client: `@supabase/supabase-js` v2.99.1
  - Type-safe: TypeScript types generated in `src/lib/types.ts`

**Tables:**
- `users` - User profiles with badges and stats
- `brands` - Supplement brand names and logos
- `categories` - Product categories with rating dimensions
- `products` - Supplement products with nutritional info
- `flavors` - Flavor variants of products
- `flavor_tags` - Tags describing flavor profiles
- `ratings` - User ratings and reviews with scores
- `review_likes` - Like tracking for reviews
- `review_comments` - Comments on reviews
- `follows` - User follow relationships
- `reports` - Content report submissions
- `product_submissions` - User-submitted new products

**File Storage:**
- Supabase Storage buckets (S3-compatible)
  - `review-photos` - Photos attached to ratings and avatars
  - `rep-photo` - Progress photos for rep tracking
  - Product images stored in `products.image_url`
  - Brand logos stored in `brands.logo_url`

**Caching:**
- Not detected - No Redis or caching layer

## Authentication & Identity

**Auth Provider:**
- Supabase Auth (managed authentication)
  - Implementation: Email/password authentication
  - Session management: Cookie-based via `@supabase/ssr`
  - User context: Global React Context (`src/context/auth-context.tsx`)

**Client Integration:**
- Browser client: `createClient()` from `src/lib/supabase.ts`
  - Uses `createBrowserClient` from `@supabase/ssr`
  - Placeholder values for missing env vars (prevents crashes)
  - Configured via `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY`

**Server Integration:**
- Server client: `createServerSupabaseClient()` from `src/lib/supabase-server.ts`
  - Uses `createServerClient` from `@supabase/ssr`
  - Manages cookies for server-side requests
  - Used in Server Components and Server Actions

**Auth Flows:**
- Sign Up: Email/password + auto-create user profile with username
- Sign In: Email/password with profile pre-fetch
- Sign Out: Session invalidation
- Auth State: Listener on `supabase.auth.onAuthStateChange()`

## Monitoring & Observability

**Error Tracking:**
- Not detected - No Sentry, Rollbar, or similar

**Logs:**
- Console logging used in browser
- Server-side: Likely forwarded to deployment platform (Vercel)

**Performance Monitoring:**
- Not detected

## CI/CD & Deployment

**Hosting:**
- Inferred: Vercel (standard for Next.js)
- Alternative: Any Node.js host supporting Next.js

**CI Pipeline:**
- Not detected - No GitHub Actions, GitLab CI, or similar configured

**Database Migrations:**
- Supabase CLI migrations in `supabase/migrations/` directory
- Seed data: `supabase/seed.sql` (57KB, populated via Supabase)

## Environment Configuration

**Required env vars:**
- `NEXT_PUBLIC_SUPABASE_URL` - Supabase project URL (required for auth/db)
- `NEXT_PUBLIC_SUPABASE_ANON_KEY` - Anonymous API key (required for auth/db)

**Optional env vars:**
- `NEXT_PUBLIC_SITE_URL` - Site URL for metadata (defaults to `https://gymtaste.app`)

**Secrets location:**
- Development: `.env.local` file (git-ignored)
- Production: Deployment platform environment variables (Vercel, etc.)

**Safety Measures:**
- `src/lib/supabase.ts` validates env vars with placeholders to prevent crashes on missing config
- Only public keys exposed in browser (`NEXT_PUBLIC_` prefix)
- Server-side operations use same public key (row-level security enforced in Supabase)

## Webhooks & Callbacks

**Incoming:**
- Not detected - No webhook endpoints

**Outgoing:**
- Supabase realtime subscriptions (for user activity changes)
- Auth state change listener in `src/context/auth-context.tsx`

## Data Flow

**User Authentication:**
1. User submits email/password on login or signup page
2. Supabase Auth validates credentials
3. Session token stored in cookies (via `@supabase/ssr`)
4. Browser client and Server Components share session via cookies
5. User profile auto-fetched from `users` table

**Product/Flavor Data:**
1. Server Components fetch products/flavors from database (SSR)
2. Data queried with joins to brands, tags, and rating stats
3. Query functions in `src/lib/queries.ts` handle complex joins

**File Uploads:**
1. Client-side compression in browser
2. Upload to Supabase Storage bucket
3. URL retrieval via `getPublicUrl()`
4. URL saved to database record

**Rating Submission:**
1. Form submission via client component
2. Photo upload to `review-photos` bucket
3. Rating record created with photo URL
4. User profile badge tier updated based on activity

## Service Integration Points

**File Locations:**
- Auth: `src/context/auth-context.tsx`
- Supabase clients: `src/lib/supabase.ts`, `src/lib/supabase-server.ts`
- Database queries: `src/lib/queries.ts`
- Type definitions: `src/lib/types.ts` (auto-generated from schema)
- Server actions: `src/app/*/actions.ts` files
- Storage operations: Inline in components (`src/app/rep/page.tsx`, `src/app/settings/page.tsx`, `src/components/rating/RatingForm.tsx`)

---

*Integration audit: 2026-03-18*

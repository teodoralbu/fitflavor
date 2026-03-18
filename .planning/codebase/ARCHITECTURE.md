# Architecture: GymTaste

## Pattern

**Next.js App Router — full-stack monolith**

Server Components by default; client components opt-in with `"use client"`. Server Actions handle all mutations. No separate API layer — Supabase SDK called directly from server components and actions.

## Layers

```
Browser
  └─ Client Components (forms, interactive UI, context consumers)
       └─ Context Providers (Auth, Theme, Toast)

Next.js Server
  ├─ Server Components (data fetching, page rendering)
  ├─ Server Actions (mutations via `"use server"`)
  └─ Route Handlers (if any)

Supabase (BaaS)
  ├─ PostgreSQL (relational data)
  ├─ Auth (sessions, JWT)
  └─ Storage (product images, user avatars)
```

## Entry Points

| Route | File | Purpose |
|-------|------|---------|
| `/` | `src/app/page.tsx` | Main feed — most complex page (~761 lines) |
| `/rate` | `src/app/rate/page.tsx` | Product search to initiate rating |
| `/rate/[slug]` | `src/app/rate/[slug]/page.tsx` | Rating form for a specific product |
| `/flavors/[slug]` | `src/app/flavors/[slug]/page.tsx` | Flavor detail page |
| `/products/[slug]` | `src/app/products/[slug]/page.tsx` | Product detail page |
| `/brands/[slug]` | `src/app/brands/[slug]/page.tsx` | Brand page |
| `/browse` | `src/app/browse/page.tsx` | Browse all products |
| `/search` | `src/app/search/page.tsx` | Search |
| `/leaderboard` | `src/app/leaderboard/page.tsx` | Top-rated products |
| `/rep` | `src/app/rep/page.tsx` | User reputation/leaderboard |
| `/users/[username]` | `src/app/users/[username]/page.tsx` | User profile |
| `/settings` | `src/app/settings/page.tsx` | User settings + avatar upload |
| `/notifications` | `src/app/notifications/page.tsx` | User notifications |
| `/login` | `src/app/login/page.tsx` | Auth |
| `/signup` | `src/app/signup/page.tsx` | Auth |
| `/admin/products` | `src/app/admin/products/page.tsx` | Admin product management |

## Data Flow

### Read path (server component)
```
Page Component (RSC)
  → src/lib/queries.ts (query functions)
  → Supabase SDK (createServerClient with cookies)
  → PostgreSQL
  → Props passed to child components
```

### Write path (server action)
```
Client Component (form submit)
  → Server Action ("use server")
  → Supabase SDK
  → PostgreSQL / Storage
  → revalidatePath() or redirect()
```

### Auth flow
```
src/context/auth-context.tsx (AuthContext)
  → Supabase Auth (client-side session)
  → Used by client components via useAuth()

Server-side auth:
  → createServerClient() reads cookies
  → Direct session check per request
```

## Key Abstractions

| File | Role |
|------|------|
| `src/lib/queries.ts` | All DB read queries (~420 lines) |
| `src/lib/supabase.ts` | Browser Supabase client |
| `src/lib/supabase-server.ts` | Server Supabase client (cookie-based) |
| `src/lib/types.ts` | Shared TypeScript types |
| `src/lib/constants.ts` | App-wide constants (UPPER_SNAKE_CASE) |
| `src/lib/utils.ts` | Pure utility functions |
| `src/lib/timeAgo.ts` | Timestamp formatting |
| `src/context/auth-context.tsx` | Auth state provider |
| `src/context/theme-context.tsx` | Theme (dark/light) provider |
| `src/context/ToastContext.tsx` | Toast notifications provider |

## Component Categories

- **`src/components/ui/`** — Primitive UI: Button, Input, Slider, Card, Modal, Pill, Badge, ThemeToggle
- **`src/components/layout/`** — App chrome: Navbar, BottomNav, Footer, PageContainer, PageTransition
- **`src/components/feed/`** — FeedCard (main feed item)
- **`src/components/rating/`** — RatingForm, ReviewCard, CommentsSection, LikeButton
- **`src/components/user/`** — AvatarUpload, FollowButton
- **`src/components/admin/`** — AdminProductImages

## Root Layout

`src/app/layout.tsx` wraps the app with:
- AuthContext
- ThemeContext
- ToastContext
- Navbar + BottomNav (persistent)
- PageTransition

---
*Mapped: 2026-03-18*

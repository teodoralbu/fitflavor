# Directory Structure: GymTaste

## Top-Level Layout

```
gymtaste/
├── src/
│   ├── app/              # Next.js App Router pages and layouts
│   ├── components/       # Reusable React components
│   ├── context/          # React Context providers
│   └── lib/              # Utilities, queries, and Supabase clients
├── public/               # Static assets
├── .planning/            # GSD planning documents
├── .env.local            # Local environment variables (not committed)
├── .env.example          # Environment variable template
├── next.config.ts        # Next.js configuration
├── tsconfig.json         # TypeScript configuration
├── eslint.config.mjs     # ESLint flat config
├── postcss.config.mjs    # PostCSS (Tailwind) config
└── package.json          # Dependencies and scripts
```

## src/app/ — Pages

```
src/app/
├── layout.tsx                     # Root layout — providers, Navbar, BottomNav
├── page.tsx                       # Home / main feed
├── error.tsx                      # Global error boundary
├── globals.css                    # Global styles + CSS custom properties
├── favicon.ico
├── icon.tsx                       # App icon (programmatic)
├── apple-icon.tsx                 # Apple touch icon
├── manifest.ts                    # PWA manifest
├── robots.ts                      # robots.txt
├── sitemap.ts                     # Dynamic sitemap
│
├── login/page.tsx                 # Login
├── signup/page.tsx                # Sign up
├── settings/page.tsx              # User settings + avatar upload
├── notifications/page.tsx         # User notifications
│
├── rate/
│   ├── page.tsx                   # Rate landing (search for product)
│   ├── RateLanding.tsx            # Client component for rate page
│   ├── RateSearch.tsx             # Search component
│   └── [slug]/
│       ├── page.tsx               # Rating form for product
│       └── success/page.tsx       # Post-rating success
│
├── flavors/[slug]/
│   ├── page.tsx                   # Flavor detail page
│   └── StickyRateCTA.tsx         # Sticky CTA component
│
├── products/[slug]/page.tsx       # Product detail page
├── brands/[slug]/page.tsx         # Brand detail page
├── browse/page.tsx                # Browse all products
├── search/page.tsx                # Search results
├── leaderboard/page.tsx           # Top-rated products
├── rep/page.tsx                   # User reputation leaderboard
├── users/[username]/page.tsx      # User profile
│
├── submit/page.tsx                # Submit new product
├── privacy/page.tsx               # Privacy policy
├── terms/page.tsx                 # Terms of service
│
└── admin/
    └── products/
        ├── page.tsx               # Admin product list
        └── actions.ts             # Admin server actions
```

## src/components/ — UI Components

```
src/components/
├── ui/                            # Primitive UI components
│   ├── Button.tsx
│   ├── Input.tsx
│   ├── Slider.tsx
│   ├── Card.tsx
│   ├── Modal.tsx
│   ├── Pill.tsx
│   ├── Badge.tsx
│   └── ThemeToggle.tsx
│
├── layout/                        # App shell components
│   ├── Navbar.tsx
│   ├── BottomNav.tsx
│   ├── Footer.tsx
│   ├── PageContainer.tsx
│   └── PageTransition.tsx
│
├── feed/
│   └── FeedCard.tsx               # Main feed item card
│
├── rating/
│   ├── RatingForm.tsx             # Core rating submission form
│   ├── ReviewCard.tsx             # Individual review display
│   ├── CommentsSection.tsx        # Comments on a review
│   └── LikeButton.tsx             # Like/unlike a review
│
├── user/
│   ├── AvatarUpload.tsx           # Profile picture upload
│   └── FollowButton.tsx           # Follow/unfollow user
│
└── admin/
    └── AdminProductImages.tsx     # Product image management
```

## src/lib/ — Utilities and Data Access

```
src/lib/
├── queries.ts          # All Supabase read queries (~420 lines)
├── supabase.ts         # Browser Supabase client (createBrowserClient)
├── supabase-server.ts  # Server Supabase client (createServerClient + cookies)
├── types.ts            # Shared TypeScript types
├── constants.ts        # App constants (UPPER_SNAKE_CASE)
├── utils.ts            # Pure utility functions
└── timeAgo.ts          # Relative timestamp formatting
```

## src/context/ — React Context Providers

```
src/context/
├── auth-context.tsx    # Auth state (user, signIn, signOut, signUp)
├── theme-context.tsx   # Dark/light theme
└── ToastContext.tsx    # Toast notification system
```

## Where to Add New Code

| Need | Location |
|------|----------|
| New page | `src/app/[route]/page.tsx` |
| New data query | `src/lib/queries.ts` |
| New server action | Co-locate `actions.ts` next to page, or in `src/app/[route]/actions.ts` |
| New reusable component | `src/components/[category]/ComponentName.tsx` |
| New primitive UI | `src/components/ui/` |
| New context/global state | `src/context/` |
| New utility function | `src/lib/utils.ts` or new `src/lib/[name].ts` |
| New type | `src/lib/types.ts` |

---
*Mapped: 2026-03-18*

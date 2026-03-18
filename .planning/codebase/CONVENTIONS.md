# Codebase Conventions: GymTaste

## File Naming

- **Components:** PascalCase (`FeedCard.tsx`, `RatingForm.tsx`, `CommentSection.tsx`)
- **Utilities/lib:** camelCase (`timeAgo.ts`, `queries.ts`, `utils.ts`)
- **Pages:** Next.js App Router convention — `page.tsx`, `layout.tsx` in route directories

## Functions & Variables

- **Functions:** camelCase throughout (`getProductBySlug()`, `calculateOverallScore()`, `timeAgo()`)
- **Variables:** camelCase
- **Constants:** UPPER_SNAKE_CASE in `src/lib/constants.ts`

## Types & Interfaces

- **Types/Interfaces:** PascalCase (`User`, `FlavorBasic`, `BadgeTier`, `Review`)
- **Defined in:** `src/types/` directory
- **Database types:** Generated Supabase types in `src/types/supabase.ts`; frequently cast to `any` inline

## Import Organization

Order: Next.js → third-party → internal (`@/*` alias) → types

```ts
import { cookies } from 'next/headers'
import { createServerClient } from '@supabase/ssr'
import { getCurrentUser } from '@/lib/auth'
import type { User } from '@/types'
```

Path alias `@/*` maps to `src/*`.

## Error Handling

Tuple/result pattern used in data-fetching utilities:

```ts
{ error: string | null, data?: T }
```

No try/catch in UI components — errors surfaced through state or returned from server actions.

## Styling

- **Method:** Inline styles via `style={{}}` with CSS custom properties
- **Variables:** `var(--text)`, `var(--accent)`, `var(--bg)`, `var(--card)` etc.
- **Responsive:** Tailwind utility classes with mobile-first `sm:` breakpoints
- **No:** CSS modules or styled-components

## Component Patterns

- **Server vs Client:** Mixed — RSC by default, `"use client"` added when needed (forms, state, effects)
- **State management:** Context API for auth/theme/toast; local `useState` for UI state
- **Data fetching:** Server components fetch directly; client components use `useEffect` or form actions

## Database Access

- **Direct Supabase SDK** calls (no ORM)
- Server-side: `createServerClient` with cookie-based auth
- Client-side: `createBrowserClient`
- Queries centralized in `src/lib/queries.ts`

## Linting

- ESLint v9 with flat config (`eslint.config.mjs`)
- Next.js ESLint plugin enabled
- TypeScript strict mode on

---
*Mapped: 2026-03-18*

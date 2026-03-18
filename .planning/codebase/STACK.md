# Technology Stack

**Analysis Date:** 2026-03-18

## Languages

**Primary:**
- TypeScript 5.x - Used for all source code, strict mode enabled
- JSX/TSX - React component syntax for UI

**Secondary:**
- JavaScript - Configuration files (ESLint, PostCSS)

## Runtime

**Environment:**
- Node.js - Primary runtime (version not pinned in package.json)

**Package Manager:**
- npm - Package management
- Lockfile: `package-lock.json` present

## Frameworks

**Core:**
- Next.js 16.1.6 - Full-stack React framework with App Router
  - Server-side rendering for pages in `/src/app`
  - Server Actions for mutations (`'use server'`)
  - API routes support

**UI:**
- React 19.2.3 - Component library
- React DOM 19.2.3 - DOM rendering

**Styling:**
- Tailwind CSS 4.x - Utility-first CSS framework (via `@tailwindcss/postcss`)
- PostCSS 4.x - CSS processing pipeline

**Testing:**
- Not detected - No test framework configured

**Build/Dev:**
- TypeScript compiler - Type checking during build
- ESLint 9.x - Code linting with Next.js config

## Key Dependencies

**Critical:**
- `@supabase/supabase-js` ^2.99.1 - Backend as a service, database, auth, file storage
- `@supabase/ssr` ^0.9.0 - Server-side rendering utilities for Supabase sessions

**Infrastructure:**
- None - No additional infrastructure libraries (no caching, queuing, etc.)

## Configuration

**Environment:**
- `.env.local` file (present - not version controlled)
- `.env.example` file (present - shows required variables)
- Public env vars use `NEXT_PUBLIC_` prefix (accessible in browser)

**Required Environment Variables:**
- `NEXT_PUBLIC_SUPABASE_URL` - Supabase project URL
- `NEXT_PUBLIC_SUPABASE_ANON_KEY` - Supabase anonymous API key
- `NEXT_PUBLIC_SITE_URL` - Optional, defaults to `https://gymtaste.app`

**Build:**
- `next.config.ts` - Minimal Next.js configuration
- `tsconfig.json` - TypeScript configuration with:
  - Target: ES2017
  - Module: esnext
  - JSX: react-jsx
  - Path alias: `@/*` → `./src/*`
- `postcss.config.mjs` - CSS processing with Tailwind
- `eslint.config.mjs` - ESLint configuration using Next.js presets

## Platform Requirements

**Development:**
- Node.js (version unspecified)
- npm or yarn
- Modern browser with JavaScript support

**Production:**
- Node.js runtime
- Deployment: Vercel (inferred from Next.js + Supabase pattern)
- Environment variables set in deployment platform

## Development Scripts

```bash
npm run dev       # Start development server (next dev)
npm run build     # Build for production (next build)
npm start         # Start production server (next start)
npm run lint      # Run ESLint (eslint)
```

---

*Stack analysis: 2026-03-18*

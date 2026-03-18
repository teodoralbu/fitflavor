---
phase: 1
slug: mobile-ux
status: draft
shadcn_initialized: false
preset: none
created: 2026-03-18
---

# Phase 1 -- UI Design Contract

> Visual and interaction contract for the Mobile UX polish phase. This phase preserves the existing design system -- it fixes layouts, touch targets, overflow, and navigation on mobile. No visual redesign.

---

## Design System

| Property | Value |
|----------|-------|
| Tool | none (custom components) |
| Preset | not applicable |
| Component library | custom `src/components/ui/` (Button, Input, Slider, Card, Modal, Pill, Badge, ThemeToggle) |
| Icon library | inline SVGs (no icon library) |
| Font | Inter (Google Fonts, variable `--font-inter`) |

**Phase scope note:** This phase does NOT introduce new design tokens, components, or visual patterns. It fixes the existing mobile experience. All values below document what already exists and must be preserved.

---

## Spacing Scale

### Normative Rules

The executor MUST use values from the standard 8-point scale when writing new or modified spacing:

| Token | Value |
|-------|-------|
| 4px | Micro gaps (e.g. icon-to-label) |
| 8px | Compact element spacing, icon gaps |
| 16px | Screen side padding, default element spacing |
| 24px | Section gaps |
| 32px | Major section breaks |
| 48px | Large vertical separation |
| 64px | Nav height, major layout anchors |

Documented exceptions (acceptable values outside the scale):
- Touch targets: minimum 44x44px hit area on all interactive elements (per MOB-01, MOB-06)
- Bottom nav height: 64px (`--nav-height`)
- Bottom safe area: `env(safe-area-inset-bottom)`
- Page bottom padding: `calc(64px + 24px + env(safe-area-inset-bottom))` for content above bottom nav

The executor MUST NOT introduce new spacing values outside {4, 8, 16, 24, 32, 48, 64} except for the documented exceptions above.

### Existing CSS Variables Reference

> Preserved from existing codebase -- not to be changed in Phase 1, not subject to normalization.

| Token | Value | Usage |
|-------|-------|-------|
| `--space-xs` | 8px | Compact element spacing, icon gaps |
| `--space-sm` | 12px | Tight padding between related elements |
| `--space-md` | 16px | Screen side padding, default element spacing |
| `--space-lg` | 20px | Comfortable padding |
| `--space-xl` | 24px | Section gaps |
| `--space-2xl` | 32px | Major section breaks |
| `--nav-height` | 64px | Bottom navigation bar height |
| `--nav-float-size` | 54px | Floating rate button diameter |

These legacy values (notably `--space-sm: 12px`, `--space-lg: 20px`, `--nav-float-size: 54px`) exist in the codebase and are referenced by existing components. They are preserved as-is in Phase 1 and are NOT subject to the normative spacing rules above. Do not modify or remove them.

---

## Typography

### Normative Rules

The executor MUST enforce these 4 type sizes and 2 weights for any new or modified text styling:

| Role | Size | Weight | Line Height |
|------|------|--------|-------------|
| Body | 14px | 400 (regular) | 1.5 |
| Input | 16px | 400 (regular) | normal |
| Display | 20px | 600 (semibold) | 1.2 |
| Score | 32px | 600 (semibold) | 1.0 |

**Normative weights:** 400 (regular) and 600 (semibold). The executor MUST NOT introduce weights outside these two.

**Mobile-critical rule:** All text inputs MUST use 16px minimum font-size to prevent iOS Safari auto-zoom on focus. This applies to every `<input>`, `<textarea>`, and `<select>` element. Already applied to `.input-search`; must be verified on all form inputs in the rating flow.

### Existing System Reference

> Read-only audit context -- documents what exists in the codebase. These are NOT part of the normative spec contract. The executor should preserve these existing styles where they appear but must not propagate non-normative sizes or weights to new code.

| Role | Size | Weight | Line Height | Source |
|------|------|--------|-------------|--------|
| Body | 14px | 400 | 1.6 | FeedCard review text, captions |
| Label | 13px | 700 | 1.5 | Usernames, experience line, section labels |
| Small | 11px | 600 | 1.0 | Timestamps, tag labels, meta text |
| Input | 15px-16px | 400 | normal | Form inputs (16px on search to prevent iOS zoom) |
| Section title | 17px | 800 | normal | `.m-section-title`, navbar brand |
| Score display | 32px | 900 | 1.0 | Rating score in feed cards |
| PR display | 20px | 900 | normal | Rep card PR values |

These existing values are preserved in Phase 1. The executor should not change them but should not replicate non-normative sizes (11px, 13px, 15px, 17px) or weights (700, 800, 900) in any new or refactored code.

---

## Color

Existing palette (preserved as-is, both themes):

| Role | Dark Value | Light Value | Usage |
|------|------------|-------------|-------|
| Dominant (60%) | `#0D0F14` (`--bg`) | `#F2F3F5` | Page background |
| Secondary (30%) | `#161B22` (`--bg-card`) | `#FFFFFF` | Cards, bottom nav, elevated surfaces |
| Accent (10%) | `#00B4FF` (`--accent`) | `#0095D9` | See reserved list below |
| Destructive | `#FF4444` (`--red`) | `#E03030` | Error states, destructive actions |
| Success | `#00E676` (`--green`) | `#00C060` | "Would buy again" badge, positive scores |
| Warning | `#FFD600` (`--yellow`) | `#E6A800` | Mid-range scores |

Accent reserved for:
- Active bottom nav tab icon and indicator dot
- Floating Rate button background
- Focus ring on form inputs (`--accent-dim` glow)
- Primary CTA buttons (`.btn-primary`)
- XP badge text
- Avatar fallback initial letter
- Slider thumb

---

## Copywriting Contract

This phase is layout/interaction polish -- no new copy is introduced. Existing copy is preserved. The contract below documents what already exists and must not be broken during refactoring.

| Element | Copy |
|---------|------|
| Primary CTA | "Rate" (floating bottom nav button) |
| Bottom nav labels | Home, Browse, Rate, Top, Profile |
| Empty state heading | Not in scope for Phase 1 (deferred to Phase 4, UX-04) |
| Empty state body | Not in scope for Phase 1 |
| Error state | Not in scope for Phase 1 (deferred to Phase 4, QUAL-02) |
| Destructive confirmation | Not in scope for Phase 1 |

---

## Mobile Interaction Contract

This section is the core deliverable for Phase 1. These are the interaction rules the executor must follow.

### Touch Targets (MOB-01, MOB-06)

Every interactive element on mobile (< 640px) must have a minimum tappable area of 44x44px. This includes:

| Element | Current Size | Required | Fix Approach |
|---------|-------------|----------|--------------|
| Bottom nav tabs | flex: 1, minHeight: 64px | OK -- already meets 44px | Verify only |
| Navbar search icon | w-9 h-9 (36x36px) | 44x44px hit area | Increase padding or use min-w-11 min-h-11 |
| Navbar notifications icon | w-9 h-9 (36x36px) | 44x44px hit area | Increase padding or use min-w-11 min-h-11 |
| Navbar avatar/menu button | w-8 h-8 visual, outer has padding | Verify 44px hit area | Add padding if needed |
| FeedCard like button area | minHeight: 44px on row | Verify individual button | Ensure LikeButton has 44px touch target |
| FeedCard comment toggle | Part of CommentsSection | Verify 44px | Audit and fix |
| Context tag pills | padding: 3px 9px | 44px hit area if tappable | If tappable, add padding; if decorative, mark non-interactive |
| Follow button | Unknown | 44px minimum | Audit |
| Theme toggle | Unknown | 44px minimum | Audit |

**Rule:** If an element is not tappable (purely decorative/display), it does not need a 44px target. Only interactive elements (links, buttons, inputs) require it.

### Feed Cards (MOB-02)

| Rule | Specification |
|------|--------------|
| Card width | Full viewport minus 32px (16px margin each side) -- already `margin: 0 16px 12px` |
| Horizontal overflow | None allowed. `overflow: hidden` on card. Text uses `text-overflow: ellipsis` with `white-space: nowrap` and `min-width: 0` on flex children |
| Image sizing | Product thumb: 52x52px fixed, `object-fit: contain`. Review photo: `width: 100%`, `max-height: 220px`, `object-fit: cover` |
| Score readability | 32px at weight 900 -- preserved |
| Flavor name truncation | Single line, ellipsis on overflow -- already implemented, verify on narrow screens (320px) |
| Brand/product meta | 11px uppercase -- verify no wrapping on narrow screens |

### Rating Form (MOB-03)

| Rule | Specification |
|------|--------------|
| Slider thumb | 24px diameter, must not clip parent container |
| Slider track | 6px height, full width of container |
| Input font size | Minimum 16px to prevent iOS zoom |
| Submit button | Full width on mobile, minimum 48px height, sticky at bottom or clearly visible without scrolling |
| Form layout | Single column on mobile, no side-by-side fields below 640px |
| Scroll behavior | User must be able to scroll through all rating dimensions without the bottom nav obscuring content |

### Profile/Settings (MOB-04)

| Rule | Specification |
|------|--------------|
| Avatar display | Circular, centered, no overflow |
| Avatar upload | File picker must work on mobile browsers (iOS Safari, Chrome Android) |
| Settings form | Full width inputs, 16px font-size minimum |
| Content padding | Must not be hidden behind bottom nav -- use `pb-[calc(64px+24px+env(safe-area-inset-bottom))]` |

### Navigation & Transitions (MOB-05)

| Rule | Specification |
|------|--------------|
| Bottom nav | Fixed to bottom, visible on all pages, `z-index: 50` |
| Top nav | Sticky, `z-index: 40`, backdrop blur |
| Content must not be hidden behind | Top nav (h-14 = 56px) or bottom nav (64px + safe area) |
| Page transitions | `PageTransition` component handles fade/slide -- preserve existing behavior |
| No layout shift | Content must not jump when navigating between pages. Main area padding must be consistent |
| Back behavior | Browser back button works correctly, no history stack issues |

### Viewport Rules

| Breakpoint | Behavior |
|-----------|----------|
| < 640px (mobile) | Bottom nav visible, footer hidden, single-column layouts, 16px side padding |
| >= 640px (sm+) | Bottom nav hidden (`sm:hidden`), footer visible, desktop layout preserved |

**Minimum supported width:** 320px (iPhone SE). All layouts must work without horizontal scroll at 320px.

---

## Registry Safety

| Registry | Blocks Used | Safety Gate |
|----------|-------------|-------------|
| shadcn official | none | not applicable |

No third-party registries in use. No registry safety vetting required.

---

## Checker Sign-Off

- [ ] Dimension 1 Copywriting: PASS
- [ ] Dimension 2 Visuals: PASS
- [ ] Dimension 3 Color: PASS
- [ ] Dimension 4 Typography: PASS
- [ ] Dimension 5 Spacing: PASS
- [ ] Dimension 6 Registry Safety: PASS

**Approval:** pending

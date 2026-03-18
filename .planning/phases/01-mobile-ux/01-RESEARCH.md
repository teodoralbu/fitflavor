# Phase 1: Mobile UX - Research

**Researched:** 2026-03-18
**Domain:** Mobile CSS/UX polish for Next.js 16 App Router + Tailwind CSS 4
**Confidence:** HIGH

## Summary

Phase 1 is a CSS/layout polish phase -- no new features, no redesign. The existing GymTaste app works on desktop but has specific mobile issues: undersized touch targets in the navbar (36px icons vs 44px minimum), an `.input` class with 15px font-size that triggers iOS Safari auto-zoom, inconsistent bottom padding on pages that may cause content to hide behind the 64px bottom nav, and potential horizontal overflow on narrow screens (320px iPhone SE).

The codebase uses a hybrid styling approach: inline styles with CSS custom properties for most components, plus Tailwind utility classes for layout. The app already has solid mobile foundations -- `viewportFit: 'cover'`, `env(safe-area-inset-bottom)` padding on the bottom nav, `maximumScale: 1` on the viewport, and a well-structured BottomNav with correct z-indexing. The work is targeted fixes, not wholesale refactoring.

**Primary recommendation:** Audit every interactive element for 44px touch targets, fix the `.input` font-size from 15px to 16px, ensure all pages have correct bottom padding to clear the bottom nav, and verify no horizontal overflow at 320px width.

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| MOB-01 | Bottom navigation is accessible, correctly sized (touch targets >= 44px), and highlights the active route | BottomNav already has 64px minHeight tabs and active route highlighting with accent color + indicator dot. Touch targets are adequate. Verify only. |
| MOB-02 | Feed cards are readable and tappable on small screens without horizontal overflow or clipping | FeedCard uses inline styles with fixed widths. Need overflow audit at 320px. `min-width: 0` on flex children and `overflow: hidden` on card container. |
| MOB-03 | Rating form is fully usable on mobile -- sliders, inputs, submit work without awkward layouts | RatingForm has sticky submit button with safe-area padding. Slider thumb is 24px (adequate). Key fix: verify all inputs use 16px font-size. |
| MOB-04 | User profile and settings correctly laid out on mobile -- no overflow, avatar upload works | Settings page uses PageContainer with px-4 padding. Bio textarea uses `.input` class (15px font -- needs 16px). Avatar upload file picker should work on mobile. |
| MOB-05 | Page transitions and navigation feel smooth on mobile -- no layout jumps, consistent back behavior | PageTransition component uses simple opacity+translateY animation. Main content has `pb-[calc(64px+env(safe-area-inset-bottom))]`. Verify consistent padding across all pages. |
| MOB-06 | All tap targets across the app meet minimum size requirements -- no tiny buttons or links | Navbar search/notification icons are 36px (w-9 h-9) -- need 44px hit area. ThemeToggle is 36px -- needs 44px. LikeButton padding is 5px 12px -- needs audit. FollowButton padding is 9px 24px -- likely adequate height but verify. |
</phase_requirements>

## Standard Stack

No new libraries are needed for this phase. This is pure CSS/layout work using the existing stack.

### Core (already installed)
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| Next.js | 16.1.6 | App Router, SSR, layout system | Already in use |
| React | 19.2.3 | Component rendering | Already in use |
| Tailwind CSS | 4.x | Utility classes for responsive breakpoints | Already in use |

### Supporting
No additional libraries needed. All mobile fixes are achievable with CSS custom properties, Tailwind utilities, and inline style adjustments already in use in the codebase.

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Manual touch target auditing | Chrome DevTools device emulation | Manual but sufficient for this scope |
| CSS container queries | Tailwind `sm:` breakpoints | Breakpoints already used throughout; container queries add complexity for no benefit here |

## Architecture Patterns

### Existing Project Structure (preserved)
```
src/
  components/
    layout/       # Navbar, BottomNav, Footer, PageContainer, PageTransition
    feed/         # FeedCard
    rating/       # RatingForm, CommentsSection, LikeButton
    user/         # AvatarUpload, FollowButton
    ui/           # Button, Input, Slider, ThemeToggle
  app/
    layout.tsx    # Root layout with providers, nav, bottom padding
    globals.css   # All CSS custom properties and global styles
```

### Pattern 1: Touch Target Enlargement Without Visual Change
**What:** Increase the tappable area of an element without changing its visual size, using padding or `min-width`/`min-height`.
**When to use:** When an icon or button is visually correct at its current size but needs a larger hit area for mobile.
**Example:**
```tsx
// BEFORE: 36px visual icon with no extra hit area
<Link className="w-9 h-9 flex items-center justify-center ..."

// AFTER: 44px hit area, icon stays visually the same size
<Link className="min-w-11 min-h-11 flex items-center justify-center ..."
```
The key technique: use `min-w-11` (44px) and `min-h-11` (44px) instead of fixed `w-9 h-9` (36px), or add padding around the element. The SVG icon size stays the same -- only the tappable area grows.

### Pattern 2: iOS Zoom Prevention on Inputs
**What:** Set `font-size: 16px` on all form inputs to prevent iOS Safari from auto-zooming when the user taps an input.
**When to use:** Every `<input>`, `<textarea>`, and `<select>` element on the page.
**Example:**
```css
/* globals.css -- fix the .input class */
.input {
  font-size: 16px; /* was 15px -- causes iOS zoom */
}
```
```tsx
// Input.tsx component -- add text-base (16px) instead of text-sm (14px)
<input className="... text-base ..." />
```

### Pattern 3: Bottom Nav Content Clearance
**What:** Ensure page content does not get hidden behind the fixed bottom nav (64px + safe area inset).
**When to use:** Every page that scrolls on mobile.
**Example:**
```tsx
// Already in layout.tsx -- correct pattern:
<main className="flex-1 pb-[calc(64px+env(safe-area-inset-bottom))] sm:pb-0">

// Pages that add their own padding must account for this.
// The sticky submit button in RatingForm uses:
paddingBottom: 'max(16px, calc(env(safe-area-inset-bottom) + 12px))'
// This is correct but the sticky element itself needs to sit above the bottom nav.
```

### Pattern 4: Overflow Prevention on Narrow Screens
**What:** Prevent horizontal scroll on content that might exceed viewport width at 320px.
**When to use:** Any flex row with text content that could grow beyond available width.
**Example:**
```tsx
// Flex child text truncation pattern:
<div style={{ minWidth: 0, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
  {longText}
</div>

// Card container:
<div style={{ overflow: 'hidden' }}>
  {/* content cannot cause horizontal scroll */}
</div>
```

### Anti-Patterns to Avoid
- **Fixed pixel widths on text containers:** Use `minWidth: 0` on flex children instead of fixed widths that may overflow at 320px.
- **Changing visual design:** This phase is layout/interaction polish. Do not change colors, fonts, spacing tokens, or visual hierarchy.
- **Adding new CSS custom properties:** The UI-SPEC explicitly forbids introducing new spacing values or design tokens.
- **Removing existing inline styles:** The codebase convention is inline styles with CSS custom properties. Preserve this pattern; do not refactor to Tailwind-only.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Safe area insets | Custom JS detection | `env(safe-area-inset-bottom)` CSS function | Already in use; native browser support; no JS needed |
| Touch target sizing | Custom touch event handling | CSS `min-width`/`min-height` or padding | Simpler, more reliable, works with assistive tech |
| iOS zoom prevention | JavaScript zoom prevention hacks | `font-size: 16px` on inputs | The only reliable cross-browser solution |
| Viewport configuration | Custom meta tags | Next.js `Viewport` export in layout.tsx | Already configured correctly |
| Scroll locking for modals | Custom scroll lock | Already implemented in CommentsSection via `document.body.style.overflow` | Works for current use case |

**Key insight:** This phase requires no new libraries or custom solutions. Every fix is a CSS property change or Tailwind class adjustment on existing elements.

## Common Pitfalls

### Pitfall 1: iOS Safari Auto-Zoom on Input Focus
**What goes wrong:** When a user taps an input with font-size < 16px, iOS Safari zooms the page to make the text readable. The page stays zoomed after the user finishes typing, requiring manual zoom-out.
**Why it happens:** iOS Safari triggers auto-zoom for any input with `font-size` below 16px. The codebase has `.input` at 15px and the `Input.tsx` component using `text-sm` (14px).
**How to avoid:** Set `font-size: 16px` (Tailwind `text-base`) on ALL input elements: `.input` class in globals.css, `Input.tsx` component, any inline-styled inputs in RatingForm, and the textarea in Settings.
**Warning signs:** Test on iOS Safari (or iOS simulator). If the page zooms when tapping any input, the font-size is wrong.

### Pitfall 2: Sticky Submit Button Hidden Behind Bottom Nav
**What goes wrong:** The RatingForm's sticky submit button (z-index: 10) sits at `bottom: 0`, but the bottom nav is also at `bottom: 0` with z-index: 50. If the page has bottom padding from layout.tsx, the sticky button may appear to work correctly, but if the user scrolls to the very bottom, the submit button could overlap with or be hidden behind the bottom nav.
**Why it happens:** Multiple fixed/sticky elements compete for the bottom of the viewport.
**How to avoid:** The sticky submit button's `bottom` value must account for the bottom nav height. Use `bottom: calc(64px + env(safe-area-inset-bottom))` on mobile, or ensure the form container's own bottom padding pushes the sticky element above the nav.
**Warning signs:** On mobile, scroll to the bottom of the rating form and verify the submit button is fully visible and tappable above the bottom nav.

### Pitfall 3: Horizontal Overflow at 320px
**What goes wrong:** Content extends beyond the viewport, creating a horizontal scrollbar or clipping text.
**Why it happens:** Flex rows with text content that doesn't truncate, or elements with fixed pixel widths that exceed the narrow viewport.
**How to avoid:** Add `overflow: hidden` on card containers. Add `minWidth: 0` on flex children that contain text. Test every page at 320px viewport width.
**Warning signs:** Horizontal scrollbar appears on any page. Test with Chrome DevTools device emulation at 320px width.

### Pitfall 4: `maximumScale: 1` Accessibility Concern
**What goes wrong:** The viewport meta tag includes `maximumScale: 1`, which prevents users from pinch-zooming. This is an accessibility issue (WCAG 1.4.4).
**Why it happens:** Common in mobile-first apps to prevent zoom, but it blocks users who need to zoom for readability.
**How to avoid:** This is already in the codebase and is an existing decision. Phase 1 preserves it as-is. If accessibility becomes a concern in Phase 4, it should be revisited. For now, document but do not change.
**Warning signs:** WCAG audit tools will flag this.

### Pitfall 5: PageTransition Layout Shift
**What goes wrong:** The PageTransition component sets `opacity: 0` and `translateY(6px)` on mount, then animates to visible. If the content has a defined height, this can cause a visible "jump" as the page appears.
**Why it happens:** The animation starts from an offset position.
**How to avoid:** The existing implementation uses `requestAnimationFrame` which should make the transition smooth. Verify on mobile that there is no visible content jump. If there is, the fix is to reduce or remove the translateY offset.
**Warning signs:** On mobile, navigate between pages and watch for content jumping downward then snapping up.

### Pitfall 6: ThemeToggle and Navbar Icons Too Small
**What goes wrong:** The ThemeToggle is 36x36px, search icon is 36x36px (w-9 h-9), notification bell is 36x36px. All are below the 44px minimum touch target.
**Why it happens:** Desktop-first sizing that was not adjusted for mobile.
**How to avoid:** Increase the tappable area to 44px minimum using `min-w-11 min-h-11` or additional padding. Keep the visual icon size the same.
**Warning signs:** Users on mobile have difficulty tapping small icons, especially in the navbar.

## Code Examples

Verified patterns from the actual codebase:

### Fix 1: Navbar Touch Targets (MOB-06)
```tsx
// CURRENT (Navbar.tsx lines 62-63):
className="sm:hidden w-9 h-9 flex items-center justify-center rounded-full ..."

// FIX: Change w-9 h-9 to min-w-11 min-h-11, keep icon SVG size unchanged
className="sm:hidden min-w-11 min-h-11 flex items-center justify-center rounded-full ..."
```

### Fix 2: ThemeToggle Touch Target (MOB-06)
```tsx
// CURRENT (ThemeToggle.tsx):
style={{ width: '36px', height: '36px', ... }}

// FIX: Increase to 44px
style={{ width: '44px', height: '44px', ... }}
// Or use minWidth/minHeight to allow the visual circle to stay at 36px
// but make the tappable area 44px via padding.
```

### Fix 3: Input Font Size iOS Zoom Prevention (MOB-03, MOB-04)
```css
/* CURRENT (globals.css line 423): */
.input { font-size: 15px; }

/* FIX: */
.input { font-size: 16px; }
```

```tsx
// CURRENT (Input.tsx line 24):
className="... text-sm ..."

// FIX:
className="... text-base ..."
// text-base = 16px, prevents iOS zoom
```

### Fix 4: LikeButton Touch Target (MOB-06)
```tsx
// CURRENT (LikeButton.tsx line 85):
padding: '5px 12px'
// This results in a very small vertical touch target

// FIX: Increase vertical padding to meet 44px minimum height
padding: '10px 12px'
// Or add minHeight: '44px'
```

### Fix 5: Bottom Padding Consistency (MOB-05)
```tsx
// The root layout already handles this correctly:
<main className="flex-1 pb-[calc(64px+env(safe-area-inset-bottom))] sm:pb-0">

// But individual pages that use PageContainer with their own py-*
// may need verification that content doesn't get clipped.
// Settings page uses: className="py-12" -- this adds top AND bottom padding
// which is fine because the layout.tsx main tag handles the nav clearance.
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| `-webkit-touch-callout: none` hacks | `touch-action: manipulation` | Widely adopted ~2020 | Already used in this codebase |
| `user-scalable=no` viewport | `maximum-scale=1` | iOS 10+ respects both | Already in use; accessibility tradeoff |
| JavaScript-based safe area detection | `env(safe-area-inset-*)` CSS | Safari 11.1+ (2018) | Already used throughout |
| Media queries for touch detection | `@media (hover: none)` | Widely supported | Not currently used but not needed for this phase |

**Deprecated/outdated:**
- `viewport` meta tag in `<head>`: Next.js 16 uses the `Viewport` export from layout.tsx instead. Already correctly implemented.
- Manual `<meta name="viewport">`: Handled by Next.js Viewport export. Do not add a manual meta tag.

## Open Questions

1. **Sticky submit button interaction with bottom nav**
   - What we know: The submit button uses `position: sticky; bottom: 0` and the layout has bottom padding for the nav. The z-index of the submit (10) is lower than the nav (50).
   - What's unclear: Whether the sticky button is actually fully visible and tappable on all iPhone models, especially with the safe area inset. This needs manual testing.
   - Recommendation: Test on iOS Safari (or simulator). If the button is obscured, change its `bottom` to `calc(64px + env(safe-area-inset-bottom))` on mobile.

2. **FeedCard horizontal overflow at 320px**
   - What we know: Feed cards use `margin: 0 16px 12px` which leaves 288px for content at 320px width. The card has `overflow: hidden`.
   - What's unclear: Whether all text elements within the card (usernames, flavor names, brand names) properly truncate at this width.
   - Recommendation: Test every feed card variant at 320px. Add `minWidth: 0` and text truncation to any flex children that overflow.

3. **Comment bottom sheet on mobile**
   - What we know: CommentsSection uses a bottom sheet pattern with body scroll lock.
   - What's unclear: Whether the comment input at the bottom of the sheet is obscured by the keyboard on mobile, and whether the sheet respects the bottom nav.
   - Recommendation: Test on mobile with keyboard open. The input should remain visible above the keyboard.

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | None detected -- zero test coverage |
| Config file | none -- see Wave 0 |
| Quick run command | N/A |
| Full suite command | N/A |

### Phase Requirements to Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| MOB-01 | Bottom nav touch targets >= 44px, active route highlighted | manual-only | N/A -- visual/interaction testing on device | N/A |
| MOB-02 | Feed cards no horizontal overflow at 320px | manual-only | N/A -- visual testing with Chrome DevTools device emulation | N/A |
| MOB-03 | Rating form usable on mobile -- sliders, inputs, submit visible | manual-only | N/A -- requires touch interaction testing | N/A |
| MOB-04 | Settings/profile no overflow, avatar upload works on mobile | manual-only | N/A -- requires file picker interaction on mobile | N/A |
| MOB-05 | No layout jumps on page navigation | manual-only | N/A -- visual testing on device | N/A |
| MOB-06 | All tap targets >= 44px | manual-only | N/A -- CSS measurement audit | N/A |

**Justification for manual-only:** All MOB requirements are visual/interaction concerns that require device testing or device emulation. There is no test framework installed, and CSS layout testing requires visual verification. Automated CSS regression testing (e.g., Playwright visual snapshots) is out of scope for this milestone per the "skip test suite" decision.

### Sampling Rate
- **Per task commit:** Manual verification using Chrome DevTools device emulation at 320px, 375px, 390px widths
- **Per wave merge:** Full manual audit of all screens on at least two viewport sizes
- **Phase gate:** All screens verified on mobile viewport in DevTools before marking complete

### Wave 0 Gaps
None -- this phase is manual-only testing. No test infrastructure is needed.

## Sources

### Primary (HIGH confidence)
- Codebase analysis: Direct reading of all component files listed in phase description
- `src/app/layout.tsx` -- viewport configuration, bottom padding, provider structure
- `src/app/globals.css` -- all CSS custom properties, `.input` class (15px font-size bug confirmed)
- `src/components/layout/BottomNav.tsx` -- 64px minHeight, safe area padding, z-index 50
- `src/components/layout/Navbar.tsx` -- w-9 h-9 icons (36px, below 44px minimum)
- `src/components/ui/ThemeToggle.tsx` -- 36px width/height (below 44px minimum)
- `src/components/ui/Input.tsx` -- uses `text-sm` (14px, triggers iOS zoom)
- `src/components/rating/LikeButton.tsx` -- 5px vertical padding (small touch target)
- `src/components/rating/RatingForm.tsx` -- sticky submit button pattern, slider implementation
- `.planning/phases/01-mobile-ux/01-UI-SPEC.md` -- normative rules for spacing, typography, touch targets

### Secondary (MEDIUM confidence)
- Apple HIG touch target guidance: 44x44pt minimum for iOS (well-established standard)
- iOS Safari 16px input zoom behavior: long-documented browser behavior, confirmed by the existing `.input-search` comment in globals.css ("16px prevents iOS zoom")

### Tertiary (LOW confidence)
- None -- all findings are based on direct codebase analysis and well-established mobile CSS patterns.

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH -- no new libraries needed; all fixes use existing CSS/Tailwind
- Architecture: HIGH -- no structural changes; all fixes are property-level CSS adjustments
- Pitfalls: HIGH -- iOS zoom bug confirmed by codebase evidence (15px vs 16px); touch target sizes measured from actual component code

**Identified issues summary (for planner):**

| Issue | File(s) | Severity | Fix Complexity |
|-------|---------|----------|----------------|
| `.input` font-size 15px (iOS zoom) | `globals.css` | HIGH | Trivial -- change to 16px |
| `Input.tsx` uses `text-sm` (14px, iOS zoom) | `Input.tsx` | HIGH | Trivial -- change to `text-base` |
| Navbar search icon 36px touch target | `Navbar.tsx` | MEDIUM | Simple -- change w-9 h-9 to min-w-11 min-h-11 |
| Navbar notification icon 36px | `Navbar.tsx` | MEDIUM | Simple -- same fix |
| ThemeToggle 36px | `ThemeToggle.tsx` | MEDIUM | Simple -- increase to 44px |
| LikeButton 5px vertical padding | `LikeButton.tsx` | MEDIUM | Simple -- increase padding or add minHeight |
| FollowButton height | `FollowButton.tsx` | LOW | Verify -- padding 9px 24px may meet 44px with text |
| Photo remove button 28px | `RatingForm.tsx` | LOW | Small -- increase to 44px hit area |
| FeedCard overflow at 320px | `FeedCard.tsx` | MEDIUM | Audit needed -- add minWidth: 0 to flex children |
| Sticky submit vs bottom nav overlap | `RatingForm.tsx` | MEDIUM | Test needed -- may need bottom offset |
| Settings page textarea iOS zoom | `settings/page.tsx` | MEDIUM | Uses `.input` class -- fixed when globals.css is fixed |
| All pages bottom padding consistency | Various | LOW | Verify -- layout.tsx handles this but individual pages may override |

**Research date:** 2026-03-18
**Valid until:** 2026-04-18 (stable CSS patterns, no API changes expected)

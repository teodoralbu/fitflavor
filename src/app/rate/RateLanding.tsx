'use client'

import { useState, useRef, useEffect } from 'react'
import Link from 'next/link'

const REGIONS = ['US', 'EU', 'Asia', 'Africa'] as const
const STIM_OPTIONS = [
  { value: 'all', label: 'All' },
  { value: 'stim', label: 'Stim' },
  { value: 'stim-free', label: 'Stim-Free' },
] as const
const MIN_RATINGS = [
  { value: 0, label: 'Any' },
  { value: 6, label: '6+' },
  { value: 7, label: '7+' },
  { value: 8, label: '8+' },
  { value: 9, label: '9+' },
] as const

interface Product {
  id: string
  name: string
  slug: string
  image_url: string | null
  region: string[]
  stim_type: 'stim' | 'stim-free' | null
  brands: { name: string; slug: string } | null
}

interface Props {
  products: Product[]
}

export function RateLanding({ products }: Props) {
  const [query, setQuery] = useState('')
  const inputRef = useRef<HTMLInputElement>(null)

  // Filter sheet state
  const [sheetOpen, setSheetOpen] = useState(false)
  const [pendingStim, setPendingStim] = useState<string>('all')
  const [pendingRegions, setPendingRegions] = useState<string[]>([])
  const [pendingBrand, setPendingBrand] = useState('')
  const [pendingMinRating, setPendingMinRating] = useState(0)

  // Applied filter state
  const [activeStim, setActiveStim] = useState<string>('all')
  const [activeRegions, setActiveRegions] = useState<string[]>([])
  const [activeBrand, setActiveBrand] = useState('')
  const [activeMinRating, setActiveMinRating] = useState(0)

  const activeCount = [
    activeStim !== 'all' ? 1 : 0,
    activeRegions.length > 0 ? 1 : 0,
    activeBrand ? 1 : 0,
    activeMinRating > 0 ? 1 : 0,
  ].reduce((a, b) => a + b, 0)

  useEffect(() => {
    const t = setTimeout(() => inputRef.current?.focus(), 200)
    return () => clearTimeout(t)
  }, [])

  // Unique brands from products
  const uniqueBrands = Array.from(
    new Map(products.map((p) => [p.brands?.slug, p.brands])).values()
  )
    .filter((b): b is { name: string; slug: string } => !!b?.slug)
    .sort((a, b) => a.name.localeCompare(b.name))

  const q = query.toLowerCase().trim()

  const filtered = products.filter((p) => {
    const matchesQuery = !q ||
      p.name.toLowerCase().includes(q) ||
      (p.brands?.name ?? '').toLowerCase().includes(q)
    const matchesStim = activeStim === 'all' || p.stim_type === activeStim
    const matchesRegion = activeRegions.length === 0 ||
      activeRegions.some((r) => (p.region ?? []).includes(r))
    const matchesBrand = !activeBrand || p.brands?.slug === activeBrand
    return matchesQuery && matchesStim && matchesRegion && matchesBrand
  })

  const openSheet = () => {
    setPendingStim(activeStim)
    setPendingRegions(activeRegions)
    setPendingBrand(activeBrand)
    setPendingMinRating(activeMinRating)
    setSheetOpen(true)
  }

  const applyFilters = () => {
    setActiveStim(pendingStim)
    setActiveRegions(pendingRegions)
    setActiveBrand(pendingBrand)
    setActiveMinRating(pendingMinRating)
    setSheetOpen(false)
  }

  const clearAll = () => {
    setPendingStim('all')
    setPendingRegions([])
    setPendingBrand('')
    setPendingMinRating(0)
  }

  const toggleRegion = (r: string) => {
    setPendingRegions((prev) =>
      prev.includes(r) ? prev.filter((x) => x !== r) : [...prev, r]
    )
  }

  return (
    <div style={{ maxWidth: '600px', margin: '0 auto', padding: 'clamp(24px, 5vw, 48px) 16px 96px' }}>

      {/* Header */}
      <div style={{ marginBottom: '24px' }}>
        <h1 style={{
          fontSize: 'clamp(24px, 6vw, 36px)',
          fontWeight: 900,
          margin: '0 0 6px',
          color: 'var(--text)',
          letterSpacing: '-0.02em',
          lineHeight: 1.1,
        }}>
          Rate a Flavor
        </h1>
        <p style={{ margin: 0, fontSize: '14px', color: 'var(--text-dim)', lineHeight: 1.5 }}>
          What did you try today? Find it and rate it.
        </p>
      </div>

      {/* Search bar */}
      <div style={{ position: 'relative', marginBottom: '12px' }}>
        <svg
          width="16" height="16" viewBox="0 0 24 24" fill="none"
          stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"
          aria-hidden="true"
          style={{ position: 'absolute', left: '14px', top: '50%', transform: 'translateY(-50%)', color: 'var(--text-faint)', pointerEvents: 'none' }}
        >
          <circle cx="11" cy="11" r="8" /><line x1="21" y1="21" x2="16.65" y2="16.65" />
        </svg>
        <input
          ref={inputRef}
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          placeholder="Search brand or product..."
          style={{
            width: '100%',
            height: '48px',
            paddingLeft: '42px',
            paddingRight: '16px',
            backgroundColor: 'var(--bg-elevated)',
            border: '1px solid var(--border)',
            borderRadius: 'var(--radius-md)',
            fontSize: '15px',
            color: 'var(--text)',
            outline: 'none',
            fontFamily: 'inherit',
            boxSizing: 'border-box',
          }}
          onFocus={(e) => { e.currentTarget.style.borderColor = 'var(--accent)' }}
          onBlur={(e) => { e.currentTarget.style.borderColor = 'var(--border)' }}
        />
        {query && (
          <button
            onClick={() => setQuery('')}
            aria-label="Clear search"
            style={{
              position: 'absolute', right: '12px', top: '50%', transform: 'translateY(-50%)',
              background: 'none', border: 'none', cursor: 'pointer',
              color: 'var(--text-faint)', padding: '4px',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              WebkitTapHighlightColor: 'transparent',
            }}
          >
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
              <line x1="18" y1="6" x2="6" y2="18" /><line x1="6" y1="6" x2="18" y2="18" />
            </svg>
          </button>
        )}
      </div>

      {/* Filter button */}
      <div style={{ marginBottom: '24px' }}>
        <button
          onClick={openSheet}
          style={{
            display: 'inline-flex',
            alignItems: 'center',
            gap: '6px',
            padding: '9px 16px',
            borderRadius: '999px',
            fontSize: '14px',
            fontWeight: 600,
            cursor: 'pointer',
            border: activeCount > 0 ? '2px solid var(--accent)' : '1px solid var(--border)',
            backgroundColor: activeCount > 0 ? 'var(--accent-dim)' : 'var(--bg-elevated)',
            color: activeCount > 0 ? 'var(--accent)' : 'var(--text-dim)',
            WebkitTapHighlightColor: 'transparent',
            touchAction: 'manipulation',
          }}
        >
          <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round">
            <line x1="4" y1="6" x2="20" y2="6" />
            <line x1="4" y1="12" x2="20" y2="12" />
            <line x1="4" y1="18" x2="20" y2="18" />
            <circle cx="8" cy="6" r="2" fill="currentColor" stroke="none" />
            <circle cx="16" cy="12" r="2" fill="currentColor" stroke="none" />
            <circle cx="10" cy="18" r="2" fill="currentColor" stroke="none" />
          </svg>
          Filters
          {activeCount > 0 && (
            <span style={{
              backgroundColor: 'var(--accent)',
              color: '#000',
              fontSize: '11px',
              fontWeight: 800,
              borderRadius: '999px',
              padding: '1px 6px',
              lineHeight: 1.4,
            }}>
              {activeCount}
            </span>
          )}
        </button>

        {activeCount > 0 && (
          <button
            onClick={() => { setActiveStim('all'); setActiveRegions([]); setActiveBrand(''); setActiveMinRating(0) }}
            style={{
              background: 'none', border: 'none', cursor: 'pointer',
              fontSize: '13px', color: 'var(--text-faint)', marginLeft: '10px',
              fontFamily: 'inherit', padding: 0,
              WebkitTapHighlightColor: 'transparent',
            }}
          >
            Clear
          </button>
        )}
      </div>

      {/* Results label */}
      <div style={{ fontSize: '11px', fontWeight: 700, color: 'var(--text-faint)', textTransform: 'uppercase', letterSpacing: '0.1em', marginBottom: '12px' }}>
        {q ? `${filtered.length} result${filtered.length !== 1 ? 's' : ''}` : `${filtered.length} product${filtered.length !== 1 ? 's' : ''}`}
      </div>

      {/* Empty state */}
      {filtered.length === 0 && (
        <div style={{ textAlign: 'center', padding: '48px 0', color: 'var(--text-faint)', fontSize: '14px' }}>
          No products found
          <div style={{ marginTop: '16px' }}>
            <Link href="/submit" style={{ color: 'var(--accent)', fontSize: '13px', fontWeight: 600 }}>
              Submit a product →
            </Link>
          </div>
        </div>
      )}

      {/* Product list */}
      {filtered.length > 0 && (
        <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
          {filtered.map((product) => (
            <Link key={product.id} href={`/products/${product.slug}`} style={{ textDecoration: 'none', color: 'inherit' }}>
              <div style={{
                display: 'flex', alignItems: 'center', gap: '14px',
                padding: '14px 16px',
                backgroundColor: 'var(--bg-card)',
                border: '1px solid var(--border)',
                borderRadius: 'var(--radius-md)',
                cursor: 'pointer',
              }}>
                {/* Product image */}
                <div style={{
                  width: '56px', height: '56px', borderRadius: '10px', flexShrink: 0,
                  backgroundColor: 'var(--bg-elevated)', border: '1px solid var(--border)',
                  overflow: 'hidden', display: 'flex', alignItems: 'center', justifyContent: 'center',
                }}>
                  {product.image_url ? (
                    // eslint-disable-next-line @next/next/no-img-element
                    <img src={product.image_url} alt={product.name} loading="lazy" decoding="async"
                      style={{ width: '100%', height: '100%', objectFit: 'contain', padding: '2px' }} />
                  ) : (
                    <span style={{ fontSize: '22px' }}>⚡</span>
                  )}
                </div>

                {/* Text */}
                <div style={{ flex: 1, minWidth: 0 }}>
                  <div style={{ fontSize: '13px', fontWeight: 600, color: 'var(--text-dim)', marginBottom: '2px' }}>
                    {product.brands?.name ?? ''}
                  </div>
                  <div style={{ fontSize: '15px', fontWeight: 800, color: 'var(--text)', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                    {product.name}
                  </div>
                  {/* Region / stim tags */}
                  <div style={{ display: 'flex', gap: '6px', marginTop: '4px', flexWrap: 'wrap' }}>
                    {product.stim_type === 'stim-free' && (
                      <span style={{ fontSize: '10px', fontWeight: 700, color: 'var(--green, #4ade80)', backgroundColor: 'rgba(74,222,128,0.1)', borderRadius: '4px', padding: '1px 5px' }}>
                        Stim-Free
                      </span>
                    )}
                    {(product.region ?? []).map((r) => (
                      <span key={r} style={{ fontSize: '10px', fontWeight: 600, color: 'var(--text-faint)', backgroundColor: 'var(--bg-elevated)', borderRadius: '4px', padding: '1px 5px', border: '1px solid var(--border-soft)' }}>
                        {r}
                      </span>
                    ))}
                  </div>
                </div>

                {/* Chevron */}
                <div style={{ color: 'var(--text-faint)', flexShrink: 0, fontSize: '18px', lineHeight: 1 }}>›</div>
              </div>
            </Link>
          ))}
        </div>
      )}

      {/* ── Filter bottom sheet backdrop ── */}
      {sheetOpen && (
        <div
          onClick={() => setSheetOpen(false)}
          style={{
            position: 'fixed', inset: 0, zIndex: 100,
            backgroundColor: 'rgba(0,0,0,0.55)',
            backdropFilter: 'blur(2px)',
            WebkitBackdropFilter: 'blur(2px)',
          }}
        />
      )}

      {/* ── Filter bottom sheet ── */}
      <div style={{
        position: 'fixed', left: 0, right: 0, bottom: 0, zIndex: 101,
        backgroundColor: 'var(--bg-card)',
        borderTop: '1px solid var(--border)',
        borderRadius: '20px 20px 0 0',
        paddingBottom: 'max(24px, env(safe-area-inset-bottom))',
        transform: sheetOpen ? 'translateY(0)' : 'translateY(100%)',
        transition: 'transform 0.3s cubic-bezier(0.32, 0.72, 0, 1)',
        maxHeight: '88vh',
        overflowY: 'auto',
        willChange: 'transform',
      }}>
        {/* Handle */}
        <div style={{ display: 'flex', justifyContent: 'center', padding: '12px 0 4px' }}>
          <div style={{ width: '36px', height: '4px', borderRadius: '999px', backgroundColor: 'var(--border)' }} />
        </div>

        {/* Sheet header */}
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '12px 20px 20px', borderBottom: '1px solid var(--border-soft)' }}>
          <span style={{ fontSize: '18px', fontWeight: 800, color: 'var(--text)' }}>Filters</span>
          <button onClick={clearAll} style={{ background: 'none', border: 'none', cursor: 'pointer', fontSize: '13px', fontWeight: 600, color: 'var(--text-dim)', fontFamily: 'inherit' }}>
            Clear all
          </button>
        </div>

        <div style={{ padding: '0 20px' }}>

          {/* Stim */}
          <section style={{ padding: '20px 0', borderBottom: '1px solid var(--border-soft)' }}>
            <h3 style={{ fontSize: '13px', fontWeight: 700, color: 'var(--text-dim)', textTransform: 'uppercase', letterSpacing: '0.08em', margin: '0 0 14px' }}>Stimulants</h3>
            <div style={{ display: 'flex', gap: '8px' }}>
              {STIM_OPTIONS.map((opt) => (
                <button key={opt.value} onClick={() => setPendingStim(opt.value)} style={{
                  flex: 1, padding: '10px 0', borderRadius: '10px',
                  fontSize: '14px', fontWeight: 600, cursor: 'pointer', fontFamily: 'inherit',
                  border: pendingStim === opt.value ? '2px solid var(--accent)' : '1px solid var(--border)',
                  backgroundColor: pendingStim === opt.value ? 'var(--accent-dim)' : 'var(--bg-elevated)',
                  color: pendingStim === opt.value ? 'var(--accent)' : 'var(--text-dim)',
                }}>
                  {opt.label}
                </button>
              ))}
            </div>
          </section>

          {/* Region */}
          <section style={{ padding: '20px 0', borderBottom: '1px solid var(--border-soft)' }}>
            <h3 style={{ fontSize: '13px', fontWeight: 700, color: 'var(--text-dim)', textTransform: 'uppercase', letterSpacing: '0.08em', margin: '0 0 4px' }}>Region</h3>
            <p style={{ fontSize: '11px', color: 'var(--text-faint)', margin: '0 0 14px', lineHeight: 1.5 }}>
              Based on the brand&apos;s official website — not third-party resellers.
            </p>
            <div style={{ display: 'flex', gap: '8px', flexWrap: 'wrap' }}>
              {REGIONS.map((r) => {
                const active = pendingRegions.includes(r)
                return (
                  <button key={r} onClick={() => toggleRegion(r)} style={{
                    padding: '9px 18px', borderRadius: '10px',
                    fontSize: '14px', fontWeight: 600, cursor: 'pointer', fontFamily: 'inherit',
                    border: active ? '2px solid var(--accent)' : '1px solid var(--border)',
                    backgroundColor: active ? 'var(--accent-dim)' : 'var(--bg-elevated)',
                    color: active ? 'var(--accent)' : 'var(--text-dim)',
                  }}>
                    {r}
                  </button>
                )
              })}
            </div>
          </section>

          {/* Brand */}
          <section style={{ padding: '20px 0', borderBottom: '1px solid var(--border-soft)' }}>
            <h3 style={{ fontSize: '13px', fontWeight: 700, color: 'var(--text-dim)', textTransform: 'uppercase', letterSpacing: '0.08em', margin: '0 0 14px' }}>Brand</h3>
            <div style={{ display: 'flex', gap: '8px', flexWrap: 'wrap' }}>
              <button onClick={() => setPendingBrand('')} style={{
                padding: '9px 18px', borderRadius: '10px',
                fontSize: '14px', fontWeight: 600, cursor: 'pointer', fontFamily: 'inherit',
                border: pendingBrand === '' ? '2px solid var(--accent)' : '1px solid var(--border)',
                backgroundColor: pendingBrand === '' ? 'var(--accent-dim)' : 'var(--bg-elevated)',
                color: pendingBrand === '' ? 'var(--accent)' : 'var(--text-dim)',
              }}>All</button>
              {uniqueBrands.map((b) => (
                <button key={b.slug} onClick={() => setPendingBrand(b.slug === pendingBrand ? '' : b.slug)} style={{
                  padding: '9px 18px', borderRadius: '10px',
                  fontSize: '14px', fontWeight: 600, cursor: 'pointer', fontFamily: 'inherit',
                  border: pendingBrand === b.slug ? '2px solid var(--accent)' : '1px solid var(--border)',
                  backgroundColor: pendingBrand === b.slug ? 'var(--accent-dim)' : 'var(--bg-elevated)',
                  color: pendingBrand === b.slug ? 'var(--accent)' : 'var(--text-dim)',
                }}>
                  {b.name}
                </button>
              ))}
            </div>
          </section>

          {/* Price — coming soon */}
          <section style={{ padding: '20px 0' }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
              <h3 style={{ fontSize: '13px', fontWeight: 700, color: 'var(--text-faint)', textTransform: 'uppercase', letterSpacing: '0.08em', margin: 0 }}>Price</h3>
              <span style={{ fontSize: '10px', fontWeight: 700, textTransform: 'uppercase', letterSpacing: '0.08em', backgroundColor: 'var(--bg-elevated)', color: 'var(--text-faint)', border: '1px solid var(--border)', borderRadius: '999px', padding: '2px 8px' }}>
                Coming soon
              </span>
            </div>
          </section>

        </div>

        {/* Apply */}
        <div style={{ padding: '0 20px' }}>
          <button onClick={applyFilters} style={{
            width: '100%', padding: '16px', borderRadius: '14px',
            fontSize: '16px', fontWeight: 800,
            backgroundColor: 'var(--accent)', color: '#000',
            border: 'none', cursor: 'pointer', fontFamily: 'inherit',
            letterSpacing: '-0.01em',
          }}>
            Apply filters
          </button>
        </div>
      </div>
    </div>
  )
}

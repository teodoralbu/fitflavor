'use client'

import { useState, useCallback } from 'react'
import { useRouter } from 'next/navigation'

const REGIONS = ['US', 'EU', 'Asia', 'Africa'] as const
const STIM_OPTIONS = [
  { value: '', label: 'All' },
  { value: 'stim', label: 'Stim' },
  { value: 'stim-free', label: 'Stim-Free' },
] as const

const MIN_RATINGS = [
  { value: '', label: 'Any' },
  { value: '6', label: '6+' },
  { value: '7', label: '7+' },
  { value: '8', label: '8+' },
  { value: '9', label: '9+' },
] as const

interface Props {
  allBrands: { name: string; slug: string }[]
  currentBrand: string
  currentStim: string
  currentRegions: string[]
  currentMinRating: string
  currentQuery: string
}

export function BrowseFilters({
  allBrands,
  currentBrand,
  currentStim,
  currentRegions,
  currentMinRating,
  currentQuery,
}: Props) {
  const router = useRouter()
  const [open, setOpen] = useState(false)

  // Local pending state (only committed on Apply)
  const [pendingBrand, setPendingBrand] = useState(currentBrand)
  const [pendingStim, setPendingStim] = useState(currentStim)
  const [pendingRegions, setPendingRegions] = useState<string[]>(currentRegions)
  const [pendingMinRating, setPendingMinRating] = useState(currentMinRating)

  const activeCount = [
    currentBrand ? 1 : 0,
    currentStim ? 1 : 0,
    currentRegions.length > 0 ? 1 : 0,
    currentMinRating ? 1 : 0,
  ].reduce((a, b) => a + b, 0)

  const openSheet = useCallback(() => {
    // Reset pending to current on open
    setPendingBrand(currentBrand)
    setPendingStim(currentStim)
    setPendingRegions(currentRegions)
    setPendingMinRating(currentMinRating)
    setOpen(true)
  }, [currentBrand, currentStim, currentRegions, currentMinRating])

  const closeSheet = useCallback(() => setOpen(false), [])

  const toggleRegion = (r: string) => {
    setPendingRegions((prev) =>
      prev.includes(r) ? prev.filter((x) => x !== r) : [...prev, r]
    )
  }

  const applyFilters = () => {
    const params = new URLSearchParams()
    if (currentQuery) params.set('q', currentQuery)
    if (pendingBrand) params.set('brand', pendingBrand)
    if (pendingStim) params.set('stim', pendingStim)
    if (pendingRegions.length > 0) params.set('region', pendingRegions.join(','))
    if (pendingMinRating) params.set('min_rating', pendingMinRating)
    router.push(`/browse?${params.toString()}`)
    setOpen(false)
  }

  const clearAll = () => {
    setPendingBrand('')
    setPendingStim('')
    setPendingRegions([])
    setPendingMinRating('')
  }

  const pillBase: React.CSSProperties = {
    display: 'inline-flex',
    alignItems: 'center',
    gap: '6px',
    padding: '9px 16px',
    borderRadius: '999px',
    fontSize: '14px',
    fontWeight: 600,
    cursor: 'pointer',
    border: '1px solid var(--border)',
    backgroundColor: activeCount > 0 ? 'var(--accent)' : 'var(--bg-elevated)',
    color: activeCount > 0 ? '#000' : 'var(--text-dim)',
    userSelect: 'none',
    WebkitTapHighlightColor: 'transparent',
    touchAction: 'manipulation',
    transition: 'background-color 0.15s ease, color 0.15s ease',
  }

  return (
    <>
      {/* ── Filter pill ── */}
      <button onClick={openSheet} style={pillBase}>
        {/* Sliders icon */}
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
            backgroundColor: activeCount > 0 ? 'rgba(0,0,0,0.2)' : 'var(--accent)',
            color: activeCount > 0 ? '#000' : '#000',
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

      {/* ── Backdrop ── */}
      {open && (
        <div
          onClick={closeSheet}
          style={{
            position: 'fixed',
            inset: 0,
            backgroundColor: 'rgba(0,0,0,0.55)',
            zIndex: 100,
            backdropFilter: 'blur(2px)',
            WebkitBackdropFilter: 'blur(2px)',
          }}
        />
      )}

      {/* ── Bottom sheet ── */}
      <div
        style={{
          position: 'fixed',
          left: 0,
          right: 0,
          bottom: 0,
          zIndex: 101,
          backgroundColor: 'var(--bg-card)',
          borderTop: '1px solid var(--border)',
          borderRadius: '20px 20px 0 0',
          paddingBottom: 'max(24px, env(safe-area-inset-bottom))',
          transform: open ? 'translateY(0)' : 'translateY(100%)',
          transition: 'transform 0.3s cubic-bezier(0.32, 0.72, 0, 1)',
          maxHeight: '88vh',
          overflowY: 'auto',
          willChange: 'transform',
        }}
      >
        {/* Handle */}
        <div style={{ display: 'flex', justifyContent: 'center', padding: '12px 0 4px' }}>
          <div style={{ width: '36px', height: '4px', borderRadius: '999px', backgroundColor: 'var(--border)' }} />
        </div>

        {/* Header */}
        <div style={{
          display: 'flex', alignItems: 'center', justifyContent: 'space-between',
          padding: '12px 20px 20px',
          borderBottom: '1px solid var(--border-soft)',
        }}>
          <span style={{ fontSize: '18px', fontWeight: 800, color: 'var(--text)' }}>Filters</span>
          <button
            onClick={clearAll}
            style={{
              background: 'none', border: 'none', cursor: 'pointer',
              fontSize: '13px', fontWeight: 600, color: 'var(--text-dim)',
              padding: '4px 0',
            }}
          >
            Clear all
          </button>
        </div>

        <div style={{ padding: '0 20px' }}>

          {/* ── Stim type ── */}
          <section style={{ padding: '20px 0', borderBottom: '1px solid var(--border-soft)' }}>
            <h3 style={{ fontSize: '13px', fontWeight: 700, color: 'var(--text-dim)', textTransform: 'uppercase', letterSpacing: '0.08em', margin: '0 0 14px' }}>
              Stimulants
            </h3>
            <div style={{ display: 'flex', gap: '8px' }}>
              {STIM_OPTIONS.map((opt) => (
                <button
                  key={opt.value}
                  onClick={() => setPendingStim(opt.value)}
                  style={{
                    flex: 1,
                    padding: '10px 0',
                    borderRadius: '10px',
                    fontSize: '14px',
                    fontWeight: 600,
                    cursor: 'pointer',
                    border: pendingStim === opt.value ? '2px solid var(--accent)' : '1px solid var(--border)',
                    backgroundColor: pendingStim === opt.value ? 'var(--accent-dim)' : 'var(--bg-elevated)',
                    color: pendingStim === opt.value ? 'var(--accent)' : 'var(--text-dim)',
                    transition: 'all 0.12s ease',
                  }}
                >
                  {opt.label}
                </button>
              ))}
            </div>
          </section>

          {/* ── Region ── */}
          <section style={{ padding: '20px 0', borderBottom: '1px solid var(--border-soft)' }}>
            <h3 style={{ fontSize: '13px', fontWeight: 700, color: 'var(--text-dim)', textTransform: 'uppercase', letterSpacing: '0.08em', margin: '0 0 4px' }}>
              Region
            </h3>
            <p style={{ fontSize: '11px', color: 'var(--text-faint)', margin: '0 0 14px', lineHeight: 1.5 }}>
              Based on the brand&apos;s official website — not third-party resellers.
            </p>
            <div style={{ display: 'flex', gap: '8px', flexWrap: 'wrap' }}>
              {REGIONS.map((r) => {
                const active = pendingRegions.includes(r)
                return (
                  <button
                    key={r}
                    onClick={() => toggleRegion(r)}
                    style={{
                      padding: '9px 18px',
                      borderRadius: '10px',
                      fontSize: '14px',
                      fontWeight: 600,
                      cursor: 'pointer',
                      border: active ? '2px solid var(--accent)' : '1px solid var(--border)',
                      backgroundColor: active ? 'var(--accent-dim)' : 'var(--bg-elevated)',
                      color: active ? 'var(--accent)' : 'var(--text-dim)',
                      transition: 'all 0.12s ease',
                    }}
                  >
                    {r}
                  </button>
                )
              })}
            </div>
          </section>

          {/* ── Min rating ── */}
          <section style={{ padding: '20px 0', borderBottom: '1px solid var(--border-soft)' }}>
            <h3 style={{ fontSize: '13px', fontWeight: 700, color: 'var(--text-dim)', textTransform: 'uppercase', letterSpacing: '0.08em', margin: '0 0 14px' }}>
              Minimum Rating
            </h3>
            <div style={{ display: 'flex', gap: '8px', flexWrap: 'wrap' }}>
              {MIN_RATINGS.map((opt) => (
                <button
                  key={opt.value}
                  onClick={() => setPendingMinRating(opt.value)}
                  style={{
                    flex: 1,
                    minWidth: '48px',
                    padding: '10px 4px',
                    borderRadius: '10px',
                    fontSize: '14px',
                    fontWeight: 600,
                    cursor: 'pointer',
                    border: pendingMinRating === opt.value ? '2px solid var(--accent)' : '1px solid var(--border)',
                    backgroundColor: pendingMinRating === opt.value ? 'var(--accent-dim)' : 'var(--bg-elevated)',
                    color: pendingMinRating === opt.value ? 'var(--accent)' : 'var(--text-dim)',
                    transition: 'all 0.12s ease',
                  }}
                >
                  {opt.label}
                </button>
              ))}
            </div>
          </section>

          {/* ── Brand ── */}
          <section style={{ padding: '20px 0', borderBottom: '1px solid var(--border-soft)' }}>
            <h3 style={{ fontSize: '13px', fontWeight: 700, color: 'var(--text-dim)', textTransform: 'uppercase', letterSpacing: '0.08em', margin: '0 0 14px' }}>
              Brand
            </h3>
            <div style={{ display: 'flex', gap: '8px', flexWrap: 'wrap' }}>
              <button
                onClick={() => setPendingBrand('')}
                style={{
                  padding: '9px 18px',
                  borderRadius: '10px',
                  fontSize: '14px',
                  fontWeight: 600,
                  cursor: 'pointer',
                  border: pendingBrand === '' ? '2px solid var(--accent)' : '1px solid var(--border)',
                  backgroundColor: pendingBrand === '' ? 'var(--accent-dim)' : 'var(--bg-elevated)',
                  color: pendingBrand === '' ? 'var(--accent)' : 'var(--text-dim)',
                  transition: 'all 0.12s ease',
                }}
              >
                All
              </button>
              {allBrands.map((b) => (
                <button
                  key={b.slug}
                  onClick={() => setPendingBrand(b.slug === pendingBrand ? '' : b.slug)}
                  style={{
                    padding: '9px 18px',
                    borderRadius: '10px',
                    fontSize: '14px',
                    fontWeight: 600,
                    cursor: 'pointer',
                    border: pendingBrand === b.slug ? '2px solid var(--accent)' : '1px solid var(--border)',
                    backgroundColor: pendingBrand === b.slug ? 'var(--accent-dim)' : 'var(--bg-elevated)',
                    color: pendingBrand === b.slug ? 'var(--accent)' : 'var(--text-dim)',
                    transition: 'all 0.12s ease',
                  }}
                >
                  {b.name}
                </button>
              ))}
            </div>
          </section>

          {/* ── Price (coming soon) ── */}
          <section style={{ padding: '20px 0' }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
              <h3 style={{ fontSize: '13px', fontWeight: 700, color: 'var(--text-faint)', textTransform: 'uppercase', letterSpacing: '0.08em', margin: 0 }}>
                Price
              </h3>
              <span style={{
                fontSize: '10px', fontWeight: 700, textTransform: 'uppercase', letterSpacing: '0.08em',
                backgroundColor: 'var(--bg-elevated)', color: 'var(--text-faint)',
                border: '1px solid var(--border)', borderRadius: '999px',
                padding: '2px 8px',
              }}>
                Coming soon
              </span>
            </div>
          </section>

        </div>

        {/* Apply button */}
        <div style={{ padding: '0 20px' }}>
          <button
            onClick={applyFilters}
            style={{
              width: '100%',
              padding: '16px',
              borderRadius: '14px',
              fontSize: '16px',
              fontWeight: 800,
              backgroundColor: 'var(--accent)',
              color: '#000',
              border: 'none',
              cursor: 'pointer',
              letterSpacing: '-0.01em',
            }}
          >
            Apply filters
          </button>
        </div>
      </div>
    </>
  )
}

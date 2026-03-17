'use client'

export function StickyRateCTA({ slug }: { slug: string }) {
  return (
    <>
      <style>{`@media (min-width: 640px) { .sticky-rate-cta { display: none !important; } }`}</style>
      <div
        className="sticky-rate-cta"
        style={{
          position: 'fixed',
          bottom: 0,
          left: 0,
          right: 0,
          zIndex: 40,
          backgroundColor: 'var(--bg-card)',
          borderTop: '1px solid var(--border)',
          padding: '12px 16px',
          paddingBottom: 'max(12px, env(safe-area-inset-bottom))',
        }}
      >
        <a
          href={`/rate/${slug}`}
          style={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            width: '100%',
            height: '48px',
            backgroundColor: 'var(--accent)',
            color: '#000',
            fontWeight: 800,
            fontSize: '15px',
            borderRadius: 'var(--radius-md)',
            textDecoration: 'none',
            WebkitTapHighlightColor: 'transparent',
            letterSpacing: '0.01em',
          }}
        >
          Rate This Flavor
        </a>
      </div>
    </>
  )
}

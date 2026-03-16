'use client'

export default function Error({
  reset,
}: {
  error: Error & { digest?: string }
  reset: () => void
}) {
  return (
    <div style={{ padding: '64px 16px', textAlign: 'center', maxWidth: '400px', margin: '0 auto' }}>
      <div style={{ fontSize: '32px', marginBottom: '16px', opacity: 0.4 }}>⚠️</div>
      <p style={{ color: 'var(--text-dim)', fontSize: '15px', margin: '0 0 20px', lineHeight: 1.5 }}>
        Something went wrong.
      </p>
      <button
        onClick={reset}
        style={{
          padding: '11px 24px',
          backgroundColor: 'var(--accent)',
          color: '#000',
          fontWeight: 700,
          fontSize: '14px',
          borderRadius: 'var(--radius-md)',
          border: 'none',
          cursor: 'pointer',
          fontFamily: 'inherit',
        }}
      >
        Try again
      </button>
    </div>
  )
}

export default function Loading() {
  return (
    <div style={{ padding: '20px 16px', maxWidth: 600, margin: '0 auto' }}>
      <div className="skeleton" style={{ height: 32, width: 200, marginBottom: 24, borderRadius: 'var(--radius-md)' }} />
      <div style={{ display: 'flex', gap: 12, marginBottom: 24 }}>
        {[1, 2, 3, 4].map(i => (
          <div key={i} className="skeleton" style={{ height: 64, flex: 1, borderRadius: 'var(--radius-md)' }} />
        ))}
      </div>
      {[1, 2, 3].map(i => (
        <div key={i} className="skeleton" style={{ height: 140, width: '100%', marginBottom: 12, borderRadius: 'var(--radius-lg)' }} />
      ))}
    </div>
  )
}

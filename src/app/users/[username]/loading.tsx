export default function Loading() {
  return (
    <div style={{ padding: '20px 16px', maxWidth: 600, margin: '0 auto', display: 'flex', flexDirection: 'column' as const, alignItems: 'center' }}>
      <div className="skeleton" style={{ height: 64, width: 64, borderRadius: '50%', marginBottom: 12 }} />
      <div className="skeleton" style={{ height: 20, width: 140, marginBottom: 8, borderRadius: 'var(--radius-md)' }} />
      <div className="skeleton" style={{ height: 16, width: 200, marginBottom: 24, borderRadius: 'var(--radius-md)' }} />
      {[1, 2, 3].map(i => (
        <div key={i} className="skeleton" style={{ height: 120, width: '100%', marginBottom: 12, borderRadius: 'var(--radius-lg)' }} />
      ))}
    </div>
  )
}

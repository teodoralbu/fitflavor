export default function Loading() {
  return (
    <div style={{ padding: '20px 16px', maxWidth: 600, margin: '0 auto' }}>
      <div className="skeleton" style={{ height: 24, width: 180, marginBottom: 16, borderRadius: 'var(--radius-md)' }} />
      {[1, 2, 3, 4, 5].map(i => (
        <div key={i} className="skeleton" style={{ height: 72, width: '100%', marginBottom: 8, borderRadius: 'var(--radius-md)' }} />
      ))}
    </div>
  )
}

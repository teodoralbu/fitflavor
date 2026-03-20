export default function Loading() {
  return (
    <div style={{ padding: '20px 16px', maxWidth: 600, margin: '0 auto' }}>
      <div className="skeleton" style={{ height: 24, width: 240, marginBottom: 16, borderRadius: 'var(--radius-md)' }} />
      <div className="skeleton" style={{ height: 200, width: '100%', marginBottom: 16, borderRadius: 'var(--radius-lg)' }} />
      <div className="skeleton" style={{ height: 16, width: '80%', marginBottom: 8, borderRadius: 'var(--radius-md)' }} />
      <div className="skeleton" style={{ height: 16, width: '60%', marginBottom: 24, borderRadius: 'var(--radius-md)' }} />
    </div>
  )
}

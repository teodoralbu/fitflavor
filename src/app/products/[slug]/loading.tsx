export default function Loading() {
  return (
    <div style={{ padding: '20px 16px', maxWidth: 600, margin: '0 auto' }}>
      <div className="skeleton" style={{ height: 24, width: 200, marginBottom: 16, borderRadius: 'var(--radius-md)' }} />
      <div className="skeleton" style={{ height: 180, width: '100%', marginBottom: 16, borderRadius: 'var(--radius-lg)' }} />
      <div className="skeleton" style={{ height: 16, width: '90%', marginBottom: 8, borderRadius: 'var(--radius-md)' }} />
      <div className="skeleton" style={{ height: 16, width: '70%', marginBottom: 8, borderRadius: 'var(--radius-md)' }} />
      <div className="skeleton" style={{ height: 16, width: '50%', borderRadius: 'var(--radius-md)' }} />
    </div>
  )
}

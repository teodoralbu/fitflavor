'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { useAuth } from '@/context/auth-context'

export function BottomNav() {
  const pathname = usePathname()
  const { profile } = useAuth()

  const profileHref = profile?.username ? `/users/${profile.username}` : '/login'

  function isActive(href: string, exact = false) {
    if (exact) return pathname === href
    return pathname.startsWith(href)
  }

  const homeActive = pathname === '/'
  const browseActive = pathname.startsWith('/browse') || pathname.startsWith('/products') || pathname.startsWith('/flavors')
  const rateActive = pathname.startsWith('/rate')
  const profileActive = pathname.startsWith('/users') || pathname.startsWith('/login') || pathname.startsWith('/signup') || pathname.startsWith('/settings')

  return (
    <nav
      className="sm:hidden"
      style={{
        position: 'fixed',
        bottom: 0,
        left: 0,
        right: 0,
        zIndex: 50,
        backgroundColor: 'var(--bg-card)',
        borderTop: '1px solid var(--border)',
        paddingBottom: 'env(safe-area-inset-bottom)',
        display: 'flex',
        alignItems: 'stretch',
      }}
    >
      {/* Home */}
      <Link
        href="/"
        style={{
          flex: 1,
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          justifyContent: 'center',
          gap: '4px',
          padding: '10px 4px',
          minHeight: '56px',
          color: homeActive ? 'var(--accent)' : 'var(--text-faint)',
          textDecoration: 'none',
          WebkitTapHighlightColor: 'transparent',
          touchAction: 'manipulation',
          userSelect: 'none',
          position: 'relative',
        }}
      >
        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
          <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" />
          <polyline points="9 22 9 12 15 12 15 22" />
        </svg>
        <span style={{ fontSize: '10px', fontWeight: homeActive ? 700 : 500, lineHeight: 1, letterSpacing: '0.01em' }}>
          Home
        </span>
        {homeActive && (
          <span style={{
            position: 'absolute', bottom: '6px', left: '50%',
            transform: 'translateX(-50%)', width: '4px', height: '4px',
            borderRadius: '50%', backgroundColor: 'var(--accent)',
          }} />
        )}
      </Link>

      {/* Browse */}
      <Link
        href="/browse"
        style={{
          flex: 1,
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          justifyContent: 'center',
          gap: '4px',
          padding: '10px 4px',
          minHeight: '56px',
          color: browseActive ? 'var(--accent)' : 'var(--text-faint)',
          textDecoration: 'none',
          WebkitTapHighlightColor: 'transparent',
          touchAction: 'manipulation',
          userSelect: 'none',
          position: 'relative',
        }}
      >
        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
          <circle cx="11" cy="11" r="8" /><line x1="21" y1="21" x2="16.65" y2="16.65" />
        </svg>
        <span style={{ fontSize: '10px', fontWeight: browseActive ? 700 : 500, lineHeight: 1, letterSpacing: '0.01em' }}>
          Browse
        </span>
        {browseActive && (
          <span style={{
            position: 'absolute', bottom: '6px', left: '50%',
            transform: 'translateX(-50%)', width: '4px', height: '4px',
            borderRadius: '50%', backgroundColor: 'var(--accent)',
          }} />
        )}
      </Link>

      {/* Rate — center hero tab */}
      <Link
        href="/rate"
        style={{
          flex: 1,
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          justifyContent: 'center',
          gap: '4px',
          padding: '10px 4px',
          minHeight: '56px',
          textDecoration: 'none',
          WebkitTapHighlightColor: 'transparent',
          touchAction: 'manipulation',
          userSelect: 'none',
          color: rateActive ? '#000' : 'var(--text-faint)',
        }}
      >
        <div style={{
          width: '40px',
          height: '40px',
          borderRadius: '14px',
          backgroundColor: rateActive ? 'var(--accent)' : 'color-mix(in srgb, var(--accent) 18%, transparent)',
          border: `1.5px solid ${rateActive ? 'var(--accent)' : 'color-mix(in srgb, var(--accent) 35%, transparent)'}`,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          transition: 'all 0.15s ease',
          boxShadow: rateActive ? '0 0 12px color-mix(in srgb, var(--accent) 40%, transparent)' : 'none',
        }}>
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={rateActive ? '#000' : 'var(--accent)'} strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
            <line x1="12" y1="5" x2="12" y2="19" />
            <line x1="5" y1="12" x2="19" y2="12" />
          </svg>
        </div>
        <span style={{ fontSize: '10px', fontWeight: 700, lineHeight: 1, letterSpacing: '0.01em', color: rateActive ? 'var(--accent)' : 'var(--text-faint)', marginTop: '-2px' }}>
          Rate
        </span>
      </Link>

      {/* Profile */}
      <Link
        href={profileHref}
        style={{
          flex: 1,
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          justifyContent: 'center',
          gap: '4px',
          padding: '10px 4px',
          minHeight: '56px',
          color: profileActive ? 'var(--accent)' : 'var(--text-faint)',
          textDecoration: 'none',
          WebkitTapHighlightColor: 'transparent',
          touchAction: 'manipulation',
          userSelect: 'none',
          position: 'relative',
        }}
      >
        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
          <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
          <circle cx="12" cy="7" r="4" />
        </svg>
        <span style={{ fontSize: '10px', fontWeight: profileActive ? 700 : 500, lineHeight: 1, letterSpacing: '0.01em' }}>
          Profile
        </span>
        {profileActive && (
          <span style={{
            position: 'absolute', bottom: '6px', left: '50%',
            transform: 'translateX(-50%)', width: '4px', height: '4px',
            borderRadius: '50%', backgroundColor: 'var(--accent)',
          }} />
        )}
      </Link>
    </nav>
  )
}

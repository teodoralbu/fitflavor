'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { useAuth } from '@/context/auth-context'
import { useEffect, useRef, useState } from 'react'

const tabs = [
  {
    label: 'Home',
    href: '/',
    exact: true,
    isRep: false,
    icon: (
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" />
        <polyline points="9 22 9 12 15 12 15 22" />
      </svg>
    ),
  },
  {
    label: 'Rep',
    href: '/rep',
    exact: false,
    isRep: true,
    icon: (
      <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
        <circle cx="12" cy="12" r="10" />
        <line x1="12" y1="8" x2="12" y2="16" />
        <line x1="8" y1="12" x2="16" y2="12" />
      </svg>
    ),
  },
  {
    label: 'Top',
    href: '/leaderboard',
    exact: false,
    isRep: false,
    icon: (
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <polyline points="18 20 18 10" />
        <polyline points="12 20 12 4" />
        <polyline points="6 20 6 14" />
      </svg>
    ),
  },
  {
    label: 'Search',
    href: '/search',
    exact: false,
    isRep: false,
    icon: (
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <circle cx="11" cy="11" r="8" />
        <line x1="21" y1="21" x2="16.65" y2="16.65" />
      </svg>
    ),
  },
]

export function BottomNav() {
  const pathname = usePathname()
  const { profile } = useAuth()
  const [visible, setVisible] = useState(true)
  const lastScrollY = useRef(0)

  useEffect(() => {
    function handleScroll() {
      const currentY = window.scrollY
      if (currentY < 60) {
        // Always show when near top
        setVisible(true)
      } else if (currentY > lastScrollY.current) {
        // Scrolling down — hide
        setVisible(false)
      } else {
        // Scrolling up — show
        setVisible(true)
      }
      lastScrollY.current = currentY
    }

    window.addEventListener('scroll', handleScroll, { passive: true })
    return () => window.removeEventListener('scroll', handleScroll)
  }, [])

  const profileTab = {
    label: 'Profile',
    href: profile?.username ? `/users/${profile.username}` : '/login',
    exact: false,
    isRep: false,
    icon: (
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
        <circle cx="12" cy="7" r="4" />
      </svg>
    ),
  }

  const allTabs = [...tabs, profileTab]

  function isActive(tab: { href: string; exact: boolean }) {
    if (tab.exact) return pathname === tab.href
    return pathname.startsWith(tab.href)
  }

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
        backdropFilter: 'blur(16px)',
        WebkitBackdropFilter: 'blur(16px)',
        borderTop: '1px solid var(--border)',
        paddingBottom: 'env(safe-area-inset-bottom)',
        display: 'flex',
        alignItems: 'stretch',
        transform: visible ? 'translateY(0)' : 'translateY(100%)',
        transition: 'transform 0.25s ease',
      }}
    >
      {allTabs.map((tab) => {
        const active = isActive(tab)
        const isRepTab = tab.isRep
        return (
          <Link
            key={tab.href}
            href={tab.href}
            style={{
              flex: 1,
              display: 'flex',
              flexDirection: 'column',
              alignItems: 'center',
              justifyContent: 'center',
              gap: '4px',
              padding: '10px 4px 10px',
              color: isRepTab ? 'var(--accent)' : active ? 'var(--accent)' : 'var(--text-faint)',
              textDecoration: 'none',
              WebkitTapHighlightColor: 'transparent',
              transition: 'color 0.15s ease',
              userSelect: 'none',
            }}
          >
            <span
              style={{
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                position: 'relative',
              }}
            >
              {tab.icon}
              {active && !isRepTab && (
                <span
                  style={{
                    position: 'absolute',
                    bottom: '-6px',
                    left: '50%',
                    transform: 'translateX(-50%)',
                    width: '4px',
                    height: '4px',
                    borderRadius: '50%',
                    backgroundColor: 'var(--accent)',
                  }}
                />
              )}
            </span>
            <span
              style={{
                fontSize: '10px',
                fontWeight: active || isRepTab ? 700 : 500,
                lineHeight: 1,
                letterSpacing: '0.01em',
                marginTop: '4px',
              }}
            >
              {tab.label}
            </span>
          </Link>
        )
      })}
    </nav>
  )
}

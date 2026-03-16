'use client'

import { createContext, useContext, useState, useCallback, useRef } from 'react'

interface ToastContextValue {
  showToast: (message: string) => void
}

const ToastContext = createContext<ToastContextValue>({ showToast: () => {} })

export function useToast() {
  return useContext(ToastContext)
}

export function ToastProvider({ children }: { children: React.ReactNode }) {
  const [message, setMessage] = useState<string | null>(null)
  const [visible, setVisible] = useState(false)
  const timerRef = useRef<ReturnType<typeof setTimeout> | null>(null)

  const showToast = useCallback((msg: string) => {
    // Clear any pending hide timer
    if (timerRef.current) clearTimeout(timerRef.current)

    setMessage(msg)
    setVisible(true)

    // After 2s, slide back down
    timerRef.current = setTimeout(() => {
      setVisible(false)
    }, 2000)
  }, [])

  return (
    <ToastContext.Provider value={{ showToast }}>
      {children}
      {message !== null && (
        <div
          aria-live="polite"
          style={{
            position: 'fixed',
            bottom: 'calc(64px + env(safe-area-inset-bottom) + 12px)',
            left: '50%',
            transform: visible
              ? 'translateX(-50%) translateY(0)'
              : 'translateX(-50%) translateY(calc(100% + 24px))',
            transition: 'transform 0.25s cubic-bezier(0.16, 1, 0.3, 1)',
            zIndex: 200,
            backgroundColor: 'var(--bg-elevated)',
            border: '1px solid var(--border)',
            color: 'var(--text)',
            fontSize: '13px',
            fontWeight: 600,
            padding: '10px 16px',
            borderRadius: '999px',
            whiteSpace: 'nowrap',
            boxShadow: 'var(--shadow-md)',
            pointerEvents: 'none',
            // Only show on mobile — screen width checked at render time via CSS max-width media query
          }}
          className="toast-mobile-only"
        >
          {message}
        </div>
      )}
    </ToastContext.Provider>
  )
}

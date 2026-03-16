'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { createClient } from '@/lib/supabase'
import { useAuth } from '@/context/auth-context'
import { useToast } from '@/context/ToastContext'

interface Props {
  ratingId: string
  initialCount: number
  initialLiked: boolean
}

export function LikeButton({ ratingId, initialCount, initialLiked }: Props) {
  const { user } = useAuth()
  const router = useRouter()
  const { showToast } = useToast()
  const [liked, setLiked] = useState(initialLiked)
  const [count, setCount] = useState(initialCount)
  const [loading, setLoading] = useState(false)
  const [animating, setAnimating] = useState(false)

  async function toggle() {
    if (!user) {
      router.push('/login')
      return
    }

    // Haptic feedback on both like and unlike
    navigator.vibrate?.(30)

    setLoading(true)
    const supabase = createClient()
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const db = supabase as any

    if (liked) {
      await db.from('review_likes').delete()
        .eq('user_id', user.id)
        .eq('rating_id', ratingId)
      setLiked(false)
      setCount((c: number) => c - 1)
      showToast('Unliked')
    } else {
      await db.from('review_likes').insert({ user_id: user.id, rating_id: ratingId })
      setLiked(true)
      setCount((c: number) => c + 1)
      // Trigger animation only on like (unliked → liked)
      setAnimating(true)
      setTimeout(() => setAnimating(false), 300)
      showToast('❤️ Liked')
    }

    setLoading(false)
    router.refresh()
  }

  return (
    <button
      onClick={toggle}
      disabled={loading}
      style={{
        display: 'inline-flex', alignItems: 'center', gap: '5px',
        padding: '5px 12px', borderRadius: '999px', fontSize: '12px', fontWeight: 600,
        cursor: loading ? 'not-allowed' : 'pointer',
        border: liked ? '1px solid #00B4FF44' : '1px solid #2A2A2A',
        backgroundColor: liked ? '#00B4FF14' : 'transparent',
        color: liked ? '#00B4FF' : '#555',
        transition: 'all 0.15s',
        fontFamily: 'inherit',
        WebkitTapHighlightColor: 'transparent',
      }}
    >
      <span className={animating ? 'heart-pop' : undefined} style={{ display: 'inline-block' }}>
        {liked ? '♥' : '♡'}
      </span>
      {count > 0 && <span>{count}</span>}
    </button>
  )
}

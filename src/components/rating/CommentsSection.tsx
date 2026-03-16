'use client'

import { useState } from 'react'
import Link from 'next/link'
import { createClient } from '@/lib/supabase'
import { useAuth } from '@/context/auth-context'
import { timeAgo } from '@/lib/timeAgo'

interface Comment {
  id: string
  text: string
  created_at: string
  user: { username: string; avatar_url: string | null } | null
}

interface Props {
  ratingId: string
  initialCount: number
}

export function CommentsSection({ ratingId, initialCount }: Props) {
  const { user, profile } = useAuth()
  const [comments, setComments] = useState<Comment[]>([])
  const [text, setText] = useState('')
  const [loading, setLoading] = useState(false)
  const [expanded, setExpanded] = useState(false)
  const [count, setCount] = useState(initialCount)
  const supabase = createClient()

  const loadComments = async () => {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const db = supabase as any
    const { data } = await db
      .from('comments')
      .select('id, text, created_at, user_id')
      .eq('rating_id', ratingId)
      .order('created_at', { ascending: true })
      .limit(20)

    if (!data || data.length === 0) { setComments([]); return }

    const userIds = data.map((c: any) => c.user_id)
    const { data: users } = await db.from('users').select('id, username, avatar_url').in('id', userIds)
    const userMap: Record<string, any> = {}
    for (const u of (users ?? []) as any[]) userMap[u.id] = u

    setComments(data.map((c: any) => ({
      id: c.id,
      text: c.text,
      created_at: c.created_at,
      user: userMap[c.user_id] ?? null,
    })))
    setCount(data.length)
  }

  const handleExpand = () => {
    if (!expanded) loadComments()
    setExpanded(!expanded)
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!user || !text.trim()) return
    setLoading(true)
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const db = supabase as any
    const { error } = await db.from('comments').insert({
      rating_id: ratingId,
      user_id: user.id,
      text: text.trim().slice(0, 280),
    })
    if (!error) {
      setText('')
      setCount(c => c + 1)
      await loadComments()
    }
    setLoading(false)
  }

  return (
    <div style={{ borderTop: '1px solid var(--border-soft)' }}>
      {/* Toggle comments */}
      <button
        onClick={handleExpand}
        style={{
          display: 'flex', alignItems: 'center', gap: '6px',
          padding: '10px 16px', background: 'none', border: 'none',
          cursor: 'pointer', color: 'var(--text-dim)', fontSize: '13px',
          fontWeight: 600, fontFamily: 'inherit', WebkitTapHighlightColor: 'transparent',
        }}
      >
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
          <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z" />
        </svg>
        {count > 0 ? `${count} comment${count !== 1 ? 's' : ''}` : 'Comment'}
      </button>

      {expanded && (
        <div style={{ padding: '0 16px 12px' }}>
          {/* Comment list */}
          {comments.map((comment) => (
            <div key={comment.id} style={{ display: 'flex', gap: '8px', marginBottom: '10px' }}>
              <Link href={`/users/${comment.user?.username}`} style={{ textDecoration: 'none', flexShrink: 0 }}>
                <div style={{
                  width: '26px', height: '26px', borderRadius: '50%',
                  backgroundColor: 'var(--bg-elevated)', border: '1px solid var(--border)',
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                  fontSize: '10px', fontWeight: 800, color: 'var(--accent)', overflow: 'hidden',
                }}>
                  {comment.user?.avatar_url ? (
                    // eslint-disable-next-line @next/next/no-img-element
                    <img src={comment.user.avatar_url} alt="" style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
                  ) : (
                    comment.user?.username?.[0]?.toUpperCase() ?? '?'
                  )}
                </div>
              </Link>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{
                  backgroundColor: 'var(--bg-elevated)', borderRadius: '10px',
                  padding: '7px 10px',
                }}>
                  <div style={{ fontSize: '12px', fontWeight: 700, color: 'var(--text)', marginBottom: '2px' }}>
                    {comment.user?.username ?? 'anon'}
                    <span style={{ fontSize: '11px', color: 'var(--text-faint)', fontWeight: 400, marginLeft: '6px' }}>
                      {timeAgo(comment.created_at)}
                    </span>
                  </div>
                  <div style={{ fontSize: '13px', color: 'var(--text-muted)', lineHeight: 1.5 }}>
                    {comment.text}
                  </div>
                </div>
              </div>
            </div>
          ))}

          {/* Input */}
          {user ? (
            <form onSubmit={handleSubmit} style={{ display: 'flex', gap: '8px', marginTop: '8px' }}>
              <div style={{
                width: '26px', height: '26px', borderRadius: '50%', flexShrink: 0,
                backgroundColor: 'var(--bg-elevated)', border: '1px solid var(--border)',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                fontSize: '10px', fontWeight: 800, color: 'var(--accent)',
              }}>
                {profile?.username?.[0]?.toUpperCase() ?? '?'}
              </div>
              <input
                value={text}
                onChange={(e) => setText(e.target.value)}
                placeholder="Add a comment..."
                maxLength={280}
                style={{
                  flex: 1, background: 'var(--bg-elevated)', border: '1px solid var(--border)',
                  borderRadius: '20px', padding: '6px 14px', fontSize: '13px',
                  color: 'var(--text)', outline: 'none', fontFamily: 'inherit',
                }}
              />
              <button
                type="submit"
                disabled={!text.trim() || loading}
                style={{
                  padding: '6px 14px', borderRadius: '20px', fontSize: '12px',
                  fontWeight: 700, border: 'none', cursor: 'pointer',
                  backgroundColor: text.trim() ? 'var(--accent)' : 'var(--bg-elevated)',
                  color: text.trim() ? '#000' : 'var(--text-faint)',
                  transition: 'all 0.15s', fontFamily: 'inherit',
                }}
              >
                {loading ? '...' : 'Post'}
              </button>
            </form>
          ) : (
            <Link href="/login" style={{ fontSize: '12px', color: 'var(--accent)', display: 'block', marginTop: '8px' }}>
              Log in to comment
            </Link>
          )}
        </div>
      )}
    </div>
  )
}

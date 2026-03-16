export const dynamic = 'force-dynamic'

import Link from 'next/link'
import { createServerSupabaseClient } from '@/lib/supabase-server'
import { timeAgo } from '@/lib/timeAgo'

interface NotificationItem {
  id: string
  type: 'like' | 'comment' | 'follow'
  created_at: string
  actor_username: string
  actor_avatar: string | null
  // for like/comment
  flavor_name?: string
  flavor_slug?: string
  // for comment
  comment_preview?: string
}

async function getNotifications(userId: string): Promise<NotificationItem[]> {
  const supabase = await createServerSupabaseClient()
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const db = supabase as any

  const [likesResult, commentsResult, followsResult] = await Promise.all([
    // Likes on the user's ratings
    db
      .from('review_likes')
      .select(`
        id,
        created_at,
        user:users!review_likes_user_id_fkey (username, avatar_url),
        rating:ratings!review_likes_rating_id_fkey (
          flavor:flavors (name, slug)
        )
      `)
      .eq('ratings.user_id', userId)
      .order('created_at', { ascending: false })
      .limit(30),

    // Comments on the user's ratings
    db
      .from('comments')
      .select(`
        id,
        created_at,
        content,
        user:users!comments_user_id_fkey (username, avatar_url),
        rating:ratings!comments_rating_id_fkey (
          flavor:flavors (name, slug)
        )
      `)
      .eq('ratings.user_id', userId)
      .order('created_at', { ascending: false })
      .limit(30),

    // New followers
    db
      .from('follows')
      .select(`
        id,
        created_at,
        follower:users!follows_follower_id_fkey (username, avatar_url)
      `)
      .eq('following_id', userId)
      .order('created_at', { ascending: false })
      .limit(30),
  ])

  const items: NotificationItem[] = []

  // Process likes
  if (likesResult.data) {
    for (const row of likesResult.data) {
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      const r = row as any
      const actor = r.user
      const flavor = r.rating?.flavor
      if (!actor?.username) continue
      items.push({
        id: `like-${r.id}`,
        type: 'like',
        created_at: r.created_at,
        actor_username: actor.username,
        actor_avatar: actor.avatar_url ?? null,
        flavor_name: flavor?.name ?? 'a flavor',
        flavor_slug: flavor?.slug ?? '',
      })
    }
  }

  // Process comments
  if (commentsResult.data) {
    for (const row of commentsResult.data) {
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      const r = row as any
      const actor = r.user
      const flavor = r.rating?.flavor
      if (!actor?.username) continue
      items.push({
        id: `comment-${r.id}`,
        type: 'comment',
        created_at: r.created_at,
        actor_username: actor.username,
        actor_avatar: actor.avatar_url ?? null,
        flavor_name: flavor?.name ?? 'a flavor',
        flavor_slug: flavor?.slug ?? '',
        comment_preview: (r.content as string)?.slice(0, 40) ?? '',
      })
    }
  }

  // Process follows
  if (followsResult.data) {
    for (const row of followsResult.data) {
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      const r = row as any
      const actor = r.follower
      if (!actor?.username) continue
      items.push({
        id: `follow-${r.id}`,
        type: 'follow',
        created_at: r.created_at,
        actor_username: actor.username,
        actor_avatar: actor.avatar_url ?? null,
      })
    }
  }

  // Sort all by created_at descending
  items.sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime())

  return items.slice(0, 30)
}

export default async function NotificationsPage() {
  const supabase = await createServerSupabaseClient()
  const { data: { user } } = await supabase.auth.getUser()

  if (!user) {
    return (
      <div style={{ maxWidth: '480px', margin: '0 auto', padding: '64px 16px', textAlign: 'center' }}>
        <div style={{ fontSize: '32px', marginBottom: '16px', opacity: 0.5 }}>🔔</div>
        <p style={{ color: 'var(--text-dim)', fontSize: '15px', margin: '0 0 20px' }}>
          Log in to see notifications
        </p>
        <Link
          href="/login"
          style={{
            display: 'inline-block', backgroundColor: 'var(--accent)', color: '#000',
            fontWeight: 700, fontSize: '14px', padding: '11px 24px',
            borderRadius: 'var(--radius-md)', textDecoration: 'none',
          }}
        >
          Log in
        </Link>
      </div>
    )
  }

  const notifications = await getNotifications(user.id)

  return (
    <div style={{ maxWidth: '480px', margin: '0 auto', padding: '16px 0 96px' }}>
      {/* Header */}
      <div style={{ padding: '8px 16px 16px' }}>
        <h1 style={{ fontSize: '20px', fontWeight: 900, color: 'var(--text)', margin: 0, letterSpacing: '-0.02em' }}>
          Notifications
        </h1>
      </div>

      {notifications.length === 0 ? (
        <div style={{ padding: '48px 16px', textAlign: 'center' }}>
          <div style={{ fontSize: '32px', marginBottom: '12px', opacity: 0.4 }}>🔔</div>
          <p style={{ color: 'var(--text-dim)', fontSize: '14px', margin: 0 }}>
            No notifications yet.
          </p>
        </div>
      ) : (
        <div style={{ backgroundColor: 'var(--bg-card)' }}>
          {notifications.map((notif, idx) => {
            const href =
              notif.type === 'follow'
                ? `/users/${notif.actor_username}`
                : `/flavors/${notif.flavor_slug}`

            return (
              <Link
                key={notif.id}
                href={href}
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: '10px',
                  padding: '12px 16px',
                  textDecoration: 'none',
                  color: 'inherit',
                  borderBottom: idx < notifications.length - 1
                    ? '1px solid var(--border-soft)'
                    : 'none',
                  WebkitTapHighlightColor: 'transparent',
                }}
              >
                {/* Avatar */}
                <div style={{
                  width: '24px', height: '24px', borderRadius: '50%', flexShrink: 0,
                  backgroundColor: 'var(--bg-elevated)', border: '1px solid var(--border)',
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                  fontSize: '9px', fontWeight: 800, color: 'var(--accent)', overflow: 'hidden',
                }}>
                  {notif.actor_avatar ? (
                    // eslint-disable-next-line @next/next/no-img-element
                    <img src={notif.actor_avatar} alt="" style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
                  ) : (
                    notif.actor_username[0]?.toUpperCase() ?? '?'
                  )}
                </div>

                {/* Text */}
                <div style={{ flex: 1, minWidth: 0 }}>
                  <p style={{ margin: 0, fontSize: '13px', color: 'var(--text)', lineHeight: 1.4 }}>
                    <span style={{ fontWeight: 700 }}>{notif.actor_username}</span>
                    {notif.type === 'like' && (
                      <> liked your review of <span style={{ fontWeight: 700 }}>{notif.flavor_name}</span></>
                    )}
                    {notif.type === 'comment' && (
                      <> commented: <span style={{ color: 'var(--text-muted)' }}>&ldquo;{notif.comment_preview}&rdquo;</span></>
                    )}
                    {notif.type === 'follow' && (
                      <> started following you</>
                    )}
                  </p>
                </div>

                {/* Time */}
                <span style={{ fontSize: '11px', color: 'var(--text-faint)', flexShrink: 0 }}>
                  {timeAgo(notif.created_at)}
                </span>
              </Link>
            )
          })}
        </div>
      )}
    </div>
  )
}

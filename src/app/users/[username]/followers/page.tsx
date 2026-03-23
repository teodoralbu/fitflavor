export const dynamic = 'force-dynamic'

import { notFound } from 'next/navigation'
import Link from 'next/link'
import Image from 'next/image'
import { createServerSupabaseClient } from '@/lib/supabase-server'
import { FollowButton } from '@/components/user/FollowButton'

interface Props {
  params: Promise<{ username: string }>
}

export default async function FollowersPage({ params }: Props) {
  const { username } = await params
  const supabase = await createServerSupabaseClient()

  // Look up profile
  const { data: profile } = await supabase
    .from('users')
    .select('id, username')
    .eq('username', username)
    .single()

  if (!profile) notFound()

  // Get current user for follow status
  const { data: { user: currentUser } } = await supabase.auth.getUser()

  // Get followers (users who follow this profile)
  const { data: followRows } = await supabase
    .from('follows')
    .select('follower_id')
    .eq('following_id', profile.id)
    .order('created_at', { ascending: false })

  const followerIds = (followRows ?? []).map((r: { follower_id: string }) => r.follower_id)

  // Fetch follower user details
  const { data: followers } = followerIds.length > 0
    ? await supabase
        .from('users')
        .select('id, username, avatar_url')
        .in('id', followerIds)
    : { data: [] as { id: string; username: string; avatar_url: string | null }[] }

  // Check which ones the current user follows (for FollowButton initial state)
  let followingSet = new Set<string>()
  if (currentUser && followerIds.length > 0) {
    const { data: myFollows } = await supabase
      .from('follows')
      .select('following_id')
      .eq('follower_id', currentUser.id)
      .in('following_id', followerIds)
    followingSet = new Set((myFollows ?? []).map((f: { following_id: string }) => f.following_id))
  }

  // Maintain order from followRows
  const orderedFollowers = followerIds
    .map(id => (followers ?? []).find(u => u.id === id))
    .filter(Boolean) as { id: string; username: string; avatar_url: string | null }[]

  return (
    <div style={{ maxWidth: '480px', margin: '0 auto', padding: '16px 0 96px' }}>
      {/* Header with back link */}
      <div style={{ padding: '8px 16px 20px', display: 'flex', alignItems: 'center', gap: '12px' }}>
        <Link
          href={`/users/${username}`}
          style={{
            color: 'var(--text)',
            textDecoration: 'none',
            fontSize: '20px',
            lineHeight: 1,
            padding: '8px',
            margin: '-8px',
            minWidth: '44px',
            minHeight: '44px',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
          }}
          aria-label="Back to profile"
        >
          &larr;
        </Link>
        <h1 style={{ fontSize: '20px', fontWeight: 900, color: 'var(--text)', margin: 0, letterSpacing: '-0.02em' }}>
          Followers
        </h1>
      </div>

      {orderedFollowers.length === 0 ? (
        <div style={{ padding: '48px 16px', textAlign: 'center' }}>
          <p style={{ color: 'var(--text-dim)', fontSize: '14px', margin: 0 }}>No followers yet.</p>
        </div>
      ) : (
        <div style={{
          backgroundColor: 'var(--bg-card)',
          marginLeft: '16px',
          marginRight: '16px',
          borderRadius: 'var(--radius-lg)',
          border: '1px solid var(--border)',
          overflow: 'hidden',
        }}>
          {orderedFollowers.map((follower, idx) => (
            <div
              key={follower.id}
              style={{
                display: 'flex',
                alignItems: 'center',
                gap: '12px',
                padding: '12px 16px',
                minHeight: '56px',
                borderTop: idx > 0 ? '1px solid var(--border-soft)' : 'none',
                boxSizing: 'border-box',
              }}
            >
              {/* Avatar + username link */}
              <Link
                href={`/users/${follower.username}`}
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: '12px',
                  flex: 1,
                  minWidth: 0,
                  textDecoration: 'none',
                  color: 'inherit',
                  minHeight: '44px',
                }}
              >
                <div style={{
                  width: '40px', height: '40px', borderRadius: '50%', flexShrink: 0,
                  backgroundColor: 'var(--bg-elevated)', border: '1px solid var(--border)',
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                  fontSize: '14px', fontWeight: 800, color: 'var(--accent)', overflow: 'hidden',
                }}>
                  {follower.avatar_url ? (
                    <Image src={follower.avatar_url} alt={`${follower.username}'s avatar`} width={40} height={40} style={{ objectFit: 'cover' }} />
                  ) : (
                    follower.username[0]?.toUpperCase() ?? '?'
                  )}
                </div>
                <span style={{ fontSize: '14px', fontWeight: 600, color: 'var(--text)', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                  {follower.username}
                </span>
              </Link>
              {/* Follow button — don't show for yourself */}
              {currentUser && currentUser.id !== follower.id && (
                <FollowButton targetUserId={follower.id} initialFollowing={followingSet.has(follower.id)} />
              )}
            </div>
          ))}
        </div>
      )}
    </div>
  )
}

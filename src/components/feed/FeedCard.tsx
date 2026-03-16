'use client'

import Link from 'next/link'
import { timeAgo } from '@/lib/timeAgo'
import { getScoreColor } from '@/lib/constants'
import { LikeButton } from '@/components/rating/LikeButton'
import { CommentsSection } from '@/components/rating/CommentsSection'

interface FeedRating {
  id: string
  overall_score: number
  would_buy_again: boolean
  review_text: string | null
  photo_url: string | null
  created_at: string
  comment_count: number
  flavor: {
    name: string
    slug: string
    products: {
      name: string
      slug: string
      image_url: string | null
      brands: { name: string }
    }
  } | null
  user: {
    username: string
    avatar_url: string | null
    badge_tier: string
  } | null
}

export function FeedCard({ rating, initialLiked = false, initialLikeCount = 0 }: {
  rating: FeedRating
  initialLiked?: boolean
  initialLikeCount?: number
}) {
  const product = (rating.flavor as any)?.products
  const brand = product?.brands
  const scoreColor = getScoreColor(rating.overall_score)

  return (
    <div style={{
      backgroundColor: 'var(--bg-card)',
      borderBottom: '1px solid var(--border-soft)',
    }}>
      {/* Header: avatar + username + time */}
      <div style={{ display: 'flex', alignItems: 'center', gap: '10px', padding: '12px 16px 10px' }}>
        <Link href={`/users/${rating.user?.username}`} style={{ textDecoration: 'none', flexShrink: 0 }}>
          <div style={{
            width: '38px', height: '38px', borderRadius: '50%',
            backgroundColor: 'var(--bg-elevated)', border: '1px solid var(--border)',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            fontSize: '14px', fontWeight: 800, color: 'var(--accent)', overflow: 'hidden',
          }}>
            {rating.user?.avatar_url ? (
              // eslint-disable-next-line @next/next/no-img-element
              <img src={rating.user.avatar_url} alt="" style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
            ) : (
              rating.user?.username?.[0]?.toUpperCase() ?? '?'
            )}
          </div>
        </Link>
        <div style={{ flex: 1, minWidth: 0 }}>
          <Link href={`/users/${rating.user?.username}`} style={{ textDecoration: 'none' }}>
            <span style={{ fontSize: '13px', fontWeight: 700, color: 'var(--text)' }}>
              {rating.user?.username ?? 'Anonymous'}
            </span>
          </Link>
          <span style={{ fontSize: '12px', color: 'var(--text-faint)', marginLeft: '6px' }}>
            {timeAgo(rating.created_at)}
          </span>
        </div>
        {rating.would_buy_again && (
          <span style={{ fontSize: '10px', color: 'var(--green)', fontWeight: 700, backgroundColor: 'color-mix(in srgb, var(--green) 10%, transparent)', padding: '3px 8px', borderRadius: '999px', border: '1px solid color-mix(in srgb, var(--green) 25%, transparent)', flexShrink: 0 }}>
            WBA
          </span>
        )}
      </div>

      {/* Product + Score block */}
      <Link href={`/flavors/${rating.flavor?.slug ?? ''}`} style={{ textDecoration: 'none', color: 'inherit', display: 'block', padding: '0 16px 12px' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: '14px' }}>
          {/* Product image */}
          <div style={{
            width: '56px', height: '56px', borderRadius: '10px', flexShrink: 0,
            backgroundColor: 'var(--bg-elevated)', border: '1px solid var(--border)',
            display: 'flex', alignItems: 'center', justifyContent: 'center', overflow: 'hidden',
          }}>
            {product?.image_url ? (
              // eslint-disable-next-line @next/next/no-img-element
              <img src={product.image_url} alt="" style={{ width: '100%', height: '100%', objectFit: 'contain', padding: '6px' }} />
            ) : (
              <span style={{ fontSize: '22px' }}>⚡</span>
            )}
          </div>

          {/* Flavor + product info */}
          <div style={{ flex: 1, minWidth: 0 }}>
            <div style={{ fontSize: '15px', fontWeight: 800, color: 'var(--text)', marginBottom: '3px', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
              {rating.flavor?.name ?? 'Unknown flavor'}
            </div>
            <div style={{ fontSize: '11px', color: 'var(--text-faint)', textTransform: 'uppercase', letterSpacing: '0.05em', fontWeight: 600 }}>
              {brand?.name} · {product?.name}
            </div>
          </div>

          {/* Score */}
          <div style={{ textAlign: 'right', flexShrink: 0 }}>
            <div style={{ fontSize: '36px', fontWeight: 900, lineHeight: 1, color: scoreColor, letterSpacing: '-0.03em' }}>
              {rating.overall_score.toFixed(1)}
            </div>
          </div>
        </div>
      </Link>

      {/* Review text */}
      {rating.review_text && (
        <div style={{ padding: '0 16px 12px' }}>
          <p style={{ margin: 0, fontSize: '14px', color: 'var(--text-muted)', lineHeight: 1.6 }}>
            &ldquo;{rating.review_text}&rdquo;
          </p>
        </div>
      )}

      {/* Review photo */}
      {rating.photo_url && (
        <div style={{ padding: '0 16px 12px' }}>
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img
            src={rating.photo_url}
            alt="Review photo"
            style={{ width: '100%', borderRadius: '10px', maxHeight: '240px', objectFit: 'cover', display: 'block' }}
          />
        </div>
      )}

      {/* Actions: like + comments count */}
      <div style={{ padding: '4px 16px 12px', display: 'flex', alignItems: 'center', gap: '16px', borderTop: '1px solid var(--border-soft)' }}>
        <LikeButton ratingId={rating.id} initialCount={initialLikeCount} initialLiked={initialLiked} />
      </div>

      {/* Comments */}
      <CommentsSection ratingId={rating.id} initialCount={rating.comment_count} />
    </div>
  )
}

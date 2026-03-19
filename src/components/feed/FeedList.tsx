'use client'

import { useRef, useCallback, useEffect, useState } from 'react'
import { FeedCard } from '@/components/feed/FeedCard'
import type { FeedItem } from '@/components/feed/FeedCard'
import { loadMoreFeed } from '@/app/actions/feed'

interface FeedListProps {
  initialItems: FeedItem[]
  initialCursor: string | null
  userId?: string
}

export function FeedList({ initialItems, initialCursor, userId }: FeedListProps) {
  const [items, setItems] = useState<FeedItem[]>(initialItems)
  const [cursor, setCursor] = useState<string | null>(initialCursor)
  const [loading, setLoading] = useState(false)
  const sentinelRef = useRef<HTMLDivElement>(null)

  const loadMore = useCallback(async () => {
    if (!cursor || loading) return
    setLoading(true)
    try {
      const { items: newItems, nextCursor } = await loadMoreFeed(cursor, userId)
      setItems(prev => [...prev, ...newItems])
      setCursor(nextCursor)
    } catch (err) {
      console.error('Failed to load more feed items:', err)
    } finally {
      setLoading(false)
    }
  }, [cursor, loading, userId])

  useEffect(() => {
    const sentinel = sentinelRef.current
    if (!sentinel) return

    const observer = new IntersectionObserver(
      (entries) => {
        if (entries[0].isIntersecting) loadMore()
      },
      { rootMargin: '200px' }
    )

    observer.observe(sentinel)
    return () => observer.disconnect()
  }, [loadMore])

  return (
    <>
      <div style={{ display: 'flex', flexDirection: 'column' }}>
        {items.map((feedItem, idx) => (
          <FeedCard key={feedItem.id} item={feedItem} initialLikeCount={0} initialLiked={false} index={idx} />
        ))}
      </div>
      {cursor && (
        <div ref={sentinelRef} style={{ padding: '20px', textAlign: 'center' }}>
          {loading && (
            <span style={{ fontSize: '13px', color: 'var(--text-dim)' }}>Loading more...</span>
          )}
        </div>
      )}
    </>
  )
}

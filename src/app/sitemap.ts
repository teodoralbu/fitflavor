import type { MetadataRoute } from 'next'
import { createServerSupabaseClient } from '@/lib/supabase-server'

const BASE_URL = process.env.NEXT_PUBLIC_SITE_URL ?? 'https://gymtaste.app'

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const supabase = await createServerSupabaseClient()
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const db = supabase as any

  const [{ data: flavors }, { data: products }, { data: brands }] = await Promise.all([
    db.from('flavors').select('slug, updated_at').limit(1000),
    db.from('products').select('slug, updated_at').eq('is_approved', true).limit(500),
    db.from('brands').select('slug').limit(200),
  ])

  const staticRoutes: MetadataRoute.Sitemap = [
    { url: BASE_URL, changeFrequency: 'daily', priority: 1 },
    { url: `${BASE_URL}/browse`, changeFrequency: 'daily', priority: 0.9 },
    { url: `${BASE_URL}/leaderboard`, changeFrequency: 'daily', priority: 0.8 },
  ]

  const flavorRoutes: MetadataRoute.Sitemap = ((flavors ?? []) as any[]).map((f) => ({
    url: `${BASE_URL}/flavors/${f.slug}`,
    lastModified: f.updated_at ? new Date(f.updated_at) : undefined,
    changeFrequency: 'weekly' as const,
    priority: 0.8,
  }))

  const productRoutes: MetadataRoute.Sitemap = ((products ?? []) as any[]).map((p) => ({
    url: `${BASE_URL}/products/${p.slug}`,
    lastModified: p.updated_at ? new Date(p.updated_at) : undefined,
    changeFrequency: 'weekly' as const,
    priority: 0.7,
  }))

  const brandRoutes: MetadataRoute.Sitemap = ((brands ?? []) as any[]).map((b) => ({
    url: `${BASE_URL}/brands/${b.slug}`,
    changeFrequency: 'monthly' as const,
    priority: 0.6,
  }))

  return [...staticRoutes, ...flavorRoutes, ...productRoutes, ...brandRoutes]
}

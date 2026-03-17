export const revalidate = 300

import type { Metadata } from 'next'
import { getProductsWithFlavors } from '@/lib/queries'
import { RateLanding } from './RateLanding'

export const metadata: Metadata = {
  title: 'Rate a Flavor — GymTaste',
  description: 'Pick a supplement flavor you tried and rate it.',
}

export default async function RatePage() {
  const products = await getProductsWithFlavors()
  return <RateLanding products={products as any} />
}

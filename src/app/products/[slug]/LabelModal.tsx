'use client'

import { useState } from 'react'
import { Modal } from '@/components/ui/Modal'

interface LabelModalProps {
  ingredients: string[] | null
  sweeteners: string[] | null
  chemicals: string[] | null
}

export function LabelModal({ ingredients, sweeteners, chemicals }: LabelModalProps) {
  const [open, setOpen] = useState(false)

  const hasIngredients = ingredients && ingredients.length > 0
  const hasSweeteners = sweeteners && sweeteners.length > 0
  const hasChemicals = chemicals && chemicals.length > 0

  if (!hasIngredients && !hasSweeteners && !hasChemicals) return null

  return (
    <>
      <button
        className="card card-hover card-press"
        onClick={() => setOpen(true)}
        style={{
          width: '100%',
          padding: '16px 20px',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
          cursor: 'pointer',
          border: 'none',
          background: 'none',
        }}
      >
        <span style={{ fontWeight: 700, fontSize: '15px', color: 'var(--text)' }}>
          View Full Label
        </span>
        <span style={{ color: 'var(--text-faint)', fontSize: '18px', lineHeight: 1 }}>
          ›
        </span>
      </button>

      <Modal open={open} onClose={() => setOpen(false)} title="Product Label" maxWidth="max-w-md">
        <div style={{ overflowY: 'auto', maxHeight: '70vh' }}>
          {hasIngredients && (
            <div style={{ marginBottom: '20px' }}>
              <h3 style={{ fontSize: '14px', fontWeight: 700, color: 'var(--text)', marginBottom: '8px' }}>
                Ingredients
              </h3>
              <p style={{ color: 'var(--text-muted)', fontSize: '13px', lineHeight: 1.6, margin: 0 }}>
                {ingredients!.join(', ')}
              </p>
            </div>
          )}

          {hasSweeteners && (
            <div style={{ marginBottom: '20px' }}>
              <h3 style={{ fontSize: '14px', fontWeight: 700, color: 'var(--text)', marginBottom: '8px' }}>
                Sweeteners
              </h3>
              <p style={{ color: 'var(--text-muted)', fontSize: '13px', lineHeight: 1.6, margin: 0 }}>
                {sweeteners!.join(', ')}
              </p>
            </div>
          )}

          {hasChemicals && (
            <div>
              <h3 style={{ fontSize: '14px', fontWeight: 700, color: 'var(--text)', marginBottom: '8px' }}>
                Other Additives
              </h3>
              <p style={{ color: 'var(--text-muted)', fontSize: '13px', lineHeight: 1.6, margin: 0 }}>
                {chemicals!.join(', ')}
              </p>
            </div>
          )}
        </div>
      </Modal>
    </>
  )
}

'use client'

import { useRef, useState } from 'react'
import { createClient } from '@/lib/supabase'
import { useAuth } from '@/context/auth-context'

interface Props {
  currentAvatarUrl: string | null
  username: string
  tierColor: string
}

export function AvatarUpload({ currentAvatarUrl, username, tierColor }: Props) {
  const { user, refreshProfile } = useAuth()
  const fileInputRef = useRef<HTMLInputElement>(null)
  const [avatarUrl, setAvatarUrl] = useState(currentAvatarUrl)
  const [uploading, setUploading] = useState(false)

  const handleFile = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0]
    if (!file || !user) return

    setUploading(true)
    const supabase = createClient()
    const ext = file.name.split('.').pop()
    const path = `${user.id}/avatar.${ext}`

    const { error: uploadError } = await supabase.storage
      .from('avatars')
      .upload(path, file, { upsert: true })

    if (!uploadError) {
      const { data: { publicUrl } } = supabase.storage.from('avatars').getPublicUrl(path)
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      await (supabase as any).from('users').update({ avatar_url: publicUrl }).eq('id', user.id)
      setAvatarUrl(publicUrl + '?t=' + Date.now())
      await refreshProfile()
    }

    setUploading(false)
    e.target.value = ''
  }

  return (
    <div
      style={{ position: 'relative', width: '76px', height: '76px', flexShrink: 0, cursor: 'pointer' }}
      onClick={() => fileInputRef.current?.click()}
    >
      {/* Avatar circle */}
      <div style={{
        width: '76px', height: '76px', borderRadius: '50%',
        backgroundColor: 'var(--bg-elevated)',
        border: `2px solid ${tierColor}`,
        boxShadow: `0 0 16px ${tierColor}44`,
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        fontSize: '28px', fontWeight: 900, color: tierColor,
        overflow: 'hidden',
      }}>
        {avatarUrl ? (
          // eslint-disable-next-line @next/next/no-img-element
          <img src={avatarUrl} alt={username} style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
        ) : (
          username[0].toUpperCase()
        )}
      </div>

      {/* Overlay */}
      <div style={{
        position: 'absolute', inset: 0, borderRadius: '50%',
        backgroundColor: uploading ? 'rgba(0,0,0,0.5)' : 'rgba(0,0,0,0)',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        transition: 'background-color 0.15s',
      }}
        className="avatar-overlay"
      >
        {uploading ? (
          <div style={{
            width: '20px', height: '20px', borderRadius: '50%',
            border: '2px solid #fff', borderTopColor: 'transparent',
            animation: 'spin 0.7s linear infinite',
          }} />
        ) : (
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"
            style={{ opacity: 0, transition: 'opacity 0.15s' }} className="avatar-edit-icon">
            <path d="M12 20h9" /><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4Z" />
          </svg>
        )}
      </div>

      <input ref={fileInputRef} type="file" accept="image/jpeg,image/png,image/webp" style={{ display: 'none' }} onChange={handleFile} />

      <style>{`
        .avatar-overlay:hover { background-color: rgba(0,0,0,0.45) !important; }
        .avatar-overlay:hover .avatar-edit-icon { opacity: 1 !important; }
        @keyframes spin { to { transform: rotate(360deg); } }
      `}</style>
    </div>
  )
}

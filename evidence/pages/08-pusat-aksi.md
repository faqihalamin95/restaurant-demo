---
title: Pusat Aksi
---

<style>
.summary-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 12px;
}

.summary-card {
  padding: 16px;
  border-radius: 16px;
  border: 1.5px solid var(--color-border-tertiary);
  background: var(--color-background-secondary);
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.summary-card.kritis {
  border-color: rgba(239, 68, 68, 0.28);
  background: linear-gradient(135deg, rgba(239, 68, 68, 0.06), var(--color-background-secondary));
}

.summary-card.sehat {
  border-color: rgba(34, 197, 94, 0.28);
  background: linear-gradient(135deg, rgba(34, 197, 94, 0.06), var(--color-background-secondary));
}

.summary-card.waspada {
  border-color: rgba(249, 115, 22, 0.28);
  background: linear-gradient(135deg, rgba(249, 115, 22, 0.06), var(--color-background-secondary));
}

.summary-card.netral {
  border-color: rgba(99, 102, 241, 0.28);
  background: linear-gradient(135deg, rgba(99, 102, 241, 0.06), var(--color-background-secondary));
}

.summary-label {
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--color-text-tertiary);
}

.summary-value {
  font-size: 1.25rem;
  font-weight: 900;
  color: var(--color-text-primary);
  letter-spacing: -0.03em;
}

.summary-value.kritis { color: #b91c1c; }
.summary-value.sehat { color: #166534; }
.summary-value.waspada { color: #c2410c; }
.summary-value.netral { color: #4338ca; }

.summary-context {
  font-size: 0.8rem;
  color: var(--color-text-secondary);
}

.kanban-stack {
  display: flex;
  flex-direction: column;
  gap: 14px;
}

.kanban-card {
  padding: 18px 20px;
  border-radius: 18px;
  border: 1px solid var(--color-border-tertiary);
  background: var(--color-background-secondary);
  border-left: 5px solid var(--color-border-tertiary);
  transition: transform 0.2s ease, box-shadow 0.2s ease, border-color 0.2s ease;
}

.kanban-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.06);
}

.kanban-card.critical {
  border-left-color: #ef4444;
  background: linear-gradient(90deg, rgba(239, 68, 68, 0.02), var(--color-background-secondary));
}

.kanban-card.high {
  border-left-color: #f97316;
  background: linear-gradient(90deg, rgba(249, 115, 22, 0.02), var(--color-background-secondary));
}

.kanban-card.moderate {
  border-left-color: #3b82f6;
  background: linear-gradient(90deg, rgba(59, 130, 246, 0.02), var(--color-background-secondary));
}

.kanban-card.pantau {
  border-left-color: #94a3b8;
  background: linear-gradient(90deg, rgba(148, 163, 184, 0.02), var(--color-background-secondary));
}

.pill-badge {
  display: inline-block;
  padding: 2px 8px;
  border-radius: 999px;
  font-size: 10px;
  font-weight: 800;
}

.pill-badge.critical { background: rgba(239, 68, 68, 0.15); color: #b91c1c; }
.pill-badge.high { background: rgba(249, 115, 22, 0.15); color: #c2410c; }
.pill-badge.moderate { background: rgba(59, 130, 246, 0.15); color: #1d4ed8; }
.pill-badge.pantau { background: rgba(148, 163, 184, 0.15); color: #475569; }

.action-link-btn {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  padding: 6px 12px;
  border-radius: 8px;
  font-size: 0.78rem;
  font-weight: 600;
  color: var(--color-primary);
  background: rgba(37, 99, 235, 0.08);
  text-decoration: none;
  transition: all 0.2s ease;
  margin-top: 10px;
  border: none;
  cursor: pointer;
  width: fit-content;
}

.action-link-btn:hover {
  background: rgba(37, 99, 235, 0.16);
  color: var(--color-primary-hover);
}

@media (max-width: 900px) {
  .summary-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 600px) {
  .summary-grid {
    grid-template-columns: 1fr;
  }
}
</style>

```sql actions_query
SELECT 
    priority_rank,
    severity,
    area,
    impact,
    recommended_action,
    CASE 
        WHEN area = 'Finance' THEN '📈 KEUANGAN'
        WHEN area = 'Branch' THEN '🏪 CABANG'
        WHEN area = 'Inventory' THEN '🥩 INVENTORI'
        WHEN area = 'Peak Hours' THEN '⏰ JAM SIBUK'
        WHEN area = 'Menu' THEN '🍳 MENU'
        WHEN area = 'Workforce' THEN '👥 PEGAWAI'
        WHEN area = 'Member' THEN '💎 MEMBER'
        ELSE area
    END AS area_label,
    CASE 
        WHEN area = 'Finance' THEN '/01-laporan-keuangan'
        WHEN area = 'Branch' THEN '/02-branch-performance'
        WHEN area = 'Inventory' THEN '/03-inventori-stok'
        WHEN area = 'Peak Hours' THEN '/04-peak-hours'
        WHEN area = 'Menu' THEN '/05-menu-performance'
        WHEN area = 'Workforce' THEN '/07-employee-performance'
        WHEN area = 'Member' THEN '/06-member-behavior'
        ELSE '/'
    END AS target_url
FROM restaurant.action_center
WHERE section = 'action_queue'
ORDER BY 
    CASE 
        WHEN severity = 'Kritis' THEN 1
        WHEN severity = 'Waspada' THEN 2
        WHEN severity = 'Tinggi' THEN 2
        ELSE 3
    END ASC,
    priority_rank ASC
```

```sql summary_cards
SELECT metric, value, context, status
FROM restaurant.action_center
WHERE section = 'summary_cards'
ORDER BY sort_order
```

<div class="branch-page">

  <!-- Subpage Hero -->
  <div class="subpage-hero">
    <div class="subpage-hero-eyebrow">🎯 PUSAT AKSI TERPADU</div>
    <h3 class="subpage-hero-title">Rekomendasi Tindakan & Prioritas Kerja Owner</h3>
    <p class="subpage-hero-copy">Satu halaman terpadu yang memantau seluruh kebocoran operasional restoran Anda. Selesaikan antrean tugas di bawah untuk memaksimalkan margin laba.</p>
  </div>

  <!-- Summary Cards Grid -->
  {#if summary_cards.length > 0}
    <div class="summary-grid">
      {#each summary_cards as card}
        {@const cardStatus = card.status?.toLowerCase() ?? 'netral'}
        <div class="summary-card {cardStatus}">
          <span class="summary-label">{card.metric}</span>
          <span class="summary-value {cardStatus}">{card.value}</span>
          <span class="summary-context">{card.context}</span>
        </div>
      {/each}
    </div>
  {/if}

  <!-- Just-In-Time Instruction Accordion -->
  <details class="guide-acc" >
  <summary>💡 Bagaimana prioritas ini ditentukan?</summary>
<div class="guide-body">
      
      <div class="guide-grid" style="grid-template-columns: repeat(3, minmax(0, 1fr));">
        <div class="guide-card blue">
          <div class="guide-card-icon">💵</div>
          <div class="guide-card-content">
            <div class="guide-card-label">DAMPAK FINANSIAL (RUPIAH IMPACT)</div>
            <h4 class="guide-card-title">Dampak Finansial (Rupiah Impact)</h4>
            <p class="guide-card-desc">Setiap masalah diukur dalam nilai rupiah kebocoran biaya atau potensi modal terikat untuk menjamin prioritas yang adil.</p>
          </div>
        </div>
        <div class="guide-card orange">
          <div class="guide-card-icon">💡</div>
          <div class="guide-card-content">
            <div class="guide-card-label">SKALA KEPARAHAN</div>
            <h4 class="guide-card-title">Skala Keparahan</h4>
            <p class="guide-card-desc">Masalah 🚨 KRITIS ditempatkan di urutan teratas karena berdampak langsung pada tergerusnya profitabilitas harian outlet.</p>
          </div>
        </div>
        <div class="guide-card teal">
          <div class="guide-card-icon">💡</div>
          <div class="guide-card-content">
            <div class="guide-card-label">DELEGASI LAPANGAN</div>
            <h4 class="guide-card-title">Delegasi Lapangan</h4>
            <p class="guide-card-desc">Owner disarankan mengaudit data detail di halaman terkait sebelum melakukan tindakan perbaikan bersama tim manajer.</p>
          </div>
        </div>
      </div>

    </div>
</details>

  <!-- Main Tasks Stack -->
  <div class="section-card">
    <div class="section-head">
      <div>
        <div class="section-eyebrow">Daftar Antrean Aksi</div>
        <h3 class="section-title">Backlog Kerja Operasional Terpadu</h3>
        <p class="section-copy">Berikut adalah daftar aksi terkurasi untuk mengatasi ketidakefisienan operasional restoran Anda minggu ini.</p>
      </div>
    </div>

    {#if actions_query.length > 0}
      <div class="kanban-stack">
        {#each actions_query as row, i}
          {@const severityClass = row.severity?.toLowerCase() === 'kritis' ? 'critical' : row.severity?.toLowerCase() === 'waspada' ? 'high' : row.severity?.toLowerCase() === 'pantau' ? 'pantau' : 'moderate'}
          <div class="kanban-card {severityClass}">
            <div style="display: flex; justify-content: space-between; align-items: start; flex-wrap: wrap; gap: 8px; margin-bottom: 8px;">
              <div style="display: flex; align-items: center; gap: 6px;">
                <span style="font-size: 0.82rem; font-weight: 800; color: var(--color-text-secondary);">#{i + 1}</span>
                <span class="pill-badge {severityClass}">
                  {#if severityClass === 'critical'}
                    🚨 KRITIS
                  {:else}
                    {row.severity?.toUpperCase() ?? 'MODERAT'}
                  {/if}
                </span>
                <span style="font-size: 0.78rem; font-weight: 700; color: var(--color-text-tertiary);">{row.area_label}</span>
              </div>
            </div>

            <h4 style="font-size: 0.95rem; font-weight: 800; color: var(--color-text-primary); margin: 6px 0;">{row.impact}</h4>
            <p style="font-size: 0.83rem; color: var(--color-text-secondary); margin: 6px 0; line-height: 1.5;"><strong>Rekomendasi Owner:</strong> {row.recommended_action}</p>
            
            <a href="{row.target_url}" class="action-link-btn">
              🔍 Buka Analisis {row.area_label.replace(/[^\p{L}\p{N}\s]/gu, '').trim()}
            </a>
          </div>
        {/each}
      </div>
    {:else}
      <div style="padding: 24px; text-align: center; border: 1.5px dashed var(--color-border-tertiary); border-radius: 16px; color: var(--color-text-secondary); font-size: 0.88rem;">
        📭 Semua indikator operasional dalam keadaan aman dan terkendali.
      </div>
    {/if}
  </div>

</div>

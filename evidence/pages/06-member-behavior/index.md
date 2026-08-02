---
title: Insight Member
sidebar: hide
hide_toc: true
---
<MemberTabs activeTab="overview" />

```sql member_kpi_period
SELECT * FROM restaurant.member_member_kpi_period
WHERE period = '30d'
```

```sql top_member
WITH max_d AS (SELECT MAX(order_date) AS d FROM restaurant.member_purchase_behavior)
SELECT member_name, SUM(total_orders) AS total_orders
FROM restaurant.member_purchase_behavior CROSS JOIN max_d
WHERE order_date >= d - INTERVAL '29 days'
GROUP BY member_name
ORDER BY total_orders DESC
LIMIT 1
```

```sql member_dates
SELECT
strftime(MAX(order_date) - INTERVAL '29 days', '%d %b %Y')  AS tgl_30_awal,
strftime(MAX(order_date), '%d %b %Y')                       AS tgl_akhir
FROM restaurant.member_purchase_behavior
```

```sql retention_kpi
SELECT 
  COUNT(*) as total_churn,
  SUM(CASE WHEN tier = 'Gold' THEN 1 ELSE 0 END) as gold_churn
FROM restaurant.member_retention_queue
```

```sql retention_stats
SELECT
  SUM(total_spend * 0.1) as potential_loss
FROM restaurant.member_retention_queue
```

```sql milestone_count
SELECT 3 as count
```



<script>
  function idFormat(num, dec = 0) {
    if (num === null || num === undefined) return '0';
    return new Intl.NumberFormat('id-ID', { minimumFractionDigits: dec, maximumFractionDigits: dec }).format(num);
  }

  let activeRate = 0;
  let goldChurn = 0;
  let totalChurn = 0;
  let totalMembers = 0;
  let churnRatePct = 0;
  let pctOrder = 0;
  let aov = 0;
  let aovNonMember = 0;
  let aovDiffPct = 0;
  let activationRatePct = 0;
  let totalMemberSpend = 0;
  let pctRevenueMember = 0;
  let totalMemberOrders = 0;
  let activeMembers = 0;
  let newMembers = 0;

  $: if (member_kpi_period && member_kpi_period.length > 0) {
     totalMembers = member_kpi_period[0].total_members;
     pctOrder = member_kpi_period[0].pct_order_member;
     aov = member_kpi_period[0].avg_order_value;
     aovNonMember = member_kpi_period[0].avg_order_value_non_member;
     activationRatePct = member_kpi_period[0].activation_rate_pct || 0;
     totalMemberSpend = member_kpi_period[0].total_member_spend;
     pctRevenueMember = member_kpi_period[0].pct_revenue_member;
     totalMemberOrders = member_kpi_period[0].total_member_orders;
     activeMembers = member_kpi_period[0].active_members;
     newMembers = member_kpi_period[0].new_members;
     
     if (aovNonMember > 0) {
       aovDiffPct = ((aov - aovNonMember) / aovNonMember) * 100;
     }
  }

  $: if (retention_kpi && retention_kpi.length > 0) {
      totalChurn = retention_kpi[0].total_churn;
      goldChurn = retention_kpi[0].gold_churn;
      if (totalMembers > 0) {
        churnRatePct = (totalChurn / totalMembers) * 100;
        activeMembers = totalMembers - totalChurn;
        activeRate = 100 - churnRatePct;
      }
   }

  let heroStatusClass = 'status-sehat';
  $: if (activeRate > 60) heroStatusClass = 'status-sehat';
  else if (activeRate >= 40) heroStatusClass = 'status-waspada';
  else heroStatusClass = 'status-kritis';

  let churnRiskState = 'safe';
  $: if (churnRatePct >= 20) churnRiskState = 'critical';
  else if (churnRatePct >= 10) churnRiskState = 'warn';
  else churnRiskState = 'safe';

  let safeCount = 0;
  let warnCount = 0;
  let criticalCount = 0;
  $: {
    let s = 0, w = 0, c = 0;
    
    if (churnRiskState === 'safe') s++;
    else if (churnRiskState === 'warn') w++;
    else c++;

    safeCount = s;
    warnCount = w;
    criticalCount = c;
  }

  // States for Narrative Accordion
  let penetrasiState = 'safe';
  $: if (pctOrder >= 35) penetrasiState = 'safe';
  else if (pctOrder >= 20) penetrasiState = 'warn';
  else penetrasiState = 'critical';

  let aovState = 'safe';
  $: if (aov > 120000) aovState = 'safe';
  else if (aov > 100000) aovState = 'warn';
</script>

{#if member_kpi_period && member_kpi_period.length > 0 && retention_kpi && retention_kpi.length > 0}

<div class="hero" style="margin-bottom: 32px; margin-top: 10px;">
  <div class="hero-eyebrow">👥 Insight Member · <Value data={member_dates} column="tgl_30_awal"/> - <Value data={member_dates} column="tgl_akhir"/></div>
  <div class="hero-grid">
    <div class="hero-main-card {heroStatusClass}">
      <div class="hero-stat-number">{idFormat(activeRate, 1)}%</div>
      <div class="hero-stat-label">MEMBER AKTIF</div>
      <div class="hero-subtitle">
        Dari total <strong>{idFormat(totalMembers)} member</strong>, mayoritas terpantau aktif berkunjung sesuai dengan ritmenya masing-masing.
      </div>
    </div>
    <div class="hero-side">
      <div class="hero-side-card">
        <div class="hero-side-label">🚨 Ancaman Omzet (Churn)</div>
        <div class="hero-side-value">-Rp <Value data={retention_stats} column="potential_loss" fmt="#,##0"/></div>
        <div class="hero-side-note">Risiko kerugian dari {idFormat(totalChurn)} member yang rawan kabur.</div>
      </div>
      <div class="hero-side-card">
        <div class="hero-side-label">🌱 Aktivasi Member Baru</div>
        <div class="hero-side-value">{activationRatePct > 0 ? idFormat(activationRatePct, 1) + '%' : '0%'}</div>
        <div class="hero-side-note">Persentase member baru yang datang lagi untuk kunjungan kedua.</div>
      </div>
    </div>
  </div>
</div>

<div style="margin-top: 32px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
  <div style="font-size: 1.5rem;">🎯</div>
  <div>
    <h2 style="margin: 0; font-size: 1.25rem; font-weight: 800; color: var(--color-text-primary); letter-spacing: -0.02em;">PUSAT AKSI HARI INI (TAKTIS)</h2>
    <div style="font-size: 0.85rem; color: var(--color-text-tertiary); font-weight: 500;">Fokus: Eksekusi Operasional yang Harus Dikerjakan Staf Restoran Hari Ini</div>
  </div>
</div>

<details class="guide-acc" open="true" style="margin-bottom: 24px; margin-top: 8px;">
  <summary>📖 Cara Cepat Menggunakan Halaman Ini</summary>
  <div class="guide-body">
    <div style="display: flex; align-items: center; gap: 12px; padding: 8px 0; width: 100%;">
      <!-- Step 1 Card -->
      <div class="interactive-card" style="flex: 1 1 0%; min-width: 0; background: #f4f8fb; border: 1px solid #e1ecf4; border-radius: 16px; padding: 20px; position: relative;">
        <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 12px;">
          <div style="position: relative;">
            <div style="font-size: 1.4rem; height: 40px; width: 40px; display: flex; align-items: center; justify-content: center; background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(124, 168, 209, 0.15);">🩺</div>
            <div style="position: absolute; width: 20px; height: 20px; background: #7ca8d1; color: white; border-radius: 50%; font-size: 0.7rem; font-weight: 800; display: flex; align-items: center; justify-content: center; box-shadow: 0 2px 4px rgba(124, 168, 209, 0.3); border: 2px solid white; top: -6px; right: -6px;">1</div>
          </div>
          <div style="font-weight: 800; color: var(--color-text-primary); font-size: 1rem;">Pantau Status</div>
        </div>
        <div style="display: flex; flex-direction: column; gap: 6px; margin-bottom: 10px; user-select: none;">
          <div style="background: rgba(22,163,74,0.06); border: 1px solid rgba(22,163,74,0.15); border-radius: 6px; padding: 4px 8px; display: flex; align-items: center; gap: 8px; pointer-events: none;">
            <span style="font-size: 0.75rem;">✅</span>
            <div style="height: 4px; background: #cbd5e1; border-radius: 2px; width: 45%;"></div>
          </div>
          <div style="background: rgba(234,179,8,0.08); border: 1px solid rgba(234,179,8,0.2); border-radius: 6px; padding: 4px 8px; display: flex; align-items: center; gap: 8px; pointer-events: none;">
            <span style="font-size: 0.75rem;">⚠️</span>
            <div style="height: 4px; background: #cbd5e1; border-radius: 2px; width: 60%;"></div>
          </div>
        </div>
        <div style="font-size: 0.85rem; color: var(--color-text-secondary); line-height: 1.6;">
          Amati status kesehatan dua indikator utama di bawah (waspadai metrik yang menyala <strong>kuning/merah</strong>).
        </div>
      </div>
      
      <!-- Arrow 1 -->
      <div style="font-size: 1.5rem; color: #cbd5e1; font-weight: bold; flex-shrink: 0; display: flex; align-items: center; justify-content: center;">➔</div>
      
      <!-- Step 2 Card -->
      <div class="interactive-card" style="flex: 1 1 0%; min-width: 0; background: #f9f5fa; border: 1px solid #eee1f1; border-radius: 16px; padding: 20px; position: relative;">
        <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 12px;">
          <div style="position: relative;">
            <div style="font-size: 1.4rem; height: 40px; width: 40px; display: flex; align-items: center; justify-content: center; background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(178, 139, 194, 0.15);">👆</div>
            <div style="position: absolute; width: 20px; height: 20px; background: #b28bc2; color: white; border-radius: 50%; font-size: 0.7rem; font-weight: 800; display: flex; align-items: center; justify-content: center; box-shadow: 0 2px 4px rgba(178, 139, 194, 0.3); border: 2px solid white; top: -6px; right: -6px;">2</div>
          </div>
          <div style="font-weight: 800; color: var(--color-text-primary); font-size: 1rem;">Klik & Deepdive</div>
        </div>
        <div style="position: relative; margin-bottom: 10px; user-select: none;">
          <div style="display: flex; flex-direction: column; gap: 6px;">
            <div style="background: rgba(22,163,74,0.06); border: 1px solid rgba(22,163,74,0.15); border-radius: 6px; padding: 4px 8px; display: flex; align-items: center; gap: 8px; pointer-events: none; opacity: 0.5;">
              <span style="font-size: 0.75rem;">✅</span>
              <div style="height: 4px; background: #cbd5e1; border-radius: 2px; width: 45%;"></div>
            </div>
            <div style="background: rgba(234,179,8,0.08); border: 1px solid rgba(234,179,8,0.2); border-radius: 6px; padding: 4px 8px; display: flex; align-items: center; gap: 8px; pointer-events: none;">
              <span style="font-size: 0.75rem;">⚠️</span>
              <div style="height: 4px; background: #cbd5e1; border-radius: 2px; width: 60%;"></div>
            </div>
          </div>
          <div style="position: absolute; right: 15%; bottom: -10px; font-size: 1.2rem; filter: drop-shadow(0 2px 4px rgba(0,0,0,0.15)); transform: rotate(-15deg);">
            👆
          </div>
        </div>
        <div style="font-size: 0.85rem; color: var(--color-text-secondary); line-height: 1.6;">
          Jangan berhenti di sini. <strong>Klik langsung</strong> baris indikator bermasalah tersebut untuk masuk ke detail analisis.
        </div>
      </div>

      <!-- Arrow 2 -->
      <div style="font-size: 1.5rem; color: #cbd5e1; font-weight: bold; flex-shrink: 0; display: flex; align-items: center; justify-content: center;">➔</div>

      <!-- Step 3 Card -->
      <div class="interactive-card" style="flex: 1 1 0%; min-width: 0; background: #f4fbf7; border: 1px solid #dcf2e5; border-radius: 16px; padding: 20px; position: relative;">
        <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 12px;">
          <div style="position: relative;">
            <div style="font-size: 1.4rem; height: 40px; width: 40px; display: flex; align-items: center; justify-content: center; background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(123, 191, 153, 0.15);">🎯</div>
            <div style="position: absolute; width: 20px; height: 20px; background: #7bbf99; color: white; border-radius: 50%; font-size: 0.7rem; font-weight: 800; display: flex; align-items: center; justify-content: center; box-shadow: 0 2px 4px rgba(123, 191, 153, 0.3); border: 2px solid white; top: -6px; right: -6px;">3</div>
          </div>
          <div style="font-weight: 800; color: var(--color-text-primary); font-size: 1rem;">Eksekusi Rekomendasi</div>
        </div>
        <div style="height: 52px; margin-bottom: 10px; background: rgba(123, 191, 153, 0.05); border: 1px solid rgba(123, 191, 153, 0.2); border-radius: 6px; padding: 4px; pointer-events: none; user-select: none; position: relative; overflow: hidden; display: flex; align-items: center; justify-content: center;">
          <svg viewBox="0 0 100 40" preserveAspectRatio="none" style="width: 100%; height: 80%; overflow: visible; opacity: 0.8;">
            <line x1="0" y1="20" x2="100" y2="20" stroke="#7bbf99" stroke-width="0.5" stroke-dasharray="2,2" opacity="0.4" />
            <line x1="0" y1="40" x2="100" y2="40" stroke="#7bbf99" stroke-width="0.5" stroke-dasharray="2,2" opacity="0.4" />
            <polyline points="0,35 20,25 40,28 60,15 80,18 100,5" fill="none" stroke="#7bbf99" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" />
            <circle cx="100" cy="5" r="3" fill="#7bbf99" />
          </svg>
        </div>
        <div style="font-size: 0.85rem; color: var(--color-text-secondary); line-height: 1.6;">
          Pelajari data pendukung dan segera terapkan <strong>langkah taktis</strong> yang direkomendasikan sistem.
        </div>
      </div>
    </div>
  </div>
</details>

<div class="menu-health">
  <div class="menu-health-head">
    <div class="menu-health-label">Ringkasan 2 Indikator Utama</div>
    <div class="menu-health-badges">
      <span class="menu-health-badge safe">✓ {safeCount} sehat</span>
      <span class="menu-health-badge warn">! {warnCount} waspada</span>
      <span class="menu-health-badge critical">x {criticalCount} kritis</span>
      <span class="menu-health-badge special" style="background: rgba(2,132,199,0.06); border: 1px solid rgba(2,132,199,0.15); color: #0284c7;">★ 1 spesial</span>
    </div>
  </div>
  <div class="menu-health-list">
    <a href="/06-member-behavior/02-aksi-taktis#ringkasan-risiko" style="text-decoration: none; color: inherit;">
      <div class="menu-health-row {churnRiskState}">
        <div class="menu-health-icon">{churnRiskState === 'safe' ? '✅' : churnRiskState === 'warn' ? '⚠️' : '🚨'}</div>
        <div style="width: 100%;">
          <span class="menu-health-title">Kebocoran Member (Churn Risk)</span> 
          <span class="menu-health-copy">- <span class="menu-health-value">{idFormat(churnRatePct, 1)}% ({totalChurn} Member)</span> sudah memasuki batas waktu rawan (zona churn). Sehat = &lt;10%, Waspada = 10-20%, Kritis = &gt;20%.</span>
        </div>
      </div>
    </a>
    <a href="/06-member-behavior/02-aksi-taktis#milestone" style="text-decoration: none; color: inherit;">
      <div class="menu-health-row special">
        <div class="menu-health-icon">💎</div>
        <div style="width: 100%;">
          <span class="menu-health-title">Pencapaian Milestone</span> 
          <span class="menu-health-copy">- <span class="menu-health-value">{milestone_count.length > 0 ? milestone_count[0].count : 0} Member</span> menyentuh tonggak loyalitas (kunjungan ke-10, 25, atau 50). Siapkan kejutan apresiasi untuk kunjungan mereka berikutnya!</span>
        </div>
      </div>
    </a>
  </div>
</div>

<details class="guide-acc" style="margin-top: 16px; margin-bottom: 24px;">
  <summary>💡 Kenapa tingkat churn dan aktivasi jadi angka utama?</summary>
  <div class="guide-body" style="padding: 16px;">
    <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
      Dua metrik ini bertindak sebagai radar awal kelangsungan hidup program loyalitas Anda sebelum masalahnya berdampak ke penurunan omzet keseluruhan.
    </p>
    <div class="guide-grid" style="grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 16px;">
      <div class="guide-card blue">
        <div class="guide-card-icon">📉</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Kebocoran Member (Churn Risk)</div>
          <h4 class="guide-card-title">Mendeteksi Member yang Pergi</h4>
          <p class="guide-card-desc">Kehilangan 1 member setia (terutama VIP) berakibat jauh lebih mahal secara finansial dibanding gagal mendapat 5 member baru. Indikator ini memastikan Anda bisa bertindak cepat.</p>
        </div>
      </div>
      <div class="guide-card blue">
        <div class="guide-card-icon">💎</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Pencapaian Milestone</div>
          <h4 class="guide-card-title">Membangun Apresiasi Spesial</h4>
          <p class="guide-card-desc">Berikan hadiah atau sapaan spesial bagi member yang berhasil mencapai kunjungan ke-10, 25, atau 50. Ini akan menciptakan ikatan emosional (Gamification) yang adiktif.</p>
        </div>
      </div>
    </div>
  </div>


</details>

<div style="margin-bottom: 16px; display: flex; align-items: center; gap: 10px; margin-top: 48px; padding-top: 32px; border-top: 2px dashed rgba(0,0,0,0.06);">
  <div style="font-size: 1.5rem;">🔭</div>
  <div>
    <h2 style="margin: 0; font-size: 1.25rem; font-weight: 800; color: var(--color-text-primary); letter-spacing: -0.02em;">KESEHATAN MAKRO (STRATEGIS)</h2>
    <div style="font-size: 0.85rem; color: var(--color-text-tertiary); font-weight: 500;">Fokus: Evaluasi Kebijakan Bisnis Jangka Panjang</div>
  </div>
</div>

<div class="kpi-grid-2" style="margin-bottom: 12px;">
  <div class="kpi-card revenue">
    <div class="kpi-label">💰 Nilai Member (AOV)</div>
    <div class="kpi-value">Rp {idFormat(aov)}</div>
    <div class="kpi-meta">
      {#if aovDiffPct > 0}
        <span class="trend-indicator up">▲ {idFormat(aovDiffPct, 1)}%</span>
      {:else if aovDiffPct < 0}
        <span class="trend-indicator down">▼ {idFormat(Math.abs(aovDiffPct), 1)}%</span>
      {:else}
        <span class="trend-indicator neutral">0,0%</span>
      {/if}
    </div>
    <div class="kpi-prev">vs non-member: Rp {idFormat(aovNonMember)}</div>
  </div>
  <div class="kpi-card revenue">
    <div class="kpi-label">💳 Revenue Member</div>
    <div class="kpi-value">Rp {idFormat(totalMemberSpend)}</div>
    <div class="kpi-meta">
      <span style="color: var(--color-text-primary); font-weight: 600; display: inline-flex; align-items: center; gap: 4px;">📊 {idFormat(pctRevenueMember, 1)}%</span>
    </div>
    <div class="kpi-prev">dari total omzet restoran bulan ini.</div>
  </div>
</div>
<div class="kpi-grid" style="margin-bottom: 24px;">
  <div class="kpi-card margin">
    <div class="kpi-label">🌱 Akuisisi (Member Baru)</div>
    <div class="kpi-value">{idFormat(newMembers)}</div>
    <div class="kpi-prev" style="margin-top: 12px;">Pendaftar baru 30 hari terakhir.</div>
  </div>
  <div class="kpi-card margin">
    <div class="kpi-label">📦 Transaksi Member</div>
    <div class="kpi-value">{idFormat(totalMemberOrders)}</div>
    <div class="kpi-meta">
      <span style="color: var(--color-text-primary); font-weight: 600; display: inline-flex; align-items: center; gap: 4px;">📊 {idFormat(pctOrder, 1)}%</span>
    </div>
    <div class="kpi-prev">dari total volume struk restoran.</div>
  </div>
  <div class="kpi-card net">
    <div class="kpi-label">🔁 Frekuensi Kunjungan</div>
    <div class="kpi-value">{idFormat(totalMemberOrders / activeMembers, 1)}x</div>
    <div class="kpi-meta">
      <span style="color: var(--color-text-primary); font-weight: 600;">Rata-rata kedatangan</span>
    </div>
    <div class="kpi-prev">per member aktif bulan ini.</div>
  </div>
</div>

<div class="clean-cta-banner">
  <div class="clean-cta-content">
    <div class="clean-cta-icon">🔍</div>
    <div class="clean-cta-text">
      <h3 class="clean-cta-title">Eksplorasi Analitik Makro & Pola Promosi</h3>
      <p class="clean-cta-desc">Bedah lebih dalam efektivitas promo, pergerakan tren pembelanjaan, dan temukan celah keuntungan tersembunyi di balik data transaksi Anda.</p>
    </div>
  </div>
  <a href="/06-member-behavior/03-evaluasi-strategis" class="clean-cta-button">
    Buka Evaluasi Strategis ➔
  </a>
</div>

{:else}
  <GlobalLoading />
{/if}

<style>
.loading-overlay {
  position: fixed;
  top: 0; left: 0; right: 0; bottom: 0;
  background: var(--color-background-primary, #ffffff);
  z-index: 9999;
  display: flex;
  align-items: center;
  justify-content: center;
}
@keyframes pulseLoader {
  0% { transform: scale(0.95); box-shadow: 0 0 0 0 rgba(13, 148, 136, 0.4); }
  70% { transform: scale(1); box-shadow: 0 0 0 15px rgba(13, 148, 136, 0); }
  100% { transform: scale(0.95); box-shadow: 0 0 0 0 rgba(13, 148, 136, 0); }
}
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}
.loader-pulse {
  width: 44px;
  height: 44px;
  border-radius: 50%;
  background: linear-gradient(135deg, #0f766e, #14b8a6);
  animation: pulseLoader 1.5s infinite;
}

.clean-cta-banner {
  margin-top: 32px;
  margin-bottom: 40px;
  padding: 24px 28px;
  border-radius: 16px;
  background: rgba(13, 148, 136, 0.03);
  border: 1px solid rgba(13, 148, 136, 0.15);
  display: flex;
  align-items: center;
  justify-content: space-between;
  box-shadow: 0 4px 12px rgba(13, 148, 136, 0.03);
  transition: all 0.3s ease;
}

.clean-cta-banner:hover {
  background: rgba(13, 148, 136, 0.05);
  border-color: rgba(13, 148, 136, 0.25);
  box-shadow: 0 8px 24px rgba(13, 148, 136, 0.06);
}

.clean-cta-content {
  display: flex;
  align-items: center;
  gap: 20px;
}

.clean-cta-icon {
  font-size: 2.2rem;
  line-height: 1;
  filter: drop-shadow(0 2px 4px rgba(13, 148, 136, 0.15));
}

.clean-cta-title {
  margin: 0 0 4px 0;
  font-size: 1.1rem;
  font-weight: 800;
  letter-spacing: -0.01em;
  color: #0f766e;
}

.clean-cta-desc {
  margin: 0;
  font-size: 0.88rem;
  color: var(--color-text-secondary);
  font-weight: 400;
  max-width: 65ch;
  line-height: 1.6;
}

.clean-cta-button {
  background: white !important;
  border: 1px solid rgba(13, 148, 136, 0.3) !important;
  color: #0d9488 !important;
  font-weight: 800 !important;
  font-size: 0.9rem !important;
  padding: 12px 20px !important;
  border-radius: 8px !important;
  text-decoration: none !important;
  display: inline-flex !important;
  align-items: center !important;
  justify-content: center !important;
  transition: all 0.2s ease !important;
  box-shadow: 0 2px 6px rgba(13, 148, 136, 0.06) !important;
  line-height: 1 !important;
  margin: 0 !important;
  white-space: nowrap !important;
}

.clean-cta-button:hover {
  background: #f0fdfa !important; /* light teal background */
  color: #0f766e !important;
  border-color: #0d9488 !important;
  transform: translateY(-1px) !important;
  box-shadow: 0 4px 12px rgba(13, 148, 136, 0.1) !important;
}


.premium-cta-button .arrow {
  transition: transform 0.3s ease !important;
  display: inline-block !important;
}

.premium-cta-button:hover .arrow {
  transform: translateX(5px) !important;
}
.interactive-card {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);
}
.interactive-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 20px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -5px rgba(0, 0, 0, 0.04);
}

.hero { display: flex; flex-direction: column; gap: 16px; margin-top: 10px; }
.section-card { padding: 16px; border-radius: 16px; border: 1px solid var(--color-border-tertiary); background: var(--color-background-secondary); }
.strategic-title { margin: 0 0 10px; font-size: 1.5rem; line-height: 1.1; letter-spacing: -0.035em; color: var(--color-text-primary); }
.section-eyebrow { font-size: 10px; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 6px; display: flex; align-items: center; gap: 6px; }
.section-head.tight { margin-bottom: 12px; }

/* ── Hero CSS ── */
.hero {
  display: flex;
  flex-direction: column;
  gap: 16px;
  padding: 24px;
  border-radius: 22px;
  border: 1px solid rgba(37, 99, 235, 0.12);
  background:
    radial-gradient(circle at top right, rgba(69, 161, 191, 0.18), transparent 35%),
    radial-gradient(circle at bottom left, rgba(99,102,241,0.08), transparent 40%),
    linear-gradient(135deg, rgba(37, 99, 235, 0.06), rgba(194, 65, 12, 0.04)),
    var(--color-background-secondary);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.02), 0 1px 3px rgba(0, 0, 0, 0.01);
}
.hero-grid {
  display: grid;
  grid-template-columns: minmax(0, 1.7fr) minmax(280px, 1fr);
  gap: 18px;
}
.hero-eyebrow {
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.13em;
  text-transform: uppercase;
  color: var(--color-text-tertiary);
  display: flex;
  align-items: center;
  gap: 6px;
}
.hero-main-card {
  padding: 24px;
  border-radius: 16px;
  border: 1.5px solid transparent;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03), 0 1px 3px rgba(0, 0, 0, 0.02);
}
.hero-main-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.05), 0 2px 5px rgba(0, 0, 0, 0.03);
}
.hero-main-card.status-sehat {
  background: rgba(22, 163, 74, 0.08);
  border-color: rgba(22, 163, 74, 0.22);
}
.hero-main-card.status-waspada {
  background: rgba(245, 158, 11, 0.09);
  border-color: rgba(245, 158, 11, 0.24);
}
.hero-main-card.status-kritis {
  background: rgba(220, 38, 38, 0.08);
  border-color: rgba(239, 68, 68, 0.22);
}

.hero-stat-number {
  font-size: 3.8rem;
  font-weight: 900;
  letter-spacing: -0.04em;
  line-height: 1;
  margin-top: 8px;
  margin-bottom: 2px;
}

.hero-main-card.status-sehat .hero-stat-number { color: #15803d; }
.hero-main-card.status-waspada .hero-stat-number { color: #b45309; }
.hero-main-card.status-kritis .hero-stat-number { color: #b91c1c; }

.hero-stat-label {
  font-size: 0.8rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  font-weight: 700;
  color: var(--color-text-tertiary);
  margin-bottom: 12px;
}
.hero-subtitle {
  font-size: 1.15rem;
  font-weight: 700;
  letter-spacing: -0.02em;
  color: var(--color-text-primary);
  margin-bottom: 0;
}
.hero-side {
  display: flex;
  flex-direction: column;
  gap: 10px;
}
.hero-side-card { 
  padding: 14px 15px; 
  border-radius: 14px; 
  border: 1px solid var(--color-border-tertiary); 
  background: rgba(255,255,255,0.72); 
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
}
.hero-side-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.04), 0 2px 4px rgba(0, 0, 0, 0.02);
  background: rgba(255, 255, 255, 0.9);
}
.hero-side-label { font-size: 10px; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 4px; }
.hero-side-value { font-size: 0.98rem; font-weight: 800; color: var(--color-text-primary); letter-spacing: -0.02em; }
.hero-side-note  { margin-top: 3px; font-size: 0.8rem; line-height: 1.55; color: var(--color-text-secondary); }

/* ── Menu Health CSS ── */
.menu-health { padding: 17px 18px; border-radius: 16px; border: 1px solid var(--color-border-tertiary); background: var(--color-background-secondary); box-shadow: 0 1px 3px rgba(0,0,0,0.035); }
.menu-health-head { display: flex; align-items: center; justify-content: space-between; gap: 10px; flex-wrap: wrap; padding-bottom: 12px; margin-bottom: 12px; border-bottom: 1px solid var(--color-border-tertiary); }
.menu-health-label { font-size: 10px; font-weight: 850; letter-spacing: 0.11em; text-transform: uppercase; color: var(--color-text-tertiary); }
.menu-health-badges { display: flex; align-items: center; gap: 8px; flex-wrap: wrap; }
.menu-health-badge { display: inline-flex; align-items: center; gap: 5px; padding: 4px 10px; border-radius: 999px; font-size: 11px; font-weight: 800; border: 1px solid; transition: all 0.2s ease; cursor: pointer; }
.menu-health-badge:hover { transform: translateY(-2px); box-shadow: 0 4px 8px rgba(0, 0, 0, 0.08); }
.menu-health-badge.safe { background: rgba(22,163,74,0.10); color: #166534; border-color: rgba(22,163,74,0.22); }
.menu-health-badge.warn { background: rgba(234,179,8,0.10); color: #854d0e; border-color: rgba(234,179,8,0.26); }
.menu-health-badge.critical { background: rgba(220,38,38,0.08); color: #991b1b; border-color: rgba(220,38,38,0.20); }
.menu-health-list { display: flex; flex-direction: column; gap: 6px; }
.menu-health-row { display: flex; align-items: flex-start; gap: 10px; padding: 9px 10px; border-radius: 10px; font-size: 0.84rem; line-height: 1.55; border: 1px solid transparent; transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1); cursor: pointer; }
.menu-health-row:hover { transform: translateX(4px) translateY(-1px); box-shadow: 0 4px 12px rgba(0,0,0,0.06); }
.menu-health-row.safe { background: rgba(22,163,74,0.045); border-color: rgba(22,163,74,0.12); }
.menu-health-row.warn { background: rgba(234,179,8,0.045); border-color: rgba(234,179,8,0.16); }
.menu-health-row.critical { background: rgba(220,38,38,0.04); border-color: rgba(220,38,38,0.13); }
.menu-health-row.special { background: rgba(2,132,199,0.045); border-color: rgba(2,132,199,0.14); }
.menu-health-icon { width: 18px; flex: 0 0 18px; margin-top: 1px; font-size: 14px; line-height: 1.2; text-align: center; }
.menu-health-title { font-weight: 850; color: var(--color-text-primary); }
.menu-health-copy { color: var(--color-text-secondary); }
.menu-health-value { font-weight: 850; color: var(--color-text-primary); }

/* ── KPI Grid ── */
.trend-indicator { font-size: 0.82rem; font-weight: 700; display: inline-flex; align-items: center; gap: 3px; }
.trend-indicator.up { color: #16a34a; }
.trend-indicator.down { color: #dc2626; }
.trend-indicator.neutral { color: var(--color-text-tertiary); }

.kpi-grid { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 12px; }
.kpi-grid-2 { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 12px; }
.kpi-card { padding: 18px 16px; border-radius: 18px; border: 1.5px solid var(--color-border-tertiary); background: var(--color-background-secondary); box-shadow: 0 4px 10px rgba(0, 0, 0, 0.02), 0 1px 3px rgba(0, 0, 0, 0.01); transition: all 0.22s ease; text-align: center; }
.kpi-card:hover { transform: translateY(-2px); box-shadow: 0 8px 16px rgba(0, 0, 0, 0.04), 0 2px 4px rgba(0, 0, 0, 0.02); }
.kpi-label { font-size: 10px; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 8px; display: flex; align-items: center; justify-content: center; gap: 5px; }
.kpi-value { font-size: 1.15rem; font-weight: 800; letter-spacing: -0.03em; color: var(--color-text-primary); }
.kpi-meta { margin-top: 6px; font-size: 0.82rem; line-height: 1; }
.kpi-prev { margin-top: 6px; font-size: 0.78rem; color: var(--color-text-secondary); line-height: 1.4; }
.kpi-card.revenue { border-color: rgba(37,99,235,0.18); background: linear-gradient(145deg, rgba(37,99,235,0.06), rgba(99,102,241,0.03)); }
.kpi-card.net { border-color: rgba(16,185,129,0.22); background: linear-gradient(145deg, rgba(16,185,129,0.07), rgba(22,163,74,0.03)); }
.kpi-card.margin { border-color: rgba(245,158,11,0.22); background: linear-gradient(145deg, rgba(245,158,11,0.07), rgba(251,191,36,0.03)); }
.kpi-card.expense { border-color: rgba(239,68,68,0.18); background: linear-gradient(145deg, rgba(239,68,68,0.06), rgba(220,38,38,0.02)); }



.diagnostics-stack { display: flex; flex-direction: column; gap: 16px; margin-top: 14px; }
.diagnostics-header { padding: 0 2px; margin-bottom: 2px; }
.diagnostics-eyebrow { font-size: 10px; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 6px; display: flex; align-items: center; gap: 6px; }
.diagnostics-title { font-size: 1.3rem; font-weight: 800; letter-spacing: -0.025em; color: var(--color-text-primary); margin: 0 0 4px; }
.diagnostics-copy { font-size: 0.9rem; line-height: 1.7; color: var(--color-text-secondary); max-width: 68ch; margin: 0; }

/* ── Signal grid ── */
.signal-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 14px;
}

.signal-card {
  padding: 18px;
  border-radius: 16px;
  border: 1px solid var(--color-border-tertiary);
  background: var(--color-background-secondary);
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
}

.signal-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.04), 0 2px 4px rgba(0, 0, 0, 0.02);
}

.signal-card.safe {
  border-color: rgba(22, 163, 74, 0.25);
  background: linear-gradient(135deg, rgba(22,163,74,0.08), rgba(16,185,129,0.03));
}

.signal-card.warn {
  border-color: rgba(245, 158, 11, 0.3);
  background: linear-gradient(135deg, rgba(245,158,11,0.09), rgba(251,191,36,0.03));
}

.signal-card.critical {
  border-color: rgba(239, 68, 68, 0.25);
  background: linear-gradient(135deg, rgba(239,68,68,0.09), rgba(220,38,38,0.03));
}

.signal-card.neutral {
  border-color: rgba(99, 102, 241, 0.2);
  background: linear-gradient(135deg, rgba(99,102,241,0.07), rgba(139,92,246,0.03));
}

.signal-label {
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.09em;
  text-transform: uppercase;
  color: var(--color-text-tertiary);
  margin-bottom: 6px;
  display: flex;
  align-items: center;
  gap: 5px;
}

.signal-title {
  font-size: 1rem;
  font-weight: 800;
  letter-spacing: -0.02em;
  color: var(--color-text-primary);
  margin-bottom: 6px;
}

.signal-copy {
  font-size: 0.9rem;
  line-height: 1.7;
  color: var(--color-text-secondary);
}
</style>

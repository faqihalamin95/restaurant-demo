---
title: Performa Cabang
sidebar_link: false
---

<script>
  import DiagnosticsHeader from '$lib/DiagnosticsHeader.svelte';
  import SectionHeader from '$lib/SectionHeader.svelte';
  import SectionCard from '$lib/SectionCard.svelte';
</script>

<style>
/* Paksa menu sidebar parent tetap aktif (hijau) saat berada di subpage ini menggunakan :global() */
:global(aside a[href="/02-branch-performance"]),
:global(#mobileScrollable a[href="/02-branch-performance"]) {
  background: linear-gradient(135deg, rgba(13, 148, 136, 0.08), rgba(20, 184, 166, 0.06)) !important;
  color: #0f766e !important;
  font-weight: 700 !important;
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.4) !important;
  border-left: 3px solid #0d9488 !important;
  padding-left: 12px !important;
}

:global([data-theme='dark'] aside a[href="/02-branch-performance"]),
:global([data-theme='dark'] #mobileScrollable a[href="/02-branch-performance"]) {
  background: linear-gradient(135deg, rgba(20, 184, 166, 0.15), rgba(45, 212, 191, 0.08)) !important;
  color: #2dd4bf !important;
  border-left-color: #14b8a6 !important;
}
</style>

```sql branch_list
SELECT * FROM restaurant.branch_deepdive_branch_list
```

```sql branch_dates
SELECT * FROM restaurant.branch_deepdive_branch_dates
```

```sql branch_scorecard
SELECT * FROM restaurant.branch_deepdive_branch_scorecard
```

```sql branch_cost_periods
SELECT * FROM restaurant.branch_deepdive_branch_cost_periods
```

```sql branch_quarterly_report
SELECT * FROM restaurant.branch_deepdive_branch_quarterly_report
```

```sql branch_yoy_report
SELECT * FROM restaurant.branch_deepdive_branch_yoy_report
```

_Dashboard portofolio cabang: kesehatan margin, pertumbuhan, profitabilitas, strategi, dan prioritas aksi._

<details class="guide-acc"  style="margin-top:12px;">
  <summary>💡 Cara memilih subpage</summary>
<div class="guide-body">
    <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
      Navigasikan analisis performa cabang Anda dari ringkasan kesehatan finansial hingga audit granular per outlet.
    </p>
    <div class="guide-grid" style="grid-template-columns: repeat(3, minmax(0, 1fr));">
      <div class="guide-card blue">
        <div class="guide-card-icon">🏠</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Ringkasan</div>
          <h4 class="guide-card-title">Status Utama &amp; Gap</h4>
          <p class="guide-card-desc">Baca cepat volume order, AOV, dan gap ketimpangan antar cabang di seluruh outlet.</p>
        </div>
      </div>
      <div class="guide-card orange">
        <div class="guide-card-icon">🏪</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Deep Dive</div>
          <h4 class="guide-card-title">Audit Per Cabang</h4>
          <p class="guide-card-desc">Audit cabang satu per satu: status margin harian, cogs, tren belanja, dan data pendukung.</p>
        </div>
      </div>
      <div class="guide-card teal">
        <div class="guide-card-icon">🔭</div>
        <div class="guide-card-content">
          <div class="guide-card-label">Analisis</div>
          <h4 class="guide-card-title">Strategi Portofolio</h4>
          <p class="guide-card-desc">Baca analisis pertumbuhan jangka panjang, profitabilitas, dan strategi portofolio cabang.</p>
        </div>
      </div>
    </div>
    <div style="font-size: 0.75rem; color: var(--color-text-secondary); margin-top: 12px;">
      *Total bisnis tetap paling pas dibaca di halaman <a class="inline-link" href="/01-laporan-keuangan">Laporan Keuangan</a>.
    </div>
  </div>
</details>

<div class="evidence-tabs-container">
  <a href="/02-branch-performance" class="tab-button ">🏠 Ringkasan</a>
  <a href="/02-branch-performance/deepdive" class="tab-button active">🏪 Deep Dive</a>
  <a href="/02-branch-performance/analysis" class="tab-button ">🔭 Analisis Lanjutan</a>
</div>

{#if branch_list.length > 0 && branch_dates.length > 0}
  {@const selectedBranchRaw = String(inputs.focus_branch ?? (branch_list[0]?.branch_name ?? ''))}
  {@const selectedBranchNormalized = decodeURIComponent(selectedBranchRaw).replace(/\+/g, ' ')}
  {@const selectedBranch = branch_list.find(branch => branch.branch_name === selectedBranchRaw || branch.branch_name === selectedBranchNormalized)?.branch_name ?? branch_list[0]?.branch_name ?? ''}
  {@const activeScorecard = branch_scorecard.find(row => row.selected_branch === selectedBranch)}
  {@const activeCostPeriods = branch_cost_periods.find(row => row.branch_name === selectedBranch)}

  <!-- Period calculations for Top Selector -->
  {@const activePeriodDeepdive = inputs.period_deepdive ?? '30d'}
  {@const activePeriodLabel = activePeriodDeepdive === 'mtd' ? 'Bulan Ini (MTD)' : activePeriodDeepdive === '90d' ? '90 Hari Terakhir' : '30 Hari Terakhir'}
  
  {@const activeMargin = activeScorecard ? (activePeriodDeepdive === 'mtd' ? activeScorecard.margin_mtd : activePeriodDeepdive === '90d' ? activeScorecard.margin_90d : activeScorecard.margin_30d) : 0}
  {@const activeMarginPrev = activeScorecard ? (activePeriodDeepdive === 'mtd' ? activeScorecard.margin_prev_mtd : activePeriodDeepdive === '90d' ? activeScorecard.margin_prev90d : activeScorecard.margin_prev30d) : 0}
  {@const activeMarginDiff = activeMargin - activeMarginPrev}
  
  {@const activeNet = activeScorecard ? (activePeriodDeepdive === 'mtd' ? activeScorecard.net_mtd : activePeriodDeepdive === '90d' ? activeScorecard.net_90d : activeScorecard.net_30d) : 0}
  {@const activeNetPrev = activeScorecard ? (activePeriodDeepdive === 'mtd' ? activeScorecard.net_prev_mtd : activePeriodDeepdive === '90d' ? activeScorecard.net_prev90d : activeScorecard.net_prev30d) : 0}
  {@const activeGross = activeScorecard ? (activePeriodDeepdive === 'mtd' ? activeScorecard.gross_mtd : activePeriodDeepdive === '90d' ? activeScorecard.gross_90d : activeScorecard.gross_30d) : 0}
  {@const activeGrossPrev = activeScorecard ? (activePeriodDeepdive === 'mtd' ? activeScorecard.gross_prev_mtd : activePeriodDeepdive === '90d' ? activeScorecard.gross_prev90d : activeScorecard.gross_prev30d) : 0}
  {@const activeCost = activeGross - activeNet}
  {@const activeCostPrev = activeGrossPrev - activeNetPrev}
  
  {@const activeMarginState = activeMargin >= 15 ? 'safe' : activeMargin >= 10 ? 'warn' : 'critical'}
  {@const activeMarginColor = activeMargin >= 15 ? '#15803d' : activeMargin >= 10 ? '#b45309' : '#b91c1c'}

  <!-- Cost Calculations -->
  {@const branchIngredientPctMtd = activeCostPeriods ? activeCostPeriods.ingr_mtd / (activeCostPeriods.gross_mtd || 1) * 100 : 0}
  {@const branchLaborPctMtd = activeCostPeriods ? activeCostPeriods.labor_mtd / (activeCostPeriods.gross_mtd || 1) * 100 : 0}
  {@const branchOverheadPctMtd = activeCostPeriods ? activeCostPeriods.overhead_mtd / (activeCostPeriods.gross_mtd || 1) * 100 : 0}

  {@const branchIngredientPct30 = activeCostPeriods ? activeCostPeriods.ingr_30d / (activeCostPeriods.gross_30d || 1) * 100 : 0}
  {@const branchLaborPct30 = activeCostPeriods ? activeCostPeriods.labor_30d / (activeCostPeriods.gross_30d || 1) * 100 : 0}
  {@const branchOverheadPct30 = activeCostPeriods ? activeCostPeriods.overhead_30d / (activeCostPeriods.gross_30d || 1) * 100 : 0}
  
  {@const branchIngredientPct90 = activeCostPeriods ? activeCostPeriods.ingr_90d / (activeCostPeriods.gross_90d || 1) * 100 : 0}
  {@const branchLaborPct90 = activeCostPeriods ? activeCostPeriods.labor_90d / (activeCostPeriods.gross_90d || 1) * 100 : 0}
  {@const branchOverheadPct90 = activeCostPeriods ? activeCostPeriods.overhead_90d / (activeCostPeriods.gross_90d || 1) * 100 : 0}
  
  <!-- Cost Pressure for MTD -->
  {@const mtdIngrExcess = branchIngredientPctMtd - 32}
  {@const mtdLaborExcess = branchLaborPctMtd - 30}
  {@const mtdOverheadExcess = branchOverheadPctMtd - 15}
  {@const mtdMaxExcess = Math.max(mtdIngrExcess, mtdLaborExcess, mtdOverheadExcess)}
  {@const branchMainCostPressureMtd = mtdMaxExcess <= 0 ? 'semua biaya dalam batas' : mtdMaxExcess === mtdOverheadExcess ? 'biaya operasional' : mtdMaxExcess === mtdIngrExcess ? 'biaya bahan' : 'biaya SDM'}

  <!-- Cost Pressure for 30D -->
  {@const ingrExcess = branchIngredientPct30 - 32}
  {@const laborExcess = branchLaborPct30 - 30}
  {@const overheadExcess = branchOverheadPct30 - 15}
  {@const maxExcess = Math.max(ingrExcess, laborExcess, overheadExcess)}
  {@const branchMainCostPressure = maxExcess <= 0 ? 'semua biaya dalam batas' : maxExcess === overheadExcess ? 'biaya operasional' : maxExcess === ingrExcess ? 'biaya bahan' : 'biaya SDM'}

  <!-- Cost Pressure for 90D -->
  {@const ingrExcess90 = branchIngredientPct90 - 32}
  {@const laborExcess90 = branchLaborPct90 - 30}
  {@const overheadExcess90 = branchOverheadPct90 - 15}
  {@const maxExcess90 = Math.max(ingrExcess90, laborExcess90, overheadExcess90)}
  {@const branchMainCostPressure90 = maxExcess90 <= 0 ? 'semua biaya dalam batas' : maxExcess90 === overheadExcess90 ? 'biaya operasional' : maxExcess90 === ingrExcess90 ? 'biaya bahan' : 'biaya SDM'}

  {@const activePeriodDates = activePeriodDeepdive === 'mtd' ? `${branch_dates[0].tgl_mtd_awal} - ${branch_dates[0].tgl_akhir}` : activePeriodDeepdive === '90d' ? `${branch_dates[0].tgl_90_awal} - ${branch_dates[0].tgl_akhir}` : `${branch_dates[0].tgl_30_awal} - ${branch_dates[0].tgl_akhir}`}
  {@const activeGrowthPct = activeScorecard ? (activePeriodDeepdive === 'mtd' ? activeScorecard.rev_pct_mtd : activePeriodDeepdive === '90d' ? activeScorecard.rev_pct_90d : activeScorecard.rev_pct_30d) : 0}
  {@const activeCostPressureLabel = activePeriodDeepdive === 'mtd' ? branchMainCostPressureMtd : activePeriodDeepdive === '90d' ? branchMainCostPressure90 : branchMainCostPressure}
  {@const activeCostPressureGap = activePeriodDeepdive === 'mtd' ? mtdMaxExcess : activePeriodDeepdive === '90d' ? maxExcess90 : maxExcess}

  <!-- Core Metric Calculations for Accordion -->
  {@const activeMetricPeriod = inputs.deepdive_metric_period ?? '30d'}
  {@const activeMetricPeriodLabel = activeMetricPeriod === 'yesterday' ? 'hari serupa (SDOW) minggu lalu' : activeMetricPeriod === '7d' ? '7 hari sebelumnya' : '30 hari sebelumnya'}
  
  {@const activeMetricRev = activeScorecard ? (activeMetricPeriod === 'yesterday' ? activeScorecard.rev_yesterday : activeMetricPeriod === '7d' ? activeScorecard.rev_7d : activeScorecard.rev_30d) : 0}
  {@const activeMetricRevPrev = activeScorecard ? (activeMetricPeriod === 'yesterday' ? activeScorecard.rev_sdow_yesterday : activeMetricPeriod === '7d' ? activeScorecard.rev_prev7d : activeScorecard.rev_prev30d) : 0}
  {@const activeMetricRevPct = activeScorecard ? (activeMetricRevPrev > 0 ? Math.round((activeMetricRev - activeMetricRevPrev) / activeMetricRevPrev * 100 * 10) / 10 : 0) : 0}

  {@const activeMetricOrd = activeScorecard ? (activeMetricPeriod === 'yesterday' ? activeScorecard.ord_yesterday : activeMetricPeriod === '7d' ? activeScorecard.ord_7d : activeScorecard.ord_30d) : 0}
  {@const activeMetricOrdPrev = activeScorecard ? (activeMetricPeriod === 'yesterday' ? activeScorecard.ord_sdow_yesterday : activeMetricPeriod === '7d' ? activeScorecard.ord_prev7d : activeScorecard.ord_prev30d) : 0}
  {@const activeMetricOrdPct = activeScorecard ? (activeMetricOrdPrev > 0 ? Math.round((activeMetricOrd - activeMetricOrdPrev) / activeMetricOrdPrev * 100 * 10) / 10 : 0) : 0}

  {@const activeMetricAov = activeScorecard ? (activeMetricPeriod === 'yesterday' ? activeScorecard.aov_yesterday : activeMetricPeriod === '7d' ? activeScorecard.aov_7d : activeScorecard.aov_30d) : 0}
  {@const activeMetricAovPrev = activeScorecard ? (activeMetricPeriod === 'yesterday' ? activeScorecard.aov_sdow_yesterday : activeMetricPeriod === '7d' ? Math.round(activeScorecard.rev_prev7d / Math.max(activeScorecard.ord_prev7d, 1)) : Math.round(activeScorecard.rev_prev30d / Math.max(activeScorecard.ord_prev30d, 1))) : 0}
  {@const activeMetricAovPct = activeScorecard ? (activeMetricAovPrev > 0 ? Math.round((activeMetricAov - activeMetricAovPrev) / activeMetricAovPrev * 100 * 10) / 10 : 0) : 0}

<div class="branch-page">

<SectionCard 
  eyebrow="🏪 Pilih Cabang" 
  title="Deep Dive per Cabang" 
  description="Pilih cabang tertentu untuk menganalisis tren margin harian, breakdown pos biaya operasional, dan sebaran jenis pesanan secara mendalam."
>
    <ButtonGroup name=focus_branch>
      {#each branch_list as branch, i}
        <ButtonGroupItem value={branch.branch_name} valueLabel={branch.branch_name} default={i === 0} />
      {/each}
    </ButtonGroup>
</SectionCard>

  {#if activeScorecard && activeScorecard.rev_30d !== null && activeCostPeriods && activeCostPeriods.gross_30d !== null}

    <!-- JIT accordion -->
    <details class="guide-acc"  style="margin-top: 10px; margin-bottom: 16px;">
  <summary>💡 Cara membaca deep dive cabang</summary>
<div class="guide-body">
        <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
          Membantu mengidentifikasi kebocoran operasional di tingkat outlet dengan melacak transisi dari harian hingga jangka panjang.
        </p>
        <div class="guide-grid" style="grid-template-columns: repeat(2, minmax(0, 1fr));">
          <div class="guide-card blue">
            <div class="guide-card-icon">⏱️</div>
            <div class="guide-card-content">
              <div class="guide-card-label">Horizon Waktu</div>
              <h4 class="guide-card-title">Multi-Horizon Strip</h4>
              <p class="guide-card-desc">Menampilkan transisi performa dari jangka sangat pendek (Kemarin, 7H) hingga jangka menengah (30H, MTD, 90H).</p>
            </div>
          </div>
          <div class="guide-card orange">
            <div class="guide-card-icon">📊</div>
            <div class="guide-card-content">
              <div class="guide-card-label">Operational</div>
              <h4 class="guide-card-title">Kinerja 30H vs 90H</h4>
              <p class="guide-card-desc">Membandingkan 30 Hari operasional aktif dengan baseline 90 Hari untuk mendeteksi anomali biaya/COGS.</p>
            </div>
          </div>
          <div class="guide-card teal">
            <div class="guide-card-icon">🗓️</div>
            <div class="guide-card-content">
              <div class="guide-card-label">Siklus</div>
              <h4 class="guide-card-title">Tren Kuartalan QoQ</h4>
              <p class="guide-card-desc">Membaca kestabilan musiman untuk memastikan apakah cabang memiliki pola transaksi di kuartal tertentu.</p>
            </div>
          </div>
          <div class="guide-card purple">
            <div class="guide-card-icon">📜</div>
            <div class="guide-card-content">
              <div class="guide-card-label">Fundamental</div>
              <h4 class="guide-card-title">Historis YoY</h4>
              <p class="guide-card-desc">Melacak arah fundamental tahun ke tahun sejak awal berdiri untuk menilai keberlanjutan outlet.</p>
            </div>
          </div>
        </div>
      </div>
</details>

    <!-- ── Section: Multi-Horizon Operational Metrics ── -->
    <SectionHeader 
      eyebrow="⏱️ Horizon Waktu &amp; Kinerja Operasional"
      title="Ringkasan Kinerja Multi-Horizon (Langkah Waktu)"
      description="Metrik operasional penting dari kinerja harian jangka sangat pendek hingga jangka menengah 90 hari untuk mendeteksi anomali secara dini."
    />

    <!-- ── 5-Horizon Period Strip ── -->
    {@const yesterdaySdowPct = activeScorecard ? (activeScorecard.rev_sdow_yesterday > 0 ? (activeScorecard.rev_yesterday - activeScorecard.rev_sdow_yesterday) / activeScorecard.rev_sdow_yesterday * 100 : 0) : 0}
    {@const yesterdayStatus = yesterdaySdowPct >= -5 ? 'sehat' : yesterdaySdowPct >= -15 ? 'waspada' : 'kritis'}

    <div class="period-strip" style="margin-top: 10px; margin-bottom: 12px; grid-template-columns: repeat(2, minmax(0, 1fr));">
      <!-- Kemarin -->
      <div class="period-pill {yesterdayStatus}">
        <div class="period-pill-label">📅 Kemarin ({branch_dates[0].tgl_akhir})</div>
        <div class="period-pill-value" style="font-size: 1.05rem;">
          <span class="pill-badge {yesterdayStatus}">
            {yesterdayStatus === 'sehat' ? '✅ Sehat' : yesterdayStatus === 'waspada' ? '⚠️ Waspada' : '🚨 Kritis'}
          </span>
          {yesterdaySdowPct >= 0 ? '+' : ''}{yesterdaySdowPct.toFixed(1)}% vs SDOW
        </div>
        <div class="period-pill-copy" style="font-size: 0.76rem; line-height: 1.45;">
          Gross: <strong>Rp {activeScorecard.gross_yesterday?.toLocaleString('id-ID')}</strong><br/>
          Orders: <strong>{activeScorecard.ord_yesterday?.toLocaleString('id-ID')}</strong><br/>
          AOV: <strong>Rp {activeScorecard.aov_yesterday?.toLocaleString('id-ID')}</strong>
          <div style="font-size: 0.65rem; color: var(--color-text-tertiary); margin-top: 6px; border-top: 1px dashed var(--color-border-tertiary); padding-top: 4px; line-height: 1.35;">
            *Catatan: Pembanding SDOW (Same Day of Week) mencocokkan hari yang sama (misal: Senin vs Senin) untuk menghindari bias akhir pekan.
          </div>
        </div>
      </div>

      <!-- Bulan Ini (MTD) -->
      <div class="period-pill {activeScorecard.margin_mtd >= 15 ? 'sehat' : activeScorecard.margin_mtd >= 10 ? 'waspada' : 'kritis'}">
        <div class="period-pill-label">📅 Bulan Ini (MTD - {branch_dates[0].nama_bulan})</div>
        <div class="period-pill-value" style="font-size: 1.05rem;">
          <span class="pill-badge {activeScorecard.margin_mtd >= 15 ? 'sehat' : activeScorecard.margin_mtd >= 10 ? 'waspada' : 'kritis'}">
            {activeScorecard.margin_mtd >= 15 ? '✅' : activeScorecard.margin_mtd >= 10 ? '⚠️' : '🚨'} {activeScorecard.margin_mtd >= 15 ? 'Sehat' : activeScorecard.margin_mtd >= 10 ? 'Waspada' : 'Kritis'}
          </span>
          {activeScorecard.margin_mtd !== null ? activeScorecard.margin_mtd.toFixed(1) + '%' : '-'}
        </div>
        <div class="period-pill-copy" style="font-size: 0.76rem; line-height: 1.45;">
          Gross: <strong>Rp {activeScorecard.gross_mtd?.toLocaleString('id-ID')}</strong><br/>
          Orders: <strong>{activeScorecard.ord_mtd?.toLocaleString('id-ID')}</strong><br/>
          AOV: <strong>Rp {activeScorecard.aov_mtd?.toLocaleString('id-ID')}</strong>
          <div style="font-size: 0.65rem; color: var(--color-text-tertiary); margin-top: 6px; border-top: 1px dashed var(--color-border-tertiary); padding-top: 4px; line-height: 1.35;">
            *Catatan: Data awal bulan berjalan bersifat sementara & belum mencerminkan total bulanan secara akurat.
          </div>
        </div>
      </div>
    </div>

    <div class="period-strip" style="margin-bottom: 16px;">
      <!-- 7 Hari -->
      <div class="period-pill {activeScorecard.margin_7d >= 15 ? 'sehat' : activeScorecard.margin_7d >= 10 ? 'waspada' : 'kritis'}">
        <div class="period-pill-label">⚡ 7 Hari Terakhir</div>
        <div class="period-pill-value" style="font-size: 1.05rem;">
          <span class="pill-badge {activeScorecard.margin_7d >= 15 ? 'sehat' : activeScorecard.margin_7d >= 10 ? 'waspada' : 'kritis'}">
            {activeScorecard.margin_7d >= 15 ? '✅' : activeScorecard.margin_7d >= 10 ? '⚠️' : '🚨'} {activeScorecard.margin_7d >= 15 ? 'Sehat' : activeScorecard.margin_7d >= 10 ? 'Waspada' : 'Kritis'}
          </span>
          {activeScorecard.margin_7d !== null ? activeScorecard.margin_7d.toFixed(1) + '%' : '-'}
        </div>
        <div class="period-pill-copy" style="font-size: 0.76rem; line-height: 1.45;">
          Gross: <strong>Rp {activeScorecard.gross_7d?.toLocaleString('id-ID')}</strong><br/>
          Orders: <strong>{activeScorecard.ord_7d?.toLocaleString('id-ID')}</strong><br/>
          AOV: <strong>Rp {activeScorecard.aov_7d?.toLocaleString('id-ID')}</strong>
        </div>
      </div>

      <!-- 30 Hari -->
      <div class="period-pill {activeScorecard.margin_30d >= 15 ? 'sehat' : activeScorecard.margin_30d >= 10 ? 'waspada' : 'kritis'}">
        <div class="period-pill-label">📊 30 Hari Terakhir</div>
        <div class="period-pill-value" style="font-size: 1.05rem;">
          <span class="pill-badge {activeScorecard.margin_30d >= 15 ? 'sehat' : activeScorecard.margin_30d >= 10 ? 'waspada' : 'kritis'}">
            {activeScorecard.margin_30d >= 15 ? '✅' : activeScorecard.margin_30d >= 10 ? '⚠️' : '🚨'} {activeScorecard.margin_30d >= 15 ? 'Sehat' : activeScorecard.margin_30d >= 10 ? 'Waspada' : 'Kritis'}
          </span>
          {activeScorecard.margin_30d !== null ? activeScorecard.margin_30d.toFixed(1) + '%' : '-'}
        </div>
        <div class="period-pill-copy" style="font-size: 0.76rem; line-height: 1.45;">
          Gross: <strong>Rp {activeScorecard.gross_30d?.toLocaleString('id-ID')}</strong><br/>
          Orders: <strong>{activeScorecard.ord_30d?.toLocaleString('id-ID')}</strong><br/>
          AOV: <strong>Rp {activeScorecard.aov_30d?.toLocaleString('id-ID')}</strong>
        </div>
      </div>

      <!-- 90 Hari -->
      <div class="period-pill {activeScorecard.margin_90d >= 15 ? 'sehat' : activeScorecard.margin_90d >= 10 ? 'waspada' : 'kritis'}">
        <div class="period-pill-label">🔭 90 Hari Terakhir</div>
        <div class="period-pill-value" style="font-size: 1.05rem;">
          <span class="pill-badge {activeScorecard.margin_90d >= 15 ? 'sehat' : activeScorecard.margin_90d >= 10 ? 'waspada' : 'kritis'}">
            {activeScorecard.margin_90d >= 15 ? '✅' : activeScorecard.margin_90d >= 10 ? '⚠️' : '🚨'} {activeScorecard.margin_90d >= 15 ? 'Sehat' : activeScorecard.margin_90d >= 10 ? 'Waspada' : 'Kritis'}
          </span>
          {activeScorecard.margin_90d !== null ? activeScorecard.margin_90d.toFixed(1) + '%' : '-'}
        </div>
        <div class="period-pill-copy" style="font-size: 0.76rem; line-height: 1.45;">
          Gross: <strong>Rp {activeScorecard.gross_90d?.toLocaleString('id-ID')}</strong><br/>
          Orders: <strong>{activeScorecard.ord_90d?.toLocaleString('id-ID')}</strong><br/>
          AOV: <strong>Rp {activeScorecard.aov_90d?.toLocaleString('id-ID')}</strong>
        </div>
      </div>
    </div>

    <!-- Accordion Section -->
      
      <!-- SECTION: Operasional & Diagnostik -->
      <DiagnosticsHeader 
        marginTop="24px"
        eyebrow="🔬 Operasional &amp; Diagnostik"
        title="Bedah performa &amp; detail biaya"
        description="Gunakan instrumen di bawah ini untuk menganalisis detail pengeluaran, radar peringatan operasional harian, serta tren perkembangan margin."
      />
        
        <!-- ACCORDION 1: 30 Hari vs 90 Hari -->
        <details class="acc-strategic" open>
          <summary>📊 Detail Analisis Operasional &amp; Tren</summary>
        <div class="acc-body">
          <div style="margin-bottom: 16px;">
            {#if activeScorecard.margin_30d > activeScorecard.margin_90d}
              <div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:12px 16px;border-radius:6px;margin:8px 0;font-size:0.9em;line-height:1.6;color:var(--color-text-primary);">
                📈 <strong>Tren Membaik:</strong> Margin 30 Hari terakhir ({activeScorecard.margin_30d.toFixed(1)}%) lebih tinggi dibandingkan baseline 90 Hari ({activeScorecard.margin_90d.toFixed(1)}%). Menunjukkan adanya perbaikan efisiensi atau pertumbuhan yang sehat dalam jangka pendek di cabang ini.
              </div>
            {:else if activeScorecard.margin_30d < activeScorecard.margin_90d}
              <div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:12px 16px;border-radius:6px;margin:8px 0;font-size:0.9em;line-height:1.6;color:var(--color-text-primary);">
                📉 <strong>Tren Menurun:</strong> Margin 30 Hari terakhir ({activeScorecard.margin_30d.toFixed(1)}%) mengalami pelemahan dibandingkan baseline 90 Hari ({activeScorecard.margin_90d.toFixed(1)}%). Ini bisa menjadi sinyal kebocoran biaya baru (COGS/Labor/Overhead) atau penurunan volume transaksi di cabang ini yang perlu diaudit secara menyeluruh.
              </div>
            {:else}
              <div style="background:rgba(0,0,0,0.04);border-left:4px solid #6b7280;padding:12px 16px;border-radius:6px;margin:8px 0;font-size:0.9em;line-height:1.6;color:var(--color-text-primary);">
                📊 <strong>Tren Stabil:</strong> Margin aktif 30 Hari ({activeScorecard.margin_30d.toFixed(1)}%) bergerak stabil selaras dengan baseline 90 Hari ({activeScorecard.margin_90d.toFixed(1)}%).
              </div>
            {/if}
          </div>

          <!-- Side-by-side comparison table -->
          <!-- Side-by-side comparison table -->
          <div style="overflow-x: auto; margin-bottom: 20px;">
            <table style="width:100%; border-collapse:collapse; font-size:0.88rem; text-align:left; border: 1px solid var(--color-border-tertiary); border-radius: 8px;">
              <thead>
                <tr style="background:var(--color-background-secondary); border-bottom:1.5px solid var(--color-border-tertiary);">
                  <th style="padding:10px 14px; font-weight:700; color:var(--color-text-primary);">Parameter Analisis</th>
                  <th style="padding:10px 14px; font-weight:700; text-align:right; color:var(--color-text-primary);">30 Hari Terakhir (Aktif)</th>
                  <th style="padding:10px 14px; font-weight:700; text-align:right; color:var(--color-text-primary);">90 Hari Terakhir (Baseline)</th>
                  <th style="padding:10px 14px; font-weight:700; text-align:right; color:var(--color-text-primary);">Selisih / Perubahan</th>
                </tr>
              </thead>
              <tbody>
                <tr style="border-bottom:1px solid var(--color-border-tertiary);">
                  <td style="padding:10px 14px; font-weight:600;">📈 Net Margin (%)</td>
                  <td style="padding:10px 14px; text-align:right; font-weight:700; color:{activeScorecard.margin_30d >= 15 ? '#16a34a' : activeScorecard.margin_30d >= 10 ? '#b45309' : '#dc2626'}">{activeScorecard.margin_30d?.toFixed(1)}%</td>
                  <td style="padding:10px 14px; text-align:right; color:var(--color-text-secondary);">{activeScorecard.margin_90d?.toFixed(1)}%</td>
                  <td style="padding:10px 14px; text-align:right; font-weight:700; color:{activeScorecard.margin_30d >= activeScorecard.margin_90d ? '#16a34a' : '#dc2626'}">
                    {activeScorecard.margin_30d >= activeScorecard.margin_90d ? '+' : ''}{(activeScorecard.margin_30d - activeScorecard.margin_90d).toFixed(1)}%
                  </td>
                </tr>
                <tr style="border-bottom:1px solid var(--color-border-tertiary);">
                  <td style="padding:10px 14px; font-weight:600;">💵 Rata-rata Omzet Harian</td>
                  <td style="padding:10px 14px; text-align:right; font-weight:700;">Rp {Math.round(activeScorecard.gross_30d / 30)?.toLocaleString('id-ID')}</td>
                  <td style="padding:10px 14px; text-align:right; color:var(--color-text-secondary);">Rp {Math.round(activeScorecard.gross_90d / 90)?.toLocaleString('id-ID')}</td>
                  <td style="padding:10px 14px; text-align:right; font-weight:700; color:{activeScorecard.gross_30d/30 >= activeScorecard.gross_90d/90 ? '#16a34a' : '#dc2626'}">
                    {activeScorecard.gross_30d/30 >= activeScorecard.gross_90d/90 ? '▲ +' : '▼ '}{(((activeScorecard.gross_30d/30) - (activeScorecard.gross_90d/90)) / (activeScorecard.gross_90d/90 || 1) * 100).toFixed(1)}%
                  </td>
                </tr>
                <tr style="border-bottom:1px solid var(--color-border-tertiary);">
                  <td style="padding:10px 14px; font-weight:600;">📦 Rata-rata Order Harian</td>
                  <td style="padding:10px 14px; text-align:right; font-weight:700;">{(activeScorecard.ord_30d / 30).toFixed(1)} order</td>
                  <td style="padding:10px 14px; text-align:right; color:var(--color-text-secondary);">{(activeScorecard.ord_90d / 90).toFixed(1)} order</td>
                  <td style="padding:10px 14px; text-align:right; font-weight:700; color:{activeScorecard.ord_30d/30 >= activeScorecard.ord_90d/90 ? '#16a34a' : '#dc2626'}">
                    {activeScorecard.ord_30d/30 >= activeScorecard.ord_90d/90 ? '▲ +' : '▼ '}{(((activeScorecard.ord_30d/30) - (activeScorecard.ord_90d/90)) / (activeScorecard.ord_90d/90 || 1) * 100).toFixed(1)}%
                  </td>
                </tr>
                <tr style="border-bottom:1px solid var(--color-border-tertiary);">
                  <td style="padding:10px 14px; font-weight:600;">🛍️ Average Order Value (AOV)</td>
                  <td style="padding:10px 14px; text-align:right; font-weight:700; color:{activeScorecard.aov_30d >= 50000 ? '#16a34a' : activeScorecard.aov_30d >= 35000 ? '#b45309' : '#dc2626'}">Rp {activeScorecard.aov_30d?.toLocaleString('id-ID')}</td>
                  <td style="padding:10px 14px; text-align:right; color:var(--color-text-secondary);">Rp {activeScorecard.aov_90d?.toLocaleString('id-ID')}</td>
                  <td style="padding:10px 14px; text-align:right; font-weight:700; color:{activeScorecard.aov_30d >= activeScorecard.aov_90d ? '#16a34a' : '#dc2626'}">
                    {activeScorecard.aov_30d >= activeScorecard.aov_90d ? '▲ +' : '▼ '}{(((activeScorecard.aov_30d - activeScorecard.aov_90d) / (activeScorecard.aov_90d || 1)) * 100).toFixed(1)}%
                  </td>
                </tr>
                <tr style="border-bottom:1px solid var(--color-border-tertiary);">
                  <td style="padding:10px 14px; font-weight:600;">🥩 Rasio Biaya Bahan Baku</td>
                  <td style="padding:10px 14px; text-align:right; font-weight:700; color:{branchIngredientPct30 <= 32 ? '#16a34a' : '#dc2626'}">{branchIngredientPct30.toFixed(1)}% <span style="font-weight:400; font-size:0.75rem; color:var(--color-text-tertiary);">(Maks 32%)</span></td>
                  <td style="padding:10px 14px; text-align:right; color:var(--color-text-secondary);">{branchIngredientPct90.toFixed(1)}%</td>
                  <td style="padding:10px 14px; text-align:right; font-weight:700; color:{branchIngredientPct30 <= branchIngredientPct90 ? '#16a34a' : '#dc2626'}">
                    {branchIngredientPct30 > branchIngredientPct90 ? '+' : ''}{(branchIngredientPct30 - branchIngredientPct90).toFixed(1)}%
                  </td>
                </tr>
                <tr style="border-bottom:1px solid var(--color-border-tertiary);">
                  <td style="padding:10px 14px; font-weight:600;">👥 Rasio Biaya Tenaga Kerja</td>
                  <td style="padding:10px 14px; text-align:right; font-weight:700; color:{branchLaborPct30 <= 30 ? '#16a34a' : '#dc2626'}">{branchLaborPct30.toFixed(1)}% <span style="font-weight:400; font-size:0.75rem; color:var(--color-text-tertiary);">(Maks 30%)</span></td>
                  <td style="padding:10px 14px; text-align:right; color:var(--color-text-secondary);">{branchLaborPct90.toFixed(1)}%</td>
                  <td style="padding:10px 14px; text-align:right; font-weight:700; color:{branchLaborPct30 <= branchLaborPct90 ? '#16a34a' : '#dc2626'}">
                    {branchLaborPct30 > branchLaborPct90 ? '+' : ''}{(branchLaborPct30 - branchLaborPct90).toFixed(1)}%
                  </td>
                </tr>
                <tr style="border-bottom:none;">
                  <td style="padding:10px 14px; font-weight:600;">🏢 Rasio Biaya Overhead</td>
                  <td style="padding:10px 14px; text-align:right; font-weight:700; color:{branchOverheadPct30 <= 15 ? '#16a34a' : '#dc2626'}">{branchOverheadPct30.toFixed(1)}% <span style="font-weight:400; font-size:0.75rem; color:var(--color-text-tertiary);">(Maks 15%)</span></td>
                  <td style="padding:10px 14px; text-align:right; color:var(--color-text-secondary);">{branchOverheadPct90.toFixed(1)}%</td>
                  <td style="padding:10px 14px; text-align:right; font-weight:700; color:{branchOverheadPct30 <= branchOverheadPct90 ? '#16a34a' : '#dc2626'}">
                    {branchOverheadPct30 > branchOverheadPct90 ? '+' : ''}{(branchOverheadPct30 - branchOverheadPct90).toFixed(1)}%
                  </td>
                </tr>
              </tbody>
            </table>
          </div>

          <!-- Breakdown progress bars visually -->
          <div class="cost-grid" style="margin-top: 16px;">
            <div class="cost-card" style="padding: 16px; border: 1px solid var(--color-border-tertiary); border-radius: 12px;">
              <div class="cost-label" style="font-size: 0.82rem; font-weight: 700;">🥩 Bahan Baku (COGS)</div>
              <div class="cost-value" style="font-size: 1.4rem; font-weight: 800; color:{branchIngredientPct30 <= 32 ? '#16a34a' : '#dc2626'}; margin: 4px 0;">{branchIngredientPct30.toFixed(1)}%</div>
              <div class="cost-target" style="font-size: 0.76rem; color:var(--color-text-tertiary); margin-bottom: 8px;">Target maks 32%</div>
              <div class="progress-track" style="height: 6px; background: rgba(0,0,0,0.06); border-radius: 3px; position: relative;">
                <div class="progress-fill" style="position: absolute; height: 100%; border-radius: 3px; width:{Math.min(branchIngredientPct30 / 40 * 100, 100)}%; background:{branchIngredientPct30 > 32 ? 'linear-gradient(90deg,#ef4444,#fca5a5)' : 'linear-gradient(90deg,#16a34a,#86efac)'};"></div>
                <div class="progress-target" style="position: absolute; height: 12px; width: 2px; background: #6b7280; top: -3px; left:{32 / 40 * 100}%;"></div>
              </div>
              <div class="progress-scale" style="display: flex; justify-content: space-between; font-size: 0.72rem; color: var(--color-text-tertiary); margin-top: 4px;"><span>0%</span><span>32%</span><span>40%</span></div>
              <div class="cost-note" style="font-size: 0.76rem; color: var(--color-text-secondary); margin-top: 6px;">Baseline 90H: {branchIngredientPct90.toFixed(1)}%</div>
            </div>
            
            <div class="cost-card" style="padding: 16px; border: 1px solid var(--color-border-tertiary); border-radius: 12px;">
              <div class="cost-label" style="font-size: 0.82rem; font-weight: 700;">👥 Tenaga Kerja</div>
              <div class="cost-value" style="font-size: 1.4rem; font-weight: 800; color:{branchLaborPct30 <= 30 ? '#16a34a' : '#dc2626'}; margin: 4px 0;">{branchLaborPct30.toFixed(1)}%</div>
              <div class="cost-target" style="font-size: 0.76rem; color:var(--color-text-tertiary); margin-bottom: 8px;">Target maks 30%</div>
              <div class="progress-track" style="height: 6px; background: rgba(0,0,0,0.06); border-radius: 3px; position: relative;">
                <div class="progress-fill" style="position: absolute; height: 100%; border-radius: 3px; width:{Math.min(branchLaborPct30 / 40 * 100, 100)}%; background:{branchLaborPct30 > 30 ? 'linear-gradient(90deg,#ef4444,#fca5a5)' : 'linear-gradient(90deg,#16a34a,#86efac)'};"></div>
                <div class="progress-target" style="position: absolute; height: 12px; width: 2px; background: #6b7280; top: -3px; left:{30 / 40 * 100}%;"></div>
              </div>
              <div class="progress-scale" style="display: flex; justify-content: space-between; font-size: 0.72rem; color: var(--color-text-tertiary); margin-top: 4px;"><span>0%</span><span>30%</span><span>40%</span></div>
              <div class="cost-note" style="font-size: 0.76rem; color: var(--color-text-secondary); margin-top: 6px;">Baseline 90H: {branchLaborPct90.toFixed(1)}%</div>
            </div>

            <div class="cost-card" style="padding: 16px; border: 1px solid var(--color-border-tertiary); border-radius: 12px;">
              <div class="cost-label" style="font-size: 0.82rem; font-weight: 700;">🏢 Overhead</div>
              <div class="cost-value" style="font-size: 1.4rem; font-weight: 800; color:{branchOverheadPct30 <= 15 ? '#16a34a' : '#dc2626'}; margin: 4px 0;">{branchOverheadPct30.toFixed(1)}%</div>
              <div class="cost-target" style="font-size: 0.76rem; color:var(--color-text-tertiary); margin-bottom: 8px;">Target maks 15%</div>
              <div class="progress-track" style="height: 6px; background: rgba(0,0,0,0.06); border-radius: 3px; position: relative;">
                <div class="progress-fill" style="position: absolute; height: 100%; border-radius: 3px; width:{Math.min(branchOverheadPct30 / 25 * 100, 100)}%; background:{branchOverheadPct30 > 15 ? 'linear-gradient(90deg,#ef4444,#fca5a5)' : 'linear-gradient(90deg,#16a34a,#86efac)'};"></div>
                <div class="progress-target" style="position: absolute; height: 12px; width: 2px; background: #6b7280; top: -3px; left:{15 / 25 * 100}%;"></div>
              </div>
              <div class="progress-scale" style="display: flex; justify-content: space-between; font-size: 0.72rem; color: var(--color-text-tertiary); margin-top: 4px;"><span>0%</span><span>15%</span><span>25%</span></div>
              <div class="cost-note" style="font-size: 0.76rem; color: var(--color-text-secondary); margin-top: 6px;">Baseline 90H: {branchOverheadPct90.toFixed(1)}%</div>
            </div>
          </div>
          
          <div class="chart-insight" style="margin-top: 16px;">
            📌 <strong>Rekomendasi Tindakan:</strong> Fokus penanganan pada komponen biaya yang melebihi target dengan gap terbesar (biaya bahan baku &gt;32%, tenaga kerja &gt;30%, overhead &gt;15%).
          </div>
        </div>
      </details>

      <!-- SECTION: Perspektif Strategis -->
      <DiagnosticsHeader 
        eyebrow="🔭 Perspektif Strategis"
        title="Baca pola jangka panjang"
        description="Dua lens di bawah ini dirancang untuk pertanyaan yang lebih besar: apakah ada pola musiman yang perlu diantisipasi, dan apakah bisnis benar-benar membaik secara fundamental dari tahun ke tahun?"
      />

        <!-- ACCORDION 2: Evaluasi Jangka Menengah (Kuartal QoQ) -->
        <details class="acc-strategic">
          <summary>📊 Quarter Report &middot; Baca Fenomena Musiman</summary>
        <div class="acc-body">
          <div style="margin-bottom: 20px;">
            <BarChart 
              data={branch_quarterly_report.filter(row => row.branch_name === selectedBranch).slice().reverse()} 
              x="quarter_name" 
              y={["gross_revenue", "net_revenue"]} 
              type="grouped" 
              title="Perkembangan Omzet vs Laba Bersih per Kuartal" 
              yFmt="Rp #,##0"
              xAxisTitle="Kuartal"
              yAxisTitle="Nilai (Rp)"
              sort=false
            />
          </div>
          <div class="table-scroll-container">
            <table class="markdown">
              <thead>
                <tr>
                  <th class="markdown" style="text-align: left;">Kuartal</th>
                  <th class="markdown" style="text-align: right;">Omzet Gross (Rp)</th>
                  <th class="markdown" style="text-align: right;">Laba Bersih (Rp)</th>
                  <th class="markdown" style="text-align: right;">Margin Bersih</th>
                </tr>
              </thead>
              <tbody>
                {#each branch_quarterly_report.filter(row => row.branch_name === selectedBranch) || [] as row}
                <tr>
                  <td class="markdown" style="text-align: left; font-weight: 600;">{row.quarter_name}</td>
                  <td class="markdown" style="text-align: right;">{row.gross_revenue !== undefined && row.gross_revenue !== null ? row.gross_revenue.toLocaleString('id-ID') : '0'}</td>
                  <td class="markdown" style="text-align: right;">{row.net_revenue !== undefined && row.net_revenue !== null ? row.net_revenue.toLocaleString('id-ID', {maximumFractionDigits: 0}) : '0'}</td>
                  <td class="markdown" style="text-align: right; font-weight: 600; color:{row.net_margin_pct >= 15 ? '#16a34a' : row.net_margin_pct >= 10 ? '#ca8a04' : '#dc2626'}">
                    {row.net_margin_pct !== undefined && row.net_margin_pct !== null ? row.net_margin_pct.toFixed(1) + '%' : '0.0%'}
                  </td>
                </tr>
                {/each}
              </tbody>
            </table>
          </div>
          <div class="chart-insight" style="margin-top: 12px;">
            📌 <strong>Analisis Kuartalan:</strong> Membantu mengidentifikasi faktor musiman (seasonality) dan stabilitas laba bersih per kuartal secara konsisten.
          </div>
        </div>
      </details>

      <!-- ACCORDION 3: Tren Jangka Panjang & YoY (Historis) -->
      <details class="acc-strategic">
        <summary>📈 Tren Jangka Panjang &amp; YoY (Historis)</summary>
        <div class="acc-body">
          <div style="margin-bottom: 20px;">
            <LineChart 
              data={branch_yoy_report.filter(row => row.branch_name === selectedBranch).slice().reverse()} 
              x="yr" 
              y="net_margin_pct" 
              title="Tren Margin Bersih Tahunan (YoY)" 
              yFmt="0.0\%"
              xAxisTitle="Tahun"
              yAxisTitle="Margin (%)"
              sort=false
            >
              <ReferenceLine y={15} label="Target Sehat 15%" lineType="dashed" color="#10B981" />
              <ReferenceLine y={10} label="Waspada 10%" lineType="dashed" color="#F97316" />
            </LineChart>
          </div>
          <DataTable data={branch_yoy_report.filter(row => row.branch_name === selectedBranch)} rows=8>
            <Column id="yr" title="Tahun" fmt="0"/>
            <Column id="gross_revenue" title="Omzet (Gross)" fmt="Rp #,##0"/>
            <Column id="net_revenue" title="Laba Bersih" fmt="Rp #,##0"/>
            <Column id="net_margin_pct" title="Margin" fmt="0.0\%"/>
          </DataTable>

          <div style="margin-top: 16px; padding: 12px; border: 1px solid var(--color-border-tertiary); border-radius: 8px; background: var(--color-background-secondary); font-size: 0.82rem; line-height: 1.6; color:var(--color-text-primary);">
            🏷️ <strong>Statistik Sejarah Cabang:</strong><br/>
            • Tanggal Transaksi Pertama: <strong>{activeScorecard.first_metric_date}</strong><br/>
            • Rata-rata Margin Bersih Historis: <strong>{activeScorecard.margin_historical?.toFixed(1)}%</strong>
          </div>
          
          <div class="chart-insight" style="margin-top: 12px;">
            📌 <strong>Analisis YoY:</strong> Memberikan pandangan makro mengenai apakah cabang ini secara fundamental bertumbuh, stabil, atau mengalami perlambatan dari tahun ke tahun.
          </div>
        </div>
      </details>

  {:else}
    <SectionCard 
      eyebrow="⚠️ Deep Dive Belum Tersedia"
      title="Cabang ini belum punya data cukup untuk diagnosis detail"
      description="Pilih cabang lain atau cek apakah data revenue, net revenue, dan biaya untuk cabang ini sudah masuk lengkap pada horizon 30 sampai 90 hari."
    />
  {/if}

</div>

{:else}
<SectionCard 
  eyebrow="⚠️ Data Belum Siap"
  title="Data deep dive belum siap"
  description="Kueri <code>branch_list</code> atau <code>branch_dates</code> belum menghasilkan baris data."
/>
{/if}

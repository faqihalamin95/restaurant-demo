---
title: Performa Cabang
---

<style>
/* ── Hero ── */
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

.hero-main-card.status-biru {
  background: rgba(59, 130, 246, 0.08);
  border-color: rgba(59, 130, 246, 0.22);
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

.hero-main-card.status-sehat .hero-stat-number {
  color: #15803d;
}

.hero-main-card.status-biru .hero-stat-number {
  color: #1d4ed8;
}

.hero-main-card.status-waspada .hero-stat-number {
  color: #b45309;
}

.hero-main-card.status-kritis .hero-stat-number {
  color: #b91c1c;
}

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
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.02), 0 1px 2px rgba(0, 0, 0, 0.01);
}

.hero-side-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.04), 0 2px 4px rgba(0, 0, 0, 0.02);
  background: rgba(255, 255, 255, 0.9);
}

.hero-side-label {
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--color-text-tertiary);
  margin-bottom: 4px;
}

.hero-side-value {
  font-size: 1.1rem;
  font-weight: 800;
  color: var(--color-text-primary);
}

.hero-side-note {
  font-size: 0.78rem;
  line-height: 1.45;
  color: var(--color-text-secondary);
  margin-top: 4px;
}

/* ── Overview Summary & Row Hover Effects ── */
.overview-badge,
.overview-row {
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  cursor: pointer;
}

.overview-badge:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

.overview-badge.safe:hover {
  background: rgba(22, 163, 74, 0.16) !important;
  border-color: rgba(22, 163, 74, 0.4) !important;
}

.overview-badge.warn:hover {
  background: rgba(234, 179, 8, 0.18) !important;
  border-color: rgba(234, 179, 8, 0.45) !important;
}

.overview-badge.critical:hover {
  background: rgba(220, 38, 38, 0.14) !important;
  border-color: rgba(220, 38, 38, 0.35) !important;
}

.overview-row:hover {
  transform: translateX(4px);
  box-shadow: 0 3px 8px rgba(0, 0, 0, 0.02);
}

.overview-row.safe:hover {
  background: rgba(22, 163, 74, 0.08) !important;
  border-color: rgba(22, 163, 74, 0.24) !important;
}

.overview-row.warn:hover {
  background: rgba(234, 179, 8, 0.08) !important;
  border-color: rgba(234, 179, 8, 0.3) !important;
}

.overview-row.critical:hover {
  background: rgba(220, 38, 38, 0.08) !important;
  border-color: rgba(220, 38, 38, 0.26) !important;
}

/* ── Branch Health Card Hover ── */
.branch-health-card {
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  cursor: pointer;
}

.branch-health-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 10px 22px rgba(0, 0, 0, 0.08), 0 3px 6px rgba(0, 0, 0, 0.03);
}

.branch-health-card.sehat:hover {
  border-color: rgba(22, 163, 74, 0.5) !important;
  background: linear-gradient(160deg, rgba(22, 163, 74, 0.12), rgba(16, 185, 129, 0.06)) !important;
}

.branch-health-card.waspada:hover {
  border-color: rgba(245, 158, 11, 0.52) !important;
  background: linear-gradient(160deg, rgba(245, 158, 11, 0.14), rgba(251, 191, 36, 0.06)) !important;
}

.branch-health-card.early-warning:hover {
  border-color: rgba(249, 115, 22, 0.55) !important;
  background: linear-gradient(160deg, rgba(249, 115, 22, 0.14), rgba(251, 146, 60, 0.06)) !important;
}

.branch-health-card.recovery:hover {
  border-color: rgba(59, 130, 246, 0.5) !important;
  background: linear-gradient(160deg, rgba(59, 130, 246, 0.12), rgba(99, 102, 241, 0.06)) !important;
}

.branch-health-card.membaik:hover {
  border-color: rgba(20, 184, 166, 0.5) !important;
  background: linear-gradient(160deg, rgba(20, 184, 166, 0.14), rgba(59, 130, 246, 0.06)) !important;
}

.branch-health-card.stabil-rendah:hover {
  border-color: rgba(245, 158, 11, 0.48) !important;
  background: linear-gradient(160deg, rgba(245, 158, 11, 0.1), rgba(251, 191, 36, 0.04)) !important;
}

.branch-health-card.turnaround:hover {
  border-color: rgba(239, 68, 68, 0.5) !important;
  background: linear-gradient(160deg, rgba(239, 68, 68, 0.14), rgba(220, 38, 38, 0.06)) !important;
}

/* ── Custom Branch Cards Layout ── */
.branch-card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
  flex-wrap: wrap;
  padding-bottom: 8px;
  border-bottom: 1px dashed rgba(128, 128, 128, 0.15);
}

.branch-margin-section {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
  align-items: center;
  padding: 8px 0;
}

.branch-margin-active-box {
  display: flex;
  flex-direction: column;
}

.branch-margin-benchmarks {
  display: flex;
  flex-direction: column;
  gap: 6px;
  background: rgba(255, 255, 255, 0.45);
  padding: 8px 12px;
  border-radius: 10px;
  border: 1px solid rgba(128, 128, 128, 0.08);
}

.benchmark-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 0.76rem;
  color: var(--color-text-secondary);
}

.benchmark-label {
  font-weight: 500;
}

.benchmark-val {
  color: var(--color-text-primary);
  font-weight: 700;
}

/* Stats Grid */
.branch-stats-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 8px;
  margin: 4px 0;
}

.stat-pill {
  background: rgba(255, 255, 255, 0.5);
  border: 1px solid rgba(128, 128, 128, 0.1);
  padding: 8px 6px;
  border-radius: 10px;
  text-align: center;
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.stat-label {
  font-size: 0.68rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: var(--color-text-tertiary);
}

.stat-value {
  font-size: 0.8rem;
  font-weight: 700;
  color: var(--color-text-primary);
}

.stat-value.text-up {
  color: #16a34a !important;
}

.stat-value.text-down {
  color: #dc2626 !important;
}

/* Diagnosis Box with left border color matching state */
.branch-diagnosis-box {
  display: flex;
  gap: 8px;
  padding: 10px 12px;
  border-radius: 10px;
  border: 1.5px solid transparent;
  border-left-width: 4px;
  font-size: 0.78rem;
  line-height: 1.45;
  color: var(--color-text-secondary);
  align-items: flex-start;
  margin-top: auto;
}

.branch-diagnosis-box.sehat {
  background: rgba(22, 163, 74, 0.04);
  border-color: rgba(22, 163, 74, 0.12);
  border-left-color: #16a34a;
}
.branch-diagnosis-box.waspada {
  background: rgba(245, 158, 11, 0.04);
  border-color: rgba(245, 158, 11, 0.12);
  border-left-color: #f59e0b;
}
.branch-diagnosis-box.early-warning {
  background: rgba(249, 115, 22, 0.04);
  border-color: rgba(249, 115, 22, 0.12);
  border-left-color: #f97316;
}
.branch-diagnosis-box.recovery {
  background: rgba(59, 130, 246, 0.04);
  border-color: rgba(59, 130, 246, 0.12);
  border-left-color: #3b82f6;
}
.branch-diagnosis-box.membaik {
  background: rgba(20, 184, 166, 0.04);
  border-color: rgba(20, 184, 166, 0.12);
  border-left-color: #14b8a6;
}
.branch-diagnosis-box.stabil-rendah {
  background: rgba(245, 158, 11, 0.03);
  border-color: rgba(245, 158, 11, 0.08);
  border-left-color: #f59e0b;
}
.branch-diagnosis-box.turnaround {
  background: rgba(239, 68, 68, 0.04);
  border-color: rgba(239, 68, 68, 0.12);
  border-left-color: #ef4444;
}

.diagnosis-icon {
  font-size: 0.85rem;
  margin-top: 1px;
}
</style>


```sql branch_list
SELECT * FROM restaurant.branch_index_branch_list
```

```sql branch_dates
SELECT * FROM restaurant.branch_index_branch_dates
```

```sql branch_health_overview
SELECT * FROM restaurant.branch_index_branch_health_overview
```

```sql branch_summary_y
SELECT * FROM restaurant.branch_index_branch_summary_y
```

```sql branch_summary_7d
SELECT * FROM restaurant.branch_index_branch_summary_7d
```

```sql branch_summary_30d
SELECT * FROM restaurant.branch_index_branch_summary_30d
```

```sql branch_orders_comparison
SELECT * FROM restaurant.branch_index_branch_orders_comparison
```

```sql branch_summary_mtd
SELECT * FROM restaurant.branch_index_branch_summary_mtd
```

```sql branch_summary_90d
SELECT * FROM restaurant.branch_index_branch_summary_90d
```

```sql branch_orders_comparison_mtd
SELECT * FROM restaurant.branch_index_branch_orders_comparison_mtd
```

```sql branch_orders_comparison_90d
SELECT * FROM restaurant.branch_index_branch_orders_comparison_90d
```

```sql branch_orders_comparison_detail_30d
SELECT * FROM restaurant.branch_index_branch_orders_comparison_detail_30d
```

```sql branch_orders_comparison_detail_mtd
SELECT * FROM restaurant.branch_index_branch_orders_comparison_detail_mtd
```

```sql branch_orders_comparison_detail_90d
SELECT * FROM restaurant.branch_index_branch_orders_comparison_detail_90d
```

```sql branch_health_classification
SELECT * FROM restaurant.branch_index_branch_health_classification
```

```sql branch_status_counts
SELECT * FROM restaurant.branch_index_branch_status_counts
```

```sql branch_concentration
SELECT * FROM restaurant.branch_index_branch_concentration
```

_Dashboard portofolio cabang: kesehatan margin, pertumbuhan, profitabilitas, strategi, dan prioritas aksi._

  <details class="guide-acc"  style="margin-top:12px; margin-bottom:12px;">
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
  <a href="/02-branch-performance" class="tab-button active">🏠 Ringkasan</a>
  <a href="/02-branch-performance/deepdive" class="tab-button ">🏪 Deep Dive</a>
  <a href="/02-branch-performance/analysis" class="tab-button ">🔭 Analisis Lanjutan</a>
</div>


{#if branch_health_classification.length > 0 && branch_status_counts.length > 0 && branch_list.length > 0 && branch_concentration.length > 0 && branch_orders_comparison.length > 0 && branch_dates.length > 0}

{@const branchOverviewRows = branch_summary_30d}
{@const branchBestName = branchOverviewRows[0]?.branch_name ?? 'Belum ada data'}
{@const branchTotalOrdersAll = branchOverviewRows.reduce((sum, row) => sum + (row.total_orders ?? 0), 0)}
{@const branchTotalRevenueAll = branchOverviewRows.reduce((sum, row) => sum + (row.total_revenue ?? 0), 0)}
{@const branchAovAll = Math.round(branchTotalRevenueAll / Math.max(branchTotalOrdersAll, 1))}
{@const branchRevenueValues = branchOverviewRows.map(row => row.total_revenue ?? 0).filter(v => v > 0)}
{@const branchMinRevenue = branchRevenueValues.reduce((min, v) => Math.min(min, v), branchRevenueValues[0] ?? 0)}
{@const branchMaxRevenue = branchRevenueValues.reduce((max, v) => Math.max(max, v), 0)}
{@const branchGapPct = branchMinRevenue > 0 ? Math.round((branchMaxRevenue - branchMinRevenue) / branchMinRevenue * 100) : 0}
{@const branchAovState = branchAovAll >= 50000 ? 'safe' : branchAovAll >= 35000 ? 'warn' : 'critical'}
{@const branchGapState = branchGapPct < 50 ? 'safe' : branchGapPct <= 100 ? 'warn' : 'critical'}
{@const branchOrdersDropPct = branch_orders_comparison[0]?.pct_change ?? 0}
{@const branchOrdersDropState = branchOrdersDropPct <= -15 ? 'critical' : branchOrdersDropPct <= -5 ? 'warn' : 'safe'}
{@const branchIndexStatus = branchAovState === 'critical' || branchGapState === 'critical' || branchOrdersDropState === 'critical' ? 'critical' : branchAovState === 'warn' || branchGapState === 'warn' || branchOrdersDropState === 'warn' ? 'warn' : 'safe'}
{@const branchIndexStates = [branchAovState, branchGapState, branchOrdersDropState]}
{@const branchIndexSafeCount = branchIndexStates.filter(s => s === 'safe').length}
{@const branchIndexWarnCount = branchIndexStates.filter(s => s === 'warn').length}
{@const branchIndexCriticalCount = branchIndexStates.filter(s => s === 'critical').length}
  {@const overviewPeriodRows = inputs.period === 'mtd' ? branch_summary_mtd : inputs.period === '90d' ? branch_summary_90d : branch_summary_30d}
  {@const overviewOrdersComp = inputs.period === 'mtd' ? branch_orders_comparison_mtd : inputs.period === '90d' ? branch_orders_comparison_90d : branch_orders_comparison}
  {@const guideOrdersDetail = inputs.period === 'mtd' ? branch_orders_comparison_detail_mtd : inputs.period === '90d' ? branch_orders_comparison_detail_90d : branch_orders_comparison_detail_30d}
  {@const healthyCount = branch_status_counts[0].sehat_count + branch_status_counts[0].recovery_count}
  {@const totalCount = branch_health_classification.length}
  {@const heroStatusClass = healthyCount === 4 ? 'status-sehat' : healthyCount === 3 ? 'status-biru' : healthyCount === 2 ? 'status-waspada' : 'status-kritis'}
  
  {@const overviewBestName = overviewPeriodRows[0]?.branch_name ?? 'Belum ada data'}
  {@const overviewTotalOrdersAll = overviewPeriodRows.reduce((sum, row) => sum + (row.total_orders ?? 0), 0)}
  {@const overviewTotalRevenueAll = overviewPeriodRows.reduce((sum, row) => sum + (row.total_revenue ?? 0), 0)}
  {@const overviewAovAll = Math.round(overviewTotalRevenueAll / Math.max(overviewTotalOrdersAll, 1))}
  {@const overviewRevenueValues = overviewPeriodRows.map(row => row.total_revenue ?? 0).filter(v => v > 0)}
  {@const overviewMinRevenue = overviewRevenueValues.reduce((min, v) => Math.min(min, v), overviewRevenueValues[0] ?? 0)}
  {@const overviewMaxRevenue = overviewRevenueValues.reduce((max, v) => Math.max(max, v), 0)}
  {@const overviewGapPct = overviewMinRevenue > 0 ? Math.round((overviewMaxRevenue - overviewMinRevenue) / overviewMinRevenue * 100) : 0}
  {@const overviewAovState = overviewAovAll >= 50000 ? 'safe' : overviewAovAll >= 35000 ? 'warn' : 'critical'}
  {@const overviewGapState = overviewGapPct < 50 ? 'safe' : overviewGapPct <= 100 ? 'warn' : 'critical'}
  {@const overviewOrdersDropPct = overviewOrdersComp[0]?.pct_change ?? 0}
  {@const overviewOrdersDropState = overviewOrdersDropPct <= -15 ? 'critical' : overviewOrdersDropPct <= -5 ? 'warn' : 'safe'}
  {@const overviewIndexStatus = overviewAovState === 'critical' || overviewGapState === 'critical' || overviewOrdersDropState === 'critical' ? 'critical' : overviewAovState === 'warn' || overviewGapState === 'warn' || overviewOrdersDropState === 'warn' ? 'warn' : 'safe'}
  {@const overviewIndexStates = [overviewAovState, overviewGapState, overviewOrdersDropState]}
  {@const overviewIndexSafeCount = overviewIndexStates.filter(s => s === 'safe').length}
  {@const overviewIndexWarnCount = overviewIndexStates.filter(s => s === 'warn').length}
  {@const overviewIndexCriticalCount = overviewIndexStates.filter(s => s === 'critical').length}

<div class="branch-page">

<ButtonGroup name=period>
    <ButtonGroupItem valueLabel="📅 Bulan Ini" value="mtd" />
    <ButtonGroupItem valueLabel="📊 30 Hari" value="30d" default />
    <ButtonGroupItem valueLabel="🔭 90 Hari" value="90d" />
  </ButtonGroup>

  <!-- Executive Summary -->
  <div class="hero" style="margin-top: 10px;">
    <div class="hero-eyebrow">📊 Performa Cabang · {inputs.period === 'mtd' ? 'Bulan Berjalan' : inputs.period === '90d' ? '90 Hari Terakhir' : '30 Hari Terakhir'}</div>
    <div class="hero-grid">
      <div class="hero-main-card {heroStatusClass}">
        <div class="hero-stat-number">{healthyCount}/{totalCount}</div>
        <div class="hero-stat-label">cabang sehat</div>
        <div class="hero-subtitle">
          {#if healthyCount === 4}
            Semua cabang sehat dan berjalan optimal.
          {:else if healthyCount === 3}
            Mayoritas cabang dalam kondisi sehat dan aman.
          {:else if healthyCount === 2}
            Setengah cabang mulai tertekan, perlu pengawasan aktif.
          {:else}
            Mayoritas cabang tertekan secara margin operasional.
          {/if}
        </div>
      </div>
      <div class="hero-side">
        <div class="hero-side-card">
          <div class="hero-side-label">📅 Periode Aktif</div>
          <div class="hero-side-value">{inputs.period === 'mtd' ? branch_dates[0].tgl_mtd_awal : inputs.period === '90d' ? branch_dates[0].tgl_90_awal : branch_dates[0].tgl_30_awal} - {branch_dates[0].tgl_akhir}</div>
          <div class="hero-side-note">Ini window paling stabil untuk keputusan operasional: cukup panjang untuk melihat pola, cukup dekat untuk bereaksi.</div>
        </div>
        <div class="hero-side-card">
          <div class="hero-side-label">🏪 Cabang Terbaik</div>
          <div class="hero-side-value">{overviewBestName}</div>
          <div class="hero-side-note">Bukan sekadar ranking; gunakan sebagai acuan untuk mencari pola operasional yang bisa ditiru cabang lain.</div>
        </div>
      </div>
    </div>
  </div>

  <div class="overview-summary">
    <div class="overview-summary-head">
      <div class="overview-summary-label">Ringkasan 3 Indikator Utama</div>
      <div class="overview-badges">
        <span class="overview-badge safe">✓ {overviewIndexSafeCount} sehat</span>
        <span class="overview-badge warn">! {overviewIndexWarnCount} waspada</span>
        <span class="overview-badge critical">x {overviewIndexCriticalCount} kritis</span>
      </div>
    </div>
    <div class="overview-list">
      <div class="overview-row {overviewAovState}">
        <div class="overview-icon">{overviewAovState === 'safe' ? '✅' : overviewAovState === 'warn' ? '⚠️' : '🚨'}</div>
        <div><span class="overview-row-title">AOV Cabang</span> <span class="overview-row-copy">- <span class="overview-row-value">Rp {overviewAovAll.toLocaleString('id-ID')}</span>. Sehat = ≥Rp50.000, Waspada = Rp35.000-49.999, Kritis = di bawah Rp35.000.</span></div>
      </div>
      <div class="overview-row {overviewOrdersDropState}">
        <div class="overview-icon">{overviewOrdersDropState === 'safe' ? '✅' : overviewOrdersDropState === 'warn' ? '⚠️' : '🚨'}</div>
        <div><span class="overview-row-title">Orders Drop</span> <span class="overview-row-copy">- <span class="overview-row-value">{overviewOrdersComp[0].orders_this_period.toLocaleString('id-ID')} order</span> | <span class="overview-row-value">{overviewOrdersDropPct > 0 ? '+' : ''}{overviewOrdersDropPct}% vs {inputs.period === 'mtd' ? 'bulan lalu (mtd)' : inputs.period === '90d' ? '90h sebelumnya' : '30h sebelumnya'}</span>. Sehat = ≥-5%, Waspada = -5% s/d -15%, Kritis = di bawah -15%.</span></div>
      </div>
      <div class="overview-row {overviewGapState}">
        <div class="overview-icon">{overviewGapState === 'safe' ? '✅' : overviewGapState === 'warn' ? '⚠️' : '🚨'}</div>
        <div><span class="overview-row-title">Gap Antar Cabang</span> <span class="overview-row-copy">- <span class="overview-row-value">{overviewGapPct}% gap revenue</span>. Sehat = &lt;50%, Waspada = 50-100%, Kritis = di atas 100%.</span></div>
      </div>
    </div>
  </div>

  <!-- Panduan Konseptual (Collapsible) -->
  <details class="guide-acc"  style="margin-top:12px;">
  <summary>💡 Kenapa AOV, total order, dan gap jadi angka utama?</summary>
<div class="guide-body">
      <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
        AOV, total order, dan gap adalah pengetahuan dasar sebelum membaca analisis cabang yang lebih berat. Ketiga angka ini sengaja diselaraskan dengan beranda agar owner memiliki alur analisis yang konsisten.
      </p>
      <div class="guide-grid" style="grid-template-columns: repeat(2, minmax(0, 1fr));">
        <div class="guide-card blue">
          <div class="guide-card-icon">💵</div>
          <div class="guide-card-content">
            <div class="guide-card-label">AOV</div>
            <h4 class="guide-card-title">Kualitas Transaksi</h4>
            <p class="guide-card-desc">AOV menjawab apakah pelanggan membeli cukup banyak/nilai cukup tinggi per kunjungan. Target sehatnya <strong>Rp50.000 ke atas</strong>.</p>
          </div>
        </div>
        <div class="guide-card orange">
          <div class="guide-card-icon">📈</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Total Order</div>
            <h4 class="guide-card-title">Volume Aktivitas</h4>
            <p class="guide-card-desc">Membaca volume/frekuensi transaksi operasional untuk mendeteksi keaktifan cabang dan adanya tren penurunan transaksi (Orders Drop).</p>
          </div>
        </div>
        <div class="guide-card purple">
          <div class="guide-card-icon">⚖️</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Gap Cabang</div>
            <h4 class="guide-card-title">Ketimpangan Performa</h4>
            <p class="guide-card-desc">Gap membaca jarak revenue cabang tertinggi dan terendah. Gap besar berarti cabang bawah perlu dicek lebih dekat.<br><strong style="font-size: 0.73rem; display: block; margin-top: 5px; color: var(--color-text-tertiary);">*Rumus gap: (revenue tertinggi - revenue terendah) / revenue terendah × 100%.</strong></p>
          </div>
        </div>
        <div class="guide-card teal">
          <div class="guide-card-icon">🚀</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Lanjutannya</div>
            <h4 class="guide-card-title">Baru Cek Margin</h4>
            <p class="guide-card-desc">Jika AOV/total order/gap memberi sinyal, lanjut ke margin 30H vs 90H untuk melihat apakah masalahnya operasional, biaya, atau struktural.</p>
          </div>
        </div>
      </div>
    </div>
</details>

  <!-- Section 1 & 2: Volume, Kualitas & Ketimpangan (Unified Collapsible Accordion) -->
  <div class="strategic-stack" style="margin-top: 32px;">
    <div class="strategic-header">
      <div class="strategic-eyebrow">📈 Volume, Kualitas & Ketimpangan Pendapatan ({inputs.period === 'mtd' ? 'Bulan Berjalan' : inputs.period === '90d' ? '90 Hari' : '30 Hari'})</div>
      <h2 class="strategic-title">Keaktifan & Keseimbangan Cabang</h2>
      <p class="strategic-copy">Gunakan view ini untuk mendeteksi volume transaksi, kualitas belanja rata-rata (AOV), dan disparitas kontribusi omzet antar cabang.</p>
    </div>

    <details class="acc-strategic">
      <summary>📊 Detail Analisis Volume, Kualitas & Ketimpangan</summary>
      <div class="acc-body" style="padding: 20px 16px 16px 16px;">
        <!-- Grid untuk data order dan AOV -->
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 24px; padding-bottom: 20px; border-bottom: 1px dashed rgba(128,128,128,0.2);">
          <!-- Chart 1: Volume (Orders Drop) -->
          <div>
            <div class="section-head tight" style="margin-bottom: 12px;">
              <div>
                <div class="section-eyebrow">📦 Volume Order</div>
                <h3 class="section-title">Bagaimana keaktifan operasional di tiap cabang?</h3>
                <p class="section-copy">Mendeteksi adanya kenaikan atau penurunan volume transaksi di masing-masing cabang dibandingkan periode sebelumnya.</p>
              </div>
            </div>
            <BarChart 
              data={guideOrdersDetail} 
              x="branch_name" 
              y={inputs.period === 'mtd' ? ["Bulan Lalu (mtd)", "Bulan Ini"] : inputs.period === '90d' ? ["90h Lalu", "90h Sekarang"] : ["30h Lalu", "30h Sekarang"]} 
              type="grouped" 
              xAxisTitle="Cabang" 
              yAxisTitle="Orders" 
              yFmt="#,##0"
            />
            <div style="font-size: 0.75rem; color: var(--color-text-secondary); margin-top: 8px; line-height: 1.45;">
              *Bandingkan volume order {inputs.period === 'mtd' ? 'Bulan Ini' : inputs.period === '90d' ? '90h Sekarang' : '30h Sekarang'} (kanan) vs {inputs.period === 'mtd' ? 'Bulan Lalu (mtd)' : inputs.period === '90d' ? '90h Lalu' : '30h Lalu'} (kiri).
            </div>
          </div>

          <!-- Chart 2: Kualitas (AOV) -->
          <div>
            <div class="section-head tight" style="margin-bottom: 12px;">
              <div>
                <div class="section-eyebrow">💵 Nilai Transaksi (AOV)</div>
                <h3 class="section-title">Berapa rata-rata nilai belanja per transaksi?</h3>
                <p class="section-copy">Mengukur kualitas belanja konsumen per kunjungan di setiap cabang untuk mendeteksi potensi upselling.</p>
              </div>
            </div>
            <BarChart 
              data={overviewPeriodRows} 
              x="branch_name" 
              y="avg_order_value" 
              xAxisTitle="Cabang" 
              yAxisTitle="AOV (Rp)" 
              yFmt="#,##0"
            >
              <ReferenceLine y={50000} label="Sehat (≥50k)" lineType="dashed" color="#10B981" />
              <ReferenceLine y={35000} label="Kritis (<35k)" lineType="dashed" color="#EF4444" />
            </BarChart>
            <div style="font-size: 0.75rem; color: var(--color-text-secondary); margin-top: 8px; line-height: 1.45;">
              *Batas kelayakan transaksi (target sehat Rp50.000, batas kritis Rp35.000).
            </div>
          </div>
        </div>

        <!-- Grafik sebaran pendapatan (gap) -->
        <div style="margin-top: 24px;">
          <div class="section-head tight" style="margin-bottom: 12px;">
            <div>
              <div class="section-eyebrow">⚖️ Sebaran Pendapatan & Ketimpangan</div>
              <h3 class="section-title">Bagaimana distribusi omzet kotor dan tingkat ketimpangannya?</h3>
              <p class="section-copy">Sebaran omzet kotor per cabang menunjukkan kontribusi pendapatan masing-masing outlet terhadap portofolio bisnis.</p>
            </div>
          </div>
          <BarChart 
            data={overviewPeriodRows} 
            x="branch_name" 
            y="total_revenue" 
            xAxisTitle="Cabang" 
            yAxisTitle="Revenue (Rp)" 
            yFmt="#,##0"
          />
          <div style="font-size: 0.75rem; color: var(--color-text-secondary); margin-top: 8px; line-height: 1.45;">
            *Ketimpangan ditunjukkan dari beda tinggi pendapatan kotor antar cabang. Selisih yang terlalu jauh antara cabang tertinggi dan terendah memicu tingginya ketimpangan performa (gap).
          </div>
        </div>
      </div>
    </details>
  </div>

  <div class="strategic-stack" style="margin-top: 32px;">
    <div class="strategic-header">
      <div class="strategic-eyebrow">📈 Status Margin Cabang · Diagnosis Aktif 30H vs Baseline 90H</div>
      <h2 class="strategic-title">Diagnosis Performa Margin Cabang</h2>
      <p class="strategic-copy">Sementara parameter waktu di Ringkasan cockpit di atas bersifat dinamis, analisis margin di bawah ini sengaja dikunci ke perbandingan 30H (aktif) vs 90H (baseline recent) untuk mendiagnosis apakah masalah bersifat sementara atau struktural.</p>
    </div>

    <details class="acc-strategic">
      <summary>📊 Detail Status Margin Cabang</summary>
      <div class="acc-body" style="padding: 20px 16px 16px 16px;">
        <div class="overview-summary" style="margin: 0 0 24px 0;">
          <div class="overview-summary-head">
            <div class="overview-summary-label">Ringkasan Status Margin Cabang</div>
            <div class="overview-badges">
              <span class="overview-badge safe">✓ {branch_status_counts[0].sehat_count + branch_status_counts[0].recovery_count} sehat/recovery</span>
              <span class="overview-badge warn">! {branch_status_counts[0].waspada_count + branch_status_counts[0].early_warning_count + branch_status_counts[0].membaik_count + branch_status_counts[0].stabil_rendah_count} perlu dipantau</span>
              <span class="overview-badge critical">x {branch_status_counts[0].turnaround_count} turnaround</span>
            </div>
          </div>
          <div class="overview-list">
            <div class="overview-row {branch_status_counts[0].sehat_count + branch_status_counts[0].recovery_count > 0 ? 'safe' : 'warn'}">
              <div class="overview-icon">✅</div>
              <div><span class="overview-row-title">Cabang sehat/recovery</span> <span class="overview-row-copy">- <span class="overview-row-value">{branch_status_counts[0].sehat_count + branch_status_counts[0].recovery_count} cabang</span>. Ini cabang yang bisa dipertahankan sebagai standar operasional atau benchmark.</span></div>
            </div>
            <div class="overview-row {branch_status_counts[0].waspada_count + branch_status_counts[0].early_warning_count + branch_status_counts[0].membaik_count + branch_status_counts[0].stabil_rendah_count > 0 ? 'warn' : 'safe'}">
              <div class="overview-icon">{branch_status_counts[0].waspada_count + branch_status_counts[0].early_warning_count + branch_status_counts[0].membaik_count + branch_status_counts[0].stabil_rendah_count > 0 ? '⚠️' : '✅'}</div>
              <div><span class="overview-row-title">Cabang perlu dipantau</span> <span class="overview-row-copy">- <span class="overview-row-value">{branch_status_counts[0].waspada_count + branch_status_counts[0].early_warning_count + branch_status_counts[0].membaik_count + branch_status_counts[0].stabil_rendah_count} cabang</span>. Termasuk cabang yang melunak, membaik tapi belum sehat, atau stabil rendah.</span></div>
            </div>
            <div class="overview-row {branch_status_counts[0].turnaround_count > 0 ? 'critical' : 'safe'}">
              <div class="overview-icon">{branch_status_counts[0].turnaround_count > 0 ? '🚨' : '✅'}</div>
              <div><span class="overview-row-title">Cabang turnaround</span> <span class="overview-row-copy">- <span class="overview-row-value">{branch_status_counts[0].turnaround_count} cabang</span>. Jika ada, ini masuk prioritas tindakan sebelum optimasi lain.</span></div>
            </div>
          </div>
        </div>

        <details class="guide-acc"  style="margin-top:14px;">
  <summary>💡 Cara membaca status cabang</summary>
<div class="guide-body">
            
      <div class="guide-grid" style="grid-template-columns: repeat(3, minmax(0, 1fr));">
        <div class="guide-card teal">
          <div class="guide-card-icon">✅</div>
          <div class="guide-card-content">
            <div class="guide-card-label">SEHAT</div>
            <h4 class="guide-card-title">Sehat</h4>
            <p class="guide-card-desc">margin 30H ≥ 15% dan baseline 90H ≥ 15%. Benchmark untuk cabang lain.</p>
          </div>
        </div>
        <div class="guide-card orange">
          <div class="guide-card-icon">⚠️</div>
          <div class="guide-card-content">
            <div class="guide-card-label">WASPADA</div>
            <h4 class="guide-card-title">Waspada</h4>
            <p class="guide-card-desc">margin 30H 10-15%, baseline 90H masih sehat. Cabang yang biasanya sehat mulai melunak.</p>
          </div>
        </div>
        <div class="guide-card orange">
          <div class="guide-card-icon">🚨</div>
          <div class="guide-card-content">
            <div class="guide-card-label">EARLY WARNING</div>
            <h4 class="guide-card-title">Early Warning</h4>
            <p class="guide-card-desc">margin 30H &lt; 10%, tapi baseline 90H masih sehat. Penurunan baru, bukan masalah lama.</p>
          </div>
        </div>
        <div class="guide-card blue">
          <div class="guide-card-icon">🔵</div>
          <div class="guide-card-content">
            <div class="guide-card-label">RECOVERY</div>
            <h4 class="guide-card-title">Recovery</h4>
            <p class="guide-card-desc">margin 30H ≥ 15%, baseline 90H masih rendah. Sudah sehat sekarang, tapi historinya masih perlu dipantau.</p>
          </div>
        </div>
        <div class="guide-card teal">
          <div class="guide-card-icon">🟢</div>
          <div class="guide-card-content">
            <div class="guide-card-label">MEMBAIK</div>
            <h4 class="guide-card-title">Membaik</h4>
            <p class="guide-card-desc">margin 30H 10-15%, baseline 90H &lt; 10%. Ada pemulihan dari kondisi lemah, tapi belum sehat.</p>
          </div>
        </div>
        <div class="guide-card orange">
          <div class="guide-card-icon">🟡</div>
          <div class="guide-card-content">
            <div class="guide-card-label">STABIL RENDAH</div>
            <h4 class="guide-card-title">Stabil Rendah</h4>
            <p class="guide-card-desc">margin 30H dan 90H sama-sama 10-15%. Bukan krisis, tapi belum optimal.</p>
          </div>
        </div>
        <div class="guide-card purple">
          <div class="guide-card-icon">🚨</div>
          <div class="guide-card-content">
            <div class="guide-card-label">TURNAROUND</div>
            <h4 class="guide-card-title">Turnaround</h4>
            <p class="guide-card-desc">margin 30H dan 90H sama-sama lemah. Perlu pembenahan struktural.</p>
          </div>
        </div>
      </div>

            Margin 30H adalah status aktif. Margin 90H adalah baseline recent. Margin historis tetap ditampilkan sebagai konteks fundamental, bukan penentu status utama.
          </div>
</details>

        <!-- Detail Status per Cabang Section -->
        <div class="strategic-header" style="margin-top:24px; padding-top:20px; border-top: 1px dashed rgba(0,0,0,0.15);">
          <div class="strategic-eyebrow">📋 Detail Status per Cabang</div>
          <h3 class="strategic-title" style="margin-top:0;">Cabang mana yang sehat, perlu dipantau, atau masuk turnaround?</h3>
          <p class="strategic-copy">Kartu di bawah ini adalah bukti per cabang dari ringkasan margin di atas. Menggunakan analisis perbandingan 30 Hari (aktif) vs 90 Hari (baseline recent) untuk memotret perkembangan operasional terbaru per cabang.</p>
        </div>

        <div class="branch-health-grid" style="margin-top:14px;">
          {#each branch_health_classification as row}
            {@const branchStatusClass = row.health_status === 'Sehat' ? 'sehat' : row.health_status === 'Waspada' ? 'waspada' : row.health_status === 'Early Warning' ? 'early-warning' : row.health_status === 'Recovery' ? 'recovery' : row.health_status === 'Membaik' ? 'membaik' : row.health_status === 'Stabil Rendah' ? 'stabil-rendah' : 'turnaround'}
            <div class="branch-health-card {branchStatusClass}">
              <!-- Header Row -->
              <div class="branch-card-header">
                <span class="branch-card-name">{row.branch_name}</span>
                <span class="branch-status-badge {branchStatusClass}">
                  {row.health_status === 'Sehat' ? '✅' : row.health_status === 'Waspada' ? '⚠️' : row.health_status === 'Early Warning' ? '🟠' : row.health_status === 'Recovery' ? '🔵' : row.health_status === 'Membaik' ? '🟢' : row.health_status === 'Stabil Rendah' ? '🟡' : '🚨'} {row.health_status}
                </span>
              </div>

              <!-- Main Margin Split Section -->
              <div class="branch-margin-section">
                <!-- Left: Active Margin -->
                <div class="branch-margin-active-box">
                  <div class="branch-margin-main {branchStatusClass}">{row.active_margin_pct}%</div>
                  <div class="branch-margin-label">Margin Aktif 30H</div>
                </div>

                <!-- Right: Structural/Historical Benchmarks -->
                <div class="branch-margin-benchmarks">
                  <div class="benchmark-item">
                    <span class="benchmark-label">Margin 90H</span>
                    <strong class="benchmark-val">{row.recent_margin_pct}%</strong>
                  </div>
                  <div class="benchmark-item">
                    <span class="benchmark-label">Historis</span>
                    <strong class="benchmark-val">{row.historical_margin_pct}%</strong>
                  </div>
                </div>
              </div>

              <!-- Stats Grid Row -->
              <div class="branch-stats-grid">
                <div class="stat-pill">
                  <span class="stat-label">Revenue</span>
                  <span class="stat-value">Rp {(row.active_revenue/1000000).toFixed(1)}jt</span>
                </div>
                <div class="stat-pill">
                  <span class="stat-label">Orders</span>
                  <span class="stat-value">{row.active_orders?.toLocaleString('id-ID')}</span>
                </div>
                <div class="stat-pill">
                  <span class="stat-label">vs Baseline</span>
                  <span class="stat-value {row.baseline_change_pct >= 0 ? 'text-up' : 'text-down'}">
                    {row.baseline_change_pct >= 0 ? '▲ +' : '▼ '}{row.baseline_change_pct}%
                  </span>
                </div>
              </div>

              <!-- Diagnosis Row -->
              <div class="branch-diagnosis-box {branchStatusClass}">
                <div class="diagnosis-icon">💡</div>
                <div class="diagnosis-text">{row.diagnosis}</div>
              </div>
            </div>
          {/each}
        </div>

        <details class="guide-acc"  style="margin-top:14px;">
  <summary>💡 Kenapa margin 30H dibandingkan dengan 90H?</summary>
<div class="guide-body">
            
      <div class="guide-grid" style="grid-template-columns: repeat(3, minmax(0, 1fr));">
        <div class="guide-card blue">
          <div class="guide-card-icon">⚡</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Margin Aktif</div>
            <h4 class="guide-card-title">Margin 30 Hari</h4>
            <p class="guide-card-desc">Margin 30H menunjukkan kondisi aktif yang perlu diputuskan sekarang.</p>
          </div>
        </div>
        <div class="guide-card teal">
          <div class="guide-card-icon">⏳</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Baseline Pembanding</div>
            <h4 class="guide-card-title">Baseline 90 Hari</h4>
            <p class="guide-card-desc">Margin 90H menunjukkan baseline recent: apakah masalahnya baru atau sudah menetap beberapa bulan.</p>
          </div>
        </div>
        <div class="guide-card orange">
          <div class="guide-card-icon">⚠️</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Masalah Baru</div>
            <h4 class="guide-card-title">Early Warning</h4>
            <p class="guide-card-desc">Jika 30H lemah tapi 90H sehat, masalahnya early warning dan masih bisa dikoreksi cepat.</p>
          </div>
        </div>
        <div class="guide-card purple">
          <div class="guide-card-icon">🚨</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Masalah Kronis</div>
            <h4 class="guide-card-title">Pola Struktural</h4>
            <p class="guide-card-desc">Jika 30H dan 90H sama-sama lemah, masalahnya sudah lebih struktural.</p>
          </div>
        </div>
        <div class="guide-card blue">
          <div class="guide-card-icon">📜</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Konteks Historis</div>
            <h4 class="guide-card-title">Margin Fundamental</h4>
            <p class="guide-card-desc">Margin historis tetap dipakai sebagai konteks fundamental, bukan sebagai alarm utama.</p>
          </div>
        </div>
      </div>

          </div>
</details>
    </div>
  </details>
</div>

</div>

{:else}
<div class="section-card">
  <div class="section-head">
    <div class="section-eyebrow">⚠️ Data Belum Siap</div>
    <h3 class="section-title">Dashboard cabang belum bisa dirender penuh</h3>
    <p class="section-copy">Dataset klasifikasi cabang atau status counts belum tersedia. Cek apakah query <code>branch_health_classification</code> dan <code>branch_status_counts</code> sudah berjalan dan menghasilkan baris data.</p>
  </div>
</div>
{/if}

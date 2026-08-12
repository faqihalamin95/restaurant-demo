---
title: Branch Performance
---

<script>
  function usFormat(num, dec = 0) {
    if (num === null || num === undefined) return '0';
    return new Intl.NumberFormat('en-US', { minimumFractionDigits: dec, maximumFractionDigits: dec }).format(num);
  }

  let topBranchName = "-";
  let topBranchNet = 0;
  let topBranchMargin = 0;
  
  let worstBranchName = "-";
  let worstBranchNet = 0;
  let worstBranchMargin = 0;

  let concentrationN = 1;
  let concentrationPct = 0;

  $: if (typeof branch_summary_30d !== 'undefined' && branch_summary_30d.length > 0) {
      const sortedByNet = [...branch_summary_30d].sort((a, b) => b.net_revenue - a.net_revenue);
      const top = sortedByNet[0];
      topBranchName = top?.branch_name ?? "-";
      topBranchNet = top?.net_revenue ?? 0;
      topBranchMargin = top?.net_margin_pct ?? 0;

      const worst = sortedByNet[sortedByNet.length - 1];
      if (worst && worst.net_revenue < 0) {
          worstBranchName = worst.branch_name;
          worstBranchNet = worst.net_revenue;
          worstBranchMargin = worst.net_margin_pct;
      } else {
          worstBranchName = "None";
      }

      const sortedByRev = [...branch_summary_30d].sort((a, b) => b.total_revenue - a.total_revenue);
      const totalBranches = sortedByRev.length;
      
      if (totalBranches <= 3) concentrationN = 1;
      else if (totalBranches <= 7) concentrationN = 2;
      else concentrationN = 3;

      let topNRev = 0;
      let totalRev = 0;
      for (let i = 0; i < totalBranches; i++) {
          totalRev += sortedByRev[i].total_revenue;
          if (i < concentrationN) {
              topNRev += sortedByRev[i].total_revenue;
          }
      }
      
      concentrationPct = totalRev > 0 ? (topNRev / totalRev) * 100 : 0;
  }
</script>

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
  align-items: center;
  justify-content: center;
  text-align: center;
}

.branch-margin-main {
  font-size: 2.2rem;
  font-weight: 800;
  line-height: 1.1;
}

.branch-margin-label {
  font-size: 0.75rem;
  color: var(--color-text-secondary);
  font-weight: 600;
  margin-top: 2px;
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
  margin: 4px 0 12px 0;
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
/* -- KPI & Macro Strategic -- */
</style>


```sql branch_list
SELECT * FROM restaurant.branch_index_branch_list
```

```sql branch_macro_strategic
SELECT * FROM restaurant.branch_index_macro_strategic
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

_Multi-location portfolio breakdown: evaluate margin health, revenue growth, unit profitability, and strategic action priorities across branches._

<details class="guide-acc"  style="margin-top:12px; margin-bottom:12px;">
  <summary>💡 How to choose a subpage</summary>
    <div class="guide-body">
      <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
        Seamlessly navigate location performance, from high-level financial health down to granular outlet audits.
      </p>
      <div class="guide-grid" style="grid-template-columns: repeat(3, minmax(0, 1fr));">
        <div class="guide-card blue">
          <div class="guide-card-icon">🏠</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Overview</div>
            <h4 class="guide-card-title">Core Metrics &amp; Variance</h4>
            <p class="guide-card-desc">Quickly monitor order volume, AOV, and performance variance across all outlets.</p>
          </div>
        </div>
        <div class="guide-card orange">
          <div class="guide-card-icon">🏪</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Deep Dive</div>
            <h4 class="guide-card-title">Branch Audit</h4>
            <p class="guide-card-desc">Granular outlet analysis: daily margins, COGS breakdown, expenditure trends, and supporting data.</p>
          </div>
        </div>
        <div class="guide-card teal">
          <div class="guide-card-icon">🔭</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Analysis</div>
            <h4 class="guide-card-title">Portfolio Strategy</h4>
            <p class="guide-card-desc">Evaluate long-term growth trajectories, unit profitability, and location-level strategic alignment.</p>
          </div>
        </div>
      </div>
      <div style="font-size: 0.75rem; color: var(--color-text-secondary); margin-top: 12px;">
        *For aggregate multi-unit financial health, visit the <a class="inline-link" href="/01-financial-report">Financial Report</a> page.
      </div>
    </div>
</details>

<div class="evidence-tabs-container">
  <a href="/02-branch-performance" class="tab-button active">🏠 Overview</a>
  <a href="/02-branch-performance/02-deepdive" class="tab-button ">🏪 Deep Dive</a>
  <a href="/02-branch-performance/03-analysis" class="tab-button ">🔭 Analysis</a>
  <a href="/02-branch-performance/04-data-directory" class="tab-button ">📁 Data Directory</a>
</div>


{#if typeof branch_health_classification !== 'undefined' && branch_health_classification.length > 0 && typeof branch_status_counts !== 'undefined' && branch_status_counts.length > 0 && typeof branch_summary_30d !== 'undefined' && branch_summary_30d.length > 0 && typeof branch_dates !== 'undefined' && branch_dates.length > 0}


  {@const overviewPeriodRows = branch_summary_30d}
  {@const healthyCount = branch_status_counts[0].sehat_count + branch_status_counts[0].recovery_count}
  {@const totalCount = branch_health_classification.length}
  {@const heroStatusClass = healthyCount === 4 ? 'status-sehat' : healthyCount === 3 ? 'status-biru' : healthyCount === 2 ? 'status-waspada' : 'status-kritis'}
  {@const sumOrders = overviewPeriodRows.reduce((acc, row) => acc + row.total_orders, 0)}
  {@const sumRevenue = overviewPeriodRows.reduce((acc, row) => acc + row.total_revenue, 0)}
  {@const avgAov = sumOrders > 0 ? sumRevenue / sumOrders : 0}
  {@const worstBranchObj = [...branch_health_classification].sort((a,b) => a.active_margin_pct - b.active_margin_pct)[0]}
  {@const bestBranchObj = [...branch_health_classification].sort((a,b) => b.active_margin_pct - a.active_margin_pct)[0]}
  {@const avgRev = overviewPeriodRows.reduce((sum, row) => sum + row.total_revenue, 0) / (overviewPeriodRows.length || 1)}
  {@const waspadaRatio = totalCount > 0 ? ((branch_status_counts[0].waspada_count + branch_status_counts[0].early_warning_count) / totalCount) * 100 : 0}
  {@const turnaroundRatio = totalCount > 0 ? (branch_status_counts[0].turnaround_count / totalCount) * 100 : 0}

<div class="branch-page">

  <!-- Executive Summary -->
  <div class="hero" style="margin-top: 10px;">
    <div class="hero-eyebrow">🏪 Branch Performance (Last 30 Days) · {branch_dates[0].tgl_30_awal} - {branch_dates[0].tgl_akhir}</div>
    <div class="hero-grid">
      <div class="hero-main-card {heroStatusClass}">
        <div class="hero-stat-number">{healthyCount}/{totalCount}</div>
        <div class="hero-stat-label">Healthy Outlets</div>
        <div class="hero-subtitle">
          {#if totalCount > 0}
            {#if healthyCount === totalCount}
              All locations are operating at healthy margin levels.
            {:else if healthyCount / totalCount >= 0.7}
              Most locations maintain healthy financial performance.
            {:else if healthyCount / totalCount >= 0.4}
              Several locations face margin pressure, active supervision needed.
            {:else}
              Majority of locations suffer from operational margin pressure.
            {/if}
          {:else}
            No location data available.
          {/if}
        </div>
      </div>
      <div class="hero-side">
        <div class="hero-side-card">
          <div class="hero-side-label">🏆 Profit Backbone</div>
          <div class="hero-side-value">{topBranchName}</div>
          <div class="hero-side-note">Profit: Rp {usFormat(topBranchNet)} &bull; Margin {usFormat(topBranchMargin, 1)}%</div>
        </div>
        <div class="hero-side-card">
          <div class="hero-side-label">🚨 Leakage Point</div>
            <div 
              class="hero-side-value" 
              style={worstBranchName && worstBranchName !== 'None' && worstBranchName !== 'Nihil' ? 'color: #a12424;' : 'color: #158a40;'}
              >
              {worstBranchName || 'None'}
            </div>

            {#if !worstBranchName || worstBranchName === 'None' || worstBranchName === 'Nihil'}
              <div class="hero-side-note text-emerald-600 font-medium">
                All locations are operating with positive net profit.
              </div>
            {:else}
              <div class="hero-side-note">
                Net Loss: Rp {usFormat(Math.abs(worstBranchNet))} &bull; Margin {usFormat(worstBranchMargin, 1)}%
              </div>
            {/if}
        </div>
      </div>
    </div>
  </div>

  <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 8px; border-top: 1px dashed rgba(0,0,0,0.15); padding-top: 24px; margin-top: 24px;">
    <div style="font-size: 2rem;">📋</div>
    <div>
      <h2 style="margin: 0; font-size: 1.25rem; font-weight: 800; color: var(--color-text-primary); letter-spacing: -0.02em; text-transform: uppercase;">BRANCH HEALTH & MARGIN AUDIT</h2>
      <div style="font-size: 0.85rem; color: var(--color-text-tertiary); font-weight: 500;">Comparative analysis: 30-day margin performance vs 90-day baseline. Select any location card to drill down into detailed analytics.</div>
    </div>
  </div>

  <div class="branch-health-grid" style="margin-top: 4px; margin-bottom: 8px;">
    {#each branch_health_classification as row}
      {@const statusKey = row.health_status?.toLowerCase().replace(/\s+/g, '-')}
      {@const branchStatusClass = 
        row.health_status === 'Healthy' ? 'sehat' : 
        row.health_status === 'Warning' ? 'waspada' : 
        row.health_status === 'Early Warning' ? 'early-warning' : 
        row.health_status === 'Recovering' ? 'recovery' : 
        row.health_status === 'Stagnant' ? 'stabil-rendah' : 'turnaround'
      }
      
      <!-- Make the whole card clickable for deep-dive analysis -->
      <a href="/02-branch-performance/02-deepdive?focus_branch={encodeURIComponent(row.branch_name)}" class="branch-health-card {branchStatusClass}" style="text-decoration: none; display: block;">
        <div class="branch-card-header">
          <span class="branch-card-name">{row.branch_name}</span>
          <span class="branch-status-badge {branchStatusClass}">
            {row.health_status === 'Healthy' ? '✅' : 
            row.health_status === 'Warning' ? '⚠️' : 
            row.health_status === 'Early Warning' ? '🟠' : 
            row.health_status === 'Recovering' ? '🟢' : 
            row.health_status === 'Stagnant' ? '🟡' : '🚨'} 
            {row.health_status}
          </span>
        </div>

        <div class="branch-margin-section">
          <div class="branch-margin-active-box">
            <div class="branch-margin-main {branchStatusClass}">{row.active_margin_pct}%</div>
            <div class="branch-margin-label">30-Day Margin</div>
          </div>

          <div class="branch-margin-benchmarks">
            <div class="benchmark-item">
              <span class="benchmark-label">90D Baseline</span>
              <strong class="benchmark-val">{row.recent_margin_pct}%</strong>
            </div>
            <div class="benchmark-item">
              <span class="benchmark-label">Historical</span>
              <strong class="benchmark-val">{row.historical_margin_pct}%</strong>
            </div>
          </div>
        </div>

        <div class="branch-stats-grid">
          <div class="stat-pill">
            <span class="stat-label">Revenue</span>
            <span class="stat-value">Rp {(row.active_revenue / 1000000).toFixed(1)}M</span>
          </div>
          <div class="stat-pill">
            <span class="stat-label">Orders</span>
            <span class="stat-value">{row.active_orders?.toLocaleString('en-US')}</span>
          </div>
          <div class="stat-pill">
            <span class="stat-label">Order Growth</span>
            <span class="stat-value {row.baseline_change_pct >= 0 ? 'text-up' : 'text-down'}">
              {row.baseline_change_pct >= 0 ? '▲ +' : '▼ '}{row.baseline_change_pct}%
            </span>
          </div>
        </div>

        <div class="branch-diagnosis-box {branchStatusClass}">
          <div class="diagnosis-icon">💡</div>
          <div class="diagnosis-text">{row.diagnosis}</div>
        </div>
      </a>
    {/each}
  </div>
  <details class="guide-acc" style="margin-top: 0px; margin-bottom: 8px;">
    <summary style="cursor: pointer; font-weight: 600; color: var(--color-text-primary);">
      💡 Why compare 30-Day Margin against the 90-Day Baseline?
    </summary>
    <div class="guide-body" style="padding-top: 12px;">
      <div class="guide-grid" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 12px;">
        
        <!-- Card 1: Active Window -->
        <div class="guide-card blue">
          <div class="guide-card-icon">⚡</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Active Window</div>
            <h4 class="guide-card-title">30-Day Margin</h4>
            <p class="guide-card-desc">Captures current operational health requiring immediate tactical decisions.</p>
          </div>
        </div>

        <!-- Card 2: Baseline Context -->
        <div class="guide-card teal">
          <div class="guide-card-icon">⏳</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Benchmark</div>
            <h4 class="guide-card-title">90-Day Baseline</h4>
            <p class="guide-card-desc">Establishes recent performance norm to distinguish fresh anomalies from chronic trends.</p>
          </div>
        </div>

        <!-- Card 3: Early Warning -->
        <div class="guide-card orange">
          <div class="guide-card-icon">⚠️</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Acute Signal</div>
            <h4 class="guide-card-title">Early Warning</h4>
            <p class="guide-card-desc">A drop in 30D margin despite a strong 90D baseline indicates a short-term issue that can be quickly corrected.</p>
          </div>
        </div>

        <!-- Card 4: Structural Pattern -->
        <div class="guide-card purple">
          <div class="guide-card-icon">🚨</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Chronic Issue</div>
            <h4 class="guide-card-title">Structural Pattern</h4>
            <p class="guide-card-desc">Weak performance across both 30D and 90D windows signals systemic operational or cost issues.</p>
          </div>
        </div>

        <!-- Card 5: Historical Context -->
        <div class="guide-card blue">
          <div class="guide-card-icon">📜</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Long-Term Context</div>
            <h4 class="guide-card-title">Historical Baseline</h4>
            <p class="guide-card-desc">Provides foundational reference for lifetime performance without overriding active signals.</p>
          </div>
        </div>

      </div>
    </div>
  </details>
<div id="makro-fix">
<style>
#makro-fix .kpi-grid { display: grid !important; grid-template-columns: repeat(3, minmax(0, 1fr)) !important; gap: 12px !important; }
#makro-fix .kpi-grid-2 { display: grid !important; grid-template-columns: repeat(2, minmax(0, 1fr)) !important; gap: 12px !important; margin-bottom: 12px !important; }
#makro-fix .kpi-card { padding: 18px 16px !important; border-radius: 18px !important; border: 1.5px solid var(--color-border-tertiary) !important; background: var(--color-background-secondary) !important; box-shadow: 0 4px 10px rgba(0, 0, 0, 0.02), 0 1px 3px rgba(0, 0, 0, 0.01) !important; transition: all 0.22s ease !important; text-align: center !important; margin: 0 !important; }
#makro-fix .kpi-card:hover { transform: translateY(-2px) !important; box-shadow: 0 8px 16px rgba(0, 0, 0, 0.04), 0 2px 4px rgba(0, 0, 0, 0.02) !important; }
#makro-fix .kpi-label { font-size: 10px !important; font-weight: 700 !important; letter-spacing: 0.1em !important; text-transform: uppercase !important; color: var(--color-text-tertiary) !important; margin-bottom: 8px !important; display: flex !important; align-items: center !important; justify-content: center !important; gap: 5px !important; }
#makro-fix .kpi-value { font-size: 1.15rem !important; font-weight: 800 !important; letter-spacing: -0.03em !important; color: var(--color-text-primary) !important; margin: 0 !important; }
#makro-fix .kpi-meta { margin-top: 6px !important; font-size: 0.82rem !important; line-height: 1 !important; }
#makro-fix .kpi-prev { margin-top: 6px !important; font-size: 0.78rem !important; color: var(--color-text-secondary) !important; line-height: 1.4 !important; }
#makro-fix .kpi-card.revenue { border-color: rgba(37,99,235,0.18) !important; background: linear-gradient(145deg, rgba(37,99,235,0.06), rgba(99,102,241,0.03)) !important; }
#makro-fix .kpi-card.net { border-color: rgba(16,185,129,0.22) !important; background: linear-gradient(145deg, rgba(16,185,129,0.07), rgba(22,163,74,0.03)) !important; }
#makro-fix .kpi-card.margin { border-color: rgba(245,158,11,0.22) !important; background: linear-gradient(145deg, rgba(245,158,11,0.07), rgba(251,191,36,0.03)) !important; }
#makro-fix .kpi-card.expense { border-color: rgba(239,68,68,0.18) !important; background: linear-gradient(145deg, rgba(239,68,68,0.06), rgba(220,38,38,0.02)) !important; }
#makro-fix p { margin: 0 !important; padding: 0 !important; line-height: normal !important; }
</style>
<div style="margin-bottom: 16px; display: flex; align-items: center; gap: 10px; margin-top: 48px; padding-top: 32px; border-top: 2px dashed rgba(0,0,0,0.06);">
  <div style="font-size: 1.5rem;">🔭</div>
  <div>
    <h2 style="margin: 0; font-size: 1.25rem; font-weight: 800; color: var(--color-text-primary); letter-spacing: -0.02em;">STRATEGIC HEALTH METRICS</h2>
    <div style="font-size: 0.85rem; color: var(--color-text-tertiary); font-weight: 500;">Focus: Long-term performance trajectory and unit economics evaluation across all locations.</div>
  </div>
</div>
<div class="kpi-grid-2">
  <div class="kpi-card revenue">
    <div class="kpi-label">⚖️ Revenue Concentration (CR{concentrationN})</div>
    <div class="kpi-value">{Number(concentrationPct).toFixed(1)}%</div>
    <div class="kpi-meta">
      <span class="trend-indicator neutral">Top {concentrationN} {concentrationN > 1 ? 'Locations' : 'Location'} Share</span>
    </div>
    <div class="kpi-prev">Top {concentrationN} {concentrationN > 1 ? 'locations account' : 'location accounts'} for {usFormat(concentrationPct, 1)}% of total revenue.</div>
  </div>
  <div class="kpi-card revenue">
    <div class="kpi-label">👥 Network Traffic Momentum</div>
    <div class="kpi-value">{usFormat(branch_macro_strategic[0].network_orders_30d)}</div>
    <div class="kpi-meta">
      {#if branch_macro_strategic[0].network_orders_pct_change > 0}
        <span class="trend-indicator up">▲ {usFormat(branch_macro_strategic[0].network_orders_pct_change, 1)}%</span>
      {:else if branch_macro_strategic[0].network_orders_pct_change < 0}
        <span class="trend-indicator down">▼ {usFormat(Math.abs(branch_macro_strategic[0].network_orders_pct_change), 1)}%</span>
      {:else}
        <span class="trend-indicator neutral">0,0%</span>
      {/if}
    </div>
    <div class="kpi-prev">Total transaction volume (30-day window)</div>
  </div>
</div>

<div class="kpi-grid" style="margin-bottom: 24px;">
<!-- Declining Locations Card -->
  <div class="kpi-card margin">
    <div class="kpi-label">📉 Declining Locations</div>
    <div class="kpi-value">{usFormat(branch_health_overview[0].declining_30d)}</div>
    <div class="kpi-meta">
      <span class="trend-indicator down" style="color: #b45309;">Demand Drop Anomaly</span>
    </div>
    <div class="kpi-prev">Revenue dropped over 10% this month.</div>
  </div>

  <!-- Network AOV Card -->
  <div class="kpi-card margin">
    <div class="kpi-label">🛒 Network Average Order Value</div>
    <div class="kpi-value">Rp {usFormat(branch_macro_strategic[0].network_aov_30d)}</div>
    <div class="kpi-meta">
      {#if branch_macro_strategic[0].network_aov_pct_change > 0}
        <span class="trend-indicator up">▲ {usFormat(branch_macro_strategic[0].network_aov_pct_change, 1)}%</span>
      {:else if branch_macro_strategic[0].network_aov_pct_change < 0}
        <span class="trend-indicator down">▼ {usFormat(Math.abs(branch_macro_strategic[0].network_aov_pct_change), 1)}%</span>
      {:else}
        <span class="trend-indicator neutral">0.0%</span>
      {/if}
    </div>
    <div class="kpi-prev">Average revenue per transaction across network.</div>
  </div>

  <!-- Resilience Indicator Card -->
  <div class="kpi-card net">
    <div class="kpi-label">🛡️ Portfolio Resilience Index</div>
    <div class="kpi-value">{usFormat(branch_macro_strategic[0].resilient_count)}</div>
    <div class="kpi-meta">
      <span style="color: var(--color-text-primary); font-weight: 600;">Resilient Locations</span>
    </div>
    <div class="kpi-prev">Maintained &gt;10% margin for 3 consecutive months.</div>
  </div>
</div>
<div class="clean-cta-banner">
  <div class="clean-cta-content">
    <div class="clean-cta-icon">🔍</div>
    <div class="clean-cta-text">
      <h3 class="clean-cta-title">Branch Analytics</h3>
      <p class="clean-cta-desc">Deep dive into SOP compliance, detect operational anomalies, and analyze profitability variance across all locations.</p>
    </div>
  </div>
  <a href="/02-branch-performance/03-analysis" class="clean-cta-button">
    Launch Strategic Evaluation ➔
  </a>
</div>
</div>
</div>
{:else}
  <GlobalLoading />
{/if}

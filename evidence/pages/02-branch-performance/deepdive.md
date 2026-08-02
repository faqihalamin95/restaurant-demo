---
title: Deepdive
sidebar: hide
hide_toc: true
---

<script>
  import DiagnosticsHeader from '$lib/DiagnosticsHeader.svelte';
  import SectionHeader from '$lib/SectionHeader.svelte';
  import SectionCard from '$lib/SectionCard.svelte';
</script>

<style>
:global(.advisor-wrapper.hide-tabs nav) { display: none !important; }

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

/* ── Risk Section (Mini-Card Layout) ── */
.risk-section { display: flex; flex-direction: column; gap: 20px; margin-bottom: 32px; }

.risk-row {
  border-radius: 20px;
  overflow: hidden;
  box-shadow: 0 2px 12px rgba(0,0,0,0.03);
  transition: border-color 0.3s ease, box-shadow 0.3s ease;
  display: block;
}

/* Row color themes */
.risk-row.purple-theme { background: linear-gradient(135deg, rgba(168,85,247,0.03), rgba(168,85,247,0.008)); border: 1.5px solid rgba(168,85,247,0.12); }
.risk-row.blue-theme { background: linear-gradient(135deg, rgba(59,130,246,0.03), rgba(59,130,246,0.008)); border: 1.5px solid rgba(59,130,246,0.12); }
.risk-row.slate-theme { background: linear-gradient(135deg, rgba(15,23,42,0.03), rgba(15,23,42,0.008)); border: 1.5px solid rgba(15,23,42,0.08); }

/* Hover: outline only */
.risk-row.purple-theme:hover { border-color: rgba(168,85,247,0.35); box-shadow: 0 4px 20px rgba(168,85,247,0.06); }
.risk-row.blue-theme:hover { border-color: rgba(59,130,246,0.35); box-shadow: 0 4px 20px rgba(59,130,246,0.06); }
.risk-row.slate-theme:hover { border-color: rgba(15,23,42,0.20); box-shadow: 0 4px 20px rgba(15,23,42,0.04); }

.risk-row-header { display: flex; align-items: center; gap: 12px; padding: 18px 24px; }

.risk-row.purple-theme .risk-row-header { border-bottom: 1px solid rgba(168,85,247,0.08); }
.risk-row.blue-theme .risk-row-header { border-bottom: 1px solid rgba(59,130,246,0.08); }
.risk-row.slate-theme .risk-row-header { border-bottom: 1px solid rgba(15,23,42,0.06); }

.risk-row-icon { font-size: 1.15rem; width: 36px; height: 36px; display: flex; align-items: center; justify-content: center; border-radius: 11px; flex-shrink: 0; }
.risk-row.purple-theme .risk-row-icon { background: rgba(168,85,247,0.10); }
.risk-row.blue-theme .risk-row-icon { background: rgba(59,130,246,0.10); }
.risk-row.slate-theme .risk-row-icon { background: rgba(15,23,42,0.06); }

.risk-row-title { margin: 0; font-size: 1.02rem; font-weight: 800; color: var(--color-text-primary); letter-spacing: -0.02em; }

/* Pills: 3-column grid */
.risk-pills { display: grid; grid-template-columns: repeat(3, 1fr); }
.risk-pills.cols-2 { grid-template-columns: repeat(2, 1fr); }
.risk-pill {
  display: flex; flex-direction: column; align-items: center; text-align: center;
  gap: 10px; padding: 20px 16px;
  border-right: 1px solid rgba(0,0,0,0.04);
  transition: background 0.25s ease;
}
.risk-pill:last-child { border-right: none; }
.risk-row.purple-theme .risk-pill:hover { background: rgba(168,85,247,0.05); }
.risk-row.blue-theme .risk-pill:hover { background: rgba(59,130,246,0.05); }
.risk-row.slate-theme .risk-pill:hover { background: rgba(15,23,42,0.03); }

.risk-pill-anchor {
  font-size: 1.15rem;
  width: 40px; height: 40px;
  display: flex; align-items: center; justify-content: center;
  border-radius: 12px;
}
.risk-row.purple-theme .risk-pill-anchor { background: rgba(168,85,247,0.10); }
.risk-row.blue-theme .risk-pill-anchor { background: rgba(59,130,246,0.10); }
.risk-row.slate-theme .risk-pill-anchor { background: rgba(15,23,42,0.06); }

.risk-pill-content { display: flex; flex-direction: column; gap: 4px; }
.risk-pill-content strong { font-size: 0.85rem; font-weight: 800; color: var(--color-text-primary); letter-spacing: -0.01em; }
.risk-pill-content span { font-size: 0.8rem; line-height: 1.5; color: var(--color-text-secondary); }

/* Fun fact footer */
.risk-funfact {
  display: flex; align-items: flex-start; gap: 12px;
  padding: 14px 24px;
  border-top: 1px dashed rgba(0,0,0,0.06);
  background: rgba(0,0,0,0.015);
}
.risk-funfact-icon { font-size: 0.9rem; margin-top: 2px; flex-shrink: 0; }
.risk-funfact-content { display: flex; flex-direction: column; gap: 2px; }
.risk-funfact-content span { font-size: 0.78rem; line-height: 1.5; color: var(--color-text-secondary); }
.risk-funfact-content cite { font-size: 0.7rem; color: var(--color-text-tertiary); font-style: italic; }

/* Pros Cons Box */
.pros-cons-box {
  margin-top: 8px;
  display: flex;
  flex-direction: column;
  gap: 4px;
  font-size: 0.72rem;
  background: rgba(0,0,0,0.02);
  padding: 8px 10px;
  border-radius: 6px;
  border: 1px solid rgba(0,0,0,0.04);
}
.pros-cons-box .pro, .pros-cons-box .con { line-height: 1.35; display: flex; gap: 4px; }
.pros-cons-box .pro { color: #15803d; }
.pros-cons-box .con { color: #b45309; }
.risk-row.purple-theme .pros-cons-box { background: rgba(168,85,247,0.03); border-color: rgba(168,85,247,0.1); }
.risk-row.blue-theme .pros-cons-box { background: rgba(59,130,246,0.03); border-color: rgba(59,130,246,0.1); }
.risk-row.slate-theme .pros-cons-box { background: rgba(15,23,42,0.02); border-color: rgba(15,23,42,0.06); }
</style>

```sql branch_list
SELECT * FROM restaurant.branch_deepdive_branch_list
```

```sql branch_dates
SELECT * FROM restaurant.branch_deepdive_branch_dates
```

```sql fin_kpi_mtd
SELECT * FROM restaurant.fin_kpi_mtd
```

```sql branch_scorecard
SELECT * FROM restaurant.branch_deepdive_branch_scorecard
```

```sql branch_cost_periods
SELECT * FROM restaurant.branch_deepdive_branch_cost_periods
```

```sql branch_menu_playbook
SELECT * FROM restaurant.menu_branch_playbook_30d
```

```sql branch_quarterly_report
SELECT * FROM restaurant.branch_deepdive_branch_quarterly_report
```

```sql branch_yoy_report
SELECT * FROM restaurant.branch_deepdive_branch_yoy_report
```

```sql branch_menu_detail_30d
SELECT * FROM restaurant.menu_a_branch_detail WHERE period = '30d'
```

```sql branch_category_mix
SELECT branch_name, category, SUM(revenue_current) as total_rev
FROM restaurant.menu_a_branch_detail
WHERE period = '30d'
GROUP BY branch_name, category
ORDER BY total_rev DESC
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
  <a href="/02-branch-performance/analysis" class="tab-button ">🔭 Evaluasi Strategis</a>
  <a href="/02-branch-performance/direktori-data" class="tab-button ">📁 Direktori Data</a>
</div>

{#if typeof branch_list !== 'undefined' && branch_list.length > 0 && typeof branch_dates !== 'undefined' && branch_dates.length > 0 && typeof branch_scorecard !== 'undefined' && typeof branch_cost_periods !== 'undefined' && typeof branch_menu_detail_30d !== 'undefined' && typeof branch_category_mix !== 'undefined' && typeof branch_quarterly_report !== 'undefined' && typeof branch_yoy_report !== 'undefined'}
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
  
  {@const activeMarginState = activeMargin >= 10 ? 'safe' : activeMargin >= 5 ? 'warn' : 'critical'}
  {@const activeMarginColor = activeMargin >= 10 ? '#15803d' : activeMargin >= 5 ? '#b45309' : '#b91c1c'}

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
  {@const mtdIngrExcess = branchIngredientPctMtd - 30}
  {@const mtdLaborExcess = branchLaborPctMtd - 30}
  {@const mtdOverheadExcess = branchOverheadPctMtd - 30}
  {@const mtdMaxExcess = Math.max(mtdIngrExcess, mtdLaborExcess, mtdOverheadExcess)}
  {@const branchMainCostPressureMtd = mtdMaxExcess <= 0 ? 'semua biaya dalam batas' : mtdMaxExcess === mtdOverheadExcess ? 'biaya operasional' : mtdMaxExcess === mtdIngrExcess ? 'biaya bahan' : 'biaya SDM'}

  <!-- Cost Pressure for 30D -->
  {@const ingrExcess = branchIngredientPct30 - 30}
  {@const laborExcess = branchLaborPct30 - 30}
  {@const overheadExcess = branchOverheadPct30 - 30}
  {@const maxExcess = Math.max(ingrExcess, laborExcess, overheadExcess)}
  {@const branchMainCostPressure = maxExcess <= 0 ? 'semua biaya dalam batas' : maxExcess === overheadExcess ? 'biaya operasional' : maxExcess === ingrExcess ? 'biaya bahan' : 'biaya SDM'}

  <!-- Cost Pressure for 90D -->
  {@const ingrExcess90 = branchIngredientPct90 - 30}
  {@const laborExcess90 = branchLaborPct90 - 30}
  {@const overheadExcess90 = branchOverheadPct90 - 30}
  {@const maxExcess90 = Math.max(ingrExcess90, laborExcess90, overheadExcess90)}
  {@const branchMainCostPressure90 = maxExcess90 <= 0 ? 'semua biaya dalam batas' : maxExcess90 === overheadExcess90 ? 'biaya operasional' : maxExcess90 === ingrExcess90 ? 'biaya bahan' : 'biaya SDM'}

  {@const activePeriodDates = activePeriodDeepdive === 'mtd' ? `${branch_dates[0].tgl_mtd_awal} - ${branch_dates[0].tgl_akhir}` : activePeriodDeepdive === '90d' ? `${branch_dates[0].tgl_90_awal} - ${branch_dates[0].tgl_akhir}` : `${branch_dates[0].tgl_30_awal} - ${branch_dates[0].tgl_akhir}`}
  {@const activeGrowthPct = activeScorecard ? (activePeriodDeepdive === 'mtd' ? activeScorecard.rev_pct_mtd : activePeriodDeepdive === '90d' ? activeScorecard.rev_pct_90d : activeScorecard.rev_pct_30d) : 0}
  {@const activeCostPressureLabel = activePeriodDeepdive === 'mtd' ? branchMainCostPressureMtd : activePeriodDeepdive === '90d' ? branchMainCostPressure90 : branchMainCostPressure}
  {@const activeCostPressureGap = activePeriodDeepdive === 'mtd' ? mtdMaxExcess : activePeriodDeepdive === '90d' ? maxExcess90 : maxExcess}
  {@const activeIngrExcess = activePeriodDeepdive === 'mtd' ? mtdIngrExcess : activePeriodDeepdive === '90d' ? ingrExcess90 : ingrExcess}
  {@const activeLaborExcess = activePeriodDeepdive === 'mtd' ? mtdLaborExcess : activePeriodDeepdive === '90d' ? laborExcess90 : laborExcess}
  {@const activeOverheadExcess = activePeriodDeepdive === 'mtd' ? mtdOverheadExcess : activePeriodDeepdive === '90d' ? overheadExcess90 : overheadExcess}

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

  {@const hasCostPressure = activeIngrExcess > 0 || activeLaborExcess > 0 || activeOverheadExcess > 0}
  {@const forceCostPressure = activeMarginState !== 'safe' && !hasCostPressure}

  {@const showIngrAdvisor = activeIngrExcess > 0 || (forceCostPressure && activeCostPressureLabel === 'biaya bahan')}
  {@const showLaborAdvisor = activeLaborExcess > 0 || (forceCostPressure && activeCostPressureLabel === 'biaya SDM')}
  {@const showOverheadAdvisor = activeOverheadExcess > 0 || (forceCostPressure && activeCostPressureLabel === 'biaya operasional')}
  {@const showIngrUnderAdvisor = branchIngredientPct30 < 25}
  {@const showLaborUnderAdvisor = branchLaborPct30 < 15}

<div class="branch-page">

<SectionCard 
  eyebrow="<span style='font-size: 12px;'>🏪 Pilih Cabang</span>" 
  title="Pusat Kendali Performa Cabang" 
  description="Pilih cabang tertentu untuk menganalisis tren margin harian, breakdown pos biaya operasional, dan sebaran jenis pesanan secara mendalam."
>
    <ButtonGroup name=focus_branch>
      {#each branch_list as branch, i}
        <ButtonGroupItem value={branch.branch_name} valueLabel={branch.branch_name} default={i === 0} />
      {/each}
    </ButtonGroup>
</SectionCard>

  {#if activeScorecard && activeScorecard.rev_30d !== null && activeCostPeriods && activeCostPeriods.gross_30d !== null}

    <!-- EXECUTIVE SUMMARY PANEL -->
    {@const activePlaybook = typeof branch_menu_playbook !== 'undefined' ? branch_menu_playbook.find(row => row.branch_name === selectedBranch) : null}
    {@const grossGrowthPct = activeScorecard.gross_90d ? (((activeScorecard.gross_30d/30) - (activeScorecard.gross_90d/90)) / (activeScorecard.gross_90d/90) * 100) : 0}
    {@const showCashcow = !showIngrAdvisor && !showLaborAdvisor && !showOverheadAdvisor && grossGrowthPct >= 0}
    {@const showGrowth = grossGrowthPct < 0}
    <div style="margin: 20px 0; padding: 24px; border-radius: 12px; border-left: 6px solid {activeMarginState === 'safe' ? '#16a34a' : activeMarginState === 'warn' ? '#d97706' : '#dc2626'}; background: {activeMarginState === 'safe' ? 'rgba(22, 163, 74, 0.04)' : activeMarginState === 'warn' ? 'rgba(217, 119, 6, 0.04)' : 'rgba(220, 38, 38, 0.04)'}; border: 1px solid var(--color-border-tertiary); border-left-width: 6px; border-left-color: {activeMarginState === 'safe' ? '#16a34a' : activeMarginState === 'warn' ? '#d97706' : '#dc2626'};">
      
      <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 16px;">
        <span style="font-size: 1.5rem;">{activeMarginState === 'safe' ? '✅' : activeMarginState === 'warn' ? '⚠️' : '🚨'}</span>
        <h3 style="margin: 0; font-size: 1.25rem; font-weight: 800; color: var(--color-text-primary);">
          KESIMPULAN EKSEKUTIF: {activeMarginState === 'safe' ? 'Kinerja Cabang Prima' : activeMarginState === 'warn' ? 'Cabang Butuh Perhatian' : 'Krisis Profitabilitas'}
        </h3>
      </div>
      
      <div style="font-size: 0.95rem; line-height: 1.6; color: var(--color-text-primary); margin-bottom: 20px;">
        {#if activeMarginState === 'safe'}
          Cabang beroperasi dengan efisien, mencetak omzet <strong>Rp {activeScorecard.gross_30d?.toLocaleString('id-ID')}</strong> dari <strong>{activeScorecard.ord_30d?.toLocaleString('id-ID')} transaksi</strong> dalam 30 hari terakhir. 
          {#if grossGrowthPct >= 0}
            Margin bersih sehat di level <strong>{activeScorecard.margin_30d?.toFixed(1)}%</strong>, selaras dengan momentum omzet harian yang tumbuh <strong>+{grossGrowthPct.toFixed(1)}%</strong> dari baseline. 
          {:else}
            Margin bersih terpantau sehat di level <strong>{activeScorecard.margin_30d?.toFixed(1)}%</strong>, <strong>namun</strong> volume bisnis sedang mengalami kontraksi <strong>{grossGrowthPct.toFixed(1)}%</strong> dari baseline. Verifikasi pada grafik Kuartalan di bawah apakah penurunan ini murni efek siklus musiman (low-season).
          {/if}
          {#if branchMainCostPressure !== 'semua biaya dalam batas'} Tetap waspadai tren pergerakan <strong>{branchMainCostPressure}</strong>.{/if}
        {:else if activeMarginState === 'warn'}
          Kinerja cabang membutuhkan perhatian. 
          {#if grossGrowthPct >= 0}
            Meski tren omzet tumbuh <strong>+{grossGrowthPct.toFixed(1)}%</strong> dengan total <strong>Rp {activeScorecard.gross_30d?.toLocaleString('id-ID')}</strong>, margin bersih tertahan di ambang batas minimum <strong>{activeScorecard.margin_30d?.toFixed(1)}%</strong>. Ekspansi volume belum optimal menjadi laba.
          {:else}
            Selain tren omzet yang terkoreksi <strong>{grossGrowthPct.toFixed(1)}%</strong> menjadi <strong>Rp {activeScorecard.gross_30d?.toLocaleString('id-ID')}</strong>, margin bersih juga tertahan di ambang batas minimum <strong>{activeScorecard.margin_30d?.toFixed(1)}%</strong>. Pastikan apakah pelemahan ini murni dampak siklus musiman atau inefisiensi operasional.
          {/if}
          Tekanan utama saat ini bersumber dari <strong>{branchMainCostPressure}</strong> yang mulai mendekati batas toleransi.
        {:else}
          Cabang memerlukan evaluasi operasional segera. 
          {#if grossGrowthPct >= 0}
            Meski berhasil mencetak pertumbuhan omzet <strong>+{grossGrowthPct.toFixed(1)}%</strong> menjadi <strong>Rp {activeScorecard.gross_30d?.toLocaleString('id-ID')}</strong>, margin bersih tergerus parah ke level <strong>{activeScorecard.margin_30d?.toFixed(1)}%</strong>. Lonjakan trafik gagal dikonversi menjadi laba, indikasi taktik promo/diskon terlalu dalam.
          {:else}
            Cabang berada dalam tekanan ganda. Omzet terkoreksi <strong>{grossGrowthPct.toFixed(1)}%</strong> menjadi <strong>Rp {activeScorecard.gross_30d?.toLocaleString('id-ID')}</strong>, dan margin bersih anjlok ke level kritis <strong>{activeScorecard.margin_30d?.toFixed(1)}%</strong>. Bahkan jika ini periode low-season, penurunan trafik seharusnya tidak merusak margin hingga separah ini.
          {/if}
          Akar masalah terindikasi pada <strong>{branchMainCostPressure}</strong> yang mengalami deviasi dari batas efisiensi 30%.
        {/if}
      </div>
    </div> <!-- EXECUTIVE SUMMARY PANEL ENDS HERE -->

    <!-- ADVISOR MODE PANEL -->
    {@const activeAdvisorsCount = [showIngrAdvisor, showLaborAdvisor, showOverheadAdvisor, showGrowth, showCashcow].filter(Boolean).length}

    <DiagnosticsHeader 
      marginTop="16px"
      eyebrow="💡 Pusat Rekomendasi Taktis"
      title="Tindakan korektif &amp; panduan strategis"
      description="Gunakan rekomendasi sistem di bawah ini untuk mengambil tindakan atas tekanan biaya, inefisiensi operasional, serta strategi optimalisasi pertumbuhan cabang."
    />

    <div class="advisor-wrapper {activeAdvisorsCount === 1 ? 'hide-tabs' : ''}">
    <Tabs id="advisor_tabs" fullWidth=true>

        {#if showIngrAdvisor}
          <Tab label="🥩 Biaya Bahan Baku">
            <div class="risk-row purple-theme" style="margin-top: 16px; margin-bottom: 24px;">
              <div class="risk-row-header">
                <span class="risk-row-icon">🥩</span>
                <h4 class="risk-row-title">Rekomendasi Pemangkasan Biaya Bahan Baku</h4>
              </div>
              <div class="risk-pills">
                <div class="risk-pill">
                  <span class="risk-pill-anchor">🕵️</span>
                  <div class="risk-pill-content">
                    <strong>Opsi A: Audit & Kontrol</strong>
                    <span><strong>Sidak & Stock Opname.</strong> Fokus mencari anomali <em>over-portioning</em> atau pencurian fisik pada menu terlaris ({activePlaybook ? activePlaybook.top_volume_menu : 'menu andalan'}).</span>
                    <div class="pros-cons-box">
                      <div class="pro"><span>✅</span><span><strong>Pro:</strong> Hentikan kebocoran instan tanpa modal.</span></div>
                      <div class="con"><span>⚠️</span><span><strong>Kontra:</strong> Menurunkan moral tim jika dilakukan terlalu represif.</span></div>
                    </div>
                  </div>
                </div>
                <div class="risk-pill">
                  <span class="risk-pill-anchor">🏷️</span>
                  <div class="risk-pill-content">
                    <strong>Opsi B: Rekayasa Harga</strong>
                    <span><strong>Naikkan Harga 5-10%.</strong> Terapkan pada menu {activePlaybook ? activePlaybook.top_revenue_menu : 'pencetak omzet'} untuk melebarkan ruang margin seketika.</span>
                    <div class="pros-cons-box">
                      <div class="pro"><span>✅</span><span><strong>Pro:</strong> Dampak margin langsung terasa hari ini.</span></div>
                      <div class="con"><span>⚠️</span><span><strong>Kontra:</strong> Berisiko menurunkan <em>traffic</em> pelanggan jika sensitivitas harga tinggi.</span></div>
                    </div>
                  </div>
                </div>
                <div class="risk-pill">
                  <span class="risk-pill-anchor">🍔</span>
                  <div class="risk-pill-content">
                    <strong>Opsi C: Cross-Selling Paksa</strong>
                    <span><strong>Bundle Minuman.</strong> Wajibkan kasir melakukan <em>bundling</em> makanan berat dengan minuman bermargin tinggi.</span>
                    <div class="pros-cons-box">
                      <div class="pro"><span>✅</span><span><strong>Pro:</strong> AOV (Average Order Value) naik tanpa membebani COGS.</span></div>
                      <div class="con"><span>⚠️</span><span><strong>Kontra:</strong> Memerlukan <em>training</em> kasir dan insentif penjualan.</span></div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="risk-funfact">
                <span class="risk-funfact-icon">📎</span>
                <div class="risk-funfact-content">
                  <span>Biaya bahan baku (COGS) yang sehat maksimal berada di angka 30%. Jika menembus angka ini, biasanya disebabkan oleh limbah (food waste), harga supplier naik, atau porsi berlebihan.</span>
                  <cite>Landasan Teori: Rasio F&B 30-30-30-10 (Food Cost)</cite>
                </div>
              </div>
            </div>
          </Tab>
        {/if}

        {#if showLaborAdvisor}
          <Tab label="👥 Beban SDM">
            <div class="risk-row blue-theme" style="margin-top: 16px; margin-bottom: 24px;">
              <div class="risk-row-header">
                <span class="risk-row-icon">👥</span>
                <h4 class="risk-row-title">Rekomendasi Restrukturisasi Beban SDM</h4>
              </div>
              <div class="risk-pills">
                <div class="risk-pill">
                  <span class="risk-pill-anchor">✂️</span>
                  <div class="risk-pill-content">
                    <strong>Opsi A: Defensif Pemotongan</strong>
                    <span><strong>Pangkas Shift.</strong> Kurangi shift karyawan <em>part-time</em> di jam <em>off-peak</em> dan bekukan rekrutmen baru.</span>
                    <div class="pros-cons-box">
                      <div class="pro"><span>✅</span><span><strong>Pro:</strong> Penurunan <em>Fixed Cost</em> secara instan bulan depan.</span></div>
                      <div class="con"><span>⚠️</span><span><strong>Kontra:</strong> Pelayanan bisa melambat saat terjadi lonjakan pesanan mendadak.</span></div>
                    </div>
                  </div>
                </div>
                <div class="risk-pill">
                  <span class="risk-pill-anchor">🚀</span>
                  <div class="risk-pill-content">
                    <strong>Opsi B: Agresif Ekspansi</strong>
                    <span><strong>Suntik Trafik.</strong> Daripada memecat staf, dorong omzet naik agar rasio beban gaji mengecil.</span>
                    <div class="pros-cons-box">
                      <div class="pro"><span>✅</span><span><strong>Pro:</strong> Menjaga moral tim dan kualitas layanan tetap prima.</span></div>
                      <div class="con"><span>⚠️</span><span><strong>Kontra:</strong> Memerlukan biaya <em>marketing</em> tambahan yang membebani kas.</span></div>
                    </div>
                  </div>
                </div>
                <div class="risk-pill">
                  <span class="risk-pill-anchor">📱</span>
                  <div class="risk-pill-content">
                    <strong>Opsi C: Restrukturisasi Sistem</strong>
                    <span><strong>Perombakan SOP.</strong> Kurangi ketergantungan pada pramusaji dengan sistem <em>Self-Service</em> atau <em>QR Ordering</em>.</span>
                    <div class="pros-cons-box">
                      <div class="pro"><span>✅</span><span><strong>Pro:</strong> Solusi skalabel jangka panjang anti-inflasi gaji.</span></div>
                      <div class="con"><span>⚠️</span><span><strong>Kontra:</strong> Butuh capex awal (investasi sistem) dan merubah <em>customer habit</em>.</span></div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="risk-funfact">
                <span class="risk-funfact-icon">📎</span>
                <div class="risk-funfact-content">
                  <span>Beban gaji ideal maksimal 30% dari omzet bruto. Memecat karyawan inti berisiko merusak layanan, sehingga pemotongan jam <em>part-time</em> atau efisiensi jam operasional lebih disarankan sebagai langkah pertama.</span>
                  <cite>Landasan Teori: Rasio F&B 30-30-30-10 (Labor Cost)</cite>
                </div>
              </div>
            </div>
          </Tab>
        {/if}

        {#if showOverheadAdvisor}
          <Tab label="🏢 Overhead & Operasional">
            <div class="risk-row slate-theme" style="margin-top: 16px; margin-bottom: 24px;">
              <div class="risk-row-header">
                <span class="risk-row-icon">🏢</span>
                <h4 class="risk-row-title">Rekomendasi Pemangkasan Overhead & Operasional</h4>
              </div>
              <div class="risk-pills">
                <div class="risk-pill">
                  <span class="risk-pill-anchor">🔌</span>
                  <div class="risk-pill-content">
                    <strong>Opsi A: Efisiensi Utilitas</strong>
                    <span><strong>Audit Energi.</strong> Buat SOP jam nyala-mati AC/Lampu yang ketat. Evaluasi tagihan listrik mingguan.</span>
                    <div class="pros-cons-box">
                      <div class="pro"><span>✅</span><span><strong>Pro:</strong> Mudah diimplementasikan tanpa resistensi pihak eksternal.</span></div>
                      <div class="con"><span>⚠️</span><span><strong>Kontra:</strong> Penghematan rupiahnya relatif kecil dibanding opsi lain.</span></div>
                    </div>
                  </div>
                </div>
                <div class="risk-pill">
                  <span class="risk-pill-anchor">🏪</span>
                  <div class="risk-pill-content">
                    <strong>Opsi B: Utilisasi Aset</strong>
                    <span><strong>Space Monetization.</strong> Sewakan area kosong ke <em>tenant</em> pelengkap atau manfaatkan dapur sebagai <em>Cloud Kitchen</em>.</span>
                    <div class="pros-cons-box">
                      <div class="pro"><span>✅</span><span><strong>Pro:</strong> Mengubah <em>sunk-cost</em> (sewa) menjadi mesin pencetak uang.</span></div>
                      <div class="con"><span>⚠️</span><span><strong>Kontra:</strong> Memakan waktu untuk mencari <em>tenant</em> dan negosiasi.</span></div>
                    </div>
                  </div>
                </div>
                <div class="risk-pill">
                  <span class="risk-pill-anchor">🤝</span>
                  <div class="risk-pill-content">
                    <strong>Opsi C: Renegosiasi Kontrak</strong>
                    <span><strong>Lobi Uang Sewa.</strong> Mengingat tren cabang lesu, negosiasikan ulang harga sewa, atau putus kontrak vendor keamanan.</span>
                    <div class="pros-cons-box">
                      <div class="pro"><span>✅</span><span><strong>Pro:</strong> Memangkas beban <em>overhead</em> terbesar secara fundamental.</span></div>
                      <div class="con"><span>⚠️</span><span><strong>Kontra:</strong> Risiko hubungan bisnis retak atau penalti pemutusan kontrak.</span></div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="risk-funfact">
                <span class="risk-funfact-icon">📎</span>
                <div class="risk-funfact-content">
                  <span>Overhead melebihi 30% adalah <em>silent killer</em> karena bersifat <em>fixed-cost</em> (harus dibayar meski restoran tidak ada pembeli). Bernegosiasi ulang biaya sewa saat bisnis tertekan adalah praktik korporat yang wajar.</span>
                  <cite>Landasan Teori: Rasio F&B 30-30-30-10 (Overhead Cost)</cite>
                </div>
              </div>
            </div>
          </Tab>
        {/if}

        {#if showGrowth}
          <Tab label="📉 Penurunan Volume">
            <div class="risk-row purple-theme" style="margin-top: 16px; margin-bottom: 24px;">
              <div class="risk-row-header">
                <span class="risk-row-icon">📉</span>
                <h4 class="risk-row-title">Rekomendasi Menghadapi Penurunan Tren Volume</h4>
              </div>
              <div class="risk-pills">
                <div class="risk-pill">
                  <span class="risk-pill-anchor">🎯</span>
                  <div class="risk-pill-content">
                    <strong>Opsi A: Agresif Promo</strong>
                    <span><strong>Bakar Margin.</strong> Buat diskon terbatas pada menu bervolume tertinggi ({activePlaybook ? activePlaybook.top_volume_menu : 'menu andalan'}).</span>
                    <div class="pros-cons-box">
                      <div class="pro"><span>✅</span><span><strong>Pro:</strong> Mendongkrak volume transaksi dan <em>traffic</em> secara instan.</span></div>
                      <div class="con"><span>⚠️</span><span><strong>Kontra:</strong> Menggerus ruang margin kotor secara sengaja di bulan berjalan.</span></div>
                    </div>
                  </div>
                </div>
                <div class="risk-pill">
                  <span class="risk-pill-anchor">💎</span>
                  <div class="risk-pill-content">
                    <strong>Opsi B: Moderat Retensi</strong>
                    <span><strong>Jaga Pelanggan Lama.</strong> Fokus pada <em>Loyalty Program</em>. Berikan <em>voucher</em> kejutan bagi pelanggan rutin.</span>
                    <div class="pros-cons-box">
                      <div class="pro"><span>✅</span><span><strong>Pro:</strong> Mempertahankan loyalitas tanpa membakar biaya akuisisi (CAC).</span></div>
                      <div class="con"><span>⚠️</span><span><strong>Kontra:</strong> Bergantung sepenuhnya pada kualitas database pelanggan (CRM).</span></div>
                    </div>
                  </div>
                </div>
                <div class="risk-pill">
                  <span class="risk-pill-anchor">🛡️</span>
                  <div class="risk-pill-content">
                    <strong>Opsi C: Defensif Pasif</strong>
                    <span><strong>Terima Kenyataan.</strong> Asumsikan ini adalah siklus <em>low-season</em> alami. Turunkan stok harian untuk menghindari <em>food waste</em>.</span>
                    <div class="pros-cons-box">
                      <div class="pro"><span>✅</span><span><strong>Pro:</strong> Melindungi margin bersih secara absolut dari risiko limbah.</span></div>
                      <div class="con"><span>⚠️</span><span><strong>Kontra:</strong> Pangsa pasar berpotensi diam-diam direbut kompetitor.</span></div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="risk-funfact">
                <span class="risk-funfact-icon">📎</span>
                <div class="risk-funfact-content">
                  <span>Membakar uang pemasaran (promo diskon) saat siklus <em>low-season</em> alami seringkali membuahkan ROI negatif. Melindungi margin melalui efisiensi persediaan adalah langkah paling rasional.</span>
                  <cite>Landasan Teori: Strategi Pertahanan Siklus Musiman F&B</cite>
                </div>
              </div>
            </div>
          </Tab>
        {/if}

        {#if showCashcow}
          <Tab label="🌟 Optimalisasi Cash Cow">
            <div class="risk-row blue-theme" style="margin-top: 16px; margin-bottom: 24px;">
              <div class="risk-row-header">
                <span class="risk-row-icon">🌟</span>
                <h4 class="risk-row-title">Rekomendasi Optimalisasi Cabang Sukses (Cash Cow)</h4>
              </div>
              <div class="risk-pills">
                <div class="risk-pill">
                  <span class="risk-pill-anchor">🏆</span>
                  <div class="risk-pill-content">
                    <strong>Opsi A: Replikasi Sukses</strong>
                    <span><strong>Standarisasi SOP.</strong> Jadikan SOP dan Manajer cabang ini sebagai <em>benchmark</em> untuk direplikasi ke cabang lain.</span>
                    <div class="pros-cons-box">
                      <div class="pro"><span>✅</span><span><strong>Pro:</strong> Mengangkat performa cabang lain yang sedang *under-performing*.</span></div>
                      <div class="con"><span>⚠️</span><span><strong>Kontra:</strong> Dapat memecah fokus Manajer Bintang dari cabang utamanya.</span></div>
                    </div>
                  </div>
                </div>
                <div class="risk-pill">
                  <span class="risk-pill-anchor">💰</span>
                  <div class="risk-pill-content">
                    <strong>Opsi B: Apresiasi Tim</strong>
                    <span><strong>Bonus Pegawai.</strong> Pertimbangkan memberikan insentif performa bagi staf di cabang ini untuk menjaga retensi.</span>
                    <div class="pros-cons-box">
                      <div class="pro"><span>✅</span><span><strong>Pro:</strong> Menjaga tingkat <em>turnover</em> karyawan pilar tetap rendah (loyalitas naik).</span></div>
                      <div class="con"><span>⚠️</span><span><strong>Kontra:</strong> Menambah beban pengeluaran kas ekstra di akhir bulan.</span></div>
                    </div>
                  </div>
                </div>
                <div class="risk-pill">
                  <span class="risk-pill-anchor">📈</span>
                  <div class="risk-pill-content">
                    <strong>Opsi C: Ekspansi Organik</strong>
                    <span><strong>Tambah Kapasitas.</strong> Alihkan fokus ke ekspansi penjualan (tambah kapasitas kursi, jam operasional, pesan antar).</span>
                    <div class="pros-cons-box">
                      <div class="pro"><span>✅</span><span><strong>Pro:</strong> Mendobrak <em>ceiling revenue</em> dan meningkatkan utilitas aset harian.</span></div>
                      <div class="con"><span>⚠️</span><span><strong>Kontra:</strong> Memerlukan injeksi modal (Capex) untuk renovasi/marketing.</span></div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="risk-funfact">
                <span class="risk-funfact-icon">📎</span>
                <div class="risk-funfact-content">
                  <cite>Landasan Teori: Matriks Portofolio BCG (Cash Cows & Stars)</cite>
                </div>
              </div>
            </div>
          </Tab>
        {/if}

      </Tabs>
    </div>



      
      <!-- SECTION: Operasional & Diagnostik -->
      <DiagnosticsHeader 
        marginTop="24px"
        eyebrow="🔬 Operasional &amp; Diagnostik"
        title="Bedah performa &amp; detail biaya"
        description="Gunakan instrumen di bawah ini untuk menganalisis detail pengeluaran, radar peringatan operasional harian, serta tren perkembangan margin."
      />
        
        <!-- 30 Hari vs 90 Hari Data Table -->

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
              </tbody>
            </table>
          </div>

          <!-- Breakdown progress bars visually -->
          <div class="cost-grid" style="margin-top: 16px;">
            <!-- COGS Card -->
            <div class="cost-card" style="background: {branchIngredientPct30 < 25 ? 'linear-gradient(180deg, rgba(254,252,232,0.9), rgba(254,249,195,0.6))' : branchIngredientPct30 <= 30 ? 'linear-gradient(180deg, rgba(240,253,244,0.9), rgba(220,252,231,0.6))' : branchIngredientPct30 <= 35 ? 'linear-gradient(180deg, rgba(254,252,232,0.9), rgba(254,249,195,0.6))' : 'linear-gradient(180deg, rgba(254,242,242,0.9), rgba(254,226,226,0.6))'}; border-color: {branchIngredientPct30 < 25 ? 'rgba(234,179,8,0.5)' : branchIngredientPct30 <= 30 ? 'rgba(34,197,94,0.5)' : branchIngredientPct30 <= 35 ? 'rgba(234,179,8,0.5)' : 'rgba(239,68,68,0.5)'};">
              <div class="cost-label">🥩 Biaya Bahan Baku</div>
              <div class="cost-value" style="color:{branchIngredientPct30 < 25 ? '#ea580c' : branchIngredientPct30 <= 30 ? '#16a34a' : branchIngredientPct30 <= 35 ? '#ea580c' : '#dc2626'};">{(Number(branchIngredientPct30)).toFixed(1).replace('.', ',')}%</div>
              <div class="cost-target">🎯 Target normal maks 30%</div>
              <div class="progress-track">
                <div class="progress-fill" style="width:{Math.min(branchIngredientPct30 / 40 * 100, 100)}%; background:{branchIngredientPct30 < 25 ? 'linear-gradient(90deg,#f59e0b,#fde68a)' : branchIngredientPct30 <= 30 ? 'linear-gradient(90deg,#16a34a,#86efac)' : branchIngredientPct30 <= 35 ? 'linear-gradient(90deg,#f59e0b,#fde68a)' : 'linear-gradient(90deg,#ef4444,#fca5a5)'};"></div>
                <div class="progress-target" style="left:{30 / 40 * 100}%;"></div>
              </div>
              <div class="progress-scale"><span>0%</span><span>30%</span><span>40%</span></div>
              <div class="cost-note">
                <div style="font-size: 0.82rem; font-weight: 600; color: {branchIngredientPct30 < 25 ? '#ea580c' : branchIngredientPct30 <= 30 ? '#16a34a' : branchIngredientPct30 <= 35 ? '#ea580c' : '#dc2626'};">
                  {branchIngredientPct30 < 25 ? '👀 Pantau Bawah (<25%)' : branchIngredientPct30 <= 30 ? '⭐ Zona Ideal (25-30%)' : branchIngredientPct30 <= 35 ? '⚠️ Pantau Atas (30-35%)' : '📉 Pemborosan (>35%)'}
                </div>
                <div style="font-size: 0.78rem; color: var(--color-text-secondary); margin-top: 4px; line-height: 1.4;">
                  {branchIngredientPct30 < 25 ? 'Rasio di bawah target. Verifikasi konsistensi standar porsi.' : branchIngredientPct30 <= 30 ? 'Rasio efisien. Pertahankan standar resep saat ini.' : branchIngredientPct30 <= 35 ? 'Rasio mulai naik. Tinjau ulang pemakaian bahan baku harian.' : 'Proporsi di atas standar. Analisis potensi inefisiensi pengadaan.'}
                </div>
                <div style="margin-top: 8px;">
                  {#if branchIngredientPct30 > branchIngredientPct90}
                    <span class="trend-indicator down">▲ +{String((branchIngredientPct30 - branchIngredientPct90).toFixed(1)).replace('.', ',')}%</span>
                  {:else if branchIngredientPct30 < branchIngredientPct90}
                    <span class="trend-indicator up">▼ {String((branchIngredientPct90 - branchIngredientPct30).toFixed(1)).replace('.', ',')}%</span>
                  {:else}
                    <span class="trend-indicator neutral">0,0%</span>
                  {/if}
                  <span style="font-size: 0.78rem; color: var(--color-text-secondary);"> vs Baseline 90 Hari</span>
                </div>
              </div>
            </div>

            <!-- Labor Card -->
            <div class="cost-card" style="background: {branchLaborPct30 < 15 ? 'linear-gradient(180deg, rgba(254,242,242,0.9), rgba(254,226,226,0.6))' : branchLaborPct30 < 20 ? 'linear-gradient(180deg, rgba(254,252,232,0.9), rgba(254,249,195,0.6))' : branchLaborPct30 <= 30 ? 'linear-gradient(180deg, rgba(240,253,244,0.9), rgba(220,252,231,0.6))' : branchLaborPct30 <= 35 ? 'linear-gradient(180deg, rgba(254,252,232,0.9), rgba(254,249,195,0.6))' : 'linear-gradient(180deg, rgba(254,242,242,0.9), rgba(254,226,226,0.6))'}; border-color: {branchLaborPct30 < 15 ? 'rgba(239,68,68,0.5)' : branchLaborPct30 < 20 ? 'rgba(234,179,8,0.5)' : branchLaborPct30 <= 30 ? 'rgba(34,197,94,0.5)' : branchLaborPct30 <= 35 ? 'rgba(234,179,8,0.5)' : 'rgba(239,68,68,0.5)'};">
              <div class="cost-label">👥 Biaya SDM</div>
              <div class="cost-value" style="color:{branchLaborPct30 < 15 ? '#dc2626' : branchLaborPct30 < 20 ? '#ea580c' : branchLaborPct30 <= 30 ? '#16a34a' : branchLaborPct30 <= 35 ? '#ea580c' : '#dc2626'};">{(Number(branchLaborPct30)).toFixed(1).replace('.', ',')}%</div>
              <div class="cost-target">🎯 Target normal maks 30%</div>
              <div class="progress-track">
                <div class="progress-fill" style="width:{Math.min(branchLaborPct30 / 35 * 100, 100)}%; background:{branchLaborPct30 < 15 ? 'linear-gradient(90deg,#ef4444,#fca5a5)' : branchLaborPct30 < 20 ? 'linear-gradient(90deg,#f59e0b,#fde68a)' : branchLaborPct30 <= 30 ? 'linear-gradient(90deg,#16a34a,#86efac)' : branchLaborPct30 <= 35 ? 'linear-gradient(90deg,#f59e0b,#fde68a)' : 'linear-gradient(90deg,#ef4444,#fca5a5)'};"></div>
                <div class="progress-target" style="left:{30 / 35 * 100}%;"></div>
              </div>
              <div class="progress-scale"><span>0%</span><span>30%</span><span>35%</span></div>
              <div class="cost-note">
                <div style="font-size: 0.82rem; font-weight: 600; color: {branchLaborPct30 < 15 ? '#dc2626' : branchLaborPct30 < 20 ? '#ea580c' : branchLaborPct30 <= 30 ? '#16a34a' : branchLaborPct30 <= 35 ? '#ea580c' : '#dc2626'};">
                  {branchLaborPct30 < 15 ? '🚨 Krisis (<15%)' : branchLaborPct30 < 20 ? '👀 Pantau Bawah (15-20%)' : branchLaborPct30 <= 30 ? '⭐ Zona Ideal (20-30%)' : branchLaborPct30 <= 35 ? '⚠️ Pantau Atas (30-35%)' : '📉 Pemborosan (>35%)'}
                </div>
                <div style="font-size: 0.78rem; color: var(--color-text-secondary); margin-top: 4px; line-height: 1.4;">
                  {branchLaborPct30 < 15 ? 'Rasio sangat rendah. Risiko operasional dan pelayanan turun.' : branchLaborPct30 < 20 ? 'Rasio di bawah target. Pantau potensi kelelahan staf.' : branchLaborPct30 <= 30 ? 'Pengeluaran staf efisien. Pertahankan produktivitas.' : branchLaborPct30 <= 35 ? 'Proporsi meningkat. Tinjau jam lembur dan jadwal staf.' : 'Indikasi inefisiensi. Evaluasi struktur tim dan shift.'}
                </div>
                <div style="margin-top: 8px;">
                  {#if branchLaborPct30 > branchLaborPct90}
                    <span class="trend-indicator down">▲ +{String((branchLaborPct30 - branchLaborPct90).toFixed(1)).replace('.', ',')}%</span>
                  {:else if branchLaborPct30 < branchLaborPct90}
                    <span class="trend-indicator up">▼ {String((branchLaborPct90 - branchLaborPct30).toFixed(1)).replace('.', ',')}%</span>
                  {:else}
                    <span class="trend-indicator neutral">0,0%</span>
                  {/if}
                  <span style="font-size: 0.78rem; color: var(--color-text-secondary);"> vs Baseline 90 Hari</span>
                </div>
              </div>
            </div>

            <!-- Overhead Card -->
            <div class="cost-card" style="background: {branchOverheadPct30 < 25 ? 'linear-gradient(180deg, rgba(254,252,232,0.9), rgba(254,249,195,0.6))' : branchOverheadPct30 <= 30 ? 'linear-gradient(180deg, rgba(240,253,244,0.9), rgba(220,252,231,0.6))' : branchOverheadPct30 <= 35 ? 'linear-gradient(180deg, rgba(254,252,232,0.9), rgba(254,249,195,0.6))' : 'linear-gradient(180deg, rgba(254,242,242,0.9), rgba(254,226,226,0.6))'}; border-color: {branchOverheadPct30 < 25 ? 'rgba(234,179,8,0.5)' : branchOverheadPct30 <= 30 ? 'rgba(34,197,94,0.5)' : branchOverheadPct30 <= 35 ? 'rgba(234,179,8,0.5)' : 'rgba(239,68,68,0.5)'};">
              <div class="cost-label">⚙️ Biaya Operasional</div>
              <div class="cost-value" style="color:{branchOverheadPct30 < 25 ? '#ea580c' : branchOverheadPct30 <= 30 ? '#16a34a' : branchOverheadPct30 <= 35 ? '#ea580c' : '#dc2626'};">{(Number(branchOverheadPct30)).toFixed(1).replace('.', ',')}%</div>
              <div class="cost-target">🎯 Target normal maks 30%</div>
              <div class="progress-track">
                <div class="progress-fill" style="width:{Math.min(branchOverheadPct30 / 40 * 100, 100)}%; background:{branchOverheadPct30 < 25 ? 'linear-gradient(90deg,#f59e0b,#fde68a)' : branchOverheadPct30 <= 30 ? 'linear-gradient(90deg,#16a34a,#86efac)' : branchOverheadPct30 <= 35 ? 'linear-gradient(90deg,#f59e0b,#fde68a)' : 'linear-gradient(90deg,#ef4444,#fca5a5)'};"></div>
                <div class="progress-target" style="left:{30 / 40 * 100}%;"></div>
              </div>
              <div class="progress-scale"><span>0%</span><span>30%</span><span>40%</span></div>
              <div class="cost-note">
                <div style="font-size: 0.82rem; font-weight: 600; color: {branchOverheadPct30 < 25 ? '#ea580c' : branchOverheadPct30 <= 30 ? '#16a34a' : branchOverheadPct30 <= 35 ? '#ea580c' : '#dc2626'};">
                  {branchOverheadPct30 < 25 ? '👀 Pantau Bawah (<25%)' : branchOverheadPct30 <= 30 ? '⭐ Zona Ideal (25-30%)' : branchOverheadPct30 <= 35 ? '⚠️ Pantau Atas (30-35%)' : '📉 Pemborosan (>35%)'}
                </div>
                <div style="font-size: 0.78rem; color: var(--color-text-secondary); margin-top: 4px; line-height: 1.4;">
                  {branchOverheadPct30 < 25 ? 'Pengeluaran rendah. Pastikan utilitas fasilitas tetap memadai.' : branchOverheadPct30 <= 30 ? 'Pengeluaran efisien. Pertahankan pola operasional saat ini.' : branchOverheadPct30 <= 35 ? 'Rasio meningkat. Periksa tagihan listrik atau utilitas.' : 'Beban operasional tinggi. Segera audit sewa dan utilitas bulanan.'}
                </div>
                <div style="margin-top: 8px;">
                  {#if branchOverheadPct30 > branchOverheadPct90}
                    <span class="trend-indicator down">▲ +{String((branchOverheadPct30 - branchOverheadPct90).toFixed(1)).replace('.', ',')}%</span>
                  {:else if branchOverheadPct30 < branchOverheadPct90}
                    <span class="trend-indicator up">▼ {String((branchOverheadPct90 - branchOverheadPct30).toFixed(1)).replace('.', ',')}%</span>
                  {:else}
                    <span class="trend-indicator neutral">0,0%</span>
                  {/if}
                  <span style="font-size: 0.78rem; color: var(--color-text-secondary);"> vs Baseline 90 Hari</span>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Kaidah Teori -->
          <div class="risk-funfact" style="margin-top: 16px; margin-bottom: 12px;">
            <span class="risk-funfact-icon">📎</span>
            <div class="risk-funfact-content">
              <span>Target normal 30% didasarkan pada kaidah keuangan 30-30-30-10 (30% Bahan, 30% SDM, 30% Operasional, 10% Laba Bersih).</span>
              <cite>National Restaurant Association, Restaurant Industry Standard Benchmarks</cite>
            </div>
          </div>

          <!-- Edukasi Underbudget -->
          <details class="guide-acc" style="margin-bottom: 20px;">
            <summary>💡 Bahaya Under-Budget (Efisiensi Semu)</summary>
            <div class="guide-body">
              <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
                Pengeluaran jauh di bawah batas target (&lt;25% untuk bahan, &lt;15% untuk SDM) tidak selalu berarti "hemat". Waspadai jebakan risiko tersembunyi berikut:
              </p>
              <div class="guide-grid" style="grid-template-columns: repeat(3, minmax(0, 1fr));">
                <div class="guide-card blue">
                  <div class="guide-card-icon">🥩</div>
                  <div class="guide-card-content">
                    <div class="guide-card-label">Biaya Bahan Baku</div>
                    <h4 class="guide-card-title">Margin Semu</h4>
                    <p class="guide-card-desc">Waspadai indikasi pencurian porsi oleh dapur (under-portioning) atau supplier menurunkan kualitas standar bahan diam-diam (downgrade).</p>
                  </div>
                </div>
                <div class="guide-card orange">
                  <div class="guide-card-icon">👥</div>
                  <div class="guide-card-content">
                    <div class="guide-card-label">Biaya SDM</div>
                    <h4 class="guide-card-title">Krisis Understaffed</h4>
                    <p class="guide-card-desc">Waktu layanan (serving time) melambat tajam, tingkat kesalahan pesanan melonjak, dan staf lama terancam <em>resign</em> karena kelelahan (burnout).</p>
                  </div>
                </div>
                <div class="guide-card teal">
                  <div class="guide-card-icon">⚙️</div>
                  <div class="guide-card-content">
                    <div class="guide-card-label">Biaya Operasional</div>
                    <h4 class="guide-card-title">Fasilitas Menurun</h4>
                    <p class="guide-card-desc">Menghemat biaya kebersihan, pemeliharaan AC, atau perbaikan alat makan dapat merusak pengalaman bersantap secara permanen di mata konsumen.</p>
                  </div>
                </div>
              </div>
            </div>
          </details>

          <!-- NEW SECTION: STRUKTUR KOMPOSISI BIAYA -->
          <div class="diagnostics-header" style="margin-top: 40px; margin-bottom: 24px;">
            <div class="diagnostics-eyebrow">🧬 STRUKTUR KOMPOSISI BIAYA</div>
            <h2 class="diagnostics-title">Proporsi Rincian Pengeluaran Cabang</h2>
            <p class="diagnostics-copy">Bedah sumber pembengkakan biaya (Bahan, SDM, Operasional) untuk mengetahui pos pengeluaran mana yang butuh efisiensi segera.</p>
          </div>

          <div class="data-wrapper" style="margin-bottom: 40px;">
            <Tabs id="komposisi_biaya" fullWidth=true>
              
              <Tab label="⚙️ Operasional (Overhead)">
                {#if selectedBranch}
                  {@const activeCost = branch_cost_periods.find(row => row.branch_name === selectedBranch) || {}}
                  {@const totalOps = activeCost.overhead_30d || 0}
                  {@const opsSewa = totalOps * 0.535}
                  {@const opsListrik = totalOps * 0.285}
                  {@const opsAir = totalOps * 0.132}
                  {@const opsLainnya = totalOps * 0.048}

                  <div class="interactive-card" style="padding: 24px; margin-top: 16px;">
                    <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 16px;">
                      <div style="font-weight: 700; color: var(--color-text-primary); font-size: 1.1rem;">Total Biaya Operasional (30 Hari)</div>
                      <div style="font-size: 1.2rem; color: var(--color-text-primary); font-weight: 800;">Rp {Math.round(totalOps).toLocaleString('id-ID')}</div>
                    </div>
                    
                    <div style="display: flex; height: 32px; border-radius: 8px; overflow: hidden; margin-bottom: 20px; box-shadow: inset 0 1px 3px rgba(0,0,0,0.1);">
                      <div style="width: 53.5%; background: linear-gradient(90deg, #3b82f6, #60a5fa); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.8rem; font-weight: 700;" title="Sewa Bangunan: Rp {Math.round(opsSewa).toLocaleString('id-ID')}">53.5%</div>
                      <div style="width: 28.5%; background: linear-gradient(90deg, #f59e0b, #fbbf24); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.8rem; font-weight: 700;" title="Listrik: Rp {Math.round(opsListrik).toLocaleString('id-ID')}">28.5%</div>
                      <div style="width: 13.2%; background: linear-gradient(90deg, #10b981, #34d399); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.8rem; font-weight: 700;" title="Air: Rp {Math.round(opsAir).toLocaleString('id-ID')}">13.2%</div>
                      <div style="width: 4.8%; background: linear-gradient(90deg, #8b5cf6, #a78bfa); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.8rem; font-weight: 700;" title="Lainnya: Rp {Math.round(opsLainnya).toLocaleString('id-ID')}">4.8%</div>
                    </div>
                    
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; font-size: 0.9rem; color: var(--color-text-secondary);">
                      <div style="display: flex; align-items: center; gap: 8px;">
                        <div style="width: 14px; height: 14px; border-radius: 4px; background: #3b82f6;"></div>
                        <div style="flex: 1;">Sewa Bangunan</div>
                        <div style="font-weight: 700; color: var(--color-text-primary);">Rp {Math.round(opsSewa).toLocaleString('id-ID')}</div>
                      </div>
                      <div style="display: flex; align-items: center; gap: 8px;">
                        <div style="width: 14px; height: 14px; border-radius: 4px; background: #f59e0b;"></div>
                        <div style="flex: 1;">Listrik</div>
                        <div style="font-weight: 700; color: var(--color-text-primary);">Rp {Math.round(opsListrik).toLocaleString('id-ID')}</div>
                      </div>
                      <div style="display: flex; align-items: center; gap: 8px;">
                        <div style="width: 14px; height: 14px; border-radius: 4px; background: #10b981;"></div>
                        <div style="flex: 1;">Air</div>
                        <div style="font-weight: 700; color: var(--color-text-primary);">Rp {Math.round(opsAir).toLocaleString('id-ID')}</div>
                      </div>
                      <div style="display: flex; align-items: center; gap: 8px;">
                        <div style="width: 14px; height: 14px; border-radius: 4px; background: #8b5cf6;"></div>
                        <div style="flex: 1;">Lainnya (Marketing, dsb)</div>
                        <div style="font-weight: 700; color: var(--color-text-primary);">Rp {Math.round(opsLainnya).toLocaleString('id-ID')}</div>
                      </div>
                    </div>
                  </div>
                {/if}
              </Tab>
              
              <Tab label="🥩 Bahan Baku (COGS)">
                {#if selectedBranch}
                  {@const activeCost = branch_cost_periods.find(row => row.branch_name === selectedBranch) || {}}
                  {@const totalCogs = activeCost.ingr_30d || 0}
                  {@const cogsProtein = totalCogs * 0.45}
                  {@const cogsSayur = totalCogs * 0.30}
                  {@const cogsKemasan = totalCogs * 0.15}
                  {@const cogsLainnya = totalCogs * 0.10}

                  <div class="interactive-card" style="padding: 24px; margin-top: 16px;">
                    <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 16px;">
                      <div style="font-weight: 700; color: var(--color-text-primary); font-size: 1.1rem;">Total Biaya Bahan Baku (30 Hari)</div>
                      <div style="font-size: 1.2rem; color: var(--color-text-primary); font-weight: 800;">Rp {Math.round(totalCogs).toLocaleString('id-ID')}</div>
                    </div>
                    
                    <div style="display: flex; height: 32px; border-radius: 8px; overflow: hidden; margin-bottom: 20px; box-shadow: inset 0 1px 3px rgba(0,0,0,0.1);">
                      <div style="width: 45%; background: linear-gradient(90deg, #ef4444, #f87171); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.8rem; font-weight: 700;" title="Daging & Protein: Rp {Math.round(cogsProtein).toLocaleString('id-ID')}">45%</div>
                      <div style="width: 30%; background: linear-gradient(90deg, #10b981, #34d399); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.8rem; font-weight: 700;" title="Sayuran & Bumbu: Rp {Math.round(cogsSayur).toLocaleString('id-ID')}">30%</div>
                      <div style="width: 15%; background: linear-gradient(90deg, #f59e0b, #fbbf24); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.8rem; font-weight: 700;" title="Kemasan (Packaging): Rp {Math.round(cogsKemasan).toLocaleString('id-ID')}">15%</div>
                      <div style="width: 10%; background: linear-gradient(90deg, #6b7280, #9ca3af); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.8rem; font-weight: 700;" title="Minyak & Lainnya: Rp {Math.round(cogsLainnya).toLocaleString('id-ID')}">10%</div>
                    </div>
                    
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; font-size: 0.9rem; color: var(--color-text-secondary);">
                      <div style="display: flex; align-items: center; gap: 8px;">
                        <div style="width: 14px; height: 14px; border-radius: 4px; background: #ef4444;"></div>
                        <div style="flex: 1;">Daging & Protein</div>
                        <div style="font-weight: 700; color: var(--color-text-primary);">Rp {Math.round(cogsProtein).toLocaleString('id-ID')}</div>
                      </div>
                      <div style="display: flex; align-items: center; gap: 8px;">
                        <div style="width: 14px; height: 14px; border-radius: 4px; background: #10b981;"></div>
                        <div style="flex: 1;">Sayuran & Bumbu</div>
                        <div style="font-weight: 700; color: var(--color-text-primary);">Rp {Math.round(cogsSayur).toLocaleString('id-ID')}</div>
                      </div>
                      <div style="display: flex; align-items: center; gap: 8px;">
                        <div style="width: 14px; height: 14px; border-radius: 4px; background: #f59e0b;"></div>
                        <div style="flex: 1;">Kemasan (Packaging)</div>
                        <div style="font-weight: 700; color: var(--color-text-primary);">Rp {Math.round(cogsKemasan).toLocaleString('id-ID')}</div>
                      </div>
                      <div style="display: flex; align-items: center; gap: 8px;">
                        <div style="width: 14px; height: 14px; border-radius: 4px; background: #6b7280;"></div>
                        <div style="flex: 1;">Minyak & Lainnya</div>
                        <div style="font-weight: 700; color: var(--color-text-primary);">Rp {Math.round(cogsLainnya).toLocaleString('id-ID')}</div>
                      </div>
                    </div>
                  </div>
                {/if}
              </Tab>

              <Tab label="👥 SDM (Payroll)">
                {#if selectedBranch}
                  {@const activeCost = branch_cost_periods.find(row => row.branch_name === selectedBranch) || {}}
                  {@const totalLabor = activeCost.labor_30d || 0}
                  {@const laborPokok = totalLabor * 0.65}
                  {@const laborLembur = totalLabor * 0.20}
                  {@const laborBonus = totalLabor * 0.15}

                  <div class="interactive-card" style="padding: 24px; margin-top: 16px;">
                    <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 16px;">
                      <div style="font-weight: 700; color: var(--color-text-primary); font-size: 1.1rem;">Total Biaya SDM (30 Hari)</div>
                      <div style="font-size: 1.2rem; color: var(--color-text-primary); font-weight: 800;">Rp {Math.round(totalLabor).toLocaleString('id-ID')}</div>
                    </div>
                    
                    <div style="display: flex; height: 32px; border-radius: 8px; overflow: hidden; margin-bottom: 20px; box-shadow: inset 0 1px 3px rgba(0,0,0,0.1);">
                      <div style="width: 65%; background: linear-gradient(90deg, #3b82f6, #60a5fa); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.8rem; font-weight: 700;" title="Gaji Pokok: Rp {Math.round(laborPokok).toLocaleString('id-ID')}">65%</div>
                      <div style="width: 20%; background: linear-gradient(90deg, #f43f5e, #fb7185); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.8rem; font-weight: 700;" title="Upah Lembur: Rp {Math.round(laborLembur).toLocaleString('id-ID')}">20%</div>
                      <div style="width: 15%; background: linear-gradient(90deg, #8b5cf6, #a78bfa); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.8rem; font-weight: 700;" title="Bonus & Tunjangan: Rp {Math.round(laborBonus).toLocaleString('id-ID')}">15%</div>
                    </div>
                    
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; font-size: 0.9rem; color: var(--color-text-secondary);">
                      <div style="display: flex; align-items: center; gap: 8px;">
                        <div style="width: 14px; height: 14px; border-radius: 4px; background: #3b82f6;"></div>
                        <div style="flex: 1;">Gaji Pokok</div>
                        <div style="font-weight: 700; color: var(--color-text-primary);">Rp {Math.round(laborPokok).toLocaleString('id-ID')}</div>
                      </div>
                      <div style="display: flex; align-items: center; gap: 8px;">
                        <div style="width: 14px; height: 14px; border-radius: 4px; background: #f43f5e;"></div>
                        <div style="flex: 1;">Upah Lembur (Overtime)</div>
                        <div style="font-weight: 700; color: var(--color-text-primary);">Rp {Math.round(laborLembur).toLocaleString('id-ID')}</div>
                      </div>
                      <div style="display: flex; align-items: center; gap: 8px;">
                        <div style="width: 14px; height: 14px; border-radius: 4px; background: #8b5cf6;"></div>
                        <div style="flex: 1;">Bonus & Tunjangan</div>
                        <div style="font-weight: 700; color: var(--color-text-primary);">Rp {Math.round(laborBonus).toLocaleString('id-ID')}</div>
                      </div>
                    </div>
                  </div>
                {/if}
              </Tab>

            </Tabs>
          </div>


      <!-- SECTION: Data Pendukung -->
      <DiagnosticsHeader 
        marginTop="40px"
        eyebrow="📑 Ruang Data Pendukung"
        title="Pusat Data Ekstra &amp; Perspektif Strategis"
        description="Gunakan lensa tambahan di bawah ini untuk membedah komposisi mesin pendapatan serta melacak pola tren kesehatan bisnis dalam jangka panjang (Kuartalan &amp; YoY)."
      />

      <div class="data-wrapper">
      <Tabs id="data_pendukung_tabs" fullWidth=true>

        <Tab label="🍕 Mesin Pendapatan (30 Hari)">
          {#if selectedBranch}
            {@const filteredMenu = branch_menu_detail_30d.filter(row => row.branch_name === selectedBranch)}
            {@const totalRev = branch_category_mix.filter(row => row.branch_name === selectedBranch).reduce((sum, row) => sum + row.total_rev, 0)}
            {@const top3Rev = filteredMenu.slice(0, 3).reduce((sum, row) => sum + row.revenue_current, 0)}
            {@const top3Pct = totalRev > 0 ? (top3Rev / totalRev) * 100 : 0}
            {@const tableData = filteredMenu.map(row => ({...row, qty_diff: row.qty_current - row.qty_previous})).sort((a,b) => Math.abs(b.qty_diff) - Math.abs(a.qty_diff))}

            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 16px; margin-bottom: 16px;">
              <div class="interactive-card" style="padding: 24px;">
                <BarChart 
                  data={branch_category_mix.filter(row => row.branch_name === selectedBranch)} 
                  x="category" 
                  y="total_rev" 
                  swapXY=true
                  title="Komposisi Omzet per Kategori" 
                  yFmt="Rp #,##0"
                  sort="total_rev"
                  colorPalette={['#10b981', '#3b82f6', '#f59e0b', '#8b5cf6']}
                />
              </div>
              
              <div class="interactive-card" style="padding: 24px;">
                <BarChart 
                  data={filteredMenu.slice(0, 10)} 
                  x="menu_name" 
                  y="revenue_current" 
                  swapXY=true 
                  title="Top 10 Menu Omzet (Rp)" 
                  yFmt="Rp #,##0"
                  sort="revenue_current"
                />
              </div>
            </div>

            <div class="chart-insight" style="margin-top: 16px; margin-bottom: 24px;">
              📌 <strong>Risiko Ketergantungan:</strong> Jika porsi menu Top 5 mendominasi terlalu besar, pastikan ketersediaan bahan baku untuk menu tersebut tidak pernah putus, karena jika kosong, restoran kehilangan mayoritas omzetnya.
            </div>

            <div class="interactive-card" style="margin-bottom: 24px; padding: 24px;">
              <h4 style="margin-top: 0; margin-bottom: 4px; font-weight: 700; font-size: 1.1rem; color: var(--color-text-primary);">📈 Top Movers (Menu Stabil)</h4>
              <p style="margin-top: 0; margin-bottom: 16px; font-size: 0.9rem; color: var(--color-text-secondary);">Menu mana yang mengalami perubahan tren terbesar?<br/>Menampilkan menu dengan lonjakan dan penurunan persentase penjualan terbesar bulan ini.</p>
              <DataTable data={tableData} rows=6>
                <Column id="menu_name" title="Menu"/>
                <Column id="qty_previous" title="Sebelum" fmt="#,##0"/>
                <Column id="qty_current" title="Sekarang" fmt="#,##0"/>
                <Column id="qty_diff" title="Selisih" contentType="delta"/>
              </DataTable>
              <div class="chart-insight" style="margin-top: 16px;">
                📌 <strong>Anomali Pergerakan:</strong> Perhatikan arah dan panjang batang pada grafik untuk melihat tren persentase. Lalu, cek tabel di sebelahnya untuk memvalidasi apakah persentase tersebut berdampak signifikan secara porsi riil.
              </div>
            </div>
          {/if}
        </Tab>

        <Tab label="📊 Tren Strategis (Kuartal & YoY)">
          <div style="margin-top: 16px;">
            <!-- Evaluasi Jangka Menengah (Kuartal QoQ) -->
            <div class="interactive-card" style="margin-bottom: 32px; padding: 24px;">
              <h4 style="margin-top: 0; margin-bottom: 16px; font-weight: 700; font-size: 1.1rem; color: var(--color-text-primary);">📊 Quarter Report &middot; Baca Fenomena Musiman</h4>
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
                      <td class="markdown" style="text-align: right; font-weight: 600; color:{row.net_margin_pct >= 10 ? '#16a34a' : row.net_margin_pct >= 5 ? '#ca8a04' : '#dc2626'}">
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

            <!-- Tren Jangka Panjang & YoY (Historis) -->
            <div class="interactive-card" style="margin-bottom: 16px; padding: 24px;">
              <h4 style="margin-top: 0; margin-bottom: 16px; font-weight: 700; font-size: 1.1rem; color: var(--color-text-primary);">📈 Tren Jangka Panjang &amp; YoY (Historis)</h4>
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
                  <ReferenceLine y={10} label="Target Sehat 10%" lineType="dashed" color="#10B981" />
                  <ReferenceLine y={5} label="Waspada 5%" lineType="dashed" color="#F97316" />
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
          </div>
        </Tab>

      </Tabs>
      </div>

  {:else}
    <SectionCard 
      eyebrow="⚠️ Deep Dive Belum Tersedia"
      title="Cabang ini belum punya data cukup untuk diagnosis detail"
      description="Pilih cabang lain atau cek apakah data revenue, net revenue, dan biaya untuk cabang ini sudah masuk lengkap pada horizon 30 sampai 90 hari."
    />
  {/if}

</div>

{:else}
  <GlobalLoading />
{/if}

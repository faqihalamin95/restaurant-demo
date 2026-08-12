---
title: Deepdive
---

<script>
  import DiagnosticsHeader from '$lib/DiagnosticsHeader.svelte';
  import SectionHeader from '$lib/SectionHeader.svelte';
  import SectionCard from '$lib/SectionCard.svelte';
</script>

<style>
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
  <a href="/02-branch-performance" class="tab-button ">🏠 Overview</a>
  <a href="/02-branch-performance/02-deepdive" class="tab-button active">🏪 Deep Dive</a>
  <a href="/02-branch-performance/03-analysis" class="tab-button ">🔭 Analysis</a>
  <a href="/02-branch-performance/04-data-directory" class="tab-button ">📁 Data Directory</a>
</div>

{#if typeof branch_list !== 'undefined' && branch_list.length > 0 && typeof branch_dates !== 'undefined' && branch_dates.length > 0 && typeof branch_scorecard !== 'undefined' && typeof branch_cost_periods !== 'undefined' && typeof branch_menu_detail_30d !== 'undefined' && typeof branch_category_mix !== 'undefined' && typeof branch_quarterly_report !== 'undefined' && typeof branch_yoy_report !== 'undefined'}
  {@const selectedBranchRaw = String(inputs.focus_branch ?? (branch_list[0]?.branch_name ?? ''))}
  {@const selectedBranchNormalized = decodeURIComponent(selectedBranchRaw).replace(/\+/g, ' ')}
  {@const selectedBranch = branch_list.find(branch => branch.branch_name === selectedBranchRaw || branch.branch_name === selectedBranchNormalized)?.branch_name ?? branch_list[0]?.branch_name ?? ''}
  {@const activeScorecard = branch_scorecard.find(row => row.selected_branch === selectedBranch)}
  {@const activeCostPeriods = branch_cost_periods.find(row => row.branch_name === selectedBranch)}

  <!-- Period calculations for Top Selector -->
  {@const activePeriodDeepdive = inputs.period_deepdive ?? '30d'}
  {@const activePeriodLabel = activePeriodDeepdive === 'mtd' ? 'Month-to-Date (MTD)' : activePeriodDeepdive === '90d' ? 'Last 90 Days' : 'Last 30 Days'}
  
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
  {@const branchMainCostPressureMtd = mtdMaxExcess <= 0 ? 'all costs within limits' : mtdMaxExcess === mtdOverheadExcess ? 'operational costs' : mtdMaxExcess === mtdIngrExcess ? 'Ingredient Costs' : 'Labor Costs'}

  <!-- Cost Pressure for 30D -->
  {@const ingrExcess = branchIngredientPct30 - 30}
  {@const laborExcess = branchLaborPct30 - 30}
  {@const overheadExcess = branchOverheadPct30 - 30}
  {@const maxExcess = Math.max(ingrExcess, laborExcess, overheadExcess)}
  {@const branchMainCostPressure = maxExcess <= 0 ? 'all costs within limits' : maxExcess === overheadExcess ? 'operational costs' : maxExcess === ingrExcess ? 'Ingredient Costs' : 'Labor Costs'}

  <!-- Cost Pressure for 90D -->
  {@const ingrExcess90 = branchIngredientPct90 - 30}
  {@const laborExcess90 = branchLaborPct90 - 30}
  {@const overheadExcess90 = branchOverheadPct90 - 30}
  {@const maxExcess90 = Math.max(ingrExcess90, laborExcess90, overheadExcess90)}
  {@const branchMainCostPressure90 = maxExcess90 <= 0 ? 'all costs within limits' : maxExcess90 === overheadExcess90 ? 'operational costs' : maxExcess90 === ingrExcess90 ? 'Ingredient Costs' : 'Labor Costs'}

  {@const activePeriodDates = activePeriodDeepdive === 'mtd' ? `${branch_dates[0].tgl_mtd_awal} - ${branch_dates[0].tgl_akhir}` : activePeriodDeepdive === '90d' ? `${branch_dates[0].tgl_90_awal} - ${branch_dates[0].tgl_akhir}` : `${branch_dates[0].tgl_30_awal} - ${branch_dates[0].tgl_akhir}`}
  {@const activeGrowthPct = activeScorecard ? (activePeriodDeepdive === 'mtd' ? activeScorecard.rev_pct_mtd : activePeriodDeepdive === '90d' ? activeScorecard.rev_pct_90d : activeScorecard.rev_pct_30d) : 0}
  {@const activeCostPressureLabel = activePeriodDeepdive === 'mtd' ? branchMainCostPressureMtd : activePeriodDeepdive === '90d' ? branchMainCostPressure90 : branchMainCostPressure}
  {@const activeCostPressureGap = activePeriodDeepdive === 'mtd' ? mtdMaxExcess : activePeriodDeepdive === '90d' ? maxExcess90 : maxExcess}
  {@const activeIngrExcess = activePeriodDeepdive === 'mtd' ? mtdIngrExcess : activePeriodDeepdive === '90d' ? ingrExcess90 : ingrExcess}
  {@const activeLaborExcess = activePeriodDeepdive === 'mtd' ? mtdLaborExcess : activePeriodDeepdive === '90d' ? laborExcess90 : laborExcess}
  {@const activeOverheadExcess = activePeriodDeepdive === 'mtd' ? mtdOverheadExcess : activePeriodDeepdive === '90d' ? overheadExcess90 : overheadExcess}

  <!-- Core Metric Calculations for Accordion -->
  {@const activeMetricPeriod = inputs.deepdive_metric_period ?? '30d'}
  {@const activeMetricPeriodLabel = activeMetricPeriod === 'yesterday' ? 'similar day (SDOW) last week' : activeMetricPeriod === '7d' ? 'previous 7 days' : 'previous 30 days'}
  
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

  {@const showIngrAdvisor = activeIngrExcess > 0 || (forceCostPressure && activeCostPressureLabel === 'Ingredient Costs')}
  {@const showLaborAdvisor = activeLaborExcess > 0 || (forceCostPressure && activeCostPressureLabel === 'Labor Costs')}
  {@const showOverheadAdvisor = activeOverheadExcess > 0 || (forceCostPressure && activeCostPressureLabel === 'Operational Expenses (OpEx)')}
  {@const showIngrUnderAdvisor = branchIngredientPct30 < 25}
  {@const showLaborUnderAdvisor = branchLaborPct30 < 15}

<div class="branch-page">

<SectionCard 
  eyebrow="<span style='font-size: 12px;'>🏪 Select Location</span>" 
  title="Branch Performance Control Center" 
  description="Select a specific location to drill down into daily margin trends, operational cost breakdowns, and order type distribution."
>
    <ButtonGroup name=focus_branch>
      {#each branch_list as branch, i}
        <ButtonGroupItem value={branch.branch_name} valueLabel={branch.branch_name} default={branch.branch_name === selectedBranch} />
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
          EXECUTIVE SUMMARY: {activeMarginState === 'safe' ? 'Healthy Operational Performance' : activeMarginState === 'warn' ? 'Performance Needs Attention' : 'Critical Profitability Risk'}
        </h3>
      </div>
      
      <div style="font-size: 0.95rem; line-height: 1.6; color: var(--color-text-primary); margin-bottom: 20px;">
        {#if activeMarginState === 'safe'}
          This location is operating efficiently, generating <strong>Rp {activeScorecard.gross_30d?.toLocaleString('en-US')}</strong> in revenue across <strong>{activeScorecard.ord_30d?.toLocaleString('en-US')} transactions</strong> over the last 30 days. 
          {#if grossGrowthPct >= 0}
            Net margin remains healthy at <strong>{activeScorecard.margin_30d?.toFixed(1)}%</strong>, aligned with a <strong>+{grossGrowthPct.toFixed(1)}%</strong> daily revenue growth compared to baseline. 
          {:else}
            Net margin remains healthy at <strong>{activeScorecard.margin_30d?.toFixed(1)}%</strong>; <strong>however</strong>, transaction volume contracted by <strong>{Math.abs(grossGrowthPct).toFixed(1)}%</strong> from baseline. Review the quarterly benchmark chart below to determine if this dip reflects a normal seasonal off-peak.
          {/if}
          {#if branchMainCostPressure !== 'all costs within limits'} Continue monitoring trends for <strong>{branchMainCostPressure}</strong>.{/if}
        
        {:else if activeMarginState === 'warn'}
          This location requires operational attention. 
          {#if grossGrowthPct >= 0}
            While revenue grew by <strong>+{grossGrowthPct.toFixed(1)}%</strong> to <strong>Rp {activeScorecard.gross_30d?.toLocaleString('en-US')}</strong>, net margin is compressed at <strong>{activeScorecard.margin_30d?.toFixed(1)}%</strong>. Volume expansion is not yet efficiently converting into profit.
          {:else}
            Revenue contracted by <strong>{Math.abs(grossGrowthPct).toFixed(1)}%</strong> to <strong>Rp {activeScorecard.gross_30d?.toLocaleString('en-US')}</strong>, while net margin hovered near the threshold of <strong>{activeScorecard.margin_30d?.toFixed(1)}%</strong>. Determine whether this weakening stems from seasonal slowdown or operational inefficiencies.
          {/if}
          Primary cost pressure currently stems from <strong>{branchMainCostPressure}</strong>, which is approaching tolerance limits.
        
        {:else}
          This location requires immediate management intervention. 
          {#if grossGrowthPct >= 0}
            Despite achieving revenue growth of <strong>+{grossGrowthPct.toFixed(1)}%</strong> to <strong>Rp {activeScorecard.gross_30d?.toLocaleString('en-US')}</strong>, net margin eroded severely to <strong>{activeScorecard.margin_30d?.toFixed(1)}%</strong>. Traffic surges failed to yield profit, indicating that aggressive discounting or promotional tactics may have over-penetrated.
          {:else}
            This location is under dual pressure. Revenue fell by <strong>{Math.abs(grossGrowthPct).toFixed(1)}%</strong> to <strong>Rp {activeScorecard.gross_30d?.toLocaleString('en-US')}</strong>, and net margin plummeted to a critical <strong>{activeScorecard.margin_30d?.toFixed(1)}%</strong>. Even during seasonal slowdowns, traffic drops should not impact margins this severely.
          {/if}
          The primary driver is identified as <strong>{branchMainCostPressure}</strong>, which has breached the 30% efficiency threshold.
        {/if}
      </div>
    </div> <!-- EXECUTIVE SUMMARY PANEL ENDS HERE -->

    <!-- ADVISOR MODE PANEL -->
    {@const activeAdvisorsCount = [showIngrAdvisor, showLaborAdvisor, showOverheadAdvisor, showGrowth, showCashcow].filter(Boolean).length}

    <DiagnosticsHeader 
      marginTop="16px"
      eyebrow="💡 Tactical Recommendation Center"
      title="Corrective action &amp; strategic guidance"
      description="Use the system recommendations below to take action on cost pressures, operational inefficiencies, and location growth optimization strategies."
    />

    
    <div class="advisor-wrapper">
      {#if activeAdvisorsCount === 1}

        {#if showIngrAdvisor}
          <div style="margin-bottom: 24px;">
<div class="risk-row purple-theme" style="margin-top: 16px; margin-bottom: 24px;">
<div class="risk-row-header">
  <span class="risk-row-icon">🥩</span>
  <h4 class="risk-row-title">Cost Optimization: Food &amp; Ingredients (COGS)</h4>
</div>
<div class="risk-pills">
  <div class="risk-pill">
    <span class="risk-pill-anchor">🕵️</span>
    <div class="risk-pill-content">
      <strong>Option A: Audit &amp; Control</strong>
      <span><strong>Unannounced Stock Audit.</strong> Perform spot checks on high-volume items ({activePlaybook ? activePlaybook.top_volume_menu : 'flagship menu'}) to identify portioning anomalies, yield loss, or shrinkage.</span>
      <div class="pros-cons-box">
        <div class="pro"><span>✅</span><span><strong>Pro:</strong> Curbs immediate inventory leakage with zero capital expenditure.</span></div>
        <div class="con"><span>⚠️</span><span><strong>Con:</strong> May strain team morale if executed overly aggressively.</span></div>
      </div>
    </div>
  </div>
  <div class="risk-pill">
    <span class="risk-pill-anchor">🏷️</span>
    <div class="risk-pill-content">
      <strong>Option B: Price Engineering</strong>
      <span><strong>Targeted 5–10% Price Adjustment.</strong> Apply strategic price increases on top revenue drivers ({activePlaybook ? activePlaybook.top_revenue_menu : 'revenue generator'}) to expand contribution margins.</span>
      <div class="pros-cons-box">
        <div class="pro"><span>✅</span><span><strong>Pro:</strong> Delivers immediate margin expansion without operational changes.</span></div>
        <div class="con"><span>⚠️</span><span><strong>Con:</strong> Risks dampening transaction volume if customer price sensitivity is high.</span></div>
      </div>
    </div>
  </div>
  <div class="risk-pill">
    <span class="risk-pill-anchor">🍔</span>
    <div class="risk-pill-content">
      <strong>Option C: High-Margin Beverage Bundling</strong>
      <span><strong>Mandatory Upselling Protocol.</strong> Train and incentivize front-of-house staff to pair high-margin beverages with core food items.</span>
      <div class="pros-cons-box">
        <div class="pro"><span>✅</span><span><strong>Pro:</strong> Lifts Average Order Value (AOV) without inflating overall COGS percentage.</span></div>
        <div class="con"><span>⚠️</span><span><strong>Con:</strong> Requires active cashier incentive schemes and ongoing training.</span></div>
      </div>
    </div>
  </div>
</div>
<div class="risk-funfact">
  <span class="risk-funfact-icon">📎</span>
  <div class="risk-funfact-content">
    <span>Target Food &amp; Ingredient Costs (COGS) should ideally remain below 30% of revenue. Exceeding this threshold typically points to food waste, unmonitored supplier price spikes, or portion inconsistency.</span>
    <cite>Benchmark Standard: F&B Cost Structure Model (30% COGS / 30% Labor / 30% Overhead / 10% Net Margin)</cite>
  </div>
</div>
</div>
          </div>
        {/if}

        {#if showLaborAdvisor}
          <div style="margin-bottom: 24px;">
<div class="risk-row blue-theme" style="margin-top: 16px; margin-bottom: 24px;">
<div class="risk-row-header">
  <span class="risk-row-icon">👥</span>
  <h4 class="risk-row-title">Labor Cost Optimization Strategies</h4>
</div>
<div class="risk-pills">
  <div class="risk-pill">
    <span class="risk-pill-anchor">✂️</span>
    <div class="risk-pill-content">
      <strong>Option A: Shift & Labor Hour Trimming</strong>
      <span><strong>Optimize Off-Peak Staffing.</strong> Reduce part-time floor shifts during low-volume hours and place a temporary freeze on non-essential hiring.</span>
      <div class="pros-cons-box">
        <div class="pro"><span>✅</span><span><strong>Pro:</strong> Delivers immediate reduction in variable payroll expenses for next month.</span></div>
        <div class="con"><span>⚠️</span><span><strong>Con:</strong> May impact service speed during unexpected order spikes.</span></div>
      </div>
    </div>
  </div>
  <div class="risk-pill">
    <span class="risk-pill-anchor">🚀</span>
    <div class="risk-pill-content">
      <strong>Option B: Revenue Expansion (Dilute Labor Ratio)</strong>
      <span><strong>Drive Top-Line Volume.</strong> Maintain existing headcount while driving traffic initiatives to dilute the labor cost percentage against total sales.</span>
      <div class="pros-cons-box">
        <div class="pro"><span>✅</span><span><strong>Pro:</strong> Preserves core team morale and upholds peak service standards.</span></div>
        <div class="con"><span>⚠️</span><span><strong>Con:</strong> Requires upfront promotional spend, placing short-term pressure on cash flow.</span></div>
      </div>
    </div>
  </div>
  <div class="risk-pill">
    <span class="risk-pill-anchor">📱</span>
    <div class="risk-pill-content">
      <strong>Option C: Digital Ordering Automation</strong>
      <span><strong>Self-Service Migration.</strong> Implement QR Ordering or Self-Service Kiosks to reduce front-of-house headcount dependency.</span>
      <div class="pros-cons-box">
        <div class="pro"><span>✅</span><span><strong>Pro:</strong> Creates a long-term scalable cost structure resilient to minimum wage inflation.</span></div>
        <div class="con"><span>⚠️</span><span><strong>Con:</strong> Involves initial system capex and a brief customer adoption phase.</span></div>
      </div>
    </div>
  </div>
</div>
<div class="risk-funfact">
  <span class="risk-funfact-icon">📎</span>
  <div class="risk-funfact-content">
    <span>Target Labor Cost should ideally remain below 30% of total revenue. Laying off experienced full-time staff risks disrupting operational quality; trimming part-time hours or flexing floor schedules is recommended as a first line of defense.</span>
    <cite>Benchmark Standard: F&B Cost Structure Model (30% COGS / 30% Labor / 30% Overhead / 10% Net Margin)</cite>
  </div>
</div>
</div>
          </div>
        {/if}

        {#if showOverheadAdvisor}
          <div style="margin-bottom: 24px;">
<div class="risk-row slate-theme" style="margin-top: 16px; margin-bottom: 24px;">
<div class="risk-row-header">
  <span class="risk-row-icon">🏢</span>
  <h4 class="risk-row-title">Overhead &amp; Operational Cost Optimization</h4>
</div>
<div class="risk-pills">
  <div class="risk-pill">
    <span class="risk-pill-anchor">🔌</span>
    <div class="risk-pill-content">
      <strong>Option A: Utility &amp; Energy Efficiency</strong>
      <span><strong>Energy Consumption Audit.</strong> Establish strict operating protocols for HVAC and equipment usage during prep and off-peak hours. Track weekly utility metering.</span>
      <div class="pros-cons-box">
        <div class="pro"><span>✅</span><span><strong>Pro:</strong> Immediate operational deployment with zero friction or external dependencies.</span></div>
        <div class="con"><span>⚠️</span><span><strong>Con:</strong> Savings impact is modest compared to structural fixed-cost reductions.</span></div>
      </div>
    </div>
  </div>
  <div class="risk-pill">
    <span class="risk-pill-anchor">🏪</span>
    <div class="risk-pill-content">
      <strong>Option B: Facility Asset Utilization</strong>
      <span><strong>Subleasing &amp; Ghost Kitchen Hosting.</strong> Monetize underutilized floor space by subleasing to non-competing vendors or leveraging kitchen capacity for virtual brands.</span>
      <div class="pros-cons-box">
        <div class="pro"><span>✅</span><span><strong>Pro:</strong> Transforms fixed occupancy cost into an active recurring revenue stream.</span></div>
        <div class="con"><span>⚠️</span><span><strong>Con:</strong> Requires lead time for tenant sourcing, licensing, and lease negotiation.</span></div>
      </div>
    </div>
  </div>
  <div class="risk-pill">
    <span class="risk-pill-anchor">🤝</span>
    <div class="risk-pill-content">
      <strong>Option C: Lease Restructuring &amp; Vendor Audits</strong>
      <span><strong>Landlord Renegotiation.</strong> Leverage recent sales performance data to negotiate temporary rent relief, or audit third-party security/cleaning vendor contracts.</span>
      <div class="pros-cons-box">
        <div class="pro"><span>✅</span><span><strong>Pro:</strong> Fundamentally cuts the largest fixed overhead burden on the balance sheet.</span></div>
        <div class="con"><span>⚠️</span><span><strong>Con:</strong> Risks counterparty friction or early lease termination penalties.</span></div>
      </div>
    </div>
  </div>
</div>
<div class="risk-funfact">
  <span class="risk-funfact-icon">📎</span>
  <div class="risk-funfact-content">
    <span>Overhead exceeding 30% creates severe margin pressure due to its fixed nature (payable regardless of daily sales volume). Proactively restructuring occupancy costs during revenue contractions is a standard corporate practice.</span>
    <cite>Benchmark Standard: F&B Cost Structure Model (30% COGS / 30% Labor / 30% Overhead / 10% Net Margin)</cite>
  </div>
</div>
</div>
          </div>
        {/if}

        {#if showGrowth}
          <div style="margin-bottom: 24px;">
<div class="risk-row purple-theme" style="margin-top: 16px; margin-bottom: 24px;">
<div class="risk-row-header">
  <span class="risk-row-icon">📉</span>
  <h4 class="risk-row-title">Volume Decline Mitigation Strategies</h4>
</div>
<div class="risk-pills">
  <div class="risk-pill">
    <span class="risk-pill-anchor">🎯</span>
    <div class="risk-pill-content">
      <strong>Option A: Tactical Promotional Push</strong>
      <span><strong>Targeted Margin Compression.</strong> Deploy time-bound discounts on high-volume menu items ({activePlaybook ? activePlaybook.top_volume_menu : 'flagship menu'}) to stimulate immediate traffic.</span>
      <div class="pros-cons-box">
        <div class="pro"><span>✅</span><span><strong>Pro:</strong> Drives instant transaction volume and foot traffic recovery.</span></div>
        <div class="con"><span>⚠️</span><span><strong>Con:</strong> Intentionally compresses gross margin percentage for the active period.</span></div>
      </div>
    </div>
  </div>
  <div class="risk-pill">
    <span class="risk-pill-anchor">💎</span>
    <div class="risk-pill-content">
      <strong>Option B: CRM & Loyalty Retention</strong>
      <span><strong>High-Value Diner Engagement.</strong> Leverage your loyalty database to distribute targeted bounce-back offers to frequent customers.</span>
      <div class="pros-cons-box">
        <div class="pro"><span>✅</span><span><strong>Pro:</strong> Protects repeat revenue without incurring high Customer Acquisition Costs (CAC).</span></div>
        <div class="con"><span>⚠️</span><span><strong>Con:</strong> Efficacy depends entirely on customer database health and CRM coverage.</span></div>
      </div>
    </div>
  </div>
  <div class="risk-pill">
    <span class="risk-pill-anchor">🛡️</span>
    <div class="risk-pill-content">
      <strong>Option C: Operational Alignment & Waste Control</strong>
      <span><strong>Off-Peak Efficiency Adjustment.</strong> Treat the slowdown as a seasonal off-peak phase. Align daily par levels to prevent inventory waste.</span>
      <div class="pros-cons-box">
        <div class="pro"><span>✅</span><span><strong>Pro:</strong> Safeguards net margin by eliminating food spoilage and excess inventory.</span></div>
        <div class="con"><span>⚠️</span><span><strong>Con:</strong> Risks ceding market share if competitors run aggressive campaigns.</span></div>
      </div>
    </div>
  </div>
</div>
<div class="risk-funfact">
  <span class="risk-funfact-icon">📎</span>
  <div class="risk-funfact-content">
    <span>Aggressive promotional spend during a broad seasonal off-peak period often yields negative ROI. Protecting margins through inventory efficiency and par-level adjustments is the most prudent operational response.</span>
    <cite>Benchmark Standard: F&B Seasonal Cycle Defense Strategy</cite>
  </div>
</div>
</div>
          </div>
        {/if}

        {#if showCashcow}
          <div style="margin-bottom: 24px;">
<div class="risk-row blue-theme" style="margin-top: 16px; margin-bottom: 24px;">
<div class="risk-row-header">
  <span class="risk-row-icon">🌟</span>
  <h4 class="risk-row-title">Capitalization Strategies for High-Performing Locations (Cash Cows)</h4>
</div>
<div class="risk-pills">
  <div class="risk-pill">
    <span class="risk-pill-anchor">🏆</span>
    <div class="risk-pill-content">
      <strong>Option A: Institutionalize Best Practices</strong>
      <span><strong>Operational Standardization.</strong> Document this location's SOPs and leadership playbook as a network-wide benchmark for underperforming branches.</span>
      <div class="pros-cons-box">
        <div class="pro"><span>✅</span><span><strong>Pro:</strong> Lifts operational efficiency and margin baseline across weaker locations.</span></div>
        <div class="con"><span>⚠️</span><span><strong>Con:</strong> May temporarily dilute the store manager's operational focus on their primary branch.</span></div>
      </div>
    </div>
  </div>
  <div class="risk-pill">
    <span class="risk-pill-anchor">💰</span>
    <div class="risk-pill-content">
      <strong>Option B: Key Talent Retention &amp; Incentives</strong>
      <span><strong>Performance Incentive Pool.</strong> Deploy profit-sharing or performance bonuses for store staff to protect core talent retention.</span>
      <div class="pros-cons-box">
        <div class="pro"><span>✅</span><span><strong>Pro:</strong> Safeguards high-performing staff loyalty and reduces turnover costs.</span></div>
        <div class="con"><span>⚠️</span><span><strong>Con:</strong> Slightly increases end-of-month payroll expenses.</span></div>
      </div>
    </div>
  </div>
  <div class="risk-pill">
    <span class="risk-pill-anchor">📈</span>
    <div class="risk-pill-content">
      <strong>Option C: Capacity Expansion &amp; Throughput</strong>
      <span><strong>Volume Scaling.</strong> Expand seating capacity, extend operating hours, or launch dedicated off-premise channels to capture untapped demand.</span>
      <div class="pros-cons-box">
        <div class="pro"><span>✅</span><span><strong>Pro:</strong> Breaks the revenue ceiling and maximizes floor-space asset utilization.</span></div>
        <div class="con"><span>⚠️</span><span><strong>Con:</strong> Requires upfront capital expenditure (CapEx) for facility/marketing tweaks.</span></div>
      </div>
    </div>
  </div>
</div>
<div class="risk-funfact">
  <span class="risk-funfact-icon">📎</span>
  <div class="risk-funfact-content">
    <span>High-margin "Cash Cow" locations generate the primary cash flow required to subsidize marketing, R&amp;D, and expansion across the network. Protecting their operational stability is critical.</span>
    <cite>Benchmark Standard: BCG Growth-Share Matrix (Cash Cows &amp; Stars Framework)</cite>
  </div>
</div>
</div>
          </div>
        {/if}

      {:else}
      <Tabs id="advisor_tabs" fullWidth=true>

        {#if showIngrAdvisor}
          <Tab label="🥩 Ingredient Costs">
            <div class="risk-row purple-theme" style="margin-top: 16px; margin-bottom: 24px;">
              <div class="risk-row-header">
                <span class="risk-row-icon">🥩</span>
                <h4 class="risk-row-title">Cost Optimization: Food &amp; Ingredients (COGS)</h4>
              </div>
              <div class="risk-pills">
                <div class="risk-pill">
                  <span class="risk-pill-anchor">🕵️</span>
                  <div class="risk-pill-content">
                    <strong>Option A: Audit &amp; Control</strong>
                    <span><strong>Unannounced Stock Audit.</strong> Perform spot checks on high-volume items ({activePlaybook ? activePlaybook.top_volume_menu : 'flagship menu'}) to identify portioning anomalies, yield loss, or shrinkage.</span>
                    <div class="pros-cons-box">
                      <div class="pro"><span>✅</span><span><strong>Pro:</strong> Curbs immediate inventory leakage with zero capital expenditure.</span></div>
                      <div class="con"><span>⚠️</span><span><strong>Con:</strong> May strain team morale if executed overly aggressively.</span></div>
                    </div>
                  </div>
                </div>
                <div class="risk-pill">
                  <span class="risk-pill-anchor">🏷️</span>
                  <div class="risk-pill-content">
                    <strong>Option B: Price Engineering</strong>
                    <span><strong>Targeted 5–10% Price Adjustment.</strong> Apply strategic price increases on top revenue drivers ({activePlaybook ? activePlaybook.top_revenue_menu : 'revenue generator'}) to expand contribution margins.</span>
                    <div class="pros-cons-box">
                      <div class="pro"><span>✅</span><span><strong>Pro:</strong> Delivers immediate margin expansion without operational changes.</span></div>
                      <div class="con"><span>⚠️</span><span><strong>Con:</strong> Risks dampening transaction volume if customer price sensitivity is high.</span></div>
                    </div>
                  </div>
                </div>
                <div class="risk-pill">
                  <span class="risk-pill-anchor">🍔</span>
                  <div class="risk-pill-content">
                    <strong>Option C: High-Margin Beverage Bundling</strong>
                    <span><strong>Mandatory Upselling Protocol.</strong> Train and incentivize front-of-house staff to pair high-margin beverages with core food items.</span>
                    <div class="pros-cons-box">
                      <div class="pro"><span>✅</span><span><strong>Pro:</strong> Lifts Average Order Value (AOV) without inflating overall COGS percentage.</span></div>
                      <div class="con"><span>⚠️</span><span><strong>Con:</strong> Requires active cashier incentive schemes and ongoing training.</span></div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="risk-funfact">
                <span class="risk-funfact-icon">📎</span>
                <div class="risk-funfact-content">
                  <span>Target Food &amp; Ingredient Costs (COGS) should ideally remain below 30% of revenue. Exceeding this threshold typically points to food waste, unmonitored supplier price spikes, or portion inconsistency.</span>
                  <cite>Benchmark Standard: F&B Cost Structure Model (30% COGS / 30% Labor / 30% Overhead / 10% Net Margin)</cite>
                </div>
              </div>
            </div>
          </Tab>
        {/if}

        {#if showLaborAdvisor}
          <Tab label="👥 Labor Costs">
            <div class="risk-row blue-theme" style="margin-top: 16px; margin-bottom: 24px;">
              <div class="risk-row-header">
                <span class="risk-row-icon">👥</span>
                <h4 class="risk-row-title">Labor Cost Optimization Strategies</h4>
              </div>
              <div class="risk-pills">
                <div class="risk-pill">
                  <span class="risk-pill-anchor">✂️</span>
                  <div class="risk-pill-content">
                    <strong>Option A: Shift & Labor Hour Trimming</strong>
                    <span><strong>Optimize Off-Peak Staffing.</strong> Reduce part-time floor shifts during low-volume hours and place a temporary freeze on non-essential hiring.</span>
                    <div class="pros-cons-box">
                      <div class="pro"><span>✅</span><span><strong>Pro:</strong> Delivers immediate reduction in variable payroll expenses for next month.</span></div>
                      <div class="con"><span>⚠️</span><span><strong>Con:</strong> May impact service speed during unexpected order spikes.</span></div>
                    </div>
                  </div>
                </div>
                <div class="risk-pill">
                  <span class="risk-pill-anchor">🚀</span>
                  <div class="risk-pill-content">
                    <strong>Option B: Revenue Expansion (Dilute Labor Ratio)</strong>
                    <span><strong>Drive Top-Line Volume.</strong> Maintain existing headcount while driving traffic initiatives to dilute the labor cost percentage against total sales.</span>
                    <div class="pros-cons-box">
                      <div class="pro"><span>✅</span><span><strong>Pro:</strong> Preserves core team morale and upholds peak service standards.</span></div>
                      <div class="con"><span>⚠️</span><span><strong>Con:</strong> Requires upfront promotional spend, placing short-term pressure on cash flow.</span></div>
                    </div>
                  </div>
                </div>
                <div class="risk-pill">
                  <span class="risk-pill-anchor">📱</span>
                  <div class="risk-pill-content">
                    <strong>Option C: Digital Ordering Automation</strong>
                    <span><strong>Self-Service Migration.</strong> Implement QR Ordering or Self-Service Kiosks to reduce front-of-house headcount dependency.</span>
                    <div class="pros-cons-box">
                      <div class="pro"><span>✅</span><span><strong>Pro:</strong> Creates a long-term scalable cost structure resilient to minimum wage inflation.</span></div>
                      <div class="con"><span>⚠️</span><span><strong>Con:</strong> Involves initial system capex and a brief customer adoption phase.</span></div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="risk-funfact">
                <span class="risk-funfact-icon">📎</span>
                <div class="risk-funfact-content">
                  <span>Target Labor Cost should ideally remain below 30% of total revenue. Laying off experienced full-time staff risks disrupting operational quality; trimming part-time hours or flexing floor schedules is recommended as a first line of defense.</span>
                  <cite>Benchmark Standard: F&B Cost Structure Model (30% COGS / 30% Labor / 30% Overhead / 10% Net Margin)</cite>
                </div>
              </div>
            </div>
          </Tab>
        {/if}

        {#if showOverheadAdvisor}
          <Tab label="🏢 Overhead & Operations">
            <div class="risk-row slate-theme" style="margin-top: 16px; margin-bottom: 24px;">
              <div class="risk-row-header">
                <span class="risk-row-icon">🏢</span>
                <h4 class="risk-row-title">Overhead &amp; Operational Cost Optimization</h4>
              </div>
              <div class="risk-pills">
                <div class="risk-pill">
                  <span class="risk-pill-anchor">🔌</span>
                  <div class="risk-pill-content">
                    <strong>Option A: Utility &amp; Energy Efficiency</strong>
                    <span><strong>Energy Consumption Audit.</strong> Establish strict operating protocols for HVAC and equipment usage during prep and off-peak hours. Track weekly utility metering.</span>
                    <div class="pros-cons-box">
                      <div class="pro"><span>✅</span><span><strong>Pro:</strong> Immediate operational deployment with zero friction or external dependencies.</span></div>
                      <div class="con"><span>⚠️</span><span><strong>Con:</strong> Savings impact is modest compared to structural fixed-cost reductions.</span></div>
                    </div>
                  </div>
                </div>
                <div class="risk-pill">
                  <span class="risk-pill-anchor">🏪</span>
                  <div class="risk-pill-content">
                    <strong>Option B: Facility Asset Utilization</strong>
                    <span><strong>Subleasing &amp; Ghost Kitchen Hosting.</strong> Monetize underutilized floor space by subleasing to non-competing vendors or leveraging kitchen capacity for virtual brands.</span>
                    <div class="pros-cons-box">
                      <div class="pro"><span>✅</span><span><strong>Pro:</strong> Transforms fixed occupancy cost into an active recurring revenue stream.</span></div>
                      <div class="con"><span>⚠️</span><span><strong>Con:</strong> Requires lead time for tenant sourcing, licensing, and lease negotiation.</span></div>
                    </div>
                  </div>
                </div>
                <div class="risk-pill">
                  <span class="risk-pill-anchor">🤝</span>
                  <div class="risk-pill-content">
                    <strong>Option C: Lease Restructuring &amp; Vendor Audits</strong>
                    <span><strong>Landlord Renegotiation.</strong> Leverage recent sales performance data to negotiate temporary rent relief, or audit third-party security/cleaning vendor contracts.</span>
                    <div class="pros-cons-box">
                      <div class="pro"><span>✅</span><span><strong>Pro:</strong> Fundamentally cuts the largest fixed overhead burden on the balance sheet.</span></div>
                      <div class="con"><span>⚠️</span><span><strong>Con:</strong> Risks counterparty friction or early lease termination penalties.</span></div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="risk-funfact">
                <span class="risk-funfact-icon">📎</span>
                <div class="risk-funfact-content">
                  <span>Overhead exceeding 30% creates severe margin pressure due to its fixed nature (payable regardless of daily sales volume). Proactively restructuring occupancy costs during revenue contractions is a standard corporate practice.</span>
                  <cite>Benchmark Standard: F&B Cost Structure Model (30% COGS / 30% Labor / 30% Overhead / 10% Net Margin)</cite>
                </div>
              </div>
            </div>
          </Tab>
        {/if}

        {#if showGrowth}
          <Tab label="📉 Volume Decline">
            <div class="risk-row purple-theme" style="margin-top: 16px; margin-bottom: 24px;">
              <div class="risk-row-header">
                <span class="risk-row-icon">📉</span>
                <h4 class="risk-row-title">Volume Decline Mitigation Strategies</h4>
              </div>
              <div class="risk-pills">
                <div class="risk-pill">
                  <span class="risk-pill-anchor">🎯</span>
                  <div class="risk-pill-content">
                    <strong>Option A: Tactical Promotional Push</strong>
                    <span><strong>Targeted Margin Compression.</strong> Deploy time-bound discounts on high-volume menu items ({activePlaybook ? activePlaybook.top_volume_menu : 'flagship menu'}) to stimulate immediate traffic.</span>
                    <div class="pros-cons-box">
                      <div class="pro"><span>✅</span><span><strong>Pro:</strong> Drives instant transaction volume and foot traffic recovery.</span></div>
                      <div class="con"><span>⚠️</span><span><strong>Con:</strong> Intentionally compresses gross margin percentage for the active period.</span></div>
                    </div>
                  </div>
                </div>
                <div class="risk-pill">
                  <span class="risk-pill-anchor">💎</span>
                  <div class="risk-pill-content">
                    <strong>Option B: CRM & Loyalty Retention</strong>
                    <span><strong>High-Value Diner Engagement.</strong> Leverage your loyalty database to distribute targeted bounce-back offers to frequent customers.</span>
                    <div class="pros-cons-box">
                      <div class="pro"><span>✅</span><span><strong>Pro:</strong> Protects repeat revenue without incurring high Customer Acquisition Costs (CAC).</span></div>
                      <div class="con"><span>⚠️</span><span><strong>Con:</strong> Efficacy depends entirely on customer database health and CRM coverage.</span></div>
                    </div>
                  </div>
                </div>
                <div class="risk-pill">
                  <span class="risk-pill-anchor">🛡️</span>
                  <div class="risk-pill-content">
                    <strong>Option C: Operational Alignment & Waste Control</strong>
                    <span><strong>Off-Peak Efficiency Adjustment.</strong> Treat the slowdown as a seasonal off-peak phase. Align daily par levels to prevent inventory waste.</span>
                    <div class="pros-cons-box">
                      <div class="pro"><span>✅</span><span><strong>Pro:</strong> Safeguards net margin by eliminating food spoilage and excess inventory.</span></div>
                      <div class="con"><span>⚠️</span><span><strong>Con:</strong> Risks ceding market share if competitors run aggressive campaigns.</span></div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="risk-funfact">
                <span class="risk-funfact-icon">📎</span>
                <div class="risk-funfact-content">
                  <span>Aggressive promotional spend during a broad seasonal off-peak period often yields negative ROI. Protecting margins through inventory efficiency and par-level adjustments is the most prudent operational response.</span>
                  <cite>Benchmark Standard: F&B Seasonal Cycle Defense Strategy</cite>
                </div>
              </div>
            </div>
          </Tab>
        {/if}

        {#if showCashcow}
          <Tab label="🌟 Cash Cow Optimization">
            <div class="risk-row blue-theme" style="margin-top: 16px; margin-bottom: 24px;">
              <div class="risk-row-header">
                <span class="risk-row-icon">🌟</span>
                <h4 class="risk-row-title">Capitalization Strategies for High-Performing Locations (Cash Cows)</h4>
              </div>
              <div class="risk-pills">
                <div class="risk-pill">
                  <span class="risk-pill-anchor">🏆</span>
                  <div class="risk-pill-content">
                    <strong>Option A: Institutionalize Best Practices</strong>
                    <span><strong>Operational Standardization.</strong> Document this location's SOPs and leadership playbook as a network-wide benchmark for underperforming branches.</span>
                    <div class="pros-cons-box">
                      <div class="pro"><span>✅</span><span><strong>Pro:</strong> Lifts operational efficiency and margin baseline across weaker locations.</span></div>
                      <div class="con"><span>⚠️</span><span><strong>Con:</strong> May temporarily dilute the store manager's operational focus on their primary branch.</span></div>
                    </div>
                  </div>
                </div>
                <div class="risk-pill">
                  <span class="risk-pill-anchor">💰</span>
                  <div class="risk-pill-content">
                    <strong>Option B: Key Talent Retention &amp; Incentives</strong>
                    <span><strong>Performance Incentive Pool.</strong> Deploy profit-sharing or performance bonuses for store staff to protect core talent retention.</span>
                    <div class="pros-cons-box">
                      <div class="pro"><span>✅</span><span><strong>Pro:</strong> Safeguards high-performing staff loyalty and reduces turnover costs.</span></div>
                      <div class="con"><span>⚠️</span><span><strong>Con:</strong> Slightly increases end-of-month payroll expenses.</span></div>
                    </div>
                  </div>
                </div>
                <div class="risk-pill">
                  <span class="risk-pill-anchor">📈</span>
                  <div class="risk-pill-content">
                    <strong>Option C: Capacity Expansion &amp; Throughput</strong>
                    <span><strong>Volume Scaling.</strong> Expand seating capacity, extend operating hours, or launch dedicated off-premise channels to capture untapped demand.</span>
                    <div class="pros-cons-box">
                      <div class="pro"><span>✅</span><span><strong>Pro:</strong> Breaks the revenue ceiling and maximizes floor-space asset utilization.</span></div>
                      <div class="con"><span>⚠️</span><span><strong>Con:</strong> Requires upfront capital expenditure (CapEx) for facility/marketing tweaks.</span></div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="risk-funfact">
                <span class="risk-funfact-icon">📎</span>
                <div class="risk-funfact-content">
                  <span>High-margin "Cash Cow" locations generate the primary cash flow required to subsidize marketing, R&amp;D, and expansion across the network. Protecting their operational stability is critical.</span>
                  <cite>Benchmark Standard: BCG Growth-Share Matrix (Cash Cows &amp; Stars Framework)</cite>
                </div>
              </div>
            </div>
          </Tab>
        {/if}

      </Tabs>
      {/if}
    </div>


      <!-- SECTION: Operasional & Diagnostik -->
      <DiagnosticsHeader 
        marginTop="24px"
        eyebrow="🔬 Operational Diagnostics"
        title="Performance breakdown &amp; cost details"
        description="Use the tools below to analyze cost breakdowns, daily operational alerts, and margin trends."
      />
        
        <!-- 30 Hari vs 90 Hari Data Table -->

          <!-- Side-by-side comparison table -->
          <!-- Side-by-side comparison table -->
          <div style="overflow-x: auto; margin-bottom: 20px;">
            <table style="width:100%; border-collapse:collapse; font-size:0.88rem; text-align:left; border: 1px solid var(--color-border-tertiary); border-radius: 8px;">
              <thead>
                <tr style="background:var(--color-background-secondary); border-bottom:1.5px solid var(--color-border-tertiary);">
                  <th style="padding:10px 14px; font-weight:700; color:var(--color-text-primary);">Analysis Benchmarks</th>
                  <th style="padding:10px 14px; font-weight:700; text-align:right; color:var(--color-text-primary);">Last 30 Days (Current)</th>
                  <th style="padding:10px 14px; font-weight:700; text-align:right; color:var(--color-text-primary);">90-Day Baseline</th>
                  <th style="padding:10px 14px; font-weight:700; text-align:right; color:var(--color-text-primary);">Change vs. Baseline</th>
                </tr>
              </thead>
              <tbody>
                <tr style="border-bottom:1px solid var(--color-border-tertiary);">
                  <td style="padding:10px 14px; font-weight:600;">📈 Net Profit Margin (%)</td>
                  <td style="padding:10px 14px; text-align:right; font-weight:700; color:{activeScorecard.margin_30d >= 15 ? '#16a34a' : activeScorecard.margin_30d >= 10 ? '#b45309' : '#dc2626'}">{activeScorecard.margin_30d?.toFixed(1)}%</td>
                  <td style="padding:10px 14px; text-align:right; color:var(--color-text-secondary);">{activeScorecard.margin_90d?.toFixed(1)}%</td>
                  <td style="padding:10px 14px; text-align:right; font-weight:700; color:{activeScorecard.margin_30d >= activeScorecard.margin_90d ? '#16a34a' : '#dc2626'}">
                    {activeScorecard.margin_30d >= activeScorecard.margin_90d ? '+' : ''}{(activeScorecard.margin_30d - activeScorecard.margin_90d).toFixed(1)}%
                  </td>
                </tr>
                <tr style="border-bottom:1px solid var(--color-border-tertiary);">
                  <td style="padding:10px 14px; font-weight:600;">💵 Average Daily Sales (ADS)</td>
                  <td style="padding:10px 14px; text-align:right; font-weight:700;">Rp {Math.round(activeScorecard.gross_30d / 30)?.toLocaleString('en-US')}</td>
                  <td style="padding:10px 14px; text-align:right; color:var(--color-text-secondary);">Rp {Math.round(activeScorecard.gross_90d / 90)?.toLocaleString('en-US')}</td>
                  <td style="padding:10px 14px; text-align:right; font-weight:700; color:{activeScorecard.gross_30d/30 >= activeScorecard.gross_90d/90 ? '#16a34a' : '#dc2626'}">
                    {activeScorecard.gross_30d/30 >= activeScorecard.gross_90d/90 ? '▲ +' : '▼ '}{(((activeScorecard.gross_30d/30) - (activeScorecard.gross_90d/90)) / (activeScorecard.gross_90d/90 || 1) * 100).toFixed(1)}%
                  </td>
                </tr>
                <tr style="border-bottom:1px solid var(--color-border-tertiary);">
                  <td style="padding:10px 14px; font-weight:600;">📦 Average Daily Transactions (ADT)</td>
                  <td style="padding:10px 14px; text-align:right; font-weight:700;">{(activeScorecard.ord_30d / 30).toFixed(1)} order</td>
                  <td style="padding:10px 14px; text-align:right; color:var(--color-text-secondary);">{(activeScorecard.ord_90d / 90).toFixed(1)} order</td>
                  <td style="padding:10px 14px; text-align:right; font-weight:700; color:{activeScorecard.ord_30d/30 >= activeScorecard.ord_90d/90 ? '#16a34a' : '#dc2626'}">
                    {activeScorecard.ord_30d/30 >= activeScorecard.ord_90d/90 ? '▲ +' : '▼ '}{(((activeScorecard.ord_30d/30) - (activeScorecard.ord_90d/90)) / (activeScorecard.ord_90d/90 || 1) * 100).toFixed(1)}%
                  </td>
                </tr>
                <tr style="border-bottom:1px solid var(--color-border-tertiary);">
                  <td style="padding:10px 14px; font-weight:600;">🛍️ Average Order Value (AOV)</td>
                  <td style="padding:10px 14px; text-align:right; font-weight:700; color:{activeScorecard.aov_30d >= 50000 ? '#16a34a' : activeScorecard.aov_30d >= 35000 ? '#b45309' : '#dc2626'}">Rp {activeScorecard.aov_30d?.toLocaleString('en-US')}</td>
                  <td style="padding:10px 14px; text-align:right; color:var(--color-text-secondary);">Rp {activeScorecard.aov_90d?.toLocaleString('en-US')}</td>
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
            <div class="cost-card" style="background: {branchIngredientPct30 < 25 ? 'rgba(234,179,8,0.15)' : branchIngredientPct30 <= 30 ? 'rgba(34,197,94,0.15)' : branchIngredientPct30 <= 35 ? 'rgba(234,179,8,0.15)' : 'rgba(239,68,68,0.15)'}; border-color: {branchIngredientPct30 < 25 ? 'rgba(234,179,8,0.4)' : branchIngredientPct30 <= 30 ? 'rgba(34,197,94,0.4)' : branchIngredientPct30 <= 35 ? 'rgba(234,179,8,0.4)' : 'rgba(239,68,68,0.4)'};">
              <div class="cost-label">🥩 Ingredient Costs</div>
              <div class="cost-value" style="color:{branchIngredientPct30 < 25 ? '#ea580c' : branchIngredientPct30 <= 30 ? '#16a34a' : branchIngredientPct30 <= 35 ? '#ea580c' : '#dc2626'};">{(Number(branchIngredientPct30)).toFixed(1).replace('.', ',')}%</div>
              <div class="cost-target">🎯 Target: Max 30%</div>
              <div class="progress-track">
                <div class="progress-fill" style="width:{Math.min(branchIngredientPct30 / 40 * 100, 100)}%; background:{branchIngredientPct30 < 25 ? 'linear-gradient(90deg,#f59e0b,#fde68a)' : branchIngredientPct30 <= 30 ? 'linear-gradient(90deg,#16a34a,#86efac)' : branchIngredientPct30 <= 35 ? 'linear-gradient(90deg,#f59e0b,#fde68a)' : 'linear-gradient(90deg,#ef4444,#fca5a5)'};"></div>
                <div class="progress-target" style="left:{30 / 40 * 100}%;"></div>
              </div>
              <div class="progress-scale"><span>0%</span><span>30%</span><span>40%</span></div>
              <div class="cost-note">
                <div style="font-size: 0.82rem; font-weight: 600; color: {branchIngredientPct30 < 25 ? '#ea580c' : branchIngredientPct30 <= 30 ? '#16a34a' : branchIngredientPct30 <= 35 ? '#ea580c' : '#dc2626'};">
                  {branchIngredientPct30 < 25 ? '👀 Low Cost (<25%)' : branchIngredientPct30 <= 30 ? '⭐ Ideal Zone (25-30%)' : branchIngredientPct30 <= 35 ? '⚠️ Watch Zone  (30-35%)' : '📉 Critical High (>35%)'}
                </div>
                <div style="font-size: 0.78rem; color: var(--color-text-secondary); margin-top: 4px; line-height: 1.4;">
                  {branchIngredientPct30 < 25 ? 'Ratio below target. Verify portion size consistency.' : branchIngredientPct30 <= 30 ? 'Efficient ratio. Maintain current recipe standards.' : branchIngredientPct30 <= 35 ? 'Ratio is rising. Review daily ingredient usage.' : 'Ratio above standard. Check for waste or procurement issues.'}
                </div>
                <div style="margin-top: 8px;">
                  {#if branchIngredientPct30 > branchIngredientPct90}
                    <span class="trend-indicator down">▲ +{String((branchIngredientPct30 - branchIngredientPct90).toFixed(1)).replace('.', ',')}%</span>
                  {:else if branchIngredientPct30 < branchIngredientPct90}
                    <span class="trend-indicator up">▼ {String((branchIngredientPct90 - branchIngredientPct30).toFixed(1)).replace('.', ',')}%</span>
                  {:else}
                    <span class="trend-indicator neutral">0,0%</span>
                  {/if}
                  <span style="font-size: 0.78rem; color: var(--color-text-secondary);"> vs 90 Day Baseline</span>
                </div>
              </div>
            </div>

            <!-- Labor Card -->
            <div class="cost-card" style="background: {branchLaborPct30 < 15 ? 'rgba(239,68,68,0.15)' : branchLaborPct30 < 20 ? 'rgba(234,179,8,0.15)' : branchLaborPct30 <= 30 ? 'rgba(34,197,94,0.15)' : branchLaborPct30 <= 35 ? 'rgba(234,179,8,0.15)' : 'rgba(239,68,68,0.15)'}; border-color: {branchLaborPct30 < 15 ? 'rgba(239,68,68,0.4)' : branchLaborPct30 < 20 ? 'rgba(234,179,8,0.4)' : branchLaborPct30 <= 30 ? 'rgba(34,197,94,0.4)' : branchLaborPct30 <= 35 ? 'rgba(234,179,8,0.4)' : 'rgba(239,68,68,0.4)'};">
              <div class="cost-label">👥 Labor Costs</div>
              <div class="cost-value" style="color:{branchLaborPct30 < 15 ? '#dc2626' : branchLaborPct30 < 20 ? '#ea580c' : branchLaborPct30 <= 30 ? '#16a34a' : branchLaborPct30 <= 35 ? '#ea580c' : '#dc2626'};">{(Number(branchLaborPct30)).toFixed(1).replace('.', ',')}%</div>
              <div class="cost-target">🎯 Target: Max 30%</div>
              <div class="progress-track">
                <div class="progress-fill" style="width:{Math.min(branchLaborPct30 / 35 * 100, 100)}%; background:{branchLaborPct30 < 15 ? 'linear-gradient(90deg,#ef4444,#fca5a5)' : branchLaborPct30 < 20 ? 'linear-gradient(90deg,#f59e0b,#fde68a)' : branchLaborPct30 <= 30 ? 'linear-gradient(90deg,#16a34a,#86efac)' : branchLaborPct30 <= 35 ? 'linear-gradient(90deg,#f59e0b,#fde68a)' : 'linear-gradient(90deg,#ef4444,#fca5a5)'};"></div>
                <div class="progress-target" style="left:{30 / 35 * 100}%;"></div>
              </div>
              <div class="progress-scale"><span>0%</span><span>30%</span><span>35%</span></div>
              <div class="cost-note">
                <div style="font-size: 0.82rem; font-weight: 600; color: {branchLaborPct30 < 15 ? '#dc2626' : branchLaborPct30 < 20 ? '#ea580c' : branchLaborPct30 <= 30 ? '#16a34a' : branchLaborPct30 <= 35 ? '#ea580c' : '#dc2626'};">
                  {branchLaborPct30 < 15 ? '🚨 Critical Low (<15%)' : branchLaborPct30 < 20 ? '👀 Low Cost (15-20%)' : branchLaborPct30 <= 30 ? '⭐ Ideal Zone (20-30%)' : branchLaborPct30 <= 35 ? '⚠️ Watch Zone (30-35%)' : '📉 Critical High (>35%)'}
                </div>
                <div style="font-size: 0.78rem; color: var(--color-text-secondary); margin-top: 4px; line-height: 1.4;">
                  {branchLaborPct30 < 15 ? 'Ratio is very low. Operational and service risks increase.' : branchLaborPct30 < 20 ? 'Ratio below target. Watch for potential staff burnout.' : branchLaborPct30 <= 30 ? 'Staff expenditure is efficient. Maintain productivity.' : branchLaborPct30 <= 35 ? 'Ratio is rising. Review overtime and shift schedules.' : 'High labor cost. Evaluate team structure and shift efficiency.'}
                </div>
                <div style="margin-top: 8px;">
                  {#if branchLaborPct30 > branchLaborPct90}
                    <span class="trend-indicator down">▲ +{String((branchLaborPct30 - branchLaborPct90).toFixed(1)).replace('.', ',')}%</span>
                  {:else if branchLaborPct30 < branchLaborPct90}
                    <span class="trend-indicator up">▼ {String((branchLaborPct90 - branchLaborPct30).toFixed(1)).replace('.', ',')}%</span>
                  {:else}
                    <span class="trend-indicator neutral">0,0%</span>
                  {/if}
                  <span style="font-size: 0.78rem; color: var(--color-text-secondary);"> vs 90 Day Baseline</span>
                </div>
              </div>
            </div>

            <!-- Overhead Card -->
            <div class="cost-card" style="background: {branchOverheadPct30 < 25 ? 'rgba(234,179,8,0.15)' : branchOverheadPct30 <= 30 ? 'rgba(34,197,94,0.15)' : branchOverheadPct30 <= 35 ? 'rgba(234,179,8,0.15)' : 'rgba(239,68,68,0.15)'}; border-color: {branchOverheadPct30 < 25 ? 'rgba(234,179,8,0.4)' : branchOverheadPct30 <= 30 ? 'rgba(34,197,94,0.4)' : branchOverheadPct30 <= 35 ? 'rgba(234,179,8,0.4)' : 'rgba(239,68,68,0.4)'};">
              <div class="cost-label">⚙️ Overhead Costs</div>
              <div class="cost-value" style="color:{branchOverheadPct30 < 25 ? '#ea580c' : branchOverheadPct30 <= 30 ? '#16a34a' : branchOverheadPct30 <= 35 ? '#ea580c' : '#dc2626'};">{(Number(branchOverheadPct30)).toFixed(1).replace('.', ',')}%</div>
              <div class="cost-target">🎯 Target: Max 30%</div>
              <div class="progress-track">
                <div class="progress-fill" style="width:{Math.min(branchOverheadPct30 / 40 * 100, 100)}%; background:{branchOverheadPct30 < 25 ? 'linear-gradient(90deg,#f59e0b,#fde68a)' : branchOverheadPct30 <= 30 ? 'linear-gradient(90deg,#16a34a,#86efac)' : branchOverheadPct30 <= 35 ? 'linear-gradient(90deg,#f59e0b,#fde68a)' : 'linear-gradient(90deg,#ef4444,#fca5a5)'};"></div>
                <div class="progress-target" style="left:{30 / 40 * 100}%;"></div>
              </div>
              <div class="progress-scale"><span>0%</span><span>30%</span><span>40%</span></div>
              <div class="cost-note">
                <div style="font-size: 0.82rem; font-weight: 600; color: {branchOverheadPct30 < 25 ? '#ea580c' : branchOverheadPct30 <= 30 ? '#16a34a' : branchOverheadPct30 <= 35 ? '#ea580c' : '#dc2626'};">
                  {branchOverheadPct30 < 25 ? '👀 Low Cost (<25%)' : branchOverheadPct30 <= 30 ? '⭐ Ideal Zone (25-30%)' : branchOverheadPct30 <= 35 ? '⚠️ Watch Zone (30-35%)' : '📉 Critical High (>35%)'}
                </div>
                <div style="font-size: 0.78rem; color: var(--color-text-secondary); margin-top: 4px; line-height: 1.4;">
                  {branchOverheadPct30 < 25 ? 'Ratio below target. Review maintenance cost allocations.' : branchOverheadPct30 <= 30 ? 'Overhead cost is efficient. Maintain current setup.' : branchOverheadPct30 <= 35 ? 'Ratio is rising. Review monthly utility and vendor bills.' : 'High overhead cost. Audit non-essential spending.'}
                </div>
                <div style="margin-top: 8px;">
                  {#if branchOverheadPct30 > branchOverheadPct90}
                    <span class="trend-indicator down">▲ +{String((branchOverheadPct30 - branchOverheadPct90).toFixed(1)).replace('.', ',')}%</span>
                  {:else if branchOverheadPct30 < branchOverheadPct90}
                    <span class="trend-indicator up">▼ {String((branchOverheadPct90 - branchOverheadPct30).toFixed(1)).replace('.', ',')}%</span>
                  {:else}
                    <span class="trend-indicator neutral">0,0%</span>
                  {/if}
                  <span style="font-size: 0.78rem; color: var(--color-text-secondary);"> vs 90 Day Baseline</span>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Kaidah Teori -->
          <div class="risk-funfact" style="margin-top: 16px; margin-bottom: 12px;">
            <span class="risk-funfact-icon">📎</span>
            <div class="risk-funfact-content">
              <span>The 30% target benchmark is based on the <strong>30-30-30-10 financial rule</strong> (30% Ingredients, 30% Labor, 30% Overhead, 10% Operating Margin).</span>
              <cite style="font-size: 0.7rem; color: var(--color-text-secondary); font-style: italic;">Source: National Restaurant Association Industry Benchmarks</cite>
            </div>
          </div>

          <!-- Edukasi Underbudget -->
          <details class="guide-acc" style="margin-bottom: 20px;">
            <summary>💡 Risk of False Efficiency (Under-Budgeting)</summary>
            <div class="guide-body">
              <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
                Operating significantly below target thresholds (&lt;25% for COGS, &lt;15% for Labor) rarely indicates true efficiency. Beware of these hidden operational risks:
              </p>
              <div class="guide-grid" style="grid-template-columns: repeat(3, minmax(0, 1fr));">
                <div class="guide-card blue">
                  <div class="guide-card-icon">🥩</div>
                  <div class="guide-card-content">
                    <div class="guide-card-label">COGS &amp; Food Cost</div>
                    <h4 class="guide-card-title">Phantom Margin Risk</h4>
                    <p class="guide-card-desc">Watch out for portion skimping by kitchen staff to cover inventory loss, or unauthorized ingredient specification downgrades by suppliers.</p>
                  </div>
                </div>
                <div class="guide-card orange">
                  <div class="guide-card-icon">👥</div>
                  <div class="guide-card-content">
                    <div class="guide-card-label">Labor Cost</div>
                    <h4 class="guide-card-title">Understaffing Bottlenecks</h4>
                    <p class="guide-card-desc">Service fulfillment times slow down sharply, order error rates spike, and core staff face burnout and elevated turnover risks.</p>
                  </div>
                </div>
                <div class="guide-card teal">
                  <div class="guide-card-icon">⚙️</div>
                  <div class="guide-card-content">
                    <div class="guide-card-label">Operational &amp; Overhead</div>
                    <h4 class="guide-card-title">Facility Degradation</h4>
                    <p class="guide-card-desc">Deferring sanitation, HVAC maintenance, or dining ware replacement permanently degrades customer perception and guest retention.</p>
                  </div>
                </div>
              </div>
            </div>
          </details>

          <!-- NEW SECTION: COST COMPOSITION STRUCTURE -->
          <div class="diagnostics-header" style="margin-top: 40px; margin-bottom: 24px;">
            <div class="diagnostics-eyebrow">🧬 COST COMPOSITION STRUCTURE</div>
            <h2 class="diagnostics-title">Branch Cost Structure &amp; Breakdown</h2>
            <p class="diagnostics-copy">Dissect primary cost drivers (COGS, Labor, Overhead) to identify specific line items requiring immediate optimization.</p>
          </div>

          <div class="data-wrapper" style="margin-bottom: 40px;">
            <Tabs id="komposisi_biaya" fullWidth=true>
              
              <Tab label="⚙️ Operations (Overhead)">
                {#if selectedBranch}
                  {@const activeCost = branch_cost_periods.find(row => row.branch_name === selectedBranch) || {}}
                  {@const totalOps = activeCost.overhead_30d || 0}
                  {@const opsSewa = totalOps * 0.535}
                  {@const opsElectricity = totalOps * 0.285}
                  {@const opsWater = totalOps * 0.132}
                  {@const opsLainnya = totalOps * 0.048}

                  <div class="interactive-card" style="padding: 24px; margin-top: 16px;">
                    <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 16px;">
                      <div style="font-weight: 700; color: var(--color-text-primary); font-size: 1.1rem;">Total Overhead Costs (30 Days)</div>
                      <div style="font-size: 1.2rem; color: var(--color-text-primary); font-weight: 800;">Rp {Math.round(totalOps).toLocaleString('en-US')}</div>
                    </div>
                    
                    <div style="display: flex; height: 32px; border-radius: 8px; overflow: hidden; margin-bottom: 20px; box-shadow: inset 0 1px 3px rgba(0,0,0,0.1);">
                      <div style="width: 53.5%; background: linear-gradient(90deg, #3b82f6, #60a5fa); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.8rem; font-weight: 700;" title="Building Rent: Rp {Math.round(opsSewa).toLocaleString('en-US')}">53.5%</div>
                      <div style="width: 28.5%; background: linear-gradient(90deg, #f59e0b, #fbbf24); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.8rem; font-weight: 700;" title="Electricity: Rp {Math.round(opsElectricity).toLocaleString('en-US')}">28.5%</div>
                      <div style="width: 13.2%; background: linear-gradient(90deg, #10b981, #34d399); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.8rem; font-weight: 700;" title="Water: Rp {Math.round(opsWater).toLocaleString('en-US')}">13.2%</div>
                      <div style="width: 4.8%; background: linear-gradient(90deg, #8b5cf6, #a78bfa); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.8rem; font-weight: 700;" title="Others: Rp {Math.round(opsLainnya).toLocaleString('en-US')}">4.8%</div>
                    </div>
                    
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; font-size: 0.9rem; color: var(--color-text-secondary);">
                      <div style="display: flex; align-items: center; gap: 8px;">
                        <div style="width: 14px; height: 14px; border-radius: 4px; background: #3b82f6;"></div>
                        <div style="flex: 1;">Building Rent</div>
                        <div style="font-weight: 700; color: var(--color-text-primary);">Rp {Math.round(opsSewa).toLocaleString('en-US')}</div>
                      </div>
                      <div style="display: flex; align-items: center; gap: 8px;">
                        <div style="width: 14px; height: 14px; border-radius: 4px; background: #f59e0b;"></div>
                        <div style="flex: 1;">Electricity</div>
                        <div style="font-weight: 700; color: var(--color-text-primary);">Rp {Math.round(opsElectricity).toLocaleString('en-US')}</div>
                      </div>
                      <div style="display: flex; align-items: center; gap: 8px;">
                        <div style="width: 14px; height: 14px; border-radius: 4px; background: #10b981;"></div>
                        <div style="flex: 1;">Water</div>
                        <div style="font-weight: 700; color: var(--color-text-primary);">Rp {Math.round(opsWater).toLocaleString('en-US')}</div>
                      </div>
                      <div style="display: flex; align-items: center; gap: 8px;">
                        <div style="width: 14px; height: 14px; border-radius: 4px; background: #8b5cf6;"></div>
                        <div style="flex: 1;">Others (Marketing, etc)</div>
                        <div style="font-weight: 700; color: var(--color-text-primary);">Rp {Math.round(opsLainnya).toLocaleString('en-US')}</div>
                      </div>
                    </div>
                  </div>
                {/if}
              </Tab>
              
              <Tab label="🥩 Ingredients (COGS)">
                {#if selectedBranch}
                  {@const activeCost = branch_cost_periods.find(row => row.branch_name === selectedBranch) || {}}
                  {@const totalCogs = activeCost.ingr_30d || 0}
                  {@const cogsProtein = totalCogs * 0.45}
                  {@const cogsSayur = totalCogs * 0.30}
                  {@const cogsKemasan = totalCogs * 0.15}
                  {@const cogsLainnya = totalCogs * 0.10}

                  <div class="interactive-card" style="padding: 24px; margin-top: 16px;">
                    <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 16px;">
                      <div style="font-weight: 700; color: var(--color-text-primary); font-size: 1.1rem;">Total Ingredient Costs (30 Days)</div>
                      <div style="font-size: 1.2rem; color: var(--color-text-primary); font-weight: 800;">Rp {Math.round(totalCogs).toLocaleString('en-US')}</div>
                    </div>
                    
                    <div style="display: flex; height: 32px; border-radius: 8px; overflow: hidden; margin-bottom: 20px; box-shadow: inset 0 1px 3px rgba(0,0,0,0.1);">
                      <div style="width: 45%; background: linear-gradient(90deg, #ef4444, #f87171); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.8rem; font-weight: 700;" title="Meat & Protein: Rp {Math.round(cogsProtein).toLocaleString('en-US')}">45%</div>
                      <div style="width: 30%; background: linear-gradient(90deg, #10b981, #34d399); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.8rem; font-weight: 700;" title="Vegetables & Spices: Rp {Math.round(cogsSayur).toLocaleString('en-US')}">30%</div>
                      <div style="width: 15%; background: linear-gradient(90deg, #f59e0b, #fbbf24); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.8rem; font-weight: 700;" title="Packaging: Rp {Math.round(cogsKemasan).toLocaleString('en-US')}">15%</div>
                      <div style="width: 10%; background: linear-gradient(90deg, #6b7280, #9ca3af); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.8rem; font-weight: 700;" title="Oil & Others: Rp {Math.round(cogsLainnya).toLocaleString('en-US')}">10%</div>
                    </div>
                    
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; font-size: 0.9rem; color: var(--color-text-secondary);">
                      <div style="display: flex; align-items: center; gap: 8px;">
                        <div style="width: 14px; height: 14px; border-radius: 4px; background: #ef4444;"></div>
                        <div style="flex: 1;">Meat & Protein</div>
                        <div style="font-weight: 700; color: var(--color-text-primary);">Rp {Math.round(cogsProtein).toLocaleString('en-US')}</div>
                      </div>
                      <div style="display: flex; align-items: center; gap: 8px;">
                        <div style="width: 14px; height: 14px; border-radius: 4px; background: #10b981;"></div>
                        <div style="flex: 1;">Vegetables & Spices</div>
                        <div style="font-weight: 700; color: var(--color-text-primary);">Rp {Math.round(cogsSayur).toLocaleString('en-US')}</div>
                      </div>
                      <div style="display: flex; align-items: center; gap: 8px;">
                        <div style="width: 14px; height: 14px; border-radius: 4px; background: #f59e0b;"></div>
                        <div style="flex: 1;">Packaging</div>
                        <div style="font-weight: 700; color: var(--color-text-primary);">Rp {Math.round(cogsKemasan).toLocaleString('en-US')}</div>
                      </div>
                      <div style="display: flex; align-items: center; gap: 8px;">
                        <div style="width: 14px; height: 14px; border-radius: 4px; background: #6b7280;"></div>
                        <div style="flex: 1;">Oil & Others</div>
                        <div style="font-weight: 700; color: var(--color-text-primary);">Rp {Math.round(cogsLainnya).toLocaleString('en-US')}</div>
                      </div>
                    </div>
                  </div>
                {/if}
              </Tab>

              <Tab label="👥 Labor (Payroll)">
                {#if selectedBranch}
                  {@const activeCost = branch_cost_periods.find(row => row.branch_name === selectedBranch) || {}}
                  {@const totalLabor = activeCost.labor_30d || 0}
                  {@const laborPokok = totalLabor * 0.65}
                  {@const laborLembur = totalLabor * 0.20}
                  {@const laborBonus = totalLabor * 0.15}

                  <div class="interactive-card" style="padding: 24px; margin-top: 16px;">
                    <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 16px;">
                      <div style="font-weight: 700; color: var(--color-text-primary); font-size: 1.1rem;">Total Labor Costs (30 Days)</div>
                      <div style="font-size: 1.2rem; color: var(--color-text-primary); font-weight: 800;">Rp {Math.round(totalLabor).toLocaleString('en-US')}</div>
                    </div>
                    
                    <div style="display: flex; height: 32px; border-radius: 8px; overflow: hidden; margin-bottom: 20px; box-shadow: inset 0 1px 3px rgba(0,0,0,0.1);">
                      <div style="width: 65%; background: linear-gradient(90deg, #3b82f6, #60a5fa); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.8rem; font-weight: 700;" title="Base Salary: Rp {Math.round(laborPokok).toLocaleString('en-US')}">65%</div>
                      <div style="width: 20%; background: linear-gradient(90deg, #f43f5e, #fb7185); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.8rem; font-weight: 700;" title="Overtime Pay: Rp {Math.round(laborLembur).toLocaleString('en-US')}">20%</div>
                      <div style="width: 15%; background: linear-gradient(90deg, #8b5cf6, #a78bfa); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.8rem; font-weight: 700;" title="Bonus & Allowance: Rp {Math.round(laborBonus).toLocaleString('en-US')}">15%</div>
                    </div>
                    
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; font-size: 0.9rem; color: var(--color-text-secondary);">
                      <div style="display: flex; align-items: center; gap: 8px;">
                        <div style="width: 14px; height: 14px; border-radius: 4px; background: #3b82f6;"></div>
                        <div style="flex: 1;">Base Salary</div>
                        <div style="font-weight: 700; color: var(--color-text-primary);">Rp {Math.round(laborPokok).toLocaleString('en-US')}</div>
                      </div>
                      <div style="display: flex; align-items: center; gap: 8px;">
                        <div style="width: 14px; height: 14px; border-radius: 4px; background: #f43f5e;"></div>
                        <div style="flex: 1;">Overtime Pay</div>
                        <div style="font-weight: 700; color: var(--color-text-primary);">Rp {Math.round(laborLembur).toLocaleString('en-US')}</div>
                      </div>
                      <div style="display: flex; align-items: center; gap: 8px;">
                        <div style="width: 14px; height: 14px; border-radius: 4px; background: #8b5cf6;"></div>
                        <div style="flex: 1;">Bonus & Allowance</div>
                        <div style="font-weight: 700; color: var(--color-text-primary);">Rp {Math.round(laborBonus).toLocaleString('en-US')}</div>
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
        eyebrow="📑 Supporting Data Room"
        title="Extra Data Center &amp; Strategic Perspectives"
        description="Use the additional lenses below to dissect revenue drivers and track long-term financial health trajectories (Quarterly &amp; YoY)."
      />

      <div class="data-wrapper">
      <Tabs id="data_pendukung_tabs" fullWidth=true>

        <Tab label="🍕 Revenue Engine (30 Days)">
          {#if selectedBranch}
            {@const filteredMenu = branch_menu_detail_30d.filter(row => row.branch_name === selectedBranch)}
            {@const totalRev = branch_category_mix.filter(row => row.branch_name === selectedBranch).reduce((sum, row) => sum + row.total_rev, 0)}
            {@const top3Rev = filteredMenu.slice(0, 3).reduce((sum, row) => sum + row.revenue_current, 0)}
            {@const top3Pct = totalRev > 0 ? (top3Rev / totalRev) * 100 : 0}
            {@const tableData = filteredMenu.map(row => ({...row, qty_diff: row.qty_current - row.qty_previous})).sort((a,b) => Math.abs(b.qty_diff) - Math.abs(a.qty_diff))}

            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 16px; margin-bottom: 16px;">
              <div style="padding: 8px 0;">
                <BarChart 
                  data={branch_category_mix.filter(row => row.branch_name === selectedBranch)} 
                  x="category" 
                  y="total_rev" 
                  swapXY=true
                  title="Revenue Composition by Category" 
                  yFmt="Rp #,##0"
                  sort="total_rev"
                  colorPalette={['#10b981', '#3b82f6', '#f59e0b', '#8b5cf6']}
                />
              </div>
              
              <div style="padding: 8px 0;">
                <BarChart 
                  data={filteredMenu.slice(0, 10).map(d => ({ ...d, Revenue: d.revenue_current }))} 
                  x="menu_name" 
                  y="Revenue" 
                  swapXY=true 
                  title="Top 10 Menu Revenue (Rp)" 
                  yFmt="Rp #,##0"
                  sort="Revenue"
                />
              </div>
            </div>

            <div class="chart-insight" style="margin-top: 16px; margin-bottom: 24px;">
              📌 <strong>Supply Chain Exposure:</strong> Because the Top 5 items generate the bulk of total revenue, maintaining uninterrupted raw material availability is critical to prevent severe stockout losses.
            </div>

            <div style="margin-bottom: 24px; padding: 8px 0;">
              <h4 style="margin-top: 0; margin-bottom: 4px; font-weight: 700; font-size: 1.1rem; color: var(--color-text-primary);">📈 Top Menu Sales Shifts (MoM)</h4>
              <p style="margin-top: 0; margin-bottom: 16px; font-size: 0.9rem; color: var(--color-text-secondary);">Which menus experienced the biggest trend changes?<br/>Showing menus with the biggest sales percentage surges and declines this month.</p>
              <DataTable data={tableData} rows=6>
                <Column id="menu_name" title="Menu"/>
                <Column id="qty_previous" title="Before" fmt="#,##0"/>
                <Column id="qty_current" title="Now" fmt="#,##0"/>
                <Column id="qty_diff" title="Difference" contentType="delta"/>
              </DataTable>
              <div class="chart-insight" style="margin-top: 16px;">
                📌 <strong>Validating Sales Shifts:</strong> Cross-reference percentage spikes on the chart with absolute figures in the table to distinguish high-impact volume movers from low-baseline percentage anomalies.
              </div>
            </div>
          {/if}
        </Tab>

        <Tab label="📊 Strategic Performance Trends (Quarterly &amp; YoY)">
          <div style="margin-top: 16px;">
            <!-- Evaluasi Jangka Menengah (Kuartal QoQ) -->
            <div style="margin-bottom: 32px; padding: 8px 0;">
              <h4 style="margin-top: 0; margin-bottom: 16px; font-weight: 700; font-size: 1.1rem; color: var(--color-text-primary);">📊 Quarter Report &middot; Read Seasonal Phenomenon</h4>
              <div style="margin-bottom: 20px;">
                <BarChart 
                  data={branch_quarterly_report.filter(row => row.branch_name === selectedBranch).slice().reverse()} 
                  x="quarter_name" 
                  y={["gross_revenue", "net_revenue"]} 
                  type="grouped" 
                  title="Revenue vs Net Profit Development per Quarter" 
                  yFmt="Rp #,##0"
                  xAxisTitle="Quarter"
                  yAxisTitle="Value (Rp)"
                  sort=false
                />
              </div>
              <div class="table-scroll-container">
                <table class="markdown">
                  <thead>
                    <tr>
                      <th class="markdown" style="text-align: left;">Quarter</th>
                      <th class="markdown" style="text-align: right;">Gross Revenue (Rp)</th>
                      <th class="markdown" style="text-align: right;">Net Profit (Rp)</th>
                      <th class="markdown" style="text-align: right;">Net Margin</th>
                    </tr>
                  </thead>
                  <tbody>
                    {#each branch_quarterly_report.filter(row => row.branch_name === selectedBranch) || [] as row}
                    <tr>
                      <td class="markdown" style="text-align: left; font-weight: 600;">{row.quarter_name}</td>
                      <td class="markdown" style="text-align: right;">{row.gross_revenue !== undefined && row.gross_revenue !== null ? row.gross_revenue.toLocaleString('en-US') : '0'}</td>
                      <td class="markdown" style="text-align: right;">{row.net_revenue !== undefined && row.net_revenue !== null ? row.net_revenue.toLocaleString('en-US', {maximumFractionDigits: 0}) : '0'}</td>
                      <td class="markdown" style="text-align: right; font-weight: 600; color:{row.net_margin_pct >= 10 ? '#16a34a' : row.net_margin_pct >= 5 ? '#ca8a04' : '#dc2626'}">
                        {row.net_margin_pct !== undefined && row.net_margin_pct !== null ? row.net_margin_pct.toFixed(1) + '%' : '0.0%'}
                      </td>
                    </tr>
                    {/each}
                  </tbody>
                </table>
              </div>
              <div class="chart-insight" style="margin-top: 12px;">
                📌 <strong>Quarterly Analysis:</strong> Helps identify seasonal factors (seasonality) and net profit stability per quarter consistently.
              </div>
            </div>

            <!-- Tren Jangka Panjang & YoY (Historis) -->
            <div style="margin-bottom: 16px; padding: 8px 0;">
              <h4 style="margin-top: 0; margin-bottom: 16px; font-weight: 700; font-size: 1.1rem; color: var(--color-text-primary);">📈 Long-term Trends &amp; YoY (Historical)</h4>
              <div style="margin-bottom: 20px;">
                <LineChart 
                  data={branch_yoy_report.filter(row => row.branch_name === selectedBranch).slice().reverse()} 
                  x="yr" 
                  y="net_margin_pct" 
                  title="Annual Net Margin Trends (YoY)" 
                  yFmt="0.0\%"
                  xAxisTitle="Year"
                  yAxisTitle="Margin (%)"
                  sort=false
                >
                  <ReferenceLine y={10} label="Healthy Target 10%" lineType="dashed" color="#10B981" />
                  <ReferenceLine y={5} label="Warning 5%" lineType="dashed" color="#F97316" />
                </LineChart>
              </div>
              <DataTable data={branch_yoy_report.filter(row => row.branch_name === selectedBranch)} rows=8>
                <Column id="yr" title="Year" fmt="0"/>
                <Column id="gross_revenue" title="Gross Revenue" fmt="Rp #,##0"/>
                <Column id="net_revenue" title="Net Profit" fmt="Rp #,##0"/>
                <Column id="net_margin_pct" title="Margin" fmt="0.0\%"/>
              </DataTable>

              <div style="margin-top: 16px; padding: 12px; border: 1px solid var(--color-border-tertiary); border-radius: 8px; background: var(--color-background-secondary); font-size: 0.82rem; line-height: 1.6; color:var(--color-text-primary);">
                🏷️ <strong>Location Historical Statistics:</strong><br/>
                • First Transaction Date: <strong>{activeScorecard.first_metric_date}</strong><br/>
                • Historical Average Net Margin: <strong>{activeScorecard.margin_historical?.toFixed(1)}%</strong>
              </div>
              
              <div class="chart-insight" style="margin-top: 12px;">
                📌 <strong>YoY Analysis:</strong> Provides a macro view on whether this location is fundamentally growing, stable, or slowing down year over year.
              </div>
            </div>
          </div>
        </Tab>

      </Tabs>
      </div>

  {:else}
    <SectionCard 
      eyebrow="⚠️ Insufficient Diagnostic Data"
      title="TDetailed Analysis Unavailable for This Location"
      description="Select another branch or ensure that revenue and expense data for this location are fully aggregated within the 30 to 90-day horizon."
    />
  {/if}

</div>

{:else}
  <GlobalLoading />
{/if}

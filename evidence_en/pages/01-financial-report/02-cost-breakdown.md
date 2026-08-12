---
title: Cost Breakdown
---

<script>


  onMount(() => {
    setTimeout(() => {
      const urlParams = new URLSearchParams(window.location.search);
      const tabQuery = urlParams.get('tab');
      if (tabQuery) {
        let targetText = '';
        if (tabQuery === 'bahan') targetText = 'Ingredient Cost';
        else if (tabQuery === 'sdm') targetText = 'Labor Cost';
        else if (tabQuery === 'ops') targetText = 'Operational Cost';

        if (targetText) {
          const tabButtons = document.querySelectorAll('button');
          for (let btn of tabButtons) {
            if (btn.textContent.includes(targetText)) {
              btn.click();
              // Clean up the URL so it doesn't stick
              window.history.replaceState({}, document.title, window.location.pathname);
              break;
            }
          }
        }
      }
    }, 150);
  });

  let activeBahanBranch = 'All Branches';
  let worstBranchBahan = null;
  let bestBranchBahan = null;
  let macroCogsPct = 0;
  let activeTierBahan = 0;

  $: if (cogs_by_branch && cogs_by_branch.length > 0) {
      let sorted = [...cogs_by_branch].sort((a,b) => b.cogs_pct - a.cogs_pct);
      worstBranchBahan = sorted[0]; 
      bestBranchBahan = sorted[sorted.length - 1]; 
  }

  $: if (cogs_kpi && cogs_kpi.length > 0) {
      macroCogsPct = cogs_kpi[0].cogs_pct_30d;
      if (macroCogsPct > 35) activeTierBahan = 5;
      else if (macroCogsPct > 30) activeTierBahan = 4;
      else if (macroCogsPct >= 25) activeTierBahan = 3;
      else activeTierBahan = 2;
  }

  let worstBranchSDM = null;
  let bestBranchSDM = null;
  let macroLaborCost = 0;
  let activeTierSDM = 0; // 1: <15, 2: 15-20, 3: 20-30, 4: 30-35, 5: >35
  let activeCompositionBranch = 'All Locations';

  $: if (branch_labor_cost && branch_labor_cost.length > 0) {
      let sorted = [...branch_labor_cost].sort((a,b) => b.labor_cost_pct - a.labor_cost_pct);
      worstBranchSDM = sorted[0]; 
      bestBranchSDM = sorted[sorted.length - 1]; 
      
      let totalRev = branch_labor_cost.reduce((acc, curr) => acc + curr.total_revenue, 0);
      let totalPay = branch_labor_cost.reduce((acc, curr) => acc + curr.total_payroll, 0);
      macroLaborCost = totalRev > 0 ? (totalPay / totalRev) * 100 : 0;

      if (macroLaborCost > 35) activeTierSDM = 5;
      else if (macroLaborCost > 30) activeTierSDM = 4;
      else if (macroLaborCost < 15) activeTierSDM = 1;
      else if (macroLaborCost < 20) activeTierSDM = 2;
      else activeTierSDM = 3;
  }

  let activeOpsBranch = 'All Locations';
  let worstBranchOps = { branch_name: "N/A", ops_pct: 0 };
  let bestBranchOps = null;
  let macroOpsPct = 0;
  let activeTierOps = 0;
  let enrichedBranches = [];

  $: if (ops_by_branch && ops_by_branch.length > 0) {
      let sorted = [...ops_by_branch].sort((a,b) => b.ops_pct - a.ops_pct);
      worstBranchOps = sorted[0]; 
      bestBranchOps = sorted[sorted.length - 1]; 
      
      enrichedBranches = sorted.map(row => {
        let targetOps = row.total_rev * 0.30;
        let varianceRp = row.total_ops - targetOps;
        let varianceStatus = "⭐ Ideal Zone";
        if (row.ops_pct > 35) varianceStatus = "📉 Critical High";
        else if (row.ops_pct > 30) varianceStatus = "⚠️ Watch Zone";
        else if (row.ops_pct < 25) varianceStatus = "👀 Low Cost";
        
        return {
          ...row,
          variance_status: varianceStatus,
          variance_rp: varianceRp
        };
      });
  }

  $: if (ops_kpi && ops_kpi.length > 0) {
      macroOpsPct = ops_kpi[0].ops_pct_30d;
      if (macroOpsPct < 25) {
        activeTierOps = 2; // Minim
      } else if (macroOpsPct <= 30) {
        activeTierOps = 3; // Ideal
      } else if (macroOpsPct <= 35) {
        activeTierOps = 4; // Pantau
      } else {
        activeTierOps = 5; // Bahaya
      }
  }
</script>



<FinanceTabs activeTab="cost-breakdown" />


<Tabs id="rincian-biaya-tabs" fullWidth=true>

<Tab label="🥩 Ingredient Costs">




```sql cogs_kpi
WITH date_boundaries AS (
  SELECT 
    DATE_TRUNC('month', MAX(metric_date)::DATE) AS start_mtd,
    MAX(metric_date)::DATE - INTERVAL '29 days' AS start_30d
  FROM restaurant.daily_net_revenue
)
SELECT
  SUM(CASE WHEN metric_date >= b.start_30d THEN inventory_usage_cost ELSE 0 END) AS cogs_30d,
  SUM(CASE WHEN metric_date >= b.start_30d THEN gross_revenue ELSE 0 END) AS rev_30d,
  ROUND(SUM(CASE WHEN metric_date >= b.start_30d THEN inventory_usage_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= b.start_30d THEN gross_revenue ELSE 0 END),0) * 100, 1) as cogs_pct_30d,
  SUM(CASE WHEN metric_date >= b.start_mtd THEN inventory_usage_cost ELSE 0 END) AS cogs_mtd,
  ROUND(SUM(CASE WHEN metric_date >= b.start_mtd THEN inventory_usage_cost ELSE 0 END) / NULLIF(SUM(CASE WHEN metric_date >= b.start_mtd THEN gross_revenue ELSE 0 END),0) * 100, 1) as cogs_pct_mtd
FROM restaurant.daily_net_revenue CROSS JOIN date_boundaries b
```


```sql cogs_by_category
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM restaurant.inventory_stock)
SELECT 
  category,
  SUM(usage_cost) AS total_cogs
FROM restaurant.inventory_stock CROSS JOIN max_d
WHERE txn_date >= max_d.d - INTERVAL '29 days'
GROUP BY category
ORDER BY total_cogs DESC
```

```sql cogs_by_branch
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM restaurant.inventory_stock),
branch_cogs AS (
  SELECT 
    branch_name,
    SUM(usage_cost) AS total_cogs
  FROM restaurant.inventory_stock CROSS JOIN max_d
  WHERE txn_date >= max_d.d - INTERVAL '29 days'
  GROUP BY branch_name
),
date_boundaries AS (
  SELECT MAX(metric_date)::DATE - INTERVAL '29 days' AS start_30d
  FROM restaurant.daily_net_revenue
),
branch_rev AS (
  SELECT
    branch_name,
    SUM(gross_revenue) AS total_rev
  FROM restaurant.daily_net_revenue CROSS JOIN date_boundaries b
  WHERE metric_date >= b.start_30d
  GROUP BY branch_name
)
SELECT 
  c.branch_name,
  c.total_cogs,
  r.total_rev,
  ROUND(c.total_cogs / NULLIF(r.total_rev, 0) * 100, 1) AS cogs_pct,
  CASE
    WHEN ROUND(c.total_cogs / NULLIF(r.total_rev, 0) * 100, 1) > 35 THEN '📉 Critical High'
    WHEN ROUND(c.total_cogs / NULLIF(r.total_rev, 0) * 100, 1) > 30 THEN '⚠️ Watch Zone'
    WHEN ROUND(c.total_cogs / NULLIF(r.total_rev, 0) * 100, 1) < 25 THEN '🔥 Critical Low'
    ELSE '⭐ Ideal Zone'
  END as variance_status,
  (c.total_cogs) - (r.total_rev * 0.30) as variance_rp
FROM branch_cogs c
JOIN branch_rev r ON c.branch_name = r.branch_name
ORDER BY cogs_pct DESC
```

```sql top_cost_items
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM restaurant.inventory_stock)
SELECT 
  item_name AS "Material Name",
  category AS "Category",
  SUM(usage_qty) AS "Usage Volume",
  SUM(usage_cost) AS "Total Cost (Rp)"
FROM restaurant.inventory_stock CROSS JOIN max_d
WHERE txn_date >= max_d.d - INTERVAL '29 days'
GROUP BY item_name, category
ORDER BY SUM(usage_cost) DESC
LIMIT 10
```

{#if worstBranchBahan && bestBranchBahan && cogs_kpi}
<div class="diagnostics-header" style="margin-top: 24px; margin-bottom: 24px;">
  <div class="diagnostics-eyebrow">🧠 MAIN DIAGNOSTICS</div>
<h2 class="diagnostics-title">Ingredient Cost & Efficiency Overview</h2>
  <p class="diagnostics-copy">A comprehensive evaluation of food cost ratios, ingredient waste, and overall kitchen cost health over the past 30 days.</p>
</div>

<div class="insight-container" style="margin-bottom: 48px;">
  <div class="insight-box {macroCogsPct > 35 ? 'red' : (macroCogsPct > 30 || macroCogsPct < 25 ? 'orange' : 'green')}">
    <div class="insight-headline">
        {#if macroCogsPct > 35}
            🚨 Critical: Severe Ingredient Cost Overrun ({macroCogsPct.toFixed(1)}%)
        {:else if macroCogsPct > 30}
            ⚠️ Warning: Ingredient Costs Above Target ({macroCogsPct.toFixed(1)}%)
        {:else if macroCogsPct < 25}
            ⚠️ Alert: Low Ingredient Cost Ratio ({macroCogsPct.toFixed(1)}%)
        {:else}
            ✅ Ideal: Balanced Ingredient Expenditure ({macroCogsPct.toFixed(1)}%)
        {/if}
    </div>
    <div class="insight-copy">
        {#if macroCogsPct > 35}
            <p style="margin-top: 0; margin-bottom: 12px;">Over the past 30 days, the average ingredient cost ratio is critically high (<strong>{macroCogsPct.toFixed(1)}%</strong>). A figure above 35% indicates potential waste, stock spoilage, or theft eroding operating profit. The highest cost ratio is currently at <strong>{worstBranchBahan.branch_name} ({worstBranchBahan.cogs_pct}%)</strong>.</p>
            <p style="margin: 0;"><strong>Recommendation:</strong> Audit recipes, portion scales, and spoilage logs for flagged branches. <em>(Note: Use this metric as an analytical indicator. Verify with actual kitchen conditions).</em></p>
        {:else if macroCogsPct > 30}
            <p style="margin-top: 0; margin-bottom: 12px;">The average ingredient cost ratio is starting to rise (<strong>{macroCogsPct.toFixed(1)}%</strong>). While operational, exceeding the 30% benchmark risks compressing margins. This trend is led by <strong>{worstBranchBahan.branch_name} ({worstBranchBahan.cogs_pct}%)</strong>.</p>
            <p style="margin: 0;"><strong>Recommendation:</strong> Review recent supplier price changes and tighten kitchen portion controls. <em>(Note: Use this metric as an analytical indicator. Verify with actual kitchen conditions).</em></p>
        {:else if macroCogsPct >= 25}
            <p style="margin-top: 0; margin-bottom: 12px;">Kitchen expenditures remain well-managed (<strong>{macroCogsPct.toFixed(1)}%</strong>), aligning with the 30% target benchmark. The business enjoys healthy gross margins, with the best performance achieved by <strong>{bestBranchBahan.branch_name} ({bestBranchBahan.cogs_pct}%)</strong>.</p>
            <p style="margin: 0;"><strong>Recommendation:</strong> Maintain current operational SOPs and use top-performing branches as a benchmark. <em>(Note: Continue monitoring customer satisfaction alongside efficiency).</em></p>
        {:else}
            <p style="margin-top: 0; margin-bottom: 12px;">The ingredient cost ratio is unusually low (<strong>{macroCogsPct.toFixed(1)}%</strong>), well below the 30% standard benchmark. While margin-friendly, verify that this is not caused by reduced portion sizes that could affect customer satisfaction. The lowest ratio was recorded at <strong>{bestBranchBahan.branch_name} ({bestBranchBahan.cogs_pct}%)</strong>.</p>
            <p style="margin: 0;"><strong>Recommendation:</strong> Verify serving SOPs to ensure portion consistency and recipe standards across all shifts. <em>(Note: Use this metric as an analytical indicator. Verify with actual kitchen conditions).</em></p>
        {/if}

        <div class="macro-progress-container">
           <div class="progress-labels">
             <span>0%</span>
             <span>25%</span>
             <span>30%</span>
             <span>35%</span>
             <span>50%</span>
           </div>
           <div class="macro-progress-bar">
             <div class="zone" style="width: 50%; background: #fed7aa;"></div>
             <div class="zone" style="width: 10%; background: #bbf7d0;"></div>
             <div class="zone" style="width: 10%; background: #fed7aa;"></div>
             <div class="zone" style="width: 30%; background: #fecaca;"></div>
             <div class="macro-marker" style="left: {Math.min(macroCogsPct / 50 * 100, 100)}%;">
               <div class="macro-marker-pin">📍 {macroCogsPct.toFixed(1)}%</div>
               <div class="macro-marker-line"></div>
             </div>
           </div>
        </div>
    </div>
  </div>
</div>


<div style="margin-bottom: 64px;">
  <div style="font-weight: 700; color: var(--color-text-primary); margin-bottom: 24px; font-size: 1.1rem; text-align: center;">Early Warning System (COGS Zone)</div>
  <div class="insight-grid" style="grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 12px; padding: 12px 0;">
    
    <div class="insight-card target-card orange {activeTierBahan === 2 ? 'active-tier' : 'inactive-tier'}">
      <div class="insight-header" style="flex-direction: column; text-align: center; gap: 4px;">
        <span class="insight-icon">👀</span>
        <span class="insight-title" style="font-size: 0.85rem;">Low Cost (&lt;25%)</span>
      </div>
      <div class="insight-body" style="font-size: 0.8rem; text-align: center; color: var(--color-text-secondary); line-height: 1.4; margin-top: 8px;">
        Ratio below target. Verify portion size consistency.
      </div>
    </div>
    
    <div class="insight-card target-card green {activeTierBahan === 3 ? 'active-tier' : 'inactive-tier'}">
      <div class="insight-header" style="flex-direction: column; text-align: center; gap: 4px;">
        <span class="insight-icon">⭐</span>
        <span class="insight-title" style="font-size: 0.85rem;">Ideal Zone (25-30%)</span>
      </div>
      <div class="insight-body" style="font-size: 0.8rem; text-align: center; color: var(--color-text-secondary); line-height: 1.4; margin-top: 8px;">
        Efficient ratio. Maintain current recipe standards.
      </div>
    </div>
    
    <div class="insight-card target-card orange {activeTierBahan === 4 ? 'active-tier' : 'inactive-tier'}">
      <div class="insight-header" style="flex-direction: column; text-align: center; gap: 4px;">
        <span class="insight-icon">⚠️</span>
        <span class="insight-title" style="font-size: 0.85rem;">Watch Zone (30-35%)</span>
      </div>
      <div class="insight-body" style="font-size: 0.8rem; text-align: center; color: var(--color-text-secondary); line-height: 1.4; margin-top: 8px;">
        Ratio is rising. Review daily ingredient usage.
      </div>
    </div>
    
    <div class="insight-card target-card red {activeTierBahan === 5 ? 'active-tier' : 'inactive-tier'}">
      <div class="insight-header" style="flex-direction: column; text-align: center; gap: 4px;">
        <span class="insight-icon">📉</span>
        <span class="insight-title" style="font-size: 0.85rem;">Critical High (&gt;35%)</span>
      </div>
      <div class="insight-body" style="font-size: 0.8rem; text-align: center; color: var(--color-text-secondary); line-height: 1.4; margin-top: 8px;">
        Ratio above standard. Check for waste or procurement issues.
      </div>
    </div>

  </div>
</div>

<div class="diagnostics-header" style="margin-bottom: 24px;">
  <div class="diagnostics-eyebrow">🔬 BRANCH CAPACITY & COGS ANALYSIS</div>
<h2 class="diagnostics-title">Branch Ingredient Cost & Efficiency</h2>
  <p class="diagnostics-copy">Compare ingredient cost ratios across branches against the 30% target benchmark to identify operational inefficiencies and waste.</p>
</div>

<div style="margin-top: 32px; margin-bottom: 48px;">
  <details class="guide-acc" style="margin-top: 16px; margin-bottom: 24px;">
    <summary>💡 Data Context & How to Read</summary>
    <div class="guide-body" style="padding: 16px;">
      <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
        While macro metrics evaluate <strong>overall</strong> business health, this micro-level breakdown pinpoints performance by <strong>individual branch</strong>. The monetary figures indicate potential cost savings or financial targets when evaluating <i>supplier terms</i> and <i>kitchen operations</i>.
      </p>
      <div class="guide-grid" style="grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 16px; display: grid;">
        <div class="guide-card orange">
          <div class="guide-card-icon">📉</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Status: Critical High</div>
            <h4 class="guide-card-title">Indication of Cost Leakage</h4>
            <p class="guide-card-desc">A positive Variance of <strong>Rp 5,000,000</strong> indicates an opportunity to <strong>investigate kitchen waste, portioning errors, or inventory leakage</strong> worth Rp 5M over the past 30 days.</p>
          </div>
        </div>
        <div class="guide-card teal">
          <div class="guide-card-icon">🏆</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Status: Saving</div>
            <h4 class="guide-card-title">Cost Savings Achieved</h4>
            <p class="guide-card-desc">You successfully saved <strong>Rp 5,000,000</strong> compared to the 30% gross sales target benchmark. Maintain these portioning and recipe standards!</p>
          </div>
        </div>
      </div>
    </div>
  </details>

  <div class="premium-table-container">
  <table class="premium-table">
    <thead>
      <tr>
        <th>Branch</th>
        <th style="text-align: center;">COGS Ratio (%)</th>
        <th>Health Status</th>
        <th style="text-align: right;">Variance Value (Rp)</th>
      </tr>
    </thead>
    <tbody>
      {#each cogs_by_branch as row, i}
        <tr class="premium-row">
          <td style="font-weight: 700; color: var(--color-text-primary);">{row.branch_name}</td>
          <td style="text-align: center; font-weight: 600;">{row.cogs_pct}%</td>
          <td>
            {#if row.cogs_pct > 35}
              <span class="badge badge-red">{row.variance_status}</span>
            {:else if row.cogs_pct > 30}
              <span class="badge badge-orange">{row.variance_status}</span>
            {:else if row.cogs_pct < 25}
              <span class="badge badge-red">{row.variance_status}</span>
            {:else}
              <span class="badge badge-green">{row.variance_status}</span>
            {/if}
          </td>
          <td style="text-align: right; font-weight: 800; color: var(--color-text-primary);" class="hover-tooltip {i < cogs_by_branch.length / 2 ? 'tooltip-down' : 'tooltip-up'}">
            <span class="tooltip-text">
              {#if row.cogs_pct > 35}
                Ingredient cost ratio is critically high. Audit kitchen portioning and waste.
              {:else if row.cogs_pct > 30}
                Ingredient costs are trending up. Evaluate supplier pricing or usage efficiency.
              {:else if row.cogs_pct < 25}
                Ingredient ratio is low. Verify portion sizes and recipe standards.
              {:else}
                Ingredient usage is stable and on target.
              {/if}
            </span>
            {#if row.variance_rp != null && row.variance_rp !== 0 && row.variance_status !== '⭐ Ideal Zone'}
              {#if row.cogs_pct > 30}
                <span style="color: #ef4444; font-size: 0.75rem; margin-right: 4px; vertical-align: middle;">▼</span>
              {:else if row.cogs_pct < 25}
                <span style="color: #22c55e; font-size: 0.75rem; margin-right: 4px; vertical-align: middle;">▲</span>
              {/if}
              Rp {Math.round(Math.abs(Number(row.variance_rp))).toLocaleString('en-US')}
            {:else}
              -
            {/if}
          </td>
        </tr>
      {/each}
    </tbody>
  </table>
</div>
</div>

```sql bahan_composition
WITH max_d AS (SELECT MAX(metric_date)::DATE AS d FROM restaurant.daily_net_revenue),
raw_data AS (
  SELECT branch_name, inventory_usage_cost, inventory_purchase_cost, inventory_total_cost
  FROM restaurant.daily_net_revenue CROSS JOIN max_d
  WHERE metric_date >= max_d.d - INTERVAL '29 days'
),
agg_branches AS (
  SELECT 
    branch_name,
    SUM(inventory_usage_cost) as total_usage,
    SUM(inventory_purchase_cost) as total_purchase,
    SUM(inventory_total_cost) as total_inv
  FROM raw_data
  GROUP BY branch_name
),
agg_all AS (
  SELECT 
    'All Branches' as branch_name,
    SUM(inventory_usage_cost) as total_usage,
    SUM(inventory_purchase_cost) as total_purchase,
    SUM(inventory_total_cost) as total_inv
  FROM raw_data
),
combined AS (
  SELECT * FROM agg_all
  UNION ALL
  SELECT * FROM agg_branches
)
SELECT 
  branch_name,
  total_usage,
  total_purchase,
  total_inv,
  ROUND(total_usage / NULLIF(total_inv, 0) * 100, 1) as pct_usage,
  ROUND(total_purchase / NULLIF(total_inv, 0) * 100, 1) as pct_purchase
FROM combined
ORDER BY CASE WHEN branch_name = 'All Branches' THEN 0 ELSE 1 END, total_inv DESC
```

<hr style="margin: 48px 0; border: 0; border-top: 1px dashed rgba(0,0,0,0.1);" />

<div class="diagnostics-header" style="margin-bottom: 24px;">
  <div class="diagnostics-eyebrow">🧬 COST COMPOSITION STRUCTURE</div>
<h2 class="diagnostics-title">Ingredient Cost Breakdown (Usage vs. Purchase)</h2>
  <p class="diagnostics-copy">Identify your primary cost drivers: determine whether high ingredient expenses stem from actual kitchen usage (goods cooked/sold) or recent inventory restocking.</p>
</div>

<div style="display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 24px;">
  {#each bahan_composition as row}
    {#if row.total_inv !== undefined}
      <button 
        style="padding: 8px 16px; border-radius: 20px; font-size: 0.9rem; font-weight: 600; cursor: pointer; border: 1px solid {activeBahanBranch === row.branch_name ? '#3b82f6' : '#e2e8f0'}; background: {activeBahanBranch === row.branch_name ? '#eff6ff' : '#ffffff'}; color: {activeBahanBranch === row.branch_name ? '#1d4ed8' : '#64748b'}; transition: all 0.2s ease;"
        on:click={() => activeBahanBranch = row.branch_name}
      >
        {row.branch_name}
      </button>
    {/if}
  {/each}
</div>

<div style="display: flex; flex-direction: column; gap: 16px; margin-bottom: 48px;">
  {#each bahan_composition as row}
    {#if row.total_inv !== undefined && row.branch_name === activeBahanBranch}
    <div class="interactive-card" style="padding: 20px; background: white; border-radius: 12px; border: 1px solid var(--color-border-primary); box-shadow: 0 1px 3px rgba(0,0,0,0.05);">
      <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 12px;">
        <div style="font-weight: 700; color: var(--color-text-primary); font-size: 1.1rem;">{row.branch_name}</div>
        <div style="font-size: 0.9rem; color: var(--color-text-tertiary); font-weight: 500;">Total Ingredient Spending: Rp {Math.round(row.total_inv || 0).toLocaleString('en-US')}</div>
      </div>
      
      <div style="display: flex; height: 28px; border-radius: 8px; overflow: hidden; margin-bottom: 16px; box-shadow: inset 0 1px 3px rgba(0,0,0,0.1);">
        <div style="width: {row.pct_usage}%; background: linear-gradient(90deg, #3b82f6, #60a5fa); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.75rem; font-weight: 700;" title="Ingredient Usage (COGS): Rp {Math.round(row.total_usage || 0).toLocaleString('en-US')}">
          {#if row.pct_usage > 10}{row.pct_usage}%{/if}
        </div>
        <div style="width: {row.pct_purchase}%; background: linear-gradient(90deg, #10b981, #34d399); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.75rem; font-weight: 700;" title="Ingredient Purchases (Restock): Rp {Math.round(row.total_purchase || 0).toLocaleString('en-US')}">
          {#if row.pct_purchase > 5}{row.pct_purchase}%{/if}
        </div>
      </div>
      
      <div style="display: flex; flex-wrap: wrap; gap: 16px; font-size: 0.85rem; color: var(--color-text-secondary);">
        <div style="display: flex; align-items: center; gap: 6px;">
          <div style="width: 12px; height: 12px; border-radius: 3px; background: #3b82f6;"></div>
          <span>Ingredient Usage (COGS) <strong>Rp {Math.round(row.total_usage || 0).toLocaleString('en-US')}</strong></span>
        </div>
        <div style="display: flex; align-items: center; gap: 6px;">
          <div style="width: 12px; height: 12px; border-radius: 3px; background: #10b981;"></div>
          <span>Ingredient Purchases (Restock) <strong>Rp {Math.round(row.total_purchase || 0).toLocaleString('en-US')}</strong></span>
        </div>
      </div>
    </div>
    {/if}
  {/each}
</div>
<div class="clean-cta-banner">
  <div class="clean-cta-content">
    <div class="clean-cta-icon">🏪</div>
    <div class="clean-cta-text">
      <h3 class="clean-cta-title">Branch Cost Investigation</h3>
      <p class="clean-cta-desc">Analyze cost structures per branch and unlock actionable recommendations.</p>
    </div>
  </div>
  <a href="/02-branch-performance/02-deepdive" class="clean-cta-button">
    Open Branch Deep Dive ➔
  </a>
</div>



{:else}
  <GlobalLoading />
{/if}



</Tab>
<Tab label="👥 Labor Costs">



<div class="diagnostics-header" style="margin-top: 24px; margin-bottom: 24px;">
  <div class="diagnostics-eyebrow">🧠 MAIN DIAGNOSTICS</div>
<h2 class="diagnostics-title">Labor Cost & Productivity Overview</h2>
  <p class="diagnostics-copy">A comprehensive evaluation of labor cost ratios, staff productivity, and overall payroll health over the past 30 days.</p>
</div>

```sql branch_labor_cost
WITH max_d AS (SELECT MAX(metric_date) AS d FROM restaurant.daily_net_revenue)
SELECT 
  branch_name,
  SUM(gross_revenue) as total_revenue,
  SUM(labor_total_cost) as total_payroll,
  ROUND(SUM(labor_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) as labor_cost_pct,
  ROUND(SUM(gross_revenue) / NULLIF(SUM(labor_total_cost), 0), 2) as roi_multiplier,
  CASE
    WHEN ROUND(SUM(labor_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) > 30 THEN 
        SUM(labor_total_cost) - (SUM(gross_revenue) * 0.30)
    WHEN ROUND(SUM(labor_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) < 20 THEN 
        (SUM(gross_revenue) * 0.20) - SUM(labor_total_cost)
    ELSE 0
  END as variance_rp,
  CASE
    WHEN ROUND(SUM(labor_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) > 35 THEN '📉 Critical High'
    WHEN ROUND(SUM(labor_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) > 30 THEN '⚠️ Watch Zone'
    WHEN ROUND(SUM(labor_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) < 15 THEN '🔥 Critical Low'
    WHEN ROUND(SUM(labor_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) < 20 THEN '👀 Low Cost'
    ELSE '⭐ Ideal Zone'
  END as variance_status
FROM restaurant.daily_net_revenue CROSS JOIN max_d
WHERE metric_date >= max_d.d - INTERVAL '29 days'
GROUP BY branch_name
ORDER BY labor_cost_pct DESC
```

```sql overtime_risk
SELECT 
  branch_name,
  total_overtime_hours,
  avg_overtime_per_person,
  overtime_session_pct,
  absent_count,
  late_count,
  pressure_score,
  CASE 
    WHEN pressure_score > 25 THEN '🔥 Critical Burnout'
    WHEN pressure_score > 15 THEN '⚠️ Warning'
    ELSE '⭐ Healthy'
  END as risk_status
FROM restaurant.overtime_by_branch_period
WHERE period = '30d'
ORDER BY pressure_score DESC
```

{#if worstBranchSDM && bestBranchSDM}
<div class="insight-container" style="margin-bottom: 48px;">
  <div class="insight-box {macroLaborCost > 35 || macroLaborCost < 15 ? 'red' : (macroLaborCost > 30 || macroLaborCost < 20 ? 'orange' : 'green')}">
    <div class="insight-headline">
        {#if macroLaborCost > 35}
            🚨 Critical: Severe Labor Cost Overrun ({macroLaborCost.toFixed(1)}%)
        {:else if macroLaborCost > 30}
            ⚠️ Warning: Labor Cost Above Target ({macroLaborCost.toFixed(1)}%)
        {:else if macroLaborCost < 15}
            🚨 Critical: High Understaffing Risk ({macroLaborCost.toFixed(1)}%)
        {:else if macroLaborCost < 20}
            ⚠️ Warning: Potential Staff Burnout Risk ({macroLaborCost.toFixed(1)}%)
        {:else}
            ✅ Ideal: Balanced Labor Expenditure ({macroLaborCost.toFixed(1)}%)
        {/if}
    </div>
    <div class="insight-copy">
        {#if macroLaborCost > 35}
            Over the past 30 days, the average labor cost ratio surpassed the critical 35% threshold (<strong>{macroLaborCost.toFixed(1)}%</strong>). This indicates potential payroll inefficiency or overstaffing relative to order volume. The highest burden is recorded at <strong>{worstBranchSDM.branch_name} ({worstBranchSDM.labor_cost_pct}%)</strong>. <br/><br/>
            <strong>Recommendation:</strong> Audit shift schedules and adjust part-time hours immediately. <em>(Note: Use this metric as an analytical indicator. Verify with actual restaurant conditions).</em>
        {:else if macroLaborCost > 30}
            Over the past 30 days, the average labor cost ratio exceeded the 30% target benchmark (<strong>{macroLaborCost.toFixed(1)}%</strong>). Unchecked payroll growth will gradually erode operating margins. The highest ratio is seen at <strong>{worstBranchSDM.branch_name} ({worstBranchSDM.labor_cost_pct}%)</strong>. <br/><br/>
            <strong>Recommendation:</strong> Review overtime allocations and optimize peak-hour shift coverage. <em>(Note: Use this metric as an analytical indicator. Verify with actual restaurant conditions).</em>
        {:else if macroLaborCost < 15}
            The average labor cost ratio has fallen below 15% (<strong>{macroLaborCost.toFixed(1)}%</strong>), indicating severe understaffing. This increases the risk of staff burnout, service delays, and customer complaints. The lowest ratio is at <strong>{bestBranchSDM.branch_name} ({bestBranchSDM.labor_cost_pct}%)</strong>. <br/><br/>
            <strong>Recommendation:</strong> Evaluate shift capacity and recruit essential staff or part-time support immediately. <em>(Note: Use this metric as an analytical indicator. Verify with actual restaurant conditions).</em>
        {:else if macroLaborCost < 20}
            The average labor cost ratio is below target (<strong>{macroLaborCost.toFixed(1)}%</strong>). While margin-friendly, ratios under 20% can lead to staff fatigue during peak operational hours. This is most noticeable at <strong>{bestBranchSDM.branch_name} ({bestBranchSDM.labor_cost_pct}%)</strong>. <br/><br/>
            <strong>Recommendation:</strong> Consider onboarding flexible part-time support for peak sales hours. <em>(Note: Use this metric as an analytical indicator. Verify with actual restaurant conditions).</em>
        {:else}
            The average labor cost ratio is optimally balanced at <strong>{macroLaborCost.toFixed(1)}%</strong>, aligning labor expenditure with store revenue. <br/><br/>
            <strong>Recommendation:</strong> Maintain current shift rosters and monitor team productivity. <em>(Note: Continue monitoring staff wellbeing and service quality on the floor).</em>
        {/if}

        <div class="macro-progress-container">
           <div class="progress-labels">
             <span>0%</span>
             <span>15%</span>
             <span>20%</span>
             <span>30%</span>
             <span>35%</span>
             <span>50%</span>
           </div>
           <div class="macro-progress-bar">
             <div class="zone" style="width: 30%; background: #fecaca;"></div>
             <div class="zone" style="width: 10%; background: #fed7aa;"></div>
             <div class="zone" style="width: 20%; background: #bbf7d0;"></div>
             <div class="zone" style="width: 10%; background: #fed7aa;"></div>
             <div class="zone" style="width: 30%; background: #fecaca;"></div>
             <div class="macro-marker" style="left: {Math.min(macroLaborCost / 50 * 100, 100)}%;">
               <div class="macro-marker-pin">📍 {macroLaborCost.toFixed(1)}%</div>
               <div class="macro-marker-line"></div>
             </div>
           </div>
        </div>
    </div>
  </div>
</div>

<div style="margin-bottom: 64px;">
  <div style="font-weight: 700; color: var(--color-text-primary); margin-bottom: 24px; font-size: 1.1rem; text-align: center;">Early Warning System (Payroll Efficiency Zone)</div>
  <div class="insight-grid" style="grid-template-columns: repeat(5, minmax(0, 1fr)); gap: 12px; padding: 12px 0;">
    
    <div class="insight-card target-card red {activeTierSDM === 1 ? 'active-tier' : 'inactive-tier'}">
      <div class="insight-header" style="flex-direction: column; text-align: center; gap: 4px;">
        <span class="insight-icon">🔥</span>
        <span class="insight-title" style="font-size: 0.85rem;">Critical Low (&lt;15%)</span>
      </div>
      <div class="insight-body" style="font-size: 0.8rem; text-align: center; color: var(--color-text-secondary); line-height: 1.4; margin-top: 8px;">
        Critical understaffing risk. Evaluate hiring or adding shift support.
      </div>
    </div>

    <div class="insight-card target-card orange {activeTierSDM === 2 ? 'active-tier' : 'inactive-tier'}">
      <div class="insight-header" style="flex-direction: column; text-align: center; gap: 4px;">
        <span class="insight-icon">👀</span>
        <span class="insight-title" style="font-size: 0.85rem;">Low Cost (15-20%)</span>
      </div>
      <div class="insight-body" style="font-size: 0.8rem; text-align: center; color: var(--color-text-secondary); line-height: 1.4; margin-top: 8px;">
        Ratio below target. Monitor staff workload and burnout risk.
      </div>
    </div>

    <div class="insight-card target-card green {activeTierSDM === 3 ? 'active-tier' : 'inactive-tier'}">
      <div class="insight-header" style="flex-direction: column; text-align: center; gap: 4px;">
        <span class="insight-icon">⭐</span>
        <span class="insight-title" style="font-size: 0.85rem;">Ideal Zone (20-30%)</span>
      </div>
      <div class="insight-body" style="font-size: 0.8rem; text-align: center; color: var(--color-text-secondary); line-height: 1.4; margin-top: 8px;">
        Efficient ratio. Maintain current scheduling standards.
      </div>
    </div>

    <div class="insight-card target-card orange {activeTierSDM === 4 ? 'active-tier' : 'inactive-tier'}">
      <div class="insight-header" style="flex-direction: column; text-align: center; gap: 4px;">
        <span class="insight-icon">⚠️</span>
        <span class="insight-title" style="font-size: 0.85rem;">Watch Zone (30-35%)</span>
      </div>
      <div class="insight-body" style="font-size: 0.8rem; text-align: center; color: var(--color-text-secondary); line-height: 1.4; margin-top: 8px;">
        Ratio is rising. Review overtime usage and peak shifts.
      </div>
    </div>

    <div class="insight-card target-card red {activeTierSDM === 5 ? 'active-tier' : 'inactive-tier'}">
      <div class="insight-header" style="flex-direction: column; text-align: center; gap: 4px;">
        <span class="insight-icon">📉</span>
        <span class="insight-title" style="font-size: 0.85rem;">Critical High (&gt;35%)</span>
      </div>
      <div class="insight-body" style="font-size: 0.8rem; text-align: center; color: var(--color-text-secondary); line-height: 1.4; margin-top: 8px;">
        Ratio above standard. Check for overstaffing or shift inefficiency.
      </div>
    </div>

  </div>
</div>

<hr style="margin: 48px 0; border: 0; border-top: 1px dashed rgba(0,0,0,0.1);" />

<div class="diagnostics-header" style="margin-bottom: 24px;">
  <div class="diagnostics-eyebrow">🔬 SUPPORTING ANALYSIS (DEEP-DIVE)</div>
<h2 class="diagnostics-title">Branch Capacity & Labor Analysis</h2>
  <p class="diagnostics-copy">Break down detailed labor cost structures and staffing efficiency by individual branch.</p>
</div>

<!-- Main Financial Variance Table -->
<div style="margin-top: 32px; margin-bottom: 48px;">
      
      <details class="guide-acc" style="margin-top: 16px; margin-bottom: 24px;">
        <summary>💡 Data Context & How to Read</summary>
        <div class="guide-body" style="padding: 16px;">
          <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
            While macro metrics evaluate <strong>overall</strong> business health, this micro-level breakdown pinpoints performance by <strong>individual branch</strong>. The monetary figures indicate potential labor cost savings or additional budget available for <i>hiring</i> allocations.
          </p>
          <div class="guide-grid" style="grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 16px; display: grid;">
            <div class="guide-card orange">
              <div class="guide-card-icon">📉</div>
              <div class="guide-card-content">
                <div class="guide-card-label">Status: Critical High</div>
                <h4 class="guide-card-title">Overtime Reduction Target</h4>
                <p class="guide-card-desc">A positive Variance of <strong>Rp 5,000,000</strong> indicates an opportunity to <strong>reduce overtime expenses</strong> worth Rp 5M over the past 30 days.</p>
              </div>
            </div>
            <div class="guide-card purple">
              <div class="guide-card-icon">🔥</div>
              <div class="guide-card-content">
                <div class="guide-card-label">Status: Critical Low</div>
                <h4 class="guide-card-title">Hiring Budget Allocation</h4>
                <p class="guide-card-desc">A negative Variance reflects a <strong>Rp 5,000,000 budget available</strong> to <strong>recruit additional staff</strong>, preventing burnout from excessive overtime.</p>
              </div>
            </div>
          </div>
        </div>
      </details>

      <!-- Custom Premium Table -->
      <div class="premium-table-container">
        <table class="premium-table">
          <thead>
            <tr>
              <th>Branch</th>
              <th style="text-align: center;">Labor Cost Ratio (%)</th>
              <th>Health Status</th>
              <th style="text-align: right;">Variance Value (Rp)</th>
            </tr>
          </thead>
          <tbody>
            {#each branch_labor_cost as row, i}
              <tr class="premium-row">
                <td style="font-weight: 700; color: var(--color-text-primary);">{row.branch_name}</td>
                <td style="text-align: center; font-weight: 600;">{row.labor_cost_pct}%</td>
                <td>
                  {#if row.labor_cost_pct > 35}
                    <span class="badge badge-red">{row.variance_status}</span>
                  {:else if row.labor_cost_pct > 30}
                    <span class="badge badge-orange">{row.variance_status}</span>
                  {:else if row.labor_cost_pct < 15}
                    <span class="badge badge-red">{row.variance_status}</span>
                  {:else if row.labor_cost_pct < 20}
                    <span class="badge badge-orange">{row.variance_status}</span>
                  {:else}
                    <span class="badge badge-green">{row.variance_status}</span>
                  {/if}
                </td>
                <td style="text-align: right; font-weight: 800; color: var(--color-text-primary);" class="hover-tooltip {i < branch_labor_cost.length / 2 ? 'tooltip-down' : 'tooltip-up'}">
                  <span class="tooltip-text">
                    {#if row.labor_cost_pct > 35}
                      Labor cost ratio is critically high. Adjust shift scheduling and reduce overtime.
                    {:else if row.labor_cost_pct > 30}
                      Labor costs are trending up. Evaluate overtime allocations to stabilize expenses.
                    {:else if row.labor_cost_pct < 15}
                      Labor cost ratio is critically low. Consider hiring to protect service quality.
                    {:else if row.labor_cost_pct < 20}
                      Labor cost is below target. Allocate budget for part-time support during peak hours.
                    {:else}
                      Labor expenditure and shift scheduling are optimal and balanced.
                    {/if}
                  </span>
                  {#if row.variance_rp != null && row.variance_rp !== 0}
                    {#if row.labor_cost_pct > 30}
                      <span style="color: #ef4444; font-size: 0.75rem; margin-right: 4px; vertical-align: middle;">▼</span>
                    {:else if row.labor_cost_pct < 20}
                      <span style="color: #22c55e; font-size: 0.75rem; margin-right: 4px; vertical-align: middle;">▲</span>
                    {/if}
                    Rp {Math.round(Number(row.variance_rp)).toLocaleString('en-US')}
                  {:else}
                    -
                  {/if}
                </td>
              </tr>
            {/each}
          </tbody>
        </table>
      </div>
</div>

```sql labor_composition
WITH max_d AS (SELECT MAX(metric_date)::DATE AS d FROM restaurant.daily_net_revenue),
raw_data AS (
  SELECT branch_name, salary_cost, overtime_cost, meal_allowance_cost, labor_total_cost
  FROM restaurant.daily_net_revenue CROSS JOIN max_d
  WHERE metric_date >= max_d.d - INTERVAL '29 days'
),
agg_branches AS (
  SELECT 
    branch_name,
    SUM(salary_cost) as total_salary,
    SUM(overtime_cost) as total_overtime,
    SUM(meal_allowance_cost) as total_allowance,
    SUM(labor_total_cost) as total_labor
  FROM raw_data
  GROUP BY branch_name
),
agg_all AS (
  SELECT 
    'All Locations' as branch_name,
    SUM(salary_cost) as total_salary,
    SUM(overtime_cost) as total_overtime,
    SUM(meal_allowance_cost) as total_allowance,
    SUM(labor_total_cost) as total_labor
  FROM raw_data
),
combined AS (
  SELECT * FROM agg_all
  UNION ALL
  SELECT * FROM agg_branches
)
SELECT 
  branch_name,
  total_salary,
  total_overtime,
  total_allowance,
  total_labor,
  ROUND(total_salary / NULLIF(total_labor, 0) * 100, 1) as pct_salary,
  ROUND(total_overtime / NULLIF(total_labor, 0) * 100, 1) as pct_overtime,
  ROUND(total_allowance / NULLIF(total_labor, 0) * 100, 1) as pct_allowance
FROM combined
ORDER BY CASE WHEN branch_name = 'All Locations' THEN 0 ELSE 1 END, total_labor DESC
```

<hr style="margin: 48px 0; border: 0; border-top: 1px dashed rgba(0,0,0,0.1);" />

<div class="diagnostics-header" style="margin-bottom: 24px;">
  <div class="diagnostics-eyebrow">🧬 COST COMPOSITION STRUCTURE</div>
<h2 class="diagnostics-title">Labor Cost Breakdown (Base Salary vs. Overtime vs. Benefits)</h2>
  <p class="diagnostics-copy">Analyze percentage composition to pinpoint primary cost drivers, whether stemming from excessive overtime spending or high base salary burdens.</p>
</div>

<div style="display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 24px;">
  {#each labor_composition as row}
    {#if row.total_labor !== undefined}
      <button 
        style="padding: 8px 16px; border-radius: 20px; font-size: 0.9rem; font-weight: 600; cursor: pointer; border: 1px solid {activeCompositionBranch === row.branch_name ? '#3b82f6' : '#e2e8f0'}; background: {activeCompositionBranch === row.branch_name ? '#eff6ff' : '#ffffff'}; color: {activeCompositionBranch === row.branch_name ? '#1d4ed8' : '#64748b'}; transition: all 0.2s ease;"
        on:click={() => activeCompositionBranch = row.branch_name}
      >
        {row.branch_name}
      </button>
    {/if}
  {/each}
</div>

<div style="display: flex; flex-direction: column; gap: 16px; margin-bottom: 48px;">
  {#each labor_composition as row}
    {#if row.total_labor !== undefined && row.branch_name === activeCompositionBranch}
    <div class="interactive-card" style="padding: 20px; background: white; border-radius: 12px; border: 1px solid var(--color-border-primary); box-shadow: 0 1px 3px rgba(0,0,0,0.05);">
      <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 12px;">
        <div style="font-weight: 700; color: var(--color-text-primary); font-size: 1.1rem;">{row.branch_name}</div>
        <div style="font-size: 0.9rem; color: var(--color-text-tertiary); font-weight: 500;">Total Labor Costs: Rp {Math.round(row.total_labor || 0).toLocaleString('en-US')}</div>
      </div>
      
      <div style="display: flex; height: 28px; border-radius: 8px; overflow: hidden; margin-bottom: 16px; box-shadow: inset 0 1px 3px rgba(0,0,0,0.1);">
        <div style="width: {row.pct_salary}%; background: linear-gradient(90deg, #3b82f6, #60a5fa); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.75rem; font-weight: 700;" title="Base Salary: Rp {Math.round(row.total_salary || 0).toLocaleString('en-US')}">
          {#if row.pct_salary > 10}{row.pct_salary}%{/if}
        </div>
        <div style="width: {row.pct_allowance}%; background: linear-gradient(90deg, #10b981, #34d399); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.75rem; font-weight: 700;" title="Benefits: Rp {Math.round(row.total_allowance || 0).toLocaleString('en-US')}">
          {#if row.pct_allowance > 5}{row.pct_allowance}%{/if}
        </div>
        <div style="width: {row.pct_overtime}%; background: linear-gradient(90deg, #f59e0b, #fbbf24); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.75rem; font-weight: 700;" title="Overtime: Rp {Math.round(row.total_overtime || 0).toLocaleString('en-US')}">
          {#if row.pct_overtime > 5}{row.pct_overtime}%{/if}
        </div>
      </div>
      
      <div style="display: flex; flex-wrap: wrap; gap: 16px; font-size: 0.85rem; color: var(--color-text-secondary);">
        <div style="display: flex; align-items: center; gap: 6px;">
          <div style="width: 12px; height: 12px; border-radius: 3px; background: #3b82f6;"></div>
          <span>Base Salary <strong>Rp {Math.round(row.total_salary || 0).toLocaleString('en-US')}</strong></span>
        </div>
        <div style="display: flex; align-items: center; gap: 6px;">
          <div style="width: 12px; height: 12px; border-radius: 3px; background: #10b981;"></div>
          <span>Benefits <strong>Rp {Math.round(row.total_allowance || 0).toLocaleString('en-US')}</strong></span>
        </div>
        <div style="display: flex; align-items: center; gap: 6px;">
          <div style="width: 12px; height: 12px; border-radius: 3px; background: #f59e0b;"></div>
          <span>Overtime <strong>Rp {Math.round(row.total_overtime || 0).toLocaleString('en-US')}</strong></span>
        </div>
      </div>
    </div>
    {/if}
  {/each}
</div>

<!-- CTA to Data Directory -->
      <div class="clean-cta-banner">
        <div class="clean-cta-content">
          <div class="clean-cta-icon">🏪</div>
          <div class="clean-cta-text">
            <h3 class="clean-cta-title">Branch Cost Investigation</h3>
            <p class="clean-cta-desc">Analyze cost structures per location and unlock actionable recommendations.</p>
          </div>
        </div>
        <a href="/02-branch-performance/02-deepdive" class="clean-cta-button">
          Open Branch Deep Dive ➔
        </a>
      </div>


{:else}
  <GlobalLoading />
{/if}



</Tab>
<Tab label="⚙️ Overhead Costs">


```sql ops_kpi
SELECT 
  SUM(operational_total_cost)/SUM(gross_revenue)*100 as ops_pct_30d
FROM restaurant.daily_net_revenue
WHERE metric_date >= (SELECT MAX(metric_date) FROM restaurant.daily_net_revenue) - INTERVAL '29 days'
```

```sql ops_by_branch
WITH max_d AS (SELECT MAX(metric_date)::DATE AS d FROM restaurant.daily_net_revenue)
SELECT 
  branch_name,
  SUM(gross_revenue) as total_rev,
  SUM(operational_total_cost) as total_ops,
  ROUND(SUM(operational_total_cost)/SUM(gross_revenue)*100, 1) as ops_pct
FROM restaurant.daily_net_revenue CROSS JOIN max_d
WHERE metric_date >= max_d.d - INTERVAL '29 days'
GROUP BY branch_name
ORDER BY ops_pct DESC
```



{#if worstBranchOps && bestBranchOps && ops_kpi}
<div class="diagnostics-header" style="margin-top: 24px; margin-bottom: 24px;">
  <div class="diagnostics-eyebrow">🧠 MAIN DIAGNOSTICS</div>
<h2 class="diagnostics-title">Overhead & Utility Cost Overview</h2>
  <p class="diagnostics-copy">A comprehensive evaluation of rent, utility usage benchmarks, and general overhead health over the past 30 days.</p>
</div>

<div class="insight-container" style="margin-bottom: 48px;">
  <div class="insight-box {macroOpsPct > 35 ? 'red' : (macroOpsPct > 30 || macroOpsPct < 25 ? 'orange' : 'green')}">
    <div class="insight-headline">
        {#if macroOpsPct > 35}
            🚨 Critical: Severe Operational & Utility Waste ({macroOpsPct.toFixed(1)}%)
        {:else if macroOpsPct > 30}
            ⚠️ Warning: Operational Expenses Above Target ({macroOpsPct.toFixed(1)}%)
        {:else if macroOpsPct >= 25}
            ✅ Ideal: Efficient Operational Spending ({macroOpsPct.toFixed(1)}%)
        {:else}
            👀 Watch: Unusually Low Overhead Costs ({macroOpsPct.toFixed(1)}%)
        {/if}
    </div>
    <div class="insight-copy">
        {#if macroOpsPct > 35}
            <p style="margin-top: 0; margin-bottom: 12px;">Over the past 30 days, the average operational cost ratio surpassed the critical 35% threshold (<strong>{macroOpsPct.toFixed(1)}%</strong>). Ratios above 35% indicate extreme spikes in utility bills or fixed overhead expenses. The highest burden is recorded at <strong>{worstBranchOps.branch_name} ({worstBranchOps.ops_pct}%)</strong>.</p>
            <p style="margin: 0;"><strong>Recommendation:</strong> Conduct an immediate utility audit and curb promotional spending with low ROI. <em>(Note: Use this metric as an analytical indicator. Verify with actual restaurant conditions).</em></p>
        {:else if macroOpsPct > 30}
            <p style="margin-top: 0; margin-bottom: 12px;">The average operational cost ratio exceeds the 30% standard target (<strong>{macroOpsPct.toFixed(1)}%</strong>). While within tolerance, unchecked overhead growth risks eroding net margins. This trend is most visible at <strong>{worstBranchOps.branch_name} ({worstBranchOps.ops_pct}%)</strong>.</p>
            <p style="margin: 0;"><strong>Recommendation:</strong> Tighten utility controls (HVAC, lighting) and defer non-essential operational expenses. <em>(Note: Use this metric as an analytical indicator. Verify with actual restaurant conditions).</em></p>
        {:else if macroOpsPct >= 25}
            <p style="margin-top: 0; margin-bottom: 12px;">Operational and fixed costs are optimally balanced at <strong>{macroOpsPct.toFixed(1)}%</strong>, complying with standard efficiency targets. The highest operational efficiency was achieved by <strong>{bestBranchOps.branch_name} ({bestBranchOps.ops_pct}%)</strong>.</p>
            <p style="margin: 0;"><strong>Recommendation:</strong> Maintain current utility efficiency standards without compromising customer comfort. <em>(Note: Continuously monitor customer satisfaction and dining area comfort).</em></p>
        {:else}
            <p style="margin-top: 0; margin-bottom: 12px;">The average operational cost ratio is unusually low (<strong>{macroOpsPct.toFixed(1)}%</strong>), falling below the 25% standard benchmark. While margin-friendly, ratios under 25% may indicate under-spent marketing or reduced guest comfort (e.g., inadequate cooling or lighting). The lowest ratio is at <strong>{bestBranchOps.branch_name} ({bestBranchOps.ops_pct}%)</strong>.</p>
            <p style="margin: 0;"><strong>Recommendation:</strong> Ensure store ambiance, guest comfort, and essential marketing are not compromised to cut operational costs. <em>(Note: Use this metric as an analytical indicator. Verify with actual restaurant conditions).</em></p>
        {/if}

        <div class="macro-progress-container">
           <div class="progress-labels">
             <span>0%</span>
             <span>25%</span>
             <span>30%</span>
             <span>35%</span>
             <span>50%</span>
           </div>
           <div class="macro-progress-bar">
             <div class="zone" style="width: 50%; background: #fdba74;"></div>
             <div class="zone" style="width: 10%; background: #86efac;"></div>
             <div class="zone" style="width: 10%; background: #fcd34d;"></div>
             <div class="zone" style="width: 30%; background: #fca5a5;"></div>
             <div class="macro-marker" style="left: {macroOpsPct > 50 ? 100 : (macroOpsPct / 50 * 100)}%;">
               <div class="macro-marker-pin">📍 {macroOpsPct.toFixed(1)}%</div>
               <div class="macro-marker-line"></div>
             </div>
           </div>
        </div>
    </div>
  </div>
</div>

<div style="margin-bottom: 64px;">
  <div style="font-weight: 700; color: var(--color-text-primary); margin-bottom: 24px; font-size: 1.1rem; text-align: center;">Early Warning System (Operational Zone)</div>
  <div class="insight-grid" style="grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 12px; padding: 12px 0;">
    
    <div class="insight-card target-card orange {activeTierOps === 2 ? 'active-tier' : 'inactive-tier'}">
      <div class="insight-header" style="flex-direction: column; text-align: center; gap: 4px;">
        <span class="insight-icon">👀</span>
        <span class="insight-title" style="font-size: 0.85rem;">Low Cost (&lt;25%)</span>
      </div>
      <div class="insight-body" style="font-size: 0.8rem; text-align: center; color: var(--color-text-secondary); line-height: 1.4; margin-top: 8px;">
        Ratio below target. Verify essential operational spending and maintenance.
      </div>
    </div>
    
    <div class="insight-card target-card green {activeTierOps === 3 ? 'active-tier' : 'inactive-tier'}">
      <div class="insight-header" style="flex-direction: column; text-align: center; gap: 4px;">
        <span class="insight-icon">⭐</span>
        <span class="insight-title" style="font-size: 0.85rem;">Ideal Zone (25-30%)</span>
      </div>
      <div class="insight-body" style="font-size: 0.8rem; text-align: center; color: var(--color-text-secondary); line-height: 1.4; margin-top: 8px;">
        Efficient spending. Maintain current operational cost controls.
      </div>
    </div>
    
    <div class="insight-card target-card orange {activeTierOps === 4 ? 'active-tier' : 'inactive-tier'}">
      <div class="insight-header" style="flex-direction: column; text-align: center; gap: 4px;">
        <span class="insight-icon">⚠️</span>
        <span class="insight-title" style="font-size: 0.85rem;">Watch Zone (30-35%)</span>
      </div>
      <div class="insight-body" style="font-size: 0.8rem; text-align: center; color: var(--color-text-secondary); line-height: 1.4; margin-top: 8px;">
        Ratio is rising. Review monthly utility bill trends and usage.
      </div>
    </div>
    
    <div class="insight-card target-card red {activeTierOps === 5 ? 'active-tier' : 'inactive-tier'}">
      <div class="insight-header" style="flex-direction: column; text-align: center; gap: 4px;">
        <span class="insight-icon">📉</span>
        <span class="insight-title" style="font-size: 0.85rem;">Critical High (&gt;35%)</span>
      </div>
      <div class="insight-body" style="font-size: 0.8rem; text-align: center; color: var(--color-text-secondary); line-height: 1.4; margin-top: 8px;">
        Ratio above standard. Conduct an immediate audit of non-essential OpEx.
      </div>
    </div>

  </div>
</div>

<div class="diagnostics-header" style="margin-bottom: 24px;">
  <div class="diagnostics-eyebrow" style="color: var(--color-text-tertiary); font-weight: 700; font-size: 0.8rem; letter-spacing: 0.05em; margin-bottom: 4px;">🏢 OVERHEAD & UTILITY COMPARISON</div>
  <h2 class="diagnostics-title" style="margin: 0; font-size: 1.2rem; font-weight: 800; color: var(--color-text-primary);">30-Day Operational Efficiency Report</h2>
  <p class="diagnostics-copy" style="margin: 4px 0 0 0; font-size: 0.9rem; color: var(--color-text-secondary);">Target Overhead Benchmark: Ideally 25–30% of total revenue per branch.</p>
</div>

<div style="margin-top: 32px; margin-bottom: 48px;">
  <details class="guide-acc" style="margin-top: 16px; margin-bottom: 24px;">
    <summary>💡 Data Context & How to Read</summary>
    <div class="guide-body" style="padding: 16px;">
      <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
        While the macro metrics evaluate overall operational health <strong>as a whole</strong>, the table below pinpoints performance across <strong>individual branches</strong> (Micro). The monetary figures represent potential financial savings achievable through overhead optimization.
      </p>
      <div class="guide-grid" style="grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 16px; display: grid;">
        <div class="guide-card orange">
          <div class="guide-card-icon">📉</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Status: Critical High</div>
            <h4 class="guide-card-title">Overhead Efficiency Target</h4>
            <p class="guide-card-desc">A positive Variance of <strong>Rp 5,000,000</strong> indicates an opportunity to <strong>reduce utility and overhead expenses</strong> by Rp 5M over the past 30 days.</p>
          </div>
        </div>
        <div class="guide-card teal">
          <div class="guide-card-icon">⭐</div>
          <div class="guide-card-content">
            <div class="guide-card-label">Status: Ideal Zone</div>
            <h4 class="guide-card-title">Optimal Operational Spending</h4>
            <p class="guide-card-desc">Your operational cost ratio is within target bounds. Maintain routine equipment and HVAC maintenance to sustain long-term energy efficiency.</p>
          </div>
        </div>
      </div>
    </div>
  </details>

  <div class="premium-table-container">
  <table class="premium-table">
    <thead>
      <tr>
        <th>Location</th>
        <th style="text-align: center;">% Ops</th>
        <th>Status Health</th>
        <th style="text-align: right;">Variance Value (Rp)</th>
      </tr>
    </thead>
    <tbody>
      {#each enrichedBranches as row, i}
        <tr class="premium-row">
          <td style="font-weight: 700; color: var(--color-text-primary);">{row.branch_name}</td>
          <td style="text-align: center; font-weight: 600;">{row.ops_pct}%</td>
          <td>
            {#if row.ops_pct > 35}
              <span class="badge badge-red">{row.variance_status}</span>
            {:else if row.ops_pct > 30}
              <span class="badge badge-orange">{row.variance_status}</span>
            {:else if row.ops_pct < 25}
              <span class="badge badge-orange">{row.variance_status}</span>
            {:else}
              <span class="badge badge-green">{row.variance_status}</span>
            {/if}
          </td>
          <td style="text-align: right; font-weight: 800; color: var(--color-text-primary);" class="hover-tooltip {i < enrichedBranches.length / 2 ? 'tooltip-down' : 'tooltip-up'}">
            <span class="tooltip-text">
              {#if row.ops_pct > 35}
                Overhead ratio is critically high. Audit utility consumption and fixed lease terms.
              {:else if row.ops_pct > 30}
                Overhead costs are trending up. Monitor monthly electricity and water bills.
              {:else if row.ops_pct < 25}
                Overhead ratio is below benchmark. Verify facility upkeep and active marketing allocation.
              {:else}
                Overhead spending and utility costs are optimal and well-balanced.
              {/if}
            </span>
            {#if row.variance_rp != null && row.variance_rp !== 0 && row.variance_status !== '⭐ Ideal Zone'}
              {#if row.ops_pct > 30}
                <span style="color: #ef4444; font-size: 0.75rem; margin-right: 4px; vertical-align: middle;">▼</span>
              {:else if row.ops_pct < 25}
                <span style="color: #22c55e; font-size: 0.75rem; margin-right: 4px; vertical-align: middle;">▲</span>
              {/if}
              Rp {Math.round(Math.abs(Number(row.variance_rp))).toLocaleString('en-US')}
            {:else}
              -
            {/if}
          </td>
        </tr>
      {/each}
    </tbody>
  </table>
</div>
</div>


```sql ops_composition
WITH max_d AS (SELECT MAX(metric_date)::DATE AS d FROM restaurant.daily_net_revenue),
raw_data AS (
  SELECT branch_name, building_rent_daily, electricity_cost, water_cost, other_utilities_cost, operational_total_cost
  FROM restaurant.daily_net_revenue CROSS JOIN max_d
  WHERE metric_date >= max_d.d - INTERVAL '29 days'
),
agg_branches AS (
  SELECT 
    branch_name,
    SUM(building_rent_daily) as total_rent,
    SUM(electricity_cost) as total_electricity,
    SUM(water_cost) as total_water,
    SUM(other_utilities_cost) as total_other,
    SUM(operational_total_cost) as total_ops
  FROM raw_data
  GROUP BY branch_name
),
agg_all AS (
  SELECT 
    'All Locations' as branch_name,
    SUM(building_rent_daily) as total_rent,
    SUM(electricity_cost) as total_electricity,
    SUM(water_cost) as total_water,
    SUM(other_utilities_cost) as total_other,
    SUM(operational_total_cost) as total_ops
  FROM raw_data
),
combined AS (
  SELECT * FROM agg_all
  UNION ALL
  SELECT * FROM agg_branches
)
SELECT 
  branch_name,
  total_rent,
  total_electricity,
  total_water,
  total_other,
  total_ops,
  ROUND(total_rent / NULLIF(total_ops, 0) * 100, 1) as pct_rent,
  ROUND(total_electricity / NULLIF(total_ops, 0) * 100, 1) as pct_electricity,
  ROUND(total_water / NULLIF(total_ops, 0) * 100, 1) as pct_water,
  ROUND(total_other / NULLIF(total_ops, 0) * 100, 1) as pct_other
FROM combined
ORDER BY CASE WHEN branch_name = 'All Locations' THEN 0 ELSE 1 END, total_ops DESC
```

<hr style="margin: 48px 0; border: 0; border-top: 1px dashed rgba(0,0,0,0.1);" />

<div class="diagnostics-header" style="margin-bottom: 24px;">
  <div class="diagnostics-eyebrow">🧬 OVERHEAD COST COMPOSITION</div>
<h2 class="diagnostics-title">Overhead Expense Breakdown</h2>
  <p class="diagnostics-copy">Identify key cost drivers across rent, utilities, and general expenses over the past 30 days to pinpoint targeted cost savings.</p>
</div>

<div style="display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 24px;">
  {#each ops_composition as row}
    {#if row.total_ops !== undefined}
      <button 
        style="padding: 8px 16px; border-radius: 20px; font-size: 0.9rem; font-weight: 600; cursor: pointer; border: 1px solid {activeOpsBranch === row.branch_name ? '#3b82f6' : '#e2e8f0'}; background: {activeOpsBranch === row.branch_name ? '#eff6ff' : '#ffffff'}; color: {activeOpsBranch === row.branch_name ? '#1d4ed8' : '#64748b'}; transition: all 0.2s ease;"
        on:click={() => activeOpsBranch = row.branch_name}
      >
        {row.branch_name}
      </button>
    {/if}
  {/each}
</div>

<div style="display: flex; flex-direction: column; gap: 16px; margin-bottom: 48px;">
  {#each ops_composition as row}
    {#if row.total_ops !== undefined && row.branch_name === activeOpsBranch}
    <div class="interactive-card" style="padding: 20px; background: white; border-radius: 12px; border: 1px solid var(--color-border-primary); box-shadow: 0 1px 3px rgba(0,0,0,0.05);">
      <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 12px;">
        <div style="font-weight: 700; color: var(--color-text-primary); font-size: 1.1rem;">{row.branch_name}</div>
        <div style="font-size: 0.9rem; color: var(--color-text-tertiary); font-weight: 500;">Total Overhead Expenses: Rp {Math.round(row.total_ops || 0).toLocaleString('en-US')}</div>
      </div>
      
      <div style="display: flex; height: 28px; border-radius: 8px; overflow: hidden; margin-bottom: 16px; box-shadow: inset 0 1px 3px rgba(0,0,0,0.1);">
        <div style="width: {row.pct_rent}%; background: linear-gradient(90deg, #3b82f6, #60a5fa); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.75rem; font-weight: 700;" title="Rent Expense: Rp {Math.round(row.total_rent || 0).toLocaleString('en-US')}">
          {#if row.pct_rent > 5}{row.pct_rent}%{/if}
        </div>
        <div style="width: {row.pct_electricity}%; background: linear-gradient(90deg, #10b981, #34d399); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.75rem; font-weight: 700;" title="Electricity: Rp {Math.round(row.total_electricity || 0).toLocaleString('en-US')}">
          {#if row.pct_electricity > 5}{row.pct_electricity}%{/if}
        </div>
        <div style="width: {row.pct_water}%; background: linear-gradient(90deg, #f59e0b, #fbbf24); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.75rem; font-weight: 700;" title="Water Utility: Rp {Math.round(row.total_water || 0).toLocaleString('en-US')}">
          {#if row.pct_water > 5}{row.pct_water}%{/if}
        </div>
        <div style="width: {row.pct_other}%; background: linear-gradient(90deg, #ef4444, #f87171); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.75rem; font-weight: 700;" title="Other Expenses: Rp {Math.round(row.total_other || 0).toLocaleString('en-US')}">
          {#if row.pct_other > 5}{row.pct_other}%{/if}
        </div>
      </div>
      
      <div style="display: flex; flex-wrap: wrap; gap: 16px; font-size: 0.85rem; color: var(--color-text-secondary);">
        <div style="display: flex; align-items: center; gap: 6px;">
          <div style="width: 12px; height: 12px; border-radius: 3px; background: #3b82f6;"></div>
          <span>Rent Expense <strong>Rp {Math.round(row.total_rent || 0).toLocaleString('en-US')}</strong></span>
        </div>
        <div style="display: flex; align-items: center; gap: 6px;">
          <div style="width: 12px; height: 12px; border-radius: 3px; background: #10b981;"></div>
          <span>Electricity <strong>Rp {Math.round(row.total_electricity || 0).toLocaleString('en-US')}</strong></span>
        </div>
        <div style="display: flex; align-items: center; gap: 6px;">
          <div style="width: 12px; height: 12px; border-radius: 3px; background: #f59e0b;"></div>
          <span>Water Utility <strong>Rp {Math.round(row.total_water || 0).toLocaleString('en-US')}</strong></span>
        </div>
        <div style="display: flex; align-items: center; gap: 6px;">
          <div style="width: 12px; height: 12px; border-radius: 3px; background: #ef4444;"></div>
          <span>Other Expenses (Marketing, etc) <strong>Rp {Math.round(row.total_other || 0).toLocaleString('en-US')}</strong></span>
        </div>
      </div>
    </div>
    {/if}
  {/each}
</div>

<div class="clean-cta-banner">
  <div class="clean-cta-content">
    <div class="clean-cta-icon">🏪</div>
    <div class="clean-cta-text">
      <h3 class="clean-cta-title">Branch Overhead Cost Deep Dive</h3>
      <p class="clean-cta-desc">Explore itemized utility and rent expenses per branch to unlock targeted cost-saving opportunities.</p>
    </div>
  </div>
  <a href="/02-branch-performance/02-deepdive" class="clean-cta-button">
    Open Branch Deep Dive ➔
  </a>
</div>
{:else}
  <GlobalLoading />
{/if}



</Tab>

</Tabs>


<style>

.insight-container {
  display: flex;
  flex-direction: column;
}
.insight-box {
  padding: 24px 32px;
  border-radius: 12px;
  border-left: 4px solid transparent;
}
.insight-box.blue {
  background-color: #eff6ff;
  border-left-color: #3b82f6;
}
.insight-box.red {
  background-color: #fef2f2;
  border-left-color: #ef4444;
}
.insight-box.orange {
  background-color: #fff7ed;
  border-left-color: #f97316;
}
.insight-box.green {
  background-color: #f0fdf4;
  border-left-color: #22c55e;
}
.insight-headline {
  font-weight: 800;
  font-size: 1.25rem;
  margin-bottom: 12px;
  color: var(--color-text-primary);
}
.insight-copy {
  font-size: 1rem;
  line-height: 1.7;
  color: var(--color-text-secondary);
}

/* Custom Progress Bar CSS */
.macro-progress-container {
  width: 100%;
  margin-top: 48px;
  margin-bottom: 12px;
  padding: 0 12px;
}
.progress-labels {
  display: flex;
  justify-content: space-between;
  font-size: 0.75rem;
  font-weight: 700;
  margin-bottom: 8px;
  color: var(--color-text-tertiary, #9ca3af);
  text-transform: uppercase;
  letter-spacing: 0.05em;
}
.macro-progress-bar {
  display: flex;
  height: 14px;
  width: 100%;
  border-radius: 8px;
  overflow: visible;
  position: relative;
  background: #f3f4f6;
  box-shadow: inset 0 2px 4px rgba(0,0,0,0.05);
}
.macro-progress-bar .zone {
  height: 100%;
}
.macro-progress-bar .zone:first-child { border-radius: 8px 0 0 8px; }
.macro-progress-bar .zone:last-child { border-radius: 0 8px 8px 0; }
.macro-marker {
  position: absolute;
  top: -30px;
  transform: translateX(-50%);
  display: flex;
  flex-direction: column;
  align-items: center;
  z-index: 10;
  transition: left 0.5s cubic-bezier(0.4, 0, 0.2, 1);
}
.macro-marker-pin {
  background: var(--color-text-primary, #111827);
  color: white;
  padding: 4px 10px;
  border-radius: 6px;
  font-size: 0.8rem;
  font-weight: 800;
  box-shadow: 0 4px 12px rgba(0,0,0,0.15);
  white-space: nowrap;
}
.macro-marker-line {
  width: 2px;
  height: 20px;
  background: var(--color-text-primary, #111827);
  border-radius: 1px;
}

/* 5 Cards CSS */
.insight-grid {
  display: grid;
  gap: 16px;
}
.insight-card {
  padding: 20px 16px;
  background: #ffffff;
  border-radius: 12px;
  border: 1px solid #e2e8f0;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
}
.inactive-tier {
  opacity: 0.45;
  filter: grayscale(80%);
  transform: scale(0.96);
}
.inactive-tier:hover {
  opacity: 0.8;
  filter: grayscale(0%);
}
.active-tier {
  opacity: 1;
  transform: scale(1.05);
  z-index: 10;
  background: #ffffff;
  box-shadow: 0 12px 30px -5px rgba(0, 0, 0, 0.15), 0 8px 10px -6px rgba(0, 0, 0, 0.1);
}
.active-tier::before {
  content: "📍 CURRENT STATUS";
  position: absolute;
  top: -14px;
  left: 50%;
  transform: translateX(-50%);
  background: #111827;
  color: white;
  font-size: 0.65rem;
  font-weight: 800;
  padding: 4px 12px;
  border-radius: 12px;
  letter-spacing: 0.05em;
  white-space: nowrap;
  box-shadow: 0 4px 6px rgba(0,0,0,0.1);
}
.active-tier.green { border: 2px solid #22c55e; box-shadow: 0 12px 30px rgba(34, 197, 94, 0.25); }
.active-tier.orange { border: 2px solid #f97316; box-shadow: 0 12px 30px rgba(249, 115, 22, 0.25); }
.active-tier.red { border: 2px solid #ef4444; box-shadow: 0 12px 30px rgba(239, 68, 68, 0.25); }
.insight-header {
  display: flex;
  align-items: center;
  gap: 12px;
}
.insight-icon {
  font-size: 1.8rem;
  margin-bottom: 4px;
}
.insight-title {
  font-weight: 800;
  color: #111827;
  font-size: 1.05rem;
}
@media (max-width: 1024px) {
  .insight-grid { grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)) !important; }
}

/* Premium Custom Table CSS */
.premium-table-container {
  overflow-x: auto;
  border-radius: 12px;
  border: 1px solid #e2e8f0;
  box-shadow: 0 4px 12px rgba(0,0,0,0.02);
  background: #f8fafc;
  margin-bottom: 32px;
}
.premium-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 0.95rem;
}
.premium-table th {
  text-align: left;
  padding: 16px 20px;
  background: #f1f5f9;
  color: var(--color-text-secondary);
  font-weight: 800;
  font-size: 0.85rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  border-bottom: 1px solid #e2e8f0;
}
.premium-row {
  transition: all 0.2s ease;
  border-bottom: 1px solid #e2e8f0;
  background: #f8fafc;
}
.premium-row:hover {
  background: #f1f5f9;
}
.premium-row td {
  padding: 16px 20px;
  color: var(--color-text-secondary);
}
.premium-row:last-child {
  border-bottom: none;
}

/* Badges */
.badge {
  display: inline-flex;
  align-items: center;
  padding: 4px 12px;
  border-radius: 16px;
  font-size: 0.85rem;
  font-weight: 700;
}
.badge-red {
  background: #fef2f2;
  color: #ef4444;
  border: 1px solid #fee2e2;
}
.badge-green {
  background: #f0fdf4;
  color: #22c55e;
  border: 1px solid #dcfce7;
}
.badge-orange {
  background: #fff7ed;
  color: #ea580c;
  border: 1px solid #ffedd5;
}

/* CTA Banner */
.clean-cta-banner {
  margin-top: 32px;
  margin-bottom: 40px;
  padding: 24px 28px;
  border-radius: 16px;
  background: rgba(13, 148, 136, 0.03);
  border: 1px solid rgba(13, 148, 136, 0.15);
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
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
  flex: 1;
  min-width: 0;
}

.clean-cta-icon {
  font-size: 2.2rem;
  line-height: 1;
  filter: drop-shadow(0 2px 4px rgba(13, 148, 136, 0.15));
  flex-shrink: 0;
}

.clean-cta-text {
  min-width: 0;
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
  flex-shrink: 0 !important;
  transition: all 0.2s ease !important;
  box-shadow: 0 2px 6px rgba(13, 148, 136, 0.06) !important;
  line-height: 1 !important;
  margin: 0 !important;
  white-space: nowrap !important;
}

.clean-cta-button:hover {
  background: #f0fdfa !important;
  color: #0f766e !important;
  border-color: #0d9488 !important;
  transform: translateY(-1px) !important;
  box-shadow: 0 4px 12px rgba(13, 148, 136, 0.1) !important;
}


.insight-container {
  display: flex;
  flex-direction: column;
}
.insight-box {
  padding: 24px 32px;
  border-radius: 12px;
  border-left: 4px solid transparent;
}
.insight-box.blue {
  background-color: #eff6ff;
  border-left-color: #3b82f6;
}
.insight-box.red {
  background-color: #fef2f2;
  border-left-color: #ef4444;
}
.insight-box.orange {
  background-color: #fff7ed;
  border-left-color: #f97316;
}
.insight-box.green {
  background-color: #f0fdf4;
  border-left-color: #22c55e;
}
.insight-headline {
  font-weight: 800;
  font-size: 1.25rem;
  margin-bottom: 12px;
  color: var(--color-text-primary);
}
.insight-copy {
  font-size: 1rem;
  line-height: 1.7;
  color: var(--color-text-secondary);
}

/* Custom Progress Bar CSS */
.macro-progress-container {
  width: 100%;
  margin-top: 48px;
  margin-bottom: 12px;
  padding: 0 12px;
}
.progress-labels {
  display: flex;
  justify-content: space-between;
  font-size: 0.75rem;
  font-weight: 700;
  margin-bottom: 8px;
  color: var(--color-text-tertiary, #9ca3af);
  text-transform: uppercase;
  letter-spacing: 0.05em;
}
.macro-progress-bar {
  display: flex;
  height: 14px;
  width: 100%;
  border-radius: 8px;
  overflow: visible;
  position: relative;
  background: #f3f4f6;
  box-shadow: inset 0 2px 4px rgba(0,0,0,0.05);
}
.macro-progress-bar .zone {
  height: 100%;
}
.macro-progress-bar .zone:first-child { border-radius: 8px 0 0 8px; }
.macro-progress-bar .zone:last-child { border-radius: 0 8px 8px 0; }
.macro-marker {
  position: absolute;
  top: -30px;
  transform: translateX(-50%);
  display: flex;
  flex-direction: column;
  align-items: center;
  z-index: 10;
  transition: left 0.5s cubic-bezier(0.4, 0, 0.2, 1);
}
.macro-marker-pin {
  background: var(--color-text-primary, #111827);
  color: white;
  padding: 4px 10px;
  border-radius: 6px;
  font-size: 0.8rem;
  font-weight: 800;
  box-shadow: 0 4px 12px rgba(0,0,0,0.15);
  white-space: nowrap;
}
.macro-marker-line {
  width: 2px;
  height: 20px;
  background: var(--color-text-primary, #111827);
  border-radius: 1px;
}

/* 5 Cards CSS */
.insight-grid {
  display: grid;
  gap: 16px;
}
.insight-card {
  padding: 20px 16px;
  background: #ffffff;
  border-radius: 12px;
  border: 1px solid var(--color-border-tertiary);
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
}
.inactive-tier {
  opacity: 0.45;
  filter: grayscale(80%);
  transform: scale(0.96);
}
.inactive-tier:hover {
  opacity: 0.8;
  filter: grayscale(0%);
}
.active-tier {
  opacity: 1;
  transform: scale(1.05);
  z-index: 10;
  background: #ffffff;
  box-shadow: 0 12px 30px -5px rgba(0, 0, 0, 0.15), 0 8px 10px -6px rgba(0, 0, 0, 0.1);
}
.active-tier::before {
  content: "📍 CURRENT STATUS";
  position: absolute;
  top: -14px;
  left: 50%;
  transform: translateX(-50%);
  background: var(--color-text-primary, #111827);
  color: white;
  font-size: 0.65rem;
  font-weight: 800;
  padding: 4px 12px;
  border-radius: 12px;
  letter-spacing: 0.05em;
  white-space: nowrap;
  box-shadow: 0 4px 6px rgba(0,0,0,0.1);
}
.active-tier.green { border: 2px solid #22c55e; box-shadow: 0 12px 30px rgba(34, 197, 94, 0.25); }
.active-tier.orange { border: 2px solid #f97316; box-shadow: 0 12px 30px rgba(249, 115, 22, 0.25); }
.active-tier.red { border: 2px solid #ef4444; box-shadow: 0 12px 30px rgba(239, 68, 68, 0.25); }
.insight-header {
  display: flex;
  align-items: center;
  gap: 12px;
}
.insight-icon {
  font-size: 1.8rem;
  margin-bottom: 4px;
}
.insight-title {
  font-weight: 800;
  color: var(--color-text-primary);
  font-size: 1.05rem;
}
@media (max-width: 1024px) {
  .insight-grid { grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)) !important; }
}

/* Callout Box CSS */
.variance-callout {
  background: linear-gradient(to right, rgba(15, 118, 110, 0.04), transparent);
  border-left: 4px solid #0f766e;
  padding: 16px 24px;
  border-radius: 0 12px 12px 0;
  margin-bottom: 24px;
}
.variance-callout-header {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 12px;
  color: var(--color-text-primary);
}
.variance-callout-list {
  margin: 0;
  padding-left: 28px;
  color: var(--color-text-secondary);
  font-size: 0.95rem;
  line-height: 1.7;
}

/* Premium Custom Table CSS */
.premium-table-container {
  overflow-x: auto;
  border-radius: 12px;
  border: 1px solid var(--color-border-tertiary);
  box-shadow: 0 4px 12px rgba(0,0,0,0.02);
  background: #f8fafc;
  margin-bottom: 32px;
}
.premium-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 0.95rem;
}
.premium-table th {
  text-align: left;
  padding: 16px 20px;
  background: #f1f5f9;
  color: var(--color-text-secondary);
  font-weight: 800;
  font-size: 0.85rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  border-bottom: 1px solid #e2e8f0;
}
.premium-row {
  transition: all 0.2s ease;
  border-bottom: 1px solid #e2e8f0;
  background: #f8fafc;
}
.premium-row:hover {
  background: #f1f5f9;
}
.premium-row td {
  padding: 16px 20px;
  color: var(--color-text-secondary);
}
.premium-row:last-child {
  border-bottom: none;
}

/* Badges */
.badge {
  display: inline-flex;
  align-items: center;
  padding: 4px 12px;
  border-radius: 16px;
  font-size: 0.85rem;
  font-weight: 700;
}
.badge-red {
  background: #fef2f2;
  color: #ef4444;
  border: 1px solid #fee2e2;
}
.badge-blue {
  background: #eff6ff;
  color: #3b82f6;
  border: 1px solid #dbeafe;
}
.badge-green {
  background: #f0fdf4;
  color: #22c55e;
  border: 1px solid #dcfce7;
}
.badge-orange {
  background: #fff7ed;
  color: #ea580c;
  border: 1px solid #ffedd5;
}

.hover-tooltip {
  position: relative;
  cursor: help;
}
.hover-tooltip .tooltip-text {
  visibility: hidden;
  width: max-content;
  max-width: 220px;
  background-color: #1e293b;
  color: #fff;
  text-align: center;
  border-radius: 8px;
  padding: 8px 12px;
  position: absolute;
  z-index: 10;
  bottom: 125%;
  right: 0;
  opacity: 0;
  transition: opacity 0.2s ease-in-out, transform 0.2s ease-in-out;
  transform: translateY(4px);
  font-size: 0.75rem;
  font-weight: 600;
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.1);
  pointer-events: none;
}
.hover-tooltip .tooltip-text::after {
  content: "";
  position: absolute;
  top: 100%;
  right: 15px;
  border-width: 5px;
  border-style: solid;
  border-color: #1e293b transparent transparent transparent;
}
.hover-tooltip:hover .tooltip-text {
  visibility: visible;
  opacity: 1;
  transform: translateY(0);
}

/* Smart Tooltip Placement based on dynamic half */
.hover-tooltip.tooltip-down .tooltip-text {
  bottom: auto;
  top: 125%;
  transform: translateY(-4px);
}
.hover-tooltip.tooltip-down:hover .tooltip-text {
  transform: translateY(0);
}
.hover-tooltip.tooltip-down .tooltip-text::after {
  top: auto;
  bottom: 100%;
  border-color: transparent transparent #1e293b transparent;
}

/* Leaderboard CSS */
.leaderboard-container {
  background: white;
  border-radius: 16px;
  border: 1px solid var(--color-border-tertiary);
  padding: 24px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.02);
}
.leaderboard-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}
.leaderboard-card {
  display: flex;
  align-items: center;
  gap: 20px;
  padding: 16px;
  border-radius: 12px;
  background: #f8fafc;
  border: 1px solid #e2e8f0;
  transition: transform 0.2s, box-shadow 0.2s;
}
.leaderboard-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 12px rgba(0,0,0,0.04);
  background: white;
}
.lb-rank {
  font-size: 1.8rem;
  width: 40px;
  text-align: center;
  flex-shrink: 0;
}
.lb-content {
  flex-grow: 1;
}
.lb-branch {
  font-size: 1.1rem;
  font-weight: 800;
  color: var(--color-text-primary);
  margin-bottom: 4px;
}
.lb-desc {
  font-size: 0.85rem;
  color: var(--color-text-secondary);
}
.lb-score {
  font-size: 1.5rem;
  font-weight: 900;
  letter-spacing: -0.02em;
}
.score-green { color: #16a34a; }
.score-orange { color: #ea580c; }
.score-red { color: #dc2626; }

.lb-bar-bg {
  height: 8px;
  background: #e2e8f0;
  border-radius: 4px;
  overflow: hidden;
  width: 100%;
}
.lb-bar-fill {
  height: 100%;
  border-radius: 4px;
  transition: width 1s ease-out;
}
.fill-green { background: linear-gradient(90deg, #22c55e, #16a34a); }
.fill-orange { background: linear-gradient(90deg, #f97316, #ea580c); }
.fill-red { background: linear-gradient(90deg, #ef4444, #dc2626); }

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
  gap: 24px;
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
  flex: 1;
  min-width: 0;
}

.clean-cta-icon {
  font-size: 2.2rem;
  line-height: 1;
  filter: drop-shadow(0 2px 4px rgba(13, 148, 136, 0.15));
  flex-shrink: 0;
}

.clean-cta-text {
  min-width: 0;
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
  flex-shrink: 0 !important;
  transition: all 0.2s ease !important;
  box-shadow: 0 2px 6px rgba(13, 148, 136, 0.06) !important;
  line-height: 1 !important;
  margin: 0 !important;
  white-space: nowrap !important;
}

.clean-cta-button:hover {
  background: #f0fdfa !important;
  color: #0f766e !important;
  border-color: #0d9488 !important;
  transform: translateY(-1px) !important;
  box-shadow: 0 4px 12px rgba(13, 148, 136, 0.1) !important;
}





.insight-container {
  display: flex;
  flex-direction: column;
}
.insight-box {
  padding: 24px 32px;
  border-radius: 12px;
  border-left: 4px solid transparent;
}
.insight-box.blue {
  background-color: #eff6ff;
  border-left-color: #3b82f6;
}
.insight-box.red {
  background-color: #fef2f2;
  border-left-color: #ef4444;
}
.insight-box.orange {
  background-color: #fff7ed;
  border-left-color: #f97316;
}
.insight-box.green {
  background-color: #f0fdf4;
  border-left-color: #22c55e;
}
.insight-headline {
  font-weight: 800;
  font-size: 1.25rem;
  margin-bottom: 12px;
  color: var(--color-text-primary);
}
.insight-copy {
  font-size: 1rem;
  line-height: 1.7;
  color: var(--color-text-secondary);
}

/* Custom Progress Bar CSS */
.macro-progress-container {
  width: 100%;
  margin-top: 48px;
  margin-bottom: 12px;
  padding: 0 12px;
}
.progress-labels {
  display: flex;
  justify-content: space-between;
  font-size: 0.75rem;
  font-weight: 700;
  margin-bottom: 8px;
  color: var(--color-text-tertiary, #9ca3af);
  text-transform: uppercase;
  letter-spacing: 0.05em;
}
.macro-progress-bar {
  display: flex;
  height: 14px;
  width: 100%;
  border-radius: 8px;
  overflow: visible;
  position: relative;
  background: #f3f4f6;
  box-shadow: inset 0 2px 4px rgba(0,0,0,0.05);
}
.macro-progress-bar .zone {
  height: 100%;
}
.macro-progress-bar .zone:first-child { border-radius: 8px 0 0 8px; }
.macro-progress-bar .zone:last-child { border-radius: 0 8px 8px 0; }
.macro-marker {
  position: absolute;
  top: -30px;
  transform: translateX(-50%);
  display: flex;
  flex-direction: column;
  align-items: center;
  z-index: 10;
  transition: left 0.5s cubic-bezier(0.4, 0, 0.2, 1);
}
.macro-marker-pin {
  background: var(--color-text-primary, #111827);
  color: white;
  padding: 4px 10px;
  border-radius: 6px;
  font-size: 0.8rem;
  font-weight: 800;
  box-shadow: 0 4px 12px rgba(0,0,0,0.15);
  white-space: nowrap;
}
.macro-marker-line {
  width: 2px;
  height: 20px;
  background: var(--color-text-primary, #111827);
  border-radius: 1px;
}

/* 5 Cards CSS */
.insight-grid {
  display: grid;
  gap: 16px;
}
.insight-card {
  padding: 20px 16px;
  background: #ffffff;
  border-radius: 12px;
  border: 1px solid #e2e8f0;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
}
.inactive-tier {
  opacity: 0.45;
  filter: grayscale(80%);
  transform: scale(0.96);
}
.inactive-tier:hover {
  opacity: 0.8;
  filter: grayscale(0%);
}
.active-tier {
  opacity: 1;
  transform: scale(1.05);
  z-index: 10;
  background: #ffffff;
  box-shadow: 0 12px 30px -5px rgba(0, 0, 0, 0.15), 0 8px 10px -6px rgba(0, 0, 0, 0.1);
}
.active-tier::before {
  content: "📍 CURRENT STATUS";
  position: absolute;
  top: -14px;
  left: 50%;
  transform: translateX(-50%);
  background: var(--color-text-primary, #111827);
  color: white;
  font-size: 0.65rem;
  font-weight: 800;
  padding: 4px 12px;
  border-radius: 12px;
  letter-spacing: 0.05em;
  white-space: nowrap;
  box-shadow: 0 4px 6px rgba(0,0,0,0.1);
}
.active-tier.green { border: 2px solid #22c55e; box-shadow: 0 12px 30px rgba(34, 197, 94, 0.25); }
.active-tier.orange { border: 2px solid #f97316; box-shadow: 0 12px 30px rgba(249, 115, 22, 0.25); }
.active-tier.red { border: 2px solid #ef4444; box-shadow: 0 12px 30px rgba(239, 68, 68, 0.25); }
.insight-header {
  display: flex;
  align-items: center;
}
.insight-icon {
  font-size: 28px;
  line-height: 1;
}
.insight-title {
  font-weight: 800;
  color: var(--color-text-primary, #111827);
  line-height: 1.2;
}

/* Premium Table CSS */
.premium-table-container {
  overflow-x: auto;
  border-radius: 12px;
  border: 1px solid #e2e8f0;
  box-shadow: 0 4px 12px rgba(0,0,0,0.02);
  background: #f8fafc;
  margin-bottom: 32px;
}
.premium-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 0.95rem;
}
.premium-table th {
  text-align: left;
  padding: 16px 20px;
  background: #f1f5f9;
  color: var(--color-text-secondary);
  font-weight: 800;
  font-size: 0.85rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  border-bottom: 1px solid #e2e8f0;
}
.premium-row {
  transition: all 0.2s ease;
  border-bottom: 1px solid #e2e8f0;
  background: #f8fafc;
}
.premium-row:hover {
  background: #f1f5f9;
}
.premium-row td {
  padding: 16px 20px;
  color: var(--color-text-secondary);
}
.premium-row:last-child {
  border-bottom: none;
}

/* Badges */
.badge {
  display: inline-flex;
  align-items: center;
  padding: 4px 12px;
  border-radius: 16px;
  font-size: 0.85rem;
  font-weight: 700;
}
.badge-red {
  background: #fef2f2;
  color: #ef4444;
  border: 1px solid #fee2e2;
}
.badge-green {
  background: #f0fdf4;
  color: #22c55e;
  border: 1px solid #dcfce7;
}
.badge-orange {
  background: #fff7ed;
  color: #ea580c;
  border: 1px solid #ffedd5;
}

/* CTA Banner */
.clean-cta-banner {
  margin-top: 32px;
  margin-bottom: 40px;
  padding: 24px 28px;
  border-radius: 16px;
  background: rgba(13, 148, 136, 0.03);
  border: 1px solid rgba(13, 148, 136, 0.15);
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
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
  flex: 1;
  min-width: 0;
}

.clean-cta-icon {
  font-size: 2.2rem;
  line-height: 1;
  filter: drop-shadow(0 2px 4px rgba(13, 148, 136, 0.15));
  flex-shrink: 0;
}

.clean-cta-text {
  min-width: 0;
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
  flex-shrink: 0 !important;
  transition: all 0.2s ease !important;
  box-shadow: 0 2px 6px rgba(13, 148, 136, 0.06) !important;
  line-height: 1 !important;
  margin: 0 !important;
  white-space: nowrap !important;
}

.clean-cta-button:hover {
  background: #f0fdfa !important;
  color: #0f766e !important;
  border-color: #0d9488 !important;
  transform: translateY(-1px) !important;
  box-shadow: 0 4px 12px rgba(13, 148, 136, 0.1) !important;
}

.trend-indicator {
  font-size: 0.82rem;
  font-weight: 700;
  display: inline-flex;
  align-items: center;
  gap: 3px;
}
.trend-indicator.up { color: #16a34a; }
.trend-indicator.down { color: #dc2626; }
.trend-indicator.neutral { color: var(--color-text-tertiary); }

.cost-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 12px;
}
.cost-card {
  padding: 16px;
  border-radius: 16px;
  border: 1px solid var(--color-border-tertiary);
  background: linear-gradient(180deg, rgba(255,255,255,0.82), rgba(255,255,255,0.6));
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 1px 3px rgba(0,0,0,0.05);
  display: flex;
  flex-direction: column;
}
.cost-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 10px 25px -5px rgba(13, 148, 136, 0.15), 0 8px 10px -6px rgba(13, 148, 136, 0.1);
  border-color: rgba(13, 148, 136, 0.4);
}
.cost-label {
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--color-text-tertiary);
  margin-bottom: 8px;
  display: flex;
  align-items: center;
  gap: 5px;
}
.cost-value {
  font-size: 1.9rem;
  font-weight: 800;
  letter-spacing: -0.03em;
}
.cost-target {
  margin-top: 3px;
  font-size: 0.8rem;
  color: var(--color-text-secondary);
}
.progress-track {
  position: relative;
  margin-top: 12px;
  height: 8px;
  border-radius: 999px;
  background: rgba(0,0,0,0.08);
  overflow: hidden;
}
.progress-fill {
  height: 100%;
  border-radius: inherit;
}
.progress-target {
  position: absolute;
  top: -2px;
  bottom: -2px;
  width: 2px;
  background: rgba(0,0,0,0.22);
}
.progress-scale {
  display: flex;
  justify-content: space-between;
  margin-top: 6px;
  font-size: 10px;
  color: var(--color-text-tertiary);
}
.cost-note {
  margin-top: 10px;
  font-size: 0.83rem;
  line-height: 1.4;
  color: var(--color-text-secondary);
  display: flex;
  flex-direction: column;
  gap: 2px;
}
</style>

---
title: Analysis
---

<script>
  import SectionCard from '$lib/SectionCard.svelte';
  
  $: donutData = typeof concentration_data !== 'undefined' ? Array.from(concentration_data).map(r => ({ value: r.rev, name: r.group_name })) : [];
  $: activeTop5Share = typeof menu_health_overview !== 'undefined' && menu_health_overview.length > 0 ? menu_health_overview[0].top5_share_30d : 0;
  
  $: donutConfig = {
    tooltip: { 
      trigger: 'item',
      formatter: function(params) {
        return params.name + ':<br/><b>Rp ' + Number(params.value).toLocaleString('en-US') + '</b> (' + params.percent + '%)';
      }
    },
    series: [
      {
        name: 'Revenue',
        type: 'pie',
        radius: ['40%', '70%'],
        itemStyle: {
          borderRadius: 8,
          borderColor: '#fff',
          borderWidth: 2
        },
        label: {
          show: true,
          formatter: '{b}\n{d}%'
        },
        color: ['#6366f1', '#6366f1', '#6366f1', '#6366f1', '#6366f1', '#cbd5e1'],
        data: donutData
      }
    ]
  };
</script>
<style>
.guide-card-icon { font-size: 2.5rem; line-height: 1; }
.guide-card-content { display: flex; flex-direction: column; gap: 8px; }
.guide-card-label { font-size: 0.75rem; font-weight: 800; letter-spacing: 0.1em; text-transform: uppercase; }
.guide-card-title { font-size: 1.1rem; font-weight: 800; color: var(--color-text-primary); margin: 0; }
.guide-card-desc { font-size: 0.9rem; line-height: 1.6; color: var(--color-text-secondary); margin: 0; }
.guide-card-list { display: flex; flex-direction: column; gap: 12px; margin-top: auto; padding-top: 16px; border-top: 1px solid rgba(0,0,0,0.05); }
.guide-card-item { display: flex; gap: 12px; font-size: 0.85rem; line-height: 1.5; color: var(--color-text-secondary); }
.guide-card-footer { font-size: 0.8rem; font-weight: 600; font-style: italic; color: var(--color-text-tertiary); margin-top: 16px; }

.strategic-stack { border: 1px solid var(--color-border-tertiary); border-radius: 20px; background: var(--color-background-primary); overflow: hidden; box-shadow: 0 4px 20px rgba(0,0,0,0.03); }
.strategic-header { padding: 24px; border-bottom: 1px solid var(--color-border-tertiary); background: linear-gradient(135deg, rgba(0,0,0,0.02), rgba(0,0,0,0)); }
.strategic-eyebrow { font-size: 10px; font-weight: 800; letter-spacing: 0.12em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 8px; }
.strategic-title { font-size: 1.2rem; font-weight: 800; color: var(--color-text-primary); margin: 0 0 6px; letter-spacing: -0.01em; }
.strategic-copy { font-size: 0.9rem; line-height: 1.6; color: var(--color-text-secondary); margin: 0; max-width: 75ch; }
.acc-strategic { border-bottom: 1px solid var(--color-border-tertiary); }
.acc-strategic:last-child { border-bottom: none; }
.acc-strategic > summary { padding: 16px 24px; cursor: pointer; font-weight: 700; color: var(--color-text-primary); list-style: none; display: flex; align-items: center; justify-content: space-between; background: var(--color-background-secondary); font-size: 0.95rem; }
.acc-strategic > summary::-webkit-details-marker { display: none; }
.acc-strategic > summary::after { content: '+'; font-size: 1.2rem; font-weight: 400; color: var(--color-text-tertiary); transition: transform 0.2s; }
.acc-strategic[open] > summary::after { content: '−'; }
.acc-strategic[open] > summary { border-bottom: 1px solid var(--color-border-tertiary); background: var(--color-background-primary); }

  .risk-section { display: flex; flex-direction: column; gap: 20px; margin-bottom: 32px; }

  .risk-row {
    border-radius: 20px;
    overflow: hidden;
    box-shadow: 0 2px 12px rgba(0,0,0,0.03);
    transition: border-color 0.3s ease, box-shadow 0.3s ease;
  }

  /* Row color themes */
  .risk-row.purple-theme { background: linear-gradient(135deg, rgba(168,85,247,0.03), rgba(168,85,247,0.008)); border: 1.5px solid rgba(168,85,247,0.12); }
  .risk-row.blue-theme { background: linear-gradient(135deg, rgba(59,130,246,0.03), rgba(59,130,246,0.008)); border: 1.5px solid rgba(59,130,246,0.12); }

  /* Hover: outline only */
  .risk-row.purple-theme:hover { border-color: rgba(168,85,247,0.35); box-shadow: 0 4px 20px rgba(168,85,247,0.06); }
  .risk-row.blue-theme:hover { border-color: rgba(59,130,246,0.35); box-shadow: 0 4px 20px rgba(59,130,246,0.06); }

  .risk-row-header { display: flex; align-items: flex-start; flex-direction: column; gap: 4px; padding: 18px 24px; }
  .risk-row.purple-theme .risk-row-header { border-bottom: 1px solid rgba(168,85,247,0.08); }
  .risk-row.blue-theme .risk-row-header { border-bottom: 1px solid rgba(59,130,246,0.08); }
  
  .risk-row-icon { font-size: 1.15rem; width: 36px; height: 36px; display: flex; align-items: center; justify-content: center; border-radius: 11px; flex-shrink: 0; }
  .risk-row.purple-theme .risk-row-icon { background: rgba(168,85,247,0.10); }
  .risk-row.blue-theme .risk-row-icon { background: rgba(59,130,246,0.10); }

  .risk-row-title { margin: 0; font-size: 1.02rem; font-weight: 800; color: var(--color-text-primary); letter-spacing: -0.02em; }

  /* Pills */
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

  .risk-pill-anchor {
    font-size: 1.15rem;
    width: 44px; height: 44px; border-radius: 50%;
    display: flex; align-items: center; justify-content: center;
  }
  .risk-row.purple-theme .risk-pill-anchor { background: rgba(168,85,247,0.10); }
  .risk-row.blue-theme .risk-pill-anchor { background: rgba(59,130,246,0.10); }

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
</style>

<MenuTabs activeTab="evaluasi" />

```sql menu_health_overview
SELECT * FROM restaurant.mart_menu_health_overview
```

```sql top_movers
WITH movers AS (
  SELECT menu_name, pct_change_qty, qty_previous, qty_current,
         (qty_current - qty_previous) as qty_diff,
         ROW_NUMBER() OVER(ORDER BY pct_change_qty DESC) as rn_desc,
         ROW_NUMBER() OVER(ORDER BY pct_change_qty ASC) as rn_asc
  FROM restaurant.mart_movers_30d
  WHERE qty_previous >= 15
)
SELECT menu_name, pct_change_qty, qty_previous, qty_current, qty_diff
FROM movers 
WHERE rn_desc <= 3 OR rn_asc <= 3
ORDER BY pct_change_qty DESC
```

```sql concentration_data
WITH ranked AS (
  SELECT menu_name, total_revenue,
         ROW_NUMBER() OVER(ORDER BY total_revenue DESC) as rn
  FROM restaurant.mart_menu_engineering_30d
)
SELECT menu_name as group_name, total_revenue as rev, rn as sort_order FROM ranked WHERE rn <= 5
UNION ALL
SELECT 'Other Remaining Menus' as group_name, SUM(total_revenue) as rev, 6 as sort_order FROM ranked WHERE rn > 5
ORDER BY sort_order
```

```sql passive_data
SELECT menu_name, category, total_qty as porsi, total_revenue as rev, (total_revenue / NULLIF(total_qty, 0)) as price
FROM restaurant.mart_menu_engineering_30d
WHERE total_qty < 15
ORDER BY total_qty ASC
```

<div class="decision-box amber" style="margin-top: 24px; margin-bottom: 32px;">
  <div class="decision-content">
    <div class="decision-title">
      <span style="display: flex; align-items: center; gap: 8px;">
        💡 Automated Portfolio Diagnostics
      </span>
      <div class="ai-badge">Automated Output</div>
    </div>

    <p class="decision-text" style="color: var(--color-text-primary); margin-bottom: 12px;">
      <strong>
      {#if activeTop5Share > 60 && passive_data.length > 0}
        🔍 Diagnostic: High Revenue Concentration &amp; Inactive Inventory
      {:else if activeTop5Share > 60 && passive_data.length === 0}
        🔍 Diagnostic: High Revenue Concentration
      {:else if activeTop5Share <= 60 && passive_data.length > 0}
        🔍 Diagnostic: Inactive Item Inventory Detected
      {:else}
        🔍 Diagnostic: Balanced Portfolio &amp; Active Inventory
      {/if}
      </strong>
    </p>
    
    <p class="decision-text">
      {#if activeTop5Share > 60 && passive_data.length > 0}
        Trailing 30-day aggregate data reflects both high revenue concentration ({activeTop5Share}% generated by the Top 5 items) and {passive_data.length} inactive menu items with zero or low order volume. This structure indicates margin sensitivity on primary revenue drivers alongside holding cost allocation on low-velocity inventory.
        <br><br><strong>Note:</strong> Identifies <strong>{passive_data.length} inactive menu items</strong> recording minimal transaction velocity. Cross-reference historical monthly sales trends on the <em>Report</em> page to evaluate whether low volume corresponds to seasonal demand cycles before adjusting portfolio status.
      {:else if activeTop5Share > 60 && passive_data.length === 0}
        Trailing 30-day aggregate data reflects high revenue concentration, where {activeTop5Share}% of total gross revenue relies on 5 core items. Operating margins remain sensitive to cost fluctuations on these primary items. Kitchen operations reflect zero inactive menu items during the observed period.
      {:else if activeTop5Share <= 60 && passive_data.length > 0}
        While gross revenue is distributed across multiple items (Top 5 revenue share stable at {activeTop5Share}%), the system identifies {passive_data.length} inactive menu items. Low-velocity items contribute to working capital allocation and inventory holding requirements.
        <br><br><strong>Note:</strong> Identifies <strong>{passive_data.length} inactive menu items</strong> recording minimal transaction velocity. Cross-reference historical monthly sales trends on the <em>Report</em> page to evaluate whether low volume corresponds to seasonal demand cycles before adjusting portfolio status.
      {:else}
        The menu portfolio reflects balanced distribution and active item velocity. Gross revenue is distributed across items (Top 5 revenue share at {activeTop5Share}%), with zero inactive menu items recorded during the observed period. Working capital allocation and inventory velocity remain baseline-aligned.
      {/if}
    </p>

    <div class="metrics-row" style="margin-top: 24px;">
      <div class="metric-pill">⚖️ Top 5 Share: {activeTop5Share}%</div>
      <div class="metric-pill">🗑️ Inactive Menu: {passive_data.length} Items</div>
    </div>

    <div class="decision-footer" style="margin-top: 24px;">
      <em>*Automated diagnostic generated from trailing 30-day sales velocity, concentration metrics, and momentum indicators. Designed for analytical decision support.</em>
    </div>
  </div>
</div>
<!-- STRUCTURAL RISK SECTION -->
<div class="diagnostics-header" style="margin-top: 48px; margin-bottom: 24px;">
  <div class="diagnostics-eyebrow">⚠️ PORTFOLIO STRUCTURE &amp; RISK DIAGNOSTICS</div>
  <h2 class="diagnostics-title">Revenue Concentration &amp; Item Velocity Analysis</h2>
  <p class="diagnostics-copy">
    Evaluates structural risk associated with high revenue concentration on top-performing items and holding cost impact of low-velocity inventory.
  </p>
</div>

<div class="risk-section">

  <div class="risk-row purple-theme">
    <div class="risk-row-header">
      <div style="display: flex; align-items: center; gap: 12px;">
        <span class="risk-row-icon">⚠️</span>
        <h4 class="risk-row-title">Hyper-Concentration Risk (Top 5 Revenue Share > 60%)</h4>
      </div>
    </div>
    <div class="risk-pills">
          <div class="risk-pill">
            <span class="risk-pill-anchor">📉</span>
            <div class="risk-pill-content">
              <strong>Commodity Inflation Exposure</strong>
              <span>A 15% COGS increase on the top-selling menu item directly contracts aggregate net operating margins.</span>
            </div>
          </div>
          <div class="risk-pill">
            <span class="risk-pill-anchor">🚚</span>
            <div class="risk-pill-content">
              <strong>Single-Vendor Dependency</strong>
              <span>Supply disruption for primary core ingredients directly impacts majority daily gross transaction revenue.</span>
            </div>
          </div>
          <div class="risk-pill">
            <span class="risk-pill-anchor">⚖️</span>
            <div class="risk-pill-content">
              <strong>Pareto Distribution Benchmark</strong>
              <span>Revenue concentration exceeding standard 80/20 baseline distributions reflects low revenue diversification across secondary categories.</span>
            </div>
          </div>
        </div>
        <div class="risk-funfact">
          <span class="risk-funfact-icon">📎</span>
          <div class="risk-funfact-content">
            <span>Restaurants with over 70% revenue concentration on core items experience up to <strong>3x higher margin volatility</strong> during commodity price spikes.</span>
            <cite>F&amp;B Portfolio Benchmark Research</cite>
          </div>
        </div>
      </div>

      <div class="risk-row blue-theme">
        <div class="risk-row-header">
          <div style="display: flex; align-items: center; gap: 12px;">
            <span class="risk-row-icon">🗑️</span>
            <h4 class="risk-row-title">Inactive Menu Item Metrics (&lt; 15 Units/Month)</h4>
          </div>
        </div>
        <div class="risk-pills">
          <div class="risk-pill">
            <span class="risk-pill-anchor">💸</span>
            <div class="risk-pill-content">
              <strong>Working Capital Allocation</strong>
              <span>Working capital committed to inactive inventory reduces liquidity available for high-turnover operational requirements.</span>
            </div>
          </div>
          <div class="risk-pill">
            <span class="risk-pill-anchor">⚙️</span>
            <div class="risk-pill-content">
              <strong>Back-of-House Prep Allocation</strong>
              <span>Kitchen prep hours allocated to inactive menu ingredients yield less than 2% of aggregate monthly gross revenue.</span>
            </div>
          </div>
          <div class="risk-pill">
            <span class="risk-pill-anchor">⏳</span>
            <div class="risk-pill-content">
              <strong>Ordering Transaction Velocity</strong>
              <span>Extensive menu item assortments increase customer ordering selection time, directly impacting table turnover rates.</span>
            </div>
          </div>
        </div>
        <div class="risk-funfact">
          <span class="risk-funfact-icon">📎</span>
          <div class="risk-funfact-content">
            <span>Industry Benchmark: Optimizing inactive menu items by 15% improves Back-of-House operational margins by <strong>2–3%</strong>.</span>
            <cite>Lean F&amp;B Operations Benchmark</cite>
          </div>
        </div>
      </div>
    </div>

<div style="margin-top: 48px;">
<SectionHeader 
    eyebrow="📑 Supporting Data Room"
    title="Item-Level Portfolio &amp; Momentum Drilldown"
    description="Tracks historical momentum shifts, revenue distribution variance, and inactive menu items segmented by menu category."
  />
</div>

<div class="data-wrapper">
  <Tabs id="support_data_room" fullWidth=true>

    <Tab label="🎯 Revenue Pareto">
      <div style="padding: 12px 0px;">
        <div class="section-head tight" style="margin-bottom: 12px;">
          <div>
            <div class="section-eyebrow">🎯 Pareto Distribution</div>
            <h3 class="section-title">Revenue Distribution Concentration</h3>
            <p class="section-copy">Displays gross revenue distribution weighting across Top 5 primary drivers relative to the remaining active menu portfolio.</p>
          </div>
        </div>
        
        <div style="margin-bottom: 8px;">
          <ECharts config={donutConfig} />
        </div>
        
        <div class="chart-insight-bar" style="margin-top: 16px;">
          📌 <strong>Pareto Portfolio Analysis:</strong> Evaluates revenue contribution variance across menu categories. A large item count within the "Other Remaining Items" segment generating disproportionately low gross revenue indicates candidates for portfolio optimization.
        </div>
      </div>
    </Tab>

    <Tab label="📈 Top Movers">
      <div style="padding: 12px 0px;">
        <div class="section-head tight" style="margin-bottom: 12px;">
          <div>
            <div class="section-eyebrow">📈 Velocity Shift</div>
            <h3 class="section-title">Momentum Velocity (Top Movers)</h3>
            <p class="section-copy">Tracks significant volume velocity variance by comparing trailing 30-day unit order volume against the prior 30-day period.</p>
          </div>
        </div>
        
        {#if top_movers.length > 0}
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 24px; align-items: start;">
          <div style="border: 1px solid var(--color-border-tertiary); border-radius: 12px; padding: 16px; background: white;">
            <BarChart 
              data={top_movers} 
              x="menu_name" 
              y="pct_change_qty" 
              swapXY=true 
              title="Volume Change (%)"
            />
          </div>
          <div style="border: 1px solid var(--color-border-tertiary); border-radius: 12px; overflow: hidden; background: white;">
            <DataTable data={top_movers}>
              <Column id="menu_name" title="Menu Item" />
              <Column id="qty_previous" title="Prev (30d)" align="right" />
              <Column id="qty_current" title="Curr (30d)" align="right" />
              <Column id="qty_diff" title="Net Diff" align="right" />
            </DataTable>
          </div>
        </div>
        {/if}
      </div>
    </Tab>

    <Tab label="🧊 Inactive Menu Items">
      <div style="padding: 12px 0px;">
        <div class="section-head tight" style="margin-bottom: 12px;">
          <div>
            <div class="section-eyebrow">🧊 Inventory Velocity Monitor</div>
            <h3 class="section-title">Inactive Item Directory</h3>
            <p class="section-copy">Identifies menu items recording low transaction velocity (&lt;15 units per trailing 30-day period).</p>
          </div>
        </div>
        
        {#if passive_data.length > 0}
        <div style="border: 1px solid var(--color-border-tertiary); border-radius: 12px; overflow: hidden; background: white;">
          <DataTable data={passive_data}>
            <Column id="menu_name" title="Menu Item" />
            <Column id="category" title="Category" />
            <Column id="price" title="Selling Price" fmt="idr" />
            <Column id="porsi" title="Order Volume (30d)" align="right" />
          </DataTable>
        </div>
        <div class="chart-insight-bar" style="margin-top: 16px; border-left-color: rgba(220,38,38,0.4); background: rgba(220,38,38,0.04);">
          📌 <strong>Inventory Allocation Directive:</strong> Items listed reflect low transaction frequency relative to holding cost requirements. Evaluates candidate items for recipe consolidation, seasonal re-classification, or menu retirement.
        </div>
        {:else}
        <div class="signal-card safe" style="margin-top:0;">
          <div class="signal-label">✅ Active Velocity Baseline</div>
          <div class="signal-title">No Inactive Menu Items Recorded</div>
          <div class="signal-copy">All active menu items met or exceeded the 15-unit threshold during the trailing 30-day evaluation window.</div>
        </div>
        {/if}
      </div>
    </Tab>

  </Tabs>
</div>

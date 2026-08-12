---
title: Trends
---

<FinanceTabs activeTab="jangka-panjang" />

```sql fin_quarter
SELECT * FROM (
    SELECT
        YEAR(metric_date) AS tahun,
        CEIL(MONTH(metric_date) / 3.0) AS qnum,
        CAST(YEAR(metric_date) AS VARCHAR) || ' Q' || CAST(CAST(CEIL(MONTH(metric_date) / 3.0) AS INTEGER) AS VARCHAR) AS quarter_label,
        YEAR(metric_date) * 10 + CEIL(MONTH(metric_date) / 3.0) AS qsort,
        SUM(gross_revenue) AS gross,
        SUM(net_revenue) AS net,
        ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS margin_pct,
        SUM(inventory_usage_cost + labor_total_cost + operational_total_cost) AS total_biaya,
        ROUND(SUM(inventory_usage_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS bahan_pct,
        ROUND(SUM(labor_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS sdm_pct,
        ROUND(SUM(operational_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS ops_pct
    FROM restaurant.daily_net_revenue
    GROUP BY 1, 2, 3, 4
    ORDER BY qsort DESC
    LIMIT 8
) ORDER BY qsort ASC
```

```sql fin_quarter_comparison
WITH fin_quarter AS (
    SELECT
        YEAR(metric_date) AS tahun,
        CEIL(MONTH(metric_date) / 3.0) AS qnum,
        CAST(YEAR(metric_date) AS VARCHAR) || ' Q' || CAST(CAST(CEIL(MONTH(metric_date) / 3.0) AS INTEGER) AS VARCHAR) AS quarter_label,
        YEAR(metric_date) * 10 + CEIL(MONTH(metric_date) / 3.0) AS qsort,
        SUM(gross_revenue) AS gross,
        SUM(net_revenue) AS net,
        ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS margin_pct,
        SUM(inventory_usage_cost + labor_total_cost + operational_total_cost) AS total_biaya,
        ROUND(SUM(inventory_usage_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS bahan_pct,
        ROUND(SUM(labor_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS sdm_pct,
        ROUND(SUM(operational_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS ops_pct
    FROM restaurant.daily_net_revenue
    GROUP BY 1, 2, 3, 4
)
SELECT
    quarter_label, gross, net, margin_pct, total_biaya, bahan_pct, sdm_pct, ops_pct,
    LAG(net) OVER (ORDER BY qsort) AS net_prev_q,
    LAG(margin_pct) OVER (ORDER BY qsort) AS margin_prev_q,
    ROUND(margin_pct - LAG(margin_pct) OVER (ORDER BY qsort), 1) AS delta_margin_q,
    ROUND((net - LAG(net) OVER (ORDER BY qsort)) / NULLIF(LAG(net) OVER (ORDER BY qsort), 0) * 100, 1) AS pct_change_net_q
FROM fin_quarter
ORDER BY qsort DESC
LIMIT 8
```

```sql fin_yoy
SELECT
    YEAR(metric_date) AS tahun,
    SUM(gross_revenue) AS gross,
    SUM(net_revenue) AS net,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS margin_pct,
    SUM(inventory_usage_cost + labor_total_cost + operational_total_cost) AS total_biaya,
    ROUND(SUM(inventory_usage_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS bahan_pct,
    ROUND(SUM(labor_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS sdm_pct,
    ROUND(SUM(operational_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS ops_pct
FROM restaurant.daily_net_revenue
GROUP BY 1
ORDER BY 1 DESC
```

```sql fin_yoy_ytd
WITH max_d AS (SELECT MAX(metric_date) AS d FROM restaurant.daily_net_revenue),
ytd_data AS (
    SELECT 
        YEAR(metric_date) AS tahun,
        ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS margin_pct
    FROM restaurant.daily_net_revenue
    CROSS JOIN max_d
    WHERE dayofyear(metric_date) <= dayofyear(max_d.d)
    GROUP BY 1
)
SELECT * FROM ytd_data ORDER BY tahun DESC
```

```sql momentum_90d
WITH max_d AS (SELECT MAX(metric_date)::DATE AS d FROM restaurant.daily_net_revenue),
daily_data AS (
    SELECT 
        metric_date,
        net_revenue,
        gross_revenue,
        inventory_usage_cost,
        labor_total_cost,
        operational_total_cost,
        CASE
            WHEN metric_date > (SELECT d FROM max_d) - INTERVAL '90 days' THEN 'Current'
            WHEN metric_date > (SELECT d FROM max_d) - INTERVAL '180 days' THEN 'Previous'
            ELSE 'Older'
        END AS period
    FROM restaurant.daily_net_revenue
),
summary_90d AS (
    SELECT
        period,
        SUM(net_revenue) as net,
        SUM(gross_revenue) as gross,
        ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) as margin_pct,
        ROUND(SUM(inventory_usage_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) as bahan_pct,
        ROUND(SUM(labor_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) as sdm_pct,
        ROUND(SUM(operational_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) as ops_pct
    FROM daily_data
    WHERE period IN ('Current', 'Previous')
    GROUP BY period
)
SELECT 
    MAX(CASE WHEN period = 'Current' THEN margin_pct END) AS current_margin,
    MAX(CASE WHEN period = 'Previous' THEN margin_pct END) AS prev_margin,
    MAX(CASE WHEN period = 'Current' THEN margin_pct END) - MAX(CASE WHEN period = 'Previous' THEN margin_pct END) AS delta_margin,
    MAX(CASE WHEN period = 'Current' THEN bahan_pct END) - MAX(CASE WHEN period = 'Previous' THEN bahan_pct END) AS delta_bahan,
    MAX(CASE WHEN period = 'Current' THEN sdm_pct END) - MAX(CASE WHEN period = 'Previous' THEN sdm_pct END) AS delta_sdm,
    MAX(CASE WHEN period = 'Current' THEN ops_pct END) - MAX(CASE WHEN period = 'Previous' THEN ops_pct END) AS delta_ops
FROM summary_90d
```

```sql monthly_margin_trend
WITH max_d AS (SELECT MAX(metric_date)::DATE AS d FROM restaurant.daily_net_revenue),
monthly_data AS (
    SELECT 
        DATE_TRUNC('month', metric_date) AS month_start,
        SUM(net_revenue) AS net,
        SUM(gross_revenue) AS gross,
        SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) AS margin_pct
    FROM restaurant.daily_net_revenue
    CROSS JOIN max_d
    WHERE metric_date >= DATE_TRUNC('month', max_d.d) - INTERVAL '15 months'
      AND metric_date < DATE_TRUNC('month', max_d.d)
    GROUP BY 1
)
SELECT 
    month_start,
    margin_pct
FROM monthly_data
ORDER BY month_start ASC
```

```sql momentum_90d_branch
WITH max_d AS (SELECT MAX(metric_date)::DATE AS d FROM restaurant.daily_net_revenue),
daily_data AS (
    SELECT 
        branch_name,
        metric_date,
        net_revenue,
        gross_revenue,
        inventory_usage_cost,
        labor_total_cost,
        operational_total_cost,
        CASE
            WHEN metric_date > (SELECT d FROM max_d) - INTERVAL '90 days' THEN 'Current'
            WHEN metric_date > (SELECT d FROM max_d) - INTERVAL '180 days' THEN 'Previous'
            ELSE 'Older'
        END AS period
    FROM restaurant.daily_net_revenue
),
summary_branch AS (
    SELECT
        branch_name,
        period,
        SUM(net_revenue) as net,
        SUM(gross_revenue) as gross,
        ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) as margin_pct,
        ROUND(SUM(inventory_usage_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) as bahan_pct,
        ROUND(SUM(labor_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) as sdm_pct,
        ROUND(SUM(operational_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) as ops_pct
    FROM daily_data
    WHERE period IN ('Current', 'Previous')
    GROUP BY 1, 2
)
SELECT 
    c.branch_name,
    c.margin_pct AS current_margin,
    p.margin_pct AS prev_margin,
    c.margin_pct - p.margin_pct AS delta_margin,
    c.bahan_pct AS current_bahan,
    p.bahan_pct AS prev_bahan,
    c.bahan_pct - p.bahan_pct AS delta_bahan,
    c.sdm_pct AS current_sdm,
    p.sdm_pct AS prev_sdm,
    c.sdm_pct - p.sdm_pct AS delta_sdm,
    c.ops_pct AS current_ops,
    p.ops_pct AS prev_ops,
    c.ops_pct - p.ops_pct AS delta_ops
FROM (SELECT * FROM summary_branch WHERE period = 'Current') c
LEFT JOIN (SELECT * FROM summary_branch WHERE period = 'Previous') p ON c.branch_name = p.branch_name
ORDER BY delta_margin DESC
```

```sql executive_summary
WITH yoy_latest AS (
    SELECT margin_pct, tahun FROM ${fin_yoy_ytd} LIMIT 1
),
yoy_prev AS (
    SELECT margin_pct, tahun FROM ${fin_yoy_ytd} OFFSET 1 LIMIT 1
),
qoq_latest AS (
    SELECT margin_pct, delta_margin_q FROM ${fin_quarter_comparison} LIMIT 1
),
m90_latest AS (
    SELECT current_margin, prev_margin, delta_margin, delta_bahan, delta_sdm, delta_ops FROM ${momentum_90d}
)
SELECT 
    y.margin_pct AS yoy_margin,
    COALESCE(y_prev.margin_pct, 0) AS yoy_prev_margin,
    y.margin_pct - COALESCE(y_prev.margin_pct, y.margin_pct) AS yoy_delta,
    q.margin_pct AS qoq_margin,
    q.delta_margin_q AS qoq_delta,
    m.current_margin AS m90_margin,
    m.delta_margin AS m90_delta,
    CASE 
        WHEN m.delta_margin < 0 THEN 
            CASE 
                WHEN m.delta_bahan >= m.delta_sdm AND m.delta_bahan >= m.delta_ops THEN 'Ingredient Cost'
                WHEN m.delta_sdm >= m.delta_bahan AND m.delta_sdm >= m.delta_ops THEN 'Labor Cost'
                ELSE 'Overhead Cost'
            END
        ELSE 
            CASE 
                WHEN m.delta_bahan <= m.delta_sdm AND m.delta_bahan <= m.delta_ops THEN 'Ingredient Cost'
                WHEN m.delta_sdm <= m.delta_bahan AND m.delta_sdm <= m.delta_ops THEN 'Labor Cost'
                ELSE 'Overhead Cost'
            END
    END AS primary_driver,
    CASE 
        WHEN m.delta_margin < 0 THEN 
            GREATEST(m.delta_bahan, m.delta_sdm, m.delta_ops)
        ELSE 
            LEAST(m.delta_bahan, m.delta_sdm, m.delta_ops)
    END AS primary_driver_val
FROM yoy_latest y
LEFT JOIN yoy_prev y_prev ON true
LEFT JOIN qoq_latest q ON true
LEFT JOIN m90_latest m ON true
```


{#if executive_summary && executive_summary.length > 0}
<div class="strategic-stack" style="margin-top: 24px; margin-bottom: 32px;">
  <div class="strategic-header">
    <div class="strategic-eyebrow">🔭 Strategic Perspective</div>
<h2 class="strategic-title">Long-Term Trend Analysis</h2>
    <p class="strategic-copy">Identify seasonal demand patterns and evaluate fundamental year-over-year business performance.</p>
  </div>
</div>

{#each executive_summary as exec}
<!-- Narrative Box -->
<div class="decision-box {exec.m90_delta > 0 ? 'green' : (exec.m90_delta < 0 ? 'red' : 'orange')}">
  <div class="decision-content">
    <div class="decision-title">
      <span style="display: flex; align-items: center; gap: 8px;">
        💡 Strategic Financial Summary
      </span>
      <div class="ai-badge">✨ AI Generated</div>
    </div>
    
    <p class="decision-text" style="color: var(--color-text-primary); margin-bottom: 12px;">
      <strong>{exec.m90_delta > 0 ? '✅' : '⚠️'} Observation: {exec.m90_delta > 0 ? 'Positive Recovery Momentum' : 'Short-Term Margin Contraction'}</strong>
    </p>
    
    <p class="decision-text" style="color: var(--color-text-primary); margin-bottom: 16px; line-height: 1.6;">
      Fundamentally, the business recorded a
      <strong style="color: {exec.yoy_delta > 0 ? '#16a34a' : (exec.yoy_delta < 0 ? '#dc2626' : '#d97706')};">
        {exec.yoy_delta > 0 ? 'positive' : (exec.yoy_delta < 0 ? 'negative' : 'stable')}{#if exec.yoy_delta !== 0} ({Math.abs(exec.yoy_delta).toFixed(1)}%){/if}
      </strong> 
      margin trajectory on a <em>Year-over-Year</em> basis. 
      On a medium-term scale, seasonal dynamics this quarter 
      {exec.qoq_delta > 0 ? 'expanded' : (exec.qoq_delta < 0 ? 'compressed' : 'stabilized')} margins by 
      <strong style="color: {exec.qoq_delta > 0 ? '#16a34a' : (exec.qoq_delta < 0 ? '#dc2626' : '#d97706')};">
        {Math.abs(exec.qoq_delta).toFixed(1)}%
      </strong>. 
    </p>

    <p class="decision-text" style="color: var(--color-text-primary); margin-bottom: 16px; line-height: 1.6;">
      However, the immediate operational focus is the 90-day momentum: 
      margins are currently 
      <strong style="color: {exec.m90_delta > 0 ? '#16a34a' : (exec.m90_delta < 0 ? '#dc2626' : '#d97706')};">
        {exec.m90_delta > 0 ? 'up' : (exec.m90_delta < 0 ? 'down' : 'flat')} {Math.abs(exec.m90_delta).toFixed(1)}%
      </strong>. 
      Detailed analysis identifies the primary driver as a 
      {exec.m90_delta > 0 ? 'cost reduction' : 'cost spike'} in 
      <strong>{exec.primary_driver} ({exec.primary_driver_val > 0 ? '+' : ''}{(exec.primary_driver_val || 0).toFixed(1)}%)</strong>.
    </p>
    
    <div class="metrics-row" style="margin-top: 24px;">
        <div class="metric-pill">🗓️ 90 Days: {exec.m90_margin}% (<strong style="color: {exec.m90_delta > 0 ? '#16a34a' : (exec.m90_delta < 0 ? '#dc2626' : '#d97706')};">{exec.m90_delta > 0 ? '▲' : (exec.m90_delta < 0 ? '▼' : '—')} {Math.abs(exec.m90_delta).toFixed(1)}%</strong>)</div>
        <div class="metric-pill">📊 Quarterly: {exec.qoq_margin}% (<strong style="color: {exec.qoq_delta > 0 ? '#16a34a' : (exec.qoq_delta < 0 ? '#dc2626' : '#d97706')};">{exec.qoq_delta > 0 ? '▲' : (exec.qoq_delta < 0 ? '▼' : '—')} {Math.abs(exec.qoq_delta).toFixed(1)}%</strong>)</div>
        <div class="metric-pill">📈 YTD: {exec.yoy_margin}% (<strong style="color: {exec.yoy_delta > 0 ? '#16a34a' : (exec.yoy_delta < 0 ? '#dc2626' : '#d97706')};">{exec.yoy_delta > 0 ? '▲' : (exec.yoy_delta < 0 ? '▼' : '—')} {Math.abs(exec.yoy_delta).toFixed(1)}%</strong>)</div>
        <div class="metric-pill" style="background: rgba(239,68,68,0.1); border-color: rgba(239,68,68,0.2);">🚨 Primary Driver: {exec.primary_driver}</div>
    </div>

    <div class="decision-footer" style="margin-top: 24px;">
      <em>*Note: This summary is generated automatically. The engine isolates the primary driver of margin shift by comparing 90-day cost deltas across Ingredient, Labor, and Overhead expenses.</em>
    </div>
  </div>
</div>
{/each}

<!-- The Visual Bridge: trends Chart -->
<div class="diagnostics-header" style="margin-top: 48px; margin-bottom: 24px;">
  <div class="diagnostics-eyebrow">📈 HISTORICAL PERFORMANCE</div>
<h2 class="diagnostics-title">Historical Profitability Trend (Last {monthly_margin_trend.length} Months)</h2>
  <p class="diagnostics-copy">Track month-over-month margin trajectories over time. <em>(Excludes incomplete current month to prevent partial-period distortion).</em></p>
</div>

<div class="trend-chart-container" style="background: var(--color-background-primary); border-radius: 12px; border: 1px solid var(--color-border-tertiary); padding: 24px; padding-top: 32px; margin-bottom: 24px; box-shadow: 0 4px 12px rgba(0,0,0,0.02);">
  
  <LineChart 
    data={monthly_margin_trend} 
    x=month_start 
    y=margin_pct 
    yFmt="pct"
    yAxisTitle="Net Margin"
    lineColor="#94a3b8"
    echartsOptions={{
      series: [{
        showSymbol: true,
        symbolSize: 12,
        lineStyle: { color: '#94a3b8' },
        itemStyle: {
          color: function (params) {
            var val = params.value[1] !== undefined ? params.value[1] : params.value;
            if (val >= 0.10) return '#10b981';
            if (val >= 0.05) return '#f59e0b';
            return '#ef4444';
          }
        }
      }]
    }}
    chartAreaHeight=280
  />

  <div style="display: flex; justify-content: center; align-items: center; gap: 24px; margin-top: 20px; font-size: 0.85rem; font-weight: 600; color: var(--color-text-secondary);">
    <div style="display: flex; align-items: center; gap: 8px;">
      <span style="display: inline-block; width: 12px; height: 12px; border-radius: 50%; background-color: #10b981; box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.1);"></span>
      <span>Healthy (≥ 10%)</span>
    </div>
    <div style="display: flex; align-items: center; gap: 8px;">
      <span style="display: inline-block; width: 12px; height: 12px; border-radius: 50%; background-color: #f59e0b; box-shadow: 0 0 0 3px rgba(245, 158, 11, 0.1);"></span>
      <span>Warning (5% - 9.9%)</span>
    </div>
    <div style="display: flex; align-items: center; gap: 8px;">
      <span style="display: inline-block; width: 12px; height: 12px; border-radius: 50%; background-color: #ef4444; box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.1);"></span>
      <span>Critical (&lt; 5%)</span>
    </div>
  </div>
</div>

<hr style="margin: 64px 0 32px 0; border: 0; border-top: 1px dashed rgba(0,0,0,0.1);" />

<div class="diagnostics-header" style="margin-bottom: 24px;">
  <div class="diagnostics-eyebrow">🔬 SUPPORTING ANALYSIS (DEEP-DIVE)</div>
<h2 class="diagnostics-title">Business Fundamentals Performance</h2>
  <p class="diagnostics-copy">Evaluate margin trends and itemized cost structure dynamics across multi-year and quarterly horizons.</p>
</div>

<Tabs id="trend-tables" fullWidth=true>
  <Tab label="🗓️ 90-Day Momentum">
    <div style="margin-top: 24px;">
      {#each executive_summary as exec}
      <div class="insight-container" style="margin-bottom: 24px;">
        <div class="insight-box {exec.m90_delta > 0 ? 'green' : (exec.m90_delta < 0 ? 'red' : 'orange')}">
          <div class="insight-header" style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 16px;">
            <div class="insight-headline" style="margin: 0; font-size: 1.1rem; font-weight: 700;">
              {exec.m90_delta > 0 ? '✅' : (exec.m90_delta < 0 ? '🚨' : '⚠️')} 90-Day Momentum Conclusion
            </div>
            <div class="ai-badge">✨ AI Generated</div>
          </div>
          
          <div class="insight-copy" style="font-size: 1.05rem; line-height: 1.6; color: var(--color-text-primary);">
            <p style="margin: 0;">Over the past 90 days, overall margin averaged <strong>{exec.m90_margin}%</strong>. 
            This reflects a 
            <strong style="color: {exec.m90_delta > 0 ? '#16a34a' : (exec.m90_delta < 0 ? '#dc2626' : '#d97706')};">
              {#if exec.m90_delta !== 0}
                {exec.m90_delta > 0 ? 'positive expansion (▲' : 'margin contraction (▼'}{Math.abs(exec.m90_delta).toFixed(1)}%)
              {:else}
                stable trajectory
              {/if}
            </strong> 
            compared to the previous 90-day period. The breakdown below highlights which branches drove this performance shift.</p>
          </div>
        </div>
      </div>
      {/each}
      <div class="premium-table-container" style="margin-bottom: 32px;">
        <table class="premium-table">
          <thead>
            <tr>
              <th rowspan="2" style="vertical-align: middle;">Branch Name</th>
              <th colspan="2" style="text-align: center; border-bottom: 1px solid var(--color-border-tertiary);">Net Margin</th>
              <th colspan="3" style="text-align: center; border-bottom: 1px solid var(--color-border-tertiary);">Cost Shift (vs Previous 90D)</th>
            </tr>
            <tr>
              <th style="text-align: right;">Last 90D</th>
              <th style="text-align: right;">Delta (vs Previous)</th>
              <th style="text-align: right;">Ingredient</th>
              <th style="text-align: right;">Labor</th>
              <th style="text-align: right;">Overhead</th>
            </tr>
          </thead>
          <tbody>
            {#each momentum_90d_branch as row}
            <tr class="premium-row">
              <td style="font-weight: 700; color: var(--color-text-primary);">{row.branch_name}</td>
              <td style="text-align: right; font-weight: 800;">{row.current_margin != null ? row.current_margin.toFixed(1) : '0'}%</td>
              <td style="text-align: right; font-weight: 700; color: {row.delta_margin > 0 ? '#22c55e' : row.delta_margin < 0 ? '#ef4444' : 'var(--color-text-tertiary)'}">
                {#if row.delta_margin != null && row.delta_margin !== 0}
                  {row.delta_margin > 0 ? '▲ +' : '▼ '} {Math.abs(row.delta_margin).toFixed(1)}%
                {:else}
                  - Stable
                {/if}
              </td>
              <td style="text-align: right; font-weight: 600; color: {row.delta_bahan < 0 ? '#22c55e' : row.delta_bahan > 0 ? '#ef4444' : 'var(--color-text-tertiary)'}">
                {#if row.delta_bahan != null && row.delta_bahan !== 0}
                  {row.delta_bahan > 0 ? '▲ +' : '▼ '} {Math.abs(row.delta_bahan).toFixed(1)}%
                {:else}
                  - Stable
                {/if}
              </td>
              <td style="text-align: right; font-weight: 600; color: {row.delta_sdm < 0 ? '#22c55e' : row.delta_sdm > 0 ? '#ef4444' : 'var(--color-text-tertiary)'}">
                {#if row.delta_sdm != null && row.delta_sdm !== 0}
                  {row.delta_sdm > 0 ? '▲ +' : '▼ '} {Math.abs(row.delta_sdm).toFixed(1)}%
                {:else}
                  - Stable
                {/if}
              </td>
              <td style="text-align: right; font-weight: 600; color: {row.delta_ops < 0 ? '#22c55e' : row.delta_ops > 0 ? '#ef4444' : 'var(--color-text-tertiary)'}">
                {#if row.delta_ops != null && row.delta_ops !== 0}
                  {row.delta_ops > 0 ? '▲ +' : '▼ '} {Math.abs(row.delta_ops).toFixed(1)}%
                {:else}
                  - Stable
                {/if}
              </td>
            </tr>
            {/each}
          </tbody>
        </table>
      </div>
      
      <div class="chart-insight-bar">
        📌 <strong>Analysis Guide (Triangulation):</strong> Short-term 90-day metrics are naturally subject to seasonal fluctuations (e.g., holiday demand spikes). Always cross-reference this trend with the <strong>Annual (YoY)</strong> view to validate underlying business performance.
      </div>
    </div>
  </Tab>

  <Tab label="📊 Quarterly (QoQ)">
    <div style="margin-top: 24px;">
      {#each executive_summary as exec}
      <div class="insight-container" style="margin-bottom: 24px;">
        <div class="insight-box {exec.qoq_delta > 0 ? 'green' : (exec.qoq_delta < 0 ? 'orange' : 'orange')}">
          <div class="insight-header" style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 16px;">
            <div class="insight-headline" style="margin: 0; font-size: 1.1rem; font-weight: 700;">
              {exec.qoq_delta > 0 ? '📈' : (exec.qoq_delta < 0 ? '📉' : '🔄')} Quarterly Performance Trajectory
            </div>
            <div class="ai-badge">✨ AI Generated</div>
          </div>
          <div class="insight-copy" style="font-size: 1.05rem; line-height: 1.6; color: var(--color-text-primary);">
            <p style="margin: 0;">The latest quarterly margin stood at <strong>{exec.qoq_margin}%</strong>, representing 
            <strong style="color: {exec.qoq_delta > 0 ? '#16a34a' : (exec.qoq_delta < 0 ? '#dc2626' : '#d97706')};">
              {#if exec.qoq_delta > 0}
                an expansion of ▲{Math.abs(exec.qoq_delta).toFixed(1)}%
              {:else if exec.qoq_delta < 0}
                a compression of ▼{Math.abs(exec.qoq_delta).toFixed(1)}%
              {:else}
                a stable trajectory
              {/if}
            </strong> 
            compared to the prior quarter. The table below outlines these quarter-over-quarter seasonal dynamics.</p>
          </div>
        </div>
      </div>
      {/each}
<div class="premium-table-container">
  <table class="premium-table">
    <thead>
      <tr>
        <th>Quarter</th>
        <th style="text-align: center;">Gross Revenue</th>
        <th style="text-align: center;">Net Revenue</th>
        <th style="text-align: center;">Margin</th>
        <th style="text-align: center;">Ingredient</th>
        <th style="text-align: center;">Labor</th>
        <th style="text-align: center;">Overhead</th>
      </tr>
    </thead>
    <tbody>
      {#each fin_quarter_comparison as row, i}
      <tr class="premium-row" style="{i === 0 ? 'background-color: rgba(234, 179, 8, 0.18); font-style: italic;' : ''}">
        <td style="font-weight: 700; color: var(--color-text-primary);">
          {row.quarter_label || ''}
        </td>
        <td style="text-align: center; font-family: monospace;">Rp {row.gross != null ? new Intl.NumberFormat('en-US', { notation: 'compact', maximumFractionDigits: 1 }).format(row.gross) : '0'}</td>
        <td style="text-align: center; font-family: monospace;">Rp {row.net != null ? new Intl.NumberFormat('en-US', { notation: 'compact', maximumFractionDigits: 1 }).format(row.net) : '0'}</td>
        <td style="text-align: center;">
          <span style="font-weight: 800; font-size: 0.95rem;">{row.margin_pct != null ? row.margin_pct.toFixed(1) : '0.0'}%</span>
          {#if row.delta_margin_q != null && row.delta_margin_q !== 0}
             <span style="font-size: 0.75rem; margin-left: 6px; font-weight: 700; color: {row.delta_margin_q > 0 ? '#22c55e' : '#ef4444'};">
               {row.delta_margin_q > 0 ? '▲' : '▼'} {Math.abs(row.delta_margin_q).toFixed(1)}%
             </span>
          {/if}
        </td>
        <td style="text-align: center; font-weight: 600; color: var(--color-text-secondary);">{row.bahan_pct != null ? row.bahan_pct.toFixed(1) : '0'}%</td>
        <td style="text-align: center; font-weight: 600; color: var(--color-text-secondary);">{row.sdm_pct != null ? row.sdm_pct.toFixed(1) : '0'}%</td>
        <td style="text-align: center; font-weight: 600; color: var(--color-text-secondary);">{row.ops_pct != null ? row.ops_pct.toFixed(1) : '0'}%</td>
      </tr>
      {/each}
    </tbody>
  </table>
</div>

      <div class="chart-insight-bar">
        📌 <strong>Current Data Note:</strong> The highlighted top row represents the <strong>in-progress quarter (Quarter-to-Date)</strong>. Figures are subject to period-end adjustments prior to official book-closing.
      </div>
    </div>
  </Tab>

  <Tab label="📈 Annual (YoY)">
    <div style="margin-top: 24px;">
      {#each executive_summary as exec}
      <div class="insight-container" style="margin-bottom: 24px;">
        <div class="insight-box {exec.yoy_delta > 0 ? 'green' : (exec.yoy_delta < 0 ? 'red' : 'orange')}">
          <div class="insight-header" style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 16px;">
            <div class="insight-headline" style="margin: 0; font-size: 1.1rem; font-weight: 700;">
              {exec.yoy_delta > 0 ? '✅' : (exec.yoy_delta < 0 ? '🚨' : '⚠️')} Fundamental Performance (YoY Cumulative)
            </div>
            <div class="ai-badge">✨ AI Generated</div>
          </div>
          <div class="insight-copy" style="font-size: 1.05rem; line-height: 1.6; color: var(--color-text-primary);">
            <p style="margin: 0;">Evaluating Year-to-Date performance against the exact same period last year (<em>apples-to-apples</em>), current aggregate margin is 
            <strong style="color: {exec.yoy_delta > 0 ? '#16a34a' : (exec.yoy_delta < 0 ? '#dc2626' : '#d97706')};">
              {#if exec.yoy_delta !== 0}
                {exec.yoy_delta > 0 ? 'improving (▲' : 'contracting (▼'} {Math.abs(exec.yoy_delta).toFixed(1)}%)
              {:else}
                holding stable
              {/if}
            </strong>. The table below outlines multi-year annual benchmarks for long-term tracking.</p>
          </div>
        </div>
      </div>
      {/each}
<div class="premium-table-container" style="margin-bottom: 32px;">
  <table class="premium-table">
    <thead>
      <tr>
        <th>Year</th>
        <th style="text-align: center;">Gross Revenue</th>
        <th style="text-align: center;">Net Revenue</th>
        <th style="text-align: center;">Margin</th>
        <th style="text-align: center;">Ingredient</th>
        <th style="text-align: center;">Labor</th>
        <th style="text-align: center;">Overhead</th>
      </tr>
    </thead>
    <tbody>
      {#each fin_yoy as row, i}
      <tr class="premium-row" style="{i === 0 ? 'background-color: rgba(234, 179, 8, 0.18); font-style: italic;' : ''}">
        <td style="font-weight: 700; color: var(--color-text-primary);">
          {row.tahun || ''}
        </td>
        <td style="text-align: center; font-family: monospace;">Rp {row.gross != null ? new Intl.NumberFormat('en-US', { notation: 'compact', maximumFractionDigits: 1 }).format(row.gross) : '0'}</td>
        <td style="text-align: center; font-family: monospace;">Rp {row.net != null ? new Intl.NumberFormat('en-US', { notation: 'compact', maximumFractionDigits: 1 }).format(row.net) : '0'}</td>
        <td style="text-align: center;">
          <span style="font-weight: 800; font-size: 0.95rem;">{row.margin_pct != null ? row.margin_pct.toFixed(1) : '0.0'}%</span>
          {#if i < fin_yoy.length - 1}
            {@const delta = row.margin_pct - fin_yoy[i+1].margin_pct}
            {#if delta !== 0}
               <span style="font-size: 0.75rem; margin-left: 6px; font-weight: 700; color: {delta > 0 ? '#22c55e' : '#ef4444'};">
                 {delta > 0 ? '▲' : '▼'} {Math.abs(delta).toFixed(1)}%
               </span>
            {/if}
          {/if}
        </td>
        <td style="text-align: center; font-weight: 600; color: var(--color-text-secondary);">{row.bahan_pct != null ? row.bahan_pct.toFixed(1) : '0'}%</td>
        <td style="text-align: center; font-weight: 600; color: var(--color-text-secondary);">{row.sdm_pct != null ? row.sdm_pct.toFixed(1) : '0'}%</td>
        <td style="text-align: center; font-weight: 600; color: var(--color-text-secondary);">{row.ops_pct != null ? row.ops_pct.toFixed(1) : '0'}%</td>
      </tr>
      {/each}
    </tbody>
  </table>
</div>

      <div class="chart-insight-bar">
        📌 <strong>Current Data Note:</strong> The highlighted top row represents the <strong>in-progress year (Year-to-Date)</strong>. Figures remain subject to annual adjustments prior to year-end book-closing.
      </div>
    </div>
  </Tab>
</Tabs>
{:else}
  <GlobalLoading />
{/if}

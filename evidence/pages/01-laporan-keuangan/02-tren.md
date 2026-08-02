---
title: Laporan Keuangan
sidebar: hide
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
                WHEN m.delta_bahan >= m.delta_sdm AND m.delta_bahan >= m.delta_ops THEN 'Bahan Baku'
                WHEN m.delta_sdm >= m.delta_bahan AND m.delta_sdm >= m.delta_ops THEN 'SDM'
                ELSE 'Operasional'
            END
        ELSE 
            CASE 
                WHEN m.delta_bahan <= m.delta_sdm AND m.delta_bahan <= m.delta_ops THEN 'Bahan Baku'
                WHEN m.delta_sdm <= m.delta_bahan AND m.delta_sdm <= m.delta_ops THEN 'SDM'
                ELSE 'Operasional'
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
    <div class="strategic-eyebrow">🔭 Perspektif Strategis</div>
    <h2 class="strategic-title">Baca pola jangka panjang</h2>
    <p class="strategic-copy">Dua metrik di bawah ini dirancang untuk menjawab: apakah ada pola musiman yang perlu diantisipasi, dan apakah bisnis membaik secara fundamental dari tahun ke tahun?</p>
  </div>
</div>

{#each executive_summary as exec}
<!-- Narrative Box -->
<div class="decision-box {exec.m90_delta > 0 ? 'green' : (exec.m90_delta < 0 ? 'red' : 'orange')}">
  <div class="decision-content">
    <div class="decision-title">
      <span style="display: flex; align-items: center; gap: 8px;">
        💡 Sintesis Finansial Makro
      </span>
      <div class="ai-badge">✨ AI Generated</div>
    </div>
    
    <p class="decision-text" style="color: var(--color-text-primary); margin-bottom: 12px;">
      <strong>{exec.m90_delta > 0 ? '✅' : '⚠️'} Observasi: {exec.m90_delta > 0 ? 'Momentum Pemulihan Positif' : 'Kontraksi Margin Jangka Pendek'}</strong>
    </p>
    
    <p class="decision-text" style="color: var(--color-text-primary); margin-bottom: 16px; line-height: 1.6;">
      Secara fundamental, bisnis mencatatkan pergerakan margin yang 
      <strong style="color: {exec.yoy_delta > 0 ? '#16a34a' : (exec.yoy_delta < 0 ? '#dc2626' : '#d97706')};">
        {exec.yoy_delta > 0 ? 'positif' : (exec.yoy_delta < 0 ? 'negatif' : 'stabil')}{#if exec.yoy_delta !== 0} ({Math.abs(exec.yoy_delta).toFixed(1)}%){/if}
      </strong> 
      secara <em>Year-to-Date</em> dibanding tahun lalu. 
      Di skala jangka menengah, efek musiman pada Kuartal terkini turut 
      {exec.qoq_delta > 0 ? 'mendorong' : (exec.qoq_delta < 0 ? 'menekan' : 'menstabilkan')} margin sebesar 
      <strong style="color: {exec.qoq_delta > 0 ? '#16a34a' : (exec.qoq_delta < 0 ? '#dc2626' : '#d97706')};">
        {Math.abs(exec.qoq_delta).toFixed(1)}%
      </strong>. 
    </p>

    <p class="decision-text" style="color: var(--color-text-primary); margin-bottom: 16px; line-height: 1.6;">
      Namun, yang paling krusial untuk ditindaklanjuti adalah momentum 90 Hari Terakhir: 
      Margin kita sedang 
      <strong style="color: {exec.m90_delta > 0 ? '#16a34a' : (exec.m90_delta < 0 ? '#dc2626' : '#d97706')};">
        {exec.m90_delta > 0 ? 'naik' : (exec.m90_delta < 0 ? 'anjlok' : 'stagnan')} {Math.abs(exec.m90_delta).toFixed(1)}%
      </strong>, 
      dan setelah dibedah, faktor penentu (episentrum) utamanya berada pada 
      {exec.m90_delta > 0 ? 'penghematan' : 'pembengkakan'} di sektor 
      <strong>Biaya {exec.primary_driver} ({exec.primary_driver_val > 0 ? '+' : ''}{(exec.primary_driver_val || 0).toFixed(1)}%)</strong>.
    </p>
    
    <div class="metrics-row" style="margin-top: 24px;">
        <div class="metric-pill">🗓️ 90 Hari: {exec.m90_margin}% (<strong style="color: {exec.m90_delta > 0 ? '#16a34a' : (exec.m90_delta < 0 ? '#dc2626' : '#d97706')};">{exec.m90_delta > 0 ? '▲' : (exec.m90_delta < 0 ? '▼' : '—')} {Math.abs(exec.m90_delta).toFixed(1)}%</strong>)</div>
        <div class="metric-pill">📊 Kuartalan: {exec.qoq_margin}% (<strong style="color: {exec.qoq_delta > 0 ? '#16a34a' : (exec.qoq_delta < 0 ? '#dc2626' : '#d97706')};">{exec.qoq_delta > 0 ? '▲' : (exec.qoq_delta < 0 ? '▼' : '—')} {Math.abs(exec.qoq_delta).toFixed(1)}%</strong>)</div>
        <div class="metric-pill">📈 YTD: {exec.yoy_margin}% (<strong style="color: {exec.yoy_delta > 0 ? '#16a34a' : (exec.yoy_delta < 0 ? '#dc2626' : '#d97706')};">{exec.yoy_delta > 0 ? '▲' : (exec.yoy_delta < 0 ? '▼' : '—')} {Math.abs(exec.yoy_delta).toFixed(1)}%</strong>)</div>
        <div class="metric-pill" style="background: rgba(239,68,68,0.1); border-color: rgba(239,68,68,0.2);">🚨 Titik Api: {exec.primary_driver}</div>
    </div>

    <div class="decision-footer" style="margin-top: 24px;">
      <em>*Disclaimer: Sintesis ini dikalkulasi secara otomatis. AI melacak titik api (episentrum) perubahan margin dengan membandingkan delta Biaya Bahan, SDM, dan Operasional selama 90 hari terakhir.</em>
    </div>
  </div>
</div>
{/each}

<!-- The Visual Bridge: Trend Chart -->
<div class="diagnostics-header" style="margin-top: 48px; margin-bottom: 24px;">
  <div class="diagnostics-eyebrow">📈 TREK HISTORIS</div>
  <h2 class="diagnostics-title">Peta Perjalanan Profitabilitas ({monthly_margin_trend.length} Bulan Terakhir)</h2>
  <p class="diagnostics-copy">Merekam tren pergerakan margin dari bulan ke bulan. <em>(Bulan berjalan dikecualikan untuk mencegah anomali data).</em></p>
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
      <span>Sehat (≥ 10%)</span>
    </div>
    <div style="display: flex; align-items: center; gap: 8px;">
      <span style="display: inline-block; width: 12px; height: 12px; border-radius: 50%; background-color: #f59e0b; box-shadow: 0 0 0 3px rgba(245, 158, 11, 0.1);"></span>
      <span>Waspada (5% - 9.9%)</span>
    </div>
    <div style="display: flex; align-items: center; gap: 8px;">
      <span style="display: inline-block; width: 12px; height: 12px; border-radius: 50%; background-color: #ef4444; box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.1);"></span>
      <span>Kritis (&lt; 5%)</span>
    </div>
  </div>
</div>

<hr style="margin: 64px 0 32px 0; border: 0; border-top: 1px dashed rgba(0,0,0,0.1);" />

<div class="diagnostics-header" style="margin-bottom: 24px;">
  <div class="diagnostics-eyebrow">🔬 ANALISIS PENDUKUNG (DEEP-DIVE)</div>
  <h2 class="diagnostics-title">Rekam Jejak Fundamental Bisnis</h2>
  <p class="diagnostics-copy">Membedah metrik margin bersih dan riwayat pergerakan struktur biaya secara mendetail dari tahun ke tahun maupun antar kuartal.</p>
</div>

<Tabs id="trend-tables" fullWidth=true>
  <Tab label="🗓️ Momentum 90 Hari">
    <div style="margin-top: 24px;">
      {#each executive_summary as exec}
      <div class="insight-container" style="margin-bottom: 24px;">
        <div class="insight-box {exec.m90_delta > 0 ? 'green' : (exec.m90_delta < 0 ? 'red' : 'orange')}">
          <div class="insight-header" style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 16px;">
            <div class="insight-headline" style="margin: 0; font-size: 1.1rem; font-weight: 700;">
              {exec.m90_delta > 0 ? '✅' : (exec.m90_delta < 0 ? '🚨' : '⚠️')} Kesimpulan Momentum 90 Hari
            </div>
            <div class="ai-badge">✨ AI Generated</div>
          </div>
          
          <div class="insight-copy" style="font-size: 1.05rem; line-height: 1.6; color: var(--color-text-primary);">
            <p style="margin: 0;">Dalam 90 hari terakhir, rata-rata margin restoran berada di angka <strong>{exec.m90_margin}%</strong>. 
            Ini merupakan pergerakan 
            <strong style="color: {exec.m90_delta > 0 ? '#16a34a' : (exec.m90_delta < 0 ? '#dc2626' : '#d97706')};">
              {#if exec.m90_delta !== 0}
                {exec.m90_delta > 0 ? 'POSITIF (▲' : 'NEGATIF (▼'}{Math.abs(exec.m90_delta).toFixed(1)}%)
              {:else}
                STABIL
              {/if}
            </strong> 
            dibandingkan 90 hari sebelumnya. Tabel di bawah membedah cabang mana yang paling memicu pergerakan tersebut.</p>
          </div>
        </div>
      </div>
      {/each}
      <div class="premium-table-container" style="margin-bottom: 32px;">
        <table class="premium-table">
          <thead>
            <tr>
              <th rowspan="2" style="vertical-align: middle;">Nama Cabang</th>
              <th colspan="2" style="text-align: center; border-bottom: 1px solid var(--color-border-tertiary);">Net Margin</th>
              <th colspan="3" style="text-align: center; border-bottom: 1px solid var(--color-border-tertiary);">Pergeseran Biaya (vs 90H Sblmnya)</th>
            </tr>
            <tr>
              <th style="text-align: right;">90H Terakhir</th>
              <th style="text-align: right;">Delta (vs Sblmnya)</th>
              <th style="text-align: right;">Bahan</th>
              <th style="text-align: right;">SDM</th>
              <th style="text-align: right;">Operasional</th>
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
                  - Stabil
                {/if}
              </td>
              <td style="text-align: right; font-weight: 600; color: {row.delta_bahan < 0 ? '#22c55e' : row.delta_bahan > 0 ? '#ef4444' : 'var(--color-text-tertiary)'}">
                {#if row.delta_bahan != null && row.delta_bahan !== 0}
                  {row.delta_bahan > 0 ? '▲ +' : '▼ '} {Math.abs(row.delta_bahan).toFixed(1)}%
                {:else}
                  - Stabil
                {/if}
              </td>
              <td style="text-align: right; font-weight: 600; color: {row.delta_sdm < 0 ? '#22c55e' : row.delta_sdm > 0 ? '#ef4444' : 'var(--color-text-tertiary)'}">
                {#if row.delta_sdm != null && row.delta_sdm !== 0}
                  {row.delta_sdm > 0 ? '▲ +' : '▼ '} {Math.abs(row.delta_sdm).toFixed(1)}%
                {:else}
                  - Stabil
                {/if}
              </td>
              <td style="text-align: right; font-weight: 600; color: {row.delta_ops < 0 ? '#22c55e' : row.delta_ops > 0 ? '#ef4444' : 'var(--color-text-tertiary)'}">
                {#if row.delta_ops != null && row.delta_ops !== 0}
                  {row.delta_ops > 0 ? '▲ +' : '▼ '} {Math.abs(row.delta_ops).toFixed(1)}%
                {:else}
                  - Stabil
                {/if}
              </td>
            </tr>
            {/each}
          </tbody>
        </table>
      </div>
      
      <div class="chart-insight-bar">
        📌 <strong>Panduan Analisis (Triangulasi):</strong> Metrik 90 Hari rentan terhadap bias musiman (misal: Lebaran). Selalu silangkan data ini dengan tab <strong>Tahunan (YoY)</strong> untuk memvalidasi performa.
      </div>
    </div>
  </Tab>

  <Tab label="📊 Kuartalan (QoQ)">
    <div style="margin-top: 24px;">
      {#each executive_summary as exec}
      <div class="insight-container" style="margin-bottom: 24px;">
        <div class="insight-box {exec.qoq_delta > 0 ? 'green' : (exec.qoq_delta < 0 ? 'orange' : 'orange')}">
          <div class="insight-header" style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 16px;">
            <div class="insight-headline" style="margin: 0; font-size: 1.1rem; font-weight: 700;">
              {exec.qoq_delta > 0 ? '📈' : (exec.qoq_delta < 0 ? '📉' : '🔄')} Kesimpulan Musiman Kuartalan
            </div>
            <div class="ai-badge">✨ AI Generated</div>
          </div>
          <div class="insight-copy" style="font-size: 1.05rem; line-height: 1.6; color: var(--color-text-primary);">
            <p style="margin: 0;">Margin kuartal terkini tercatat sebesar <strong>{exec.qoq_margin}%</strong>. Angka ini 
            <strong style="color: {exec.qoq_delta > 0 ? '#16a34a' : (exec.qoq_delta < 0 ? '#dc2626' : '#d97706')};">
              {#if exec.qoq_delta !== 0}
                {exec.qoq_delta > 0 ? 'naik (▲' : 'turun (▼'} {Math.abs(exec.qoq_delta).toFixed(1)}%)
              {:else}
                stabil
              {/if}
            </strong> 
            bila dibandingkan dengan kuartal sebelumnya. Tabel historis di bawah melacak pola siklus ini setiap 3 bulan.</p>
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
        <th style="text-align: center;">Net Margin</th>
        <th style="text-align: center;">Bahan</th>
        <th style="text-align: center;">SDM</th>
        <th style="text-align: center;">Operasional</th>
      </tr>
    </thead>
    <tbody>
      {#each fin_quarter_comparison as row, i}
      <tr class="premium-row" style="{i === 0 ? 'background-color: rgba(234, 179, 8, 0.18); font-style: italic;' : ''}">
        <td style="font-weight: 700; color: var(--color-text-primary);">
          {row.quarter_label || ''}
        </td>
        <td style="text-align: center; font-family: monospace;">Rp {row.gross != null ? new Intl.NumberFormat('id-ID', { notation: 'compact', maximumFractionDigits: 1 }).format(row.gross) : '0'}</td>
        <td style="text-align: center; font-family: monospace;">Rp {row.net != null ? new Intl.NumberFormat('id-ID', { notation: 'compact', maximumFractionDigits: 1 }).format(row.net) : '0'}</td>
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
        📌 <strong>Catatan Data Berjalan:</strong> Baris teratas yang disorot menampilkan data kuartal yang <strong>belum selesai</strong> (<em>Quarter-to-Date</em>). Fluktuasi pada periode ini wajar terjadi sebelum tutup buku di akhir kuartal.
      </div>
    </div>
  </Tab>

  <Tab label="📈 Tahunan (YoY)">
    <div style="margin-top: 24px;">
      {#each executive_summary as exec}
      <div class="insight-container" style="margin-bottom: 24px;">
        <div class="insight-box {exec.yoy_delta > 0 ? 'green' : (exec.yoy_delta < 0 ? 'red' : 'orange')}">
          <div class="insight-header" style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 16px;">
            <div class="insight-headline" style="margin: 0; font-size: 1.1rem; font-weight: 700;">
              {exec.yoy_delta > 0 ? '✅' : (exec.yoy_delta < 0 ? '🚨' : '⚠️')} Kesimpulan Fundamental (Metode YTD)
            </div>
            <div class="ai-badge">✨ AI Generated</div>
          </div>
          <div class="insight-copy" style="font-size: 1.05rem; line-height: 1.6; color: var(--color-text-primary);">
            <p style="margin: 0;">Membandingkan margin <em>Year-to-Date</em> (sejak 1 Januari hingga data terbaru) melawan periode yang persis sama tahun lalu (<em>apples-to-apples</em>), margin kita saat ini 
            <strong style="color: {exec.yoy_delta > 0 ? '#16a34a' : (exec.yoy_delta < 0 ? '#dc2626' : '#d97706')};">
              {#if exec.yoy_delta !== 0}
                {exec.yoy_delta > 0 ? 'membaik (▲' : 'menurun (▼'} {Math.abs(exec.yoy_delta).toFixed(1)}%)
              {:else}
                stabil
              {/if}
            </strong>. Tabel di bawah ini tetap mencatat data riwayat tahunan secara penuh sebagai arsip historis.</p>
          </div>
        </div>
      </div>
      {/each}
<div class="premium-table-container" style="margin-bottom: 32px;">
  <table class="premium-table">
    <thead>
      <tr>
        <th>Tahun</th>
        <th style="text-align: center;">Gross Revenue</th>
        <th style="text-align: center;">Net Revenue</th>
        <th style="text-align: center;">Net Margin</th>
        <th style="text-align: center;">Bahan</th>
        <th style="text-align: center;">SDM</th>
        <th style="text-align: center;">Operasional</th>
      </tr>
    </thead>
    <tbody>
      {#each fin_yoy as row, i}
      <tr class="premium-row" style="{i === 0 ? 'background-color: rgba(234, 179, 8, 0.18); font-style: italic;' : ''}">
        <td style="font-weight: 700; color: var(--color-text-primary);">
          {row.tahun || ''}
        </td>
        <td style="text-align: center; font-family: monospace;">Rp {row.gross != null ? new Intl.NumberFormat('id-ID', { notation: 'compact', maximumFractionDigits: 1 }).format(row.gross) : '0'}</td>
        <td style="text-align: center; font-family: monospace;">Rp {row.net != null ? new Intl.NumberFormat('id-ID', { notation: 'compact', maximumFractionDigits: 1 }).format(row.net) : '0'}</td>
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
        📌 <strong>Catatan Data Berjalan:</strong> Baris teratas yang disorot menampilkan data tahun berjalan yang <strong>belum selesai</strong> (<em>Year-to-Date</em>). Fluktuasi pada periode ini wajar terjadi sebelum tutup buku di akhir tahun.
      </div>
    </div>
  </Tab>
</Tabs>
{:else}
  <GlobalLoading />
{/if}

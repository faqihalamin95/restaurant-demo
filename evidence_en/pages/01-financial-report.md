---
title: Financial Report
---

_Business financial health — profitability, cost structure, and margin trends._

```sql header_kpi
SELECT
    SUM(gross_revenue)                                                        AS gross_revenue,
    SUM(inventory_usage_cost + labor_total_cost + operational_total_cost)     AS total_costs,
    SUM(net_revenue)                                                           AS net_revenue,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1)          AS net_margin_pct
FROM restaurant_en.daily_net_revenue
WHERE metric_date >= (SELECT MAX(metric_date) FROM restaurant_en.daily_net_revenue) - INTERVAL '30 days'
```

```sql margin_vs_prev
SELECT
    ROUND(SUM(CASE WHEN metric_date >= (SELECT MAX(metric_date) FROM restaurant_en.daily_net_revenue) - INTERVAL '30 days'
        THEN net_revenue END) /
    NULLIF(SUM(CASE WHEN metric_date >= (SELECT MAX(metric_date) FROM restaurant_en.daily_net_revenue) - INTERVAL '30 days'
        THEN gross_revenue END), 0) * 100, 1) AS margin_30d,
    ROUND(SUM(CASE WHEN metric_date >= (SELECT MAX(metric_date) FROM restaurant_en.daily_net_revenue) - INTERVAL '60 days'
               AND metric_date <  (SELECT MAX(metric_date) FROM restaurant_en.daily_net_revenue) - INTERVAL '30 days'
        THEN net_revenue END) /
    NULLIF(SUM(CASE WHEN metric_date >= (SELECT MAX(metric_date) FROM restaurant_en.daily_net_revenue) - INTERVAL '60 days'
               AND metric_date <  (SELECT MAX(metric_date) FROM restaurant_en.daily_net_revenue) - INTERVAL '30 days'
        THEN gross_revenue END), 0) * 100, 1) AS margin_30d_prev,
    ROUND(
        ROUND(SUM(CASE WHEN metric_date >= (SELECT MAX(metric_date) FROM restaurant_en.daily_net_revenue) - INTERVAL '30 days'
            THEN net_revenue END) /
        NULLIF(SUM(CASE WHEN metric_date >= (SELECT MAX(metric_date) FROM restaurant_en.daily_net_revenue) - INTERVAL '30 days'
            THEN gross_revenue END), 0) * 100, 1)
        -
        ROUND(SUM(CASE WHEN metric_date >= (SELECT MAX(metric_date) FROM restaurant_en.daily_net_revenue) - INTERVAL '60 days'
               AND metric_date <  (SELECT MAX(metric_date) FROM restaurant_en.daily_net_revenue) - INTERVAL '30 days'
            THEN net_revenue END) /
        NULLIF(SUM(CASE WHEN metric_date >= (SELECT MAX(metric_date) FROM restaurant_en.daily_net_revenue) - INTERVAL '60 days'
               AND metric_date <  (SELECT MAX(metric_date) FROM restaurant_en.daily_net_revenue) - INTERVAL '30 days'
            THEN gross_revenue END), 0) * 100, 1)
    , 1) AS margin_delta
FROM restaurant_en.daily_net_revenue
```

```sql location_margin_alert
SELECT
    branch_name,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS net_margin_pct
FROM restaurant_en.daily_net_revenue
WHERE metric_date >= (SELECT MAX(metric_date) FROM restaurant_en.daily_net_revenue) - INTERVAL '30 days'
GROUP BY branch_name
HAVING net_margin_pct < 10
ORDER BY net_margin_pct ASC
```

```sql periode_30d
SELECT
    STRFTIME('%b %d, %Y', MAX(metric_date) - INTERVAL '29 days') AS date_from,
    STRFTIME('%b %d, %Y', MAX(metric_date))                       AS date_to
FROM restaurant_en.daily_net_revenue
```

---

## Last 30 Days Summary

<span style="font-size:0.85em;color:var(--color-text-secondary)">{periode_30d[0].date_from} – {periode_30d[0].date_to}</span>

<BigValue data={header_kpi} value="gross_revenue"  title="Gross Revenue"  fmt="$#,##0.00" />
<BigValue data={header_kpi} value="total_costs"    title="Total Costs"    fmt="$#,##0.00" />
<BigValue data={header_kpi} value="net_revenue"    title="Net Revenue"    fmt="$#,##0.00" />
<BigValue data={header_kpi} value="net_margin_pct" title="Net Margin"     fmt="0.0\%" />

{#if margin_vs_prev[0].margin_delta < -2}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:12px 16px;border-radius:6px;margin:16px 0;">
🚨 <strong>Margin dropped {Math.abs(margin_vs_prev[0].margin_delta)} pts</strong> vs the prior 30 days ({margin_vs_prev[0].margin_30d_prev}% → {margin_vs_prev[0].margin_30d}%). Costs are growing faster than revenue — review the cost breakdown below.
</div>
{:else if margin_vs_prev[0].margin_delta > 2}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:12px 16px;border-radius:6px;margin:16px 0;">
✅ <strong>Margin improved {margin_vs_prev[0].margin_delta} pts</strong> vs the prior 30 days ({margin_vs_prev[0].margin_30d_prev}% → {margin_vs_prev[0].margin_30d}%). Cost efficiency is trending better.
</div>
{:else}
<div style="background:rgba(100,116,139,0.08);border-left:4px solid #888;padding:12px 16px;border-radius:6px;margin:16px 0;">
➡️ <strong>Margin stable</strong> at {margin_vs_prev[0].margin_30d}% — only {margin_vs_prev[0].margin_delta} pts vs prior 30 days.
</div>
{/if}

{#if location_margin_alert.length > 0}
<div style="background:rgba(248,201,0,0.1);border-left:4px solid #f8c900;padding:12px 16px;border-radius:6px;margin:8px 0;">
⚠️ <strong>Margin below 10%:</strong>
{#each location_margin_alert as row}
{row.branch_name} ({row.net_margin_pct}%)&nbsp;
{/each}
— these locations need a cost review.
</div>
{/if}

---

## Cost Structure (Last 30 Days)

```sql cost_structure_30d
SELECT
    branch_name,
    SUM(gross_revenue)          AS gross_revenue,
    SUM(inventory_usage_cost)   AS cost_ingredients,
    SUM(labor_total_cost)       AS cost_labor,
    SUM(operational_total_cost) AS cost_overhead,
    SUM(net_revenue)            AS net_revenue,
    ROUND(SUM(inventory_usage_cost)   / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS pct_ingredients,
    ROUND(SUM(labor_total_cost)       / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS pct_labor,
    ROUND(SUM(operational_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS pct_overhead,
    ROUND(SUM(net_revenue)            / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS net_margin_pct
FROM restaurant_en.daily_net_revenue
WHERE metric_date >= (SELECT MAX(metric_date) FROM restaurant_en.daily_net_revenue) - INTERVAL '30 days'
GROUP BY branch_name
ORDER BY net_revenue DESC
```

```sql cost_proportion_all
SELECT 'Ingredients' AS component, SUM(inventory_usage_cost)   AS total FROM restaurant_en.daily_net_revenue
WHERE metric_date >= (SELECT MAX(metric_date) FROM restaurant_en.daily_net_revenue) - INTERVAL '30 days'
UNION ALL
SELECT 'Labor',                     SUM(labor_total_cost)       AS total FROM restaurant_en.daily_net_revenue
WHERE metric_date >= (SELECT MAX(metric_date) FROM restaurant_en.daily_net_revenue) - INTERVAL '30 days'
UNION ALL
SELECT 'Overhead',                  SUM(operational_total_cost) AS total FROM restaurant_en.daily_net_revenue
WHERE metric_date >= (SELECT MAX(metric_date) FROM restaurant_en.daily_net_revenue) - INTERVAL '30 days'
```

<Grid cols=2>
<div>

### Cost Mix by Location

<BarChart
    data={cost_structure_30d}
    x="branch_name"
    y={["cost_ingredients", "cost_labor", "cost_overhead"]}
    type="stacked"
    title="Cost Breakdown by Location — 30 Days"
    yFmt="$#,##0"
    xAxisTitle="Location"
    yAxisTitle="Total Cost ($)"
/>

</div>
<div>

### Overall Cost Proportion

<BarChart
    data={cost_proportion_all}
    x="component"
    y="total"
    title="Total Cost by Component — 30 Days"
    yFmt="$#,##0"
    xAxisTitle="Component"
    yAxisTitle="Total ($)"
    colorPalette={['#e07b39', '#4f86c6', '#a0c878']}
/>

</div>
</Grid>

<DataTable data={cost_structure_30d}>
    <Column id="branch_name"       title="Location"/>
    <Column id="gross_revenue"     title="Gross Revenue"   fmt="$#,##0.00"/>
    <Column id="cost_ingredients"  title="Ingredients"     fmt="$#,##0.00"/>
    <Column id="pct_ingredients"   title="% Ingr."         fmt="0.0\%"/>
    <Column id="cost_labor"        title="Labor"           fmt="$#,##0.00"/>
    <Column id="pct_labor"         title="% Labor"         fmt="0.0\%"/>
    <Column id="cost_overhead"     title="Overhead"        fmt="$#,##0.00"/>
    <Column id="pct_overhead"      title="% Overhead"      fmt="0.0\%"/>
    <Column id="net_revenue"       title="Net Revenue"     fmt="$#,##0.00"/>
    <Column id="net_margin_pct"    title="Margin"          fmt="0.0\%"/>
</DataTable>

_Industry benchmarks for fast casual: ingredients ~28–32%, labor ~25–30%, overhead ~10–15%. Components exceeding these ranges are optimization priorities._

---

## Monthly Trends

```sql monthly_gross_net
SELECT
    DATE_TRUNC('month', metric_date) AS month,
    branch_name,
    SUM(gross_revenue) AS gross_revenue,
    SUM(net_revenue)   AS net_revenue,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS net_margin_pct
FROM restaurant_en.daily_net_revenue
GROUP BY 1, 2
ORDER BY 1, 2
```

```sql monthly_margin_trend
SELECT
    DATE_TRUNC('month', metric_date) AS month,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS net_margin_pct
FROM restaurant_en.daily_net_revenue
GROUP BY 1
ORDER BY 1
```

<Grid cols=2>
<div>

### Gross vs Net Revenue — Monthly

<BarChart
    data={monthly_gross_net}
    x="month"
    y={["gross_revenue", "net_revenue"]}
    series="branch_name"
    type="grouped"
    title="Monthly Gross vs Net Revenue ($)"
    yFmt="$#,##0"
    xAxisTitle="Month"
    yAxisTitle="Revenue ($)"
/>

</div>
<div>

### Net Margin Trend

<LineChart
    data={monthly_margin_trend}
    x="month"
    y="net_margin_pct"
    title="Net Margin % — Monthly Trend"
    yFmt="0.0\%"
    xAxisTitle="Month"
    yAxisTitle="Net Margin (%)"
/>

</div>
</Grid>

_A shrinking margin alongside growing revenue means costs are outpacing sales — address before it becomes structural._

---

## Daily Net Revenue Trend (Last 90 Days)

```sql net_trend_90d
SELECT
    metric_date,
    branch_name,
    net_revenue,
    ROUND(AVG(net_revenue) OVER (
        PARTITION BY branch_name
        ORDER BY metric_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ), 2) AS net_revenue_7d_avg
FROM restaurant_en.daily_net_revenue
WHERE metric_date >= (SELECT MAX(metric_date) FROM restaurant_en.daily_net_revenue) - INTERVAL '90 days'
ORDER BY metric_date, branch_name
```

<Grid cols=2>
<div>

### Daily Net Revenue

<LineChart
    data={net_trend_90d}
    x="metric_date"
    y="net_revenue"
    series="branch_name"
    title="Daily Net Revenue by Location ($)"
    yFmt="$#,##0"
    xAxisTitle="Date"
    yAxisTitle="Net Revenue ($)"
/>

</div>
<div>

### 7-Day Rolling Average

<LineChart
    data={net_trend_90d}
    x="metric_date"
    y="net_revenue_7d_avg"
    series="branch_name"
    title="Net Revenue 7-Day Avg by Location ($)"
    yFmt="$#,##0"
    xAxisTitle="Date"
    yAxisTitle="7-Day Avg ($)"
/>

</div>
</Grid>

_A line consistently below zero means that location is losing money every day — requires immediate action._

---

## Daily Detail (Last 30 Days)

```sql daily_detail_30d
SELECT
    metric_date,
    branch_name,
    gross_revenue,
    inventory_usage_cost,
    labor_total_cost,
    operational_total_cost,
    net_revenue,
    ROUND(net_revenue / NULLIF(gross_revenue, 0) * 100, 1) AS net_margin_pct
FROM restaurant_en.daily_net_revenue
WHERE metric_date >= (SELECT MAX(metric_date) FROM restaurant_en.daily_net_revenue) - INTERVAL '30 days'
ORDER BY metric_date DESC, branch_name
```

<Grid cols=2>
<div>

### Downtown

<DataTable data={daily_detail_30d.filter(d => d.branch_name === 'Downtown')} rows=10>
    <Column id="metric_date"            title="Date"/>
    <Column id="gross_revenue"          title="Revenue"       fmt="$#,##0.00"/>
    <Column id="inventory_usage_cost"   title="Ingredients"   fmt="$#,##0.00"/>
    <Column id="labor_total_cost"       title="Labor"         fmt="$#,##0.00"/>
    <Column id="operational_total_cost" title="Overhead"      fmt="$#,##0.00"/>
    <Column id="net_revenue"            title="Net Rev."      fmt="$#,##0.00"/>
    <Column id="net_margin_pct"         title="Margin"        fmt="0.0\%"/>
</DataTable>

</div>
<div>

### Midtown

<DataTable data={daily_detail_30d.filter(d => d.branch_name === 'Midtown')} rows=10>
    <Column id="metric_date"            title="Date"/>
    <Column id="gross_revenue"          title="Revenue"       fmt="$#,##0.00"/>
    <Column id="inventory_usage_cost"   title="Ingredients"   fmt="$#,##0.00"/>
    <Column id="labor_total_cost"       title="Labor"         fmt="$#,##0.00"/>
    <Column id="operational_total_cost" title="Overhead"      fmt="$#,##0.00"/>
    <Column id="net_revenue"            title="Net Rev."      fmt="$#,##0.00"/>
    <Column id="net_margin_pct"         title="Margin"        fmt="0.0\%"/>
</DataTable>

</div>
<div>

### Westside

<DataTable data={daily_detail_30d.filter(d => d.branch_name === 'Westside')} rows=10>
    <Column id="metric_date"            title="Date"/>
    <Column id="gross_revenue"          title="Revenue"       fmt="$#,##0.00"/>
    <Column id="inventory_usage_cost"   title="Ingredients"   fmt="$#,##0.00"/>
    <Column id="labor_total_cost"       title="Labor"         fmt="$#,##0.00"/>
    <Column id="operational_total_cost" title="Overhead"      fmt="$#,##0.00"/>
    <Column id="net_revenue"            title="Net Rev."      fmt="$#,##0.00"/>
    <Column id="net_margin_pct"         title="Margin"        fmt="0.0\%"/>
</DataTable>

</div>
<div>

### Northside

<DataTable data={daily_detail_30d.filter(d => d.branch_name === 'Northside')} rows=10>
    <Column id="metric_date"            title="Date"/>
    <Column id="gross_revenue"          title="Revenue"       fmt="$#,##0.00"/>
    <Column id="inventory_usage_cost"   title="Ingredients"   fmt="$#,##0.00"/>
    <Column id="labor_total_cost"       title="Labor"         fmt="$#,##0.00"/>
    <Column id="operational_total_cost" title="Overhead"      fmt="$#,##0.00"/>
    <Column id="net_revenue"            title="Net Rev."      fmt="$#,##0.00"/>
    <Column id="net_margin_pct"         title="Margin"        fmt="0.0\%"/>
</DataTable>

</div>
</Grid>

_Rows with a negative margin are days where costs exceeded revenue — occasional dips are normal; recurring negatives at the same location need investigation._

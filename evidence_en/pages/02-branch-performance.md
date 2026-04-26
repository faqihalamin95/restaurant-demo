---
title: Branch Performance
---

_Revenue analysis and performance trends per location._

```sql periode_30d
SELECT
    STRFTIME('%b %d, %Y', MAX(order_date) - INTERVAL '29 days') AS date_from,
    STRFTIME('%b %d, %Y', MAX(order_date))                       AS date_to,
    MAX(order_date)                                               AS max_date
FROM restaurant_en.daily_revenue
```

```sql branch_daily_30
SELECT
    order_date,
    branch_name,
    total_revenue,
    ROUND(revenue_sdow_avg, 2) AS revenue_sdow_avg
FROM restaurant_en.daily_revenue
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.daily_revenue) - INTERVAL '29 days'
ORDER BY order_date, branch_name
```

```sql profitability_30d
SELECT
    branch_name,
    SUM(gross_revenue)          AS gross_revenue,
    SUM(net_revenue)            AS net_revenue,
    SUM(inventory_usage_cost)   AS cost_ingredients,
    SUM(labor_total_cost)       AS cost_labor,
    SUM(operational_total_cost) AS cost_overhead,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS net_margin_pct
FROM restaurant_en.daily_net_revenue
WHERE metric_date >= (SELECT MAX(metric_date) FROM restaurant_en.daily_net_revenue) - INTERVAL '29 days'
GROUP BY branch_name
ORDER BY net_revenue DESC
```

---

## Last 30 Days Summary

<span style="font-size:0.85em;color:var(--color-text-secondary)">{periode_30d[0].date_from} – {periode_30d[0].date_to}</span>

```sql kpi_30d
SELECT
    SUM(total_revenue)                                                AS total_revenue,
    SUM(total_orders)                                                 AS total_orders,
    ROUND(SUM(total_revenue) / NULLIF(SUM(total_orders), 0), 2)      AS avg_order_value,
    COUNT(DISTINCT branch_id)                                         AS total_locations
FROM restaurant_en.daily_revenue
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.daily_revenue) - INTERVAL '29 days'
```

```sql net_30d
SELECT
    SUM(net_revenue)                                                  AS net_revenue,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS net_margin_pct
FROM restaurant_en.daily_net_revenue
WHERE metric_date >= (SELECT MAX(metric_date) FROM restaurant_en.daily_net_revenue) - INTERVAL '29 days'
```

```sql branch_30d
SELECT
    dr.branch_name,
    SUM(dr.total_revenue)                                              AS total_revenue,
    SUM(dr.total_orders)                                               AS total_orders,
    ROUND(SUM(dr.total_revenue) / NULLIF(SUM(dr.total_orders), 0), 2) AS avg_order_value,
    ROUND(AVG(dr.pct_change_vs_sdow_avg), 3)                          AS avg_pct_change_vs_sdow,
    SUM(nr.net_revenue)                                                AS net_revenue,
    ROUND(SUM(nr.net_revenue) / NULLIF(SUM(nr.gross_revenue), 0) * 100, 1) AS net_margin_pct
FROM restaurant_en.daily_revenue dr
LEFT JOIN restaurant_en.daily_net_revenue nr
    ON dr.order_date = nr.metric_date AND dr.branch_id = nr.branch_id
WHERE dr.order_date >= (SELECT MAX(order_date) FROM restaurant_en.daily_revenue) - INTERVAL '29 days'
GROUP BY dr.branch_name
ORDER BY total_revenue DESC
```

```sql branch_alert_30d
SELECT
    branch_name,
    ROUND(AVG(pct_change_vs_sdow_avg) * 100, 1) AS avg_pct_change
FROM restaurant_en.daily_revenue
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.daily_revenue) - INTERVAL '29 days'
GROUP BY branch_name
HAVING AVG(pct_change_vs_sdow_avg) < -0.15
ORDER BY avg_pct_change ASC
```

<BigValue data={kpi_30d} value="total_revenue"   title="Gross Revenue — 30 Days"  fmt="$#,##0.00" />
<BigValue data={kpi_30d} value="total_orders"    title="Total Orders — 30 Days"   fmt="#,##0" />
<BigValue data={kpi_30d} value="avg_order_value" title="Avg Order Value"          fmt="$#,##0.00" />
<BigValue data={net_30d} value="net_revenue"     title="Net Revenue — 30 Days"    fmt="$#,##0.00" />
<BigValue data={net_30d} value="net_margin_pct"  title="Net Margin — 30 Days"     fmt="0.0\%" />

{#if branch_alert_30d.length > 0}
<div style="display:flex;flex-direction:column;gap:8px;margin:16px 0;">
{#each branch_alert_30d as row}
<div style="background:#fff3f3;border-left:4px solid #dc2626;padding:12px 16px;border-radius:6px;">
🚨 <strong>{row.branch_name}</strong> — Revenue averaged <strong>{row.avg_pct_change}%</strong> vs same-day-of-week benchmark over the last 30 days.
</div>
{/each}
</div>
{:else}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:12px 16px;border-radius:6px;margin:16px 0;">
✅ <strong>All locations normal.</strong> No significant underperformance vs same-day-of-week benchmark in the last 30 days.
</div>
{/if}

<DataTable data={branch_30d}>
    <Column id="branch_name"             title="Location"/>
    <Column id="total_revenue"           title="Gross Revenue"    fmt="$#,##0.00"/>
    <Column id="total_orders"            title="Orders"           fmt="#,##0"/>
    <Column id="avg_order_value"         title="Avg Order Value"  fmt="$#,##0.00"/>
    <Column id="avg_pct_change_vs_sdow"  title="vs Same-Day Avg" fmt="+0.0%;-0.0%;0.0%" contentType="delta"/>
    <Column id="net_revenue"             title="Net Revenue"      fmt="$#,##0.00"/>
    <Column id="net_margin_pct"          title="Margin"           fmt="0.0\%"/>
</DataTable>

---

## 30-Day Trends

<span style="font-size:0.85em;color:var(--color-text-secondary)">{periode_30d[0].date_from} – {periode_30d[0].date_to}</span>

<Grid cols=2>
<div>

### Daily Revenue by Location

<LineChart
    data={branch_daily_30}
    x="order_date"
    y="total_revenue"
    series="branch_name"
    title="Daily Gross Revenue ($)"
    yFmt="$#,##0"
    xAxisTitle="Date"
    yAxisTitle="Revenue ($)"
/>

</div>
<div>

### Same-Day-of-Week Average (Smoothed)

<LineChart
    data={branch_daily_30}
    x="order_date"
    y="revenue_sdow_avg"
    series="branch_name"
    title="Same-Day-of-Week Avg Revenue ($)"
    yFmt="$#,##0"
    xAxisTitle="Date"
    yAxisTitle="SDOW Avg ($)"
/>

</div>
</Grid>

_Left: actual daily revenue. Right: smoothed by same-day-of-week average — Monday vs Monday — removing weekday/weekend noise to reveal true directional trends._

<Grid cols=2>
<div>

### Gross vs Net Revenue

<BarChart
    data={profitability_30d}
    x="branch_name"
    y={["gross_revenue", "net_revenue"]}
    type="grouped"
    title="Gross vs Net Revenue — 30 Days ($)"
    yFmt="$#,##0"
    xAxisTitle="Location"
    yAxisTitle="Revenue ($)"
/>

</div>
<div>

### Cost Structure

<BarChart
    data={profitability_30d}
    x="branch_name"
    y={["cost_ingredients", "cost_labor", "cost_overhead"]}
    type="stacked"
    title="Cost Breakdown by Location — 30 Days ($)"
    yFmt="$#,##0"
    xAxisTitle="Location"
    yAxisTitle="Total Cost ($)"
/>

</div>
</Grid>

<DataTable data={profitability_30d}>
    <Column id="branch_name"      title="Location"/>
    <Column id="gross_revenue"    title="Gross Revenue"  fmt="$#,##0.00"/>
    <Column id="cost_ingredients" title="Ingredients"    fmt="$#,##0.00"/>
    <Column id="cost_labor"       title="Labor"          fmt="$#,##0.00"/>
    <Column id="cost_overhead"    title="Overhead"       fmt="$#,##0.00"/>
    <Column id="net_revenue"      title="Net Revenue"    fmt="$#,##0.00"/>
    <Column id="net_margin_pct"   title="Margin"         fmt="0.0\%"/>
</DataTable>

---

## Locations to Watch — Last 30 Days

```sql declining_gross
WITH max_date AS (SELECT MAX(order_date) AS max_d FROM restaurant_en.daily_revenue),
branch_revenue AS (
    SELECT
        branch_name,
        SUM(CASE WHEN order_date >= (max_d - INTERVAL '29 days') AND order_date < (max_d - INTERVAL '14 days')
            THEN total_revenue ELSE 0 END) AS revenue_first_15d,
        SUM(CASE WHEN order_date >= (max_d - INTERVAL '14 days') AND order_date <= max_d
            THEN total_revenue ELSE 0 END) AS revenue_last_15d
    FROM restaurant_en.daily_revenue CROSS JOIN max_date
    WHERE order_date >= (max_d - INTERVAL '29 days')
    GROUP BY branch_name
)
SELECT
    branch_name,
    revenue_first_15d,
    revenue_last_15d,
    ROUND((revenue_last_15d - revenue_first_15d) / NULLIF(revenue_first_15d, 0) * 100, 1) AS pct_change
FROM branch_revenue
WHERE revenue_last_15d < revenue_first_15d
ORDER BY pct_change ASC
```

```sql negative_net
SELECT
    branch_name,
    SUM(net_revenue)   AS net_revenue_30d,
    SUM(gross_revenue) AS gross_revenue_30d,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS net_margin_pct,
    COUNT(CASE WHEN net_revenue < 0 THEN 1 END) AS days_negative
FROM restaurant_en.daily_net_revenue
WHERE metric_date >= (SELECT MAX(metric_date) FROM restaurant_en.daily_net_revenue) - INTERVAL '29 days'
GROUP BY branch_name
HAVING SUM(net_revenue) < 0 OR COUNT(CASE WHEN net_revenue < 0 THEN 1 END) >= 7
ORDER BY net_revenue_30d ASC
```

### Revenue Slowing Down

_Benchmark: first 15 vs last 15 days of this period. An early signal that a location is weakening — not yet losing money, but worth watching before it worsens._

{#if declining_gross.length > 0}
<DataTable data={declining_gross}>
    <Column id="branch_name"       title="Location"/>
    <Column id="revenue_first_15d" title="First 15 Days" fmt="$#,##0.00"/>
    <Column id="revenue_last_15d"  title="Last 15 Days"  fmt="$#,##0.00"/>
    <Column id="pct_change"        title="Change"        fmt="+0.0;-0.0" contentType="delta"/>
</DataTable>
{:else}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:12px 16px;border-radius:6px;">
✅ All locations are stable or growing — no significant revenue deceleration.
</div>
{/if}

### Net Revenue Negative

_Benchmark: cumulative net revenue over 30 days after all cost deductions. Locations here are actually losing money — requires immediate action._

{#if negative_net.length > 0}
<DataTable data={negative_net}>
    <Column id="branch_name"      title="Location"/>
    <Column id="gross_revenue_30d" title="Gross Revenue" fmt="$#,##0.00"/>
    <Column id="net_revenue_30d"   title="Net Revenue"   fmt="$#,##0.00"/>
    <Column id="net_margin_pct"    title="Margin"        fmt="0.0\%"/>
    <Column id="days_negative"     title="Days Negative (of 30)" fmt="#,##0"/>
</DataTable>
{:else}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:12px 16px;border-radius:6px;">
✅ All locations generated positive net revenue in the last 30 days.
</div>
{/if}

---

## Monthly Trends

```sql branch_monthly
SELECT
    DATE_TRUNC('month', order_date) AS month,
    branch_name,
    SUM(total_revenue)              AS total_revenue,
    SUM(total_orders)               AS total_orders
FROM restaurant_en.daily_revenue
GROUP BY 1, 2
ORDER BY 1, 2
```

```sql branch_wow
WITH max_date AS (SELECT MAX(order_date) AS d FROM restaurant_en.daily_revenue)
SELECT
    branch_name,
    SUM(CASE WHEN order_date >= (SELECT d FROM max_date) - INTERVAL '6 days'
        THEN total_revenue END)                                              AS revenue_this_week,
    SUM(CASE WHEN order_date < (SELECT d FROM max_date) - INTERVAL '6 days'
         AND  order_date >= (SELECT d FROM max_date) - INTERVAL '13 days'
        THEN total_revenue END)                                              AS revenue_last_week,
    ROUND(
        (SUM(CASE WHEN order_date >= (SELECT d FROM max_date) - INTERVAL '6 days'
            THEN total_revenue END)
        - SUM(CASE WHEN order_date < (SELECT d FROM max_date) - INTERVAL '6 days'
             AND   order_date >= (SELECT d FROM max_date) - INTERVAL '13 days'
            THEN total_revenue END))
        / NULLIF(SUM(CASE WHEN order_date < (SELECT d FROM max_date) - INTERVAL '6 days'
             AND  order_date >= (SELECT d FROM max_date) - INTERVAL '13 days'
            THEN total_revenue END), 0) * 100
    , 1) AS pct_change
FROM restaurant_en.daily_revenue
GROUP BY 1
ORDER BY branch_name
```

<Grid cols=2>
<div>

### Monthly Revenue

<BarChart
    data={branch_monthly}
    x="month"
    y="total_revenue"
    series="branch_name"
    type="stacked"
    title="Monthly Revenue by Location ($)"
    yFmt="$#,##0"
    xAxisTitle="Month"
    yAxisTitle="Revenue ($)"
/>

</div>
<div>

### This Week vs Last Week

<DataTable data={branch_wow}>
    <Column id="branch_name"        title="Location"/>
    <Column id="revenue_this_week"  title="This Week"  fmt="$#,##0.00"/>
    <Column id="revenue_last_week"  title="Last Week"  fmt="$#,##0.00"/>
    <Column id="pct_change"         title="Change"     fmt="+0.0;-0.0" contentType="delta"/>
</DataTable>

</div>
</Grid>

---

## All-Time Summary (Since Opening)

```sql branch_summary
SELECT
    dr.branch_name,
    SUM(dr.total_revenue)                                               AS total_revenue,
    SUM(dr.total_orders)                                                AS total_orders,
    ROUND(SUM(dr.total_revenue) / NULLIF(SUM(dr.total_orders), 0), 2)  AS avg_order_value,
    SUM(nr.net_revenue)                                                 AS net_revenue,
    ROUND(SUM(nr.net_revenue) / NULLIF(SUM(nr.gross_revenue), 0) * 100, 1) AS net_margin_pct,
    MIN(dr.order_date)                                                  AS first_date,
    MAX(dr.order_date)                                                  AS last_date
FROM restaurant_en.daily_revenue dr
LEFT JOIN restaurant_en.daily_net_revenue nr
    ON dr.order_date = nr.metric_date AND dr.branch_id = nr.branch_id
GROUP BY dr.branch_name
ORDER BY total_revenue DESC
```

<DataTable data={branch_summary}>
    <Column id="branch_name"     title="Location"/>
    <Column id="total_revenue"   title="Gross Revenue"   fmt="$#,##0.00"/>
    <Column id="total_orders"    title="Total Orders"    fmt="#,##0"/>
    <Column id="avg_order_value" title="Avg Order Value" fmt="$#,##0.00"/>
    <Column id="net_revenue"     title="Net Revenue"     fmt="$#,##0.00"/>
    <Column id="net_margin_pct"  title="Margin"          fmt="0.0\%"/>
    <Column id="first_date"      title="Since"/>
    <Column id="last_date"       title="Last Data"/>
</DataTable>

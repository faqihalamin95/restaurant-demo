---
title: Branch Performance
---

_Revenue, profitability, and trend analysis per location._

```sql branch_list
SELECT DISTINCT branch_name
FROM restaurant_en.daily_revenue
ORDER BY branch_name
```

<ButtonGroup name=branch>
  <ButtonGroupItem valueLabel="All Locations" value="all" default />
  {#each branch_list as b}
  <ButtonGroupItem valueLabel={b.branch_name} value={b.branch_name} />
  {/each}
</ButtonGroup>

---

{#if inputs.branch === 'all'}

<!-- ════════════════════════════════════════════════
     ALL LOCATIONS VIEW
════════════════════════════════════════════════ -->

```sql health_branches
WITH max_d AS (SELECT MAX(order_date) AS d FROM restaurant_en.daily_revenue),
period AS (
    SELECT
        branch_name,
        SUM(total_revenue)                                                         AS revenue_30d,
        ROUND(AVG(pct_change_vs_sdow_avg) * 100, 1)                               AS avg_pct_vs_sdow
    FROM restaurant_en.daily_revenue CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '29 days'
    GROUP BY branch_name
),
margin AS (
    SELECT
        branch_name,
        ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1)          AS net_margin_pct
    FROM restaurant_en.daily_net_revenue CROSS JOIN (SELECT MAX(metric_date) AS d FROM restaurant_en.daily_net_revenue)
    WHERE metric_date >= d - INTERVAL '29 days'
    GROUP BY branch_name
),
gap AS (
    SELECT
        ROUND((MAX(revenue_30d) - MIN(revenue_30d)) / NULLIF(MIN(revenue_30d), 0) * 100, 1) AS gap_pct,
        MAX(CASE WHEN revenue_30d = (SELECT MAX(revenue_30d) FROM period) THEN branch_name END) AS top_branch,
        MIN(CASE WHEN revenue_30d = (SELECT MIN(revenue_30d) FROM period) THEN branch_name END) AS bottom_branch
    FROM period
)
SELECT
    SUM(p.revenue_30d)                                                             AS total_revenue_30d,
    ROUND(SUM(m.net_margin_pct * p.revenue_30d) / NULLIF(SUM(p.revenue_30d), 0), 1) AS avg_margin,
    g.gap_pct,
    g.top_branch,
    g.bottom_branch,
    COUNT(CASE WHEN m.net_margin_pct < 10 THEN 1 END)                             AS branches_critical,
    COUNT(CASE WHEN p.avg_pct_vs_sdow < -15 THEN 1 END)                           AS branches_declining
FROM period p
LEFT JOIN margin m ON p.branch_name = m.branch_name
CROSS JOIN gap g
GROUP BY g.gap_pct, g.top_branch, g.bottom_branch
```

```sql kpi_all_30d
SELECT
    SUM(total_revenue)                                                            AS total_revenue,
    SUM(total_orders)                                                             AS total_orders,
    ROUND(SUM(total_revenue) / NULLIF(SUM(total_orders), 0), 2)                  AS avg_order_value,
    COUNT(DISTINCT branch_id)                                                     AS total_locations
FROM restaurant_en.daily_revenue
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.daily_revenue) - INTERVAL '29 days'
```

```sql net_all_30d
SELECT
    SUM(net_revenue)                                                              AS net_revenue,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1)            AS net_margin_pct
FROM restaurant_en.daily_net_revenue
WHERE metric_date >= (SELECT MAX(metric_date) FROM restaurant_en.daily_net_revenue) - INTERVAL '29 days'
```

```sql branch_summary_30d
SELECT
    dr.branch_name,
    SUM(dr.total_revenue)                                                         AS total_revenue,
    SUM(dr.total_orders)                                                          AS total_orders,
    ROUND(SUM(dr.total_revenue) / NULLIF(SUM(dr.total_orders), 0), 2)            AS avg_order_value,
    ROUND(AVG(dr.pct_change_vs_sdow_avg) * 100, 1)                               AS avg_pct_vs_sdow,
    SUM(nr.net_revenue)                                                           AS net_revenue,
    ROUND(SUM(nr.net_revenue) / NULLIF(SUM(nr.gross_revenue), 0) * 100, 1)       AS net_margin_pct
FROM restaurant_en.daily_revenue dr
LEFT JOIN restaurant_en.daily_net_revenue nr
    ON dr.order_date = nr.metric_date AND dr.branch_id = nr.branch_id
WHERE dr.order_date >= (SELECT MAX(order_date) FROM restaurant_en.daily_revenue) - INTERVAL '29 days'
GROUP BY dr.branch_name
ORDER BY total_revenue DESC
```

```sql branch_alert_30d
SELECT branch_name, ROUND(AVG(pct_change_vs_sdow_avg) * 100, 1) AS avg_pct_change
FROM restaurant_en.daily_revenue
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.daily_revenue) - INTERVAL '29 days'
GROUP BY branch_name
HAVING AVG(pct_change_vs_sdow_avg) < -0.15
ORDER BY avg_pct_change ASC
```

```sql branch_daily_30d
SELECT order_date, branch_name, total_revenue,
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

```sql branch_wow
WITH max_date AS (SELECT MAX(order_date) AS d FROM restaurant_en.daily_revenue)
SELECT
    branch_name,
    SUM(CASE WHEN order_date >= (SELECT d FROM max_date) - INTERVAL '6 days'
        THEN total_revenue END)                                                   AS revenue_this_week,
    SUM(CASE WHEN order_date < (SELECT d FROM max_date) - INTERVAL '6 days'
         AND  order_date >= (SELECT d FROM max_date) - INTERVAL '13 days'
        THEN total_revenue END)                                                   AS revenue_last_week,
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
GROUP BY branch_name
ORDER BY branch_name
```

## Last 30 Days — All Locations

<BigValue data={kpi_all_30d} value="total_revenue"   title="Total Gross Revenue"  fmt="$#,##0.00" />
<BigValue data={kpi_all_30d} value="total_orders"    title="Total Orders"          fmt="#,##0" />
<BigValue data={kpi_all_30d} value="avg_order_value" title="Avg Order Value"       fmt="$#,##0.00" />
<BigValue data={net_all_30d} value="net_revenue"     title="Net Revenue"           fmt="$#,##0.00" />
<BigValue data={net_all_30d} value="net_margin_pct"  title="Net Margin"            fmt="0.0\%" />

<!-- Health Card -->
<div style="background:var(--color-background-secondary);border:1px solid var(--color-border-tertiary);border-radius:12px;padding:1.1rem 1.3rem;margin:20px 0;box-shadow:0 1px 3px rgba(0,0,0,0.04);">

<div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:14px;padding-bottom:12px;border-bottom:1px solid var(--color-border-tertiary);flex-wrap:wrap;gap:8px;">
<span style="font-size:12px;font-weight:600;letter-spacing:0.05em;text-transform:uppercase;color:var(--color-text-tertiary);">Location Health — 30 Days</span>
<div style="display:flex;gap:8px;flex-wrap:wrap;">
{#if health_branches[0].branches_critical === 0 && health_branches[0].branches_declining === 0}
<span style="display:inline-flex;align-items:center;gap:5px;padding:3px 10px;border-radius:20px;font-size:12px;font-weight:600;background:rgba(22,163,74,0.10);color:#166534;border:1px solid rgba(22,163,74,0.2);">
✓ All locations healthy
</span>
{/if}
{#if health_branches[0].branches_critical > 0}
<span style="display:inline-flex;align-items:center;gap:5px;padding:3px 10px;border-radius:20px;font-size:12px;font-weight:600;background:rgba(220,38,38,0.08);color:#991b1b;border:1px solid rgba(220,38,38,0.2);">
{health_branches[0].branches_critical} critical margin
</span>
{/if}
{#if health_branches[0].branches_declining > 0}
<span style="display:inline-flex;align-items:center;gap:5px;padding:3px 10px;border-radius:20px;font-size:12px;font-weight:600;background:rgba(248,201,0,0.10);color:#854d0e;border:1px solid rgba(234,179,8,0.25);">
{health_branches[0].branches_declining} underperforming
</span>
{/if}
</div>
</div>

<div style="display:flex;flex-direction:column;gap:6px;">

{#if health_branches[0].avg_margin >= 15}
<div style="display:flex;align-items:flex-start;gap:10px;padding:8px 10px;background:rgba(22,163,74,0.04);border:1px solid rgba(22,163,74,0.12);border-radius:8px;font-size:13px;">
<div style="width:7px;height:7px;border-radius:50%;background:#16a34a;flex-shrink:0;margin-top:4px;"></div>
<div><span style="font-weight:600;color:#166534;">💰 Net Margin</span> — {health_branches[0].avg_margin}% blended margin across all locations. Healthy.</div>
</div>
{:else if health_branches[0].avg_margin >= 10}
<div style="display:flex;align-items:flex-start;gap:10px;padding:8px 10px;background:rgba(234,179,8,0.04);border:1px solid rgba(234,179,8,0.18);border-radius:8px;font-size:13px;">
<div style="width:7px;height:7px;border-radius:50%;background:#ca8a04;flex-shrink:0;margin-top:4px;"></div>
<div><span style="font-weight:600;color:#854d0e;">💰 Net Margin</span> — {health_branches[0].avg_margin}% blended margin. Below 15% target — review cost structure.</div>
</div>
{:else}
<div style="display:flex;align-items:flex-start;gap:10px;padding:8px 10px;background:rgba(220,38,38,0.04);border:1px solid rgba(220,38,38,0.12);border-radius:8px;font-size:13px;">
<div style="width:7px;height:7px;border-radius:50%;background:#dc2626;flex-shrink:0;margin-top:4px;"></div>
<div><span style="font-weight:600;color:#991b1b;">💰 Net Margin</span> — {health_branches[0].avg_margin}% blended margin. Critical — below 10%.</div>
</div>
{/if}

{#if health_branches[0].gap_pct < 50}
<div style="display:flex;align-items:flex-start;gap:10px;padding:8px 10px;background:rgba(22,163,74,0.04);border:1px solid rgba(22,163,74,0.12);border-radius:8px;font-size:13px;">
<div style="width:7px;height:7px;border-radius:50%;background:#16a34a;flex-shrink:0;margin-top:4px;"></div>
<div><span style="font-weight:600;color:#166534;">🏪 Revenue Gap</span> — {health_branches[0].gap_pct}% gap between top and bottom location. Well balanced.</div>
</div>
{:else if health_branches[0].gap_pct <= 100}
<div style="display:flex;align-items:flex-start;gap:10px;padding:8px 10px;background:rgba(234,179,8,0.04);border:1px solid rgba(234,179,8,0.18);border-radius:8px;font-size:13px;">
<div style="width:7px;height:7px;border-radius:50%;background:#ca8a04;flex-shrink:0;margin-top:4px;"></div>
<div><span style="font-weight:600;color:#854d0e;">🏪 Revenue Gap</span> — {health_branches[0].gap_pct}% gap. <strong>{health_branches[0].bottom_branch}</strong> is lagging behind <strong>{health_branches[0].top_branch}</strong>. Select that branch to investigate.</div>
</div>
{:else}
<div style="display:flex;align-items:flex-start;gap:10px;padding:8px 10px;background:rgba(220,38,38,0.04);border:1px solid rgba(220,38,38,0.12);border-radius:8px;font-size:13px;">
<div style="width:7px;height:7px;border-radius:50%;background:#dc2626;flex-shrink:0;margin-top:4px;"></div>
<div><span style="font-weight:600;color:#991b1b;">🏪 Revenue Gap</span> — {health_branches[0].gap_pct}% gap. <strong>{health_branches[0].bottom_branch}</strong> is far behind — select it to investigate.</div>
</div>
{/if}

{#each branch_alert_30d as row}
<div style="display:flex;align-items:flex-start;gap:10px;padding:8px 10px;background:rgba(220,38,38,0.04);border:1px solid rgba(220,38,38,0.12);border-radius:8px;font-size:13px;">
<div style="width:7px;height:7px;border-radius:50%;background:#dc2626;flex-shrink:0;margin-top:4px;"></div>
<div><span style="font-weight:600;color:#991b1b;">📉 {row.branch_name}</span> — averaging <strong>{row.avg_pct_change}%</strong> vs same-day-of-week benchmark over 30 days. Select this location for a deeper look.</div>
</div>
{/each}

</div>
</div>

<DataTable data={branch_summary_30d}>
    <Column id="branch_name"            title="Location"/>
    <Column id="total_revenue"          title="Gross Revenue"    fmt="$#,##0.00"/>
    <Column id="total_orders"           title="Orders"           fmt="#,##0"/>
    <Column id="avg_order_value"        title="Avg Order Value"  fmt="$#,##0.00"/>
    <Column id="avg_pct_vs_sdow"        title="vs Same-Day Avg" fmt="+0.0;-0.0" contentType="delta"/>
    <Column id="net_revenue"            title="Net Revenue"      fmt="$#,##0.00"/>
    <Column id="net_margin_pct"         title="Margin"           fmt="0.0\%"/>
</DataTable>

_Click a location name in the button bar above to see its detailed multi-period breakdown._

---

## 30-Day Trends

<Grid cols=2>
<div>

### Daily Revenue by Location

<LineChart
    data={branch_daily_30d}
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

### This Week vs Last Week

<DataTable data={branch_wow}>
    <Column id="branch_name"        title="Location"/>
    <Column id="revenue_this_week"  title="This Week"  fmt="$#,##0.00"/>
    <Column id="revenue_last_week"  title="Last Week"  fmt="$#,##0.00"/>
    <Column id="pct_change"         title="Change"     fmt="+0.0;-0.0" contentType="delta"/>
</DataTable>

</div>
</Grid>

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

---

## All-Time Summary

```sql branch_alltime
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

<DataTable data={branch_alltime}>
    <Column id="branch_name"     title="Location"/>
    <Column id="total_revenue"   title="Gross Revenue"   fmt="$#,##0.00"/>
    <Column id="total_orders"    title="Total Orders"    fmt="#,##0"/>
    <Column id="avg_order_value" title="Avg Order Value" fmt="$#,##0.00"/>
    <Column id="net_revenue"     title="Net Revenue"     fmt="$#,##0.00"/>
    <Column id="net_margin_pct"  title="Margin"          fmt="0.0\%"/>
    <Column id="first_date"      title="Since"/>
    <Column id="last_date"       title="Last Data"/>
</DataTable>

{:else}

<!-- ════════════════════════════════════════════════
     SINGLE BRANCH VIEW
════════════════════════════════════════════════ -->

```sql branch_scorecard
WITH b AS (SELECT '{inputs.branch}' AS branch_name),
max_d AS (SELECT MAX(order_date) AS d FROM restaurant_en.daily_revenue),
max_nr AS (SELECT MAX(metric_date) AS d FROM restaurant_en.daily_net_revenue),

-- Revenue periods
rev AS (
    SELECT
        SUM(CASE WHEN order_date = (SELECT d FROM max_d) THEN total_revenue END)                   AS rev_yesterday,
        SUM(CASE WHEN order_date >= (SELECT d FROM max_d) - INTERVAL '6 days' THEN total_revenue END)  AS rev_7d,
        SUM(CASE WHEN order_date >= (SELECT d FROM max_d) - INTERVAL '29 days' THEN total_revenue END) AS rev_30d,
        SUM(CASE WHEN order_date >= (SELECT d FROM max_d) - INTERVAL '89 days' THEN total_revenue END) AS rev_90d,
        -- prev periods for delta
        SUM(CASE WHEN order_date >= (SELECT d FROM max_d) - INTERVAL '13 days' AND order_date < (SELECT d FROM max_d) - INTERVAL '6 days' THEN total_revenue END) AS rev_prev7d,
        SUM(CASE WHEN order_date >= (SELECT d FROM max_d) - INTERVAL '59 days' AND order_date < (SELECT d FROM max_d) - INTERVAL '29 days' THEN total_revenue END) AS rev_prev30d,
        SUM(CASE WHEN order_date >= (SELECT d FROM max_d) - INTERVAL '179 days' AND order_date < (SELECT d FROM max_d) - INTERVAL '89 days' THEN total_revenue END) AS rev_prev90d
    FROM restaurant_en.daily_revenue
    WHERE branch_name = (SELECT branch_name FROM b)
),

-- Orders periods
ord AS (
    SELECT
        SUM(CASE WHEN order_date = (SELECT d FROM max_d) THEN total_orders END)                   AS ord_yesterday,
        SUM(CASE WHEN order_date >= (SELECT d FROM max_d) - INTERVAL '6 days' THEN total_orders END)  AS ord_7d,
        SUM(CASE WHEN order_date >= (SELECT d FROM max_d) - INTERVAL '29 days' THEN total_orders END) AS ord_30d,
        SUM(CASE WHEN order_date >= (SELECT d FROM max_d) - INTERVAL '89 days' THEN total_orders END) AS ord_90d
    FROM restaurant_en.daily_revenue
    WHERE branch_name = (SELECT branch_name FROM b)
),

-- Net revenue & margin
net AS (
    SELECT
        SUM(CASE WHEN metric_date = (SELECT d FROM max_nr) THEN net_revenue END)                   AS net_yesterday,
        SUM(CASE WHEN metric_date >= (SELECT d FROM max_nr) - INTERVAL '6 days' THEN net_revenue END)  AS net_7d,
        SUM(CASE WHEN metric_date >= (SELECT d FROM max_nr) - INTERVAL '29 days' THEN net_revenue END) AS net_30d,
        SUM(CASE WHEN metric_date >= (SELECT d FROM max_nr) - INTERVAL '89 days' THEN net_revenue END) AS net_90d,
        SUM(CASE WHEN metric_date = (SELECT d FROM max_nr) THEN gross_revenue END)                  AS gross_yesterday,
        SUM(CASE WHEN metric_date >= (SELECT d FROM max_nr) - INTERVAL '6 days' THEN gross_revenue END)  AS gross_7d,
        SUM(CASE WHEN metric_date >= (SELECT d FROM max_nr) - INTERVAL '29 days' THEN gross_revenue END) AS gross_30d,
        SUM(CASE WHEN metric_date >= (SELECT d FROM max_nr) - INTERVAL '89 days' THEN gross_revenue END) AS gross_90d,
        -- prev margin
        SUM(CASE WHEN metric_date >= (SELECT d FROM max_nr) - INTERVAL '13 days' AND metric_date < (SELECT d FROM max_nr) - INTERVAL '6 days' THEN net_revenue END) AS net_prev7d,
        SUM(CASE WHEN metric_date >= (SELECT d FROM max_nr) - INTERVAL '13 days' AND metric_date < (SELECT d FROM max_nr) - INTERVAL '6 days' THEN gross_revenue END) AS gross_prev7d,
        SUM(CASE WHEN metric_date >= (SELECT d FROM max_nr) - INTERVAL '59 days' AND metric_date < (SELECT d FROM max_nr) - INTERVAL '29 days' THEN net_revenue END) AS net_prev30d,
        SUM(CASE WHEN metric_date >= (SELECT d FROM max_nr) - INTERVAL '59 days' AND metric_date < (SELECT d FROM max_nr) - INTERVAL '29 days' THEN gross_revenue END) AS gross_prev30d,
        SUM(CASE WHEN metric_date >= (SELECT d FROM max_nr) - INTERVAL '179 days' AND metric_date < (SELECT d FROM max_nr) - INTERVAL '89 days' THEN net_revenue END) AS net_prev90d,
        SUM(CASE WHEN metric_date >= (SELECT d FROM max_nr) - INTERVAL '179 days' AND metric_date < (SELECT d FROM max_nr) - INTERVAL '89 days' THEN gross_revenue END) AS gross_prev90d
    FROM restaurant_en.daily_net_revenue
    WHERE branch_name = (SELECT branch_name FROM b)
)

SELECT
    -- Revenue
    rev_yesterday, rev_7d, rev_30d, rev_90d,
    ROUND((rev_7d  - rev_prev7d)  / NULLIF(rev_prev7d,  0) * 100, 1) AS rev_pct_7d,
    ROUND((rev_30d - rev_prev30d) / NULLIF(rev_prev30d, 0) * 100, 1) AS rev_pct_30d,
    ROUND((rev_90d - rev_prev90d) / NULLIF(rev_prev90d, 0) * 100, 1) AS rev_pct_90d,
    -- Orders
    ord_yesterday, ord_7d, ord_30d, ord_90d,
    -- AOV
    ROUND(rev_yesterday / NULLIF(ord_yesterday, 0), 2)                AS aov_yesterday,
    ROUND(rev_7d        / NULLIF(ord_7d,        0), 2)                AS aov_7d,
    ROUND(rev_30d       / NULLIF(ord_30d,       0), 2)                AS aov_30d,
    ROUND(rev_90d       / NULLIF(ord_90d,       0), 2)                AS aov_90d,
    -- Net revenue
    net_yesterday, net_7d, net_30d, net_90d,
    -- Margin
    ROUND(net_yesterday / NULLIF(gross_yesterday, 0) * 100, 1)        AS margin_yesterday,
    ROUND(net_7d        / NULLIF(gross_7d,        0) * 100, 1)        AS margin_7d,
    ROUND(net_30d       / NULLIF(gross_30d,       0) * 100, 1)        AS margin_30d,
    ROUND(net_90d       / NULLIF(gross_90d,       0) * 100, 1)        AS margin_90d,
    ROUND(net_prev7d    / NULLIF(gross_prev7d,    0) * 100, 1)        AS margin_prev7d,
    ROUND(net_prev30d   / NULLIF(gross_prev30d,   0) * 100, 1)        AS margin_prev30d,
    ROUND(net_prev90d   / NULLIF(gross_prev90d,   0) * 100, 1)        AS margin_prev90d
FROM rev, ord, net
```

```sql branch_cost_periods
WITH max_d AS (SELECT MAX(metric_date) AS d FROM restaurant_en.daily_net_revenue)
SELECT
    -- 30d
    SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN inventory_usage_cost END) AS ingr_30d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN labor_total_cost END)     AS labor_30d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN operational_total_cost END) AS overhead_30d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN gross_revenue END)         AS gross_30d,
    -- 90d
    SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN inventory_usage_cost END) AS ingr_90d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN labor_total_cost END)     AS labor_90d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN operational_total_cost END) AS overhead_90d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN gross_revenue END)         AS gross_90d
FROM restaurant_en.daily_net_revenue CROSS JOIN max_d
WHERE branch_name = '{inputs.branch}'
```

```sql branch_daily_trend
SELECT order_date, total_revenue, ROUND(revenue_sdow_avg, 2) AS revenue_sdow_avg,
    ROUND(pct_change_vs_sdow_avg * 100, 1) AS pct_vs_sdow
FROM restaurant_en.daily_revenue
WHERE branch_name = '{inputs.branch}'
  AND order_date >= (SELECT MAX(order_date) FROM restaurant_en.daily_revenue) - INTERVAL '89 days'
ORDER BY order_date
```

```sql branch_net_trend
SELECT metric_date, net_revenue, gross_revenue,
    ROUND(net_revenue / NULLIF(gross_revenue, 0) * 100, 1) AS margin_pct
FROM restaurant_en.daily_net_revenue
WHERE branch_name = '{inputs.branch}'
  AND metric_date >= (SELECT MAX(metric_date) FROM restaurant_en.daily_net_revenue) - INTERVAL '89 days'
ORDER BY metric_date
```

```sql branch_cost_trend
SELECT metric_date, inventory_usage_cost, labor_total_cost, operational_total_cost
FROM restaurant_en.daily_net_revenue
WHERE branch_name = '{inputs.branch}'
  AND metric_date >= (SELECT MAX(metric_date) FROM restaurant_en.daily_net_revenue) - INTERVAL '89 days'
ORDER BY metric_date
```

```sql branch_order_type
SELECT
    order_date,
    SUM(delivery_orders)  AS delivery,
    SUM(dine_in_orders)   AS dine_in,
    SUM(takeaway_orders)  AS takeaway
FROM restaurant_en.daily_revenue
WHERE branch_name = '{inputs.branch}'
  AND order_date >= (SELECT MAX(order_date) FROM restaurant_en.daily_revenue) - INTERVAL '29 days'
GROUP BY order_date
ORDER BY order_date
```

## {inputs.branch} — Performance Overview

<!-- Naratif pembuka dinamis -->
{#if branch_scorecard[0].margin_30d >= 15 && branch_scorecard[0].rev_pct_30d >= 0}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:12px 16px;border-radius:6px;margin-bottom:20px;">
✅ <strong>{inputs.branch} is in good shape.</strong> Net margin at {branch_scorecard[0].margin_30d}% over the last 30 days, with revenue {branch_scorecard[0].rev_pct_30d > 0 ? 'up' : 'flat'} {branch_scorecard[0].rev_pct_30d > 0 ? branch_scorecard[0].rev_pct_30d + '%' : ''} vs the prior period.
</div>
{:else if branch_scorecard[0].margin_30d >= 10}
<div style="background:rgba(248,201,0,0.1);border-left:4px solid #f8c900;padding:12px 16px;border-radius:6px;margin-bottom:20px;">
⚠️ <strong>{inputs.branch} needs attention.</strong> Margin at {branch_scorecard[0].margin_30d}% — below the 15% target. {branch_scorecard[0].rev_pct_30d < 0 ? 'Revenue is also down ' + Math.abs(branch_scorecard[0].rev_pct_30d) + '% vs the prior period.' : 'Check the cost breakdown below.'}
</div>
{:else}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:12px 16px;border-radius:6px;margin-bottom:20px;">
🚨 <strong>{inputs.branch} requires immediate action.</strong> Margin at {branch_scorecard[0].margin_30d}% — critically below 10%. Review cost structure and revenue performance below.
</div>
{/if}

---

### Multi-Period Scorecard

<div style="overflow-x:auto;">
<table style="width:100%;border-collapse:collapse;font-size:0.9em;">
<thead>
<tr style="border-bottom:2px solid var(--color-border-tertiary);">
  <th style="text-align:left;padding:10px 12px;color:var(--color-text-tertiary);font-weight:600;font-size:11px;text-transform:uppercase;letter-spacing:0.05em;">Metric</th>
  <th style="text-align:right;padding:10px 12px;color:var(--color-text-tertiary);font-weight:600;font-size:11px;text-transform:uppercase;letter-spacing:0.05em;">Yesterday</th>
  <th style="text-align:right;padding:10px 12px;color:var(--color-text-tertiary);font-weight:600;font-size:11px;text-transform:uppercase;letter-spacing:0.05em;">7 Days</th>
  <th style="text-align:right;padding:10px 12px;color:var(--color-text-tertiary);font-weight:600;font-size:11px;text-transform:uppercase;letter-spacing:0.05em;">30 Days</th>
  <th style="text-align:right;padding:10px 12px;color:var(--color-text-tertiary);font-weight:600;font-size:11px;text-transform:uppercase;letter-spacing:0.05em;">90 Days</th>
</tr>
</thead>
<tbody>

<tr style="border-bottom:1px solid var(--color-border-tertiary);">
  <td style="padding:10px 12px;font-weight:600;">Gross Revenue</td>
  <td style="padding:10px 12px;text-align:right;">${branch_scorecard[0].rev_yesterday?.toLocaleString('en-US', {minimumFractionDigits:2, maximumFractionDigits:2})}</td>
  <td style="padding:10px 12px;text-align:right;">
    ${branch_scorecard[0].rev_7d?.toLocaleString('en-US', {minimumFractionDigits:2, maximumFractionDigits:2})}
    {#if branch_scorecard[0].rev_pct_7d !== null}
    <span style="font-size:11px;margin-left:4px;color:{branch_scorecard[0].rev_pct_7d >= 0 ? '#16a34a' : '#dc2626'};">{branch_scorecard[0].rev_pct_7d >= 0 ? '▲' : '▼'}{Math.abs(branch_scorecard[0].rev_pct_7d)}%</span>
    {/if}
  </td>
  <td style="padding:10px 12px;text-align:right;">
    ${branch_scorecard[0].rev_30d?.toLocaleString('en-US', {minimumFractionDigits:2, maximumFractionDigits:2})}
    {#if branch_scorecard[0].rev_pct_30d !== null}
    <span style="font-size:11px;margin-left:4px;color:{branch_scorecard[0].rev_pct_30d >= 0 ? '#16a34a' : '#dc2626'};">{branch_scorecard[0].rev_pct_30d >= 0 ? '▲' : '▼'}{Math.abs(branch_scorecard[0].rev_pct_30d)}%</span>
    {/if}
  </td>
  <td style="padding:10px 12px;text-align:right;">
    ${branch_scorecard[0].rev_90d?.toLocaleString('en-US', {minimumFractionDigits:2, maximumFractionDigits:2})}
    {#if branch_scorecard[0].rev_pct_90d !== null}
    <span style="font-size:11px;margin-left:4px;color:{branch_scorecard[0].rev_pct_90d >= 0 ? '#16a34a' : '#dc2626'};">{branch_scorecard[0].rev_pct_90d >= 0 ? '▲' : '▼'}{Math.abs(branch_scorecard[0].rev_pct_90d)}%</span>
    {/if}
  </td>
</tr>

<tr style="border-bottom:1px solid var(--color-border-tertiary);">
  <td style="padding:10px 12px;font-weight:600;">Net Revenue</td>
  <td style="padding:10px 12px;text-align:right;">${branch_scorecard[0].net_yesterday?.toLocaleString('en-US', {minimumFractionDigits:2, maximumFractionDigits:2})}</td>
  <td style="padding:10px 12px;text-align:right;">${branch_scorecard[0].net_7d?.toLocaleString('en-US', {minimumFractionDigits:2, maximumFractionDigits:2})}</td>
  <td style="padding:10px 12px;text-align:right;">${branch_scorecard[0].net_30d?.toLocaleString('en-US', {minimumFractionDigits:2, maximumFractionDigits:2})}</td>
  <td style="padding:10px 12px;text-align:right;">${branch_scorecard[0].net_90d?.toLocaleString('en-US', {minimumFractionDigits:2, maximumFractionDigits:2})}</td>
</tr>

<tr style="border-bottom:1px solid var(--color-border-tertiary);background:rgba(0,0,0,0.02);">
  <td style="padding:10px 12px;font-weight:600;">Net Margin</td>
  <td style="padding:10px 12px;text-align:right;">
    <span style="font-weight:700;color:{branch_scorecard[0].margin_yesterday >= 15 ? '#16a34a' : branch_scorecard[0].margin_yesterday >= 10 ? '#ca8a04' : '#dc2626'};">{branch_scorecard[0].margin_yesterday}%</span>
  </td>
  <td style="padding:10px 12px;text-align:right;">
    <span style="font-weight:700;color:{branch_scorecard[0].margin_7d >= 15 ? '#16a34a' : branch_scorecard[0].margin_7d >= 10 ? '#ca8a04' : '#dc2626'};">{branch_scorecard[0].margin_7d}%</span>
    {#if branch_scorecard[0].margin_prev7d !== null}
    <span style="font-size:11px;margin-left:4px;color:{branch_scorecard[0].margin_7d >= branch_scorecard[0].margin_prev7d ? '#16a34a' : '#dc2626'};">{branch_scorecard[0].margin_7d >= branch_scorecard[0].margin_prev7d ? '▲' : '▼'}{Math.abs(branch_scorecard[0].margin_7d - branch_scorecard[0].margin_prev7d).toFixed(1)}pp</span>
    {/if}
  </td>
  <td style="padding:10px 12px;text-align:right;">
    <span style="font-weight:700;color:{branch_scorecard[0].margin_30d >= 15 ? '#16a34a' : branch_scorecard[0].margin_30d >= 10 ? '#ca8a04' : '#dc2626'};">{branch_scorecard[0].margin_30d}%</span>
    {#if branch_scorecard[0].margin_prev30d !== null}
    <span style="font-size:11px;margin-left:4px;color:{branch_scorecard[0].margin_30d >= branch_scorecard[0].margin_prev30d ? '#16a34a' : '#dc2626'};">{branch_scorecard[0].margin_30d >= branch_scorecard[0].margin_prev30d ? '▲' : '▼'}{Math.abs(branch_scorecard[0].margin_30d - branch_scorecard[0].margin_prev30d).toFixed(1)}pp</span>
    {/if}
  </td>
  <td style="padding:10px 12px;text-align:right;">
    <span style="font-weight:700;color:{branch_scorecard[0].margin_90d >= 15 ? '#16a34a' : branch_scorecard[0].margin_90d >= 10 ? '#ca8a04' : '#dc2626'};">{branch_scorecard[0].margin_90d}%</span>
    {#if branch_scorecard[0].margin_prev90d !== null}
    <span style="font-size:11px;margin-left:4px;color:{branch_scorecard[0].margin_90d >= branch_scorecard[0].margin_prev90d ? '#16a34a' : '#dc2626'};">{branch_scorecard[0].margin_90d >= branch_scorecard[0].margin_prev90d ? '▲' : '▼'}{Math.abs(branch_scorecard[0].margin_90d - branch_scorecard[0].margin_prev90d).toFixed(1)}pp</span>
    {/if}
  </td>
</tr>

<tr style="border-bottom:1px solid var(--color-border-tertiary);">
  <td style="padding:10px 12px;font-weight:600;">Orders</td>
  <td style="padding:10px 12px;text-align:right;">{branch_scorecard[0].ord_yesterday?.toLocaleString()}</td>
  <td style="padding:10px 12px;text-align:right;">{branch_scorecard[0].ord_7d?.toLocaleString()}</td>
  <td style="padding:10px 12px;text-align:right;">{branch_scorecard[0].ord_30d?.toLocaleString()}</td>
  <td style="padding:10px 12px;text-align:right;">{branch_scorecard[0].ord_90d?.toLocaleString()}</td>
</tr>

<tr>
  <td style="padding:10px 12px;font-weight:600;">Avg Order Value</td>
  <td style="padding:10px 12px;text-align:right;">${branch_scorecard[0].aov_yesterday}</td>
  <td style="padding:10px 12px;text-align:right;">${branch_scorecard[0].aov_7d}</td>
  <td style="padding:10px 12px;text-align:right;">${branch_scorecard[0].aov_30d}</td>
  <td style="padding:10px 12px;text-align:right;">${branch_scorecard[0].aov_90d}</td>
</tr>

</tbody>
</table>
</div>

_▲▼ deltas compare to the equivalent prior period. Margin color: 🟢 ≥15% · 🟡 10–15% · 🔴 di bawah 10%._

---

### 90-Day Revenue Trend

<LineChart
    data={branch_daily_trend}
    x="order_date"
    y={["total_revenue", "revenue_sdow_avg"]}
    title="Daily Revenue vs Same-Day-of-Week Avg ($)"
    yFmt="$#,##0"
    xAxisTitle="Date"
    yAxisTitle="Revenue ($)"
/>

_Solid line = actual daily revenue. Dashed line = same-day-of-week average (Monday vs Mondays). When actual consistently trails the average, the location is structurally underperforming._

---

### Net Margin Trend — 90 Days

<LineChart
    data={branch_net_trend}
    x="metric_date"
    y="margin_pct"
    title="Net Margin % — Daily"
    yFmt="0.0\%"
    xAxisTitle="Date"
    yAxisTitle="Net Margin (%)"
/>

---

### Cost Structure — 30 Days vs 90 Days

<div style="overflow-x:auto;">
<table style="width:100%;border-collapse:collapse;font-size:0.9em;">
<thead>
<tr style="border-bottom:2px solid var(--color-border-tertiary);">
  <th style="text-align:left;padding:10px 12px;color:var(--color-text-tertiary);font-weight:600;font-size:11px;text-transform:uppercase;letter-spacing:0.05em;">Cost Component</th>
  <th style="text-align:right;padding:10px 12px;color:var(--color-text-tertiary);font-weight:600;font-size:11px;text-transform:uppercase;letter-spacing:0.05em;">30 Days ($)</th>
  <th style="text-align:right;padding:10px 12px;color:var(--color-text-tertiary);font-weight:600;font-size:11px;text-transform:uppercase;letter-spacing:0.05em;">30 Days (% Rev)</th>
  <th style="text-align:right;padding:10px 12px;color:var(--color-text-tertiary);font-weight:600;font-size:11px;text-transform:uppercase;letter-spacing:0.05em;">90 Days ($)</th>
  <th style="text-align:right;padding:10px 12px;color:var(--color-text-tertiary);font-weight:600;font-size:11px;text-transform:uppercase;letter-spacing:0.05em;">90 Days (% Rev)</th>
</tr>
</thead>
<tbody>

<tr style="border-bottom:1px solid var(--color-border-tertiary);">
  <td style="padding:10px 12px;font-weight:600;">🥩 Ingredients</td>
  <td style="padding:10px 12px;text-align:right;">${branch_cost_periods[0].ingr_30d?.toLocaleString('en-US', {minimumFractionDigits:2, maximumFractionDigits:2})}</td>
  <td style="padding:10px 12px;text-align:right;">
    <span style="font-weight:600;color:{branch_cost_periods[0].ingr_30d / branch_cost_periods[0].gross_30d * 100 <= 32 ? '#16a34a' : branch_cost_periods[0].ingr_30d / branch_cost_periods[0].gross_30d * 100 <= 38 ? '#ca8a04' : '#dc2626'};">
      {(branch_cost_periods[0].ingr_30d / branch_cost_periods[0].gross_30d * 100).toFixed(1)}%
    </span>
  </td>
  <td style="padding:10px 12px;text-align:right;">${branch_cost_periods[0].ingr_90d?.toLocaleString('en-US', {minimumFractionDigits:2, maximumFractionDigits:2})}</td>
  <td style="padding:10px 12px;text-align:right;">
    <span style="font-weight:600;color:{branch_cost_periods[0].ingr_90d / branch_cost_periods[0].gross_90d * 100 <= 32 ? '#16a34a' : branch_cost_periods[0].ingr_90d / branch_cost_periods[0].gross_90d * 100 <= 38 ? '#ca8a04' : '#dc2626'};">
      {(branch_cost_periods[0].ingr_90d / branch_cost_periods[0].gross_90d * 100).toFixed(1)}%
    </span>
  </td>
</tr>

<tr style="border-bottom:1px solid var(--color-border-tertiary);">
  <td style="padding:10px 12px;font-weight:600;">👨‍💼 Labor</td>
  <td style="padding:10px 12px;text-align:right;">${branch_cost_periods[0].labor_30d?.toLocaleString('en-US', {minimumFractionDigits:2, maximumFractionDigits:2})}</td>
  <td style="padding:10px 12px;text-align:right;">
    <span style="font-weight:600;color:{branch_cost_periods[0].labor_30d / branch_cost_periods[0].gross_30d * 100 <= 30 ? '#16a34a' : branch_cost_periods[0].labor_30d / branch_cost_periods[0].gross_30d * 100 <= 35 ? '#ca8a04' : '#dc2626'};">
      {(branch_cost_periods[0].labor_30d / branch_cost_periods[0].gross_30d * 100).toFixed(1)}%
    </span>
  </td>
  <td style="padding:10px 12px;text-align:right;">${branch_cost_periods[0].labor_90d?.toLocaleString('en-US', {minimumFractionDigits:2, maximumFractionDigits:2})}</td>
  <td style="padding:10px 12px;text-align:right;">
    <span style="font-weight:600;color:{branch_cost_periods[0].labor_90d / branch_cost_periods[0].gross_90d * 100 <= 30 ? '#16a34a' : branch_cost_periods[0].labor_90d / branch_cost_periods[0].gross_90d * 100 <= 35 ? '#ca8a04' : '#dc2626'};">
      {(branch_cost_periods[0].labor_90d / branch_cost_periods[0].gross_90d * 100).toFixed(1)}%
    </span>
  </td>
</tr>

<tr>
  <td style="padding:10px 12px;font-weight:600;">🏢 Overhead</td>
  <td style="padding:10px 12px;text-align:right;">${branch_cost_periods[0].overhead_30d?.toLocaleString('en-US', {minimumFractionDigits:2, maximumFractionDigits:2})}</td>
  <td style="padding:10px 12px;text-align:right;">
    <span style="font-weight:600;color:{branch_cost_periods[0].overhead_30d / branch_cost_periods[0].gross_30d * 100 <= 15 ? '#16a34a' : branch_cost_periods[0].overhead_30d / branch_cost_periods[0].gross_30d * 100 <= 20 ? '#ca8a04' : '#dc2626'};">
      {(branch_cost_periods[0].overhead_30d / branch_cost_periods[0].gross_30d * 100).toFixed(1)}%
    </span>
  </td>
  <td style="padding:10px 12px;text-align:right;">${branch_cost_periods[0].overhead_90d?.toLocaleString('en-US', {minimumFractionDigits:2, maximumFractionDigits:2})}</td>
  <td style="padding:10px 12px;text-align:right;">
    <span style="font-weight:600;color:{branch_cost_periods[0].overhead_90d / branch_cost_periods[0].gross_90d * 100 <= 15 ? '#16a34a' : branch_cost_periods[0].overhead_90d / branch_cost_periods[0].gross_90d * 100 <= 20 ? '#ca8a04' : '#dc2626'};">
      {(branch_cost_periods[0].overhead_90d / branch_cost_periods[0].gross_90d * 100).toFixed(1)}%
    </span>
  </td>
</tr>

</tbody>
</table>
</div>

_Benchmarks: Ingredients ≤32% · Labor ≤30% · Overhead ≤15%. Color: 🟢 on target · 🟡 watch · 🔴 over._

---

### Daily Cost Trend — 90 Days

<BarChart
    data={branch_cost_trend}
    x="metric_date"
    y={["inventory_usage_cost", "labor_total_cost", "operational_total_cost"]}
    type="stacked"
    title="Daily Cost Breakdown ($)"
    yFmt="$#,##0"
    xAxisTitle="Date"
    yAxisTitle="Cost ($)"
/>

---

### Order Type Mix — Last 30 Days

<BarChart
    data={branch_order_type}
    x="order_date"
    y={["dine_in", "delivery", "takeaway"]}
    type="stacked"
    title="Orders by Type — Daily"
    xAxisTitle="Date"
    yAxisTitle="Orders"
/>

{/if}

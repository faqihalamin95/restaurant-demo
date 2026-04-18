---
title: Restaurant Analytics — Daily Overview
---

```sql tgl
SELECT
    MAX(order_date)                                      AS max_date,
    DAYNAME(MAX(order_date))                             AS day_name,
    STRFTIME('%B %d, %Y', MAX(order_date))               AS date_display
FROM restaurant_en.daily_revenue
```

```sql daily_kpi
SELECT
    SUM(total_revenue)                                           AS total_revenue,
    SUM(total_orders)                                            AS total_orders,
    COUNT(DISTINCT branch_id)                                    AS active_locations,
    ROUND(SUM(total_revenue) / NULLIF(SUM(total_orders), 0), 2) AS avg_order_value
FROM restaurant_en.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant_en.daily_revenue)
```

```sql net_summary_today
SELECT
    SUM(net_revenue)                                                  AS net_revenue,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS net_margin_pct
FROM restaurant_en.daily_net_revenue
WHERE metric_date = (SELECT MAX(metric_date) FROM restaurant_en.daily_net_revenue)
```

```sql pct_change
SELECT
    ROUND((today_rev - avg_sdow) / NULLIF(avg_sdow, 0), 3) AS pct_change,
    CASE
        WHEN ROUND((today_rev - avg_sdow) / NULLIF(avg_sdow, 0), 3) > 0.10  THEN 'up'
        WHEN ROUND((today_rev - avg_sdow) / NULLIF(avg_sdow, 0), 3) < -0.10 THEN 'down'
        ELSE 'stable'
    END AS condition
FROM (
    SELECT
        SUM(CASE WHEN order_date = (SELECT MAX(order_date) FROM restaurant_en.daily_revenue)
            THEN daily_total ELSE 0 END)                             AS today_rev,
        AVG(CASE
            WHEN order_date < (SELECT MAX(order_date) FROM restaurant_en.daily_revenue)
            AND DAYOFWEEK(order_date) = DAYOFWEEK((SELECT MAX(order_date) FROM restaurant_en.daily_revenue))
            AND order_date >= (SELECT MAX(order_date) FROM restaurant_en.daily_revenue) - INTERVAL '30 days'
            THEN daily_total
        END)                                                         AS avg_sdow
    FROM (
        SELECT order_date, SUM(total_revenue) AS daily_total
        FROM restaurant_en.daily_revenue
        WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.daily_revenue) - INTERVAL '30 days'
        GROUP BY order_date
    )
)
```

```sql best_location
SELECT branch_name, total_revenue
FROM restaurant_en.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant_en.daily_revenue)
ORDER BY total_revenue DESC
LIMIT 1
```

```sql top_menu_today
SELECT menu_name
FROM restaurant_en.menu_performance
WHERE order_date = (SELECT MAX(order_date) FROM restaurant_en.menu_performance)
ORDER BY total_qty_sold DESC
LIMIT 1
```

```sql insights
SELECT
    branch_name,
    ROUND(pct_change_vs_sdow_avg * 100, 1) AS pct_change
FROM restaurant_en.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant_en.daily_revenue)
  AND pct_change_vs_sdow_avg < -0.15
ORDER BY pct_change_vs_sdow_avg ASC
LIMIT 3
```

```sql menu_alerts
SELECT
    menu_name,
    ROUND(qty_wow_change * 100, 1) AS pct_change
FROM restaurant_en.menu_performance
WHERE order_date = (SELECT MAX(order_date) FROM restaurant_en.menu_performance)
  AND qty_wow_change < -0.20
ORDER BY qty_wow_change ASC
LIMIT 3
```

```sql attendance_alerts
SELECT COUNT(*) AS absent_count
FROM restaurant_en.employee_shift_performance
WHERE attendance_date = (SELECT MAX(attendance_date) FROM restaurant_en.employee_shift_performance)
  AND attendance_status = 'absent'
```

---

_Data refreshed automatically every morning. Report covers **{tgl[0].day_name}, {tgl[0].date_display}**._

---

{#if pct_change[0].condition === 'up'}
<div>

🎉 **Hey, Owner!** Yesterday's revenue is up **{(pct_change[0].pct_change * 100).toFixed(1)}%** vs the average {tgl[0].day_name} over the past 30 days. Best location: **{best_location[0].branch_name}**, top-selling item: **{top_menu_today[0].menu_name}**.

</div>
{:else if pct_change[0].condition === 'down'}
<div>

⚠️ **Heads up, Owner.** Yesterday's revenue is down **{(Math.abs(pct_change[0].pct_change) * 100).toFixed(1)}%** vs the average {tgl[0].day_name} over the past 30 days. Check the locations flagged below.

</div>
{:else}
<div>

👋 **Hey, Owner!** Yesterday was steady compared to the average {tgl[0].day_name} over the past 30 days. Best location: **{best_location[0].branch_name}**, top item: **{top_menu_today[0].menu_name}**.

</div>
{/if}

---

## 🔔 Alerts

{#if insights.length > 0 || attendance_alerts[0].absent_count >= 3 || menu_alerts.length > 0}

<div style="display:flex;flex-direction:column;gap:12px;margin-bottom:24px;">

{#each insights as row}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:12px 16px;border-radius:6px;">
🔴 <strong>{row.branch_name}</strong> — Revenue down <strong>{row.pct_change}%</strong> vs same-day-of-week average (30 days). Investigate immediately.
</div>
{/each}

{#if attendance_alerts[0].absent_count >= 3}
<div style="background:rgba(248,201,0,0.1);border-left:4px solid #f8c900;padding:12px 16px;border-radius:6px;">
🟡 <strong>{attendance_alerts[0].absent_count} staff absent</strong> yesterday. Verify no shift is understaffed.
</div>
{/if}

{#each menu_alerts as row}
<div style="background:rgba(248,201,0,0.1);border-left:4px solid #f8c900;padding:12px 16px;border-radius:6px;">
🟡 <strong>{row.menu_name}</strong> — Sales down <strong>{row.pct_change}%</strong> vs last week. Consider a promotion or menu review.
</div>
{/each}

</div>

{:else}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:12px 16px;border-radius:6px;margin-bottom:24px;">
✅ <strong>All indicators normal.</strong> No flagged locations, menus, or attendance issues yesterday.
</div>
{/if}

---

## Key Metrics — {tgl[0].date_display}

<BigValue data={daily_kpi}         value="total_revenue"   title="Total Revenue"        fmt="$#,##0.00" />
<BigValue data={daily_kpi}         value="total_orders"    title="Total Orders"          fmt="#,##0" />
<BigValue data={daily_kpi}         value="active_locations" title="Active Locations" />
<BigValue data={daily_kpi}         value="avg_order_value" title="Avg Order Value"       fmt="$#,##0.00" />
<BigValue data={net_summary_today} value="net_revenue"     title="Net Revenue"           fmt="$#,##0.00" />
<BigValue data={net_summary_today} value="net_margin_pct"  title="Net Margin"            fmt="0.0\%" />

---

## Location Performance — {tgl[0].date_display}

```sql branch_daily
SELECT
    branch_name,
    total_revenue,
    total_orders,
    ROUND(total_revenue / NULLIF(total_orders, 0), 2) AS avg_order_value,
    pct_change_vs_sdow_avg
FROM restaurant_en.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant_en.daily_revenue)
ORDER BY total_revenue DESC
```

```sql net_by_branch_today
SELECT
    branch_name,
    gross_revenue,
    inventory_usage_cost   AS cost_ingredients,
    labor_total_cost       AS cost_labor,
    operational_total_cost AS cost_overhead,
    net_revenue,
    ROUND(net_revenue / NULLIF(gross_revenue, 0) * 100, 1) AS net_margin_pct
FROM restaurant_en.daily_net_revenue
WHERE metric_date = (SELECT MAX(metric_date) FROM restaurant_en.daily_net_revenue)
ORDER BY net_revenue DESC
```

<DataTable data={branch_daily}>
    <Column id="branch_name"            title="Location"/>
    <Column id="total_revenue"          title="Revenue"            fmt="$#,##0.00"/>
    <Column id="total_orders"           title="Orders"             fmt="#,##0"/>
    <Column id="avg_order_value"        title="Avg Order Value"    fmt="$#,##0.00"/>
    <Column id="pct_change_vs_sdow_avg" title="vs Same-Day Avg"   fmt="+0.0%;-0.0%;0.0%" contentType="delta"/>
</DataTable>

<DataTable data={net_by_branch_today}>
    <Column id="branch_name"     title="Location"/>
    <Column id="gross_revenue"   title="Gross Revenue"   fmt="$#,##0.00"/>
    <Column id="cost_ingredients" title="Ingredients"    fmt="$#,##0.00"/>
    <Column id="cost_labor"      title="Labor"           fmt="$#,##0.00"/>
    <Column id="cost_overhead"   title="Overhead"        fmt="$#,##0.00"/>
    <Column id="net_revenue"     title="Net Revenue"     fmt="$#,##0.00"/>
    <Column id="net_margin_pct"  title="Margin"          fmt="0.0\%"/>
</DataTable>

_Full trend analysis on the **Branch Performance** and **Financial Report** pages._

---

## Top Menu Items — {tgl[0].date_display}

```sql menu_daily
SELECT
    menu_name,
    category,
    SUM(total_qty_sold) AS total_qty,
    SUM(total_revenue)  AS total_revenue
FROM restaurant_en.menu_performance
WHERE order_date = (SELECT MAX(order_date) FROM restaurant_en.menu_performance)
GROUP BY menu_name, category
ORDER BY total_qty DESC
LIMIT 10
```

<DataTable data={menu_daily}>
    <Column id="menu_name"     title="Item"/>
    <Column id="category"      title="Category"/>
    <Column id="total_qty"     title="Units Sold"   fmt="#,##0"/>
    <Column id="total_revenue" title="Revenue"      fmt="$#,##0.00"/>
</DataTable>

---

## Shift & Attendance — {tgl[0].date_display}

```sql shift_daily
SELECT
    shift_name,
    SUM(orders_handled)       AS total_orders,
    SUM(total_revenue)        AS total_revenue,
    ROUND(AVG(avg_ticket), 2) AS avg_ticket
FROM restaurant_en.employee_shift_performance
WHERE attendance_date = (SELECT MAX(attendance_date) FROM restaurant_en.employee_shift_performance)
GROUP BY shift_name
ORDER BY total_revenue DESC
```

```sql attendance_daily
SELECT
    attendance_status,
    COUNT(*) AS total
FROM restaurant_en.employee_shift_performance
WHERE attendance_date = (SELECT MAX(attendance_date) FROM restaurant_en.employee_shift_performance)
GROUP BY attendance_status
ORDER BY total DESC
```

<Grid cols=2>
<div>

### Performance by Shift

<DataTable data={shift_daily}>
    <Column id="shift_name"    title="Shift"/>
    <Column id="total_orders"  title="Orders Handled"  fmt="#,##0"/>
    <Column id="total_revenue" title="Revenue"         fmt="$#,##0.00"/>
    <Column id="avg_ticket"    title="Avg Ticket"      fmt="$#,##0.00"/>
</DataTable>

</div>
<div>

### Attendance Status

<BarChart
    data={attendance_daily}
    x="attendance_status"
    y="total"
    title="Staff Attendance"
    xAxisTitle="Status"
    yAxisTitle="Count"
/>

</div>
</Grid>

---

## Orders by Hour — {tgl[0].date_display}

```sql hourly_daily
SELECT
    order_hour,
    order_type,
    SUM(total_orders)  AS total_orders,
    SUM(total_revenue) AS total_revenue
FROM restaurant_en.peak_hours
WHERE order_date = (SELECT MAX(order_date) FROM restaurant_en.peak_hours)
GROUP BY order_hour, order_type
ORDER BY order_hour
```

<BarChart
    data={hourly_daily}
    x="order_hour"
    y="total_orders"
    series="order_type"
    type="stacked"
    title="Orders by Hour — Dine-in vs Delivery vs Takeaway"
    xAxisTitle="Hour"
    yAxisTitle="Total Orders"
/>

_Peak hour forecasting on the **Peak Hours** page._

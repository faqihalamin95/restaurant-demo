---
title: Restaurant Analytics
---

# 🍔 Restaurant Analytics Dashboard

_Data updated daily at 6:00 AM. Showing yesterday's performance._

```sql today_summary
SELECT
    SUM(total_revenue)                          AS total_revenue,
    SUM(total_orders)                           AS total_orders,
    COUNT(DISTINCT branch_id)                   AS active_locations,
    ROUND(SUM(total_revenue) / SUM(total_orders), 2) AS avg_order_value
FROM restaurant_en.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant_en.daily_revenue)
```

<BigValue
    data={today_summary}
    value="total_revenue"
    title="Today's Revenue"
    fmt="$#,##0.00"
/>

<BigValue
    data={today_summary}
    value="total_orders"
    title="Total Orders"
    fmt="#,##0"
/>

<BigValue
    data={today_summary}
    value="active_locations"
    title="Active Locations"
/>

<BigValue
    data={today_summary}
    value="avg_order_value"
    title="Avg Order Value"
    fmt="$#,##0.00"
/>

---

## Revenue Trend — Last 30 Days

```sql revenue_trend
SELECT
    order_date,
    branch_name,
    total_revenue
FROM restaurant_en.daily_revenue
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.daily_revenue) - INTERVAL '30 days'
ORDER BY order_date
```

<LineChart
    data={revenue_trend}
    x="order_date"
    y="total_revenue"
    series="branch_name"
    title="Revenue by Location (30 Days)"
    yFmt="$#,##0"
/>

---

## Location Performance — Yesterday

```sql branch_yesterday
SELECT
    branch_name,
    total_revenue,
    total_orders,
    ROUND(pct_change_vs_7d_avg * 100, 1) AS pct_change
FROM restaurant_en.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant_en.daily_revenue)
ORDER BY total_revenue DESC
```

<DataTable
    data={branch_yesterday}
    rows=4
>
    <Column id="branch_name" title="Location"/>
    <Column id="total_revenue" title="Revenue" fmt="$#,##0.00"/>
    <Column id="total_orders" title="Orders" fmt="#,##0"/>
    <Column id="pct_change" title="vs 7-Day Avg" fmt="+0.0%;-0.0%;0.0%" contentType="delta"/>
</DataTable>

---

## ⚠️ Early Warning — Revenue Drop

```sql anomaly_alert
SELECT
    branch_name,
    order_date,
    total_revenue,
    ROUND(revenue_7d_avg, 2)                AS avg_7d,
    ROUND(pct_change_vs_7d_avg * 100, 1)    AS pct_drop
FROM restaurant_en.daily_revenue
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.daily_revenue) - INTERVAL '7 days'
  AND pct_change_vs_7d_avg < -0.15
ORDER BY pct_change_vs_7d_avg ASC
```

{#if anomaly_alert.length > 0}
<DataTable data={anomaly_alert}>
    <Column id="branch_name" title="Location"/>
    <Column id="order_date" title="Date"/>
    <Column id="total_revenue" title="Revenue" fmt="$#,##0.00"/>
    <Column id="avg_7d" title="7-Day Avg" fmt="$#,##0.00"/>
    <Column id="pct_drop" title="Change" fmt="+0.0%;-0.0%;0.0%" contentType="delta"/>
</DataTable>
{:else}
> ✅ No revenue anomalies detected in the last 7 days.
{/if}
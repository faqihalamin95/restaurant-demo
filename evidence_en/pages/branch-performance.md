---
title: Location Performance
---

# 📍 Location Performance

```sql branch_monthly
SELECT
    DATE_TRUNC('month', order_date)     AS month,
    branch_name,
    SUM(total_revenue)                  AS total_revenue,
    SUM(total_orders)                   AS total_orders
FROM restaurant_en.daily_revenue
GROUP BY 1, 2
ORDER BY 1, 2
```

## Monthly Revenue by Location

<BarChart
    data={branch_monthly}
    x="month"
    y="total_revenue"
    series="branch_name"
    type="stacked"
    title="Monthly Revenue (Stacked)"
    yFmt="$#,##0"
/>

---

## Daily Trend — Last 90 Days

```sql branch_daily_90
SELECT
    order_date,
    branch_name,
    total_revenue,
    ROUND(revenue_7d_avg, 2)            AS revenue_7d_avg
FROM restaurant_en.daily_revenue
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.daily_revenue) - INTERVAL '90 days'
ORDER BY order_date, branch_name
```

<LineChart
    data={branch_daily_90}
    x="order_date"
    y="revenue_7d_avg"
    series="branch_name"
    title="7-Day Rolling Average Revenue by Location"
    yFmt="$#,##0"
/>

---

## Overall Summary

```sql branch_summary
SELECT
    branch_name,
    SUM(total_revenue)                                  AS total_revenue,
    SUM(total_orders)                                   AS total_orders,
    ROUND(SUM(total_revenue) / SUM(total_orders), 2)    AS avg_order_value,
    MIN(order_date)                                     AS first_date
FROM restaurant_en.daily_revenue
GROUP BY branch_name
ORDER BY total_revenue DESC
```

<DataTable data={branch_summary}>
    <Column id="branch_name" title="Location"/>
    <Column id="total_revenue" title="Total Revenue" fmt="$#,##0.00"/>
    <Column id="total_orders" title="Total Orders" fmt="#,##0"/>
    <Column id="avg_order_value" title="Avg Order Value" fmt="$#,##0.00"/>
    <Column id="first_date" title="Since"/>
</DataTable>
---
title: Peak Hours
---

# ⏰ Peak Hours Analysis

## Order Distribution by Hour — All Locations

```sql hourly_all
SELECT
    order_hour,
    day_part,
    SUM(total_orders)       AS total_orders,
    SUM(total_revenue)      AS total_revenue
FROM restaurant_en.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.peak_hours) - INTERVAL '30 days'
GROUP BY order_hour, day_part
ORDER BY order_hour
```

<BarChart
    data={hourly_all}
    x="order_hour"
    y="total_orders"
    series="day_part"
    title="Total Orders by Hour (30 Days)"
    xAxisTitle="Hour"
    yAxisTitle="Total Orders"
/>

---

## Order Type by Hour

```sql order_type_hourly
SELECT
    order_hour,
    order_type,
    SUM(total_orders)       AS total_orders
FROM restaurant_en.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.peak_hours) - INTERVAL '30 days'
GROUP BY order_hour, order_type
ORDER BY order_hour
```

<BarChart
    data={order_type_hourly}
    x="order_hour"
    y="total_orders"
    series="order_type"
    type="stacked"
    title="Dine-in vs Delivery vs Takeaway by Hour"
    xAxisTitle="Hour"
/>

---

## Peak Hours by Location

```sql peak_by_branch
SELECT
    branch_name,
    day_part,
    SUM(total_orders)       AS total_orders
FROM restaurant_en.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.peak_hours) - INTERVAL '30 days'
GROUP BY branch_name, day_part
ORDER BY branch_name, total_orders DESC
```

<BarChart
    data={peak_by_branch}
    x="day_part"
    y="total_orders"
    series="branch_name"
    title="Day Part Distribution by Location"
    type="grouped"
/>

---

## Day Part Summary

```sql daypart_summary
SELECT
    day_part,
    SUM(total_orders)                               AS total_orders,
    SUM(total_revenue)                              AS total_revenue,
    ROUND(SUM(total_revenue) / SUM(total_orders), 2) AS avg_order_value
FROM restaurant_en.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant_en.peak_hours) - INTERVAL '30 days'
GROUP BY day_part
ORDER BY total_orders DESC
```

<DataTable data={daypart_summary}>
    <Column id="day_part" title="Period"/>
    <Column id="total_orders" title="Total Orders" fmt="#,##0"/>
    <Column id="total_revenue" title="Total Revenue" fmt="$#,##0.00"/>
    <Column id="avg_order_value" title="Avg Order Value" fmt="$#,##0.00"/>
</DataTable>
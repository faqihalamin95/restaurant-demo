---
title: Jam Sibuk
---

# ⏰ Analisis Jam Sibuk

## Distribusi Order per Jam — Semua Cabang

```sql hourly_all
SELECT
    order_hour,
    day_part,
    SUM(total_orders)       AS total_orders,
    SUM(total_revenue)      AS total_revenue
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY order_hour, day_part
ORDER BY order_hour
```

<BarChart
    data={hourly_all}
    x="order_hour"
    y="total_orders"
    series="day_part"
    title="Total Order per Jam (30 Hari)"
    xAxisTitle="Jam"
    yAxisTitle="Total Order"
/>

---

## Order Type per Jam

```sql order_type_hourly
SELECT
    order_hour,
    order_type,
    SUM(total_orders)       AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY order_hour, order_type
ORDER BY order_hour
```

<BarChart
    data={order_type_hourly}
    x="order_hour"
    y="total_orders"
    series="order_type"
    type="stacked"
    title="Dine-in vs Delivery vs Takeaway per Jam"
    xAxisTitle="Jam"
/>

---

## Peak Hours per Cabang

```sql peak_by_branch
SELECT
    branch_name,
    day_part,
    SUM(total_orders)       AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY branch_name, day_part
ORDER BY branch_name, total_orders DESC
```

<BarChart
    data={peak_by_branch}
    x="day_part"
    y="total_orders"
    series="branch_name"
    title="Distribusi Day Part per Cabang"
    type="grouped"
/>

---

## Ringkasan Day Part

```sql daypart_summary
SELECT
    day_part,
    SUM(total_orders)                               AS total_orders,
    SUM(total_revenue)                              AS total_revenue,
    ROUND(SUM(total_revenue) / SUM(total_orders), 0) AS avg_order_value
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY day_part
ORDER BY total_orders DESC
```

<DataTable data={daypart_summary}>
    <Column id="day_part" title="Periode"/>
    <Column id="total_orders" title="Total Order" fmt="#,##0"/>
    <Column id="total_revenue" title="Total Revenue" fmt="Rp #,##0"/>
    <Column id="avg_order_value" title="Avg Order Value" fmt="Rp #,##0"/>
</DataTable>
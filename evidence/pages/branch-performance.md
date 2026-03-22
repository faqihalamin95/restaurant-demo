---
title: Performa Cabang
---

# Performa Cabang

_Analisis revenue dan tren performa per cabang restoran._

---

## Revenue Bulanan per Cabang

```sql branch_monthly
SELECT
    DATE_TRUNC('month', order_date) AS bulan,
    branch_name,
    SUM(total_revenue)              AS total_revenue,
    SUM(total_orders)               AS total_orders
FROM restaurant.daily_revenue
GROUP BY 1, 2
ORDER BY 1, 2
```

<BarChart
    data={branch_monthly}
    x="bulan"
    y="total_revenue"
    series="branch_name"
    type="stacked"
    title="Revenue Bulanan per Cabang"
    yfmt="Rp #,##0"
    xAxisTitle="Bulan"
    yAxisTitle="Revenue"
/>

---

## Tren Harian  (90 Hari Terakhir)

```sql branch_daily_90
SELECT
    order_date,
    branch_name,
    total_revenue,
    ROUND(revenue_7d_avg, 0) AS revenue_7d_avg
FROM restaurant.daily_revenue
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.daily_revenue) - INTERVAL '90 days'
ORDER BY order_date, branch_name
```

<LineChart
    data={branch_daily_90}
    x="order_date"
    y="revenue_7d_avg"
    series="branch_name"
    title="Rata-rata 7 Hari per Cabang"
    yfmt="Rp #,##0"
    xAxisTitle="Tanggal"
    yAxisTitle="Revenue (7-Day Avg)"
/>

---

## Ringkasan Keseluruhan

```sql branch_summary
SELECT
    branch_name,
    SUM(total_revenue)                                                  AS total_revenue,
    SUM(total_orders)                                                   AS total_orders,
    ROUND(SUM(total_revenue) / NULLIF(SUM(total_orders), 0), 0)         AS avg_order_value,
    MIN(order_date)                                                     AS first_date,
    MAX(order_date)                                                     AS last_date
FROM restaurant.daily_revenue
GROUP BY branch_name
ORDER BY total_revenue DESC
```

<DataTable data={branch_summary}>
    <Column id="branch_name" title="Cabang"/>
    <Column id="total_revenue" title="Total Revenue" fmt="Rp #,##0"/>
    <Column id="total_orders" title="Total Pesanan" fmt="#,##0"/>
    <Column id="avg_order_value" title="Rata-rata Nilai Order" fmt="Rp #,##0"/>
    <Column id="first_date" title="Mulai Beroperasi"/>
    <Column id="last_date" title="Data Terakhir"/>
</DataTable>

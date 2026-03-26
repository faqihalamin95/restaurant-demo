---
title: Performa Cabang
---

_Analisis revenue dan tren performa per cabang restoran._

```sql summary_all
SELECT
    SUM(total_revenue)              AS total_revenue_all,
    COUNT(DISTINCT branch_id)       AS total_cabang
FROM restaurant.daily_revenue
```

```sql best_branch_month
SELECT
    branch_name,
    SUM(total_revenue) AS total_revenue
FROM restaurant.daily_revenue
WHERE DATE_TRUNC('month', order_date) = DATE_TRUNC('month', (SELECT MAX(order_date) FROM restaurant.daily_revenue))
GROUP BY branch_name
ORDER BY total_revenue DESC
LIMIT 1
```

<BigValue
    data={summary_all}
    value="total_revenue_all"
    title="Total Revenue Keseluruhan (Rp)"
    fmt="#,##0"
/>

<BigValue
    data={summary_all}
    value="total_cabang"
    title="Total Cabang Aktif"
/>

<BigValue
    data={best_branch_month}
    value="branch_name"
    title="Cabang Terbaik Bulan Ini"
/>

<BigValue
    data={best_branch_month}
    value="total_revenue"
    title="Revenue Cabang Terbaik (Rp)"
    fmt="#,##0"
/>

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
    title="Revenue Bulanan per Cabang (Rp)"
    yFmt="#,##0"
    xAxisTitle="Bulan"
    yAxisTitle="Revenue (Rp)"
/>

_Grafik di atas menunjukkan kontribusi revenue tiap cabang per bulan. Cabang dengan bar tertinggi secara konsisten adalah pemain utama bisnis kamu — pertahankan performa mereka dan jadikan benchmark untuk cabang lainnya._

---

## Tren Harian (90 Hari Terakhir)

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
    title="Rata-rata 7 Hari per Cabang (Rp)"
    yFmt="#,##0"
    xAxisTitle="Tanggal"
    yAxisTitle="Revenue 7-Day Avg (Rp)"
/>

_Garis yang menurun secara konsisten perlu perhatian lebih — bisa jadi indikasi masalah operasional atau persaingan di area cabang tersebut. Sebaliknya, tren naik yang stabil menandakan cabang sedang dalam momentum yang baik._

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
    <Column id="total_revenue" title="Total Revenue (Rp)" fmt="#,##0"/>
    <Column id="total_orders" title="Total Pesanan" fmt="#,##0"/>
    <Column id="avg_order_value" title="Rata-rata Nilai Order (Rp)" fmt="#,##0"/>
    <Column id="first_date" title="Mulai Beroperasi"/>
    <Column id="last_date" title="Data Terakhir"/>
</DataTable>

_Rata-rata nilai order yang rendah di suatu cabang bisa jadi peluang untuk mendorong upselling atau bundling menu. Bandingkan antar cabang untuk menemukan best practice yang bisa diterapkan di cabang lain._
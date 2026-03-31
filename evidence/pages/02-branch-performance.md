---
title: Performa Cabang
---

_Analisis revenue dan tren performa per cabang restoran._
```sql summary_all
SELECT
    SUM(total_revenue)        AS total_revenue_all,
    COUNT(DISTINCT branch_id) AS total_cabang
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

<BigValue data={summary_all}       value="total_revenue_all" title="Total Revenue Keseluruhan (Rp)" fmt="#,##0" />
<BigValue data={summary_all}       value="total_cabang"      title="Total Cabang Aktif" />
<BigValue data={best_branch_month} value="branch_name"       title="Cabang Terbaik Bulan Ini" />
<BigValue data={best_branch_month} value="total_revenue"     title="Revenue Cabang Terbaik (Rp)" fmt="#,##0" />

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
```sql branch_wow
WITH max_date AS (
    SELECT MAX(order_date) AS d FROM restaurant.daily_revenue
)
SELECT
    branch_name,
    SUM(CASE WHEN order_date >= (SELECT d FROM max_date) - INTERVAL '6 days'
        THEN total_revenue END)                                             AS revenue_minggu_ini,
    SUM(CASE WHEN order_date <  (SELECT d FROM max_date) - INTERVAL '6 days'
         AND  order_date >= (SELECT d FROM max_date) - INTERVAL '13 days'
        THEN total_revenue END)                                             AS revenue_minggu_lalu,
    ROUND(
        (SUM(CASE WHEN order_date >= (SELECT d FROM max_date) - INTERVAL '6 days'
            THEN total_revenue END)
        - SUM(CASE WHEN order_date <  (SELECT d FROM max_date) - INTERVAL '6 days'
             AND   order_date >= (SELECT d FROM max_date) - INTERVAL '13 days'
            THEN total_revenue END))
        / NULLIF(SUM(CASE WHEN order_date <  (SELECT d FROM max_date) - INTERVAL '6 days'
             AND  order_date >= (SELECT d FROM max_date) - INTERVAL '13 days'
            THEN total_revenue END), 0) * 100
    , 1)                                                                    AS pct_change
FROM restaurant.daily_revenue
GROUP BY 1
ORDER BY branch_name
```

<Grid cols=2>

<div>

### Revenue Bulanan 

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

</div>

<div>

### Perbandingan Minggu Ini vs Minggu Lalu

<DataTable data={branch_wow}>
    <Column id="branch_name"         title="Cabang"/>
    <Column id="revenue_minggu_ini"  title="Minggu Ini (Rp)"  fmt="#,##0"/>
    <Column id="revenue_minggu_lalu" title="Minggu Lalu (Rp)" fmt="#,##0"/>
    <Column id="pct_change"          title="Perubahan (%)"    fmt="+0.0;-0.0" contentType="delta"/>
</DataTable>

</div>

</Grid>

_Cabang dengan bar tertinggi secara konsisten adalah pemain utama bisnis kamu — pertahankan performa mereka dan jadikan benchmark untuk cabang lainnya. Perbandingan WoW memperlihatkan momentum terkini tiap cabang._

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

<Grid cols=2>

<div>

### Revenue Harian

<LineChart
    data={branch_daily_90}
    x="order_date"
    y="total_revenue"
    series="branch_name"
    title="Revenue Harian per Cabang (Rp)"
    yFmt="#,##0"
    xAxisTitle="Tanggal"
    yAxisTitle="Revenue (Rp)"
/>

</div>

<div>

### Rata-rata 7 Hari (Tren Halus)

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

</div>

</Grid>

_Chart kiri menunjukkan revenue aktual harian — naik turun mengikuti pola weekday vs weekend. Chart kanan menghaluskan fluktuasi tersebut sehingga arah tren tiap cabang terlihat lebih jelas. Garis yang menurun konsisten di chart kanan perlu perhatian lebih._

---

## Ringkasan Keseluruhan
```sql branch_summary
SELECT
    branch_name,
    SUM(total_revenue)                                          AS total_revenue,
    SUM(total_orders)                                           AS total_orders,
    ROUND(SUM(total_revenue) / NULLIF(SUM(total_orders), 0), 0) AS avg_order_value,
    MIN(order_date)                                             AS first_date,
    MAX(order_date)                                             AS last_date
FROM restaurant.daily_revenue
GROUP BY branch_name
ORDER BY total_revenue DESC
```

<DataTable data={branch_summary}>
    <Column id="branch_name"     title="Cabang"/>
    <Column id="total_revenue"   title="Total Revenue (Rp)"        fmt="#,##0"/>
    <Column id="total_orders"    title="Total Pesanan"              fmt="#,##0"/>
    <Column id="avg_order_value" title="Rata-rata Nilai Order (Rp)" fmt="#,##0"/>
    <Column id="first_date"      title="Mulai Beroperasi"/>
    <Column id="last_date"       title="Data Terakhir"/>
</DataTable>

_Rata-rata nilai order yang rendah di suatu cabang bisa jadi peluang untuk mendorong upselling atau bundling menu. Bandingkan antar cabang untuk menemukan best practice yang bisa diterapkan di cabang lain._

---

## Cabang dengan Penurunan Signifikan (30 Hari Terakhir)
```sql declining_branches
WITH max_date AS (
    SELECT MAX(order_date) AS max_d
    FROM restaurant.daily_revenue
),

branch_revenue AS (
    SELECT
        branch_name,
        SUM(CASE
            WHEN order_date >= (max_d - INTERVAL '29 days')
             AND order_date <  (max_d - INTERVAL '14 days')
            THEN total_revenue ELSE 0 END) AS revenue_periode_lalu,
        SUM(CASE
            WHEN order_date >= (max_d - INTERVAL '14 days')
             AND order_date <= max_d
            THEN total_revenue ELSE 0 END) AS revenue_periode_ini
    FROM restaurant.daily_revenue
    CROSS JOIN max_date
    WHERE order_date >= (max_d - INTERVAL '29 days')
    GROUP BY branch_name
)

SELECT
    branch_name,
    revenue_periode_lalu,
    revenue_periode_ini,
    ROUND(
        (revenue_periode_ini - revenue_periode_lalu)
        / NULLIF(revenue_periode_lalu, 0) * 100
    , 1) AS pct_change
FROM branch_revenue
WHERE revenue_periode_ini < revenue_periode_lalu
ORDER BY pct_change ASC
```

<DataTable data={declining_branches}>
    <Column id="branch_name"          title="Cabang"/>
    <Column id="revenue_periode_lalu" title="15 Hari Lalu (Rp)" fmt="#,##0"/>
    <Column id="revenue_periode_ini"  title="15 Hari Ini (Rp)"  fmt="#,##0"/>
    <Column id="pct_change"           title="Perubahan (%)"      fmt="+0.0;-0.0" contentType="delta"/>
</DataTable>

_Cabang di atas mengalami penurunan revenue dalam 15 hari terakhir dibanding 15 hari sebelumnya. Tabel kosong berarti semua cabang sedang tumbuh atau stabil — kondisi ideal. Cabang dengan penurunan terbesar perlu dicek lebih lanjut di chart tren di atas._
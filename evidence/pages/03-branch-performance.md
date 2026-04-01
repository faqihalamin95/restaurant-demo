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
```sql net_summary_month
SELECT
    SUM(net_revenue)                                                  AS net_revenue_month,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS net_margin_avg
FROM restaurant.daily_net_revenue
WHERE DATE_TRUNC('month', metric_date) = DATE_TRUNC('month', (SELECT MAX(metric_date) FROM restaurant.daily_net_revenue))
```

<BigValue data={summary_all}        value="total_revenue_all"  title="Total Revenue Keseluruhan (Rp)" fmt="#,##0" />
<BigValue data={summary_all}        value="total_cabang"       title="Total Cabang Aktif" />
<BigValue data={best_branch_month}  value="branch_name"        title="Cabang Terbaik Bulan Ini" />
<BigValue data={best_branch_month}  value="total_revenue"      title="Revenue Cabang Terbaik (Rp)"   fmt="#,##0" />
<BigValue data={net_summary_month}  value="net_revenue_month"  title="Net Revenue Bulan Ini (Rp)"    fmt="#,##0" />
<BigValue data={net_summary_month}  value="net_margin_avg"     title="Net Margin Rata-rata (%)"       fmt="0.0\%" />

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

## Profitabilitas per Cabang (30 Hari Terakhir)
```sql profitability_30d
SELECT
    branch_name,
    SUM(gross_revenue)          AS gross_revenue,
    SUM(net_revenue)            AS net_revenue,
    SUM(inventory_usage_cost)   AS inventory_usage_cost,
    SUM(labor_total_cost)       AS labor_total_cost,
    SUM(operational_total_cost) AS operational_total_cost,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS net_margin_pct
FROM restaurant.daily_net_revenue
WHERE metric_date >= (SELECT MAX(metric_date) FROM restaurant.daily_net_revenue) - INTERVAL '30 days'
GROUP BY branch_name
ORDER BY net_revenue DESC
```

<Grid cols=2>

<div>

### Gross vs Net Revenue per Cabang

<BarChart
    data={profitability_30d}
    x="branch_name"
    y={["gross_revenue", "net_revenue"]}
    type="grouped"
    title="Gross vs Net Revenue — 30 Hari (Rp)"
    yFmt="#,##0"
    xAxisTitle="Cabang"
    yAxisTitle="Revenue (Rp)"
/>

</div>

<div>

### Breakdown Biaya per Cabang

<BarChart
    data={profitability_30d}
    x="branch_name"
    y={["inventory_usage_cost", "labor_total_cost", "operational_total_cost"]}
    type="stacked"
    title="Struktur Biaya per Cabang — 30 Hari (Rp)"
    yFmt="#,##0"
    xAxisTitle="Cabang"
    yAxisTitle="Total Biaya (Rp)"
/>

</div>

</Grid>

<DataTable data={profitability_30d}>
    <Column id="branch_name"            title="Cabang"/>
    <Column id="gross_revenue"          title="Gross Revenue (Rp)"      fmt="#,##0"/>
    <Column id="inventory_usage_cost"   title="Biaya Bahan (Rp)"        fmt="#,##0"/>
    <Column id="labor_total_cost"       title="Biaya SDM (Rp)"          fmt="#,##0"/>
    <Column id="operational_total_cost" title="Biaya Operasional (Rp)"  fmt="#,##0"/>
    <Column id="net_revenue"            title="Net Revenue (Rp)"        fmt="#,##0"/>
    <Column id="net_margin_pct"         title="Margin (%)"              fmt="0.0\%"/>
</DataTable>

_Gap besar antara gross dan net revenue menunjukkan struktur biaya yang perlu dioptimalkan. Cabang dengan margin rendah meski omset tinggi adalah prioritas review biaya — terutama komponen mana yang paling membebani._

---

## Ringkasan Keseluruhan
```sql branch_summary
SELECT
    dr.branch_name,
    SUM(dr.total_revenue)                                               AS total_revenue,
    SUM(dr.total_orders)                                                AS total_orders,
    ROUND(SUM(dr.total_revenue) / NULLIF(SUM(dr.total_orders), 0), 0)  AS avg_order_value,
    SUM(nr.net_revenue)                                                 AS net_revenue,
    ROUND(SUM(nr.net_revenue) / NULLIF(SUM(nr.gross_revenue), 0) * 100, 1) AS net_margin_pct,
    MIN(dr.order_date)                                                  AS first_date,
    MAX(dr.order_date)                                                  AS last_date
FROM restaurant.daily_revenue dr
LEFT JOIN restaurant.daily_net_revenue nr
    ON dr.order_date = nr.metric_date
    AND dr.branch_id = nr.branch_id
GROUP BY dr.branch_name
ORDER BY total_revenue DESC
```

<DataTable data={branch_summary}>
    <Column id="branch_name"     title="Cabang"/>
    <Column id="total_revenue"   title="Gross Revenue (Rp)"       fmt="#,##0"/>
    <Column id="total_orders"    title="Total Pesanan"             fmt="#,##0"/>
    <Column id="avg_order_value" title="Rata-rata Nilai Order (Rp)" fmt="#,##0"/>
    <Column id="net_revenue"     title="Net Revenue (Rp)"          fmt="#,##0"/>
    <Column id="net_margin_pct"  title="Margin (%)"                fmt="0.0\%"/>
    <Column id="first_date"      title="Mulai Beroperasi"/>
    <Column id="last_date"       title="Data Terakhir"/>
</DataTable>

_Rata-rata nilai order yang rendah di suatu cabang bisa jadi peluang untuk mendorong upselling atau bundling menu. Bandingkan net margin antar cabang untuk menemukan cabang mana yang paling efisien secara biaya._

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
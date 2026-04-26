---
title: Performa Cabang
---

_Analisis revenue dan tren performa per cabang restoran._
```sql periode_30d
SELECT
    strftime(MAX(order_date) - INTERVAL '29 days', '%d %b %Y') AS tgl_awal,
    strftime(MAX(order_date), '%d %b %Y')                       AS tgl_akhir,
    MAX(order_date) AS max_date
FROM restaurant.daily_revenue
```
```sql tgl_bulan
SELECT
    CASE MONTH((SELECT MAX(order_date) FROM restaurant.daily_revenue))
        WHEN 1 THEN 'Januari' WHEN 2 THEN 'Februari' WHEN 3 THEN 'Maret'
        WHEN 4 THEN 'April' WHEN 5 THEN 'Mei' WHEN 6 THEN 'Juni'
        WHEN 7 THEN 'Juli' WHEN 8 THEN 'Agustus' WHEN 9 THEN 'September'
        WHEN 10 THEN 'Oktober' WHEN 11 THEN 'November' WHEN 12 THEN 'Desember'
    END || ' ' ||
    YEAR((SELECT MAX(order_date) FROM restaurant.daily_revenue)) AS bulan_display
FROM (SELECT 1) t
```
```sql branch_daily_30
SELECT
    order_date,
    branch_name,
    total_revenue,
    ROUND(revenue_sdow_avg, 0) AS revenue_sdow_avg
FROM restaurant.daily_revenue
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.daily_revenue) - INTERVAL '29 days'
ORDER BY order_date, branch_name
```
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
WHERE metric_date >= (SELECT MAX(metric_date) FROM restaurant.daily_net_revenue) - INTERVAL '29 days'
GROUP BY branch_name
ORDER BY net_revenue DESC
```

---

## Performa 30 Hari Terakhir

<span style="font-size:0.85em;color:var(--color-text-secondary)">{periode_30d[0].tgl_awal} – {periode_30d[0].tgl_akhir}</span>

_Ringkasan kumulatif semua cabang dalam 30 hari terakhir — patokan kondisi operasional terkini sebelum melihat tren._
```sql kpi_30d
SELECT
    SUM(total_revenue)                                                AS total_revenue,
    SUM(total_orders)                                                 AS total_orders,
    ROUND(SUM(total_revenue) / NULLIF(SUM(total_orders), 0), 0)      AS avg_order_value,
    COUNT(DISTINCT branch_id)                                         AS total_cabang
FROM restaurant.daily_revenue
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.daily_revenue) - INTERVAL '29 days'
```
```sql net_30d
SELECT
    SUM(net_revenue)                                                  AS net_revenue,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS net_margin_pct
FROM restaurant.daily_net_revenue
WHERE metric_date >= (SELECT MAX(metric_date) FROM restaurant.daily_net_revenue) - INTERVAL '29 days'
```
```sql branch_30d
SELECT
    dr.branch_name,
    SUM(dr.total_revenue)                                              AS total_revenue,
    SUM(dr.total_orders)                                               AS total_orders,
    ROUND(SUM(dr.total_revenue) / NULLIF(SUM(dr.total_orders), 0), 0) AS avg_order_value,
    ROUND(AVG(dr.pct_change_vs_sdow_avg), 3)                          AS avg_pct_change_vs_sdow,
    SUM(nr.net_revenue)                                                AS net_revenue,
    ROUND(SUM(nr.net_revenue) / NULLIF(SUM(nr.gross_revenue), 0) * 100, 1) AS net_margin_pct
FROM restaurant.daily_revenue dr
LEFT JOIN restaurant.daily_net_revenue nr
    ON dr.order_date = nr.metric_date AND dr.branch_id = nr.branch_id
WHERE dr.order_date >= (SELECT MAX(order_date) FROM restaurant.daily_revenue) - INTERVAL '29 days'
GROUP BY dr.branch_name
ORDER BY total_revenue DESC
```
```sql branch_alert_30d
SELECT
    branch_name,
    ROUND(AVG(pct_change_vs_sdow_avg) * 100, 1) AS avg_pct_change
FROM restaurant.daily_revenue
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.daily_revenue) - INTERVAL '29 days'
GROUP BY branch_name
HAVING AVG(pct_change_vs_sdow_avg) < -0.15
ORDER BY avg_pct_change ASC
```

<BigValue data={kpi_30d}   value="total_revenue"   title="Gross Revenue (Rp) — 30 Hari"        fmt="#,##0" />
<BigValue data={kpi_30d}   value="total_orders"    title="Total Order — 30 Hari"                fmt="#,##0" />
<BigValue data={kpi_30d}   value="avg_order_value" title="Rata-rata Nilai Order (Rp)"           fmt="#,##0" />
<BigValue data={net_30d}   value="net_revenue"     title="Net Revenue (Rp) — 30 Hari"          fmt="#,##0" />
<BigValue data={net_30d}   value="net_margin_pct"  title="Net Margin (%) — 30 Hari"            fmt="0.0\%" />

{#if branch_alert_30d.length > 0}
<div style="display:flex;flex-direction:column;gap:8px;margin:16px 0;">
{#each branch_alert_30d as row}
<div style="background:#fff3f3;border-left:4px solid #dc2626;padding:12px 16px;border-radius:6px;">
🚨 <strong>{row.branch_name}</strong> — Rata-rata revenue turun <strong>{row.avg_pct_change}%</strong> vs rata-rata hari serupa dalam 30 hari terakhir.
</div>
{/each}
</div>
{:else}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:12px 16px;border-radius:6px;margin:16px 0;">
✅ <strong>Semua cabang normal.</strong> Tidak ada penurunan signifikan vs hari serupa dalam 30 hari terakhir.
</div>
{/if}

<DataTable data={branch_30d}>
    <Column id="branch_name"           title="Cabang"/>
    <Column id="total_revenue"         title="Gross Revenue (Rp)"        fmt="#,##0"/>
    <Column id="total_orders"          title="Order"                     fmt="#,##0"/>
    <Column id="avg_order_value"       title="Rata-rata Nilai Order (Rp)" fmt="#,##0"/>
    <Column id="avg_pct_change_vs_sdow" title="Rata-rata vs Hari Serupa" fmt="+0.0%;-0.0%;0.0%" contentType="delta"/>
    <Column id="net_revenue"           title="Net Revenue (Rp)"          fmt="#,##0"/>
    <Column id="net_margin_pct"        title="Net Margin (%)"            fmt="0.0\%"/>
</DataTable>

---

## Tren 30 Hari Terakhir

<span style="font-size:0.85em;color:var(--color-text-secondary)">{periode_30d[0].tgl_awal} – {periode_30d[0].tgl_akhir} · Patokan: kondisi operasional rolling sebulan terakhir</span>

<Grid cols=2>
<div>

### Revenue Harian per Cabang

<LineChart
    data={branch_daily_30}
    x="order_date"
    y="total_revenue"
    series="branch_name"
    title="Gross Revenue Harian (Rp)"
    yFmt="#,##0"
    xAxisTitle="Tanggal"
    yAxisTitle="Revenue (Rp)"
/>

</div>
<div>

### Rata-rata Hari Serupa (Tren Halus)

<LineChart
    data={branch_daily_30}
    x="order_date"
    y="revenue_sdow_avg"
    series="branch_name"
    title="Rata-rata Hari Serupa (Rp)"
    yFmt="#,##0"
    xAxisTitle="Tanggal"
    yAxisTitle="Revenue SDOW Avg (Rp)"
/>

</div>
</Grid>

_Chart kiri: revenue aktual harian. Chart kanan: dihaluskan dengan rata-rata hari serupa — Senin dibanding Senin — sehingga arah tren tiap cabang terlihat tanpa bias weekday vs weekend._

<Grid cols=2>
<div>

### Gross vs Net Revenue

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

### Struktur Biaya

<BarChart
    data={profitability_30d}
    x="branch_name"
    y={["inventory_usage_cost", "labor_total_cost", "operational_total_cost"]}
    type="stacked"
    title="Breakdown Biaya per Cabang — 30 Hari (Rp)"
    yFmt="#,##0"
    xAxisTitle="Cabang"
    yAxisTitle="Total Biaya (Rp)"
/>

</div>
</Grid>

<DataTable data={profitability_30d}>
    <Column id="branch_name"            title="Cabang"/>
    <Column id="gross_revenue"          title="Gross Revenue (Rp)"     fmt="#,##0"/>
    <Column id="inventory_usage_cost"   title="Biaya Bahan (Rp)"       fmt="#,##0"/>
    <Column id="labor_total_cost"       title="Biaya SDM (Rp)"         fmt="#,##0"/>
    <Column id="operational_total_cost" title="Biaya Operasional (Rp)" fmt="#,##0"/>
    <Column id="net_revenue"            title="Net Revenue (Rp)"       fmt="#,##0"/>
    <Column id="net_margin_pct"         title="Margin (%)"             fmt="0.0\%"/>
</DataTable>

---

## Yang Perlu Diperhatikan — 30 Hari Terakhir

_Dua jenis sinyal berbeda: cabang yang omsetnya melambat vs cabang yang sudah merugi._
```sql declining_gross
WITH max_date AS (
    SELECT MAX(order_date) AS max_d FROM restaurant.daily_revenue
),
branch_revenue AS (
    SELECT
        branch_name,
        SUM(CASE
            WHEN order_date >= (max_d - INTERVAL '29 days')
             AND order_date <  (max_d - INTERVAL '14 days')
            THEN total_revenue ELSE 0 END) AS revenue_15d_lalu,
        SUM(CASE
            WHEN order_date >= (max_d - INTERVAL '14 days')
             AND order_date <= max_d
            THEN total_revenue ELSE 0 END) AS revenue_15d_ini
    FROM restaurant.daily_revenue
    CROSS JOIN max_date
    WHERE order_date >= (max_d - INTERVAL '29 days')
    GROUP BY branch_name
)
SELECT
    branch_name,
    revenue_15d_lalu,
    revenue_15d_ini,
    ROUND((revenue_15d_ini - revenue_15d_lalu) / NULLIF(revenue_15d_lalu, 0) * 100, 1) AS pct_change
FROM branch_revenue
WHERE revenue_15d_ini < revenue_15d_lalu
ORDER BY pct_change ASC
```
```sql negative_net
SELECT
    branch_name,
    SUM(net_revenue)   AS net_revenue_30d,
    SUM(gross_revenue) AS gross_revenue_30d,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS net_margin_pct,
    COUNT(CASE WHEN net_revenue < 0 THEN 1 END) AS hari_merugi
FROM restaurant.daily_net_revenue
WHERE metric_date >= (SELECT MAX(metric_date) FROM restaurant.daily_net_revenue) - INTERVAL '29 days'
GROUP BY branch_name
HAVING SUM(net_revenue) < 0 OR COUNT(CASE WHEN net_revenue < 0 THEN 1 END) >= 7
ORDER BY net_revenue_30d ASC
```

### Gross Revenue Melambat

_Patokan: perbandingan 15 hari pertama vs 15 hari terakhir dalam periode ini. Sinyal awal bahwa omset mulai melemah — belum tentu merugi, tapi perlu dicermati sebelum berlanjut._

{#if declining_gross.length > 0}
<DataTable data={declining_gross}>
    <Column id="branch_name"      title="Cabang"/>
    <Column id="revenue_15d_lalu" title="15 Hari Pertama (Rp)" fmt="#,##0"/>
    <Column id="revenue_15d_ini"  title="15 Hari Terakhir (Rp)" fmt="#,##0"/>
    <Column id="pct_change"       title="Perubahan (%)" fmt="+0.0;-0.0" contentType="delta"/>
</DataTable>
{:else}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:12px 16px;border-radius:6px;">
✅ Semua cabang stabil atau tumbuh — tidak ada perlambatan omset signifikan.
</div>
{/if}

### Net Revenue Negatif

_Patokan: total net revenue 30 hari terakhir setelah dikurangi biaya bahan, SDM, dan operasional. Cabang di sini sudah merugi secara aktual — bukan hanya melambat. Perlu tindakan segera._

{#if negative_net.length > 0}
<DataTable data={negative_net}>
    <Column id="branch_name"      title="Cabang"/>
    <Column id="gross_revenue_30d" title="Gross Revenue (Rp)"  fmt="#,##0"/>
    <Column id="net_revenue_30d"   title="Net Revenue (Rp)"    fmt="#,##0"/>
    <Column id="net_margin_pct"    title="Margin (%)"          fmt="0.0\%"/>
    <Column id="hari_merugi"       title="Hari Merugi (dari 30)" fmt="#,##0"/>
</DataTable>
{:else}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:12px 16px;border-radius:6px;">
✅ Semua cabang menghasilkan net revenue positif dalam 30 hari terakhir.
</div>
{/if}

---

## Tren Bulanan

_Patokan: pola pertumbuhan jangka menengah per cabang._
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
    , 1) AS pct_change
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

### Minggu Ini vs Minggu Lalu

<DataTable data={branch_wow}>
    <Column id="branch_name"         title="Cabang"/>
    <Column id="revenue_minggu_ini"  title="Minggu Ini (Rp)"  fmt="#,##0"/>
    <Column id="revenue_minggu_lalu" title="Minggu Lalu (Rp)" fmt="#,##0"/>
    <Column id="pct_change"          title="Perubahan (%)"    fmt="+0.0;-0.0" contentType="delta"/>
</DataTable>

</div>
</Grid>

---

## Ringkasan Sejak Awal Beroperasi

_Patokan: performa kumulatif jangka panjang per cabang sejak pertama kali beroperasi._
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
    ON dr.order_date = nr.metric_date AND dr.branch_id = nr.branch_id
GROUP BY dr.branch_name
ORDER BY total_revenue DESC
```

<DataTable data={branch_summary}>
    <Column id="branch_name"     title="Cabang"/>
    <Column id="total_revenue"   title="Gross Revenue (Rp)"        fmt="#,##0"/>
    <Column id="total_orders"    title="Total Order"                fmt="#,##0"/>
    <Column id="avg_order_value" title="Rata-rata Nilai Order (Rp)" fmt="#,##0"/>
    <Column id="net_revenue"     title="Net Revenue (Rp)"           fmt="#,##0"/>
    <Column id="net_margin_pct"  title="Margin (%)"                 fmt="0.0\%"/>
    <Column id="first_date"      title="Mulai Beroperasi"/>
    <Column id="last_date"       title="Data Terakhir"/>
</DataTable>
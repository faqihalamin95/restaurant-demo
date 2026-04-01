---
title: Financial Health
---

_Analisis profitabilitas, struktur biaya, dan kesehatan finansial bisnis secara keseluruhan._

```sql header_kpi
SELECT
    SUM(gross_revenue)                                                    AS gross_revenue,
    SUM(inventory_usage_cost + labor_total_cost + operational_total_cost) AS total_biaya,
    SUM(net_revenue)                                                       AS net_revenue,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1)      AS net_margin_pct
FROM restaurant.daily_net_revenue
WHERE metric_date >= (SELECT MAX(metric_date) FROM restaurant.daily_net_revenue) - INTERVAL '30 days'
```

<BigValue data={header_kpi} value="gross_revenue"   title="Gross Revenue (Rp) — 30 Hari"  fmt="#,##0" />
<BigValue data={header_kpi} value="total_biaya"     title="Total Biaya (Rp) — 30 Hari"    fmt="#,##0" />
<BigValue data={header_kpi} value="net_revenue"     title="Net Revenue (Rp) — 30 Hari"    fmt="#,##0" />
<BigValue data={header_kpi} value="net_margin_pct"  title="Net Margin (%) — 30 Hari"      fmt="0.0\%" />

---

## Tren Net Revenue per Cabang (90 Hari Terakhir)

```sql net_trend_90d
SELECT
    metric_date,
    branch_name,
    net_revenue,
    ROUND(AVG(net_revenue) OVER (
        PARTITION BY branch_name
        ORDER BY metric_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ), 0) AS net_revenue_7d_avg
FROM restaurant.daily_net_revenue
WHERE metric_date >= (SELECT MAX(metric_date) FROM restaurant.daily_net_revenue) - INTERVAL '90 days'
ORDER BY metric_date, branch_name
```

<Grid cols=2>

<div>

### Net Revenue Harian

<LineChart
    data={net_trend_90d}
    x="metric_date"
    y="net_revenue"
    series="branch_name"
    title="Net Revenue Harian per Cabang (Rp)"
    yFmt="#,##0"
    xAxisTitle="Tanggal"
    yAxisTitle="Net Revenue (Rp)"
/>

</div>

<div>

### Rata-rata 7 Hari (Tren Halus)

<LineChart
    data={net_trend_90d}
    x="metric_date"
    y="net_revenue_7d_avg"
    series="branch_name"
    title="Net Revenue 7-Day Avg per Cabang (Rp)"
    yFmt="#,##0"
    xAxisTitle="Tanggal"
    yAxisTitle="Net Revenue 7-Day Avg (Rp)"
/>

</div>

</Grid>

_Chart kanan menghaluskan fluktuasi harian sehingga arah tren profitabilitas tiap cabang terlihat lebih jelas. Garis yang konsisten di bawah nol perlu perhatian segera — cabang tersebut membakar uang setiap hari._

---

## Struktur Biaya (30 Hari Terakhir)

```sql cost_structure_30d
SELECT
    branch_name,
    SUM(gross_revenue)          AS gross_revenue,
    SUM(inventory_usage_cost)   AS biaya_bahan,
    SUM(labor_total_cost)       AS biaya_sdm,
    SUM(operational_total_cost) AS biaya_operasional,
    SUM(net_revenue)            AS net_revenue,
    ROUND(SUM(inventory_usage_cost)   / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS pct_bahan,
    ROUND(SUM(labor_total_cost)       / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS pct_sdm,
    ROUND(SUM(operational_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS pct_operasional,
    ROUND(SUM(net_revenue)            / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS net_margin_pct
FROM restaurant.daily_net_revenue
WHERE metric_date >= (SELECT MAX(metric_date) FROM restaurant.daily_net_revenue) - INTERVAL '30 days'
GROUP BY branch_name
ORDER BY net_revenue DESC
```

```sql cost_proportion_all
SELECT
    'Biaya Bahan'       AS komponen,
    SUM(inventory_usage_cost)   AS total
FROM restaurant.daily_net_revenue
WHERE metric_date >= (SELECT MAX(metric_date) FROM restaurant.daily_net_revenue) - INTERVAL '30 days'
UNION ALL
SELECT
    'Biaya SDM'         AS komponen,
    SUM(labor_total_cost)       AS total
FROM restaurant.daily_net_revenue
WHERE metric_date >= (SELECT MAX(metric_date) FROM restaurant.daily_net_revenue) - INTERVAL '30 days'
UNION ALL
SELECT
    'Biaya Operasional' AS komponen,
    SUM(operational_total_cost) AS total
FROM restaurant.daily_net_revenue
WHERE metric_date >= (SELECT MAX(metric_date) FROM restaurant.daily_net_revenue) - INTERVAL '30 days'
```

<Grid cols=2>

<div>

### Komposisi Biaya per Cabang

<BarChart
    data={cost_structure_30d}
    x="branch_name"
    y={["biaya_bahan", "biaya_sdm", "biaya_operasional"]}
    type="stacked"
    title="Struktur Biaya per Cabang — 30 Hari (Rp)"
    yFmt="#,##0"
    xAxisTitle="Cabang"
    yAxisTitle="Total Biaya (Rp)"
/>

</div>

<div>

### Proporsi Biaya Keseluruhan

<BarChart
    data={cost_proportion_all}
    x="komponen"
    y="total"
    title="Total Biaya per Komponen — 30 Hari (Rp)"
    yFmt="#,##0"
    xAxisTitle="Komponen"
    yAxisTitle="Total (Rp)"
    colorPalette={['#e07b39', '#4f86c6', '#a0c878']}
/>

</div>

</Grid>

<DataTable data={cost_structure_30d}>
    <Column id="branch_name"       title="Cabang"/>
    <Column id="gross_revenue"     title="Gross Revenue (Rp)"     fmt="#,##0"/>
    <Column id="biaya_bahan"       title="Biaya Bahan (Rp)"       fmt="#,##0"/>
    <Column id="pct_bahan"         title="% Bahan"                fmt="0.0\%"/>
    <Column id="biaya_sdm"         title="Biaya SDM (Rp)"         fmt="#,##0"/>
    <Column id="pct_sdm"           title="% SDM"                  fmt="0.0\%"/>
    <Column id="biaya_operasional" title="Biaya Operasional (Rp)" fmt="#,##0"/>
    <Column id="pct_operasional"   title="% Operasional"          fmt="0.0\%"/>
    <Column id="net_revenue"       title="Net Revenue (Rp)"       fmt="#,##0"/>
    <Column id="net_margin_pct"    title="Margin (%)"             fmt="0.0\%"/>
</DataTable>

_Persentase biaya terhadap gross revenue adalah metrik kunci — standar industri restoran: biaya bahan ~28–32%, SDM ~18–22%, operasional ~12–15%. Komponen mana yang melampaui batas ini adalah titik mulai optimasi._

---

## Gross vs Net Revenue per Bulan

```sql monthly_gross_net
SELECT
    DATE_TRUNC('month', metric_date) AS bulan,
    branch_name,
    SUM(gross_revenue) AS gross_revenue,
    SUM(net_revenue)   AS net_revenue,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS net_margin_pct
FROM restaurant.daily_net_revenue
GROUP BY 1, 2
ORDER BY 1, 2
```

```sql monthly_margin_trend
SELECT
    DATE_TRUNC('month', metric_date) AS bulan,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS net_margin_pct
FROM restaurant.daily_net_revenue
GROUP BY 1
ORDER BY 1
```

<Grid cols=2>

<div>

### Gross vs Net per Bulan — Semua Cabang

<BarChart
    data={monthly_gross_net}
    x="bulan"
    y={["gross_revenue", "net_revenue"]}
    series="branch_name"
    type="grouped"
    title="Gross vs Net Revenue Bulanan (Rp)"
    yFmt="#,##0"
    xAxisTitle="Bulan"
    yAxisTitle="Revenue (Rp)"
/>

</div>

<div>

### Tren Net Margin Bulanan

<LineChart
    data={monthly_margin_trend}
    x="bulan"
    y="net_margin_pct"
    title="Net Margin % — Tren Bulanan"
    yFmt="0.0\%"
    xAxisTitle="Bulan"
    yAxisTitle="Net Margin (%)"
/>

</div>

</Grid>

_Tren margin bulanan adalah sinyal paling penting — margin yang terus mengecil meski revenue tumbuh berarti biaya tumbuh lebih cepat dari omset. Tangani sebelum menjadi masalah struktural._

---

## Detail Harian (30 Hari Terakhir)

```sql daily_detail_30d
SELECT
    metric_date,
    branch_name,
    gross_revenue,
    inventory_usage_cost,
    labor_total_cost,
    operational_total_cost,
    net_revenue,
    ROUND(net_revenue / NULLIF(gross_revenue, 0) * 100, 1) AS net_margin_pct
FROM restaurant.daily_net_revenue
WHERE metric_date >= (SELECT MAX(metric_date) FROM restaurant.daily_net_revenue) - INTERVAL '30 days'
ORDER BY metric_date DESC, branch_name
```

<DataTable data={daily_detail_30d} rows=15>
    <Column id="metric_date"           title="Tanggal"/>
    <Column id="branch_name"           title="Cabang"/>
    <Column id="gross_revenue"         title="Gross Revenue (Rp)"      fmt="#,##0"/>
    <Column id="inventory_usage_cost"  title="Biaya Bahan (Rp)"        fmt="#,##0"/>
    <Column id="labor_total_cost"      title="Biaya SDM (Rp)"          fmt="#,##0"/>
    <Column id="operational_total_cost" title="Biaya Operasional (Rp)" fmt="#,##0"/>
    <Column id="net_revenue"           title="Net Revenue (Rp)"        fmt="#,##0"/>
    <Column id="net_margin_pct"        title="Margin (%)"              fmt="0.0\%"/>
</DataTable>

_Tabel ini memperlihatkan kondisi finansial harian per cabang. Baris dengan margin negatif adalah hari di mana biaya melebihi revenue — wajar sesekali, tapi kalau terjadi berulang di cabang yang sama perlu investigasi lebih lanjut._
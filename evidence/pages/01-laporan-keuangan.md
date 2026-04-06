---
title: Laporan Keuangan
---

_Kesehatan finansial bisnis — profitabilitas, struktur biaya, dan tren margin._

```sql header_kpi
SELECT
    SUM(gross_revenue)                                                    AS gross_revenue,
    SUM(inventory_usage_cost + labor_total_cost + operational_total_cost) AS total_biaya,
    SUM(net_revenue)                                                       AS net_revenue,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1)      AS net_margin_pct
FROM restaurant.daily_net_revenue
WHERE metric_date >= (SELECT MAX(metric_date) FROM restaurant.daily_net_revenue) - INTERVAL '30 days'
```

```sql margin_vs_bulan_lalu
SELECT
    ROUND(SUM(CASE WHEN metric_date >= (SELECT MAX(metric_date) FROM restaurant.daily_net_revenue) - INTERVAL '30 days'
        THEN net_revenue END) /
    NULLIF(SUM(CASE WHEN metric_date >= (SELECT MAX(metric_date) FROM restaurant.daily_net_revenue) - INTERVAL '30 days'
        THEN gross_revenue END), 0) * 100, 1) AS margin_30d,
    ROUND(SUM(CASE WHEN metric_date >= (SELECT MAX(metric_date) FROM restaurant.daily_net_revenue) - INTERVAL '60 days'
               AND metric_date <  (SELECT MAX(metric_date) FROM restaurant.daily_net_revenue) - INTERVAL '30 days'
        THEN net_revenue END) /
    NULLIF(SUM(CASE WHEN metric_date >= (SELECT MAX(metric_date) FROM restaurant.daily_net_revenue) - INTERVAL '60 days'
               AND metric_date <  (SELECT MAX(metric_date) FROM restaurant.daily_net_revenue) - INTERVAL '30 days'
        THEN gross_revenue END), 0) * 100, 1) AS margin_30d_lalu,
    ROUND(
        ROUND(SUM(CASE WHEN metric_date >= (SELECT MAX(metric_date) FROM restaurant.daily_net_revenue) - INTERVAL '30 days'
            THEN net_revenue END) /
        NULLIF(SUM(CASE WHEN metric_date >= (SELECT MAX(metric_date) FROM restaurant.daily_net_revenue) - INTERVAL '30 days'
            THEN gross_revenue END), 0) * 100, 1)
        -
        ROUND(SUM(CASE WHEN metric_date >= (SELECT MAX(metric_date) FROM restaurant.daily_net_revenue) - INTERVAL '60 days'
               AND metric_date <  (SELECT MAX(metric_date) FROM restaurant.daily_net_revenue) - INTERVAL '30 days'
            THEN net_revenue END) /
        NULLIF(SUM(CASE WHEN metric_date >= (SELECT MAX(metric_date) FROM restaurant.daily_net_revenue) - INTERVAL '60 days'
               AND metric_date <  (SELECT MAX(metric_date) FROM restaurant.daily_net_revenue) - INTERVAL '30 days'
            THEN gross_revenue END), 0) * 100, 1)
    , 1) AS selisih_margin
FROM restaurant.daily_net_revenue
```

```sql cabang_margin_alert
SELECT
    branch_name,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS net_margin_pct
FROM restaurant.daily_net_revenue
WHERE metric_date >= (SELECT MAX(metric_date) FROM restaurant.daily_net_revenue) - INTERVAL '30 days'
GROUP BY branch_name
HAVING net_margin_pct < 10
ORDER BY net_margin_pct ASC
```

---

## Ringkasan 30 Hari Terakhir

<BigValue data={header_kpi} value="gross_revenue"  title="Gross Revenue (Rp)"  fmt="#,##0" />
<BigValue data={header_kpi} value="total_biaya"    title="Total Biaya (Rp)"    fmt="#,##0" />
<BigValue data={header_kpi} value="net_revenue"    title="Net Revenue (Rp)"    fmt="#,##0" />
<BigValue data={header_kpi} value="net_margin_pct" title="Net Margin (%)"      fmt="0.0\%" />

{#if margin_vs_bulan_lalu[0].selisih_margin < -2}
<div style="background: #fff3f3; border-left: 4px solid #dc2626; padding: 12px 16px; border-radius: 6px; margin: 16px 0;">
🔴 <strong>Margin turun {Math.abs(margin_vs_bulan_lalu[0].selisih_margin)} poin</strong> dibanding 30 hari sebelumnya ({margin_vs_bulan_lalu[0].margin_30d_lalu}% → {margin_vs_bulan_lalu[0].margin_30d}%). Biaya tumbuh lebih cepat dari revenue — cek struktur biaya di bawah.
</div>
{:else if margin_vs_bulan_lalu[0].selisih_margin > 2}
<div style="background: #f0fdf4; border-left: 4px solid #16a34a; padding: 12px 16px; border-radius: 6px; margin: 16px 0;">
✅ <strong>Margin naik {margin_vs_bulan_lalu[0].selisih_margin} poin</strong> dibanding 30 hari sebelumnya ({margin_vs_bulan_lalu[0].margin_30d_lalu}% → {margin_vs_bulan_lalu[0].margin_30d}%). Efisiensi biaya membaik.
</div>
{:else}
<div style="background: #f5f5f5; border-left: 4px solid #888; padding: 12px 16px; border-radius: 6px; margin: 16px 0;">
➡️ <strong>Margin stabil</strong> di {margin_vs_bulan_lalu[0].margin_30d}% — selisih hanya {margin_vs_bulan_lalu[0].selisih_margin} poin vs 30 hari sebelumnya.
</div>
{/if}

{#if cabang_margin_alert.length > 0}
<div style="background: #fffbeb; border-left: 4px solid #f8c900; padding: 12px 16px; border-radius: 6px; margin: 8px 0;">
🟡 <strong>Margin di bawah 10%:</strong>
{#each cabang_margin_alert as row}
{row.branch_name} ({row.net_margin_pct}%)&nbsp;
{/each}
— cabang ini perlu review biaya lebih lanjut.
</div>
{/if}

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
SELECT 'Biaya Bahan'       AS komponen, SUM(inventory_usage_cost)   AS total
FROM restaurant.daily_net_revenue
WHERE metric_date >= (SELECT MAX(metric_date) FROM restaurant.daily_net_revenue) - INTERVAL '30 days'
UNION ALL
SELECT 'Biaya SDM'         AS komponen, SUM(labor_total_cost)       AS total
FROM restaurant.daily_net_revenue
WHERE metric_date >= (SELECT MAX(metric_date) FROM restaurant.daily_net_revenue) - INTERVAL '30 days'
UNION ALL
SELECT 'Biaya Operasional' AS komponen, SUM(operational_total_cost) AS total
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

_Standar industri restoran: biaya bahan ~28–32%, SDM ~18–22%, operasional ~12–15%. Komponen yang melampaui batas ini adalah prioritas optimasi._

---

## Tren Bulanan

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

### Gross vs Net Revenue per Bulan

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

_Margin yang terus mengecil meski revenue tumbuh berarti biaya tumbuh lebih cepat dari omset — tangani sebelum menjadi masalah struktural._

---

## Tren Net Revenue Harian (90 Hari Terakhir)

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

_Garis yang konsisten di bawah nol berarti cabang tersebut membakar uang setiap hari — perlu tindakan segera._

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

<Grid cols=2>

<div>

### Cabang Pusat

<DataTable data={daily_detail_30d.filter(d => d.branch_name === 'Cabang Pusat')} rows=10>
    <Column id="metric_date"            title="Tanggal"/>
    <Column id="gross_revenue"          title="Revenue (Rp)"           fmt="#,##0"/>
    <Column id="inventory_usage_cost"   title="Bahan (Rp)"             fmt="#,##0"/>
    <Column id="labor_total_cost"       title="SDM (Rp)"               fmt="#,##0"/>
    <Column id="operational_total_cost" title="Operasional (Rp)"       fmt="#,##0"/>
    <Column id="net_revenue"            title="Net Revenue (Rp)"       fmt="#,##0"/>
    <Column id="net_margin_pct"         title="Margin (%)"             fmt="0.0\%"/>
</DataTable>

</div>

<div>

### Cabang Selatan

<DataTable data={daily_detail_30d.filter(d => d.branch_name === 'Cabang Selatan')} rows=10>
    <Column id="metric_date"            title="Tanggal"/>
    <Column id="gross_revenue"          title="Revenue (Rp)"           fmt="#,##0"/>
    <Column id="inventory_usage_cost"   title="Bahan (Rp)"             fmt="#,##0"/>
    <Column id="labor_total_cost"       title="SDM (Rp)"               fmt="#,##0"/>
    <Column id="operational_total_cost" title="Operasional (Rp)"       fmt="#,##0"/>
    <Column id="net_revenue"            title="Net Revenue (Rp)"       fmt="#,##0"/>
    <Column id="net_margin_pct"         title="Margin (%)"             fmt="0.0\%"/>
</DataTable>

</div>

<div>

### Cabang Utara

<DataTable data={daily_detail_30d.filter(d => d.branch_name === 'Cabang Utara')} rows=10>
    <Column id="metric_date"            title="Tanggal"/>
    <Column id="gross_revenue"          title="Revenue (Rp)"           fmt="#,##0"/>
    <Column id="inventory_usage_cost"   title="Bahan (Rp)"             fmt="#,##0"/>
    <Column id="labor_total_cost"       title="SDM (Rp)"               fmt="#,##0"/>
    <Column id="operational_total_cost" title="Operasional (Rp)"       fmt="#,##0"/>
    <Column id="net_revenue"            title="Net Revenue (Rp)"       fmt="#,##0"/>
    <Column id="net_margin_pct"         title="Margin (%)"             fmt="0.0\%"/>
</DataTable>

</div>

<div>

### Cabang Timur

<DataTable data={daily_detail_30d.filter(d => d.branch_name === 'Cabang Timur')} rows=10>
    <Column id="metric_date"            title="Tanggal"/>
    <Column id="gross_revenue"          title="Revenue (Rp)"           fmt="#,##0"/>
    <Column id="inventory_usage_cost"   title="Bahan (Rp)"             fmt="#,##0"/>
    <Column id="labor_total_cost"       title="SDM (Rp)"               fmt="#,##0"/>
    <Column id="operational_total_cost" title="Operasional (Rp)"       fmt="#,##0"/>
    <Column id="net_revenue"            title="Net Revenue (Rp)"       fmt="#,##0"/>
    <Column id="net_margin_pct"         title="Margin (%)"             fmt="0.0\%"/>
</DataTable>

</div>

</Grid>

_Baris dengan margin negatif adalah hari di mana biaya melebihi revenue — wajar sesekali, tapi kalau terjadi berulang di cabang yang sama perlu investigasi lebih lanjut._
---
title: Inventori & Stok Bahan Baku
---

_Pantau penggunaan, pembelian, dan biaya bahan baku per cabang._

> ⚠️ **Catatan:** Dashboard ini menampilkan **arus keluar-masuk bahan baku** berdasarkan transaksi harian, bukan saldo stok fisik. Untuk mengetahui stok aktual di gudang, perlu integrasi dengan sistem kasir atau aplikasi stok.

```sql header_kpi
SELECT
    SUM(usage_cost)                                              AS total_biaya_pemakaian,
    SUM(purchase_cost)                                           AS total_pembelian,
    COUNT(DISTINCT item_name)                                    AS total_item,
    COUNT(DISTINCT branch_name)                                  AS total_cabang
FROM restaurant.inventory_stok
WHERE txn_date >= (SELECT MAX(txn_date) FROM restaurant.inventory_stok) - INTERVAL '30 days'
```

```sql price_alert_count
SELECT COUNT(DISTINCT item_name) AS jumlah_item
FROM (
    SELECT item_name
    FROM restaurant.inventory_stok
    WHERE txn_date >= (SELECT MAX(txn_date) FROM restaurant.inventory_stok) - INTERVAL '30 days'
    GROUP BY item_name
    HAVING (AVG(avg_unit_cost) - AVG(base_unit_cost)) / NULLIF(AVG(base_unit_cost), 0) * 100 > 10
)
```

```sql overstock_alert_count
SELECT COUNT(DISTINCT branch_name) AS jumlah_cabang
FROM (
    SELECT branch_name
    FROM restaurant.inventory_stok
    WHERE txn_date >= (SELECT MAX(txn_date) FROM restaurant.inventory_stok) - INTERVAL '30 days'
    GROUP BY branch_name
    HAVING SUM(purchase_cost) > SUM(usage_cost) * 1.3
)
```

```sql periode_30d
SELECT
    strftime('%d %b %Y', MAX(txn_date) - INTERVAL '29 days') AS tgl_awal,
    strftime('%d %b %Y', MAX(txn_date))                       AS tgl_akhir
FROM restaurant.inventory_stok
```
```sql wow_biaya
SELECT
    SUM(CASE WHEN txn_date >= (SELECT MAX(txn_date) FROM restaurant.inventory_stok) - INTERVAL '6 days'
        THEN usage_cost END)                                        AS biaya_minggu_ini,
    SUM(CASE WHEN txn_date >= (SELECT MAX(txn_date) FROM restaurant.inventory_stok) - INTERVAL '13 days'
         AND txn_date <  (SELECT MAX(txn_date) FROM restaurant.inventory_stok) - INTERVAL '6 days'
        THEN usage_cost END)                                        AS biaya_minggu_lalu,
    ROUND(
        (SUM(CASE WHEN txn_date >= (SELECT MAX(txn_date) FROM restaurant.inventory_stok) - INTERVAL '6 days'
            THEN usage_cost END)
        - SUM(CASE WHEN txn_date >= (SELECT MAX(txn_date) FROM restaurant.inventory_stok) - INTERVAL '13 days'
             AND txn_date <  (SELECT MAX(txn_date) FROM restaurant.inventory_stok) - INTERVAL '6 days'
            THEN usage_cost END))
        / NULLIF(SUM(CASE WHEN txn_date >= (SELECT MAX(txn_date) FROM restaurant.inventory_stok) - INTERVAL '13 days'
             AND txn_date <  (SELECT MAX(txn_date) FROM restaurant.inventory_stok) - INTERVAL '6 days'
            THEN usage_cost END), 0) * 100
    , 1) AS pct_change
FROM restaurant.inventory_stok
```

---

## Ringkasan 30 Hari Terakhir

## Ringkasan 30 Hari Terakhir
<span style="font-size:0.85em;color:var(--color-text-secondary)">{periode_30d[0].tgl_awal} – {periode_30d[0].tgl_akhir}</span>

_Ringkasan kumulatif kondisi stok & inventori dalam 30 hari terakhir — patokan kondisi operasional terkini sebelum melihat tren._

<BigValue data={header_kpi} value="total_biaya_pemakaian" title="Total Biaya Pemakaian (Rp)" fmt="#,##0" />
<BigValue data={header_kpi} value="total_pembelian"       title="Total Pembelian (Rp)"       fmt="#,##0" />
<BigValue data={header_kpi} value="total_item"            title="Total Item Bahan Baku" />
<BigValue data={header_kpi} value="total_cabang"          title="Cabang Terpantau" />

{#if wow_biaya[0].pct_change > 10}
<div style="background: #fff3f3; border-left: 4px solid #dc2626; padding: 12px 16px; border-radius: 6px; margin: 8px 0;">
🔴 <strong>Biaya pemakaian minggu ini naik {wow_biaya[0].pct_change}%</strong> vs minggu lalu (Rp {wow_biaya[0].biaya_minggu_lalu?.toLocaleString()} → Rp {wow_biaya[0].biaya_minggu_ini?.toLocaleString()}). Cek item mana yang mendorong kenaikan di tabel per kategori di bawah.
</div>
{:else if wow_biaya[0].pct_change < -10}
<div style="background: #f0fdf4; border-left: 4px solid #16a34a; padding: 12px 16px; border-radius: 6px; margin: 8px 0;">
✅ <strong>Biaya pemakaian minggu ini turun {Math.abs(wow_biaya[0].pct_change)}%</strong> vs minggu lalu — efisiensi membaik atau volume operasional memang lebih rendah.
</div>
{:else}
<div style="background: #f5f5f5; border-left: 4px solid #888; padding: 12px 16px; border-radius: 6px; margin: 8px 0;">
➡️ <strong>Biaya pemakaian stabil</strong> — selisih hanya {wow_biaya[0].pct_change}% vs minggu lalu.
</div>
{/if}

{#if price_alert_count[0].jumlah_item > 0}
<div style="background: #fff3f3; border-left: 4px solid #dc2626; padding: 12px 16px; border-radius: 6px; margin: 16px 0;">
🔴 <strong>{price_alert_count[0].jumlah_item} bahan baku</strong> dengan harga beli aktual >10% di atas harga dasar. Segera renegosiasi dengan supplier — detail ada di bagian Perbandingan Harga di bawah.
</div>
{:else if overstock_alert_count[0].jumlah_cabang > 0}
<div style="background: #fffbeb; border-left: 4px solid #f8c900; padding: 12px 16px; border-radius: 6px; margin: 16px 0;">
🟡 <strong>{overstock_alert_count[0].jumlah_cabang} cabang</strong> dengan total pembelian melebihi pemakaian >30% — potensi stok menumpuk atau jadwal pembelian yang tidak efisien. Cek grafik Pemakaian vs Pembelian di bawah.
</div>
{:else}
<div style="background: #f0fdf4; border-left: 4px solid #16a34a; padding: 12px 16px; border-radius: 6px; margin: 16px 0;">
✅ <strong>Semua indikator normal.</strong> Tidak ada lonjakan harga beli atau penumpukan stok yang signifikan dalam 30 hari terakhir.
</div>
{/if}

---

```sql category_summary
SELECT
    category,
    COUNT(DISTINCT item_name)                                                       AS total_item,
    SUM(usage_qty)                                                                  AS total_qty_pakai,
    SUM(usage_cost)                                                                 AS total_biaya_pakai,
    SUM(purchase_cost)                                                              AS total_biaya_beli,
    ROUND(SUM(usage_cost) / NULLIF(SUM(SUM(usage_cost)) OVER (), 0) * 100, 1)      AS pct_dari_total,
    ROUND(SUM(purchase_cost) / NULLIF(SUM(usage_cost), 0), 2)                      AS rasio_beli_pakai
FROM restaurant.inventory_stok
WHERE txn_date >= (SELECT MAX(txn_date) FROM restaurant.inventory_stok) - INTERVAL '30 days'
GROUP BY category
ORDER BY total_biaya_pakai DESC
```
```sql category_trend
SELECT
    txn_date,
    category,
    SUM(usage_cost) AS biaya_pakai
FROM restaurant.inventory_stok
WHERE txn_date >= (SELECT MAX(txn_date) FROM restaurant.inventory_stok) - INTERVAL '30 days'
GROUP BY 1, 2
ORDER BY 1, 2
```

## Biaya per Kategori (30 Hari Terakhir)
<span style="font-size:0.85em;color:var(--color-text-secondary)">{periode_30d[0].tgl_awal} – {periode_30d[0].tgl_akhir}</span>

<Grid cols=2>

<div>

### Biaya Pemakaian per Kategori

<BarChart
    data={category_summary}
    x="category"
    y="total_biaya_pakai"
    title="Total Biaya Pemakaian per Kategori (Rp)"
    yFmt="#,##0"
    xAxisTitle="Kategori"
    yAxisTitle="Biaya (Rp)"
/>

</div>

<div>

### Tren Harian per Kategori

<LineChart
    data={category_trend}
    x="txn_date"
    y="biaya_pakai"
    series="category"
    title="Tren Biaya Pemakaian Harian per Kategori (Rp)"
    yFmt="#,##0"
    xAxisTitle="Tanggal"
    yAxisTitle="Biaya (Rp)"
/>

</div>

</Grid>

<DataTable data={category_summary}>
    <Column id="category"          title="Kategori"/>
    <Column id="total_item"        title="Jumlah Item"         fmt="#,##0"/>
    <Column id="total_qty_pakai"   title="Qty Dipakai"         fmt="#,##0"/>
    <Column id="total_biaya_pakai" title="Biaya Pakai (Rp)"    fmt="#,##0"/>
    <Column id="total_biaya_beli"  title="Biaya Beli (Rp)"     fmt="#,##0"/>
    <Column id="pct_dari_total"    title="% dari Total"        fmt="0.0\%"/>
    <Column id="rasio_beli_pakai"  title="Rasio Beli/Pakai"    fmt="0.00"/>
</DataTable>

_**Rasio Beli/Pakai** idealnya mendekati 1.0 — artinya yang dibeli setara dengan yang dipakai. Rasio >1.5 berarti pembelian jauh melebihi pemakaian: stok menumpuk atau jadwal beli tidak efisien. Kategori protein dan produce perlu diperhatikan lebih karena rentan rusak._

---

## Biaya Pemakaian per Item (30 Hari Terakhir)

```sql usage_by_item
SELECT
    item_name,
    category,
    unit,
    SUM(usage_qty)  AS total_qty_pakai,
    SUM(usage_cost) AS total_biaya
FROM restaurant.inventory_stok
WHERE txn_date >= (SELECT MAX(txn_date) FROM restaurant.inventory_stok) - INTERVAL '30 days'
GROUP BY item_name, category, unit
ORDER BY total_biaya DESC
```

<Grid cols=2>

<div>

### Biaya per Item

<BarChart
    data={usage_by_item}
    x="item_name"
    y="total_biaya"
    swapXY=true
    title="Total Biaya Pemakaian per Item (Rp)"
    yFmt="#,##0"
    xAxisTitle="Total Biaya (Rp)"
    colorPalette={['#1D9E75']}
/>

</div>

<div>

### Detail

<DataTable data={usage_by_item}>
    <Column id="item_name"       title="Bahan Baku"/>
    <Column id="category"        title="Kategori"/>
    <Column id="unit"            title="Satuan"/>
    <Column id="total_qty_pakai" title="Qty Dipakai"    fmt="#,##0"/>
    <Column id="total_biaya"     title="Total Biaya (Rp)" fmt="#,##0"/>
</DataTable>

</div>

</Grid>

_Item dengan biaya pemakaian tertinggi adalah prioritas utama untuk negosiasi harga dengan supplier atau efisiensi penggunaan._

---

## Pemakaian vs Pembelian per Cabang (30 Hari Terakhir)

```sql usage_vs_purchase_branch
SELECT
    branch_name,
    SUM(usage_cost)    AS biaya_pemakaian,
    SUM(purchase_cost) AS biaya_pembelian
FROM restaurant.inventory_stok
WHERE txn_date >= (SELECT MAX(txn_date) FROM restaurant.inventory_stok) - INTERVAL '30 days'
GROUP BY branch_name
ORDER BY biaya_pemakaian DESC
```

<BarChart
    data={usage_vs_purchase_branch}
    x="branch_name"
    y={["biaya_pemakaian", "biaya_pembelian"]}
    type="grouped"
    title="Biaya Pemakaian vs Pembelian per Cabang (Rp)"
    yFmt="#,##0"
    xAxisTitle="Cabang"
    yAxisTitle="Biaya (Rp)"
/>

_Selisih besar antara pembelian dan pemakaian di suatu cabang bisa mengindikasikan stok menumpuk atau jadwal pembelian yang tidak efisien._

---

## Tren Biaya Pemakaian Harian (90 Hari Terakhir)

```sql usage_trend_90d
SELECT
    txn_date,
    branch_name,
    SUM(usage_cost) AS biaya_pemakaian
FROM restaurant.inventory_stok
WHERE txn_date >= (SELECT MAX(txn_date) FROM restaurant.inventory_stok) - INTERVAL '90 days'
GROUP BY txn_date, branch_name
ORDER BY txn_date, branch_name
```

<LineChart
    data={usage_trend_90d}
    x="txn_date"
    y="biaya_pemakaian"
    series="branch_name"
    title="Tren Biaya Pemakaian Harian per Cabang (Rp)"
    yFmt="#,##0"
    xAxisTitle="Tanggal"
    yAxisTitle="Biaya Pemakaian (Rp)"
/>

---

## Perbandingan Harga Beli Aktual vs Harga Dasar

```sql price_variance
SELECT
    item_name,
    category,
    ROUND(AVG(base_unit_cost), 0)  AS harga_dasar,
    ROUND(AVG(avg_unit_cost), 0)   AS harga_beli_aktual,
    ROUND(
        (AVG(avg_unit_cost) - AVG(base_unit_cost))
        / NULLIF(AVG(base_unit_cost), 0) * 100
    , 1)                           AS selisih_pct
FROM restaurant.inventory_stok
WHERE txn_date >= (SELECT MAX(txn_date) FROM restaurant.inventory_stok) - INTERVAL '30 days'
GROUP BY item_name, category
ORDER BY selisih_pct DESC
```

{#if price_alert_count[0].jumlah_item > 0}
<div style="background: #fff3f3; border-left: 4px solid #dc2626; padding: 12px 16px; border-radius: 6px; margin: 8px 0;">
🔴 <strong>{price_alert_count[0].jumlah_item} item</strong> dengan harga beli di atas 10% harga dasar — tandai merah di tabel di bawah. Prioritaskan untuk renegosiasi supplier.
</div>
{/if}

<DataTable data={price_variance}>
    <Column id="item_name"         title="Bahan Baku"/>
    <Column id="category"          title="Kategori"/>
    <Column id="harga_dasar"       title="Harga Dasar (Rp)"       fmt="#,##0"/>
    <Column id="harga_beli_aktual" title="Harga Beli Aktual (Rp)" fmt="#,##0"/>
    <Column id="selisih_pct"       title="Selisih (%)"            fmt="+0.0;-0.0" contentType="delta"/>
</DataTable>

_Selisih positif berarti harga beli aktual lebih mahal dari harga dasar — sinyal untuk renegosiasi dengan supplier._

---

## Tren Harga Beli per Item (90 Hari Terakhir)

_Apakah kenaikan harga konsisten setiap minggu atau hanya lonjakan sesekali? Ini penentu apakah perlu renegosiasi segera atau cukup dipantau._
```sql price_trend_weekly
SELECT
    DATE_TRUNC('week', txn_date)                        AS minggu,
    item_name,
    category,
    ROUND(AVG(avg_unit_cost), 0)                        AS avg_harga_beli,
    ROUND(AVG(base_unit_cost), 0)                       AS harga_dasar
FROM restaurant.inventory_stok
WHERE txn_date >= (SELECT MAX(txn_date) FROM restaurant.inventory_stok) - INTERVAL '90 days'
GROUP BY 1, 2, 3
ORDER BY 1, 2
```
```sql price_trend_summary
SELECT
    item_name,
    category,
    ROUND(MIN(avg_unit_cost), 0)                                        AS harga_terendah,
    ROUND(MAX(avg_unit_cost), 0)                                        AS harga_tertinggi,
    ROUND(AVG(avg_unit_cost), 0)                                        AS harga_rata_rata,
    ROUND(AVG(base_unit_cost), 0)                                       AS harga_dasar,
    ROUND((MAX(avg_unit_cost) - MIN(avg_unit_cost))
        / NULLIF(MIN(avg_unit_cost), 0) * 100, 1)                       AS volatilitas_pct,
    ROUND((AVG(avg_unit_cost) - AVG(base_unit_cost))
        / NULLIF(AVG(base_unit_cost), 0) * 100, 1)                      AS selisih_vs_dasar_pct
FROM restaurant.inventory_stok
WHERE txn_date >= (SELECT MAX(txn_date) FROM restaurant.inventory_stok) - INTERVAL '90 days'
GROUP BY 1, 2
ORDER BY volatilitas_pct DESC
```

<LineChart
    data={price_trend_weekly}
    x="minggu"
    y="avg_harga_beli"
    series="item_name"
    title="Tren Harga Beli Mingguan per Item (Rp)"
    yFmt="#,##0"
    xAxisTitle="Minggu"
    yAxisTitle="Harga Beli (Rp)"
/>

<DataTable data={price_trend_summary}>
    <Column id="item_name"              title="Bahan Baku"/>
    <Column id="category"               title="Kategori"/>
    <Column id="harga_dasar"            title="Harga Dasar (Rp)"      fmt="#,##0"/>
    <Column id="harga_rata_rata"        title="Rata-rata Aktual (Rp)" fmt="#,##0"/>
    <Column id="harga_terendah"         title="Terendah (Rp)"         fmt="#,##0"/>
    <Column id="harga_tertinggi"        title="Tertinggi (Rp)"        fmt="#,##0"/>
    <Column id="volatilitas_pct"        title="Volatilitas (%)"       fmt="0.0\%"/>
    <Column id="selisih_vs_dasar_pct"   title="vs Harga Dasar (%)"    fmt="+0.0;-0.0" contentType="delta"/>
</DataTable>

_**Volatilitas** mengukur seberapa jauh harga berfluktuasi dalam 90 hari — item dengan volatilitas tinggi butuh pemantauan lebih ketat dan idealnya ada kontrak harga tetap dengan supplier. Item dengan **selisih vs harga dasar positif** secara konsisten adalah prioritas renegosiasi._

---

## Rasio Efisiensi Pembelian per Item per Cabang (30 Hari Terakhir)
<span style="font-size:0.85em;color:var(--color-text-secondary)">{periode_30d[0].tgl_awal} – {periode_30d[0].tgl_akhir}</span>

_Rasio ideal mendekati 1.0. Jauh di atas 1.0 berarti stok menumpuk — berisiko terbuang untuk bahan yang mudah rusak._
```sql efficiency_ratio
SELECT
    branch_name,
    item_name,
    category,
    unit,
    ROUND(SUM(usage_qty), 1)                                            AS total_pakai,
    ROUND(SUM(purchase_qty), 1)                                         AS total_beli,
    ROUND(SUM(purchase_qty) / NULLIF(SUM(usage_qty), 0), 2)            AS rasio_beli_pakai,
    SUM(usage_cost)                                                     AS biaya_pakai,
    SUM(purchase_cost)                                                  AS biaya_beli
FROM restaurant.inventory_stok
WHERE txn_date >= (SELECT MAX(txn_date) FROM restaurant.inventory_stok) - INTERVAL '30 days'
GROUP BY 1, 2, 3, 4
HAVING SUM(usage_qty) > 0
ORDER BY rasio_beli_pakai DESC
```

<DataTable data={efficiency_ratio} rows=15 search=true>
    <Column id="branch_name"      title="Cabang"/>
    <Column id="item_name"        title="Bahan Baku"/>
    <Column id="category"         title="Kategori"/>
    <Column id="unit"             title="Satuan"/>
    <Column id="total_pakai"      title="Qty Dipakai"      fmt="#,##0"/>
    <Column id="total_beli"       title="Qty Dibeli"       fmt="#,##0"/>
    <Column id="rasio_beli_pakai" title="Rasio Beli/Pakai" fmt="0.00"/>
    <Column id="biaya_pakai"      title="Biaya Pakai (Rp)" fmt="#,##0"/>
    <Column id="biaya_beli"       title="Biaya Beli (Rp)"  fmt="#,##0"/>
</DataTable>

_Urutkan kolom **Rasio Beli/Pakai** dari terbesar — baris paling atas adalah pemborosan terbesar. Fokus dulu pada kategori **protein** dan **produce** karena risikonya bukan hanya boros, tapi juga terbuang kalau tidak habis dipakai._

---

## Detail per Item per Cabang (30 Hari Terakhir)

```sql detail_per_item_branch
SELECT
    branch_name,
    item_name,
    category,
    unit,
    SUM(usage_qty)                                              AS total_qty_pakai,
    SUM(purchase_qty)                                           AS total_qty_beli,
    SUM(usage_cost)                                             AS total_biaya_pakai,
    ROUND(SUM(usage_cost) / NULLIF(SUM(usage_qty), 0), 0)      AS biaya_per_unit_aktual
FROM restaurant.inventory_stok
WHERE txn_date >= (SELECT MAX(txn_date) FROM restaurant.inventory_stok) - INTERVAL '30 days'
GROUP BY branch_name, item_name, category, unit
ORDER BY branch_name, total_biaya_pakai DESC
```

<DataTable data={detail_per_item_branch} rows=15>
    <Column id="branch_name"           title="Cabang"/>
    <Column id="item_name"             title="Bahan Baku"/>
    <Column id="category"              title="Kategori"/>
    <Column id="unit"                  title="Satuan"/>
    <Column id="total_qty_pakai"       title="Qty Dipakai"            fmt="#,##0"/>
    <Column id="total_qty_beli"        title="Qty Dibeli"             fmt="#,##0"/>
    <Column id="total_biaya_pakai"     title="Total Biaya Pakai (Rp)" fmt="#,##0"/>
    <Column id="biaya_per_unit_aktual" title="Biaya/Unit Aktual (Rp)" fmt="#,##0"/>
</DataTable>

_Bandingkan Qty Dibeli vs Qty Dipakai per cabang — selisih besar yang konsisten pada item tertentu perlu dicek ke lapangan._
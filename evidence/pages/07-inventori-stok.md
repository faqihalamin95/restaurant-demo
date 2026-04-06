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

---

## Ringkasan 30 Hari Terakhir

<BigValue data={header_kpi} value="total_biaya_pemakaian" title="Total Biaya Pemakaian (Rp) — 30 Hari" fmt="#,##0" />
<BigValue data={header_kpi} value="total_pembelian"       title="Total Pembelian (Rp) — 30 Hari"      fmt="#,##0" />
<BigValue data={header_kpi} value="total_item"            title="Total Item Bahan Baku" />
<BigValue data={header_kpi} value="total_cabang"          title="Cabang Terpantau" />

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
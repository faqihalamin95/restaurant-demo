---
title: Performa Menu
---

_Analisis penjualan, tren, dan potensi menu restoran._

<style>
.tip {
    border-bottom: 1px dashed var(--color-text-secondary);
    cursor: help;
    position: relative;
}
.tip::after {
    content: attr(data-tip);
    position: absolute;
    bottom: 125%;
    left: 50%;
    transform: translateX(-50%);
    background: Canvas;
    border: 1px solid rgba(128,128,128,0.2);
    box-shadow: 0 2px 8px rgba(0,0,0,0.12);
    color: inherit;
    padding: 6px 10px;
    border-radius: 6px;
    font-size: 0.8em;
    white-space: normal;
    width: 220px;
    text-align: center;
    line-height: 1.4;
    opacity: 0;
    pointer-events: none;
    transition: opacity 0.15s;
    z-index: 10;
}
.tip:hover::after {
    opacity: 1;
}
</style>

```sql periode_30d
SELECT
    strftime('%d %b %Y', MAX(order_date) - INTERVAL '29 days') AS tgl_awal,
    strftime('%d %b %Y', MAX(order_date))                       AS tgl_akhir
FROM restaurant.menu_performance
```

```sql summary_menu
SELECT
    COUNT(DISTINCT menu_name) AS total_menu
FROM restaurant.menu_performance
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.menu_performance)
```

```sql best_menu_30d
SELECT
    menu_name,
    SUM(total_qty_sold) AS total_qty
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
GROUP BY menu_name
ORDER BY total_qty DESC
LIMIT 1
```

```sql best_revenue_30d
SELECT
    menu_name,
    SUM(total_revenue) AS total_revenue
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
GROUP BY menu_name
ORDER BY total_revenue DESC
LIMIT 1
```

```sql menu_alert_declining
SELECT
    menu_name,
    ROUND(qty_wow_change * 100, 1) AS pct_change
FROM restaurant.menu_performance
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.menu_performance)
  AND qty_wow_change < -0.20
ORDER BY qty_wow_change ASC
LIMIT 3
```

```sql menu_alert_rising
SELECT
    menu_name,
    ROUND(qty_wow_change * 100, 1) AS pct_change
FROM restaurant.menu_performance
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.menu_performance)
  AND qty_wow_change > 0.20
ORDER BY qty_wow_change DESC
LIMIT 1
```

---

## Ringkasan 30 Hari Terakhir

<span style="font-size:0.85em;color:var(--color-text-secondary)">{periode_30d[0].tgl_awal} – {periode_30d[0].tgl_akhir}</span>

_Ringkasan kumulatif performa menu dalam 30 hari terakhir — patokan kondisi operasional terkini sebelum melihat tren._

<BigValue data={best_menu_30d}    value="menu_name"     title="Menu Terlaris" />
<BigValue data={best_menu_30d}    value="total_qty"     title="Total Terjual"             fmt="#,##0" />
<BigValue data={best_revenue_30d} value="menu_name"     title="Menu Penggerak Revenue" />
<BigValue data={best_revenue_30d} value="total_revenue" title="Revenue Menu Tersebut (Rp)" fmt="#,##0" />
<BigValue data={summary_menu}     value="total_menu"    title="Total Menu Aktif" />

{#if menu_alert_declining.length > 0}
<div style="display: flex; flex-direction: column; gap: 8px; margin: 16px 0;">
{#each menu_alert_declining as row}
<div style="background: rgba(220,38,38,0.08); border-left: 4px solid #dc2626; padding: 12px 16px; border-radius: 6px;">
🔴 <strong>{row.menu_name}</strong> — penjualan turun <strong>{row.pct_change}%</strong> vs minggu lalu. Pertimbangkan promo atau evaluasi menu ini — cek dulu apakah penurunan terjadi di semua cabang atau hanya satu cabang sebelum ambil keputusan.
</div>
{/each}
</div>
{/if}

{#if menu_alert_rising.length > 0}
<div style="background: rgba(22,163,74,0.08); border-left: 4px solid #16a34a; padding: 12px 16px; border-radius: 6px; margin: 8px 0;">
🟢 <strong>{menu_alert_rising[0].menu_name}</strong> — penjualan naik <strong>{menu_alert_rising[0].pct_change}%</strong> vs minggu lalu. Pastikan stok cukup.
</div>
{/if}

---

## Volume Terjual vs Kontribusi Revenue (30 Hari Terakhir)

```sql top_by_volume
SELECT
    menu_name,
    CASE category
        WHEN 'main'    THEN 'Menu Utama'
        WHEN 'drink'   THEN 'Minuman'
        WHEN 'snack'   THEN 'Camilan'
        WHEN 'dessert' THEN 'Dessert'
        WHEN 'side'    THEN 'Pendamping'
        ELSE category
    END AS category,
    SUM(total_qty_sold) AS total_qty
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
GROUP BY menu_name, category
ORDER BY total_qty DESC
LIMIT 10
```

```sql top_by_revenue
SELECT
    menu_name,
    CASE category
        WHEN 'main'    THEN 'Menu Utama'
        WHEN 'drink'   THEN 'Minuman'
        WHEN 'snack'   THEN 'Camilan'
        WHEN 'dessert' THEN 'Dessert'
        WHEN 'side'    THEN 'Pendamping'
        ELSE category
    END AS category,
    SUM(total_revenue) AS total_revenue
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
GROUP BY menu_name, category
ORDER BY total_revenue DESC
LIMIT 10
```

<Grid cols=2>

<div>

### Top 10 by Volume

<BarChart
    data={top_by_volume}
    x="menu_name"
    y="total_qty"
    swapXY=true
    title="Menu Terlaris"
    xAxisTitle="Total Terjual"
    colorPalette={['#4f86c6']}
/>

</div>

<div>

### Top 10 by Revenue

<BarChart
    data={top_by_revenue}
    x="menu_name"
    y="total_revenue"
    swapXY=true
    title="Menu Penggerak Revenue (Rp)"
    yFmt="#,##0"
    xAxisTitle="Total Revenue (Rp)"
    colorPalette={['#e07b39']}
/>

</div>

</Grid>

_Kalau menu di Top 10 Volume dan Top 10 Revenue tidak banyak overlap, 
berarti ada gap antara apa yang laku dan apa yang menghasilkan uang — 
cek kolom <span class="tip" data-tip="Rata-rata harga jual per item berdasarkan yang benar-benar terjual — bukan harga di menu">**Harga Realisasi**</span> 
di tabel kategori._

---

## Kontribusi per Kategori & Segmen Harga (30 Hari Terakhir)
```sql category_summary_30d
SELECT
    CASE category
        WHEN 'main'    THEN 'Menu Utama'
        WHEN 'drink'   THEN 'Minuman'
        WHEN 'snack'   THEN 'Camilan'
        WHEN 'dessert' THEN 'Dessert'
        WHEN 'side'    THEN 'Pendamping'
        ELSE category
    END AS category,
    COUNT(DISTINCT menu_name)                                            AS total_menu,
    SUM(total_qty_sold)                                                  AS total_qty,
    SUM(total_revenue)                                                   AS total_revenue,
    ROUND(SUM(total_revenue) / NULLIF(SUM(total_qty_sold), 0), 0)       AS avg_price_realisasi,
    ROUND(SUM(total_revenue) / NULLIF(SUM(SUM(total_revenue)) OVER (), 0) * 100, 1) AS pct_revenue
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
GROUP BY category
ORDER BY total_revenue DESC
```
```sql price_tier_summary_30d
SELECT
    price_tier,
    COUNT(DISTINCT menu_name)                                            AS total_menu,
    SUM(total_qty_sold)                                                  AS total_qty,
    SUM(total_revenue)                                                   AS total_revenue,
    ROUND(SUM(total_revenue) / NULLIF(SUM(SUM(total_revenue)) OVER (), 0) * 100, 1) AS pct_revenue
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
GROUP BY price_tier
ORDER BY total_revenue DESC
```

<Grid cols=2>

<div>

### Per Kategori

<BarChart
    data={category_summary_30d}
    x="category"
    y="total_revenue"
    title="Revenue per Kategori (Rp)"
    yFmt="#,##0"
    xAxisTitle="Kategori"
    yAxisTitle="Revenue (Rp)"
/>

</div>

<div>

### Per Segmen Harga

<BarChart
    data={price_tier_summary_30d}
    x="price_tier"
    y="total_revenue"
    title="Revenue per Segmen Harga (Rp)"
    yFmt="#,##0"
    xAxisTitle="Segmen"
    yAxisTitle="Revenue (Rp)"
/>

</div>

</Grid>

<Grid cols=2>

<div>

<DataTable data={category_summary_30d}>
    <Column id="category"           title="Kategori"/>
    <Column id="total_menu"         title="Jumlah Menu"    fmt="#,##0"/>
    <Column id="total_qty"          title="Qty Terjual"    fmt="#,##0"/>
    <Column id="total_revenue"      title="Revenue (Rp)"   fmt="#,##0"/>
    <Column id="avg_price_realisasi" title="Harga Realisasi (Rp)" fmt="#,##0"/>
    <Column id="pct_revenue"        title="% Revenue"      fmt="0.0\%"/>
</DataTable>

</div>

<div>

<DataTable data={price_tier_summary_30d}>
    <Column id="price_tier"    title="Segmen"/>
    <Column id="total_menu"    title="Jumlah Menu"  fmt="#,##0"/>
    <Column id="total_qty"     title="Qty Terjual"  fmt="#,##0"/>
    <Column id="total_revenue" title="Revenue (Rp)" fmt="#,##0"/>
    <Column id="pct_revenue"   title="% Revenue"    fmt="0.0\%"/>
</DataTable>

</div>

</Grid>

_Kalau kategori **Menu Utama** dominasi revenue >70% artinya bisnis sangat bergantung pada satu segmen — risiko tinggi kalau ada gangguan supply atau kompetitor masuk._

```sql menu_reference
SELECT
    menu_name,
    CASE category
        WHEN 'main'    THEN 'Menu Utama'
        WHEN 'drink'   THEN 'Minuman'
        WHEN 'snack'   THEN 'Camilan'
        WHEN 'dessert' THEN 'Dessert'
        WHEN 'side'    THEN 'Pendamping'
        ELSE category
    END AS category,
    price_tier,
    ROUND(AVG(price), 0) AS harga
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
GROUP BY menu_name, category, price_tier
ORDER BY category, harga DESC
```

### Referensi Menu — Kategori & Segmen Harga

<DataTable data={menu_reference} search=true>
    <Column id="menu_name"  title="Menu"/>
    <Column id="category"   title="Kategori"/>
    <Column id="price_tier" title="Segmen"/>
    <Column id="harga"      title="Harga (Rp)" fmt="#,##0"/>
</DataTable>

---

## Andalan per Cabang (30 Hari Terakhir)

```sql andalan_per_cabang
SELECT
    branch_name,
    MAX(CASE WHEN rn_qty = 1 THEN menu_name END) AS top_volume_menu,
    MAX(CASE WHEN rn_qty = 1 THEN total_qty END)  AS top_volume_qty,
    MAX(CASE WHEN rn_rev = 1 THEN menu_name END)  AS top_revenue_menu,
    MAX(CASE WHEN rn_rev = 1 THEN total_rev END)  AS top_revenue_value
FROM (
    SELECT
        branch_name,
        menu_name,
        SUM(total_qty_sold)                                                             AS total_qty,
        SUM(total_revenue)                                                              AS total_rev,
        ROW_NUMBER() OVER (PARTITION BY branch_name ORDER BY SUM(total_qty_sold) DESC) AS rn_qty,
        ROW_NUMBER() OVER (PARTITION BY branch_name ORDER BY SUM(total_revenue) DESC)  AS rn_rev
    FROM restaurant.menu_performance
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
    GROUP BY branch_name, menu_name
)
GROUP BY branch_name
ORDER BY branch_name
```

<DataTable data={andalan_per_cabang}>
    <Column id="branch_name"       title="Cabang"/>
    <Column id="top_volume_menu"   title="Menu Terlaris"/>
    <Column id="top_volume_qty"    title="Qty Terjual"       fmt="#,##0"/>
    <Column id="top_revenue_menu"  title="Menu Revenue Terbesar"/>
    <Column id="top_revenue_value" title="Revenue (Rp)"      fmt="#,##0"/>
</DataTable>

_Menu andalan yang berbeda antar cabang bisa jadi dasar strategi stok, promo, dan pelatihan staf yang lebih tepat sasaran._

---

## Menu Engineering — Klasifikasi Menu (30 Hari Terakhir)

_Wekadata otomatis mengklasifikasikan menu menggunakan framework Menu Engineering — tanpa harus hitung manual._

```sql menu_engineering
SELECT
    menu_name,
    CASE category
        WHEN 'main'    THEN 'Menu Utama'
        WHEN 'drink'   THEN 'Minuman'
        WHEN 'snack'   THEN 'Camilan'
        WHEN 'dessert' THEN 'Dessert'
        WHEN 'side'    THEN 'Pendamping'
        ELSE category
    END AS category,
    SUM(total_qty_sold) AS total_qty,
    SUM(total_revenue)  AS total_revenue,
    CASE
        WHEN SUM(total_qty_sold) >= MEDIAN(SUM(total_qty_sold)) OVER ()
             AND SUM(total_revenue) >= MEDIAN(SUM(total_revenue)) OVER ()
        THEN 'Primadona'
        WHEN SUM(total_qty_sold) >= MEDIAN(SUM(total_qty_sold)) OVER ()
             AND SUM(total_revenue) < MEDIAN(SUM(total_revenue)) OVER ()
        THEN 'Pekerja Keras'
        WHEN SUM(total_qty_sold) < MEDIAN(SUM(total_qty_sold)) OVER ()
             AND SUM(total_revenue) >= MEDIAN(SUM(total_revenue)) OVER ()
        THEN 'Misteri'
        ELSE 'Lemah'
    END AS klasifikasi
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
GROUP BY menu_name, category
```

```sql menu_engineering_table
SELECT
    klasifikasi,
    menu_name,
    category,
    total_qty,
    total_revenue
FROM (
    SELECT
        menu_name,
        CASE category
            WHEN 'main'    THEN 'Menu Utama'
            WHEN 'drink'   THEN 'Minuman'
            WHEN 'snack'   THEN 'Camilan'
            WHEN 'dessert' THEN 'Dessert'
            WHEN 'side'    THEN 'Pendamping'
            ELSE category
        END AS category,
        SUM(total_qty_sold) AS total_qty,
        SUM(total_revenue)  AS total_revenue,
        CASE
            WHEN SUM(total_qty_sold) >= MEDIAN(SUM(total_qty_sold)) OVER ()
                 AND SUM(total_revenue) >= MEDIAN(SUM(total_revenue)) OVER ()
            THEN 'Primadona'
            WHEN SUM(total_qty_sold) >= MEDIAN(SUM(total_qty_sold)) OVER ()
                 AND SUM(total_revenue) < MEDIAN(SUM(total_revenue)) OVER ()
            THEN 'Pekerja Keras'
            WHEN SUM(total_qty_sold) < MEDIAN(SUM(total_qty_sold)) OVER ()
                 AND SUM(total_revenue) >= MEDIAN(SUM(total_revenue)) OVER ()
            THEN 'Misteri'
            ELSE 'Lemah'
        END AS klasifikasi
    FROM restaurant.menu_performance
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
    GROUP BY menu_name, category
)
ORDER BY
    CASE klasifikasi
        WHEN 'Primadona'     THEN 1
        WHEN 'Misteri'       THEN 2
        WHEN 'Pekerja Keras' THEN 3
        WHEN 'Lemah'         THEN 4
    END,
    total_revenue DESC
```

<ScatterPlot
    data={menu_engineering}
    x="total_qty"
    y="total_revenue"
    series="klasifikasi"
    pointName="menu_name"
    xAxisTitle="Volume Terjual"
    yAxisTitle="Total Revenue (Rp)"
    title="Menu Engineering — Volume vs Revenue"
    yFmt="#,##0"
/>

<DataTable data={menu_engineering_table}>
    <Column id="klasifikasi"   title="Klasifikasi"/>
    <Column id="menu_name"     title="Menu"/>
    <Column id="category"      title="Kategori"/>
    <Column id="total_qty"     title="Volume Terjual"     fmt="#,##0"/>
    <Column id="total_revenue" title="Total Revenue (Rp)" fmt="#,##0"/>
</DataTable>

_**Primadona** — volume & revenue tinggi, pertahankan kualitas dan stok. **Misteri** — revenue tinggi tapi kurang laku, promosikan lebih agresif. **Pekerja Keras** — laris tapi revenue kecil, naikkan harga atau buat bundling. **Lemah** — pertimbangkan hapus dari menu atau reformulasi._

---

## Tren Menu — Perbandingan Minggu Ini vs Minggu Lalu

```sql menu_wow
SELECT
    menu_name,
    CASE category
        WHEN 'main'    THEN 'Menu Utama'
        WHEN 'drink'   THEN 'Minuman'
        WHEN 'snack'   THEN 'Camilan'
        WHEN 'dessert' THEN 'Dessert'
        WHEN 'side'    THEN 'Pendamping'
        ELSE category
    END AS category,
    SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
        THEN total_qty_sold END)                                        AS qty_minggu_ini,
    SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '13 days'
         AND order_date < (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
        THEN total_qty_sold END)                                        AS qty_minggu_lalu,
    ROUND(
        (SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
            THEN total_qty_sold END)
        - SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '13 days'
             AND order_date < (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
            THEN total_qty_sold END))
        / NULLIF(SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '13 days'
             AND order_date < (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
            THEN total_qty_sold END), 0) * 100
    , 1) AS pct_change_qty,
    SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
        THEN total_revenue END)                                         AS rev_minggu_ini,
    SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '13 days'
         AND order_date < (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
        THEN total_revenue END)                                         AS rev_minggu_lalu,
    ROUND(
        (SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
            THEN total_revenue END)
        - SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '13 days'
             AND order_date < (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
            THEN total_revenue END))
        / NULLIF(SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '13 days'
             AND order_date < (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
            THEN total_revenue END), 0) * 100
    , 1) AS pct_change_revenue
FROM restaurant.menu_performance
GROUP BY menu_name, category
ORDER BY pct_change_qty ASC
```

<DataTable data={menu_wow}>
    <Column id="menu_name"        title="Menu"/>
    <Column id="category"         title="Kategori"/>
    <Column id="qty_minggu_ini"   title="Qty Minggu Ini"      fmt="#,##0"/>
    <Column id="qty_minggu_lalu"  title="Qty Minggu Lalu"     fmt="#,##0"/>
    <Column id="pct_change_qty"   title="Δ Qty (%)"           fmt="+0.0;-0.0" contentType="delta"/>
    <Column id="rev_minggu_ini"   title="Revenue Minggu Ini"  fmt="#,##0"/>
    <Column id="rev_minggu_lalu"  title="Revenue Minggu Lalu" fmt="#,##0"/>
    <Column id="pct_change_revenue" title="Δ Revenue (%)"     fmt="+0.0;-0.0" contentType="delta"/>
</DataTable>

_Menu dengan Δ Qty negatif tapi Δ Revenue positif berarti harga rata-rata naik atau mix produk bergeser ke item mahal — tidak selalu buruk. Sebaliknya, Δ Qty positif tapi Δ Revenue stagnan bisa berarti yang laku justru item murah._

---

## Menu dengan Tren Menurun (90 Hari Terakhir)

```sql declining_trend
WITH declining_menus AS (
    SELECT menu_name
    FROM restaurant.menu_performance
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '90 days'
    GROUP BY menu_name
    HAVING
        SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
            THEN total_qty_sold ELSE 0 END)
        <
        SUM(CASE WHEN order_date < (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '60 days'
            THEN total_qty_sold ELSE 0 END)
),
daily_sales AS (
    SELECT
        order_date,
        menu_name,
        SUM(total_qty_sold) AS qty_harian
    FROM restaurant.menu_performance
    WHERE menu_name IN (SELECT menu_name FROM declining_menus)
      AND order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '90 days'
    GROUP BY order_date, menu_name
)
SELECT
    order_date,
    menu_name,
    AVG(qty_harian) OVER (
        PARTITION BY menu_name
        ORDER BY order_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS rolling_avg_qty
FROM daily_sales
ORDER BY order_date, menu_name
```

```sql declining_by_branch
SELECT
    branch_name,
    menu_name,
    SUM(CASE WHEN order_date < (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '60 days'
        THEN total_qty_sold ELSE 0 END) AS qty_30_awal,
    SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
        THEN total_qty_sold ELSE 0 END) AS qty_30_akhir,
    ROUND(
        (SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
            THEN total_qty_sold ELSE 0 END)
        - SUM(CASE WHEN order_date < (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '60 days'
            THEN total_qty_sold ELSE 0 END))
        / NULLIF(SUM(CASE WHEN order_date < (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '60 days'
            THEN total_qty_sold ELSE 0 END), 0) * 100
    , 1) AS pct_change
FROM restaurant.menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '90 days'
GROUP BY branch_name, menu_name
HAVING pct_change < 0
ORDER BY pct_change ASC
```

{#if declining_trend.length > 0}

<LineChart
    data={declining_trend}
    x="order_date"
    y="rolling_avg_qty"
    series="menu_name"
    title="Tren Penurunan Menu (Rata-rata Bergerak 7 Hari)"
    xAxisTitle="Tanggal"
    yAxisTitle="Rata-rata Qty Terjual (7 Hari)"
/>

_Garis yang terus mengarah ke bawah berarti minat pelanggan berkurang secara konsisten — pertimbangkan promo, reformulasi, atau penghapusan menu._

### Detail Penurunan per Cabang

<DataTable data={declining_by_branch}>
    <Column id="branch_name"  title="Cabang"/>
    <Column id="menu_name"    title="Menu"/>
    <Column id="qty_30_awal"  title="30 Hari Pertama"  fmt="#,##0"/>
    <Column id="qty_30_akhir" title="30 Hari Terakhir" fmt="#,##0"/>
    <Column id="pct_change"   title="Perubahan (%)"    fmt="+0.0;-0.0" contentType="delta"/>
</DataTable>

_Cek per cabang untuk tindakan yang lebih tepat sasaran — penurunan di satu cabang saja butuh penanganan berbeda vs penurunan di semua cabang._

{:else}
<div style="background: rgba(22,163,74,0.08); border-left: 4px solid #16a34a; padding: 12px 16px; border-radius: 6px;">
✅ <strong>Tidak ada menu dengan tren menurun</strong> dalam 90 hari terakhir — semua menu stabil atau tumbuh.
</div>
{/if}
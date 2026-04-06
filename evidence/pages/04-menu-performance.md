---
title: Performa Menu
---

_Analisis penjualan, tren, dan potensi menu restoran._

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

<BigValue data={best_menu_30d}    value="menu_name"     title="Menu Terlaris" />
<BigValue data={best_menu_30d}    value="total_qty"     title="Total Terjual"             fmt="#,##0" />
<BigValue data={best_revenue_30d} value="menu_name"     title="Menu Penggerak Revenue" />
<BigValue data={best_revenue_30d} value="total_revenue" title="Revenue Menu Tersebut (Rp)" fmt="#,##0" />
<BigValue data={summary_menu}     value="total_menu"    title="Total Menu Aktif" />

{#if menu_alert_declining.length > 0}
<div style="display: flex; flex-direction: column; gap: 8px; margin: 16px 0;">
{#each menu_alert_declining as row}
<div style="background: #fff3f3; border-left: 4px solid #dc2626; padding: 12px 16px; border-radius: 6px;">
🔴 <strong>{row.menu_name}</strong> — penjualan turun <strong>{row.pct_change}%</strong> vs minggu lalu. Pertimbangkan promo atau evaluasi menu ini.
</div>
{/each}
</div>
{/if}

{#if menu_alert_rising.length > 0}
<div style="background: #f0fdf4; border-left: 4px solid #16a34a; padding: 12px 16px; border-radius: 6px; margin: 8px 0;">
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

_Menu terlaris belum tentu penggerak revenue terbesar. Pertimbangkan upselling atau bundling untuk mendorong revenue dari menu murah yang sering dipesan._

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
    , 1) AS pct_change
FROM restaurant.menu_performance
GROUP BY menu_name, category
ORDER BY pct_change ASC
```

<DataTable data={menu_wow}>
    <Column id="menu_name"       title="Menu"/>
    <Column id="category"        title="Kategori"/>
    <Column id="qty_minggu_ini"  title="Minggu Ini"    fmt="#,##0"/>
    <Column id="qty_minggu_lalu" title="Minggu Lalu"   fmt="#,##0"/>
    <Column id="pct_change"      title="Perubahan (%)" fmt="+0.0;-0.0" contentType="delta"/>
</DataTable>

_Menu dengan tanda merah perlu perhatian segera. Cek apakah penurunan terjadi di semua cabang atau hanya cabang tertentu._

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
<div style="background: #f0fdf4; border-left: 4px solid #16a34a; padding: 12px 16px; border-radius: 6px;">
✅ <strong>Tidak ada menu dengan tren menurun</strong> dalam 90 hari terakhir — semua menu stabil atau tumbuh.
</div>
{/if}
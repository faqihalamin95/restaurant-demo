---
title: Performa Menu
---

_Analisis penjualan, tren, dan potensi menu restoran._

```sql summary_menu
SELECT
    COUNT(DISTINCT menu_name) AS total_menu
FROM restaurant.menu_performance
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

<BigValue
    data={best_menu_30d}
    value="menu_name"
    title="Menu Terlaris (30 Hari Terakhir)"
/>

<BigValue
    data={best_menu_30d}
    value="total_qty"
    title="Total Terjual"
    fmt="#,##0"
/>

<BigValue
    data={best_revenue_30d}
    value="menu_name"
    title="Menu Penggerak Revenue (30 Hari Terakhir)"
/>

<BigValue
    data={best_revenue_30d}
    value="total_revenue"
    title="Total Revenue Menu Tersebut (Rp)"
    fmt="#,##0"
/>

<BigValue
    data={summary_menu}
    value="total_menu"
    title="Total Menu Aktif"
/>

---

## Menu Engineering — Klasifikasi Menu (30 Hari Terakhir)

_Wekadata otomatis mengklasifikasikan menu kamu pakai framework Menu Engineering yang sama yang dipakai restoran bintang lima — tanpa kamu harus hitung manual._

```sql menu_engineering
SELECT
    menu_name,
    category,
    SUM(total_qty_sold)  AS total_qty,
    SUM(total_revenue)   AS total_revenue,
    CASE
        WHEN SUM(total_qty_sold) >= MEDIAN(SUM(total_qty_sold)) OVER ()
             AND SUM(total_revenue) >= MEDIAN(SUM(total_revenue)) OVER ()
        THEN 'Stars'
        WHEN SUM(total_qty_sold) >= MEDIAN(SUM(total_qty_sold)) OVER ()
             AND SUM(total_revenue) < MEDIAN(SUM(total_revenue)) OVER ()
        THEN 'Plowhorses'
        WHEN SUM(total_qty_sold) < MEDIAN(SUM(total_qty_sold)) OVER ()
             AND SUM(total_revenue) >= MEDIAN(SUM(total_revenue)) OVER ()
        THEN 'Puzzles'
        ELSE 'Dogs'
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
        category,
        SUM(total_qty_sold)  AS total_qty,
        SUM(total_revenue)   AS total_revenue,
        CASE
            WHEN SUM(total_qty_sold) >= MEDIAN(SUM(total_qty_sold)) OVER ()
                 AND SUM(total_revenue) >= MEDIAN(SUM(total_revenue)) OVER ()
            THEN 'Stars'
            WHEN SUM(total_qty_sold) >= MEDIAN(SUM(total_qty_sold)) OVER ()
                 AND SUM(total_revenue) < MEDIAN(SUM(total_revenue)) OVER ()
            THEN 'Plowhorses'
            WHEN SUM(total_qty_sold) < MEDIAN(SUM(total_qty_sold)) OVER ()
                 AND SUM(total_revenue) >= MEDIAN(SUM(total_revenue)) OVER ()
            THEN 'Puzzles'
            ELSE 'Dogs'
        END AS klasifikasi
    FROM restaurant.menu_performance
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '30 days'
    GROUP BY menu_name, category
)
ORDER BY
    CASE klasifikasi
        WHEN 'Stars'       THEN 1
        WHEN 'Puzzles'     THEN 2
        WHEN 'Plowhorses'  THEN 3
        WHEN 'Dogs'        THEN 4
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
    <Column id="klasifikasi" title="Klasifikasi"/>
    <Column id="menu_name" title="Menu"/>
    <Column id="category" title="Kategori"/>
    <Column id="total_qty" title="Volume Terjual" fmt="#,##0"/>
    <Column id="total_revenue" title="Total Revenue (Rp)" fmt="#,##0"/>
</DataTable>

_**Stars** — volume & revenue tinggi, pertahankan kualitas. **Puzzles** — revenue tinggi tapi kurang laku, promosikan lebih agresif. **Plowhorses** — laris tapi revenue kecil, naikkan harga atau buat bundling. **Dogs** — volume & revenue rendah, pertimbangkan hapus dari menu._

---

## Volume Terjual vs Kontribusi Revenue (30 Hari Terakhir)

```sql top_by_volume
SELECT
    menu_name,
    category,
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
    category,
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

_Menu terlaris belum tentu penggerak revenue terbesar. Menu murah yang sering dipesan bisa jadi tidak banyak menggerakkan omset — pertimbangkan strategi upselling atau bundling untuk mendorong revenue dari menu-menu tersebut._

---

## Andalan per Cabang (30 Hari Terakhir)

```sql andalan_per_cabang
SELECT
    branch_name,
    MAX(CASE WHEN rn_qty = 1 THEN menu_name END)  AS top_volume_menu,
    MAX(CASE WHEN rn_qty = 1 THEN total_qty END)   AS top_volume_qty,
    MAX(CASE WHEN rn_rev = 1 THEN menu_name END)   AS top_revenue_menu,
    MAX(CASE WHEN rn_rev = 1 THEN total_rev END)   AS top_revenue_value
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
    <Column id="branch_name" title="Cabang"/>
    <Column id="top_volume_menu" title="Menu Terlaris"/>
    <Column id="top_volume_qty" title="Qty Terjual" fmt="#,##0"/>
    <Column id="top_revenue_menu" title="Menu Revenue Terbesar"/>
    <Column id="top_revenue_value" title="Revenue (Rp)" fmt="#,##0"/>
</DataTable>

_Tiap cabang punya karakter pelanggan yang berbeda. Menu andalan yang berbeda antar cabang bisa jadi dasar strategi stok, promo, dan pelatihan staf yang lebih tepat sasaran._

---

## Tren Menu — Perbandingan Minggu Ini vs Minggu Lalu

```sql menu_wow
SELECT
    menu_name,
    category,
    SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
        THEN total_qty_sold END)                                         AS qty_minggu_ini,
    SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '13 days'
         AND order_date < (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
        THEN total_qty_sold END)                                         AS qty_minggu_lalu,
    ROUND(
        (SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
            THEN total_qty_sold END)
        - SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '13 days'
             AND order_date < (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
            THEN total_qty_sold END))
        / NULLIF(SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '13 days'
             AND order_date < (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '6 days'
            THEN total_qty_sold END), 0) * 100
    , 1)                                                                 AS pct_change
FROM restaurant.menu_performance
GROUP BY menu_name, category
ORDER BY pct_change ASC
```

<DataTable data={menu_wow}>
    <Column id="menu_name" title="Menu"/>
    <Column id="category" title="Kategori"/>
    <Column id="qty_minggu_ini" title="Minggu Ini" fmt="#,##0"/>
    <Column id="qty_minggu_lalu" title="Minggu Lalu" fmt="#,##0"/>
    <Column id="pct_change" title="Perubahan (%)" fmt="+0.0;-0.0" contentType="delta"/>
</DataTable>

_Perbandingan langsung antara minggu ini dan minggu lalu — menu dengan tanda merah perlu perhatian segera._

---

## Menu dengan Tren Menurun (90 Hari Terakhir)

```sql declining_trend
SELECT
    order_date,
    menu_name,
    SUM(total_qty_sold) AS qty_harian
FROM restaurant.menu_performance
WHERE menu_name IN (
    SELECT menu_name
    FROM (
        SELECT
            menu_name,
            AVG(CASE WHEN hari_ke <= 30 THEN total_qty_sold END) AS avg_awal,
            AVG(CASE WHEN hari_ke > 60  THEN total_qty_sold END) AS avg_akhir
        FROM (
            SELECT
                menu_name,
                order_date,
                total_qty_sold,
                ROW_NUMBER() OVER (PARTITION BY menu_name ORDER BY order_date) AS hari_ke
            FROM restaurant.menu_performance
            WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '90 days'
        )
        GROUP BY menu_name
    )
    WHERE (avg_akhir - avg_awal) / NULLIF(avg_awal, 0) <= 0
    ORDER BY (avg_akhir - avg_awal) / NULLIF(avg_awal, 0) ASC
)
AND order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '90 days'
GROUP BY order_date, menu_name
ORDER BY order_date, menu_name
```

<LineChart
    data={declining_trend}
    x="order_date"
    y="qty_harian"
    series="menu_name"
    title="Menu dengan Tren Penjualan Menurun (90 Hari)"
    xAxisTitle="Tanggal"
    yAxisTitle="Qty Terjual per Hari"
/>

_Grafik menunjukkan tren penjualan harian menu dengan penurunan konsisten dalam 90 hari terakhir._

---

### Detail Penurunan per Cabang

```sql declining_by_branch
SELECT
    branch_name,
    menu_name,
    SUM(CASE WHEN hari_ke <= 30 THEN total_qty_sold END) AS qty_30_awal,
    SUM(CASE WHEN hari_ke > 60  THEN total_qty_sold END) AS qty_30_akhir,
    ROUND(
        (SUM(CASE WHEN hari_ke > 60  THEN total_qty_sold END)
        - SUM(CASE WHEN hari_ke <= 30 THEN total_qty_sold END))
        / NULLIF(SUM(CASE WHEN hari_ke <= 30 THEN total_qty_sold END), 0) * 100
    , 1) AS pct_change
FROM (
    SELECT
        branch_name,
        menu_name,
        order_date,
        total_qty_sold,
        ROW_NUMBER() OVER (PARTITION BY branch_name, menu_name ORDER BY order_date) AS hari_ke
    FROM restaurant.menu_performance
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '90 days'
)
GROUP BY branch_name, menu_name
HAVING pct_change <= 0
ORDER BY pct_change ASC
```

<DataTable data={declining_by_branch}>
    <Column id="branch_name" title="Cabang"/>
    <Column id="menu_name" title="Menu"/>
    <Column id="qty_30_awal" title="30 Hari Pertama" fmt="#,##0"/>
    <Column id="qty_30_akhir" title="30 Hari Terakhir" fmt="#,##0"/>
    <Column id="pct_change" title="Perubahan (%)" fmt="+0.0;-0.0" contentType="delta"/>
</DataTable>

_Menu di atas mengalami penurunan dalam 90 hari terakhir. Cek per cabang untuk tindakan yang lebih tepat sasaran._
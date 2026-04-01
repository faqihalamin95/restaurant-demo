---
title: Laporan Harian
---
```sql tgl
SELECT
    DAY(MAX(order_date)) || ' ' ||
    CASE MONTH(MAX(order_date))
        WHEN 1 THEN 'Januari' WHEN 2 THEN 'Februari' WHEN 3 THEN 'Maret'
        WHEN 4 THEN 'April' WHEN 5 THEN 'Mei' WHEN 6 THEN 'Juni'
        WHEN 7 THEN 'Juli' WHEN 8 THEN 'Agustus' WHEN 9 THEN 'September'
        WHEN 10 THEN 'Oktober' WHEN 11 THEN 'November' WHEN 12 THEN 'Desember'
    END || ' ' ||
    YEAR(MAX(order_date)) AS tanggal_display,
    CASE DAYNAME(MAX(order_date))
        WHEN 'Monday'    THEN 'Senin'
        WHEN 'Tuesday'   THEN 'Selasa'
        WHEN 'Wednesday' THEN 'Rabu'
        WHEN 'Thursday'  THEN 'Kamis'
        WHEN 'Friday'    THEN 'Jumat'
        WHEN 'Saturday'  THEN 'Sabtu'
        WHEN 'Sunday'    THEN 'Minggu'
    END AS nama_hari
FROM restaurant.daily_revenue
```

_Ringkasan operasional **{tgl[0].nama_hari}, {tgl[0].tanggal_display}**. Semua data mengacu pada hari terakhir yang tersedia._

---

## Revenue & Order
```sql daily_kpi
SELECT
    SUM(total_revenue)                                                  AS total_revenue,
    SUM(total_orders)                                                   AS total_orders,
    COUNT(DISTINCT branch_id)                                           AS cabang_aktif,
    ROUND(SUM(total_revenue) / NULLIF(SUM(total_orders), 0), 0)         AS avg_order_value
FROM restaurant.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)
```
```sql daily_vs_avg
SELECT
    ROUND(pct_change * 100, 1)       AS pct_change_display,
    ABS(ROUND(pct_change * 100, 1))  AS pct_change_abs,
    CASE
        WHEN pct_change > 0.10  THEN 'naik'
        WHEN pct_change < -0.10 THEN 'turun'
        ELSE 'stabil'
    END AS kondisi
FROM (
    SELECT
        ROUND((today_rev - avg_7d) / NULLIF(avg_7d, 0), 3) AS pct_change
    FROM (
        SELECT
            SUM(CASE WHEN order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)
                THEN daily_total ELSE 0 END)                AS today_rev,
            AVG(CASE WHEN order_date < (SELECT MAX(order_date) FROM restaurant.daily_revenue)
                THEN daily_total ELSE NULL END)              AS avg_7d
        FROM (
            SELECT order_date, SUM(total_revenue) AS daily_total
            FROM restaurant.daily_revenue
            WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.daily_revenue) - INTERVAL '7 days'
            GROUP BY order_date
        )
    )
)
```

<BigValue data={daily_kpi} value="total_revenue"   title="Total Revenue (Rp)"        fmt="#,##0" />
<BigValue data={daily_kpi} value="total_orders"    title="Total Order"                fmt="#,##0" />
<BigValue data={daily_kpi} value="cabang_aktif"    title="Cabang Aktif" />
<BigValue data={daily_kpi} value="avg_order_value" title="Rata-rata Nilai Order (Rp)" fmt="#,##0" />

{#if daily_vs_avg[0].kondisi === 'naik'}
<div>

✅ Revenue kemarin **naik {daily_vs_avg[0].pct_change_display}%** dibanding rata-rata 7 hari terakhir.

</div>
{:else if daily_vs_avg[0].kondisi === 'turun'}
<div>

⚠️ Revenue kemarin **turun {daily_vs_avg[0].pct_change_abs}%** dibanding rata-rata 7 hari terakhir.

</div>
{:else}
<div>

👍 Revenue kemarin **stabil** dibanding rata-rata 7 hari terakhir.

</div>
{/if}

---

## Biaya & Net Revenue Hari Ini
```sql net_kpi_today
SELECT
    SUM(gross_revenue)                                                    AS gross_revenue,
    SUM(inventory_usage_cost + labor_total_cost + operational_total_cost) AS total_biaya,
    SUM(net_revenue)                                                       AS net_revenue,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1)      AS net_margin_pct
FROM restaurant.daily_net_revenue
WHERE metric_date = (SELECT MAX(metric_date) FROM restaurant.daily_net_revenue)
```
```sql net_by_branch_today
SELECT
    branch_name,
    gross_revenue,
    inventory_usage_cost  AS biaya_bahan,
    labor_total_cost      AS biaya_sdm,
    operational_total_cost AS biaya_operasional,
    net_revenue,
    ROUND(net_revenue / NULLIF(gross_revenue, 0) * 100, 1) AS net_margin_pct
FROM restaurant.daily_net_revenue
WHERE metric_date = (SELECT MAX(metric_date) FROM restaurant.daily_net_revenue)
ORDER BY net_revenue DESC
```

<BigValue data={net_kpi_today} value="total_biaya"    title="Total Biaya Hari Ini (Rp)" fmt="#,##0" />
<BigValue data={net_kpi_today} value="net_revenue"    title="Net Revenue Hari Ini (Rp)" fmt="#,##0" />
<BigValue data={net_kpi_today} value="net_margin_pct" title="Net Margin (%)"             fmt="0.0\%" />

<DataTable data={net_by_branch_today}>
    <Column id="branch_name"       title="Cabang"/>
    <Column id="gross_revenue"     title="Gross Revenue (Rp)"     fmt="#,##0"/>
    <Column id="biaya_bahan"       title="Biaya Bahan (Rp)"       fmt="#,##0"/>
    <Column id="biaya_sdm"         title="Biaya SDM (Rp)"         fmt="#,##0"/>
    <Column id="biaya_operasional" title="Biaya Operasional (Rp)" fmt="#,##0"/>
    <Column id="net_revenue"       title="Net Revenue (Rp)"       fmt="#,##0"/>
    <Column id="net_margin_pct"    title="Margin (%)"             fmt="0.0\%"/>
</DataTable>

_Net Revenue = Gross Revenue dikurangi seluruh biaya operasional hari ini. Detail tren biaya dan profitabilitas jangka panjang tersedia di halaman **Financial Health**._

---

## Performa per Cabang
```sql branch_daily
SELECT
    branch_name,
    total_revenue,
    total_orders,
    ROUND(total_revenue / NULLIF(total_orders, 0), 0) AS avg_order_value,
    pct_change_vs_7d_avg
FROM restaurant.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)
ORDER BY total_revenue DESC
```
```sql branch_trend_7d
SELECT
    order_date,
    branch_name,
    total_revenue
FROM restaurant.daily_revenue
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.daily_revenue) - INTERVAL '6 days'
ORDER BY order_date, branch_name
```

<Grid cols=2>

<div>

### Revenue & Tren vs 7 Hari

<DataTable data={branch_daily}>
    <Column id="branch_name"          title="Cabang"/>
    <Column id="total_revenue"        title="Revenue (Rp)"     fmt="#,##0"/>
    <Column id="total_orders"         title="Order"            fmt="#,##0"/>
    <Column id="avg_order_value"      title="Rata-rata Nilai Order (Rp)"  fmt="#,##0"/>
    <Column id="pct_change_vs_7d_avg" title="vs 7hr"           fmt="+0.0%;-0.0%;0.0%" contentType="delta"/>
</DataTable>

</div>

<div>

### Tren 7 Hari Terakhir

<LineChart
    data={branch_trend_7d}
    x="order_date"
    y="total_revenue"
    series="branch_name"
    title="Revenue per Cabang — 7 Hari"
    yFmt="#,##0"
    xAxisTitle="Tanggal"
    yAxisTitle="Revenue (Rp)"
/>

</div>

</Grid>

_Kolom "vs 7hr" menunjukkan apakah performa cabang hari ini di atas atau di bawah rata-rata 7 hari terakhir mereka sendiri — lebih adil dibanding membandingkan antar cabang yang berbeda baseline-nya._

---

## Menu Terlaris Hari Ini
```sql menu_daily
SELECT
    menu_name,
    category,
    SUM(total_qty_sold)  AS total_qty,
    SUM(total_revenue)   AS total_revenue
FROM restaurant.menu_performance
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.menu_performance)
GROUP BY menu_name, category
ORDER BY total_qty DESC
LIMIT 10
```
```sql menu_daily_by_branch
SELECT
    branch_name,
    menu_name,
    SUM(total_qty_sold) AS total_qty
FROM restaurant.menu_performance
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.menu_performance)
GROUP BY branch_name, menu_name
ORDER BY branch_name, total_qty DESC
```

<Grid cols=2>

<div>

### Top 10 Menu by Volume

<DataTable data={menu_daily}>
    <Column id="menu_name"     title="Menu"/>
    <Column id="category"      title="Kategori"/>
    <Column id="total_qty"     title="Qty Terjual"   fmt="#,##0"/>
    <Column id="total_revenue" title="Revenue (Rp)"  fmt="#,##0"/>
</DataTable>

</div>

<div>

### Volume per Cabang

<BarChart
    data={menu_daily_by_branch}
    x="menu_name"
    y="total_qty"
    series="branch_name"
    swapXY=true
    title="Qty Terjual per Cabang"
    xAxisTitle="Qty"
    yAxisTitle="Menu"
/>

</div>

</Grid>

_Menu yang laris di semua cabang sekaligus adalah indikator kuat — pastikan stok selalu tersedia. Menu yang hanya laris di satu cabang bisa jadi bahan eksperimen promo lintas cabang._

---

## Ringkasan Shift & Kehadiran
```sql shift_daily
SELECT
    shift_name,
    SUM(orders_handled)       AS total_orders,
    SUM(total_revenue)        AS total_revenue,
    ROUND(AVG(avg_ticket), 0) AS avg_ticket
FROM restaurant.employee_shift_performance
WHERE attendance_date = (SELECT MAX(attendance_date) FROM restaurant.employee_shift_performance)
GROUP BY shift_name
ORDER BY total_revenue DESC
```
```sql attendance_daily
SELECT
    attendance_status,
    COUNT(*) AS total
FROM restaurant.employee_shift_performance
WHERE attendance_date = (SELECT MAX(attendance_date) FROM restaurant.employee_shift_performance)
GROUP BY attendance_status
ORDER BY total DESC
```

<Grid cols=2>

<div>

### Performa per Shift

<DataTable data={shift_daily}>
    <Column id="shift_name"    title="Shift"/>
    <Column id="total_orders"  title="Order Ditangani"   fmt="#,##0"/>
    <Column id="total_revenue" title="Revenue (Rp)"      fmt="#,##0"/>
    <Column id="avg_ticket"    title="Rata-rata Nilai Order (Rp)" fmt="#,##0"/>
</DataTable>

</div>

<div>

### Status Kehadiran

<BarChart
    data={attendance_daily}
    x="attendance_status"
    y="total"
    title="Kehadiran Pegawai Hari Ini"
    xAxisTitle="Status"
    yAxisTitle="Jumlah"
/>

</div>

</Grid>

_Kalau `absent` hari ini tinggi, cek apakah ada shift yang kekurangan staf — bisa berpengaruh ke kecepatan layanan dan revenue._

---

## Pola Order per Jam Hari Ini
```sql hourly_daily
SELECT
    order_hour,
    order_type,
    SUM(total_orders)  AS total_orders,
    SUM(total_revenue) AS total_revenue
FROM restaurant.peak_hours
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.peak_hours)
GROUP BY order_hour, order_type
ORDER BY order_hour
```

<BarChart
    data={hourly_daily}
    x="order_hour"
    y="total_orders"
    series="order_type"
    type="stacked"
    title="Order per Jam — Dine-in vs Delivery vs Takeaway"
    xAxisTitle="Jam"
    yAxisTitle="Total Order"
/>

_Bandingkan pola ini dengan prediksi di halaman Jam Sibuk — apakah jam puncak hari ini sesuai ekspektasi atau ada anomali yang perlu dicek._
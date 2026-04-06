---
title: Analisis Jam Sibuk
---

_Ketahui kapan pelanggan datang dan optimalkan operasional restoranmu._

```sql peak_summary
SELECT
    day_part                AS periode,
    SUM(total_orders)       AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY day_part
ORDER BY total_orders DESC
LIMIT 1
```

```sql peak_hour_summary
SELECT
    order_hour              AS jam_tersibuk,
    SUM(total_orders)       AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY order_hour
ORDER BY total_orders DESC
LIMIT 1
```

```sql peak_order_type
SELECT
    CASE order_type
        WHEN 'dine_in'  THEN 'Makan di Tempat'
        WHEN 'delivery' THEN 'Pesan Antar'
        WHEN 'takeaway' THEN 'Bawa Pulang'
        ELSE order_type
    END                     AS tipe_order,
    SUM(total_orders)       AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY order_type
ORDER BY total_orders DESC
LIMIT 1
```

```sql daypart_summary
SELECT
    day_part AS periode,
    CASE day_part
        WHEN 'Pagi'        THEN '08.00 – 10.00'
        WHEN 'Makan Siang' THEN '11.00 – 13.00'
        WHEN 'Sore'        THEN '14.00 – 16.00'
        WHEN 'Makan Malam' THEN '17.00 – 20.00'
        WHEN 'Larut Malam' THEN '21.00 – 22.00'
        ELSE '-'
    END AS rentang_jam,
    SUM(total_orders)                                            AS total_orders,
    SUM(total_revenue)                                           AS total_revenue,
    ROUND(SUM(total_revenue) / NULLIF(SUM(total_orders), 0), 0) AS avg_order_value
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY day_part
ORDER BY total_orders DESC
```

```sql quiet_period
SELECT
    day_part AS periode,
    SUM(total_orders) AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY day_part
ORDER BY total_orders ASC
LIMIT 1
```

---

## Ringkasan 30 Hari Terakhir

<BigValue data={peak_summary}      value="periode"      title="Periode Tersibuk" />
<BigValue data={peak_hour_summary} value="jam_tersibuk" title="Jam Tersibuk" />
<BigValue data={peak_order_type}   value="tipe_order"   title="Tipe Order Terbanyak" />
<BigValue data={peak_hour_summary} value="total_orders" title="Total Order di Jam Tersibuk" fmt="#,##0" />

{#if quiet_period.length > 0 && peak_summary.length > 0}
<div style="background: #f0fdf4; border-left: 4px solid #16a34a; padding: 12px 16px; border-radius: 6px; margin: 16px 0;">
📊 Periode paling ramai: <strong>{peak_summary[0].periode}</strong> dengan <strong>{peak_summary[0].total_orders}</strong> order. Periode paling sepi: <strong>{quiet_period[0].periode}</strong> dengan <strong>{quiet_period[0].total_orders}</strong> order — peluang promo untuk mendorong traffic di jam ini.
</div>
{/if}

---

## Distribusi Order per Jam (30 Hari Terakhir)

```sql hourly_all
SELECT
    order_hour,
    day_part,
    SUM(total_orders)  AS total_orders,
    SUM(total_revenue) AS total_revenue
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY order_hour, day_part
ORDER BY order_hour
```

<Grid cols=2>

<div>

### Total Order per Jam

<BarChart
    data={hourly_all}
    x="order_hour"
    y="total_orders"
    series="day_part"
    title="Total Order per Jam"
    xAxisTitle="Jam"
    yAxisTitle="Total Order"
/>

</div>

<div>

### Ringkasan per Periode

<DataTable data={daypart_summary}>
    <Column id="periode"         title="Periode"/>
    <Column id="rentang_jam"     title="Jam"/>
    <Column id="total_orders"    title="Total Order"               fmt="#,##0"/>
    <Column id="total_revenue"   title="Total Revenue (Rp)"        fmt="#,##0"/>
    <Column id="avg_order_value" title="Rata-rata Nilai Order (Rp)" fmt="#,##0"/>
</DataTable>

</div>

</Grid>

_Periode dengan rata-rata nilai order tinggi tapi volume rendah adalah peluang promo untuk mendorong traffic._

---

## Weekday vs Weekend (30 Hari Terakhir)

```sql weekday_vs_weekend
SELECT
    order_hour,
    CASE WHEN DAYOFWEEK(order_date) IN (1, 7) THEN 'Weekend' ELSE 'Weekday' END AS tipe_hari,
    SUM(total_orders)                                                             AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY order_hour, tipe_hari
ORDER BY order_hour, tipe_hari
```

```sql daypart_weekday_weekend
SELECT
    day_part                                                                      AS periode,
    CASE WHEN DAYOFWEEK(order_date) IN (1, 7) THEN 'Weekend' ELSE 'Weekday' END AS tipe_hari,
    SUM(total_orders)   AS total_orders,
    SUM(total_revenue)  AS total_revenue
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY day_part, tipe_hari
ORDER BY day_part, tipe_hari
```

<Grid cols=2>

<div>

### Pola Order per Jam

<BarChart
    data={weekday_vs_weekend}
    x="order_hour"
    y="total_orders"
    series="tipe_hari"
    type="grouped"
    title="Total Order per Jam — Weekday vs Weekend"
    xAxisTitle="Jam"
    yAxisTitle="Total Order"
/>

</div>

<div>

### Kontribusi per Periode

<BarChart
    data={daypart_weekday_weekend}
    x="periode"
    y="total_orders"
    series="tipe_hari"
    type="grouped"
    title="Periode — Weekday vs Weekend"
    xAxisTitle="Periode"
    yAxisTitle="Total Order"
/>

</div>

</Grid>

_Weekend biasanya menggeser pola traffic — jam makan siang lebih ramai dan dine-in meningkat. Kalau pola weekday dan weekend hampir sama, kemungkinan cabang berada di area transit atau perkantoran._

---

## Tipe Order per Jam (30 Hari Terakhir)

```sql order_type_hourly
SELECT
    order_hour,
    CASE order_type
        WHEN 'dine_in'  THEN 'Makan di Tempat'
        WHEN 'delivery' THEN 'Pesan Antar'
        WHEN 'takeaway' THEN 'Bawa Pulang'
        ELSE order_type
    END AS tipe_order,
    SUM(total_orders) AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY order_hour, order_type
ORDER BY order_hour
```

```sql order_type_by_branch
SELECT
    branch_name,
    day_part AS periode,
    CASE order_type
        WHEN 'dine_in'  THEN 'Makan di Tempat'
        WHEN 'delivery' THEN 'Pesan Antar'
        WHEN 'takeaway' THEN 'Bawa Pulang'
        ELSE order_type
    END AS tipe_order,
    SUM(total_orders) AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY branch_name, day_part, order_type
ORDER BY branch_name, day_part, order_type
```

<Grid cols=2>

<div>

### Tipe Order per Jam

<BarChart
    data={order_type_hourly}
    x="order_hour"
    y="total_orders"
    series="tipe_order"
    type="stacked"
    title="Makan di Tempat vs Pesan Antar vs Bawa Pulang per Jam"
    xAxisTitle="Jam"
    yAxisTitle="Total Order"
/>

</div>

<div>

### Detail per Cabang & Periode

<DataTable data={order_type_by_branch}>
    <Column id="branch_name"  title="Cabang"/>
    <Column id="periode"      title="Periode"/>
    <Column id="tipe_order"   title="Tipe Order"/>
    <Column id="total_orders" title="Total Order" fmt="#,##0"/>
</DataTable>

</div>

</Grid>

_Kalau Pesan Antar dominan di jam tertentu, pastikan kerjasama dengan platform ojol berjalan lancar. Kalau Makan di Tempat dominan, fokuskan kapasitas meja dan pelayanan._

---

## Jam Sibuk per Cabang (30 Hari Terakhir)

```sql peak_by_branch
SELECT
    branch_name,
    day_part AS periode,
    SUM(total_orders) AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY branch_name, day_part
ORDER BY branch_name, total_orders DESC
```

<BarChart
    data={peak_by_branch}
    x="periode"
    y="total_orders"
    series="branch_name"
    type="grouped"
    title="Distribusi Periode per Cabang"
    xAxisTitle="Periode"
    yAxisTitle="Total Order"
/>

_Tiap cabang bisa punya jam sibuk yang berbeda tergantung lokasi dan demografi pelanggan. Jadikan data ini dasar penjadwalan staf per cabang._

---

## Prediksi Jam Sibuk Besok

```sql besok
SELECT
    DAY(CURRENT_DATE + INTERVAL '1 day') || ' ' ||
    CASE MONTH(CURRENT_DATE + INTERVAL '1 day')
        WHEN 1 THEN 'Januari' WHEN 2 THEN 'Februari' WHEN 3 THEN 'Maret'
        WHEN 4 THEN 'April' WHEN 5 THEN 'Mei' WHEN 6 THEN 'Juni'
        WHEN 7 THEN 'Juli' WHEN 8 THEN 'Agustus' WHEN 9 THEN 'September'
        WHEN 10 THEN 'Oktober' WHEN 11 THEN 'November' WHEN 12 THEN 'Desember'
    END || ' ' ||
    YEAR(CURRENT_DATE + INTERVAL '1 day')   AS tanggal_besok,
    CASE DAYNAME(CURRENT_DATE + INTERVAL '1 day')
        WHEN 'Monday'    THEN 'Senin'
        WHEN 'Tuesday'   THEN 'Selasa'
        WHEN 'Wednesday' THEN 'Rabu'
        WHEN 'Thursday'  THEN 'Kamis'
        WHEN 'Friday'    THEN 'Jumat'
        WHEN 'Saturday'  THEN 'Sabtu'
        WHEN 'Sunday'    THEN 'Minggu'
    END                                      AS nama_hari
FROM (SELECT 1) t
```

```sql prediksi_besok
SELECT
    order_hour,
    branch_name,
    ROUND(AVG(daily_total), 0) AS prediksi_order
FROM (
    SELECT
        order_date,
        order_hour,
        branch_name,
        SUM(total_orders) AS daily_total
    FROM restaurant.peak_hours
    WHERE DAYNAME(order_date) = DAYNAME(CURRENT_DATE + INTERVAL '1 day')
      AND order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
    GROUP BY order_date, order_hour, branch_name
)
GROUP BY order_hour, branch_name
ORDER BY order_hour, branch_name
```

### {besok[0].tanggal_besok} — {besok[0].nama_hari}

<BarChart
    data={prediksi_besok}
    x="order_hour"
    y="prediksi_order"
    series="branch_name"
    type="stacked"
    title="Prediksi Total Order per Jam Besok — per Cabang"
    xAxisTitle="Jam"
    yAxisTitle="Prediksi Total Order"
/>

_Prediksi berdasarkan rata-rata order di hari {besok[0].nama_hari} dalam 30 hari terakhir. Gunakan ini untuk merencanakan jumlah staf dan persiapan stok sehari sebelumnya._
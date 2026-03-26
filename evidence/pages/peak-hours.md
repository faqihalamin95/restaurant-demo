---
title: Analisis Jam Sibuk
---

_Ketahui kapan pelanggan datang dan optimalkan operasional restoranmu._

```sql peak_summary
SELECT
    day_part                                                            AS periode_tersibuk,
    SUM(total_orders)                                                   AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY day_part
ORDER BY total_orders DESC
LIMIT 1
```

```sql peak_hour_summary
SELECT
    order_hour                                                          AS jam_tersibuk,
    SUM(total_orders)                                                   AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY order_hour
ORDER BY total_orders DESC
LIMIT 1
```

```sql peak_order_type
SELECT
    order_type                                                          AS tipe_terbanyak,
    SUM(total_orders)                                                   AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY order_type
ORDER BY total_orders DESC
LIMIT 1
```

<BigValue
    data={peak_summary}
    value="periode_tersibuk"
    title="Periode Tersibuk (30 Hari Terakhir)"
/>

<BigValue
    data={peak_hour_summary}
    value="jam_tersibuk"
    title="Jam Tersibuk (30 Hari Terakhir)"
/>

<BigValue
    data={peak_order_type}
    value="tipe_terbanyak"
    title="Tipe Order Terbanyak"
/>

---

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

## Prediksi Jam Sibuk — {besok[0].tanggal_besok} ({besok[0].nama_hari})

<BarChart
    data={prediksi_besok}
    x="order_hour"
    y="prediksi_order"
    series="branch_name"
    type="stacked"
    title="Prediksi Order per Jam Besok — per Cabang"
    xAxisTitle="Jam"
    yAxisTitle="Prediksi Total Order"
/>

_Prediksi berdasarkan rata-rata order di hari {besok[0].nama_hari} dalam 30 hari terakhir. Gunakan ini untuk merencanakan jumlah staf dan persiapan stok sehari sebelumnya — bukan prediksi pasti, tapi pola historis yang cukup andal untuk planning operasional._

---

## Distribusi Order per Jam — Semua Cabang (30 Hari Terakhir)

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

<BarChart
    data={hourly_all}
    x="order_hour"
    y="total_orders"
    series="day_part"
    title="Total Order per Jam"
    xAxisTitle="Jam"
    yAxisTitle="Total Order"
/>

_Jam dengan order tertinggi adalah momen kritis — pastikan staf penuh dan stok siap di jam-jam ini. Persiapan 30 menit sebelum jam sibuk biasanya sudah cukup untuk menghindari kehabisan menu._

---

## Jam Sibuk per Cabang (30 Hari Terakhir)

```sql peak_by_branch
SELECT
    branch_name,
    day_part,
    SUM(total_orders) AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY branch_name, day_part
ORDER BY branch_name, total_orders DESC
```

<BarChart
    data={peak_by_branch}
    x="day_part"
    y="total_orders"
    series="branch_name"
    title="Distribusi Periode per Cabang"
    type="grouped"
    xAxisTitle="Periode"
    yAxisTitle="Total Order"
/>

_Tiap cabang bisa punya jam sibuk yang berbeda tergantung lokasi dan demografi pelanggan. Jadikan data ini dasar penjadwalan staf per cabang — cabang di area perkantoran biasanya peak siang, cabang di area perumahan biasanya peak malam._

---

## Jenis Order per Jam (30 Hari Terakhir)

```sql order_type_hourly
SELECT
    order_hour,
    order_type,
    SUM(total_orders) AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY order_hour, order_type
ORDER BY order_hour
```

<BarChart
    data={order_type_hourly}
    x="order_hour"
    y="total_orders"
    series="order_type"
    type="stacked"
    title="Dine-in vs Delivery vs Takeaway per Jam"
    xAxisTitle="Jam"
    yAxisTitle="Total Order"
/>

_Kalau order jenis delivery yang dominan, pastikan kerjasama dengan platform ojol berjalan lancar di jam tersebut. Sebaliknya, kalau order jenis dine-in yang dominan, fokuskan kapasitas meja dan pelayanan di jam tersebut._

```sql order_type_by_branch
SELECT
    branch_name,
    day_part,
    order_type,
    SUM(total_orders) AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY branch_name, day_part, order_type
ORDER BY branch_name, day_part, order_type
```

<DataTable data={order_type_by_branch}>
    <Column id="branch_name" title="Cabang"/>
    <Column id="day_part" title="Periode"/>
    <Column id="order_type" title="Tipe Order"/>
    <Column id="total_orders" title="Total Order" fmt="#,##0"/>
</DataTable>

_Detail jenis order per cabang per periode — gunakan ini untuk mengoptimalkan alokasi staf dan kapasitas per tipe layanan di tiap cabang._

---

## Ringkasan per Periode (30 Hari Terakhir)

```sql daypart_summary
SELECT
    day_part,
    SUM(total_orders)                                                   AS total_orders,
    SUM(total_revenue)                                                  AS total_revenue,
    ROUND(SUM(total_revenue) / NULLIF(SUM(total_orders), 0), 0)         AS avg_order_value
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '30 days'
GROUP BY day_part
ORDER BY total_orders DESC
```

<DataTable data={daypart_summary}>
    <Column id="day_part" title="Periode"/>
    <Column id="total_orders" title="Total Order" fmt="#,##0"/>
    <Column id="total_revenue" title="Total Revenue (Rp)" fmt="#,##0"/>
    <Column id="avg_order_value" title="Rata-rata Nilai Order (Rp)" fmt="#,##0"/>
</DataTable>

_Periode dengan rata-rata nilai order tinggi tapi volume rendah adalah peluang — coba dorong traffic di jam tersebut lewat promo atau diskon khusus._
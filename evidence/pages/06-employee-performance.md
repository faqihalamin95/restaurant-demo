---
title: Performa Pegawai
---

_Analisis produktivitas pegawai berdasarkan transaksi yang ditangani, shift kerja, dan histori absensi._

```sql employee_summary_30d
SELECT
    COUNT(DISTINCT employee_id) AS total_pegawai,
    SUM(orders_handled)         AS total_order_ditangani,
    SUM(total_revenue)          AS total_revenue_ditangani,
    ROUND(AVG(avg_ticket), 0)   AS avg_ticket
FROM restaurant.employee_shift_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.employee_shift_performance) - INTERVAL '30 days'
```

<BigValue data={employee_summary_30d} value="total_pegawai"           title="Total Pegawai Aktif" />
<BigValue data={employee_summary_30d} value="total_order_ditangani"   title="Order Ditangani (30 Hari)"   fmt="#,##0" />
<BigValue data={employee_summary_30d} value="total_revenue_ditangani" title="Revenue Ditangani (Rp)"      fmt="#,##0" />
<BigValue data={employee_summary_30d} value="avg_ticket"              title="Rata-rata Nilai Order  (Rp)"       fmt="#,##0" />

---

## Distribusi Absensi Pegawai (30 Hari Terakhir)

```sql attendance_mix_30d
SELECT
    attendance_status,
    COUNT(*) AS total_hari
FROM restaurant.employee_shift_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.employee_shift_performance) - INTERVAL '30 days'
GROUP BY 1
ORDER BY 2 DESC
```

```sql attendance_by_branch
SELECT
    branch_name,
    attendance_status,
    COUNT(*) AS total_hari
FROM restaurant.employee_shift_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.employee_shift_performance) - INTERVAL '30 days'
GROUP BY 1, 2
ORDER BY branch_name, total_hari DESC
```

<Grid cols=2>

<div>

### Keseluruhan

<BarChart
    data={attendance_mix_30d}
    x="attendance_status"
    y="total_hari"
    title="Status Absensi — Semua Cabang"
    xAxisTitle="Status"
    yAxisTitle="Jumlah Hari"
/>

</div>

<div>

### Per Cabang

<BarChart
    data={attendance_by_branch}
    x="branch_name"
    y="total_hari"
    series="attendance_status"
    title="Status Absensi per Cabang"
    xAxisTitle="Cabang"
    yAxisTitle="Jumlah Hari"
/>

</div>

</Grid>

_`present`(kehadiran) dan `late`(keterlambatan) adalah hari kerja aktif. `off` adalah hari libur terjadwal pegawai. `absent` dan `leave`(cuti) adalah ketidakhadiran di luar jadwal libur — angka ini yang perlu diperhatikan._

---

## Performa per Shift (30 Hari Terakhir)

```sql shift_performance_30d
SELECT
    shift_name,
    SUM(orders_handled)       AS total_orders,
    SUM(total_revenue)        AS total_revenue,
    ROUND(AVG(avg_ticket), 0) AS avg_ticket
FROM restaurant.employee_shift_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.employee_shift_performance) - INTERVAL '30 days'
GROUP BY 1
ORDER BY total_revenue DESC
```

```sql shift_wow
SELECT
    shift_name,
    SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.employee_shift_performance) - INTERVAL '6 days'
        THEN orders_handled END)                                             AS orders_minggu_ini,
    SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.employee_shift_performance) - INTERVAL '13 days'
         AND order_date < (SELECT MAX(order_date) FROM restaurant.employee_shift_performance) - INTERVAL '6 days'
        THEN orders_handled END)                                             AS orders_minggu_lalu,
    ROUND(
        (SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.employee_shift_performance) - INTERVAL '6 days'
            THEN orders_handled END)
        - SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.employee_shift_performance) - INTERVAL '13 days'
             AND order_date < (SELECT MAX(order_date) FROM restaurant.employee_shift_performance) - INTERVAL '6 days'
            THEN orders_handled END))
        / NULLIF(SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.employee_shift_performance) - INTERVAL '13 days'
             AND order_date < (SELECT MAX(order_date) FROM restaurant.employee_shift_performance) - INTERVAL '6 days'
            THEN orders_handled END), 0) * 100
    , 1)                                                                     AS pct_change
FROM restaurant.employee_shift_performance
GROUP BY 1
ORDER BY shift_name
```

<Grid cols=2>

<div>

### Revenue per Shift

<BarChart
    data={shift_performance_30d}
    x="shift_name"
    y="total_revenue"
    title="Revenue per Shift (30 Hari)"
    yFmt="#,##0"
    xAxisTitle="Shift"
    yAxisTitle="Revenue (Rp)"
/>

</div>

<div>

### Perbandingan Minggu Ini vs Minggu Lalu

<DataTable data={shift_wow}>
    <Column id="shift_name"         title="Shift"/>
    <Column id="orders_minggu_ini"  title="Minggu Ini"    fmt="#,##0"/>
    <Column id="orders_minggu_lalu" title="Minggu Lalu"   fmt="#,##0"/>
    <Column id="pct_change"         title="Perubahan (%)" fmt="+0.0;-0.0" contentType="delta"/>
</DataTable>

</div>

</Grid>

<DataTable data={shift_performance_30d}>
    <Column id="shift_name"    title="Shift"/>
    <Column id="total_orders"  title="Total Orders"       fmt="#,##0"/>
    <Column id="total_revenue" title="Total Revenue (Rp)" fmt="#,##0"/>
    <Column id="avg_ticket"    title="Rata-rata Nilai Order (Rp)"    fmt="#,##0"/>
</DataTable>

_Shift dengan rata-rata nilai order  tinggi menunjukkan pegawai berhasil mendorong pembelian item bernilai lebih besar. Shift dengan volume order tinggi tapi rata-rata nilai order  rendah bisa jadi kandidat program upselling._

---

## Top Pegawai — Revenue Ditangani (30 Hari Terakhir)

```sql top_employee_30d
SELECT
    employee_name,
    role,
    branch_name,
    shift_name,
    SUM(orders_handled)                                            AS orders_handled,
    SUM(total_revenue)                                             AS total_revenue,
    ROUND(AVG(avg_ticket), 0)                                      AS avg_ticket,
    SUM(CASE WHEN attendance_status = 'late'   THEN 1 ELSE 0 END) AS total_terlambat,
    SUM(CASE WHEN attendance_status = 'absent' THEN 1 ELSE 0 END) AS total_absent
FROM restaurant.employee_shift_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.employee_shift_performance) - INTERVAL '30 days'
GROUP BY 1, 2, 3, 4
ORDER BY total_revenue DESC
LIMIT 20
```

<DataTable data={top_employee_30d} rows=20>
    <Column id="employee_name"   title="Pegawai"/>
    <Column id="role"            title="Role"/>
    <Column id="branch_name"     title="Cabang"/>
    <Column id="shift_name"      title="Shift"/>
    <Column id="orders_handled"  title="Orders Ditangani"      fmt="#,##0"/>
    <Column id="total_revenue"   title="Revenue Ditangani (Rp)" fmt="#,##0"/>
    <Column id="avg_ticket"      title="Rata-rata Nilai Order (Rp)"        fmt="#,##0"/>
    <Column id="total_terlambat" title="Terlambat"              fmt="#,##0"/>
    <Column id="total_absent"    title="Absent"                 fmt="#,##0"/>
</DataTable>

_Revenue ditangani bukan satu-satunya ukuran — perhatikan kombinasi rata-rata nilai order  dan konsistensi kehadiran untuk menilai performa pegawai secara menyeluruh._

---

## Pegawai dengan Kehadiran Bermasalah (30 Hari Terakhir)

```sql attendance_problem
SELECT
    employee_name,
    role,
    branch_name,
    SUM(CASE WHEN attendance_status = 'absent' THEN 1 ELSE 0 END) AS total_absent,
    SUM(CASE WHEN attendance_status = 'late'   THEN 1 ELSE 0 END) AS total_terlambat,
    SUM(CASE WHEN attendance_status = 'leave'  THEN 1 ELSE 0 END) AS total_cuti,
    COUNT(*)                                                        AS total_hari_kerja
FROM restaurant.employee_shift_performance
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.employee_shift_performance) - INTERVAL '30 days'
GROUP BY 1, 2, 3
HAVING total_absent >= 2 OR total_terlambat >= 4
ORDER BY total_absent DESC, total_terlambat DESC
```

<DataTable data={attendance_problem}>
    <Column id="employee_name"    title="Pegawai"/>
    <Column id="role"             title="Role"/>
    <Column id="branch_name"      title="Cabang"/>
    <Column id="total_hari_kerja" title="Hari Kerja"  fmt="#,##0"/>
    <Column id="total_absent"     title="Absent"      fmt="#,##0"/>
    <Column id="total_terlambat"  title="Terlambat"   fmt="#,##0"/>
    <Column id="total_cuti"       title="Cuti"        fmt="#,##0"/>
</DataTable>

_Pegawai dengan absent ≥ 2 atau terlambat ≥ 4 dalam 30 hari terakhir. Tabel kosong berarti tidak ada masalah kehadiran signifikan — kondisi ideal._
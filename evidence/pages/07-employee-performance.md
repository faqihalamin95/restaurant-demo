---
title: Performa Pegawai
---

_Analisis produktivitas pegawai berdasarkan transaksi yang ditangani, shift kerja, dan histori absensi._

```sql periode_30d
SELECT
    strftime('%d %b %Y', MAX(attendance_date) - INTERVAL '29 days') AS tgl_awal,
    strftime('%d %b %Y', MAX(attendance_date))                       AS tgl_akhir
FROM restaurant.employee_shift_performance
```

```sql employee_summary_30d
SELECT
    COUNT(DISTINCT employee_id)  AS total_pegawai,
    SUM(orders_handled)          AS total_order_ditangani,
    SUM(total_revenue)           AS total_revenue_ditangani,
    ROUND(SUM(total_revenue) / NULLIF(SUM(orders_handled), 0), 0) AS avg_order_value
FROM restaurant.employee_shift_performance
WHERE attendance_date >= (SELECT MAX(attendance_date) FROM restaurant.employee_shift_performance) - INTERVAL '30 days'
```

```sql attendance_alert_today
SELECT COUNT(*) AS jumlah_absent
FROM restaurant.employee_shift_performance
WHERE attendance_date = (SELECT MAX(attendance_date) FROM restaurant.employee_shift_performance)
  AND attendance_status = 'absent'
```

```sql attendance_problem_count
SELECT COUNT(DISTINCT employee_name) AS jumlah_bermasalah
FROM (
    SELECT employee_name
    FROM restaurant.employee_shift_performance
    WHERE attendance_date >= (SELECT MAX(attendance_date) FROM restaurant.employee_shift_performance) - INTERVAL '30 days'
    GROUP BY employee_name
    HAVING
        SUM(CASE WHEN attendance_status = 'absent' THEN 1 ELSE 0 END) >= 2
        OR SUM(CASE WHEN attendance_status = 'late'   THEN 1 ELSE 0 END) >= 4
)
```

---

## Ringkasan 30 Hari Terakhir

<span style="font-size:0.85em;color:var(--color-text-secondary)">{periode_30d[0].tgl_awal} – {periode_30d[0].tgl_akhir}</span>

_Ringkasan kumulatif performa pegawai dalam 30 hari terakhir — patokan kondisi operasional terkini sebelum melihat tren._

<BigValue data={employee_summary_30d} value="total_pegawai"           title="Total Pegawai Aktif" />
<BigValue data={employee_summary_30d} value="total_order_ditangani"   title="Order Ditangani (30 Hari)"    fmt="#,##0" />
<BigValue data={employee_summary_30d} value="total_revenue_ditangani" title="Revenue Ditangani (Rp)"       fmt="#,##0" />
<BigValue data={employee_summary_30d} value="avg_order_value"         title="Rata-rata Nilai Order (Rp)"   fmt="#,##0" />

{#if attendance_problem_count[0].jumlah_bermasalah > 0}
<div style="background: rgba(220,38,38,0.08); border-left: 4px solid #dc2626; padding: 12px 16px; border-radius: 6px; margin: 16px 0;">
🚨 <strong>{attendance_problem_count[0].jumlah_bermasalah} pegawai</strong> dengan kehadiran bermasalah dalam 30 hari terakhir — absent ≥ 2 atau terlambat ≥ 4 kali. Detail ada di bagian bawah halaman ini.
</div>
{:else if attendance_alert_today[0].jumlah_absent >= 3}
<div style="background: rgba(248,201,0,0.1); border-left: 4px solid #f8c900; padding: 12px 16px; border-radius: 6px; margin: 16px 0;">
⚠️ <strong>{attendance_alert_today[0].jumlah_absent} pegawai tidak hadir</strong> kemarin. Pastikan tidak ada shift yang kekurangan staf.
</div>
{:else}
<div style="background: rgba(22,163,74,0.08); border-left: 4px solid #16a34a; padding: 12px 16px; border-radius: 6px; margin: 16px 0;">
✅ <strong>Kehadiran normal.</strong> Tidak ada pegawai dengan pola absensi bermasalah dalam 30 hari terakhir.
</div>
{/if}

---

## Distribusi Absensi Pegawai (30 Hari Terakhir)

```sql attendance_mix_30d
SELECT
    attendance_status,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct
FROM restaurant.employee_shift_performance
WHERE attendance_date >= (SELECT MAX(attendance_date) FROM restaurant.employee_shift_performance) - INTERVAL '30 days'
GROUP BY 1
ORDER BY 2 DESC
```

```sql attendance_by_branch
SELECT
    branch_name,
    attendance_status,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY branch_name), 1) AS pct
FROM restaurant.employee_shift_performance
WHERE attendance_date >= (SELECT MAX(attendance_date) FROM restaurant.employee_shift_performance) - INTERVAL '30 days'
GROUP BY 1, 2
ORDER BY branch_name, pct DESC
```

<Grid cols=2>
<div>

### Keseluruhan

<BarChart
    data={attendance_mix_30d}
    x="attendance_status"
    y="pct"
    yFmt="0.0\%"
    title="Status Absensi — Semua Cabang"
    xAxisTitle="Status"
    yAxisTitle="Persentase (%)"
/>

</div>
<div>

### Per Cabang

<BarChart
    data={attendance_by_branch}
    x="branch_name"
    y="pct"
    yFmt="0.0\%"
    series="attendance_status"
    title="Status Absensi per Cabang"
    xAxisTitle="Cabang"
    yAxisTitle="Persentase (%)"
/>

</div>
</Grid>

_`present` dan `late` adalah hari kerja aktif. `absent` dan `leave` adalah ketidakhadiran — angka ini yang perlu diperhatikan._

---

## Tren Kehadiran Harian (30 Hari Terakhir)

_Apakah absensi minggu ini lebih buruk dari minggu lalu? Adakah hari tertentu yang konsisten bermasalah?_

```sql attendance_daily_trend
SELECT
    attendance_date,
    SUM(CASE WHEN attendance_status = 'present' THEN 1 ELSE 0 END) AS present,
    SUM(CASE WHEN attendance_status = 'late'    THEN 1 ELSE 0 END) AS late,
    SUM(CASE WHEN attendance_status = 'absent'  THEN 1 ELSE 0 END) AS absent,
    SUM(CASE WHEN attendance_status = 'leave'   THEN 1 ELSE 0 END) AS cuti,
    ROUND(
        (SUM(CASE WHEN attendance_status IN ('absent', 'leave') THEN 1 ELSE 0 END) * 100.0)
        / NULLIF(COUNT(*), 0)
    , 1) AS pct_tidak_hadir
FROM restaurant.employee_shift_performance
WHERE attendance_date >= (SELECT MAX(attendance_date) FROM restaurant.employee_shift_performance) - INTERVAL '30 days'
GROUP BY 1
ORDER BY 1
```

```sql attendance_by_dayofweek
SELECT
    DAYNAME(attendance_date)    AS nama_hari,
    DAYOFWEEK(attendance_date)  AS urutan_hari,
    ROUND(AVG(CASE WHEN attendance_status = 'absent' THEN 1.0 ELSE 0 END) * 100, 1) AS avg_pct_absent,
    ROUND(AVG(CASE WHEN attendance_status = 'late'   THEN 1.0 ELSE 0 END) * 100, 1) AS avg_pct_late
FROM restaurant.employee_shift_performance
WHERE attendance_date >= (SELECT MAX(attendance_date) FROM restaurant.employee_shift_performance) - INTERVAL '30 days'
GROUP BY 1, 2
ORDER BY 2
```

```sql attendance_wow
SELECT
    SUM(CASE WHEN attendance_date >= (SELECT MAX(attendance_date) FROM restaurant.employee_shift_performance) - INTERVAL '6 days'
         AND attendance_status = 'absent' THEN 1 ELSE 0 END) AS absent_minggu_ini,
    SUM(CASE WHEN attendance_date >= (SELECT MAX(attendance_date) FROM restaurant.employee_shift_performance) - INTERVAL '13 days'
         AND attendance_date <  (SELECT MAX(attendance_date) FROM restaurant.employee_shift_performance) - INTERVAL '6 days'
         AND attendance_status = 'absent' THEN 1 ELSE 0 END) AS absent_minggu_lalu,
    SUM(CASE WHEN attendance_date >= (SELECT MAX(attendance_date) FROM restaurant.employee_shift_performance) - INTERVAL '6 days'
         AND attendance_status = 'late' THEN 1 ELSE 0 END)   AS late_minggu_ini,
    SUM(CASE WHEN attendance_date >= (SELECT MAX(attendance_date) FROM restaurant.employee_shift_performance) - INTERVAL '13 days'
         AND attendance_date <  (SELECT MAX(attendance_date) FROM restaurant.employee_shift_performance) - INTERVAL '6 days'
         AND attendance_status = 'late' THEN 1 ELSE 0 END)   AS late_minggu_lalu
FROM restaurant.employee_shift_performance
```

<Grid cols=2>
<div>

### Tren % Tidak Hadir Harian

<LineChart
    data={attendance_daily_trend}
    x="attendance_date"
    y="pct_tidak_hadir"
    title="% Tidak Hadir (Absent + Cuti) per Hari"
    yFmt="0.0\%"
    xAxisTitle="Tanggal"
    yAxisTitle="% Tidak Hadir"
/>

</div>
<div>

### Pola per Hari dalam Seminggu

<BarChart
    data={attendance_by_dayofweek}
    x="nama_hari"
    y={["avg_pct_absent", "avg_pct_late"]}
    type="grouped"
    title="Rata-rata % Absent & Terlambat per Hari"
    yFmt="0.0\%"
    xAxisTitle="Hari"
    yAxisTitle="Rata-rata (%)"
/>

</div>
</Grid>

<DataTable data={attendance_wow}>
    <Column id="absent_minggu_lalu" title="Absent Minggu Lalu" fmt="#,##0"/>
    <Column id="absent_minggu_ini"  title="Absent Minggu Ini"  fmt="#,##0"/>
    <Column id="late_minggu_lalu"   title="Terlambat Minggu Lalu" fmt="#,##0"/>
    <Column id="late_minggu_ini"    title="Terlambat Minggu Ini"  fmt="#,##0"/>
</DataTable>

_Grafik tren memperlihatkan apakah ada lonjakan absensi di periode tertentu. Pola per hari membantu mengidentifikasi hari "rawan" — misalnya Senin atau Jumat yang konsisten punya absensi lebih tinggi._

---

## Performa per Shift (30 Hari Terakhir)

```sql shift_performance_30d
SELECT
    shift_name,
    SUM(orders_handled)       AS total_orders,
    SUM(total_revenue)        AS total_revenue,
    ROUND(SUM(total_revenue) / NULLIF(SUM(orders_handled), 0), 0) AS avg_order_value
FROM restaurant.employee_shift_performance
WHERE attendance_date >= (SELECT MAX(attendance_date) FROM restaurant.employee_shift_performance) - INTERVAL '30 days'
GROUP BY 1
ORDER BY total_revenue DESC
```

```sql shift_wow
WITH max_date AS (
    SELECT MAX(attendance_date) AS d FROM restaurant.employee_shift_performance
)
SELECT
    shift_name,
    SUM(CASE WHEN attendance_date >= (SELECT d FROM max_date) - INTERVAL '6 days'
        THEN orders_handled END)                                                        AS orders_minggu_ini,
    SUM(CASE WHEN attendance_date <  (SELECT d FROM max_date) - INTERVAL '6 days'
         AND  attendance_date >= (SELECT d FROM max_date) - INTERVAL '13 days'
        THEN orders_handled END)                                                        AS orders_minggu_lalu,
    ROUND(
        (SUM(CASE WHEN attendance_date >= (SELECT d FROM max_date) - INTERVAL '6 days'
            THEN orders_handled END)
        - SUM(CASE WHEN attendance_date <  (SELECT d FROM max_date) - INTERVAL '6 days'
             AND   attendance_date >= (SELECT d FROM max_date) - INTERVAL '13 days'
            THEN orders_handled END))
        / NULLIF(SUM(CASE WHEN attendance_date <  (SELECT d FROM max_date) - INTERVAL '6 days'
             AND  attendance_date >= (SELECT d FROM max_date) - INTERVAL '13 days'
            THEN orders_handled END), 0) * 100
    , 1)                                                                                AS pct_change
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
    <Column id="total_orders"  title="Total Order"               fmt="#,##0"/>
    <Column id="total_revenue" title="Total Revenue (Rp)"        fmt="#,##0"/>
    <Column id="avg_order_value" title="Rata-rata Nilai Order (Rp)" fmt="#,##0"/>
</DataTable>

_Shift dengan rata-rata nilai order tinggi menunjukkan pegawai berhasil mendorong pembelian item bernilai lebih besar. Shift dengan volume order tinggi tapi rata-rata nilai order rendah adalah kandidat program upselling._

---

## Analisis Overtime (30 Hari Terakhir)

_Overtime tinggi di shift tertentu bisa jadi sinyal understaffing, bukan produktivitas tinggi. Jangan rayakan overtime — investigasi penyebabnya._

```sql overtime_by_shift
SELECT
    shift_name,
    COUNT(DISTINCT employee_id)                                                     AS total_pegawai,
    SUM(overtime_hours)                                                              AS total_overtime_hours,
    ROUND(AVG(overtime_hours), 2)                                                    AS avg_overtime_per_orang,
    SUM(CASE WHEN overtime_hours > 0 THEN 1 ELSE 0 END)                             AS jumlah_sesi_overtime,
    ROUND(SUM(CASE WHEN overtime_hours > 0 THEN 1 ELSE 0 END) * 100.0
          / NULLIF(COUNT(*), 0), 1)                                                  AS pct_sesi_overtime
FROM restaurant.employee_shift_performance
WHERE attendance_date >= (SELECT MAX(attendance_date) FROM restaurant.employee_shift_performance) - INTERVAL '30 days'
  AND attendance_status IN ('present', 'late')
GROUP BY 1
ORDER BY total_overtime_hours DESC
```

```sql overtime_by_branch
SELECT
    branch_name,
    SUM(overtime_hours)                                                             AS total_overtime_hours,
    ROUND(AVG(overtime_hours), 2)                                                   AS avg_overtime_per_orang,
    ROUND(SUM(CASE WHEN overtime_hours > 0 THEN 1 ELSE 0 END) * 100.0
          / NULLIF(COUNT(*), 0), 1)                                                 AS pct_sesi_overtime
FROM restaurant.employee_shift_performance
WHERE attendance_date >= (SELECT MAX(attendance_date) FROM restaurant.employee_shift_performance) - INTERVAL '30 days'
  AND attendance_status IN ('present', 'late')
GROUP BY 1
ORDER BY total_overtime_hours DESC
```

```sql overtime_trend
SELECT
    attendance_date,
    shift_name,
    SUM(overtime_hours) AS total_overtime_hours
FROM restaurant.employee_shift_performance
WHERE attendance_date >= (SELECT MAX(attendance_date) FROM restaurant.employee_shift_performance) - INTERVAL '30 days'
  AND overtime_hours > 0
GROUP BY 1, 2
ORDER BY 1, 2
```

```sql top_overtime_employees
SELECT
    employee_name,
    role,
    branch_name,
    shift_name,
    SUM(overtime_hours)                                     AS total_overtime_hours,
    COUNT(CASE WHEN overtime_hours > 0 THEN 1 END)          AS hari_overtime,
    ROUND(AVG(CASE WHEN overtime_hours > 0 THEN overtime_hours END), 1) AS avg_jam_per_sesi
FROM restaurant.employee_shift_performance
WHERE attendance_date >= (SELECT MAX(attendance_date) FROM restaurant.employee_shift_performance) - INTERVAL '30 days'
  AND attendance_status IN ('present', 'late')
GROUP BY 1, 2, 3, 4
HAVING SUM(overtime_hours) > 0
ORDER BY total_overtime_hours DESC
LIMIT 15
```

<Grid cols=2>
<div>

### Overtime per Shift

<BarChart
    data={overtime_by_shift}
    x="shift_name"
    y="total_overtime_hours"
    title="Total Jam Overtime per Shift (30 Hari)"
    xAxisTitle="Shift"
    yAxisTitle="Total Jam Overtime"
/>

</div>
<div>

### % Sesi Overtime per Cabang

<BarChart
    data={overtime_by_branch}
    x="branch_name"
    y="pct_sesi_overtime"
    title="% Sesi Kerja dengan Overtime per Cabang"
    yFmt="0.0\%"
    xAxisTitle="Cabang"
    yAxisTitle="% Sesi Overtime"
/>

</div>
</Grid>

<LineChart
    data={overtime_trend}
    x="attendance_date"
    y="total_overtime_hours"
    series="shift_name"
    title="Tren Jam Overtime Harian per Shift"
    xAxisTitle="Tanggal"
    yAxisTitle="Total Jam Overtime"
/>

<DataTable data={overtime_by_shift}>
    <Column id="shift_name"           title="Shift"/>
    <Column id="total_pegawai"        title="Total Pegawai"      fmt="#,##0"/>
    <Column id="total_overtime_hours" title="Total Jam Overtime" fmt="#,##0"/>
    <Column id="avg_overtime_per_orang" title="Rata-rata per Orang" fmt="0.00"/>
    <Column id="jumlah_sesi_overtime" title="Sesi Overtime"      fmt="#,##0"/>
    <Column id="pct_sesi_overtime"    title="% Sesi Overtime"    fmt="0.0\%"/>
</DataTable>

### Pegawai dengan Overtime Tertinggi

<DataTable data={top_overtime_employees}>
    <Column id="employee_name"        title="Pegawai"/>
    <Column id="role"                 title="Role"/>
    <Column id="branch_name"          title="Cabang"/>
    <Column id="shift_name"           title="Shift"/>
    <Column id="total_overtime_hours" title="Total Jam OT"    fmt="#,##0"/>
    <Column id="hari_overtime"        title="Hari OT"         fmt="#,##0"/>
    <Column id="avg_jam_per_sesi"     title="Avg Jam/Sesi"    fmt="0.0"/>
</DataTable>

_Shift atau cabang dengan % sesi overtime tinggi perlu dievaluasi kapasitas stafnya. Pegawai yang sering overtime bukan selalu yang paling produktif — bisa jadi mereka menanggung beban rekan yang sering absen._

---

## Performa per Role (30 Hari Terakhir)

_Kasir, pramusaji, dan supervisor punya fungsi berbeda — membandingkan performa tanpa memisahkan role adalah perbandingan apel dan jeruk._

```sql role_performance_30d
SELECT
    role,
    COUNT(DISTINCT employee_id)       AS total_pegawai,
    SUM(orders_handled)               AS total_orders,
    SUM(total_revenue)                AS total_revenue,
    ROUND(AVG(avg_ticket), 0)         AS avg_order_value,
    ROUND(SUM(orders_handled) * 1.0 / NULLIF(COUNT(DISTINCT employee_id), 0), 1) AS avg_order_per_orang,
    ROUND(AVG(CASE WHEN attendance_status = 'absent' THEN 1.0 ELSE 0 END) * 100, 1) AS pct_absent,
    ROUND(AVG(CASE WHEN attendance_status = 'late'   THEN 1.0 ELSE 0 END) * 100, 1) AS pct_late
FROM restaurant.employee_shift_performance
WHERE attendance_date >= (SELECT MAX(attendance_date) FROM restaurant.employee_shift_performance) - INTERVAL '30 days'
GROUP BY 1
ORDER BY total_revenue DESC
```

```sql attendance_by_role
SELECT
    role,
    attendance_status,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY role), 1) AS pct
FROM restaurant.employee_shift_performance
WHERE attendance_date >= (SELECT MAX(attendance_date) FROM restaurant.employee_shift_performance) - INTERVAL '30 days'
GROUP BY 1, 2
ORDER BY role, pct DESC
```

```sql overtime_by_role
SELECT
    role,
    SUM(overtime_hours)                                                              AS total_overtime_hours,
    ROUND(AVG(CASE WHEN overtime_hours > 0 THEN overtime_hours END), 1)              AS avg_jam_ot_per_sesi,
    ROUND(SUM(CASE WHEN overtime_hours > 0 THEN 1 ELSE 0 END) * 100.0
          / NULLIF(SUM(CASE WHEN attendance_status IN ('present','late') THEN 1 ELSE 0 END), 0), 1) AS pct_sesi_overtime
FROM restaurant.employee_shift_performance
WHERE attendance_date >= (SELECT MAX(attendance_date) FROM restaurant.employee_shift_performance) - INTERVAL '30 days'
GROUP BY 1
ORDER BY total_overtime_hours DESC
```

<Grid cols=2>
<div>

### Absensi per Role

<BarChart
    data={attendance_by_role}
    x="role"
    y="pct"
    series="attendance_status"
    type="stacked"
    title="Distribusi Status Absensi per Role"
    yFmt="0.0\%"
    xAxisTitle="Role"
    yAxisTitle="Persentase (%)"
/>

</div>
<div>

### Overtime per Role

<BarChart
    data={overtime_by_role}
    x="role"
    y="pct_sesi_overtime"
    title="% Sesi Overtime per Role"
    yFmt="0.0\%"
    xAxisTitle="Role"
    yAxisTitle="% Sesi Overtime"
/>

</div>
</Grid>

<DataTable data={role_performance_30d}>
    <Column id="role"                 title="Role"/>
    <Column id="total_pegawai"        title="Jumlah Pegawai"              fmt="#,##0"/>
    <Column id="total_orders"         title="Total Order"                 fmt="#,##0"/>
    <Column id="avg_order_per_orang"  title="Order per Orang"             fmt="0.0"/>
    <Column id="total_revenue"        title="Revenue (Rp)"                fmt="#,##0"/>
    <Column id="avg_order_value"      title="Rata-rata Nilai Order (Rp)"  fmt="#,##0"/>
    <Column id="pct_absent"           title="% Absent"                    fmt="0.0\%"/>
    <Column id="pct_late"             title="% Terlambat"                 fmt="0.0\%"/>
</DataTable>

_Supervisor yang sering absent berdampak lebih besar dari kasir yang absent — dampaknya ke koordinasi seluruh tim. Perhatikan % absent dan % overtime per role secara terpisah untuk tindakan yang lebih tepat sasaran._

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
    ROUND(SUM(total_revenue) / NULLIF(SUM(orders_handled), 0), 0) AS avg_order_value,
    SUM(CASE WHEN attendance_status = 'late'   THEN 1 ELSE 0 END) AS total_terlambat,
    SUM(CASE WHEN attendance_status = 'absent' THEN 1 ELSE 0 END) AS total_absent,
    SUM(overtime_hours)                                            AS total_overtime_hours
FROM restaurant.employee_shift_performance
WHERE attendance_date >= (SELECT MAX(attendance_date) FROM restaurant.employee_shift_performance) - INTERVAL '30 days'
GROUP BY 1, 2, 3, 4
ORDER BY total_revenue DESC
LIMIT 20
```

<DataTable data={top_employee_30d} rows=20>
    <Column id="employee_name"       title="Pegawai"/>
    <Column id="role"                title="Role"/>
    <Column id="branch_name"         title="Cabang"/>
    <Column id="shift_name"          title="Shift"/>
    <Column id="orders_handled"      title="Order Ditangani"            fmt="#,##0"/>
    <Column id="total_revenue"       title="Revenue Ditangani (Rp)"     fmt="#,##0"/>
    <Column id="avg_order_value"     title="Rata-rata Nilai Order (Rp)" fmt="#,##0"/>
    <Column id="total_overtime_hours" title="Jam OT"                   fmt="#,##0"/>
    <Column id="total_terlambat"     title="Terlambat"                  fmt="#,##0"/>
    <Column id="total_absent"        title="Absent"                     fmt="#,##0"/>
</DataTable>

_Revenue ditangani bukan satu-satunya ukuran — perhatikan kombinasi rata-rata nilai order dan konsistensi kehadiran. Kolom Jam OT ditambahkan: pegawai dengan revenue tinggi tapi OT banyak mungkin sedang menanggung beban berlebih._

---

## Revenue per Jam Kerja — Normalisasi antar Shift

_Pegawai shift malam selalu kalah di total revenue karena jam operasional lebih pendek — bukan karena performanya lebih buruk. Gunakan metrik ini untuk perbandingan yang adil._

```sql revenue_per_hour
WITH shift_hours AS (
    SELECT
        shift_id,
        shift_name,
        CASE shift_id
            WHEN 'S1' THEN 7   -- Pagi: 7 jam efektif
            WHEN 'S2' THEN 8   -- Siang: 8 jam efektif
            WHEN 'S3' THEN 7   -- Malam: 7 jam efektif
            ELSE 7
        END AS shift_duration_hours
    FROM (SELECT DISTINCT shift_id, shift_name FROM restaurant.employee_shift_performance)
),

employee_stats AS (
    SELECT
        e.employee_name,
        e.role,
        e.branch_name,
        e.shift_name,
        e.shift_id,
        COUNT(CASE WHEN e.attendance_status IN ('present', 'late') THEN 1 END) AS hari_hadir,
        SUM(e.orders_handled)   AS total_orders,
        SUM(e.total_revenue)    AS total_revenue,
        ROUND(AVG(e.avg_ticket), 0) AS avg_ticket
    FROM restaurant.employee_shift_performance e
    WHERE attendance_date >= (SELECT MAX(attendance_date) FROM restaurant.employee_shift_performance) - INTERVAL '30 days'
    GROUP BY 1, 2, 3, 4, 5
    HAVING hari_hadir > 0
)

SELECT
    es.employee_name,
    es.role,
    es.branch_name,
    es.shift_name,
    es.hari_hadir,
    es.total_orders,
    es.total_revenue,
    es.avg_ticket,
    es.hari_hadir * sh.shift_duration_hours                                   AS estimasi_total_jam,
    ROUND(es.total_revenue / NULLIF(es.hari_hadir * sh.shift_duration_hours, 0), 0) AS revenue_per_jam,
    ROUND(es.total_orders  / NULLIF(es.hari_hadir * sh.shift_duration_hours, 0), 2) AS order_per_jam
FROM employee_stats es
LEFT JOIN shift_hours sh ON es.shift_id = sh.shift_id
ORDER BY revenue_per_jam DESC
LIMIT 20
```

```sql revenue_per_hour_by_shift
WITH shift_hours AS (
    SELECT
        shift_id,
        shift_name,
        CASE shift_id
            WHEN 'S1' THEN 7
            WHEN 'S2' THEN 8
            WHEN 'S3' THEN 7
            ELSE 7
        END AS shift_duration_hours
    FROM (SELECT DISTINCT shift_id, shift_name FROM restaurant.employee_shift_performance)
),

employee_stats AS (
    SELECT
        e.shift_id,
        e.shift_name,
        e.role,
        COUNT(CASE WHEN e.attendance_status IN ('present', 'late') THEN 1 END) AS hari_hadir,
        SUM(e.total_revenue)    AS total_revenue
    FROM restaurant.employee_shift_performance e
    WHERE attendance_date >= (SELECT MAX(attendance_date) FROM restaurant.employee_shift_performance) - INTERVAL '30 days'
    GROUP BY 1, 2, 3
    HAVING hari_hadir > 0
)

SELECT
    es.shift_name,
    es.role,
    ROUND(SUM(es.total_revenue) / NULLIF(SUM(es.hari_hadir * sh.shift_duration_hours), 0), 0) AS revenue_per_jam
FROM employee_stats es
LEFT JOIN shift_hours sh ON es.shift_id = sh.shift_id
GROUP BY 1, 2
ORDER BY revenue_per_jam DESC
```

<Grid cols=2>
<div>

### Revenue per Jam per Shift & Role

<BarChart
    data={revenue_per_hour_by_shift}
    x="shift_name"
    y="revenue_per_jam"
    series="role"
    type="grouped"
    title="Revenue per Jam Kerja (Rp) — Shift × Role"
    yFmt="#,##0"
    xAxisTitle="Shift"
    yAxisTitle="Revenue per Jam (Rp)"
/>

</div>
<div>

_Metrik ini menyeimbangkan perbedaan durasi shift — satu jam kerja dari shift Pagi dan shift Malam kini bisa dibandingkan secara adil. Gap besar antar role dalam shift yang sama menunjukkan perbedaan produktivitas nyata, bukan artefak jadwal._

</div>
</Grid>

### Top 20 Pegawai — Revenue per Jam Tertinggi

<DataTable data={revenue_per_hour} rows=20>
    <Column id="employee_name"       title="Pegawai"/>
    <Column id="role"                title="Role"/>
    <Column id="branch_name"         title="Cabang"/>
    <Column id="shift_name"          title="Shift"/>
    <Column id="hari_hadir"          title="Hari Hadir"               fmt="#,##0"/>
    <Column id="estimasi_total_jam"  title="Estimasi Jam Kerja"       fmt="#,##0"/>
    <Column id="total_revenue"       title="Total Revenue (Rp)"       fmt="#,##0"/>
    <Column id="revenue_per_jam"     title="Revenue per Jam (Rp) ↑"  fmt="#,##0"/>
    <Column id="order_per_jam"       title="Order per Jam"            fmt="0.00"/>
    <Column id="avg_ticket"          title="Rata-rata Nilai Order"    fmt="#,##0"/>
</DataTable>

_Pegawai di urutan atas adalah kontributor nyata per unit waktu — bukan sekadar yang paling banyak jam kerja atau yang kebetulan dapat shift sibuk. Gunakan ini untuk keputusan pengembangan karier dan insentif._

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
WHERE attendance_date >= (SELECT MAX(attendance_date) FROM restaurant.employee_shift_performance) - INTERVAL '30 days'
GROUP BY 1, 2, 3
HAVING
    SUM(CASE WHEN attendance_status = 'absent' THEN 1 ELSE 0 END) >= 2
    OR SUM(CASE WHEN attendance_status = 'late' THEN 1 ELSE 0 END) >= 4
ORDER BY total_absent DESC, total_terlambat DESC
```

_Pegawai dengan absent ≥ 2 atau terlambat ≥ 4 dalam 30 hari terakhir. Perhatikan role-nya: supervisor dengan kehadiran bermasalah perlu penanganan lebih cepat dari role lain._

{#if attendance_problem.length > 0}

<DataTable data={attendance_problem}>
    <Column id="employee_name"    title="Pegawai"/>
    <Column id="role"             title="Role"/>
    <Column id="branch_name"      title="Cabang"/>
    <Column id="total_hari_kerja" title="Hari Kerja"  fmt="#,##0"/>
    <Column id="total_absent"     title="Absent"      fmt="#,##0"/>
    <Column id="total_terlambat"  title="Terlambat"   fmt="#,##0"/>
    <Column id="total_cuti"       title="Cuti"        fmt="#,##0"/>
</DataTable>

_Tindak lanjut perlu dilakukan sebelum pola ini berdampak pada operasional shift._

{:else}
<div style="background: rgba(22,163,74,0.08); border-left: 4px solid #16a34a; padding: 12px 16px; border-radius: 6px;">
✅ <strong>Tidak ada pegawai dengan kehadiran bermasalah</strong> dalam 30 hari terakhir — kondisi ideal.
</div>
{/if}
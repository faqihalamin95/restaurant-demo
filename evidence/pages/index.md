---
title: Wekadata — Ringkasan Performa Bisnis
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

```sql daily_kpi
SELECT
    SUM(total_revenue)                                           AS total_revenue,
    SUM(total_orders)                                            AS total_orders,
    COUNT(DISTINCT branch_id)                                    AS cabang_aktif,
    ROUND(SUM(total_revenue) / NULLIF(SUM(total_orders), 0), 0) AS avg_order_value
FROM restaurant.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)
```

```sql net_summary_today
SELECT
    SUM(net_revenue)                                                  AS net_revenue,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS net_margin_pct
FROM restaurant.daily_net_revenue
WHERE metric_date = (SELECT MAX(metric_date) FROM restaurant.daily_net_revenue)
```

```sql pct_change
SELECT
    ROUND(pct_change * 100, 1)      AS pct_change_display,
    ABS(ROUND(pct_change * 100, 1)) AS pct_change_abs,
    CASE
        WHEN pct_change > 0.10  THEN 'naik'
        WHEN pct_change < -0.10 THEN 'turun'
        ELSE 'stabil'
    END AS kondisi
FROM (
    SELECT ROUND((today_rev - avg_sdow) / NULLIF(avg_sdow, 0), 3) AS pct_change
    FROM (
        SELECT
            SUM(CASE WHEN order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)
                THEN daily_total ELSE 0 END)             AS today_rev,
            AVG(CASE
                WHEN order_date < (SELECT MAX(order_date) FROM restaurant.daily_revenue)
                AND DAYOFWEEK(order_date) = DAYOFWEEK((SELECT MAX(order_date) FROM restaurant.daily_revenue))
                AND order_date >= (SELECT MAX(order_date) FROM restaurant.daily_revenue) - INTERVAL '30 days'
                THEN daily_total
            END) AS avg_sdow
        FROM (
            SELECT order_date, SUM(total_revenue) AS daily_total
            FROM restaurant.daily_revenue
            WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.daily_revenue) - INTERVAL '30 days'
            GROUP BY order_date
        )
    )
)
```

```sql best_branch
SELECT branch_name, total_revenue
FROM restaurant.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)
ORDER BY total_revenue DESC
LIMIT 1
```

```sql top_menu_today
SELECT menu_name
FROM restaurant.menu_performance
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.menu_performance)
ORDER BY total_qty_sold DESC
LIMIT 1
```

```sql declining_branches
SELECT
    COUNT(*)         AS jumlah_cabang,
    MIN(branch_name) AS cabang_terparah
FROM restaurant.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)
  AND pct_change_vs_sdow_avg < -0.20
```

```sql insights
SELECT
    branch_name,
    ROUND(pct_change_vs_sdow_avg * 100, 1) AS pct_change
FROM restaurant.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)
  AND pct_change_vs_sdow_avg < -0.15
ORDER BY pct_change_vs_sdow_avg ASC
LIMIT 3
```

```sql menu_alerts
SELECT
    menu_name,
    ROUND(qty_wow_change * 100, 1) AS pct_change
FROM restaurant.menu_performance
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.menu_performance)
  AND qty_wow_change < -0.20
ORDER BY qty_wow_change ASC
LIMIT 3
```

```sql attendance_alerts
SELECT COUNT(*) AS jumlah_absent
FROM restaurant.employee_shift_performance
WHERE attendance_date = (SELECT MAX(attendance_date) FROM restaurant.employee_shift_performance)
  AND attendance_status = 'absent'
```

---

_Data diperbarui otomatis setiap hari. Laporan berikut mencakup operasional **{tgl[0].nama_hari}, {tgl[0].tanggal_display}**._

---

{#if pct_change[0].kondisi === 'naik'}
<div>

🎉 **Halo, Owner!** Revenue kemarin naik **{pct_change[0].pct_change_display}%** dibanding rata-rata hari {tgl[0].nama_hari} dalam 30 hari terakhir. Cabang terbaik: **{best_branch[0].branch_name}**, menu terlaris: **{top_menu_today[0].menu_name}**.

</div>
{:else if pct_change[0].kondisi === 'turun'}
<div>

⚠️ **Perhatian, Owner.** Revenue kemarin turun **{pct_change[0].pct_change_abs}%** dibanding rata-rata hari {tgl[0].nama_hari} dalam 30 hari terakhir. Ada **{declining_branches[0].jumlah_cabang} cabang** dengan penurunan signifikan, terbesar di **{declining_branches[0].cabang_terparah}**.

</div>
{:else}
<div>

👋 **Halo, Owner!** Performa kemarin stabil dibanding rata-rata hari {tgl[0].nama_hari} dalam 30 hari terakhir. Cabang terbaik: **{best_branch[0].branch_name}**, menu terlaris: **{top_menu_today[0].menu_name}**.

</div>
{/if}

---

## 🔔 Yang Perlu Diperhatikan

{#if insights.length > 0 || attendance_alerts[0].jumlah_absent >= 3 || menu_alerts.length > 0}

<div style="display: flex; flex-direction: column; gap: 12px; margin-bottom: 24px;">

{#each insights as row}
<div style="background: rgba(220,38,38,0.08); border-left: 4px solid #dc2626; padding: 12px 16px; border-radius: 6px;">
🔴 <strong>{row.branch_name}</strong> — Revenue turun <strong>{row.pct_change}%</strong> vs rata-rata hari serupa dalam 30 hari terakhir. Segera cek kondisi operasional cabang ini.
</div>
{/each}

{#if attendance_alerts[0].jumlah_absent >= 3}
<div style="background: rgba(248,201,0,0.1); border-left: 4px solid #f8c900; padding: 12px 16px; border-radius: 6px;">
🟡 <strong>{attendance_alerts[0].jumlah_absent} pegawai tidak hadir</strong> kemarin. Pastikan tidak ada shift yang kekurangan staf.
</div>
{/if}

{#each menu_alerts as row}
<div style="background: rgba(248,201,0,0.1); border-left: 4px solid #f8c900; padding: 12px 16px; border-radius: 6px;">
🟡 <strong>{row.menu_name}</strong> — Penjualan turun <strong>{row.pct_change}%</strong> vs minggu lalu. Pertimbangkan promo atau evaluasi menu.
</div>
{/each}

</div>

{:else}
<div style="background: rgba(22,163,74,0.08); border-left: 4px solid #16a34a; padding: 12px 16px; border-radius: 6px; margin-bottom: 24px;">
✅ <strong>Semua indikator normal.</strong> Tidak ada cabang, menu, atau kehadiran yang perlu perhatian kemarin.
</div>
{/if}

---

## KPI Utama — {tgl[0].nama_hari},{tgl[0].tanggal_display}

<BigValue data={daily_kpi}         value="total_revenue"   title="Total Revenue (Rp)"        fmt="#,##0" />
<BigValue data={daily_kpi}         value="total_orders"    title="Total Order"                fmt="#,##0" />
<BigValue data={daily_kpi}         value="cabang_aktif"    title="Cabang Aktif" />
<BigValue data={daily_kpi}         value="avg_order_value" title="Rata-rata Nilai Order (Rp)" fmt="#,##0" />
<BigValue data={net_summary_today} value="net_revenue"     title="Net Revenue (Rp)"           fmt="#,##0" />
<BigValue data={net_summary_today} value="net_margin_pct"  title="Net Margin (%)"             fmt="0.0\%" />

---

## Performa Cabang — {tgl[0].tanggal_display}

```sql branch_daily
SELECT
    branch_name,
    total_revenue,
    total_orders,
    ROUND(total_revenue / NULLIF(total_orders, 0), 0) AS avg_order_value,
    pct_change_vs_sdow_avg
FROM restaurant.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)
ORDER BY total_revenue DESC
```

```sql net_by_branch_today
SELECT
    branch_name,
    gross_revenue,
    inventory_usage_cost   AS biaya_bahan,
    labor_total_cost       AS biaya_sdm,
    operational_total_cost AS biaya_operasional,
    net_revenue,
    ROUND(net_revenue / NULLIF(gross_revenue, 0) * 100, 1) AS net_margin_pct
FROM restaurant.daily_net_revenue
WHERE metric_date = (SELECT MAX(metric_date) FROM restaurant.daily_net_revenue)
ORDER BY net_revenue DESC
```

<DataTable data={branch_daily}>
    <Column id="branch_name"            title="Cabang"/>
    <Column id="total_revenue"          title="Revenue (Rp)"               fmt="#,##0"/>
    <Column id="total_orders"           title="Order"                      fmt="#,##0"/>
    <Column id="avg_order_value"        title="Rata-rata Nilai Order (Rp)" fmt="#,##0"/>
    <Column id="pct_change_vs_sdow_avg" title="vs Hari Serupa"             fmt="+0.0%;-0.0%;0.0%" contentType="delta"/>
</DataTable>

<DataTable data={net_by_branch_today}>
    <Column id="branch_name"       title="Cabang"/>
    <Column id="gross_revenue"     title="Revenue (Rp)"           fmt="#,##0"/>
    <Column id="biaya_bahan"       title="Biaya Bahan (Rp)"       fmt="#,##0"/>
    <Column id="biaya_sdm"         title="Biaya SDM (Rp)"         fmt="#,##0"/>
    <Column id="biaya_operasional" title="Biaya Operasional (Rp)" fmt="#,##0"/>
    <Column id="net_revenue"       title="Net Revenue (Rp)"       fmt="#,##0"/>
    <Column id="net_margin_pct"    title="Margin (%)"             fmt="0.0\%"/>
</DataTable>

_Detail tren jangka panjang ada di halaman **Performa Cabang** dan **Laporan Keuangan**._

---

## Menu Terlaris — {tgl[0].tanggal_display}

```sql menu_daily
SELECT
    menu_name,
    category,
    SUM(total_qty_sold) AS total_qty,
    SUM(total_revenue)  AS total_revenue
FROM restaurant.menu_performance
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.menu_performance)
GROUP BY menu_name, category
ORDER BY total_qty DESC
LIMIT 10
```

<DataTable data={menu_daily}>
    <Column id="menu_name"     title="Menu"/>
    <Column id="category"      title="Kategori"/>
    <Column id="total_qty"     title="Qty Terjual"  fmt="#,##0"/>
    <Column id="total_revenue" title="Revenue (Rp)" fmt="#,##0"/>
</DataTable>

_Analisis tren, menu engineering, dan perbandingan antar cabang ada di halaman **Performa Menu**._

---

## Shift & Kehadiran — {tgl[0].tanggal_display}

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
    <Column id="total_orders"  title="Order Ditangani"            fmt="#,##0"/>
    <Column id="total_revenue" title="Revenue (Rp)"               fmt="#,##0"/>
    <Column id="avg_ticket"    title="Rata-rata Nilai Order (Rp)" fmt="#,##0"/>
</DataTable>

</div>

<div>

### Status Kehadiran

<BarChart
    data={attendance_daily}
    x="attendance_status"
    y="total"
    title="Kehadiran Pegawai"
    xAxisTitle="Status"
    yAxisTitle="Jumlah"
/>

</div>

</Grid>

_Analisis lengkap produktivitas dan absensi ada di halaman **Performa Pegawai**._

---

## Pola Order per Jam — {tgl[0].tanggal_display}

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
    title="Order per Jam — Makan di Tempat vs Pesan Antar vs Bawa Pulang"
    xAxisTitle="Jam"
    yAxisTitle="Total Order"
/>

_Prediksi jam sibuk untuk hari berikutnya ada di halaman **Jam Sibuk**._
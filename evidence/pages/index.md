---
title: Ringkasan Performa Bisnis
---

```sql last_date
SELECT
    DAY(MAX(order_date)) || ' ' ||
    CASE MONTH(MAX(order_date))
        WHEN 1 THEN 'Januari' WHEN 2 THEN 'Februari' WHEN 3 THEN 'Maret'
        WHEN 4 THEN 'April' WHEN 5 THEN 'Mei' WHEN 6 THEN 'Juni'
        WHEN 7 THEN 'Juli' WHEN 8 THEN 'Agustus' WHEN 9 THEN 'September'
        WHEN 10 THEN 'Oktober' WHEN 11 THEN 'November' WHEN 12 THEN 'Desember'
    END || ' ' ||
    YEAR(MAX(order_date)) AS tanggal_display
FROM restaurant.daily_revenue
```

```sql today_summary
SELECT
    SUM(total_revenue)                                                  AS total_revenue,
    SUM(total_orders)                                                   AS total_orders,
    COUNT(DISTINCT branch_id)                                           AS active_branches,
    ROUND(SUM(total_revenue) / NULLIF(SUM(total_orders), 0), 0)         AS avg_order_value
FROM restaurant.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)
```

```sql pct_change
SELECT
    ROUND(pct_change * 100, 1)      AS pct_change_display,
    ABS(ROUND(pct_change * 100, 1)) AS pct_change_abs,
    pct_change,
    CASE
        WHEN pct_change > 0.20  THEN 'naik'
        WHEN pct_change < -0.20 THEN 'turun'
        ELSE 'stabil'
    END AS kondisi
FROM (
    SELECT
        ROUND(
            (today_rev - avg_7d) / NULLIF(avg_7d, 0)
        , 3) AS pct_change
    FROM (
        SELECT
            SUM(CASE WHEN order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)
                THEN daily_total ELSE 0 END)                            AS today_rev,
            AVG(CASE WHEN order_date < (SELECT MAX(order_date) FROM restaurant.daily_revenue)
                THEN daily_total ELSE NULL END)                         AS avg_7d
        FROM (
            SELECT order_date, SUM(total_revenue) AS daily_total
            FROM restaurant.daily_revenue
            WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.daily_revenue) - INTERVAL '7 days'
            GROUP BY order_date
        )
    )
)
```

```sql best_branch
SELECT
    branch_name,
    total_revenue
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
  AND pct_change_vs_7d_avg < -0.20
```

_Data diperbarui otomatis setiap hari. Menampilkan performa {last_date[0].tanggal_display}._

---

{#if pct_change[0].kondisi === 'naik'}

🎉 **Halo Owner! Kabar baik** — revenue kemarin naik **{pct_change[0].pct_change_display}%** dibanding rata-rata 7 hari terakhir. Cabang terbaik kemarin adalah **{best_branch[0].branch_name}**. Menu terlaris adalah **{top_menu_today[0].menu_name}**. Detail lengkap ada di halaman masing-masing.

{:else if pct_change[0].kondisi === 'turun'}

⚠️ **Halo Owner**, ada yang perlu diperhatikan — revenue kemarin turun **{pct_change[0].pct_change_abs}%** dibanding rata-rata 7 hari terakhir. Terdapat **{declining_branches[0].jumlah_cabang} cabang** dengan penurunan signifikan, dan **{declining_branches[0].cabang_terparah}** mengalami penurunan paling tajam. Detail bisa dicek di halaman Performa Cabang.

{:else}

👋 **Halo Owner!** Performa kemarin terjaga stabil. Cabang terbaik adalah **{best_branch[0].branch_name}**. Menu terlaris kemarin adalah **{top_menu_today[0].menu_name}**. Detail lengkap ada di halaman masing-masing.

{/if}

---

<BigValue
    data={today_summary}
    value="total_revenue"
    title="Total Revenue (Rp)"
    fmt="#,##0"
/>

<BigValue
    data={today_summary}
    value="total_orders"
    title="Total Pesanan"
    fmt="#,##0"
/>

<BigValue
    data={today_summary}
    value="active_branches"
    title="Cabang Aktif"
/>

<BigValue
    data={today_summary}
    value="avg_order_value"
    title="Rata-rata Nilai Order (Rp)"
    fmt="#,##0"
/>

---

## Tren Revenue (30 Hari Terakhir)

```sql revenue_trend
SELECT
    order_date,
    branch_name,
    total_revenue
FROM restaurant.daily_revenue
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.daily_revenue) - INTERVAL '30 days'
ORDER BY order_date
```

<LineChart
    data={revenue_trend}
    x="order_date"
    y="total_revenue"
    series="branch_name"
    title="Revenue per Cabang (Rp)"
    yFmt="#,##0"
    xAxisTitle="Tanggal"
    yAxisTitle="Revenue (Rp)"
/>

---

## Performa Cabang {last_date[0].tanggal_display}

```sql branch_yesterday
SELECT
    branch_name,
    total_revenue,
    total_orders,
    pct_change_vs_7d_avg
FROM restaurant.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)
ORDER BY total_revenue DESC
```

<DataTable data={branch_yesterday} rows=5>
    <Column id="branch_name" title="Cabang"/>
    <Column id="total_revenue" title="Revenue (Rp)" fmt="#,##0"/>
    <Column id="total_orders" title="Pesanan" fmt="#,##0"/>
    <Column id="pct_change_vs_7d_avg"
            title="Tren (7hr)"
            fmt="+0.0%;-0.0%;0.0%"
            contentType="delta"
    />
</DataTable>
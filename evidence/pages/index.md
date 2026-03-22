---
title: Ringkasan Bisnis
---

# Ringkasan Performa Bisnis

_Data diperbarui otomatis setiap hari. Menampilkan performa kemarin._

```sql today_summary
SELECT
    SUM(total_revenue)                                                 AS total_revenue,
    SUM(total_orders)                                                  AS total_orders,
    COUNT(DISTINCT branch_id)                                          AS active_branches,
    -- PERBAIKAN: Gunakan NULLIF untuk mencegah error division by zero
    ROUND(SUM(total_revenue) / NULLIF(SUM(total_orders), 0), 0)        AS avg_order_value
FROM restaurant.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)
```

<BigValue
    data={today_summary}
    value="total_revenue"
    title="Total Revenue"
    fmt="Rp #,##0"
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
    title="Rata-rata Nilai Order"
    fmt="Rp #,##0"
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
    title="Revenue per Cabang"
    yFmt="Rp #,##0"
    xAxisTitle="Tanggal"
    yAxisTitle="Revenue"
/>

---

## Performa Cabang Kemarin

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
    <Column id="total_revenue" title="Revenue" fmt="Rp #,##0"/> 
    <Column id="total_orders" title="Pesanan" fmt="#,##0"/>
    <Column id="pct_change_vs_7d_avg" 
            title="Tren (7hr)" 
            fmt="+0.0%;-0.0%;0.0%"
            contentType="delta"
    />
</DataTable>

---

## Peringatan Dini — Penurunan Revenue

```sql anomaly_alert
SELECT
    branch_name,
    order_date,
    total_revenue,
    ROUND(revenue_7d_avg, 0)        AS avg_7d,
    ROUND(pct_change_vs_7d_avg, 3)  AS pct_drop -- Membulatkan desimal agar lebih rapi saat ditampilkan
FROM restaurant.daily_revenue
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.daily_revenue) - INTERVAL '7 days'
  -- PERBAIKAN: Gunakan desimal (-0.15) bukan angka bulat (-15)
  AND pct_change_vs_7d_avg < -0.15 
ORDER BY pct_change_vs_7d_avg ASC
```

{#if anomaly_alert.length > 0}

> Cabang berikut menunjukkan penurunan revenue lebih dari 15% dibanding rata-rata 7 hari terakhir.

<DataTable data={anomaly_alert}>
    <Column id="branch_name" title="Cabang"/>
    <Column id="order_date" title="Tanggal"/>
    <Column id="total_revenue" title="Revenue" fmt="Rp #,##0"/>
    <Column id="avg_7d" title="Rata-rata 7 Hari" fmt="Rp #,##0"/>
    <Column id="pct_drop" title="Selisih (%)" fmt="+0.0%;-0.0%;0.0%" contentType="delta"/>
</DataTable>

{:else}

> Tidak ada anomali revenue dalam 7 hari terakhir. Semua cabang beroperasi normal.

{/if}

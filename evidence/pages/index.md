---
title: Restaurant Analytics
---

# 🍗 Restaurant Analytics Dashboard

_Data updated daily at 06:00 WIB. Showing yesterday's performance._

```sql today_summary
SELECT
    SUM(total_revenue)                          AS total_revenue,
    SUM(total_orders)                           AS total_orders,
    COUNT(DISTINCT branch_id)                   AS active_branches,
    ROUND(SUM(total_revenue) / SUM(total_orders), 0) AS avg_order_value
FROM restaurant.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)
```

<BigValue
    data={today_summary}
    value="total_revenue"
    title="Revenue Hari Ini"
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

## Tren Revenue 30 Hari Terakhir

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
    title="Revenue per Cabang (30 Hari)"
    yFmt="Rp #,##0"
/>

---

## Performa Cabang Kemarin

```sql branch_yesterday
SELECT
    branch_name,
    total_revenue,
    total_orders,
    ROUND(pct_change_vs_7d_avg * 100, 1) AS pct_change
FROM restaurant.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)
ORDER BY total_revenue DESC
```

<DataTable
    data={branch_yesterday}
    rows=4
>
    <Column id="branch_name" title="Cabang"/>
    <Column id="total_revenue" title="Revenue" fmt="Rp #,##0"/>
    <Column id="total_orders" title="Pesanan" fmt="#,##0"/>
    <Column id="pct_change" title="vs 7 Hari Avg" fmt="+0.0%;-0.0%;0.0%" contentType="delta"/>
</DataTable>

---

## ⚠️ Early Warning — Revenue Drop

```sql anomaly_alert
SELECT
    branch_name,
    order_date,
    total_revenue,
    ROUND(revenue_7d_avg, 0)            AS avg_7d,
    ROUND(pct_change_vs_7d_avg * 100, 1) AS pct_drop
FROM restaurant.daily_revenue
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.daily_revenue) - INTERVAL '7 days'
  AND pct_change_vs_7d_avg < -0.15
ORDER BY pct_change_vs_7d_avg ASC
```

{#if anomaly_alert.length > 0}
<DataTable data={anomaly_alert}>
    <Column id="branch_name" title="Cabang"/>
    <Column id="order_date" title="Tanggal"/>
    <Column id="total_revenue" title="Revenue" fmt="Rp #,##0"/>
    <Column id="avg_7d" title="Avg 7 Hari" fmt="Rp #,##0"/>
    <Column id="pct_drop" title="Selisih" fmt="+0.0%;-0.0%;0.0%" contentType="delta"/>
</DataTable>
{:else}
> ✅ Tidak ada anomali revenue dalam 7 hari terakhir.
{/if}
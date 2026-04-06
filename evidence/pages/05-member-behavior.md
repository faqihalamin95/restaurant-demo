---
title: Analisis Perilaku Member
---

_Pola pembelian customer member berdasarkan tier, frekuensi belanja, dan nilai transaksi._

```sql member_summary_90d
SELECT
    COUNT(DISTINCT member_id)                                 AS total_member_aktif,
    SUM(total_orders)                                         AS total_orders_member,
    SUM(total_spend)                                          AS total_belanja_member,
    ROUND(SUM(total_spend) / NULLIF(SUM(total_orders), 0), 0) AS avg_order_value
FROM restaurant.member_purchase_behavior
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior) - INTERVAL '90 days'
```

```sql member_vs_periode_lalu
SELECT
    ROUND(SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior) - INTERVAL '90 days'
        THEN total_spend END) /
    NULLIF(SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior) - INTERVAL '90 days'
        THEN total_orders END), 0), 0) AS avg_order_value_90d,
    ROUND(SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior) - INTERVAL '180 days'
               AND order_date <  (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior) - INTERVAL '90 days'
        THEN total_spend END) /
    NULLIF(SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior) - INTERVAL '180 days'
               AND order_date <  (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior) - INTERVAL '90 days'
        THEN total_orders END), 0), 0) AS avg_order_value_90d_lalu,
    ROUND(
        (ROUND(SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior) - INTERVAL '90 days'
            THEN total_spend END) /
        NULLIF(SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior) - INTERVAL '90 days'
            THEN total_orders END), 0), 0)
        -
        ROUND(SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior) - INTERVAL '180 days'
               AND order_date <  (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior) - INTERVAL '90 days'
            THEN total_spend END) /
        NULLIF(SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior) - INTERVAL '180 days'
               AND order_date <  (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior) - INTERVAL '90 days'
            THEN total_orders END), 0), 0))
    / NULLIF(ROUND(SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior) - INTERVAL '180 days'
               AND order_date <  (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior) - INTERVAL '90 days'
            THEN total_spend END) /
        NULLIF(SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior) - INTERVAL '180 days'
               AND order_date <  (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior) - INTERVAL '90 days'
            THEN total_orders END), 0), 0), 0) * 100
    , 1) AS pct_change_aov
FROM restaurant.member_purchase_behavior
```

```sql churn_count
SELECT
    COUNT(DISTINCT member_name) AS jumlah_churn_risk,
    SUM(CASE WHEN tier = 'Gold'   THEN 1 ELSE 0 END) AS gold_churn,
    SUM(CASE WHEN tier = 'Silver' THEN 1 ELSE 0 END) AS silver_churn
FROM (
    SELECT
        member_name,
        tier,
        MIN(recency_days) AS hari_sejak_transaksi
    FROM restaurant.member_purchase_behavior
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior) - INTERVAL '90 days'
    GROUP BY member_name, tier
    HAVING MIN(recency_days) >= 21
)
```

---

## Ringkasan 90 Hari Terakhir

<BigValue data={member_summary_90d} value="total_member_aktif"   title="Total Member Aktif"          fmt="#,##0" />
<BigValue data={member_summary_90d} value="total_orders_member"  title="Total Order Member"           fmt="#,##0" />
<BigValue data={member_summary_90d} value="total_belanja_member" title="Total Belanja (Rp)"           fmt="#,##0" />
<BigValue data={member_summary_90d} value="avg_order_value"      title="Rata-rata Nilai Order (Rp)"   fmt="#,##0" />

{#if member_vs_periode_lalu[0].pct_change_aov > 5}
<div style="background: #f0fdf4; border-left: 4px solid #16a34a; padding: 12px 16px; border-radius: 6px; margin: 16px 0;">
✅ <strong>Rata-rata nilai order naik {member_vs_periode_lalu[0].pct_change_aov}%</strong> vs 90 hari sebelumnya (Rp {member_vs_periode_lalu[0].avg_order_value_90d_lalu} → Rp {member_vs_periode_lalu[0].avg_order_value_90d}). Member semakin loyal dan belanja lebih besar.
</div>
{:else if member_vs_periode_lalu[0].pct_change_aov < -5}
<div style="background: #fff3f3; border-left: 4px solid #dc2626; padding: 12px 16px; border-radius: 6px; margin: 16px 0;">
🔴 <strong>Rata-rata nilai order turun {member_vs_periode_lalu[0].pct_change_aov}%</strong> vs 90 hari sebelumnya (Rp {member_vs_periode_lalu[0].avg_order_value_90d_lalu} → Rp {member_vs_periode_lalu[0].avg_order_value_90d}). Cek apakah ada pergeseran tier atau penurunan frekuensi belanja.
</div>
{:else}
<div style="background: #f5f5f5; border-left: 4px solid #888; padding: 12px 16px; border-radius: 6px; margin: 16px 0;">
➡️ <strong>Rata-rata nilai order stabil</strong> vs 90 hari sebelumnya — perubahan hanya {member_vs_periode_lalu[0].pct_change_aov}%.
</div>
{/if}

{#if churn_count[0].jumlah_churn_risk > 0}
<div style="background: #fffbeb; border-left: 4px solid #f8c900; padding: 12px 16px; border-radius: 6px; margin: 8px 0;">
🟡 <strong>{churn_count[0].jumlah_churn_risk} member berisiko churn</strong> — tidak bertransaksi dalam 21 hari terakhir.
{#if churn_count[0].gold_churn > 0} Termasuk <strong>{churn_count[0].gold_churn} member Gold</strong> yang perlu prioritas outreach.{/if}
{#if churn_count[0].silver_churn > 0} Dan <strong>{churn_count[0].silver_churn} member Silver</strong>.{/if}
Detail ada di bagian bawah halaman ini.
</div>
{/if}

---

## Kontribusi per Tier (90 Hari Terakhir)

```sql tier_spending_90d
SELECT
    tier,
    COUNT(DISTINCT member_id)      AS total_member,
    SUM(total_orders)              AS total_orders,
    SUM(total_spend)               AS total_belanja,
    ROUND(AVG(avg_order_value), 0) AS avg_order_value
FROM restaurant.member_purchase_behavior
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior) - INTERVAL '90 days'
GROUP BY 1
ORDER BY total_belanja DESC
```

```sql tier_wow
SELECT
    tier,
    SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior) - INTERVAL '6 days'
        THEN total_spend END)                                                   AS belanja_minggu_ini,
    SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior) - INTERVAL '13 days'
         AND order_date < (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior) - INTERVAL '6 days'
        THEN total_spend END)                                                   AS belanja_minggu_lalu,
    ROUND(
        (SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior) - INTERVAL '6 days'
            THEN total_spend END)
        - SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior) - INTERVAL '13 days'
             AND order_date < (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior) - INTERVAL '6 days'
            THEN total_spend END))
        / NULLIF(SUM(CASE WHEN order_date >= (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior) - INTERVAL '13 days'
             AND order_date < (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior) - INTERVAL '6 days'
            THEN total_spend END), 0) * 100
    , 1) AS pct_change
FROM restaurant.member_purchase_behavior
GROUP BY 1
ORDER BY tier
```

<Grid cols=2>

<div>

### Total Belanja per Tier

<BarChart
    data={tier_spending_90d}
    x="tier"
    y="total_belanja"
    title="Total Belanja per Tier (90 Hari)"
    yFmt="#,##0"
    xAxisTitle="Tier"
    yAxisTitle="Total Belanja (Rp)"
/>

</div>

<div>

### Perbandingan Minggu Ini vs Minggu Lalu

<DataTable data={tier_wow}>
    <Column id="tier"                title="Tier"/>
    <Column id="belanja_minggu_ini"  title="Minggu Ini (Rp)"  fmt="#,##0"/>
    <Column id="belanja_minggu_lalu" title="Minggu Lalu (Rp)" fmt="#,##0"/>
    <Column id="pct_change"          title="Perubahan (%)"    fmt="+0.0;-0.0" contentType="delta"/>
</DataTable>

</div>

</Grid>

<DataTable data={tier_spending_90d}>
    <Column id="tier"            title="Tier"/>
    <Column id="total_member"    title="Total Member"               fmt="#,##0"/>
    <Column id="total_orders"    title="Total Order"                fmt="#,##0"/>
    <Column id="total_belanja"   title="Total Belanja (Rp)"         fmt="#,##0"/>
    <Column id="avg_order_value" title="Rata-rata Nilai Order (Rp)" fmt="#,##0"/>
</DataTable>

_Tier Gold berkontribusi besar pada revenue meski jumlahnya sedikit — program retensi Gold perlu diprioritaskan. Tier Bronze yang volumenya besar adalah peluang upgrade melalui program loyalitas._

---

## Tren Belanja Harian (30 Hari Terakhir)

```sql spending_trend_30d
SELECT
    order_date,
    tier,
    SUM(total_spend) AS total_belanja
FROM restaurant.member_purchase_behavior
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior) - INTERVAL '30 days'
GROUP BY 1, 2
ORDER BY 1, 2
```

```sql spending_by_city
SELECT
    city,
    COUNT(DISTINCT member_id)      AS total_member,
    SUM(total_spend)               AS total_belanja,
    ROUND(AVG(avg_order_value), 0) AS avg_order_value
FROM restaurant.member_purchase_behavior
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior) - INTERVAL '90 days'
GROUP BY 1
ORDER BY total_belanja DESC
```

<Grid cols=2>

<div>

### Tren per Tier

<LineChart
    data={spending_trend_30d}
    x="order_date"
    y="total_belanja"
    series="tier"
    title="Tren Belanja Harian Member per Tier"
    yFmt="#,##0"
    xAxisTitle="Tanggal"
    yAxisTitle="Total Belanja (Rp)"
/>

</div>

<div>

### Belanja Member per Kota (90 Hari)

<BarChart
    data={spending_by_city}
    x="city"
    y="total_belanja"
    title="Total Belanja Member per Kota"
    yFmt="#,##0"
    xAxisTitle="Kota"
    yAxisTitle="Total Belanja (Rp)"
/>

</div>

</Grid>

_Pola tren harian memperlihatkan hari-hari dengan lonjakan aktivitas member — bisa dijadikan momentum promo. Distribusi kota membantu menentukan area prioritas ekspansi._

---

## Top Member — Belanja Tertinggi (90 Hari Terakhir)

```sql top_member_90d
SELECT
    member_name,
    tier,
    city,
    SUM(total_orders)              AS total_orders,
    SUM(total_items)               AS total_items,
    SUM(total_spend)               AS total_belanja,
    ROUND(AVG(avg_order_value), 0) AS avg_order_value,
    MIN(recency_days)              AS hari_sejak_transaksi
FROM restaurant.member_purchase_behavior
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior) - INTERVAL '90 days'
GROUP BY 1, 2, 3
ORDER BY total_belanja DESC
LIMIT 25
```

<DataTable data={top_member_90d} rows=25>
    <Column id="member_name"          title="Member"/>
    <Column id="tier"                 title="Tier"/>
    <Column id="city"                 title="Kota"/>
    <Column id="total_orders"         title="Total Order"               fmt="#,##0"/>
    <Column id="total_items"          title="Total Item"                fmt="#,##0"/>
    <Column id="total_belanja"        title="Total Belanja (Rp)"        fmt="#,##0"/>
    <Column id="avg_order_value"      title="Rata-rata Nilai Order (Rp)" fmt="#,##0"/>
    <Column id="hari_sejak_transaksi" title="Hari Sejak Transaksi"      fmt="#,##0"/>
</DataTable>

_Member dengan Hari Sejak Transaksi tinggi di list ini pernah belanja besar tapi sudah lama tidak kembali — kandidat utama program win-back._

---

## Member Berisiko Churn

```sql churn_risk
SELECT
    member_name,
    tier,
    city,
    SUM(total_orders)              AS total_orders,
    SUM(total_spend)               AS total_belanja,
    ROUND(AVG(avg_order_value), 0) AS avg_order_value,
    MIN(recency_days)              AS hari_sejak_transaksi
FROM restaurant.member_purchase_behavior
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior) - INTERVAL '90 days'
GROUP BY 1, 2, 3
HAVING MIN(recency_days) >= 21
ORDER BY total_belanja DESC, hari_sejak_transaksi DESC
LIMIT 25
```

{#if churn_risk.length > 0}

<DataTable data={churn_risk}>
    <Column id="member_name"          title="Member"/>
    <Column id="tier"                 title="Tier"/>
    <Column id="city"                 title="Kota"/>
    <Column id="total_orders"         title="Total Order"               fmt="#,##0"/>
    <Column id="total_belanja"        title="Total Belanja (Rp)"        fmt="#,##0"/>
    <Column id="avg_order_value"      title="Rata-rata Nilai Order (Rp)" fmt="#,##0"/>
    <Column id="hari_sejak_transaksi" title="Hari Sejak Transaksi"      fmt="#,##0"/>
</DataTable>

_Prioritaskan outreach ke tier Gold dan Silver dengan Hari Sejak Transaksi tertinggi — mereka punya nilai tinggi dan paling sayang untuk hilang._

{:else}
<div style="background: #f0fdf4; border-left: 4px solid #16a34a; padding: 12px 16px; border-radius: 6px;">
✅ <strong>Tidak ada member berisiko churn</strong> saat ini — semua member masih aktif bertransaksi dalam 21 hari terakhir.
</div>
{/if}
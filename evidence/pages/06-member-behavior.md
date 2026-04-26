---
title: Analisis Perilaku Member
---

_Pola pembelian customer member berdasarkan tier, frekuensi belanja, dan nilai transaksi._

```sql periode_90d
SELECT
    strftime('%d %b %Y', MAX(order_date) - INTERVAL '89 days') AS tgl_awal,
    strftime('%d %b %Y', MAX(order_date))                       AS tgl_akhir
FROM restaurant.member_purchase_behavior
```

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
    HAVING
        (tier = 'Gold'   AND MIN(recency_days) >= 14) OR
        (tier = 'Silver' AND MIN(recency_days) >= 21) OR
        (tier = 'Bronze' AND MIN(recency_days) >= 30)
)
```

---

## Ringkasan 90 Hari Terakhir

<span style="font-size:0.85em;color:var(--color-text-secondary)">{periode_90d[0].tgl_awal} – {periode_90d[0].tgl_akhir}</span>

<div style="background:rgba(22,163,74,0.08);border-left:4px solid #1D9E75;padding:12px 16px;border-radius:6px;margin:12px 0;font-size:0.9em;line-height:1.6;">
💡 <strong>Kenapa pelanggan setia perlu dicatat?</strong><br/>
Hampir setiap restoran punya pelanggan yang sering datang — tapi tanpa pencatatan, kamu tidak tahu siapa mereka, seberapa sering mereka datang, atau kapan mereka mulai jarang kembali. Program member bukan untuk menciptakan pelanggan setia, tapi untuk <strong>mengenali yang sudah ada</strong> — supaya kamu bisa menjaga mereka sebelum pergi ke tempat lain tanpa kamu sadari.
</div>

<BigValue data={member_summary_90d} value="total_member_aktif"   title="Total Member Aktif"          fmt="#,##0" />
<BigValue data={member_summary_90d} value="total_orders_member"  title="Total Order Member"           fmt="#,##0" />
<BigValue data={member_summary_90d} value="total_belanja_member" title="Total Belanja (Rp)"           fmt="#,##0" />
<BigValue data={member_summary_90d} value="avg_order_value"      title="Rata-rata Nilai Order (Rp)"   fmt="#,##0" />

{#if member_vs_periode_lalu[0].pct_change_aov > 5}
<div style="background: rgba(22,163,74,0.08); border-left: 4px solid #16a34a; padding: 12px 16px; border-radius: 6px; margin: 16px 0;">
✅ <strong>Rata-rata nilai order naik {member_vs_periode_lalu[0].pct_change_aov}%</strong> vs 90 hari sebelumnya (Rp {member_vs_periode_lalu[0].avg_order_value_90d_lalu} → Rp {member_vs_periode_lalu[0].avg_order_value_90d}). Member semakin loyal dan belanja lebih besar.
</div>
{:else if member_vs_periode_lalu[0].pct_change_aov < -5}
<div style="background: rgba(220,38,38,0.08); border-left: 4px solid #dc2626; padding: 12px 16px; border-radius: 6px; margin: 16px 0;">
🚨 <strong>Rata-rata nilai order turun {member_vs_periode_lalu[0].pct_change_aov}%</strong> vs 90 hari sebelumnya (Rp {member_vs_periode_lalu[0].avg_order_value_90d_lalu} → Rp {member_vs_periode_lalu[0].avg_order_value_90d}). Cek apakah ada pergeseran tier atau penurunan frekuensi belanja.
</div>
{:else}
<div style="background: rgba(100,116,139,0.08); border-left: 4px solid #888; padding: 12px 16px; border-radius: 6px; margin: 16px 0;">
➡️ <strong>Rata-rata nilai order stabil</strong> vs 90 hari sebelumnya — perubahan hanya {member_vs_periode_lalu[0].pct_change_aov}%.
</div>
{/if}

{#if churn_count[0].jumlah_churn_risk > 0}
<div style="background: rgba(248,201,0,0.1); border-left: 4px solid #f8c900; padding: 12px 16px; border-radius: 6px; margin: 8px 0;">
⚠️ <strong>{churn_count[0].jumlah_churn_risk} member berisiko churn</strong> — tidak bertransaksi dalam 21 hari terakhir.
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
    SUM(total_orders)                    AS total_orders,
    ROUND(SUM(total_orders) / 12.86, 1)  AS orders_per_minggu,
    SUM(total_items)                     AS total_items,
    SUM(total_spend)                     AS total_belanja,
    ROUND(AVG(avg_order_value), 0)       AS avg_order_value,
    MIN(recency_days)                    AS hari_sejak_transaksi
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
    <Column id="total_orders"         title="Total Order"                fmt="#,##0"/>
    <Column id="orders_per_minggu"    title="Frekuensi (order/minggu)"   fmt="0.0"/>
    <Column id="total_belanja"        title="Total Belanja (Rp)"         fmt="#,##0"/>
    <Column id="avg_order_value"      title="Rata-rata Nilai Order (Rp)" fmt="#,##0"/>
    <Column id="hari_sejak_transaksi" title="Hari Sejak Transaksi"       fmt="#,##0"/>
</DataTable>

_Member dengan frekuensi tinggi tapi total belanja rendah artinya sering datang tapi selalu pesan yang murah — kandidat program upselling. Member dengan frekuensi rendah tapi AOV tinggi artinya jarang datang tapi sekali datang belanja besar — kandidat program frekuensi seperti stamp card._

---

---

## Distribusi Tier per Kota (90 Hari Terakhir)
```sql tier_per_kota
SELECT
    city                                                                          AS kota,
    tier,
    COUNT(DISTINCT member_id)                                                     AS total_member,
    SUM(total_spend)                                                              AS total_belanja,
    ROUND(AVG(avg_order_value), 0)                                                AS avg_order_value,
    ROUND(COUNT(DISTINCT member_id) * 100.0 /
        SUM(COUNT(DISTINCT member_id)) OVER (PARTITION BY city), 1)              AS pct_dari_kota
FROM restaurant.member_purchase_behavior
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior) - INTERVAL '90 days'
GROUP BY city, tier
ORDER BY kota, total_belanja DESC
```

<Grid cols=2>

<div>

### Jumlah Member per Tier per Kota

<BarChart
    data={tier_per_kota}
    x="kota"
    y="total_member"
    series="tier"
    type="stacked"
    title="Distribusi Tier per Kota"
    xAxisTitle="Kota"
    yAxisTitle="Jumlah Member"
/>

</div>

<div>

### Total Belanja per Tier per Kota

<BarChart
    data={tier_per_kota}
    x="kota"
    y="total_belanja"
    series="tier"
    type="stacked"
    title="Total Belanja per Tier per Kota (Rp)"
    yFmt="#,##0"
    xAxisTitle="Kota"
    yAxisTitle="Total Belanja (Rp)"
/>

</div>

</Grid>

<DataTable data={tier_per_kota}>
    <Column id="kota"            title="Kota"/>
    <Column id="tier"            title="Tier"/>
    <Column id="total_member"    title="Jumlah Member"               fmt="#,##0"/>
    <Column id="total_belanja"   title="Total Belanja (Rp)"          fmt="#,##0"/>
    <Column id="avg_order_value" title="Rata-rata Nilai Order (Rp)"  fmt="#,##0"/>
    <Column id="pct_dari_kota"   title="% dari Kota"                 fmt="0.0\%"/>
</DataTable>

_Kota dengan proporsi Gold tinggi adalah area prioritas untuk program retensi premium. Kota dengan mayoritas Bronze tapi total belanja besar berarti banyak member potensial yang belum naik tier — cocok untuk program upgrade._

---

## Cohort — Member Berdasarkan Bulan Bergabung

> **Apa itu cohort?**
> Cohort adalah cara mengelompokkan member berdasarkan kapan mereka pertama kali bergabung — misalnya "semua member yang daftar bulan Januari" adalah satu cohort. Dengan membandingkan antar cohort, kamu bisa tahu apakah member yang baru daftar sekarang kualitasnya lebih baik atau lebih buruk dari yang daftar setahun lalu. Tanpa cohort, angka rata-rata keseluruhan bisa menipu — kelihatan bagus padahal member lama sudah mulai pergi.

> **Kenapa program member penting?**
> Mendatangkan pelanggan baru biayanya 5–7x lebih mahal dari mempertahankan yang sudah ada. Program member memberi alasan bagi pelanggan untuk kembali — bukan karena diskon semata, tapi karena mereka merasa dikenal dan dihargai. Data di bawah ini adalah alat untuk tahu program member kamu berjalan atau tidak.
```sql cohort_summary
SELECT
    DATE_TRUNC('month', join_date)                                           AS cohort_bulan,
    tier,
    COUNT(DISTINCT member_id)                                                AS total_member,
    ROUND(SUM(total_spend) / NULLIF(COUNT(DISTINCT member_id), 0), 0)       AS avg_spend_per_member,
    ROUND(SUM(total_orders) / NULLIF(COUNT(DISTINCT member_id), 0) / 12.86, 1) AS avg_frekuensi_mingguan
FROM restaurant.member_purchase_behavior
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior) - INTERVAL '90 days'
GROUP BY 1, 2
ORDER BY 1, 2
```
```sql cohort_total
SELECT
    DATE_TRUNC('month', join_date)                                           AS cohort_bulan,
    COUNT(DISTINCT member_id)                                                AS total_member,
    ROUND(SUM(total_spend) / NULLIF(COUNT(DISTINCT member_id), 0), 0)       AS avg_spend_per_member,
    ROUND(SUM(total_orders) / NULLIF(COUNT(DISTINCT member_id), 0) / 12.86, 1) AS avg_frekuensi_mingguan
FROM restaurant.member_purchase_behavior
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior) - INTERVAL '90 days'
GROUP BY 1
ORDER BY 1
```

<Grid cols=2>

<div>

### Rata-rata Belanja per Member per Cohort

<LineChart
    data={cohort_total}
    x="cohort_bulan"
    y="avg_spend_per_member"
    title="Avg Belanja per Member — per Bulan Bergabung (Rp)"
    yFmt="#,##0"
    xAxisTitle="Bulan Bergabung"
    yAxisTitle="Avg Belanja (Rp)"
/>

</div>

<div>

### Frekuensi Mingguan per Cohort

<LineChart
    data={cohort_total}
    x="cohort_bulan"
    y="avg_frekuensi_mingguan"
    title="Avg Frekuensi per Member — per Bulan Bergabung"
    yFmt="0.0"
    xAxisTitle="Bulan Bergabung"
    yAxisTitle="Order per Minggu"
/>

</div>

</Grid>

<DataTable data={cohort_summary}>
    <Column id="cohort_bulan"             title="Bulan Bergabung"/>
    <Column id="tier"                     title="Tier"/>
    <Column id="total_member"             title="Jumlah Member"              fmt="#,##0"/>
    <Column id="avg_spend_per_member"     title="Avg Belanja per Member (Rp)" fmt="#,##0"/>
    <Column id="avg_frekuensi_mingguan"   title="Avg Frekuensi (order/minggu)" fmt="0.0"/>
</DataTable>

**Cara membaca tabel ini:**

**Avg Belanja per Member** — rata-rata total uang yang dikeluarkan satu member dalam 90 hari terakhir. Ini ukuran seberapa berharga satu member secara finansial. Cohort dengan angka ini tinggi berarti member dari bulan itu loyal dan belanja besar. Kalau cohort lama angkanya terus turun, artinya member lama mulai jarang kembali — program retensi perlu diperkuat.

**Avg Frekuensi (order/minggu)** — rata-rata berapa kali satu member memesan dalam seminggu. Ini ukuran kebiasaan, bukan sekadar uang. Member yang datang 3x seminggu dengan order kecil lebih sulit digantikan daripada member yang datang sekali sebulan tapi belanja besar — karena kebiasaan jauh lebih sulit diputus. Kalau frekuensi cohort baru lebih rendah dari cohort lama, berarti member baru belum terbentuk kebiasaannya — perlu program onboarding yang mendorong kunjungan kedua dan ketiga.

_Pola ideal: cohort makin baru, avg belanja dan frekuensi makin tinggi — artinya program member semakin efektif dari waktu ke waktu. Kalau sebaliknya, evaluasi cara rekrutmen member dan benefit yang ditawarkan._

---

## Member Berisiko Churn

```sql churn_risk
SELECT
    member_name,
    tier,
    city,
    SUM(total_orders)                                    AS total_orders,
    ROUND(SUM(total_orders) / 12.86, 1)                 AS orders_per_minggu,
    SUM(total_spend)                                     AS total_belanja,
    ROUND(AVG(avg_order_value), 0)                       AS avg_order_value,
    MIN(recency_days)                                    AS hari_sejak_transaksi,
    CASE tier
        WHEN 'Gold'   THEN 14
        WHEN 'Silver' THEN 21
        WHEN 'Bronze' THEN 30
    END                                                  AS threshold_hari
FROM restaurant.member_purchase_behavior
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior) - INTERVAL '90 days'
GROUP BY 1, 2, 3
HAVING
    (tier = 'Gold'   AND MIN(recency_days) >= 14) OR
    (tier = 'Silver' AND MIN(recency_days) >= 21) OR
    (tier = 'Bronze' AND MIN(recency_days) >= 30)
ORDER BY total_belanja DESC, hari_sejak_transaksi DESC
LIMIT 25
```

{#if churn_risk.length > 0}

<DataTable data={churn_risk}>
    <Column id="member_name"          title="Member"/>
    <Column id="tier"                 title="Tier"/>
    <Column id="city"                 title="Kota"/>
    <Column id="orders_per_minggu"    title="Frekuensi (order/minggu)"   fmt="0.0"/>
    <Column id="total_belanja"        title="Total Belanja (Rp)"         fmt="#,##0"/>
    <Column id="avg_order_value"      title="Rata-rata Nilai Order (Rp)" fmt="#,##0"/>
    <Column id="hari_sejak_transaksi" title="Hari Sejak Transaksi"       fmt="#,##0"/>
    <Column id="threshold_hari"       title="Batas Churn (Hari)"         fmt="#,##0"/>
</DataTable>

_Threshold berbeda per tier: Gold 14 hari, Silver 21 hari, Bronze 30 hari — disesuaikan dengan pola kunjungan normal tiap segmen. Member dengan frekuensi tinggi yang tiba-tiba berhenti lebih urgent ditangani daripada member yang memang jarang datang._

{:else}
<div style="background: rgba(22,163,74,0.08); border-left: 4px solid #16a34a; padding: 12px 16px; border-radius: 6px;">
✅ <strong>Tidak ada member berisiko churn</strong> saat ini — semua member masih aktif bertransaksi dalam 21 hari terakhir.
</div>
{/if}
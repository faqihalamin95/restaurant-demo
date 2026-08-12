# 📋 Restaurant Dashboard — Review & Rencana Peningkatan Konten

> **Dokumen ini menggabungkan**: review konten, audit ketersediaan data, dan rencana implementasi detail.
> Dibuat: 23 Juni 2026

---

## Daftar Isi

1. [Status Dashboard Saat Ini](#1-status-dashboard-saat-ini)
2. [Skor Kecukupan Konten](#2-skor-kecukupan-konten)
3. [Kekuatan Utama](#3-kekuatan-utama)
4. [Audit Ketersediaan Data](#4-audit-ketersediaan-data)
5. [Gap & Klasifikasi](#5-gap--klasifikasi)
6. [Rencana Implementasi Quick-Win](#6-rencana-implementasi-quick-win)
7. [Gap yang Butuh Data Baru](#7-gap-yang-butuh-data-baru)
8. [Verdict & Skor Akhir](#8-verdict--skor-akhir)

---

## 1. Status Dashboard Saat Ini

### Arsitektur Data

| Layer | Jumlah | Detail |
|-------|--------|--------|
| Raw Tables | 12 | orders (247K), order_items (520K), menu_items (16), branches (4), employees (32), employee_attendance (21K), employee_compensation (32), members (700), shifts (3), inventory_catalog (8), inventory_transactions (37K), branch_daily_operational_costs (3.5K) |
| Staging | 11 | stg_orders, stg_order_items, stg_menu_items, stg_branches, stg_employees, stg_employee_attendance, stg_employee_compensation, stg_members, stg_inventory_catalog, stg_inventory_transactions, stg_branch_daily_operational_costs |
| Foundation | 11 | dim_branches, dim_menu_items, dim_employees, dim_members, dim_shifts, dim_inventory_items, fct_orders, fct_employee_attendance, fct_inventory_costs_daily, fct_labor_costs_daily, fct_branch_operational_costs_daily |
| Marts | 8 | mart_daily_revenue, mart_daily_net_revenue, mart_menu_performance, mart_peak_hours, mart_member_purchase_behavior, mart_employee_shift_performance, mart_inventory_stok, mart_action_center |
| Evidence Sources | 263 | Pre-computed SQL queries per chart/tabel |

**Rentang Data**: 1 Januari 2024 → 22 Juni 2026 (~2.5 tahun, 4 cabang)

### Peta Halaman Dashboard

| # | Halaman | File | Ukuran | Peran |
|---|---------|------|--------|-------|
| 🏠 | Ringkasan | `evidence/pages/index.md` | 271 KB / 6.449 baris | Executive cockpit: health score, KPI semua modul, trend, alert |
| 📈 | Laporan Keuangan | `evidence/pages/01-laporan-keuangan.md` | 119 KB / 2.545 baris | Full P&L, cost breakdown (bahan/SDM/ops), margin trend, quarterly, YoY |
| 🏪 | Performa Cabang | `evidence/pages/02-branch-performance/` | 3 subpage (index, deepdive, analysis) | Branch health (7 level), revenue gap, growth driver, inflation-adjusted |
| 🥩 | Inventori & Stok | `evidence/pages/03-inventori-stok/` | 8 subpage | Overstock, reorder, transfer, supplier, stock aktual, branch inventory |
| ⏰ | Peak Hours | `evidence/pages/04-peak-hours.md` | 99 KB / 1.868 baris | Jam sibuk, prediksi besok, weekday vs weekend, branch peak matrix, seasonal |
| 🍳 | Performa Menu | `evidence/pages/05-menu-performance.md` | 160 KB / 2.908 baris | Menu Engineering Matrix (BCG), decline detection, category/tier, movers |
| 💎 | Perilaku Member | `evidence/pages/06-member-behavior.md` | 106 KB / 1.900 baris | Tier (Gold/Silver/Bronze), churn risk, retention queue, cohort, spending |
| 👥 | Performa Pegawai | `evidence/pages/07-employee-performance.md` | 68 KB / 874 baris | Kehadiran, overtime, produktivitas (rev/jam), shift risk, coaching queue |
| 🎯 | Pusat Aksi | `evidence/pages/08-pusat-aksi.md` | 10 KB / 306 baris | Unified action queue terprioritasi dari semua modul |

---

## 2. Skor Kecukupan Konten

| Modul | Skor | Aspek yang Sudah Ada |
|-------|------|---------------------|
| Laporan Keuangan | **9/10** | P&L lengkap (gross → net → margin), cost breakdown 3 komponen, cost vs target, period comparison (30d/90d/quarterly/YoY), branch-level margin, margin trend harian |
| Menu Performance | **9/10** | Menu Engineering Matrix 4 kuadran (Primadona/Pekerja Keras/Misteri/Lemah), top 5 volume & revenue, decline detection WoW, category analysis, price tier, branch movers, 90d structural decline |
| Inventori & Stok | **8.5/10** | Overstock detection, reorder alert, transfer candidate antar cabang, supplier cost, stock value per category, branch breakdown, cost tier, price volatility |
| Employee Performance | **8.5/10** | Attendance rate & trend, late tracking, overtime pressure, productivity (rev/jam), shift risk pattern, role coverage gap, coaching queue |
| Branch Performance | **8/10** | 7 level health classification, revenue gap, orders comparison, branch concentration risk, deep-dive per branch, growth driver, inflation-adjusted |
| Pusat Aksi | **8/10** | Unified queue dari 7 modul, priority ranking (Kritis → Pantau), impact statement, deep-link, severity badge |
| Peak Hours | **7.5/10** | Jam sibuk identification, weekday vs weekend, branch peak matrix, prediksi besok, seasonal pattern, anomaly detection |
| Member Behavior | **7.5/10** | Tier breakdown, churn risk per tier, retention queue, AOV & frequency, cohort, spending by city, tier movement |

**Overall: 8.3/10 untuk modul yang sudah ada**

---

## 3. Kekuatan Utama

1. **Full P&L real** — bukan cuma revenue. Punya cost breakdown (bahan baku, SDM, operasional) sampai ke net margin. Jarang ada di dashboard restaurant level UMKM/SME.

2. **7 modul operasional lengkap** — Finance, Branch, Inventory, Peak Hours, Menu, Member, Employee. Hampir semua aspek restoran tercover.

3. **Action-oriented** — setiap halaman punya rekomendasi tindakan. Pusat Aksi (08) menyatukan semua signal jadi satu prioritized queue lewat `mart_action_center.sql` (47 KB).

4. **Multi-period** — bisa lihat kemarin, 7d, 30d, 90d, quarterly, yearly. Owner bisa zoom in/out.

5. **Threshold-based status** — sistem Sehat/Waspada/Kritis konsisten di semua halaman. Owner tidak perlu interpretasi angka, langsung lihat warna.

6. **Data pipeline production-grade** — 12 raw → 11 foundation → 8 marts → 263 Evidence sources. Orchestrated via Dagster, transformasi via dbt.

---

## 4. Audit Ketersediaan Data

### Data yang Sudah Ada & Dipakai Penuh

| Data | Raw Table | Kolom Kunci | Rows | Dipakai di |
|------|-----------|-------------|------|------------|
| Orders | `raw.orders` | order_id, branch_id, order_time, payment_method, order_type, shift_id, handler_employee_id, member_id | 247.539 | Semua modul |
| Order Items | `raw.order_items` | order_item_id, order_id, menu_id, qty, subtotal | 519.974 | Menu, Revenue, Peak |
| Menu Items | `raw.menu_items` | menu_id, name, category, price, is_active | 16 | Menu Performance |
| Branches | `raw.branches` | branch_id, name, location, opened_date | 4 | Branch Performance |
| Employees | `raw.employees` | employee_id, name, branch_id, role, assigned_shift_id, start_date | 32 | Employee Performance |
| Attendance | `raw.employee_attendance` | attendance_date, employee_id, status (present/late/absent/leave), overtime_hours | 21.128 | Employee Performance |
| Compensation | `raw.employee_compensation` | base_salary_monthly, meal_allowance_daily, overtime_rate_hourly | 32 | Labor cost di P&L |
| Members | `raw.members` | member_id, tier (Gold/Silver/Bronze), city, join_date | 700 | Member Behavior |
| Inventory Catalog | `raw.inventory_catalog` | item_name, category, unit, base_unit_cost | 8 | Inventori |
| Inventory Txn | `raw.inventory_transactions` | txn_type (usage/purchase), qty, unit_cost, total_cost, stock_on_hand, days_remaining | 37.120 | Inventori, Cost P&L |
| Branch Ops Cost | `raw.branch_daily_operational_costs` | building_rent_daily, water, electricity, other_utilities | 3.517 | P&L ops cost |
| Shifts | `raw.shifts` | shift_name (Pagi/Siang/Malam), start_hour, end_hour | 3 | Employee, Peak |

### Data yang Ada tapi Belum Dimanfaatkan

| Data | Lokasi | Isi | Status Pemakaian |
|------|--------|-----|-----------------|
| **`payment_method`** | `raw.orders` → `fct_orders` | QRIS: 124.024 (50.1%), Cash: 86.647 (35.0%), Card: 29.446 (11.9%), Null: 7.422 (3.0%) | ❌ Tidak ada chart/analisis di dashboard manapun |
| **`order_type`** | `raw.orders` → `fct_orders` → `mart_daily_revenue` | Dine-in: 110.509 (44.7%), Delivery: 74.683 (30.2%), Takeaway: 62.347 (25.2%) | ⚠️ Mart sudah hitung `delivery_orders`, `dine_in_orders`, `takeaway_orders` tapi tidak ada visualisasi dedicated |
| **`member_id` linkage** | `raw.orders` → `fct_orders` | Member orders: 93.837 (37.9%), Non-member: 153.702 (62.1%) | ⚠️ Sudah dipakai partial di Member page, tapi rasio member vs non-member bisa lebih dieksplorasi |

### Data yang Tidak Ada

| Data | Tabel yang Dicari | Hasil | Kolom yang Dibutuhkan |
|------|------------------|-------|----------------------|
| **Food cost per menu** | recipe, bom, ingredient, hpp | ❌ Tidak ada | `cost_per_portion` di menu_items, atau tabel `recipes` (menu_id → inventory_id, qty_needed) |
| **Waste / shrinkage** | waste, shrink, loss | ❌ Tidak ada | Tabel `waste_transactions` (date, branch, item, qty, reason) |
| **Customer rating** | rating, review, feedback, complaint | ❌ Tidak ada | Tabel `reviews` (order_id, rating 1-5, comment) |
| **Budget / target** | budget, target | ❌ Tidak ada | Seed table `branch_monthly_targets` (branch_id, month, revenue_target, margin_target) |
| **Platform fee** | commission, platform_fee | ❌ Tidak ada | Kolom `platform_commission` di orders atau seed rate table |

---

## 5. Gap & Klasifikasi

### Quick Win (Data ada, bisa langsung implementasi)

| # | Gap | Sumber Data | Effort | Target Page |
|---|-----|-------------|--------|-------------|
| 1 | Channel Mix per Cabang | `mart_daily_revenue` (delivery/dine_in/takeaway_orders) | ~2 jam | 02-branch-performance |
| 2 | Payment Method Analysis | `fct_orders.payment_method` | ~3 jam | 01-laporan-keuangan |
| 3 | Break-Even Point | `mart_daily_net_revenue` (fixed + variable cost) | ~4-6 jam | 01-laporan-keuangan |
| 4 | Basket Analysis | `fct_orders` (order_id × menu_id self-join) | ~6 jam | 05-menu-performance |

### Butuh Data Baru (Tidak bisa tanpa tambah source)

| # | Gap | Data yang Dibutuhkan | Effort | Target Page |
|---|-----|---------------------|--------|-------------|
| 5 | Food Cost per Menu | Tabel `recipes` atau kolom `cost_per_portion` | Medium | 05-menu-performance |
| 6 | Waste Tracking | Tabel `waste_transactions` | High | 03-inventori-stok |
| 7 | Customer Rating | Tabel `reviews` | High | 02-branch-performance atau page baru |
| 8 | Budget vs Actual | Seed `branch_monthly_targets` | Medium | 01-keuangan + 02-branch |
| 9 | Platform Fee | Kolom/seed commission rate | Medium | 01-keuangan |

---

## 6. Rencana Implementasi Quick-Win

### Quick Win #1: 🏪 Channel Mix per Cabang

**Target page**: `evidence/pages/02-branch-performance/index.md`
**Effort**: ~2 jam
**Prioritas implementasi**: 1 (paling mudah, data sudah di mart)

#### Kenapa di Branch Performance?
- Channel mix (dine-in / delivery / takeaway) **berbeda antar cabang** — ini strategi cabang, bukan finance
- Cabang di area perumahan kemungkinan dominan delivery, cabang di pusat kota dominan dine-in
- Owner perlu tahu: "Cabang mana yang terlalu tergantung delivery?" (risiko bila platform fee naik)

#### Posisi di halaman
```
02-branch-performance/index.md
├── Hero: X/4 cabang sehat                    ← sudah ada
├── Branch Health Classification              ← sudah ada
├── Revenue Gap Analysis                      ← sudah ada
├── Orders Comparison                         ← sudah ada
├── 📦 Channel Mix per Cabang                ← BARU ✨
│   ├── Stacked bar chart: % dine-in / delivery / takeaway per cabang
│   ├── Trend 30d: apakah delivery share naik/turun
│   ├── AOV per channel per cabang
│   └── Signal card: "Cabang X dependency delivery 65%"
├── Branch Concentration                      ← sudah ada
└── Diagnosis per cabang                      ← sudah ada
```

#### KPI yang ditambahkan

| KPI | Definisi | Contoh |
|-----|----------|--------|
| Channel share per cabang | `delivery_orders / total_orders × 100` per branch | Pusat 25%, Timur 45% |
| AOV per channel | `SUM(revenue) / COUNT(orders)` per order_type per branch | Dine-in Rp72K, Delivery Rp58K |
| Channel trend 30d | Bandingkan channel share 30d ini vs 30d sebelumnya | Delivery ↑5%, Dine-in ↓2% |
| Delivery dependency alert | Flag jika delivery_share > 50% | ⚠️ Cabang Timur 65% |

#### Sumber data

Data sudah dihitung di `dbt_restaurant/models/marts/mart_daily_revenue.sql`:

```sql
-- Kolom yang sudah tersedia di mart_daily_revenue:
-- delivery_orders, dine_in_orders, takeaway_orders, total_orders
-- Tinggal buat Evidence source query:

-- File: evidence/sources/restaurant/branch_index_channel_mix_30d.sql

SELECT
    branch_name,
    SUM(delivery_orders)  AS delivery,
    SUM(dine_in_orders)   AS dine_in,
    SUM(takeaway_orders)  AS takeaway,
    SUM(total_orders)     AS total,
    ROUND(SUM(delivery_orders) * 100.0 / NULLIF(SUM(total_orders), 0), 1) AS delivery_pct,
    ROUND(SUM(dine_in_orders) * 100.0 / NULLIF(SUM(total_orders), 0), 1)  AS dine_in_pct,
    ROUND(SUM(takeaway_orders) * 100.0 / NULLIF(SUM(total_orders), 0), 1) AS takeaway_pct
FROM main_marts.mart_daily_revenue
WHERE order_date >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY branch_name
ORDER BY total DESC
```

#### Visualisasi yang direkomendasikan
- **Stacked BarChart**: x = branch_name, y = delivery_pct / dine_in_pct / takeaway_pct
- **LineChart** (dalam accordion): daily delivery_pct per branch, 30d trend
- **DataTable**: detail angka per cabang × channel

---

### Quick Win #2: 💳 Payment Method Analysis

**Target page**: `evidence/pages/01-laporan-keuangan.md`
**Effort**: ~3 jam
**Prioritas implementasi**: 2

#### Kenapa di Laporan Keuangan?
- Payment method = bagaimana uang masuk → topik keuangan
- Owner perlu tahu estimasi biaya MDR (Merchant Discount Rate): Card ~2-2.5%, QRIS ~0.7%
- MDR mempengaruhi net revenue tapi belum masuk hitungan cost di P&L saat ini

#### Posisi di halaman
```
01-laporan-keuangan.md
├── Period strip (MTD / 30d / 90d)            ← sudah ada
├── Hero (P&L summary)                        ← sudah ada
├── KPI strip (gross, net, margin)             ← sudah ada
├── 💸 Breakdown Biaya (bahan/SDM/ops)        ← sudah ada
├── 📈 Tren Margin                            ← sudah ada
├── 💳 Metode Pembayaran                      ← BARU ✨
│   ├── Donut chart: distribusi QRIS / Cash / Card
│   ├── Trend line 30d: pergeseran cash → digital
│   ├── Tabel: per cabang × metode pembayaran
│   ├── Signal card: estimasi biaya MDR bulanan
│   └── Accordion: "Apa itu MDR?" + penjelasan owner-friendly
├── 📊 Quarterly Report                       ← sudah ada
└── 📊 Year-on-Year                           ← sudah ada
```

#### KPI yang ditambahkan

| KPI | Definisi | Contoh |
|-----|----------|--------|
| % Transaksi Digital | `(QRIS + Card) / total × 100` | 62% |
| QRIS share | `QRIS / total × 100` | 50.1% |
| Estimasi biaya MDR/bulan | `(Card_revenue × 0.025) + (QRIS_revenue × 0.007)` | Rp X juta |
| Cash ratio trend | Bandingkan cash% 30d ini vs 30d lalu | ↓3% |

#### Sumber data

Data dari `fct_orders` — kolom `payment_method` sudah ada. Perlu 3 Evidence source query baru:

```sql
-- File: evidence/sources/restaurant/fin_payment_method_30d.sql

SELECT
    payment_method,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(subtotal)            AS total_revenue,
    ROUND(COUNT(DISTINCT order_id) * 100.0 /
        SUM(COUNT(DISTINCT order_id)) OVER (), 1) AS order_pct,
    ROUND(SUM(subtotal) * 100.0 /
        SUM(SUM(subtotal)) OVER (), 1) AS revenue_pct
FROM main_foundation.fct_orders
WHERE order_date >= CURRENT_DATE - INTERVAL '30 days'
  AND payment_method IS NOT NULL
GROUP BY payment_method
ORDER BY total_revenue DESC
```

```sql
-- File: evidence/sources/restaurant/fin_payment_trend_30d.sql

SELECT
    order_date,
    payment_method,
    COUNT(DISTINCT order_id) AS orders
FROM main_foundation.fct_orders
WHERE order_date >= CURRENT_DATE - INTERVAL '30 days'
  AND payment_method IS NOT NULL
GROUP BY order_date, payment_method
ORDER BY order_date
```

```sql
-- File: evidence/sources/restaurant/fin_payment_branch_30d.sql

SELECT
    b.branch_name,
    f.payment_method,
    COUNT(DISTINCT f.order_id) AS total_orders,
    SUM(f.subtotal)            AS total_revenue
FROM main_foundation.fct_orders f
JOIN main_foundation.dim_branches b ON f.branch_id = b.branch_id
WHERE f.order_date >= CURRENT_DATE - INTERVAL '30 days'
  AND f.payment_method IS NOT NULL
GROUP BY b.branch_name, f.payment_method
ORDER BY b.branch_name, total_revenue DESC
```

#### Visualisasi yang direkomendasikan
- **BarChart / ECharts Pie**: distribusi payment method (orders & revenue)
- **LineChart**: daily trend per payment method (30d)
- **DataTable**: branch × payment method matrix
- **Signal card**: estimasi MDR cost

---

### Quick Win #3: 📊 Break-Even Point per Cabang

**Target page**: `evidence/pages/01-laporan-keuangan.md`
**Effort**: ~4-6 jam
**Prioritas implementasi**: 3

#### Kenapa di Laporan Keuangan?
- BEP = "berapa revenue minimum supaya tidak rugi" → pertanyaan finance paling fundamental
- Semua komponen cost sudah ada di `mart_daily_net_revenue`
- Posisi setelah P&L dan breakdown biaya → owner sudah paham konteks sebelum lihat BEP

#### Posisi di halaman
```
01-laporan-keuangan.md
├── Period strip                               ← sudah ada
├── Hero P&L                                   ← sudah ada
├── KPI strip                                  ← sudah ada
├── 💸 Breakdown Biaya                         ← sudah ada
├── 📈 Tren Margin                             ← sudah ada
├── 💳 Metode Pembayaran                       ← BARU (lihat #2)
├── 📊 Titik Impas (Break-Even Point)         ← BARU ✨
│   ├── KPI card: BEP harian total & per cabang
│   ├── Gap indicator: "Revenue Rp17.4jt vs BEP Rp15.2jt → aman Rp2.2jt"
│   ├── Bar chart: revenue aktual vs BEP line per cabang
│   ├── Stat: berapa hari dalam 30d di bawah BEP
│   └── Accordion: formula & cara baca BEP
├── 📊 Quarterly Report                        ← sudah ada
└── 📊 Year-on-Year                            ← sudah ada
```

#### KPI yang ditambahkan

| KPI | Definisi | Contoh |
|-----|----------|--------|
| BEP harian total | `SUM(fixed_cost) / (1 - variable_cost_ratio)` | Rp 15.2 juta |
| BEP per cabang | Sama, per branch_id | Pusat Rp4.8jt, Selatan Rp3.1jt |
| Safety margin hari ini | `actual_revenue - BEP` | +Rp 2.2 juta |
| Hari di bawah BEP (30d) | `COUNT WHERE daily_revenue < daily_BEP` | 4 dari 30 hari |

#### Sumber data & formula

Data dari `mart_daily_net_revenue.sql`. Komponen yang sudah tersedia:
- **Fixed cost** = `building_rent_daily` + `salary_cost`
- **Variable cost** = `inventory_usage_cost` + `meal_allowance_cost` + `overtime_cost` + `operational_total_cost`
- **Revenue** = `gross_revenue`

```sql
-- File: evidence/sources/restaurant/fin_breakeven_30d.sql

WITH daily AS (
    SELECT
        branch_id,
        branch_name,
        metric_date,
        gross_revenue,
        -- Fixed costs (tidak berubah berdasarkan volume)
        building_rent_daily + salary_cost AS fixed_cost_daily,
        -- Variable costs (berubah berdasarkan volume)
        inventory_usage_cost + meal_allowance_cost + overtime_cost
          + operational_total_cost AS variable_cost_daily
    FROM main_marts.mart_daily_net_revenue
    WHERE metric_date >= CURRENT_DATE - INTERVAL '30 days'
),
branch_avg AS (
    SELECT
        branch_id,
        branch_name,
        AVG(fixed_cost_daily)    AS avg_fixed,
        AVG(variable_cost_daily) AS avg_variable,
        AVG(gross_revenue)       AS avg_revenue,
        -- Variable cost ratio
        CASE WHEN AVG(gross_revenue) > 0
             THEN AVG(variable_cost_daily) / AVG(gross_revenue)
             ELSE 1 END AS vcr
    FROM daily
    GROUP BY branch_id, branch_name
)
SELECT
    branch_name,
    ROUND(avg_fixed)    AS avg_fixed_cost,
    ROUND(avg_variable) AS avg_variable_cost,
    ROUND(avg_revenue)  AS avg_revenue,
    ROUND(vcr, 4)       AS variable_cost_ratio,
    -- BEP = Fixed Cost / (1 - Variable Cost Ratio)
    ROUND(avg_fixed / NULLIF(1 - vcr, 0)) AS breakeven_daily,
    ROUND(avg_revenue - (avg_fixed / NULLIF(1 - vcr, 0))) AS safety_margin
FROM branch_avg
ORDER BY breakeven_daily DESC
```

```sql
-- File: evidence/sources/restaurant/fin_breakeven_daily_30d.sql
-- Untuk chart: hari mana saja di bawah BEP

WITH daily AS (
    SELECT
        branch_id,
        branch_name,
        metric_date,
        gross_revenue,
        building_rent_daily + salary_cost AS fixed_cost,
        inventory_usage_cost + meal_allowance_cost + overtime_cost
          + operational_total_cost AS variable_cost
    FROM main_marts.mart_daily_net_revenue
    WHERE metric_date >= CURRENT_DATE - INTERVAL '30 days'
),
with_ratio AS (
    SELECT
        *,
        CASE WHEN gross_revenue > 0
             THEN variable_cost / gross_revenue
             ELSE 1 END AS vcr,
        CASE WHEN (1 - CASE WHEN gross_revenue > 0
                             THEN variable_cost / gross_revenue ELSE 1 END) > 0
             THEN fixed_cost / (1 - CASE WHEN gross_revenue > 0
                                         THEN variable_cost / gross_revenue ELSE 1 END)
             ELSE fixed_cost * 10 END AS breakeven
    FROM daily
)
SELECT
    metric_date,
    branch_name,
    ROUND(gross_revenue) AS revenue,
    ROUND(breakeven)     AS breakeven_point,
    CASE WHEN gross_revenue >= breakeven THEN 'aman' ELSE 'di_bawah_bep' END AS status
FROM with_ratio
ORDER BY metric_date, branch_name
```

#### Visualisasi yang direkomendasikan
- **KPI cards**: BEP per cabang (hijau = aman, merah = di bawah BEP)
- **BarChart + ReferenceLine**: revenue harian per cabang dengan BEP line horizontal
- **Value card**: "X dari 30 hari di bawah BEP"
- **Accordion**: "Cara membaca Titik Impas" + formula BEP owner-friendly

---

### Quick Win #4: 🛒 Basket Analysis (Pola Pembelian Bersamaan)

**Target page**: `evidence/pages/05-menu-performance.md`
**Effort**: ~6 jam
**Prioritas implementasi**: 4

#### Kenapa di Menu Performance?
- "Menu apa yang sering dibeli bareng" = keputusan menu: bundling, paket, cross-sell
- Pelengkap alami Menu Engineering Matrix yang sudah ada
- Insight: menu Lemah yang sering dibeli bareng menu Primadona → jangan hapus dulu, buat bundling

#### Posisi di halaman
```
05-menu-performance.md
├── Hero & health overview                     ← sudah ada
├── Period strip (7d / 30d / Tahun)           ← sudah ada
├── KPI strip                                  ← sudah ada
├── Menu Engineering Matrix                    ← sudah ada
├── Category & Price Tier                      ← sudah ada
├── Trend & Movers                             ← sudah ada
├── Branch playbook                            ← sudah ada
├── 🛒 Pola Pembelian Bersamaan               ← BARU ✨
│   ├── KPI: avg items per order, top combo
│   ├── Top 10 pasangan menu tersering
│   ├── Cards: "Ayam Bakar Madu + Es Teh Manis → 34% order"
│   ├── Rekomendasi: "Buat paket bundling X+Y, estimasi uplift Rp Z"
│   └── Accordion: detail per cabang, matrix lengkap
├── Structural decline 90d                     ← sudah ada
└── Action queue                               ← sudah ada
```

#### KPI yang ditambahkan

| KPI | Definisi | Contoh |
|-----|----------|--------|
| Avg items per order | `COUNT(order_items) / COUNT(DISTINCT order_id)` | 2.1 item |
| Top combo | Pasangan menu dengan co-occurrence tertinggi | Ayam Bakar + Es Teh (34%) |
| Bundling opportunity | Pasangan dengan co-occurrence >25% | 3 pasangan |
| Combo AOV vs non-combo | AOV order yang mengandung top combo vs tidak | +Rp 18K |

#### Sumber data

Data dari `fct_orders` — grain: order_item_id, punya `order_id` + `menu_id`:

```sql
-- File: evidence/sources/restaurant/menu_basket_30d.sql

WITH order_menus AS (
    SELECT DISTINCT
        f.order_id,
        f.menu_id,
        m.menu_name
    FROM main_foundation.fct_orders f
    JOIN main_foundation.dim_menu_items m ON f.menu_id = m.menu_id
    WHERE f.order_date >= CURRENT_DATE - INTERVAL '30 days'
),
pairs AS (
    SELECT
        a.menu_name AS menu_a,
        b.menu_name AS menu_b,
        COUNT(DISTINCT a.order_id) AS pair_count
    FROM order_menus a
    JOIN order_menus b
        ON a.order_id = b.order_id
        AND a.menu_id < b.menu_id   -- hindari duplikat & self-pair
    GROUP BY a.menu_name, b.menu_name
),
total_orders AS (
    SELECT COUNT(DISTINCT order_id) AS total
    FROM main_foundation.fct_orders
    WHERE order_date >= CURRENT_DATE - INTERVAL '30 days'
)
SELECT
    p.menu_a,
    p.menu_b,
    p.pair_count,
    ROUND(p.pair_count * 100.0 / t.total, 1) AS pct_of_orders,
    p.menu_a || ' + ' || p.menu_b AS combo_label
FROM pairs p
CROSS JOIN total_orders t
WHERE p.pair_count >= 50
ORDER BY p.pair_count DESC
LIMIT 15
```

```sql
-- File: evidence/sources/restaurant/menu_basket_kpi_30d.sql

SELECT
    ROUND(COUNT(*) * 1.0 / COUNT(DISTINCT order_id), 1) AS avg_items_per_order,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT menu_id) AS unique_menus_sold
FROM main_foundation.fct_orders
WHERE order_date >= CURRENT_DATE - INTERVAL '30 days'
```

#### Visualisasi yang direkomendasikan
- **Cards**: top 5 combo, masing-masing menampilkan menu_a + menu_b, pair_count, pct_of_orders
- **DataTable** (accordion): full matrix top 15
- **Signal cards**: rekomendasi bundling berdasarkan top combo

---

### Update ke Index & Pusat Aksi

Setelah 4 quick win diimplementasi di page masing-masing, perlu update 2 halaman:

#### Index (Ringkasan) — `evidence/pages/index.md`

Tambahkan KPI ringkas baru:

| KPI Baru | Sumber | Link ke |
|----------|--------|---------|
| % Transaksi Digital (QRIS + Card) | fin_payment_method | → 01-Keuangan |
| Channel dominan hari ini | branch_index_channel_mix | → 02-Branch |
| Top combo menu | menu_basket | → 05-Menu |
| Gap vs BEP hari ini | fin_breakeven | → 01-Keuangan |

#### Pusat Aksi — `evidence/pages/08-pusat-aksi.md`

Update `mart_action_center.sql` untuk menambah alert baru:

| Alert Baru | Threshold | Severity |
|-----------|-----------|----------|
| "Cabang X dependency delivery > 60%" | delivery_pct > 60% | Waspada |
| "X hari di bawah BEP dalam 30 hari" | below_bep_days > 5 | Kritis |
| "Cash ratio turun > 10% vs bulan lalu" | cash_trend < -10% | Pantau |

---

## 7. Gap yang Butuh Data Baru

### 7.1 Food Cost per Menu (P0 — Gap Paling Kritis)

| Aspek | Detail |
|-------|--------|
| **Dampak** | Menu Engineering saat ini hanya berdasarkan popularity (volume × revenue), bukan profitability. Owner bisa salah pertahankan menu populer tapi margin tipis. |
| **Data yang dibutuhkan** | **Opsi A**: Tambah kolom `cost_per_portion` di `raw.menu_items`. **Opsi B**: Buat tabel `raw.recipes` (`menu_id → inventory_id, qty_per_portion`) dan hitung COGS dari `inventory_catalog.base_unit_cost`. |
| **Analisis yang dimungkinkan** | Margin per menu, profit-based menu engineering (4 kuadran berdasarkan profit bukan revenue), food cost % per menu, menu pricing recommendation |
| **Page target** | `05-menu-performance.md` — upgrade Menu Engineering Matrix dari popularity-based → profit-based |
| **Effort** | Medium — perlu update data generator + tambah staging/foundation model + update mart_menu_performance |

### 7.2 Waste / Shrinkage Tracking

| Aspek | Detail |
|-------|--------|
| **Dampak** | Kebocoran bahan baku tidak terdeteksi. Inventory cost bisa tinggi karena waste, bukan karena volume penjualan. |
| **Data yang dibutuhkan** | Tabel `raw.waste_transactions` (`date, branch_id, inventory_id, qty, waste_type: expired/damaged/overcooked, estimated_cost`) |
| **Analisis yang dimungkinkan** | Waste rate per item, waste cost per branch, waste trend, waste vs usage ratio |
| **Page target** | `03-inventori-stok/` — subpage baru atau section di index |
| **Effort** | High — perlu generate data baru + full staging → foundation → mart pipeline |

### 7.3 Customer Satisfaction / Rating

| Aspek | Detail |
|-------|--------|
| **Dampak** | Owner blind terhadap kualitas layanan dan makanan. Revenue bisa turun tanpa early warning dari sisi customer experience. |
| **Data yang dibutuhkan** | Tabel `raw.reviews` (`order_id, rating 1-5, comment, channel: dine-in/delivery-platform/google`) |
| **Analisis yang dimungkinkan** | Avg rating per branch, rating trend, top complaints, correlation rating vs revenue |
| **Page target** | Section di `02-branch-performance/` atau page baru |
| **Effort** | High — perlu generate data + sentiment analysis optional |

### 7.4 Budget vs Actual (Target Setting)

| Aspek | Detail |
|-------|--------|
| **Dampak** | Tidak ada benchmark internal. Owner tidak bisa track apakah cabang on-track terhadap target. |
| **Data yang dibutuhkan** | dbt seed `branch_monthly_targets` (`branch_id, year_month, revenue_target, margin_target, orders_target`) |
| **Analisis yang dimungkinkan** | Actual vs target %, gap analysis, forecast to close month |
| **Page target** | `01-laporan-keuangan.md` dan `02-branch-performance/` |
| **Effort** | Medium — perlu dbt seed + source query + chart dengan target line |

### 7.5 Delivery Platform Fee

| Aspek | Detail |
|-------|--------|
| **Dampak** | Delivery orders (30.2% dari total) kemungkinan kena commission 15-30%, tapi belum masuk P&L. Net revenue bisa overstated. |
| **Data yang dibutuhkan** | Kolom `platform_commission_rate` per order, atau seed table rate per platform |
| **Analisis yang dimungkinkan** | True net revenue per channel, delivery profitability, channel cost comparison |
| **Page target** | `01-laporan-keuangan.md` — tambah di cost breakdown |
| **Effort** | Medium — perlu update data generator + cost calculation di mart |

---

## 8. Verdict & Skor Akhir

### Skor Kecukupan Konten Saat Ini

| Konteks | Skor | Catatan |
|---------|------|---------|
| **Untuk demo / pitch** | **8.5/10** | Sudah jauh di atas rata-rata. 7 modul + action queue = compelling. |
| **Untuk owner harian** | **7/10** | Blocker: food cost per menu. Quick win bisa naikkan ke 8/10. |
| **Untuk SaaS production** | **5.5/10** | Butuh auth, multi-tenant, billing, data onboarding, PII masking. |

### Proyeksi Setelah Quick Win (4 item, ~15 jam)

| Konteks | Skor Baru | Delta |
|---------|-----------|-------|
| Demo / pitch | **9/10** | +0.5 (channel + payment = lebih lengkap) |
| Owner harian | **8/10** | +1.0 (BEP + payment + basket = keputusan lebih baik) |
| SaaS production | 5.5/10 | Tidak berubah (butuh infrastruktur, bukan konten) |

### Proyeksi Setelah Food Cost per Menu (P0)

| Konteks | Skor Baru | Delta |
|---------|-----------|-------|
| Demo / pitch | **9.5/10** | Menu engineering profit-based = killer feature |
| Owner harian | **9/10** | Semua keputusan menu jadi data-driven |

### Ringkasan Prioritas Keseluruhan

| Prioritas | Item | Effort | Impact | Status Data |
|-----------|------|--------|--------|-------------|
| **1** | Channel Mix per Cabang | ~2 jam | 🔥🔥 | ✅ Data di mart |
| **2** | Payment Method Analysis | ~3 jam | 🔥🔥 | ✅ Data di fct_orders |
| **3** | Break-Even Point | ~4-6 jam | 🔥🔥 | ✅ Data di mart |
| **4** | Basket Analysis | ~6 jam | 🔥 | ✅ Data di fct_orders |
| **5** | Food Cost per Menu | Medium | 🔥🔥🔥 | ❌ Perlu data baru |
| **6** | Budget vs Actual | Medium | 🔥🔥 | ❌ Perlu seed table |
| **7** | Waste Tracking | High | 🔥🔥 | ❌ Perlu data baru |
| **8** | Customer Rating | High | 🔥 | ❌ Perlu data baru |
| **9** | Platform Fee | Medium | 🔥 | ❌ Perlu data baru |

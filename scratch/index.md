---
title: Wekadata — Ringkasan Performa Bisnis
---


<style>
.table-scroll-container {
  overflow-x: auto;
  width: 100%;
  -webkit-overflow-scrolling: touch;
  margin: 14px 0;
  border-radius: 8px;
}

.table-scroll-container table {
  width: 100%;
  min-width: 650px;
}

.table-scroll-container th,
.table-scroll-container td {
  white-space: nowrap;
}

/* Cockpit Hero Health Card Styles */
.hero-health-card {
  border-radius: 16px;
  padding: 24px;
  margin-bottom: 24px;
  border: 1px solid rgba(128,128,128,0.15);
  box-shadow: 0 4px 20px rgba(0,0,0,0.03);
  transition: all 0.3s ease;
}
.hero-health-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 24px rgba(0,0,0,0.05);
}
.hero-health-card.status-sehat {
  border-color: rgba(34,197,94,0.3);
  background: linear-gradient(135deg, rgba(34,197,94,0.08) 0%, rgba(34,197,94,0.02) 100%);
}
.hero-health-card.status-waspada {
  border-color: rgba(234,179,8,0.3);
  background: linear-gradient(135deg, rgba(234,179,8,0.08) 0%, rgba(234,179,8,0.02) 100%);
}
.hero-health-card.status-kritis {
  border-color: rgba(239,68,68,0.3);
  background: linear-gradient(135deg, rgba(239,68,68,0.08) 0%, rgba(239,68,68,0.02) 100%);
}

.hero-card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}
.hero-card-badge {
  font-size: 0.75rem;
  font-weight: 700;
  text-transform: uppercase;
  padding: 4px 12px;
  border-radius: 99px;
  letter-spacing: 0.05em;
}
.hero-health-card.status-sehat .hero-card-badge {
  background: rgba(34,197,94,0.15);
  color: #15803d;
}
.hero-health-card.status-waspada .hero-card-badge {
  background: rgba(234,179,8,0.15);
  color: #a16207;
}
.hero-health-card.status-kritis .hero-card-badge {
  background: rgba(239,68,68,0.15);
  color: #b91c1c;
}

.hero-card-title {
  font-size: 1.5rem;
  font-weight: 800;
  margin-bottom: 8px;
  line-height: 1.25;
}
.hero-health-card.status-sehat .hero-card-title { color: #166534; }
.hero-health-card.status-waspada .hero-card-title { color: #854d0e; }
.hero-health-card.status-kritis .hero-card-title { color: #991b1b; }

.hero-card-desc {
  font-size: 0.95rem;
  line-height: 1.6;
  color: var(--color-text-secondary);
  margin-bottom: 20px;
}

.hero-card-metrics {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 16px;
  border-top: 1px solid rgba(128,128,128,0.15);
  padding-top: 16px;
}
.hero-metric-item {
  display: flex;
  flex-direction: column;
}
.hero-metric-label {
  font-size: 0.75rem;
  text-transform: uppercase;
  color: var(--color-text-tertiary);
  font-weight: 600;
  margin-bottom: 4px;
}
.hero-metric-value {
  font-size: 1.25rem;
  font-weight: 700;
  color: var(--color-text-primary);
}
</style>

```sql tgl
SELECT
    DAY(MAX(order_date)) || ' ' ||
    CASE MONTH(MAX(order_date))
        WHEN 1 THEN 'Januari' WHEN 2 THEN 'Februari' WHEN 3 THEN 'Maret'
        WHEN 4 THEN 'April'   WHEN 5 THEN 'Mei'       WHEN 6 THEN 'Juni'
        WHEN 7 THEN 'Juli'    WHEN 8 THEN 'Agustus'   WHEN 9 THEN 'September'
        WHEN 10 THEN 'Oktober' WHEN 11 THEN 'November' WHEN 12 THEN 'Desember'
    END || ' ' || YEAR(MAX(order_date)) AS tanggal_display,
    CASE DAYNAME(MAX(order_date))
        WHEN 'Monday' THEN 'Senin' WHEN 'Tuesday' THEN 'Selasa'
        WHEN 'Wednesday' THEN 'Rabu' WHEN 'Thursday' THEN 'Kamis'
        WHEN 'Friday' THEN 'Jumat' WHEN 'Saturday' THEN 'Sabtu'
        WHEN 'Sunday' THEN 'Minggu'
    END AS nama_hari
FROM restaurant.daily_revenue
```

```sql pct_change
SELECT
    ROUND(pct_change * 100, 1)      AS pct_change_display,
    ABS(ROUND(pct_change * 100, 1)) AS pct_change_abs,
    CASE WHEN pct_change > 0.10 THEN 'naik' WHEN pct_change < -0.10 THEN 'turun' ELSE 'stabil' END AS kondisi
FROM (
    SELECT ROUND((today_rev - avg_sdow) / NULLIF(avg_sdow, 0), 3) AS pct_change
    FROM (
        SELECT
            SUM(CASE WHEN order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue) THEN daily_total ELSE 0 END) AS today_rev,
            AVG(CASE WHEN order_date < (SELECT MAX(order_date) FROM restaurant.daily_revenue)
                AND DAYOFWEEK(order_date) = DAYOFWEEK((SELECT MAX(order_date) FROM restaurant.daily_revenue))
                AND order_date >= (SELECT MAX(order_date) FROM restaurant.daily_revenue) - INTERVAL '30 days'
                THEN daily_total END) AS avg_sdow
        FROM (SELECT order_date, SUM(total_revenue) AS daily_total FROM restaurant.daily_revenue
              WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.daily_revenue) - INTERVAL '30 days'
              GROUP BY order_date)
    )
)
```

```sql best_branch
SELECT branch_name, total_revenue FROM restaurant.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)
ORDER BY total_revenue DESC LIMIT 1
```

```sql top_menu_today
SELECT menu_name FROM restaurant.menu_performance
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.menu_performance)
ORDER BY total_qty_sold DESC LIMIT 1
```

```sql declining_branches
SELECT COUNT(*) AS jumlah_cabang, MIN(branch_name) AS cabang_terparah
FROM restaurant.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)
  AND pct_change_vs_sdow_avg < -0.20
```

```sql insights
SELECT branch_name, ROUND(pct_change_vs_sdow_avg * 100, 1) AS pct_change
FROM restaurant.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)
  AND pct_change_vs_sdow_avg < -0.15
ORDER BY pct_change_vs_sdow_avg ASC LIMIT 3
```

```sql menu_alerts
SELECT menu_name, ROUND(qty_wow_change * 100, 1) AS pct_change
FROM restaurant.menu_performance
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.menu_performance)
  AND qty_wow_change < -0.20
ORDER BY qty_wow_change ASC LIMIT 3
```

```sql attendance_alerts
SELECT COUNT(*) AS jumlah_absent FROM restaurant.employee_shift_performance
WHERE attendance_date = (SELECT MAX(attendance_date) FROM restaurant.employee_shift_performance)
  AND attendance_status = 'absent'
```

```sql fin_kpi_yesterday
SELECT SUM(gross_revenue) AS gross_revenue, SUM(net_revenue) AS net_revenue,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS net_margin_pct
FROM restaurant.daily_net_revenue
WHERE metric_date = (SELECT MAX(metric_date) FROM restaurant.daily_net_revenue)
```

```sql fin_sdow_yesterday
WITH daily_total AS (
    SELECT order_date, SUM(total_revenue) AS daily_rev
    FROM restaurant.daily_revenue
    GROUP BY order_date
),
max_d AS (SELECT MAX(order_date) AS d FROM restaurant.daily_revenue)
SELECT
    (SELECT daily_rev FROM daily_total WHERE order_date = (SELECT d FROM max_d)) AS gross_yesterday,
    ROUND(AVG(daily_rev), 0)                                                      AS sdow_avg,
    ROUND(
        ((SELECT daily_rev FROM daily_total WHERE order_date = (SELECT d FROM max_d)) - AVG(daily_rev))
        / NULLIF(AVG(daily_rev), 0) * 100
    , 1)                                                                           AS pct_change_sdow
FROM daily_total, max_d
WHERE order_date < d
  AND DAYOFWEEK(order_date) = DAYOFWEEK(d)
  AND order_date >= d - INTERVAL '30 days'
```

```sql fin_sdow_branch_yesterday
WITH max_d AS (SELECT MAX(order_date) AS d FROM restaurant.daily_revenue),
sdow_avg AS (
    SELECT branch_name,
        ROUND(AVG(total_revenue), 0) AS sdow_avg
    FROM restaurant.daily_revenue, max_d
    WHERE order_date < d
      AND DAYOFWEEK(order_date) = DAYOFWEEK(d)
      AND order_date >= d - INTERVAL '30 days'
    GROUP BY branch_name
),
today AS (
    SELECT branch_name, total_revenue AS gross_yesterday
    FROM restaurant.daily_revenue, max_d
    WHERE order_date = d
)
SELECT
    t.branch_name,
    t.gross_yesterday,
    s.sdow_avg,
    ROUND((t.gross_yesterday - s.sdow_avg) / NULLIF(s.sdow_avg, 0) * 100, 1) AS pct_change_sdow
FROM today t
LEFT JOIN sdow_avg s ON t.branch_name = s.branch_name
ORDER BY pct_change_sdow DESC
```

```sql fin_margin_branch_yesterday
SELECT branch_name,
    ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS net_margin_pct,
    CASE WHEN ROUND(SUM(net_revenue)/NULLIF(SUM(gross_revenue),0)*100,1) >= 15 THEN ROUND(SUM(net_revenue)/NULLIF(SUM(gross_revenue),0)*100,1) ELSE NULL END AS margin_sehat,
    CASE WHEN ROUND(SUM(net_revenue)/NULLIF(SUM(gross_revenue),0)*100,1) >= 10 AND ROUND(SUM(net_revenue)/NULLIF(SUM(gross_revenue),0)*100,1) < 15 THEN ROUND(SUM(net_revenue)/NULLIF(SUM(gross_revenue),0)*100,1) ELSE NULL END AS margin_waspada,
    CASE WHEN ROUND(SUM(net_revenue)/NULLIF(SUM(gross_revenue),0)*100,1) < 10 THEN ROUND(SUM(net_revenue)/NULLIF(SUM(gross_revenue),0)*100,1) ELSE NULL END AS margin_kritis
FROM restaurant.daily_net_revenue
WHERE metric_date = (SELECT MAX(metric_date) FROM restaurant.daily_net_revenue)
GROUP BY branch_name ORDER BY net_margin_pct DESC
```

```sql branch_kpi_yesterday
SELECT branch_name, total_revenue, total_orders,
    ROUND(total_revenue / NULLIF(total_orders, 0), 0) AS avg_order_value,
    ROUND(revenue_sdow_avg, 0)                        AS revenue_sdow_avg,
    pct_change_vs_sdow_avg
FROM restaurant.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)
ORDER BY total_revenue DESC
```

```sql branch_agg_yesterday
SELECT
    SUM(total_orders) AS total_orders_all,
    ROUND(SUM(total_revenue) / NULLIF(SUM(total_orders), 0), 0) AS aov_avg,
    ROUND((MAX(total_revenue) - MIN(total_revenue)) / NULLIF(MIN(total_revenue), 0) * 100, 1) AS gap_pct
FROM restaurant.daily_revenue
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)
```

```sql menu_top_yesterday
SELECT menu_name,
    CASE category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman'
        WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert' ELSE category END AS category,
    SUM(total_qty_sold) AS total_qty, SUM(total_revenue) AS total_revenue
FROM restaurant.menu_performance
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.menu_performance)
GROUP BY menu_name, category ORDER BY total_qty DESC LIMIT 5
```

```sql menu_kpi_agg_yesterday
SELECT
    ROUND(SUM(CASE WHEN rn = 1 THEN total_revenue END) * 100.0 / NULLIF(SUM(total_revenue), 0), 1) AS kontribusi_pct,
    COUNT(DISTINCT menu_name) AS total_menu,
    COUNT(DISTINCT menu_name) AS menu_aktif,
    100.0 AS pct_menu_aktif,
    COUNT(DISTINCT menu_name) || ' dari ' || COUNT(DISTINCT menu_name) || ' menu' AS menu_aktif_label
FROM (
    SELECT menu_name,
        SUM(total_revenue) AS total_revenue,
        ROW_NUMBER() OVER (ORDER BY SUM(total_revenue) DESC) AS rn
    FROM restaurant.menu_performance
    WHERE order_date = (SELECT MAX(order_date) FROM restaurant.menu_performance)
    GROUP BY menu_name
)
```

```sql member_kpi_yesterday
SELECT
    COUNT(DISTINCT member_id) AS member_aktif,
    ROUND(SUM(total_orders)*100.0/NULLIF(
        (SELECT SUM(total_orders) FROM restaurant.daily_revenue
         WHERE order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue))
    ,0),1) AS pct_order_member,
    ROUND(SUM(total_orders)*1.0/NULLIF(COUNT(DISTINCT member_id),0),1) AS avg_frekuensi
FROM restaurant.member_purchase_behavior
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior)
```

```sql member_tier_yesterday
SELECT
    tier,
    COUNT(DISTINCT member_id)                                    AS total_member,
    SUM(total_spend)                                             AS total_belanja,
    ROUND(SUM(total_orders)*1.0/NULLIF(COUNT(DISTINCT member_id),0),1) AS avg_frekuensi
FROM restaurant.member_purchase_behavior
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior)
GROUP BY tier ORDER BY total_belanja DESC
```

```sql att_kpi_yesterday
SELECT
    SUM(is_present + is_late)                                                                    AS hadir,
    SUM(is_absent)                                                                               AS absent,
    SUM(is_late)                                                                                 AS terlambat,
    ROUND(SUM(is_present + is_late)*100.0/NULLIF(SUM(is_present+is_late+is_absent),0),1)        AS pct_hadir,
    ROUND(SUM(is_late)*100.0/NULLIF(SUM(is_present+is_late),0),1)                               AS pct_terlambat,
    (SELECT shift_name FROM restaurant.employee_shift_performance
     WHERE attendance_date = (SELECT MAX(attendance_date) FROM restaurant.employee_shift_performance)
     GROUP BY shift_name ORDER BY SUM(total_revenue) DESC LIMIT 1)                              AS shift_tersibuk
FROM restaurant.employee_shift_performance
WHERE attendance_date = (SELECT MAX(attendance_date) FROM restaurant.employee_shift_performance)
```

```sql att_branch_yesterday
SELECT
    branch_name,
    ROUND(SUM(is_present+is_late)*100.0/NULLIF(SUM(is_present+is_late+is_absent),0),1) AS pct_hadir
FROM restaurant.employee_shift_performance
WHERE attendance_date = (SELECT MAX(attendance_date) FROM restaurant.employee_shift_performance)
GROUP BY branch_name ORDER BY pct_hadir DESC
```

```sql shift_kpi_yesterday
SELECT shift_name, SUM(orders_handled) AS total_orders, SUM(total_revenue) AS total_revenue,
    ROUND(AVG(avg_ticket),0) AS avg_ticket
FROM restaurant.employee_shift_performance
WHERE attendance_date = (SELECT MAX(attendance_date) FROM restaurant.employee_shift_performance)
GROUP BY shift_name ORDER BY total_revenue DESC
```

```sql inv_kpi_yesterday
SELECT
    i.total_biaya_bahan,
    ROUND(i.total_biaya_bahan / NULLIF(f.gross_revenue, 0) * 100, 1) AS pct_dari_revenue,
    ROUND(i.total_beli / NULLIF(i.total_pakai, 0), 2)                AS rasio_beli_pakai,
    i.kategori_tertinggi
FROM (
    SELECT
        SUM(usage_cost)    AS total_pakai,
        SUM(purchase_cost) AS total_beli,
        SUM(usage_cost)    AS total_biaya_bahan,
        (SELECT category FROM restaurant.inventory_stok
         WHERE txn_date = (SELECT MAX(txn_date) FROM restaurant.inventory_stok)
         GROUP BY category ORDER BY SUM(usage_cost) DESC LIMIT 1) AS kategori_tertinggi
    FROM restaurant.inventory_stok
    WHERE txn_date = (SELECT MAX(txn_date) FROM restaurant.inventory_stok)
) i
CROSS JOIN (
    SELECT SUM(gross_revenue) AS gross_revenue
    FROM restaurant.daily_net_revenue
    WHERE metric_date = (SELECT MAX(metric_date) FROM restaurant.daily_net_revenue)
) f
```

```sql inv_cat_yesterday
SELECT category, SUM(usage_cost) AS biaya_pakai, SUM(purchase_cost) AS biaya_beli
FROM restaurant.inventory_stok
WHERE txn_date = (SELECT MAX(txn_date) FROM restaurant.inventory_stok)
GROUP BY category ORDER BY biaya_pakai DESC
```

```sql inv_item_yesterday
SELECT
    item_name,
    category,
    ROUND(SUM(usage_cost), 0)                              AS biaya_pakai,
    ROUND(SUM(purchase_cost), 0)                           AS biaya_beli,
    ROUND(SUM(purchase_cost)/NULLIF(SUM(usage_cost),0), 2) AS rasio
FROM restaurant.inventory_stok
WHERE txn_date = (SELECT MAX(txn_date) FROM restaurant.inventory_stok)
GROUP BY item_name, category
ORDER BY rasio DESC
```

```sql peak_yesterday
SELECT order_hour, order_type, SUM(total_orders) AS total_orders
FROM restaurant.peak_hours
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.peak_hours)
GROUP BY order_hour, order_type ORDER BY order_hour
```

```sql peak_daypart_yesterday
SELECT day_part AS periode, SUM(total_orders) AS total_orders
FROM restaurant.peak_hours
WHERE order_date = (SELECT MAX(order_date) FROM restaurant.peak_hours)
GROUP BY day_part ORDER BY total_orders DESC LIMIT 1
```

```sql peak_kpi_yesterday
SELECT
    CAST(h.peak_hour AS INTEGER) || ':00' AS jam_puncak,
    h.day_part AS periode_puncak,
    h.peak_orders,
    ROUND(h.peak_orders * 100.0 / h.total_all, 1) AS pct_jam_puncak,
    CASE d.order_type
        WHEN 'dine_in'  THEN 'Dine In'
        WHEN 'takeaway' THEN 'Takeaway'
        WHEN 'delivery' THEN 'Delivery'
        ELSE d.order_type
    END AS order_type_dominan
FROM (
    SELECT order_hour AS peak_hour, day_part,
        SUM(total_orders) AS peak_orders,
        SUM(SUM(total_orders)) OVER () AS total_all
    FROM restaurant.peak_hours
    WHERE order_date = (SELECT MAX(order_date) FROM restaurant.peak_hours)
    GROUP BY order_hour, day_part
    ORDER BY peak_orders DESC LIMIT 1
) h
CROSS JOIN (
    SELECT order_type
    FROM restaurant.peak_hours
    WHERE order_date = (SELECT MAX(order_date) FROM restaurant.peak_hours)
    AND order_hour = (
        SELECT order_hour FROM restaurant.peak_hours
        WHERE order_date = (SELECT MAX(order_date) FROM restaurant.peak_hours)
        GROUP BY order_hour ORDER BY SUM(total_orders) DESC LIMIT 1
    )
    GROUP BY order_type ORDER BY SUM(total_orders) DESC LIMIT 1
) d
```

```sql health_yesterday
-- 1. Keuangan — SDOW Revenue vs Kemarin
SELECT 'Keuangan' AS section, '💰' AS icon,
    CASE WHEN p >= -5 THEN 'sehat' WHEN p >= -15 THEN 'perhatian' ELSE 'kritis' END AS status,
    CASE WHEN p >= -5  THEN 'Revenue kemarin ' || p || '% vs rata-rata hari serupa (30h), normal'
         WHEN p >= -15 THEN 'Revenue kemarin ' || p || '% vs rata-rata hari serupa, di bawah normal'
         ELSE               'Revenue kemarin ' || p || '% vs rata-rata hari serupa, drop signifikan' END AS label,
    'vs Hari Serupa' AS metrik
FROM (
    SELECT ROUND(
        (SUM(CASE WHEN order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)
            THEN total_revenue ELSE 0 END)
        - AVG(CASE
            WHEN order_date < (SELECT MAX(order_date) FROM restaurant.daily_revenue)
            AND DAYOFWEEK(order_date) = DAYOFWEEK((SELECT MAX(order_date) FROM restaurant.daily_revenue))
            AND order_date >= (SELECT MAX(order_date) FROM restaurant.daily_revenue) - INTERVAL '30 days'
            THEN total_revenue END))
        / NULLIF(AVG(CASE
            WHEN order_date < (SELECT MAX(order_date) FROM restaurant.daily_revenue)
            AND DAYOFWEEK(order_date) = DAYOFWEEK((SELECT MAX(order_date) FROM restaurant.daily_revenue))
            AND order_date >= (SELECT MAX(order_date) FROM restaurant.daily_revenue) - INTERVAL '30 days'
            THEN total_revenue END), 0) * 100
    , 1) AS p
    FROM restaurant.daily_revenue
    WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.daily_revenue) - INTERVAL '30 days'
)
UNION ALL
-- 2. Cabang — AOV
SELECT 'Cabang', '🏪',
    CASE WHEN aov < 35000 THEN 'kritis' WHEN aov < 50000 THEN 'perhatian' ELSE 'sehat' END,
    CASE WHEN aov < 35000 THEN 'AOV Rp ' || aov || ', di bawah ambang kritis Rp 35.000'
         WHEN aov < 50000 THEN 'AOV Rp ' || aov || ', mendekati target Rp 50.000'
         ELSE 'AOV Rp ' || aov || ', di atas target' END,
    'AOV'
FROM (SELECT ROUND(SUM(total_revenue)/NULLIF(SUM(total_orders),0),0) AS aov
      FROM restaurant.daily_revenue
      WHERE order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue))
UNION ALL
-- 3. Cabang — Gap Antar Cabang
SELECT 'Cabang', '🏪',
    CASE WHEN g > 100 THEN 'kritis' WHEN g >= 50 THEN 'perhatian' ELSE 'sehat' END,
    CASE WHEN g > 100 THEN 'Gap antar cabang ' || g || '%, cabang bawah jauh tertinggal'
         WHEN g >= 50 THEN 'Gap antar cabang ' || g || '%, cabang bawah perlu perhatian'
         ELSE 'Gap ' || g || '%, performa antar cabang merata' END,
    'Gap Cabang'
FROM (SELECT ROUND((MAX(total_revenue)-MIN(total_revenue))/NULLIF(MIN(total_revenue),0)*100,1) AS g
      FROM restaurant.daily_revenue
      WHERE order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue))
UNION ALL
-- 4. Menu — Kontribusi Menu Terlaris
SELECT 'Menu', '🍽️',
    CASE WHEN k > 50 THEN 'kritis' WHEN k > 30 THEN 'perhatian' ELSE 'sehat' END,
    CASE WHEN k > 50 THEN 'Menu terlaris dominasi ' || k || '% revenue, ketergantungan tinggi'
         WHEN k > 30 THEN 'Menu terlaris ' || k || '% revenue, mulai bergantung'
         ELSE k || '% kontribusi menu terlaris, distribusi sehat' END,
    'Kontribusi Menu'
FROM (
    SELECT ROUND(SUM(CASE WHEN rn=1 THEN total_revenue END)*100.0/NULLIF(SUM(total_revenue),0),1) AS k
    FROM (SELECT menu_name, SUM(total_revenue) AS total_revenue,
              ROW_NUMBER() OVER (ORDER BY SUM(total_revenue) DESC) AS rn
          FROM restaurant.menu_performance
          WHERE order_date = (SELECT MAX(order_date) FROM restaurant.menu_performance)
          GROUP BY menu_name)
)
UNION ALL
-- 5. Member — Order dari Member
SELECT 'Member', '👥',
    CASE WHEN p < 20 THEN 'kritis' WHEN p < 40 THEN 'perhatian' ELSE 'sehat' END,
    CASE WHEN p < 20 THEN 'Hanya ' || p || '% order dari member, program loyalitas perlu evaluasi'
         WHEN p < 40 THEN p || '% order dari member, potensi belum maksimal'
         ELSE p || '% order dari member, program loyalitas aktif' END,
    'Order Member'
FROM (
    SELECT ROUND(SUM(total_orders)*100.0/NULLIF(
        (SELECT SUM(total_orders) FROM restaurant.daily_revenue
         WHERE order_date = (SELECT MAX(order_date) FROM restaurant.daily_revenue)),0),1) AS p
    FROM restaurant.member_purchase_behavior
    WHERE order_date = (SELECT MAX(order_date) FROM restaurant.member_purchase_behavior)
)
UNION ALL
-- 6. Pegawai — Kehadiran
SELECT 'Pegawai', '👨‍💼',
    CASE WHEN h < 85 THEN 'kritis' WHEN h < 95 THEN 'perhatian' ELSE 'sehat' END,
    CASE WHEN h < 85 THEN 'Kehadiran ' || h || '%, di bawah ambang kritis 85%'
         WHEN h < 95 THEN 'Kehadiran ' || h || '%, perlu perhatian'
         ELSE 'Kehadiran ' || h || '%, baik' END,
    'Kehadiran'
FROM (
    SELECT ROUND(SUM(is_present+is_late)*100.0/NULLIF(SUM(is_present+is_late+is_absent),0),1) AS h
    FROM restaurant.employee_shift_performance
    WHERE attendance_date = (SELECT MAX(attendance_date) FROM restaurant.employee_shift_performance)
)
UNION ALL
-- 7. Pegawai — Keterlambatan
SELECT 'Pegawai', '👨‍💼',
    CASE WHEN t > 20 THEN 'kritis' WHEN t > 10 THEN 'perhatian' ELSE 'sehat' END,
    CASE WHEN t > 20 THEN t || '% pegawai terlambat, masalah disiplin serius'
         WHEN t > 10 THEN t || '% pegawai terlambat, perlu perhatian'
         ELSE t || '% keterlambatan, disiplin baik' END,
    'Keterlambatan'
FROM (
    SELECT ROUND(SUM(is_late)*100.0/NULLIF(SUM(is_present+is_late),0),1) AS t
    FROM restaurant.employee_shift_performance
    WHERE attendance_date = (SELECT MAX(attendance_date) FROM restaurant.employee_shift_performance)
)
UNION ALL
-- 8. Inventori — Biaya Bahan
SELECT 'Inventori', '📦',
    CASE WHEN b > 38 THEN 'kritis' WHEN b > 32 THEN 'perhatian' ELSE 'sehat' END,
    CASE WHEN b > 38 THEN 'Biaya bahan ' || b || '% revenue, di atas ambang kritis 38%'
         WHEN b > 32 THEN 'Biaya bahan ' || b || '% revenue, perlu perhatian'
         ELSE 'Biaya bahan ' || b || '% revenue, normal' END,
    'Biaya Bahan'
FROM (
    SELECT ROUND(SUM(usage_cost)*100.0/NULLIF(
        (SELECT SUM(gross_revenue) FROM restaurant.daily_net_revenue
         WHERE metric_date = (SELECT MAX(metric_date) FROM restaurant.daily_net_revenue)),0),1) AS b
    FROM restaurant.inventory_stok
    WHERE txn_date = (SELECT MAX(txn_date) FROM restaurant.inventory_stok)
)
UNION ALL
-- 9. Inventori — Rasio Beli/Pakai
SELECT 'Inventori', '📦',
    CASE WHEN r > 1.5 THEN 'kritis'
         WHEN r > 1.2 OR r < 0.9 THEN 'perhatian'
         ELSE 'sehat' END,
    CASE WHEN r > 1.5 THEN 'Rasio beli/pakai ' || r || ', over-purchasing berbahaya'
         WHEN r > 1.2 THEN 'Rasio beli/pakai ' || r || ', pembelian mulai berlebih'
         WHEN r = 0 THEN 'Tidak ada data pembelian kemarin'
         WHEN r < 0.9 THEN 'Rasio beli/pakai ' || r || ', stok terkuras'
         ELSE 'Rasio beli/pakai ' || r || ', normal' END,
    'Rasio Beli/Pakai'
FROM (
    SELECT ROUND(SUM(purchase_cost)/NULLIF(SUM(usage_cost),0),2) AS r
    FROM restaurant.inventory_stok
    WHERE txn_date = (SELECT MAX(txn_date) FROM restaurant.inventory_stok)
)
UNION ALL
-- 10. Jam Sibuk — Konsentrasi Order
SELECT 'Jam Sibuk', '⏰',
    CASE WHEN p > 20 THEN 'kritis' WHEN p > 12 THEN 'perhatian' ELSE 'sehat' END,
    CASE WHEN p > 20 THEN p || '% order terkonsentrasi di satu jam, risiko operasional tinggi'
         WHEN p > 12 THEN p || '% order di jam puncak, perhatikan alokasi staf'
         ELSE 'Order terdistribusi merata, ' || p || '% di jam puncak' END,
    'Konsentrasi Order'
FROM (
    SELECT ROUND(MAX(jam_total)*100.0/NULLIF(SUM(jam_total),0),1) AS p
    FROM (SELECT order_hour, SUM(total_orders) AS jam_total FROM restaurant.peak_hours
          WHERE order_date = (SELECT MAX(order_date) FROM restaurant.peak_hours)
          GROUP BY order_hour)
)
```

---

_Data diperbarui otomatis setiap hari. Laporan berikut mencakup operasional **{tgl[0].nama_hari}, {tgl[0].tanggal_display}**._

---


<div class="evidence-tabs-container" style="margin-bottom: 24px;">
  <a href="/" class="tab-button active">📅 Kemarin</a>
  <a href="/7d" class="tab-button">📊 7 Hari</a>
  <a href="/30d" class="tab-button">🔭 30 Hari</a>
</div>



---

_Data diperbarui otomatis setiap hari. Laporan berikut mencakup operasional **{tgl[0].nama_hari}, {tgl[0].tanggal_display}**._

---



{#if pct_change[0].kondisi === 'naik'}
<div style="margin:24px 0 4px;">
<div style="font-size:1.55em;font-weight:700;color:#166534;line-height:1.3;margin-bottom:6px;">
Revenue kemarin naik {pct_change[0].pct_change_display}% 🎉
</div>
<div style="font-size:0.95em;color:var(--color-text-secondary);margin-bottom:18px;">
Dibanding rata-rata hari {tgl[0].nama_hari} dalam 30 hari terakhir. Cabang terbaik: <strong>{best_branch[0].branch_name}</strong> — menu terlaris: <strong>{top_menu_today[0].menu_name}</strong>.
</div>
</div>
{:else if pct_change[0].kondisi === 'turun'}
<div style="margin:24px 0 4px;">
<div style="font-size:1.55em;font-weight:700;color:#991b1b;line-height:1.3;margin-bottom:6px;">
Revenue kemarin turun {pct_change[0].pct_change_abs}% ⚠️
</div>
<div style="font-size:0.95em;color:var(--color-text-secondary);margin-bottom:18px;">
Dibanding rata-rata hari {tgl[0].nama_hari} dalam 30 hari terakhir. Cek indikator di bawah untuk tahu area mana yang perlu perhatian.
</div>
</div>
{:else}
<div style="margin:24px 0 4px;">
<div style="font-size:1.55em;font-weight:700;color:var(--color-text-primary);line-height:1.3;margin-bottom:6px;">
Halo, Owner! 👋
</div>
<div style="font-size:0.95em;color:var(--color-text-secondary);margin-bottom:18px;">
Performa kemarin stabil dibanding rata-rata hari {tgl[0].nama_hari}. Cabang terbaik: <strong>{best_branch[0].branch_name}</strong> — menu terlaris: <strong>{top_menu_today[0].menu_name}</strong>.
</div>
</div>
{/if}

<div style="background:var(--color-background-secondary);border:1px solid var(--color-border-tertiary);border-radius:12px;padding:1.1rem 1.3rem;margin-bottom:24px;box-shadow:0 1px 3px rgba(0,0,0,0.04);">

<div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:14px;padding-bottom:12px;border-bottom:1px solid var(--color-border-tertiary);flex-wrap:wrap;gap:8px;">
<span style="font-size:12px;font-weight:600;letter-spacing:0.05em;text-transform:uppercase;color:var(--color-text-tertiary);">Ringkasan {health_yesterday.length} Indikator</span>
<div style="display:flex;align-items:center;gap:8px;flex-wrap:wrap;">
<span style="display:inline-flex;align-items:center;gap:5px;padding:3px 10px;border-radius:20px;font-size:12px;font-weight:600;background:rgba(22,163,74,0.10);color:#166534;border:1px solid rgba(22,163,74,0.2);">
<svg width="10" height="10" viewBox="0 0 10 10" fill="none"><path d="M2 5l2.5 2.5L8 3" stroke="#166534" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
{health_yesterday.filter(r => r.status === 'sehat').length} sehat
</span>
<span style="display:inline-flex;align-items:center;gap:5px;padding:3px 10px;border-radius:20px;font-size:12px;font-weight:600;background:rgba(234,179,8,0.10);color:#854d0e;border:1px solid rgba(234,179,8,0.25);">
<svg width="10" height="10" viewBox="0 0 10 10" fill="none"><path d="M5 2v3.5M5 7.5v.5" stroke="#854d0e" stroke-width="1.5" stroke-linecap="round"/></svg>
{health_yesterday.filter(r => r.status === 'perhatian').length} perlu perhatian
</span>
<span style="display:inline-flex;align-items:center;gap:5px;padding:3px 10px;border-radius:20px;font-size:12px;font-weight:600;background:rgba(220,38,38,0.08);color:#991b1b;border:1px solid rgba(220,38,38,0.2);">
<svg width="10" height="10" viewBox="0 0 10 10" fill="none"><path d="M3 3l4 4M7 3l-4 4" stroke="#991b1b" stroke-width="1.5" stroke-linecap="round"/></svg>
{health_yesterday.filter(r => r.status === 'kritis').length} kritis
</span>
</div>
</div>

{#if health_yesterday.filter(r => r.status === 'kritis').length === 0 && health_yesterday.filter(r => r.status === 'perhatian').length === 0}
<div style="display:flex;align-items:center;gap:10px;padding:10px 12px;background:rgba(22,163,74,0.06);border-radius:8px;font-size:13px;color:#166534;">
<svg width="16" height="16" viewBox="0 0 16 16" fill="none"><circle cx="8" cy="8" r="7" stroke="#16a34a" stroke-width="1.5"/><path d="M5 8l2.5 2.5L11 5.5" stroke="#16a34a" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
<strong>Semua indikator sehat</strong> — tidak ada area yang perlu perhatian kemarin
</div>
{:else}
{#each health_yesterday.filter(r => r.status === 'kritis') as row}
<div style="display:flex;align-items:flex-start;gap:10px;padding:8px 10px;margin-bottom:4px;background:rgba(220,38,38,0.04);border:1px solid rgba(220,38,38,0.12);border-radius:8px;font-size:13px;">
<div style="width:7px;height:7px;border-radius:50%;background:#dc2626;flex-shrink:0;margin-top:4px;"></div>
<div><span style="font-weight:600;color:#991b1b;">{row.icon} {row.section}</span> <span style="color:var(--color-text-secondary);">·</span> <span style="color:var(--color-text-secondary);">{row.metrik}</span> — {row.label}</div>
</div>
{/each}
{#each health_yesterday.filter(r => r.status === 'perhatian') as row}
<div style="display:flex;align-items:flex-start;gap:10px;padding:8px 10px;margin-bottom:4px;background:rgba(234,179,8,0.04);border:1px solid rgba(234,179,8,0.18);border-radius:8px;font-size:13px;">
<div style="width:7px;height:7px;border-radius:50%;background:#ca8a04;flex-shrink:0;margin-top:4px;"></div>
<div><span style="font-weight:600;color:#854d0e;">{row.icon} {row.section}</span> <span style="color:var(--color-text-secondary);">·</span> <span style="color:var(--color-text-secondary);">{row.metrik}</span> — {row.label}</div>
</div>
{/each}
{/if}

</div>


---

<div style="margin:8px 0 0;">
<div style="display:flex;align-items:baseline;gap:10px;flex-wrap:wrap;">
<h2 style="margin:0;font-size:1.4em;font-weight:700;">💰 Keuangan</h2>
<span style="font-size:0.8em;color:var(--color-text-tertiary);font-weight:400;">Net Margin · AOV · Gap Cabang</span>
</div>
</div>


<BigValue data={fin_sdow_yesterday} value="gross_yesterday" title="Gross Revenue Kemarin (Rp)" fmt="#,##0" />
<BigValue data={fin_sdow_yesterday} value="sdow_avg"        title="Rata-rata Hari Serupa (Rp)" fmt="#,##0" />
<BigValue data={fin_sdow_yesterday} value="pct_change_sdow" title="Selisih vs Hari Serupa (%)" fmt="+0.0;-0.0\%" />

<details class="guide-acc">
<summary>💡 Kenapa KPI ini?</summary>
<div class="guide-body">
<div class="guide-grid" style="grid-template-columns: repeat(3, minmax(0, 1fr));">
<div class="guide-card blue">
  <div class="guide-card-icon">💰</div>
  <div class="guide-card-content">
    <div class="guide-card-label">Gross Revenue</div>
    <h4 class="guide-card-title">Angka Dasar</h4>
    <p class="guide-card-desc">Total penjualan kemarin sebelum dikurangi biaya apapun. Angka mentah yang menjadi dasar perbandingan.</p>
  </div>
</div>
<div class="guide-card orange">
  <div class="guide-card-icon">📊</div>
  <div class="guide-card-content">
    <div class="guide-card-label">Rata-rata SDOW</div>
    <h4 class="guide-card-title">Baseline Fair</h4>
    <p class="guide-card-desc">Rata-rata revenue di hari yang sama (Senin vs Senin, Sabtu vs Sabtu) dalam 30 hari terakhir. Menghilangkan bias weekday vs weekend.</p>
  </div>
</div>
<div class="guide-card teal">
  <div class="guide-card-icon">📈</div>
  <div class="guide-card-content">
    <div class="guide-card-label">Selisih</div>
    <h4 class="guide-card-title">Indikator Utama</h4>
    <p class="guide-card-desc">Berapa persen revenue kemarin menyimpang dari baseline SDOW. Indikator utama: apakah kemarin <em>abnormal</em> dibanding biasanya?</p>
  </div>
</div>
</div>
</div>
</details>

{#if fin_sdow_yesterday[0].pct_change_sdow >= -5}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:10px 16px;border-radius:6px;margin:8px 0;font-size:0.9em;">
✅ <strong>Normal — {fin_sdow_yesterday[0].pct_change_sdow}% vs hari serupa</strong> &nbsp;|&nbsp; Revenue kemarin dalam rentang wajar
</div>
{:else if fin_sdow_yesterday[0].pct_change_sdow >= -15}
<div style="background:rgba(248,201,0,0.1);border-left:4px solid #f8c900;padding:10px 16px;border-radius:6px;margin:8px 0;font-size:0.9em;">
⚠️ <strong>Di bawah normal — {fin_sdow_yesterday[0].pct_change_sdow}% vs hari serupa</strong> &nbsp;|&nbsp; Cek apakah ada penyebab spesifik kemarin
</div>
{:else}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:10px 16px;border-radius:6px;margin:8px 0;font-size:0.9em;">
🚨 <strong>Drop signifikan — {fin_sdow_yesterday[0].pct_change_sdow}% vs hari serupa</strong> &nbsp;|&nbsp; Investigasi segera — cek cabang mana yang paling terdampak
</div>
{/if}

<details class="read-acc">
<summary>💡 Cara membaca angka ini</summary>
<div class="read-body">

<div class="read-concept">
<h4 class="read-concept-header"><span>📊</span> Kenapa SDOW, bukan Net Margin?</h4>
<div class="read-concept-desc">

Net margin harian tidak valid sebagai indikator kesehatan karena biaya tetap (gaji, sewa) dibagi rata setiap hari — hari sepi dengan 50 order dan hari ramai dengan 200 order sama-sama menanggung biaya yang sama. Hasilnya, hari sepi selalu kelihatan "kritis" padahal itu normal.

SDOW (Same Day of Week) membandingkan kemarin dengan hari yang sama di minggu-minggu sebelumnya — Senin dibanding Senin, Sabtu dibanding Sabtu. Pertanyaannya bukan "apakah margin bagus?" tapi

**"apakah kemarin tidak biasa?"**

</div>
</div>

<div class="read-threshold-sec">
<h4 class="read-threshold-header"><span>🎯</span> Threshold SDOW</h4>
<div class="read-table-wrapper">
<table class="read-table">
<thead>
<tr>
<th>Selisih</th>
<th>Artinya</th>
</tr>
</thead>
<tbody>
<tr>
<td style="font-weight: 500;">di atas -5%</td>
<td>Normal ✅</td>
</tr>
<tr>
<td style="font-weight: 500;">-5% sampai -15%</td>
<td>Di bawah normal ⚠️</td>
</tr>
<tr>
<td style="font-weight: 500;">di bawah -15%</td>
<td>Drop signifikan 🚨</td>
</tr>
</tbody>
</table>
</div>
<div class="read-note">

**Buffer -5%** ada karena noise harian wajar — cuaca, insiden kecil, atau variasi acak tidak perlu menimbulkan alarm.

**Untuk analisis profitabilitas** (net margin, struktur biaya), gunakan periode 7 atau 30 hari di halaman Laporan Keuangan — datanya jauh lebih stabil dan bisa diandalkan.

</div>
</div>

</div>
</details>

<details class="acc-strategic">
<summary>📈 Lihat detail & chart</summary>
<div class="acc-body">

_Selisih revenue kemarin vs rata-rata hari serupa per cabang. Positif berarti di atas normal, negatif berarti di bawah._

<BarChart
    data={fin_sdow_branch_yesterday}
    x="branch_name"
    y="pct_change_sdow"
    title="Selisih vs Hari Serupa per Cabang — Kemarin (%)"
    yFmt="+0.0;-0.0"
    xAxisTitle="Cabang"
    yAxisTitle="Selisih vs SDOW (%)"
>
    <ReferenceArea yMin={-5}  color="green" />
    <ReferenceArea yMin={-15} yMax={-5}  color="yellow" />
    <ReferenceArea yMax={-15} color="red" />
    <ReferenceLine y={-5}  lineType="dashed" color="green" />
    <ReferenceLine y={-15} lineType="dashed" color="red" />
</BarChart>
<div style="display:flex;gap:16px;font-size:0.82em;color:#555;margin-top:4px;margin-bottom:8px;justify-content:center;">
    <span><span style="display:inline-block;width:12px;height:12px;background:rgba(22,163,74,0.2);border:1px solid #16a34a;border-radius:2px;margin-right:4px;vertical-align:middle;"></span>Normal (&gt;-5%)</span>
    <span><span style="display:inline-block;width:12px;height:12px;background:rgba(234,179,8,0.2);border:1px solid #ca8a04;border-radius:2px;margin-right:4px;vertical-align:middle;"></span>Di bawah normal (-5% s/d -15%)</span>
    <span><span style="display:inline-block;width:12px;height:12px;background:rgba(220,38,38,0.15);border:1px solid #dc2626;border-radius:2px;margin-right:4px;vertical-align:middle;"></span>Drop signifikan (&lt;-15%)</span>
</div>

<div class="table-scroll-container">
<table class="markdown">
    <thead>
        <tr>
            <th class="markdown">Cabang</th>
            <th class="markdown">Revenue Kemarin (Rp)</th>
            <th class="markdown">Rata-rata Hari Serupa (Rp)</th>
            <th class="markdown">Selisih (%)</th>
        </tr>
    </thead>
    <tbody>
        {#each fin_sdow_branch_yesterday || [] as row}
        <tr>
            <td class="markdown" style="font-weight: 500;">{row.branch_name || ''}</td>
            <td class="markdown">{row.gross_yesterday !== undefined && row.gross_yesterday !== null ? row.gross_yesterday.toLocaleString('id-ID') : '0'}</td>
            <td class="markdown">{row.sdow_avg !== undefined && row.sdow_avg !== null ? row.sdow_avg.toLocaleString('id-ID') : '0'}</td>
            <td class="markdown" style="font-weight: 600; color: {row.pct_change_sdow >= -5 ? '#16a34a' : row.pct_change_sdow >= -15 ? '#ca8a04' : '#dc2626'}">
                {row.pct_change_sdow !== undefined && row.pct_change_sdow !== null ? (row.pct_change_sdow > 0 ? '+' : '') + row.pct_change_sdow + '% ' + (row.pct_change_sdow >= 0 ? '▲' : '▼') : '0.0%'}
            </td>
        </tr>
        {/each}
    </tbody>
</table>
</div>


</div>
</details>

[→ Laporan Keuangan lengkap](/01-laporan-keuangan)


---

<div style="margin:8px 0 0;">
<div style="display:flex;align-items:baseline;gap:10px;flex-wrap:wrap;">
<h2 style="margin:0;font-size:1.4em;font-weight:700;">🏪 Performa Cabang</h2>
<span style="font-size:0.8em;color:var(--color-text-tertiary);font-weight:400;">Revenue · Order · AOV · Gap</span>
</div>
</div>


<BigValue data={branch_kpi_yesterday} value="branch_name"      title="Cabang Terbaik" />
<BigValue data={branch_agg_yesterday} value="total_orders_all"  title="Total Orders (Semua Cabang)" fmt="#,##0" />
<BigValue data={branch_agg_yesterday} value="aov_avg"           title="AOV (Semua Cabang)" fmt="#,##0" />

<details class="guide-acc">
<summary>💡 Kenapa KPI ini?</summary>
<div class="guide-body">
<div class="guide-grid" style="grid-template-columns: repeat(3, minmax(0, 1fr));">
<div class="guide-card blue">
  <div class="guide-card-icon">🏆</div>
  <div class="guide-card-content">
    <div class="guide-card-label">Cabang Terbaik</div>
    <h4 class="guide-card-title">Acuan Performa</h4>
    <p class="guide-card-desc">Siapa yang jadi acuan performa? Bukan untuk dipuji, tapi untuk dipelajari: apa yang mereka lakukan berbeda dari cabang lain?</p>
  </div>
</div>
<div class="guide-card orange">
  <div class="guide-card-icon">🧾</div>
  <div class="guide-card-content">
    <div class="guide-card-label">Total Orders</div>
    <h4 class="guide-card-title">Volume Aktivitas</h4>
    <p class="guide-card-desc">Mengukur volume aktivitas terlepas dari harga. Membedakan apakah penurunan revenue karena sepi pengunjung atau pelanggan belanja lebih sedikit.</p>
  </div>
</div>
<div class="guide-card teal">
  <div class="guide-card-icon">💳</div>
  <div class="guide-card-content">
    <div class="guide-card-label">AOV</div>
    <h4 class="guide-card-title">Kualitas Transaksi</h4>
    <p class="guide-card-desc">Seberapa besar nilai tiap transaksi? Mengukur kualitas kunjungan. AOV rendah bisa berarti ada peluang upselling yang belum dimanfaatkan.</p>
  </div>
</div>
</div>
</div>
</details>

{#if branch_agg_yesterday[0].aov_avg >= 50000}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:10px 16px;border-radius:6px;margin:8px 0;font-size:0.9em;">
✅ <strong>AOV Baik — Rp {branch_agg_yesterday[0].aov_avg}</strong> &nbsp;|&nbsp; Di atas target Rp 50.000
</div>
{:else if branch_agg_yesterday[0].aov_avg >= 35000}
<div style="background:rgba(248,201,0,0.1);border-left:4px solid #f8c900;padding:10px 16px;border-radius:6px;margin:8px 0;font-size:0.9em;">
⚠️ <strong>AOV Cukup — Rp {branch_agg_yesterday[0].aov_avg}</strong> &nbsp;|&nbsp; Mendekati target, dorong upselling
</div>
{:else}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:10px 16px;border-radius:6px;margin:8px 0;font-size:0.9em;">
🚨 <strong>AOV Rendah — Rp {branch_agg_yesterday[0].aov_avg}</strong> &nbsp;|&nbsp; Di bawah Rp 35.000, perlu strategi upselling
</div>
{/if}

{#if branch_agg_yesterday[0].gap_pct < 50}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:10px 16px;border-radius:6px;margin:8px 0;font-size:0.9em;">
✅ <strong>Performa Merata — gap {branch_agg_yesterday[0].gap_pct}%</strong> &nbsp;|&nbsp; Semua cabang berjalan seimbang
</div>
{:else if branch_agg_yesterday[0].gap_pct <= 100}
<div style="background:rgba(248,201,0,0.1);border-left:4px solid #f8c900;padding:10px 16px;border-radius:6px;margin:8px 0;font-size:0.9em;">
⚠️ <strong>Gap Moderat — {branch_agg_yesterday[0].gap_pct}%</strong> &nbsp;|&nbsp; Cabang bawah perlu perhatian lebih
</div>
{:else}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:10px 16px;border-radius:6px;margin:8px 0;font-size:0.9em;">
🚨 <strong>Gap Kritis — {branch_agg_yesterday[0].gap_pct}%</strong> &nbsp;|&nbsp; Cabang terbawah jauh tertinggal, cek operasional
</div>
{/if}

<details class="read-acc">
<summary>💡 Cara membaca angka ini</summary>
<div class="read-body">

<div class="read-concept">
<h4 class="read-concept-header"><span>🎯</span> Target AOV — Rp 50.000</h4>
<div class="read-concept-desc">

Angka ini bukan standar industri nasional, tapi threshold yang wajar berdasarkan struktur menu restoran ini:
- Menu utama berkisar Rp 25.000–40.000
- Pelanggan ideal = satu menu utama + minuman → AOV seharusnya di atas Rp 50.000
- AOV di bawah target → banyak pelanggan hanya pesan satu item

**Apa yang bisa dilakukan?** Bundling menu, rekomendasi aktif dari kasir, atau penempatan item add-on yang lebih strategis di daftar menu.

</div>
</div>

<div class="read-threshold-sec">
<h4 class="read-threshold-header"><span>🎯</span> Threshold Gap Antar Cabang</h4>
<div class="read-table-wrapper">
<table class="read-table">
<thead>
<tr>
<th>Gap</th>
<th>Artinya</th>
</tr>
</thead>
<tbody>
<tr>
<td style="font-weight: 500;">di bawah 50%</td>
<td>Semua cabang berjalan seimbang ✅</td>
</tr>
<tr>
<td style="font-weight: 500;">50–100%</td>
<td>Cabang bawah perlu perhatian ⚠️</td>
</tr>
<tr>
<td style="font-weight: 500;">di atas 100%</td>
<td>Cabang bawah jauh tertinggal 🚨</td>
</tr>
</tbody>
</table>
</div>
<div class="read-note">

**Penting:** Gap besar bukan otomatis masalah — bisa karena lokasi memang berbeda potensinya. Yang perlu diwaspadai adalah kalau gap **membesar dari waktu ke waktu**, artinya cabang bawah semakin tertinggal secara struktural.

</div>
</div>

</div>
</details>

<details class="acc-strategic">
<summary>📈 Lihat detail & chart</summary>
<div class="acc-body">

_Data satu hari bisa fluktuatif — jangan langsung simpulkan dari satu hari saja. Kolom "Rata-rata Hari Serupa" menunjukkan baseline hari yang sama di minggu-minggu sebelumnya._

<div class="table-scroll-container">
<table class="markdown">
    <thead>
        <tr>
            <th class="markdown">Cabang</th>
            <th class="markdown">Order</th>
            <th class="markdown">AOV (Rp)</th>
            <th class="markdown">Gross Revenue (Rp)</th>
            <th class="markdown">Rata-rata Hari Serupa</th>
            <th class="markdown">Selisih %</th>
        </tr>
    </thead>
    <tbody>
        {#each branch_kpi_yesterday || [] as row}
        <tr>
            <td class="markdown" style="font-weight: 500;">{row.branch_name || ''}</td>
            <td class="markdown">{row.total_orders !== undefined && row.total_orders !== null ? row.total_orders.toLocaleString('id-ID') : '0'}</td>
            <td class="markdown">{row.avg_order_value !== undefined && row.avg_order_value !== null ? row.avg_order_value.toLocaleString('id-ID') : '0'}</td>
            <td class="markdown">{row.total_revenue !== undefined && row.total_revenue !== null ? row.total_revenue.toLocaleString('id-ID') : '0'}</td>
            <td class="markdown">{row.revenue_sdow_avg !== undefined && row.revenue_sdow_avg !== null ? row.revenue_sdow_avg.toLocaleString('id-ID') : '0'}</td>
            <td class="markdown" style="font-weight: 600; color: {row.pct_change_vs_sdow_avg >= -5 ? '#16a34a' : row.pct_change_vs_sdow_avg >= -15 ? '#ca8a04' : '#dc2626'}">
                {row.pct_change_vs_sdow_avg !== undefined && row.pct_change_vs_sdow_avg !== null ? (row.pct_change_vs_sdow_avg > 0 ? '+' : '') + row.pct_change_vs_sdow_avg.toFixed(1) + '% ' + (row.pct_change_vs_sdow_avg >= 0 ? '▲' : '▼') : '0.0%'}
            </td>
        </tr>
        {/each}
    </tbody>
</table>
</div>

</div>
</details>

[→ Performa Cabang lengkap](/02-branch-performance)


---

<div style="margin:8px 0 0;">
<div style="display:flex;align-items:baseline;gap:10px;flex-wrap:wrap;">
<h2 style="margin:0;font-size:1.4em;font-weight:700;">🍽️ Performa Menu</h2>
<span style="font-size:0.8em;color:var(--color-text-tertiary);font-weight:400;">Menu Aktif · Kontribusi · Tren</span>
</div>
</div>


<BigValue data={menu_top_yesterday}     value="menu_name"       title="Menu Terlaris" />
<BigValue data={menu_kpi_agg_yesterday} value="kontribusi_pct"  title="Kontribusi Revenue Menu Terlaris" fmt="0.0\%" />
<BigValue data={menu_kpi_agg_yesterday} value="menu_aktif_label" title="Menu Terjual Kemarin" />

<details class="guide-acc">
<summary>💡 Kenapa KPI ini?</summary>
<div class="guide-body">
<div class="guide-grid" style="grid-template-columns: repeat(3, minmax(0, 1fr));">
<div class="guide-card blue">
  <div class="guide-card-icon">🥇</div>
  <div class="guide-card-content">
    <div class="guide-card-label">Menu Terlaris</div>
    <h4 class="guide-card-title">Harian Fluktuatif</h4>
    <p class="guide-card-desc">Menu dengan revenue tertinggi kemarin. Urutan harian bisa berubah — untuk pola konsisten, lihat data 7 atau 30 hari.</p>
  </div>
</div>
<div class="guide-card orange">
  <div class="guide-card-icon">📊</div>
  <div class="guide-card-content">
    <div class="guide-card-label">Kontribusi Revenue</div>
    <h4 class="guide-card-title">Ketergantungan Harian</h4>
    <p class="guide-card-desc">Berapa persen revenue total dari menu terlaris kemarin? Mengukur ketergantungan bisnis pada satu menu di hari itu.</p>
  </div>
</div>
<div class="guide-card teal">
  <div class="guide-card-icon">✅</div>
  <div class="guide-card-content">
    <div class="guide-card-label">Menu Terjual</div>
    <h4 class="guide-card-title">Cakupan Harian</h4>
    <p class="guide-card-desc">Berapa menu yang terjual kemarin dari total yang tersedia. Tidak terjual bisa karena stok habis, tidak di POS, atau tidak diminati.</p>
  </div>
</div>
</div>
</div>
</details>

{#if menu_kpi_agg_yesterday[0].kontribusi_pct <= 30}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:10px 16px;border-radius:6px;margin:8px 0;font-size:0.9em;">
✅ <strong>Distribusi Sehat — kontribusi {menu_kpi_agg_yesterday[0].kontribusi_pct}%</strong> &nbsp;|&nbsp; Revenue tidak terlalu bergantung pada satu menu
</div>
{:else if menu_kpi_agg_yesterday[0].kontribusi_pct <= 50}
<div style="background:rgba(248,201,0,0.1);border-left:4px solid #f8c900;padding:10px 16px;border-radius:6px;margin:8px 0;font-size:0.9em;">
⚠️ <strong>Mulai Bergantung — kontribusi {menu_kpi_agg_yesterday[0].kontribusi_pct}%</strong> &nbsp;|&nbsp; Satu menu menyumbang 30–50% revenue, cek tren di period 7 atau 30 hari
</div>
{:else}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:10px 16px;border-radius:6px;margin:8px 0;font-size:0.9em;">
🚨 <strong>Ketergantungan Tinggi — kontribusi {menu_kpi_agg_yesterday[0].kontribusi_pct}%</strong> &nbsp;|&nbsp; Lebih dari 50% revenue dari satu menu kemarin
</div>
{/if}

<details class="read-acc">
<summary>💡 Cara membaca angka ini</summary>
<div class="read-body">

<div class="read-concept">
<h4 class="read-concept-header"><span>🗺️</span> Peta Menu Engineering</h4>
<div class="read-concept-desc">

Scatter plot tidak ditampilkan untuk data harian karena satu hari terlalu sedikit untuk menyimpulkan posisi menu. Gunakan period 7 atau 30 hari untuk melihat menu engineering yang akurat.

</div>
</div>

<div class="read-threshold-sec">
<h4 class="read-threshold-header"><span>🎯</span> Threshold Kontribusi Revenue</h4>
<div class="read-table-wrapper">
<table class="read-table">
<thead>
<tr>
<th>Kontribusi</th>
<th>Artinya</th>
</tr>
</thead>
<tbody>
<tr>
<td style="font-weight: 500;">di bawah 30%</td>
<td>Distribusi sehat ✅</td>
</tr>
<tr>
<td style="font-weight: 500;">30–50%</td>
<td>Mulai bergantung ⚠️</td>
</tr>
<tr>
<td style="font-weight: 500;">di atas 50%</td>
<td>Ketergantungan tinggi 🚨</td>
</tr>
</tbody>
</table>
</div>
</div>

</div>
</details>

<details class="acc-strategic">
<summary>📈 Lihat detail & chart</summary>
<div class="acc-body">

_Urutan menu harian bisa berubah signifikan antara hari kerja dan weekend. Untuk keputusan menu engineering, gunakan data 7 atau 30 hari._

<div style="display:grid;grid-template-columns:1fr 1fr;gap:16px;">
<div>
<BarChart data={menu_top_yesterday} x="menu_name" y="total_qty" swapXY=true title="Top 5 — Qty Terjual" colorPalette={['#45a1bf']} xAxisTitle="Qty" />
</div>
<div>
<BarChart data={menu_top_yesterday} x="menu_name" y="total_revenue" swapXY=true title="Top 5 — Revenue (Rp)" yFmt="#,##0" colorPalette={['#236aa4']} xAxisTitle="Revenue (Rp)" />
</div>
</div>

</div>
</details>

[→ Performa Menu lengkap](/05-menu-performance)


---

<div style="margin:8px 0 0;">
<div style="display:flex;align-items:baseline;gap:10px;flex-wrap:wrap;">
<h2 style="margin:0;font-size:1.4em;font-weight:700;">👥 Member</h2>
<span style="font-size:0.8em;color:var(--color-text-tertiary);font-weight:400;">Order Member · Avg Frekuensi · Tier</span>
</div>
</div>


<BigValue data={member_kpi_yesterday} value="member_aktif"     title="Member Aktif"                    fmt="#,##0" />
<BigValue data={member_kpi_yesterday} value="pct_order_member" title="Kontribusi Order dari Member (%)" fmt="0.0\%" />
<BigValue data={member_kpi_yesterday} value="avg_frekuensi"    title="Transaksi per Member (Kemarin)"   fmt="0.0" />

<details class="guide-acc">
<summary>💡 Kenapa KPI ini?</summary>
<div class="guide-body">
<div class="guide-grid" style="grid-template-columns: repeat(3, minmax(0, 1fr));">
<div class="guide-card blue">
  <div class="guide-card-icon">👥</div>
  <div class="guide-card-content">
    <div class="guide-card-label">Member Aktif</div>
    <h4 class="guide-card-title">Snapshot Harian</h4>
    <p class="guide-card-desc">Jumlah member yang bertransaksi kemarin. Data harian bisa fluktuatif — untuk pola loyalitas lebih akurat, lihat data 7 atau 30 hari.</p>
  </div>
</div>
<div class="guide-card orange">
  <div class="guide-card-icon">📦</div>
  <div class="guide-card-content">
    <div class="guide-card-label">Kontribusi Order</div>
    <h4 class="guide-card-title">Kontribusi Harian</h4>
    <p class="guide-card-desc">Berapa persen total order kemarin dari member? Angka harian bisa bervariasi tergantung hari dalam seminggu.</p>
  </div>
</div>
<div class="guide-card teal">
  <div class="guide-card-icon">🔁</div>
  <div class="guide-card-content">
    <div class="guide-card-label">Transaksi</div>
    <h4 class="guide-card-title">Frekuensi Harian</h4>
    <p class="guide-card-desc">Rata-rata berapa kali member bertransaksi kemarin. Untuk data harian hampir selalu 1 — lebih bermakna di period 7 atau 30 hari.</p>
  </div>
</div>
</div>
</div>
</details>

{#if member_kpi_yesterday[0].pct_order_member >= 40}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:10px 16px;border-radius:6px;margin:8px 0;font-size:0.9em;">
✅ <strong>Program Loyalitas Aktif — {member_kpi_yesterday[0].pct_order_member}% order dari member</strong> &nbsp;|&nbsp; Member berkontribusi signifikan kemarin
</div>
{:else if member_kpi_yesterday[0].pct_order_member >= 20}
<div style="background:rgba(248,201,0,0.1);border-left:4px solid #f8c900;padding:10px 16px;border-radius:6px;margin:8px 0;font-size:0.9em;">
⚠️ <strong>Potensi Belum Maksimal — {member_kpi_yesterday[0].pct_order_member}% order dari member</strong> &nbsp;|&nbsp; Cek tren 7 atau 30 hari untuk gambaran yang lebih akurat
</div>
{:else}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:10px 16px;border-radius:6px;margin:8px 0;font-size:0.9em;">
🚨 <strong>Member Kurang Aktif — {member_kpi_yesterday[0].pct_order_member}% order dari member</strong> &nbsp;|&nbsp; Cek tren 7 atau 30 hari sebelum mengambil kesimpulan
</div>
{/if}

<details class="read-acc">
<summary>💡 Cara membaca angka ini</summary>
<div class="read-body">

<div class="read-concept">
<h4 class="read-concept-header"><span>🔁</span> Transaksi per Member</h4>
<div class="read-concept-desc">

Untuk data harian angka ini hampir selalu mendekati 1 karena seorang member jarang bertransaksi lebih dari sekali dalam sehari. Gunakan period 7 atau 30 hari untuk analisis frekuensi yang lebih bermakna.

</div>
</div>

<div class="read-threshold-sec">
<h4 class="read-threshold-header"><span>🎯</span> Threshold Kontribusi Order Member</h4>
<div class="read-table-wrapper">
<table class="read-table">
<thead>
<tr>
<th>Kontribusi</th>
<th>Artinya</th>
</tr>
</thead>
<tbody>
<tr>
<td style="font-weight: 500;">di atas 40%</td>
<td>Program loyalitas berjalan baik ✅</td>
</tr>
<tr>
<td style="font-weight: 500;">20–40%</td>
<td>Potensi belum dimanfaatkan ⚠️</td>
</tr>
<tr>
<td style="font-weight: 500;">di bawah 20%</td>
<td>Member kurang aktif 🚨</td>
</tr>
</tbody>
</table>
</div>
<div class="read-note">

**Catatan:** Threshold ini adalah acuan awal dan bersifat fleksibel — disarankan dikalibrasi ulang setelah 3–6 bulan data terkumpul.

</div>
</div>

</div>
</details>

<details class="acc-strategic">
<summary>📈 Lihat detail & chart</summary>
<div class="acc-body">

_Data member harian menunjukkan siapa yang aktif kemarin. Untuk analisis frekuensi kembali per tier yang lebih bermakna, lihat data 7 atau 30 hari._

<BarChart data={member_tier_yesterday} x="tier" y="avg_frekuensi" title="Avg Transaksi per Member per Tier — Kemarin" yFmt="0.0" colorPalette={['#f4b548']} xAxisTitle="Tier" yAxisTitle="Avg Transaksi" />

<div class="table-scroll-container">
<table class="markdown">
    <thead>
        <tr>
            <th class="markdown">Tier</th>
            <th class="markdown">Jumlah Member</th>
            <th class="markdown">Total Belanja (Rp)</th>
            <th class="markdown">Avg Transaksi/Member</th>
        </tr>
    </thead>
    <tbody>
        {#each member_tier_yesterday || [] as row}
        <tr>
            <td class="markdown" style="font-weight: 500;">{row.tier || ''}</td>
            <td class="markdown">{row.total_member !== undefined && row.total_member !== null ? row.total_member.toLocaleString('id-ID') : '0'}</td>
            <td class="markdown">{row.total_belanja !== undefined && row.total_belanja !== null ? row.total_belanja.toLocaleString('id-ID') : '0'}</td>
            <td class="markdown">{row.avg_frekuensi !== undefined && row.avg_frekuensi !== null ? row.avg_frekuensi.toFixed(1) : '0.0'}</td>
        </tr>
        {/each}
    </tbody>
</table>
</div>

</div>
</details>

[→ Analisis Member lengkap](/06-member-behavior)


---

<div style="margin:8px 0 0;">
<div style="display:flex;align-items:baseline;gap:10px;flex-wrap:wrap;">
<h2 style="margin:0;font-size:1.4em;font-weight:700;">👨‍💼 Pegawai & Shift</h2>
<span style="font-size:0.8em;color:var(--color-text-tertiary);font-weight:400;">Kehadiran · Keterlambatan · Shift</span>
</div>
</div>


<BigValue data={att_kpi_yesterday} value="pct_hadir"      title="Tingkat Kehadiran"     fmt="0.0\%" />
<BigValue data={att_kpi_yesterday} value="pct_terlambat"  title="Tingkat Keterlambatan" fmt="0.0\%" />
<BigValue data={att_kpi_yesterday} value="shift_tersibuk" title="Shift Tersibuk" />

<details class="guide-acc">
<summary>💡 Kenapa KPI ini?</summary>
<div class="guide-body">
<div class="guide-grid" style="grid-template-columns: repeat(3, minmax(0, 1fr));">
<div class="guide-card blue">
  <div class="guide-card-icon">✅</div>
  <div class="guide-card-content">
    <div class="guide-card-label">Kehadiran</div>
    <h4 class="guide-card-title">Respon Cepat</h4>
    <p class="guide-card-desc">Persentase hadir kemarin. Data harian untuk respon cepat — kalau banyak absent, owner bisa langsung antisipasi sebelum jam buka.</p>
  </div>
</div>
<div class="guide-card orange">
  <div class="guide-card-icon">⏰</div>
  <div class="guide-card-content">
    <div class="guide-card-label">Keterlambatan</div>
    <h4 class="guide-card-title">Evaluasi Harian</h4>
    <p class="guide-card-desc">Persentase hadir tapi terlambat kemarin. Untuk pola yang lebih bermakna, lihat data 7 atau 30 hari.</p>
  </div>
</div>
<div class="guide-card teal">
  <div class="guide-card-icon">📊</div>
  <div class="guide-card-content">
    <div class="guide-card-label">Shift Tersibuk</div>
    <h4 class="guide-card-title">Fokus Hari Ini</h4>
    <p class="guide-card-desc">Shift dengan revenue tertinggi kemarin. Memastikan staf terbaik ditempatkan di shift yang paling kritis.</p>
  </div>
</div>
</div>
</div>
</details>

{#if att_kpi_yesterday[0].pct_hadir >= 95}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:10px 16px;border-radius:6px;margin:8px 0;font-size:0.9em;">
✅ <strong>Kehadiran Baik — {att_kpi_yesterday[0].pct_hadir}%</strong> &nbsp;|&nbsp; Operasional kemarin berjalan dengan staf yang cukup
</div>
{:else if att_kpi_yesterday[0].pct_hadir >= 85}
<div style="background:rgba(248,201,0,0.1);border-left:4px solid #f8c900;padding:10px 16px;border-radius:6px;margin:8px 0;font-size:0.9em;">
⚠️ <strong>Kehadiran Perlu Perhatian — {att_kpi_yesterday[0].pct_hadir}%</strong> &nbsp;|&nbsp; Cek tren 7 hari sebelum mengambil kesimpulan
</div>
{:else}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:10px 16px;border-radius:6px;margin:8px 0;font-size:0.9em;">
🚨 <strong>Kehadiran Kritis — {att_kpi_yesterday[0].pct_hadir}%</strong> &nbsp;|&nbsp; Di bawah 85% kemarin — cek apakah ada masalah di cabang tertentu
</div>
{/if}

{#if att_kpi_yesterday[0].pct_terlambat <= 10}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:10px 16px;border-radius:6px;margin:8px 0;font-size:0.9em;">
✅ <strong>Disiplin Baik — {att_kpi_yesterday[0].pct_terlambat}% terlambat</strong> &nbsp;|&nbsp; Pegawai datang tepat waktu kemarin
</div>
{:else if att_kpi_yesterday[0].pct_terlambat <= 20}
<div style="background:rgba(248,201,0,0.1);border-left:4px solid #f8c900;padding:10px 16px;border-radius:6px;margin:8px 0;font-size:0.9em;">
⚠️ <strong>Disiplin Perlu Perhatian — {att_kpi_yesterday[0].pct_terlambat}% terlambat</strong> &nbsp;|&nbsp; Cek tren 7 hari untuk konfirmasi
</div>
{:else}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:10px 16px;border-radius:6px;margin:8px 0;font-size:0.9em;">
🚨 <strong>Masalah Disiplin — {att_kpi_yesterday[0].pct_terlambat}% terlambat</strong> &nbsp;|&nbsp; Di atas 20% kemarin — cek shift dan cabang mana yang paling banyak terlambat
</div>
{/if}

<details class="read-acc">
<summary>💡 Cara membaca angka ini</summary>
<div class="read-body">

<div class="read-concept">
<h4 class="read-concept-header"><span>⏰</span> Tingkat Keterlambatan</h4>
<div class="read-concept-desc">

Persentase dari pegawai yang hadir tapi datang terlambat kemarin. Untuk pola yang lebih bermakna, lihat data 7 atau 30 hari — keterlambatan satu hari bisa karena faktor eksternal seperti macet atau cuaca.

</div>
</div>

<div class="read-threshold-sec">
<h4 class="read-threshold-header"><span>🎯</span> Threshold Tingkat Keterlambatan</h4>
<div class="read-table-wrapper">
<table class="read-table">
<thead>
<tr>
<th>Keterlambatan</th>
<th>Artinya</th>
</tr>
</thead>
<tbody>
<tr>
<td style="font-weight: 500;">di bawah 10%</td>
<td>Disiplin baik ✅</td>
</tr>
<tr>
<td style="font-weight: 500;">10–20%</td>
<td>Perlu perhatian ⚠️</td>
</tr>
<tr>
<td style="font-weight: 500;">di atas 20%</td>
<td>Masalah disiplin serius 🚨</td>
</tr>
</tbody>
</table>
</div>
<div class="read-note">

**Catatan:** Semua threshold di atas adalah acuan awal yang dapat disesuaikan dengan kebijakan masing-masing restoran.

</div>
</div>

</div>
</details>

<details class="acc-strategic">
<summary>📈 Lihat detail & chart</summary>
<div class="acc-body">

_Satu hari absensi tinggi bisa karena faktor insidental. Kalau pola ini berulang di hari yang sama setiap minggu, itu indikasi masalah jadwal atau motivasi yang perlu ditangani._

<BarChart data={att_branch_yesterday} x="branch_name" y="pct_hadir" title="Tingkat Kehadiran per Cabang — Kemarin (%)" yFmt="0.0\%" colorPalette={['#85c7c6']} xAxisTitle="Cabang" yAxisTitle="Kehadiran (%)">
    <ReferenceLine y={95} label="Target 95%" lineType="dashed" color="green" />
    <ReferenceLine y={85} label="Batas Kritis 85%" lineType="dashed" color="red" />
</BarChart>

<BarChart data={shift_kpi_yesterday} x="shift_name" y="total_revenue" title="Revenue per Shift — Kemarin (Rp)" yFmt="#,##0" colorPalette={['#85c7c6']} xAxisTitle="Shift" yAxisTitle="Revenue (Rp)" />

<div class="table-scroll-container">
<table class="markdown">
    <thead>
        <tr>
            <th class="markdown">Shift</th>
            <th class="markdown">Order</th>
            <th class="markdown">Revenue (Rp)</th>
            <th class="markdown">Avg Ticket (Rp)</th>
        </tr>
    </thead>
    <tbody>
        {#each shift_kpi_yesterday || [] as row}
        <tr>
            <td class="markdown" style="font-weight: 500;">{row.shift_name || ''}</td>
            <td class="markdown">{row.total_orders !== undefined && row.total_orders !== null ? row.total_orders.toLocaleString('id-ID') : '0'}</td>
            <td class="markdown">{row.total_revenue !== undefined && row.total_revenue !== null ? row.total_revenue.toLocaleString('id-ID') : '0'}</td>
            <td class="markdown">{row.avg_ticket !== undefined && row.avg_ticket !== null ? row.avg_ticket.toLocaleString('id-ID') : '0'}</td>
        </tr>
        {/each}
    </tbody>
</table>
</div>

</div>
</details>

[→ Performa Pegawai lengkap](/07-employee-performance)


---

<div style="margin:8px 0 0;">
<div style="display:flex;align-items:baseline;gap:10px;flex-wrap:wrap;">
<h2 style="margin:0;font-size:1.4em;font-weight:700;">📦 Inventori & Biaya Bahan</h2>
<span style="font-size:0.8em;color:var(--color-text-tertiary);font-weight:400;">Biaya Bahan · Rasio Beli/Pakai · Kategori</span>
</div>
</div>


<BigValue data={inv_kpi_yesterday} value="pct_dari_revenue"   title="Biaya Bahan dari Revenue"  fmt="0.0\%" />
<BigValue data={inv_kpi_yesterday} value="rasio_beli_pakai"   title="Rasio Beli vs Pakai"        fmt="0.00" />
<BigValue data={inv_kpi_yesterday} value="kategori_tertinggi" title="Kategori Biaya Tertinggi" />

<details class="guide-acc">
<summary>💡 Kenapa KPI ini?</summary>
<div class="guide-body">
<div class="guide-grid" style="grid-template-columns: repeat(3, minmax(0, 1fr));">
<div class="guide-card blue">
  <div class="guide-card-icon">📊</div>
  <div class="guide-card-content">
    <div class="guide-card-label">Food Cost</div>
    <h4 class="guide-card-title">Data Fluktuatif</h4>
    <p class="guide-card-desc">Berapa persen penjualan kemarin untuk bahan baku. Data harian bisa sangat fluktuatif — hari pembelian besar terlihat lebih tinggi.</p>
  </div>
</div>
<div class="guide-card orange">
  <div class="guide-card-icon">⚖️</div>
  <div class="guide-card-content">
    <div class="guide-card-label">Rasio Beli/Pakai</div>
    <h4 class="guide-card-title">Snapshot Harian</h4>
    <p class="guide-card-desc">Pembelian vs pemakaian kemarin. Bisa 0 di hari tanpa pembelian — lebih bermakna di period 7 atau 30 hari.</p>
  </div>
</div>
<div class="guide-card teal">
  <div class="guide-card-icon">🏷️</div>
  <div class="guide-card-content">
    <div class="guide-card-label">Kategori Tertinggi</div>
    <h4 class="guide-card-title">Fokus Hari Ini</h4>
    <p class="guide-card-desc">Kategori bahan yang paling banyak makan biaya kemarin. Informasi untuk tahu di mana fokus perhatian hari ini.</p>
  </div>
</div>
</div>
</div>
</details>

{#if inv_kpi_yesterday[0].pct_dari_revenue <= 32}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:10px 16px;border-radius:6px;margin:8px 0;font-size:0.9em;">
✅ <strong>Biaya Bahan Normal — {inv_kpi_yesterday[0].pct_dari_revenue}%</strong> &nbsp;|&nbsp; Standar industri: 28–32% dari revenue
</div>
{:else if inv_kpi_yesterday[0].pct_dari_revenue <= 38}
<div style="background:rgba(248,201,0,0.1);border-left:4px solid #f8c900;padding:10px 16px;border-radius:6px;margin:8px 0;font-size:0.9em;">
⚠️ <strong>Biaya Bahan Waspada — {inv_kpi_yesterday[0].pct_dari_revenue}%</strong> &nbsp;|&nbsp; Cek tren 7 hari sebelum mengambil kesimpulan
</div>
{:else}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:10px 16px;border-radius:6px;margin:8px 0;font-size:0.9em;">
🚨 <strong>Biaya Bahan Tinggi — {inv_kpi_yesterday[0].pct_dari_revenue}%</strong> &nbsp;|&nbsp; Bisa karena hari pembelian besar — cek tren 7 hari untuk konfirmasi
</div>
{/if}

{#if inv_kpi_yesterday[0].rasio_beli_pakai === 0}
<div style="background:rgba(248,201,0,0.1);border-left:4px solid #f8c900;padding:10px 16px;border-radius:6px;margin:8px 0;font-size:0.9em;">
⚠️ <strong>Tidak Ada Pembelian Kemarin</strong> &nbsp;|&nbsp; Normal kalau bukan hari restok — lihat tren 7 hari untuk gambaran yang lebih lengkap
</div>
{:else if inv_kpi_yesterday[0].rasio_beli_pakai < 0.9}
<div style="background:rgba(248,201,0,0.1);border-left:4px solid #f8c900;padding:10px 16px;border-radius:6px;margin:8px 0;font-size:0.9em;">
⚠️ <strong>Pembelian Kurang — rasio {inv_kpi_yesterday[0].rasio_beli_pakai}</strong> &nbsp;|&nbsp; Pemakaian lebih besar dari pembelian — cek tren 7 hari untuk konfirmasi
</div>
{:else if inv_kpi_yesterday[0].rasio_beli_pakai <= 1.2}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:10px 16px;border-radius:6px;margin:8px 0;font-size:0.9em;">
✅ <strong>Pembelian Seimbang — rasio {inv_kpi_yesterday[0].rasio_beli_pakai}</strong> &nbsp;|&nbsp; Pembelian kemarin proporsional dengan pemakaian
</div>
{:else if inv_kpi_yesterday[0].rasio_beli_pakai <= 1.5}
<div style="background:rgba(248,201,0,0.1);border-left:4px solid #f8c900;padding:10px 16px;border-radius:6px;margin:8px 0;font-size:0.9em;">
⚠️ <strong>Pembelian Mulai Berlebih — rasio {inv_kpi_yesterday[0].rasio_beli_pakai}</strong> &nbsp;|&nbsp; Cek tren 7 hari untuk konfirmasi
</div>
{:else}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:10px 16px;border-radius:6px;margin:8px 0;font-size:0.9em;">
🚨 <strong>Over-Purchasing — rasio {inv_kpi_yesterday[0].rasio_beli_pakai}</strong> &nbsp;|&nbsp; Bisa karena hari pembelian besar — cek tren 7 hari untuk konfirmasi
</div>
{/if}

<details class="read-acc">
<summary>💡 Cara membaca angka ini</summary>
<div class="read-body">

<div class="read-concept">
<h4 class="read-concept-header"><span>⚖️</span> Rasio Beli vs Pakai</h4>
<div class="read-concept-desc">

Untuk data harian, rasio ini bisa 0 di hari tanpa pembelian dan sangat tinggi di hari pembelian besar. Lihat tren 7 atau 30 hari untuk rasio yang lebih representatif.

</div>
</div>

<div class="read-threshold-sec">
<h4 class="read-threshold-header"><span>🎯</span> Threshold Rasio Beli vs Pakai</h4>
<div class="read-table-wrapper">
<table class="read-table">
<thead>
<tr>
<th>Rasio</th>
<th>Artinya</th>
</tr>
</thead>
<tbody>
<tr>
<td style="font-weight: 500;">0</td>
<td>Tidak ada pembelian hari ini ⚠️</td>
</tr>
<tr>
<td style="font-weight: 500;">di bawah 0.9</td>
<td>Pembelian kurang, stok terkuras ⚠️</td>
</tr>
<tr>
<td style="font-weight: 500;">0.9–1.2</td>
<td>Seimbang ✅</td>
</tr>
<tr>
<td style="font-weight: 500;">1.2–1.5</td>
<td>Pembelian mulai berlebih ⚠️</td>
</tr>
<tr>
<td style="font-weight: 500;">di atas 1.5</td>
<td>Over-purchasing 🚨</td>
</tr>
</tbody>
</table>
</div>
<div class="read-note">

**Catatan:** Semua threshold di atas adalah acuan awal yang dapat disesuaikan dengan pola pembelian masing-masing restoran.

</div>
</div>

</div>
</details>

<details class="acc-strategic">
<summary>📈 Lihat detail & chart</summary>
<div class="acc-body">

_Biaya bahan harian bisa fluktuatif tergantung jadwal pembelian. Hari pembelian besar akan terlihat lebih tinggi — lihat 7 atau 30 hari untuk pola yang lebih stabil._

<BarChart data={inv_cat_yesterday} x="category" y="biaya_pakai" title="Biaya Bahan per Kategori — Kemarin (Rp)" yFmt="#,##0" colorPalette={['#8f3d56']} xAxisTitle="Kategori" yAxisTitle="Biaya (Rp)" />

<div style="font-weight: 600; margin: 12px 0 6px; font-size: 0.95em;">Detail Item — Diurutkan Rasio Beli/Pakai Tertinggi</div>
<div class="table-scroll-container">
<table class="markdown">
    <thead>
        <tr>
            <th class="markdown">Item</th>
            <th class="markdown">Kategori</th>
            <th class="markdown">Biaya Pakai (Rp)</th>
            <th class="markdown">Biaya Beli (Rp)</th>
            <th class="markdown">Rasio Beli/Pakai</th>
        </tr>
    </thead>
    <tbody>
        {#each inv_item_yesterday || [] as row}
        <tr>
            <td class="markdown" style="font-weight: 500; text-align: left;">{row.item_name || ''}</td>
            <td class="markdown">{row.category || ''}</td>
            <td class="markdown">{row.biaya_pakai !== undefined && row.biaya_pakai !== null ? row.biaya_pakai.toLocaleString('id-ID') : '0'}</td>
            <td class="markdown">{row.biaya_beli !== undefined && row.biaya_beli !== null ? row.biaya_beli.toLocaleString('id-ID') : '0'}</td>
            <td class="markdown">{row.rasio !== undefined && row.rasio !== null ? row.rasio.toFixed(2) : '0.00'}</td>
        </tr>
        {/each}
    </tbody>
</table>
</div>

_Tabel diurutkan berdasarkan rasio beli/pakai tertinggi — item di posisi teratas adalah yang pembeliannya paling jauh melebihi pemakaian kemarin. Untuk data harian, item tanpa pembelian akan muncul dengan rasio 0._

</div>
</details>

[→ Inventori lengkap](/03-inventori-stok)


---

<div style="margin:8px 0 0;">
<div style="display:flex;align-items:baseline;gap:10px;flex-wrap:wrap;">
<h2 style="margin:0;font-size:1.4em;font-weight:700;">⏰ Jam Sibuk</h2>
<span style="font-size:0.8em;color:var(--color-text-tertiary);font-weight:400;">Konsentrasi Order · Jam Puncak · Order Type</span>
</div>
</div>


<BigValue data={peak_kpi_yesterday} value="jam_puncak"         title="Jam Puncak Kemarin" />
<BigValue data={peak_kpi_yesterday} value="periode_puncak"     title="Periode Puncak" />
<BigValue data={peak_kpi_yesterday} value="order_type_dominan" title="Order Type Dominan di Jam Puncak" />

<details class="guide-acc">
<summary>💡 Kenapa KPI ini?</summary>
<div class="guide-body">
<div class="guide-grid" style="grid-template-columns: repeat(3, minmax(0, 1fr));">
<div class="guide-card blue">
  <div class="guide-card-icon">🕐</div>
  <div class="guide-card-content">
    <div class="guide-card-label">Jam Puncak</div>
    <h4 class="guide-card-title">Evaluasi Kemarin</h4>
    <p class="guide-card-desc">Jam dengan volume order tertinggi kemarin. Evaluasi apakah distribusi staf kemarin sudah optimal di jam-jam kritis.</p>
  </div>
</div>
<div class="guide-card orange">
  <div class="guide-card-icon">🍽️</div>
  <div class="guide-card-content">
    <div class="guide-card-label">Periode Puncak</div>
    <h4 class="guide-card-title">Ritme Harian</h4>
    <p class="guide-card-desc">Konteks waktu jam puncak kemarin. Data harian bisa berbeda signifikan — untuk pola stabil, lihat data 7 atau 30 hari.</p>
  </div>
</div>
<div class="guide-card teal">
  <div class="guide-card-icon">📦</div>
  <div class="guide-card-content">
    <div class="guide-card-label">Order Type</div>
    <h4 class="guide-card-title">Kesiapan Hari Ini</h4>
    <p class="guide-card-desc">Jenis order terbanyak di jam puncak kemarin. Evaluasi kesiapan operasional hari ini kalau polanya serupa.</p>
  </div>
</div>
</div>
</div>
</details>

{#if peak_kpi_yesterday[0].pct_jam_puncak >= 20}
<div style="background:rgba(220,38,38,0.08);border-left:4px solid #dc2626;padding:10px 16px;border-radius:6px;margin:8px 0;font-size:0.9em;">
🚨 <strong>Order Sangat Terkonsentrasi — {peak_kpi_yesterday[0].pct_jam_puncak}% order di jam {peak_kpi_yesterday[0].jam_puncak}</strong> &nbsp;|&nbsp; Pastikan staf terbaik siap di jam yang sama hari ini
</div>
{:else if peak_kpi_yesterday[0].pct_jam_puncak >= 12}
<div style="background:rgba(248,201,0,0.1);border-left:4px solid #f8c900;padding:10px 16px;border-radius:6px;margin:8px 0;font-size:0.9em;">
⚠️ <strong>Order Cukup Terkonsentrasi — {peak_kpi_yesterday[0].pct_jam_puncak}% order di jam {peak_kpi_yesterday[0].jam_puncak}</strong> &nbsp;|&nbsp; Perhatikan alokasi staf di jam ini
</div>
{:else}
<div style="background:rgba(22,163,74,0.08);border-left:4px solid #16a34a;padding:10px 16px;border-radius:6px;margin:8px 0;font-size:0.9em;">
✅ <strong>Order Terdistribusi Merata — {peak_kpi_yesterday[0].pct_jam_puncak}% order di jam {peak_kpi_yesterday[0].jam_puncak}</strong> &nbsp;|&nbsp; Tidak ada jam yang terlalu dominan kemarin
</div>
{/if}

<details class="read-acc">
<summary>💡 Cara membaca angka ini</summary>
<div class="read-body">

<div class="read-concept">
<h4 class="read-concept-header"><span>📦</span> Order Type Dominan</h4>
<div class="read-concept-desc">

Jenis order terbanyak di jam puncak kemarin. Kalau polanya konsisten, ini bisa jadi acuan untuk kesiapan operasional hari ini:
- **Dine In** → pastikan meja dan pramusaji siap
- **Takeaway** → pastikan kasir dan packaging siap
- **Delivery** → pastikan koordinasi kurir sudah terkonfirmasi

</div>
</div>

<div class="read-threshold-sec">
<h4 class="read-threshold-header"><span>🎯</span> Threshold Konsentrasi Order di Jam Puncak</h4>
<div class="read-table-wrapper">
<table class="read-table">
<thead>
<tr>
<th>% Order di Jam Puncak</th>
<th>Artinya</th>
</tr>
</thead>
<tbody>
<tr>
<td style="font-weight: 500;">di bawah 12%</td>
<td>Terdistribusi merata ✅</td>
</tr>
<tr>
<td style="font-weight: 500;">12–20%</td>
<td>Cukup terkonsentrasi ⚠️</td>
</tr>
<tr>
<td style="font-weight: 500;">di atas 20%</td>
<td>Sangat terkonsentrasi 🚨</td>
</tr>
</tbody>
</table>
</div>
<div class="read-note">

**Catatan:** Threshold ini adalah acuan awal yang dapat disesuaikan dengan karakteristik masing-masing restoran.

</div>
</div>

</div>
</details>

<details class="acc-strategic">
<summary>📈 Lihat detail & chart</summary>
<div class="acc-body">

_Data jam sibuk kemarin berguna untuk evaluasi apakah staf sudah terdistribusi dengan baik di jam-jam kritis. Bandingkan dengan pola 7 atau 30 hari untuk melihat apakah kemarin tipikal atau tidak._

<BarChart data={peak_yesterday} x="order_hour" y="total_orders" series="order_type" type="stacked" title="Order per Jam — Kemarin" xAxisTitle="Jam" yAxisTitle="Total Order">
    <ReferenceLine x={peak_kpi_yesterday[0].jam_puncak} lineType="dashed" color="red" label="Jam Puncak" />
</BarChart>

</div>
</details>

[→ Analisis Jam Sibuk lengkap](/04-peak-hours)

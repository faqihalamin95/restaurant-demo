WITH anchor_date AS (
    SELECT MAX(order_date) AS d FROM main_marts.mart_daily_revenue
),
-- 1. Keuangan
fin AS (
    SELECT ROUND(SUM(net_revenue)/NULLIF(SUM(gross_revenue),0)*100,1) AS m
    FROM main_marts.mart_daily_net_revenue
    WHERE metric_date >= (SELECT d FROM anchor_date) - INTERVAL '6 days'
      AND metric_date <= (SELECT d FROM anchor_date)
),
-- 2. Order Performance
ord AS (
    SELECT ROUND((curr - prev) / NULLIF(prev, 0) * 100, 1) AS p
    FROM (
        SELECT
            SUM(CASE WHEN order_date >= (SELECT d FROM anchor_date) - INTERVAL '6 days' THEN total_orders ELSE 0 END) AS curr,
            SUM(CASE WHEN order_date >= (SELECT d FROM anchor_date) - INTERVAL '13 days' AND order_date < (SELECT d FROM anchor_date) - INTERVAL '6 days' THEN total_orders ELSE 0 END) AS prev
        FROM main_marts.mart_daily_revenue
        WHERE order_date >= (SELECT d FROM anchor_date) - INTERVAL '13 days'
    )
),
-- 3. AOV
aov_stat AS (
    SELECT ROUND(SUM(total_revenue)/NULLIF(SUM(total_orders),0),0) AS aov
    FROM main_marts.mart_daily_revenue
    WHERE order_date >= (SELECT d FROM anchor_date) - INTERVAL '6 days'
      AND order_date <= (SELECT d FROM anchor_date)
),
-- 4. Gap
gap_stat AS (
    SELECT ROUND((MAX(s)-MIN(s))/NULLIF(MIN(s),0)*100,1) AS g
    FROM (SELECT branch_name, SUM(total_revenue) AS s
          FROM main_marts.mart_daily_revenue
          WHERE order_date >= (SELECT d FROM anchor_date) - INTERVAL '6 days'
            AND order_date <= (SELECT d FROM anchor_date)
          GROUP BY branch_name)
),
-- 5. Menu Aktif
menu_active AS (
    SELECT ROUND(COUNT(DISTINCT CASE WHEN hari_aktif >= 4 THEN menu_name END)*100.0/NULLIF(COUNT(DISTINCT menu_name),0),1) AS a
    FROM (SELECT menu_name, COUNT(DISTINCT order_date) AS hari_aktif
          FROM main_marts.mart_menu_performance
          WHERE order_date >= (SELECT d FROM anchor_date) - INTERVAL '6 days'
            AND order_date <= (SELECT d FROM anchor_date)
          GROUP BY menu_name)
),
-- 6. Kontribusi Menu
menu_top AS (
    SELECT ROUND(SUM(CASE WHEN rn=1 THEN total_revenue END)*100.0/NULLIF(SUM(total_revenue),0),1) AS k
    FROM (SELECT menu_name, SUM(total_revenue) AS total_revenue,
              ROW_NUMBER() OVER (ORDER BY SUM(total_revenue) DESC) AS rn
          FROM main_marts.mart_menu_performance
          WHERE order_date >= (SELECT d FROM anchor_date) - INTERVAL '6 days'
            AND order_date <= (SELECT d FROM anchor_date)
          GROUP BY menu_name)
),
-- 7. Member Order
mem_stat AS (
    SELECT ROUND(SUM(total_orders)*100.0/NULLIF((SELECT SUM(total_orders) FROM main_marts.mart_daily_revenue WHERE order_date >= (SELECT d FROM anchor_date) - INTERVAL '6 days' AND order_date <= (SELECT d FROM anchor_date)),0),1) AS p
    FROM main_marts.mart_member_purchase_behavior
    WHERE order_date >= (SELECT d FROM anchor_date) - INTERVAL '6 days'
      AND order_date <= (SELECT d FROM anchor_date)
),
-- 8. Member Frekuensi
mem_freq AS (
    SELECT ROUND(SUM(total_orders)*1.0/NULLIF(COUNT(DISTINCT member_id),0),1) AS f
    FROM main_marts.mart_member_purchase_behavior
    WHERE order_date >= (SELECT d FROM anchor_date) - INTERVAL '6 days'
      AND order_date <= (SELECT d FROM anchor_date)
),
-- 9 & 10. Pegawai
emp_stat AS (
    SELECT
        ROUND(SUM(is_present+is_late)*100.0/NULLIF(SUM(is_present+is_late+is_absent),0),1) AS h,
        ROUND(SUM(is_late)*100.0/NULLIF(SUM(is_present+is_late),0),1) AS t
    FROM main_marts.mart_employee_shift_performance
    WHERE attendance_date >= (SELECT d FROM anchor_date) - INTERVAL '6 days'
      AND attendance_date <= (SELECT d FROM anchor_date)
),
-- 11 & 12. Inventori
inv_stat AS (
    SELECT
        ROUND(SUM(usage_cost)*100.0/NULLIF((SELECT SUM(gross_revenue) FROM main_marts.mart_daily_net_revenue WHERE metric_date >= (SELECT d FROM anchor_date) - INTERVAL '6 days' AND metric_date <= (SELECT d FROM anchor_date)),0),1) AS b,
        ROUND(SUM(purchase_cost)/NULLIF(SUM(usage_cost),0),2) AS r
    FROM main_marts.mart_inventory_stok
    WHERE txn_date >= (SELECT d FROM anchor_date) - INTERVAL '6 days'
      AND txn_date <= (SELECT d FROM anchor_date)
),
-- 13. Jam Sibuk
peak_stat AS (
    SELECT ROUND(MAX(jam_total)*100.0/NULLIF(SUM(jam_total),0),1) AS p
    FROM (SELECT order_hour, SUM(total_orders) AS jam_total FROM main_marts.mart_peak_hours
          WHERE order_date >= (SELECT d FROM anchor_date) - INTERVAL '6 days'
            AND order_date <= (SELECT d FROM anchor_date)
          GROUP BY order_hour)
)

-- FINAL UNION
SELECT 'Keuangan' AS section, '💰' AS icon,
    CASE WHEN m < 5 THEN 'kritis' WHEN m < 10 THEN 'perhatian' ELSE 'sehat' END AS status,
    'Net margin ' || m || '%' AS label, 'Net Margin' AS metrik FROM fin
UNION ALL
SELECT 'Cabang', '🏪',
    CASE WHEN p >= -5 THEN 'sehat' WHEN p >= -15 THEN 'perhatian' ELSE 'kritis' END,
    'Order ' || p || '% vs 7h lalu', 'Order vs 7h Lalu' FROM ord
UNION ALL
SELECT 'Cabang', '🏪',
    CASE WHEN aov < 35000 THEN 'kritis' WHEN aov < 50000 THEN 'perhatian' ELSE 'sehat' END,
    'AOV Rp ' || aov, 'AOV' FROM aov_stat
UNION ALL
SELECT 'Cabang', '🏪',
    CASE WHEN g > 100 THEN 'kritis' WHEN g >= 50 THEN 'perhatian' ELSE 'sehat' END,
    'Gap antar cabang ' || g || '%', 'Gap Cabang' FROM gap_stat
UNION ALL
SELECT 'Menu', '🍽️',
    CASE WHEN a < 50 THEN 'kritis' WHEN a < 70 THEN 'perhatian' ELSE 'sehat' END,
    a || '% menu aktif', 'Menu Aktif' FROM menu_active
UNION ALL
SELECT 'Menu', '🍽️',
    CASE WHEN k > 50 THEN 'kritis' WHEN k > 30 THEN 'perhatian' ELSE 'sehat' END,
    'Menu terlaris dominasi ' || k || '%', 'Kontribusi Menu' FROM menu_top
UNION ALL
SELECT 'Member', '👥',
    CASE WHEN p < 20 THEN 'kritis' WHEN p < 40 THEN 'perhatian' ELSE 'sehat' END,
    p || '% order member', 'Order Member' FROM mem_stat
UNION ALL
SELECT 'Member', '👥',
    CASE WHEN f < 1 THEN 'kritis' WHEN f < 3 THEN 'perhatian' ELSE 'sehat' END,
    f || 'x transaksi/member', 'Avg Frekuensi' FROM mem_freq
UNION ALL
SELECT 'Pegawai', '👨‍💼',
    CASE WHEN h < 85 THEN 'kritis' WHEN h < 95 THEN 'perhatian' ELSE 'sehat' END,
    'Kehadiran ' || h || '%', 'Kehadiran' FROM emp_stat
UNION ALL
SELECT 'Pegawai', '👨‍💼',
    CASE WHEN t > 20 THEN 'kritis' WHEN t > 10 THEN 'perhatian' ELSE 'sehat' END,
    'Keterlambatan ' || t || '%', 'Keterlambatan' FROM emp_stat
UNION ALL
SELECT 'Inventori', '📦',
    CASE WHEN b > 38 THEN 'kritis' WHEN b > 32 THEN 'perhatian' ELSE 'sehat' END,
    'Biaya bahan ' || b || '%', 'Biaya Bahan' FROM inv_stat
UNION ALL
SELECT 'Inventori', '📦',
    CASE WHEN r > 1.5 OR r < 0.9 THEN 'kritis' WHEN r > 1.2 THEN 'perhatian' ELSE 'sehat' END,
    'Rasio beli/pakai ' || r, 'Rasio Beli/Pakai' FROM inv_stat
UNION ALL
SELECT 'Jam Sibuk', '⏰',
    CASE WHEN p > 20 THEN 'kritis' WHEN p > 12 THEN 'perhatian' ELSE 'sehat' END,
    p || '% order jam puncak', 'Konsentrasi Order' FROM peak_stat

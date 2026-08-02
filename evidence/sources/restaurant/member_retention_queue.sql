WITH max_d AS (SELECT MAX(order_date) AS d FROM main_marts.mart_member_purchase_behavior),
members AS (
    SELECT member_id, member_name, tier, city
    FROM main_foundation.dim_members
),
orders_180 AS (
    SELECT member_id,
        SUM(total_orders) AS total_orders_180,
        SUM(total_spend) AS total_spend_180,
        ROUND(SUM(total_orders)/25.71,1) AS orders_per_week_180,
        ROUND(SUM(total_spend)/NULLIF(SUM(total_orders),0),0) AS avg_order_value_180
    FROM main_marts.mart_member_purchase_behavior CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '179 days'
    GROUP BY member_id
),
visit_days AS (
    SELECT DISTINCT member_id, order_date
    FROM main_marts.mart_member_purchase_behavior CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '179 days'
      AND order_date <= d
),
visit_gaps AS (
    SELECT
        member_id,
        order_date,
        DATEDIFF('day', LAG(order_date) OVER (PARTITION BY member_id ORDER BY order_date), order_date) AS gap_days
    FROM visit_days
),
visit_rhythm AS (
    SELECT
        member_id,
        COUNT(*) AS visit_days_180,
        ROUND(AVG(gap_days),1) AS avg_visit_interval_days
    FROM visit_gaps
    GROUP BY member_id
),
last_order AS (
    SELECT member_id, MAX(order_date) AS last_order_date
    FROM main_marts.mart_member_purchase_behavior CROSS JOIN max_d
    WHERE order_date <= d
    GROUP BY member_id
),
base AS (
    SELECT
        m.member_name, m.tier, m.city,
        COALESCE(o.total_orders_180,0) AS total_orders,
        COALESCE(o.orders_per_week_180,0) AS orders_per_week,
        COALESCE(o.total_spend_180,0) AS total_spend,
        COALESCE(o.avg_order_value_180,0) AS avg_order_value,
        COALESCE(r.visit_days_180,0) AS visit_days_180,
        r.avg_visit_interval_days,
        COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) AS recency_days,
        CASE
            WHEN r.avg_visit_interval_days IS NULL THEN NULL
            ELSE ROUND(COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) - r.avg_visit_interval_days, 1)
        END AS delay_days
    FROM members m
    CROSS JOIN max_d
    LEFT JOIN orders_180 o ON m.member_id = o.member_id
    LEFT JOIN visit_rhythm r ON m.member_id = r.member_id
    LEFT JOIN last_order l ON m.member_id = l.member_id
),
spend_p75 AS (
    SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_spend) AS p75
    FROM base WHERE total_spend > 0
),
gold_risk AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY delay_days DESC NULLS LAST, total_spend DESC) AS rn,
        CASE WHEN recency_days >= 21 OR delay_days >= 14 THEN 'Kritis' ELSE 'Tinggi' END AS severity,
        'Gold Churn Risk'  AS action_type,
        'Gold mulai jarang kembali' AS action_label,
        'Hubungi personal, beri apresiasi khusus' AS action_short,
        member_name, tier, city,
        total_spend,
        avg_order_value,
        total_orders,
        orders_per_week,
        recency_days,
        delay_days,
        avg_visit_interval_days,
        CAST(recency_days AS VARCHAR) || ' hari tidak transaksi' AS metric_value,
        CASE
            WHEN avg_visit_interval_days IS NULL THEN 'Ritme normal belum cukup histori.'
            WHEN delay_days > 0 THEN 'Biasanya tiap ' || CAST(avg_visit_interval_days AS VARCHAR) || ' hari; sekarang telat ' || CAST(delay_days AS VARCHAR) || ' hari dari ritme normal.'
            ELSE 'Masih dalam ritme kunjungan normal.'
        END AS rhythm_text,
        'Member Gold bernilai tinggi mulai berisiko churn.' AS impact_text,
        'Hubungi personal via WhatsApp/telepon. Beri apresiasi khusus, akses reservasi, atau perhatian personal.' AS recommended_action
    FROM base
    WHERE tier = 'Gold' AND delay_days > 7
),
hv_inactive AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY delay_days DESC NULLS LAST, total_spend DESC) AS rn,
        'Tinggi'            AS severity,
        'High-Value Inactive' AS action_type,
        'Member bernilai tinggi tidak aktif' AS action_label,
        'Kirim win-back personal' AS action_short,
        member_name, tier, city,
        total_spend,
        avg_order_value,
        total_orders,
        orders_per_week,
        recency_days,
        delay_days,
        avg_visit_interval_days,
        CAST(recency_days AS VARCHAR) || ' hari · Rp' || CAST(ROUND(total_spend/1000000.0,1) AS VARCHAR) || 'jt' AS metric_value,
        CASE
            WHEN avg_visit_interval_days IS NULL THEN 'Ritme normal belum cukup histori.'
            WHEN delay_days > 0 THEN 'Biasanya tiap ' || CAST(avg_visit_interval_days AS VARCHAR) || ' hari; sekarang telat ' || CAST(delay_days AS VARCHAR) || ' hari dari ritme normal.'
            ELSE 'Masih dalam ritme kunjungan normal.'
        END AS rhythm_text,
        'Member dengan belanja besar tapi sudah lama tidak aktif.' AS impact_text,
        'Kirim pesan win-back dengan penawaran personalisasi.' AS recommended_action
    FROM base, spend_p75
    WHERE tier IN ('Silver','Bronze')
      AND delay_days > 7
      AND total_spend > spend_p75.p75
      AND total_spend > 0
)
SELECT
    severity,
    action_type,
    action_label,
    action_short,
    member_name,
    tier,
    city,
    CAST(recency_days AS VARCHAR) || ' hari lalu' AS last_order_label,
    CASE
        WHEN delay_days IS NULL THEN 'Belum cukup histori'
        WHEN delay_days > 0 THEN CAST(delay_days AS VARCHAR) || ' hari'
        ELSE 'Masih sesuai ritme'
    END AS delay_label,
    delay_days,
    avg_visit_interval_days,
    recency_days,
    total_spend,
    avg_order_value,
    total_orders,
    orders_per_week,
    metric_value,
    rhythm_text,
    impact_text,
    recommended_action
FROM (
    SELECT severity, action_type, action_label, action_short, member_name, tier, city, total_spend, avg_order_value, total_orders, orders_per_week, recency_days, delay_days, avg_visit_interval_days, metric_value, rhythm_text, impact_text, recommended_action, rn FROM gold_risk
    UNION ALL
    SELECT severity, action_type, action_label, action_short, member_name, tier, city, total_spend, avg_order_value, total_orders, orders_per_week, recency_days, delay_days, avg_visit_interval_days, metric_value, rhythm_text, impact_text, recommended_action, rn FROM hv_inactive
)
ORDER BY
    CASE severity WHEN 'Kritis' THEN 1 WHEN 'Tinggi' THEN 2 ELSE 3 END,
    CASE action_type WHEN 'Gold Churn Risk' THEN 1 ELSE 2 END,
    rn

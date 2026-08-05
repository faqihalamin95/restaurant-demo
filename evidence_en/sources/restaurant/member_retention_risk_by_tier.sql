WITH max_d AS (SELECT MAX(order_date) AS d FROM main_marts.mart_member_purchase_behavior),
members AS (
    SELECT member_id, member_name, tier, city
    FROM main_foundation.dim_members
),
last_order AS (
    SELECT member_id, MAX(order_date) AS last_order_date
    FROM main_marts.mart_member_purchase_behavior CROSS JOIN max_d
    WHERE order_date <= d
    GROUP BY member_id
),
orders_180 AS (
    SELECT member_id,
        SUM(total_orders) AS total_orders_180,
        SUM(total_spend) AS total_spend_180
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
base AS (
    SELECT
        m.member_id,
        m.tier,
        COALESCE(o.total_orders_180,0) AS total_orders_180,
        COALESCE(o.total_spend_180,0) AS total_spend_180,
        COALESCE(r.visit_days_180,0) AS visit_days_180,
        r.avg_visit_interval_days,
        COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) AS recency_days,
        CASE
            WHEN r.avg_visit_interval_days IS NULL THEN NULL
            ELSE ROUND(COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) - r.avg_visit_interval_days, 1)
        END AS delay_days,
        CASE
            WHEN m.tier='Gold' AND COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) >= 14 THEN 1
            WHEN m.tier='Silver' AND COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) >= 21 THEN 1
            WHEN m.tier='Bronze' AND COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) >= 30 THEN 1
            ELSE 0
        END AS is_churn_risk
    FROM members m
    CROSS JOIN max_d
    LEFT JOIN last_order l ON m.member_id = l.member_id
    LEFT JOIN orders_180 o ON m.member_id = o.member_id
    LEFT JOIN visit_rhythm r ON m.member_id = r.member_id
)
SELECT
    tier,
    COUNT(*) AS total_members,
    SUM(is_churn_risk) AS churn_risk_members,
    ROUND(SUM(is_churn_risk)*100.0/NULLIF(COUNT(*),0),1) AS churn_risk_pct,
    ROUND(AVG(CASE WHEN recency_days < 9999 THEN recency_days END),1) AS avg_recency_days,
    ROUND(AVG(CASE WHEN is_churn_risk=1 AND avg_visit_interval_days IS NOT NULL THEN avg_visit_interval_days END),1) AS avg_visit_interval_days,
    ROUND(AVG(CASE WHEN is_churn_risk=1 AND delay_days IS NOT NULL THEN delay_days END),1) AS avg_delay_days,
    SUM(CASE WHEN is_churn_risk=1 AND delay_days > 0 THEN 1 ELSE 0 END) AS delayed_beyond_rhythm,
    SUM(CASE WHEN is_churn_risk=1 AND avg_visit_interval_days IS NOT NULL THEN 1 ELSE 0 END) AS rhythm_known_members,
    SUM(total_orders_180) AS orders_180d,
    SUM(total_spend_180) AS spend_180d,
    ROUND(SUM(total_spend_180)/NULLIF(SUM(total_orders_180),0),0) AS avg_order_value_180d
FROM base
GROUP BY tier
ORDER BY CASE tier WHEN 'Gold' THEN 1 WHEN 'Silver' THEN 2 ELSE 3 END

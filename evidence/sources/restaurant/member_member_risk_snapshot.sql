WITH max_d AS (SELECT MAX(order_date) AS d FROM main_marts.mart_member_purchase_behavior),
members AS (
    SELECT member_id, member_name, tier, city
    FROM main_foundation.dim_members
),
orders_180 AS (
    SELECT member_id,
        SUM(total_orders) AS total_orders_180,
        SUM(total_spend) AS total_spend_180
    FROM main_marts.mart_member_purchase_behavior CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '179 days'
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
        m.member_id, m.tier,
        COALESCE(o.total_spend_180,0) AS total_spend_180,
        COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) AS recency_days,
        CASE
            WHEN m.tier='Gold' AND COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) >= 14 THEN 1
            WHEN m.tier='Silver' AND COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) >= 21 THEN 1
            WHEN m.tier='Bronze' AND COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) >= 30 THEN 1
            ELSE 0
        END AS is_churn_risk
    FROM members m
    CROSS JOIN max_d
    LEFT JOIN orders_180 o ON m.member_id = o.member_id
    LEFT JOIN last_order l ON m.member_id = l.member_id
),
spend_p75 AS (
    SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_spend_180) AS p75
    FROM base
    WHERE total_spend_180 > 0
)
SELECT
    COUNT(*) AS total_members,
    SUM(is_churn_risk) AS churn_risk_members,
    ROUND(SUM(is_churn_risk)*100.0/NULLIF(COUNT(*),0),1) AS churn_risk_pct,
    SUM(CASE WHEN tier='Gold' AND is_churn_risk=1 THEN 1 ELSE 0 END) AS gold_churn_risk,
    SUM(CASE WHEN tier='Silver' AND is_churn_risk=1 THEN 1 ELSE 0 END) AS silver_churn_risk,
    SUM(CASE WHEN tier='Bronze' AND is_churn_risk=1 THEN 1 ELSE 0 END) AS bronze_churn_risk,
    SUM(CASE WHEN tier IN ('Silver','Bronze')
              AND recency_days >= 21
              AND total_spend_180 > (SELECT p75 FROM spend_p75)
             THEN 1 ELSE 0 END) AS high_value_inactive
FROM base

WITH max_d AS (SELECT MAX(order_date) AS d FROM main_marts.mart_member_purchase_behavior),
members AS (
    SELECT member_id, member_name, tier, city
    FROM main_foundation.dim_members
),
orders_90 AS (
    SELECT
        member_id,
        SUM(total_orders) AS total_orders,
        SUM(total_spend) AS total_spend,
        ROUND(SUM(total_spend)/NULLIF(SUM(total_orders),0),0) AS avg_order_value
    FROM main_marts.mart_member_purchase_behavior CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '89 days'
      AND order_date <= d
    GROUP BY member_id
),
last_order AS (
    SELECT member_id, MAX(order_date) AS last_order_date
    FROM main_marts.mart_member_purchase_behavior CROSS JOIN max_d
    WHERE order_date <= d
    GROUP BY member_id
)
SELECT
    m.member_name,
    m.tier,
    m.city,
    COALESCE(o.total_orders,0) AS total_orders,
    ROUND(COALESCE(o.total_orders,0)/12.86,1) AS orders_per_week,
    COALESCE(o.total_spend,0) AS total_spend,
    COALESCE(o.avg_order_value,0) AS avg_order_value,
    COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) AS recency_days,
    CASE
        WHEN COALESCE(o.total_orders,0) = 0 THEN 'Belum aktif'
        WHEN m.tier='Gold' AND COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) >= 14 THEN 'Berisiko'
        WHEN m.tier='Silver' AND COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) >= 21 THEN 'Berisiko'
        WHEN m.tier='Bronze' AND COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) >= 30 THEN 'Berisiko'
        ELSE 'Aktif'
    END AS status_member
FROM members m
CROSS JOIN max_d
LEFT JOIN orders_90 o ON m.member_id = o.member_id
LEFT JOIN last_order l ON m.member_id = l.member_id
ORDER BY
    CASE m.tier WHEN 'Gold' THEN 1 WHEN 'Silver' THEN 2 ELSE 3 END,
    COALESCE(o.total_spend,0) DESC

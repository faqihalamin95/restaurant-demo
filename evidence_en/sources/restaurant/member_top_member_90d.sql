WITH max_d AS (SELECT MAX(order_date) AS d FROM main_marts.mart_member_purchase_behavior),
base AS (
    SELECT member_name, tier, city,
        SUM(total_orders)              AS total_orders,
        ROUND(SUM(total_orders)/12.86,1) AS orders_per_week,
        SUM(total_items)               AS total_items,
        SUM(total_spend)               AS total_spend,
        ROUND(AVG(avg_order_value),0)  AS avg_order_value,
        DATEDIFF('day', MAX(order_date), d) AS recency_days
    FROM main_marts.mart_member_purchase_behavior CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '89 days'
    GROUP BY member_name, tier, city, d
),
p75 AS (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_spend) AS v FROM base)
SELECT
    b.member_name, b.tier, b.city,
    b.total_orders, b.orders_per_week,
    b.total_items, b.total_spend, b.avg_order_value, b.recency_days,
    CASE
        WHEN (b.tier='Gold' AND b.recency_days>=14)
          OR (b.tier='Silver' AND b.recency_days>=21)
          OR (b.tier='Bronze' AND b.recency_days>=30) THEN 'Cek Retensi'
        WHEN b.total_spend >= p.v AND b.recency_days < 14 THEN 'Pertahankan'
        WHEN b.orders_per_week >= 2 AND b.avg_order_value < 50000 THEN 'Dorong add-on'
        WHEN b.tier = 'Bronze' AND b.orders_per_week >= 1 THEN 'Dorong upgrade'
        ELSE 'Pantau'
    END AS member_action
FROM base b, p75 p
ORDER BY b.total_spend DESC
LIMIT 25

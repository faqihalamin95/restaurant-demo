WITH max_d AS (SELECT MAX(order_date) AS d FROM main_marts.mart_member_purchase_behavior)
SELECT
    city,
    COUNT(DISTINCT member_id)      AS active_members,
    SUM(total_spend)               AS total_spend,
    ROUND(AVG(avg_order_value),0)  AS avg_order_value,
    ROUND(SUM(total_orders)*1.0/NULLIF(COUNT(DISTINCT member_id),0),1) AS orders_per_member
FROM main_marts.mart_member_purchase_behavior CROSS JOIN max_d
WHERE order_date >= d - INTERVAL '89 days'
GROUP BY city
ORDER BY total_spend DESC

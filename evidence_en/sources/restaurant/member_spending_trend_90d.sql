SELECT
    order_date,
    tier,
    SUM(total_spend)               AS total_spend,
    SUM(total_orders)              AS total_orders,
    COUNT(DISTINCT member_id)      AS active_members
FROM main_marts.mart_member_purchase_behavior
WHERE order_date >= (SELECT MAX(order_date) FROM main_marts.mart_member_purchase_behavior) - INTERVAL '89 days'
GROUP BY order_date, tier
ORDER BY order_date, tier

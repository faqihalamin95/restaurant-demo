SELECT
    tier,
    COUNT(DISTINCT member_id)                                    AS total_member,
    SUM(total_spend)                                             AS total_belanja,
    ROUND(SUM(total_orders)*1.0/NULLIF(COUNT(DISTINCT member_id),0),1) AS avg_frekuensi
FROM main_marts.mart_member_purchase_behavior
WHERE order_date >= (SELECT MAX(order_date) FROM main_marts.mart_member_purchase_behavior) - INTERVAL '29 days'
GROUP BY tier ORDER BY total_belanja DESC

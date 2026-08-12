SELECT
    DATE_TRUNC('month', join_date)                                                AS cohort_bulan,
    tier,
    COUNT(DISTINCT member_id)                                                      AS total_member,
    ROUND(SUM(total_spend)/NULLIF(COUNT(DISTINCT member_id),0),0)                 AS avg_spend_per_member,
    ROUND(SUM(total_orders)*1.0/NULLIF(COUNT(DISTINCT member_id),0)/12.86,1)      AS avg_frekuensi_mingguan
FROM main_marts.mart_member_purchase_behavior
WHERE order_date >= (SELECT MAX(order_date) FROM main_marts.mart_member_purchase_behavior) - INTERVAL '89 days'
GROUP BY 1, 2
ORDER BY 1, 2

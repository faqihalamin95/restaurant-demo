WITH max_d AS (SELECT MAX(order_date) AS d FROM main_marts.mart_member_purchase_behavior)
SELECT
    city, tier,
    COUNT(DISTINCT member_id)      AS active_members,
    SUM(total_spend)               AS total_spend,
    ROUND(AVG(avg_order_value),0)  AS avg_order_value,
    ROUND(COUNT(DISTINCT member_id)*100.0 /
        NULLIF(SUM(COUNT(DISTINCT member_id)) OVER (PARTITION BY city),0),1) AS pct_members_in_city,
    ROUND(SUM(total_spend)*100.0 /
        NULLIF(SUM(SUM(total_spend)) OVER (PARTITION BY city),0),1) AS pct_spend_in_city
FROM main_marts.mart_member_purchase_behavior CROSS JOIN max_d
WHERE order_date >= d - INTERVAL '89 days'
GROUP BY city, tier
ORDER BY city, total_spend DESC

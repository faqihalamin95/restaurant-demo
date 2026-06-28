WITH max_d AS (SELECT MAX(order_date) AS d FROM main_marts.mart_member_purchase_behavior),
base AS (
    SELECT member_id, tier,
        SUM(total_orders) AS orders,
        SUM(total_spend)  AS spend
    FROM main_marts.mart_member_purchase_behavior CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '89 days'
    GROUP BY member_id, tier
),
totals AS (SELECT SUM(spend) AS tot FROM base)
SELECT tier,
    COUNT(DISTINCT member_id)                                                     AS active_members,
    SUM(orders)                                                                    AS total_orders,
    SUM(spend)                                                                     AS total_spend,
    ROUND(SUM(spend)/NULLIF(SUM(orders),0),0)                                     AS avg_order_value,
    ROUND(SUM(orders)*1.0/NULLIF(COUNT(DISTINCT member_id),0),1)                  AS orders_per_member,
    ROUND(SUM(orders)*1.0/NULLIF(COUNT(DISTINCT member_id),0)/12.86,2)            AS orders_per_member_per_week,
    ROUND(SUM(spend)/NULLIF(COUNT(DISTINCT member_id),0),0)                       AS spend_per_member,
    ROUND(SUM(spend)*100.0/NULLIF(t.tot,0),1)                                     AS pct_spend,
    ROUND(COUNT(DISTINCT member_id)*100.0/NULLIF(SUM(COUNT(DISTINCT member_id)) OVER (),0),1) AS pct_members
FROM base, totals t
GROUP BY tier, t.tot
ORDER BY total_spend DESC

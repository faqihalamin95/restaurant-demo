WITH max_d AS (SELECT MAX(order_date) AS d FROM main_marts.mart_member_purchase_behavior),
curr AS (
    SELECT tier, member_id, SUM(total_spend) AS spend, SUM(total_orders) AS orders
    FROM main_marts.mart_member_purchase_behavior CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '89 days'
    GROUP BY tier, member_id
),
prev AS (
    SELECT tier, member_id, SUM(total_spend) AS spend, SUM(total_orders) AS orders
    FROM main_marts.mart_member_purchase_behavior CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '179 days'
      AND order_date <  d - INTERVAL '89 days'
    GROUP BY tier, member_id
),
ac AS (SELECT tier, SUM(spend) AS sc, SUM(orders) AS oc, COUNT(*) AS mc FROM curr GROUP BY tier),
ap AS (SELECT tier, SUM(spend) AS sp, SUM(orders) AS op, COUNT(*) AS mp FROM prev GROUP BY tier)
SELECT c.tier,
    c.sc                                                                          AS spend_current,
    COALESCE(p.sp,0)                                                              AS spend_previous,
    ROUND((c.sc - COALESCE(p.sp,0))/NULLIF(p.sp,0)*100,1)                        AS spend_change_pct,
    c.oc                                                                          AS orders_current,
    COALESCE(p.op,0)                                                              AS orders_previous,
    ROUND((c.oc - COALESCE(p.op,0))/NULLIF(p.op,0)*100,1)                        AS orders_change_pct,
    ROUND(c.oc*1.0/NULLIF(c.mc,0)/12.86,2)                                       AS freq_current,
    ROUND(COALESCE(p.op,0)*1.0/NULLIF(p.mp,0)/12.86,2)                           AS freq_previous,
    CASE
        WHEN (c.sc - COALESCE(p.sp,0))/NULLIF(p.sp,0)*100 >=  10 THEN 'Naik'
        WHEN (c.sc - COALESCE(p.sp,0))/NULLIF(p.sp,0)*100 <= -10 THEN 'Turun'
        ELSE 'Stabil'
    END AS movement_status
FROM ac c LEFT JOIN ap p ON c.tier=p.tier
ORDER BY c.sc DESC

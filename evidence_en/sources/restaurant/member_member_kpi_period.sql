WITH max_d AS (SELECT MAX(order_date) AS d FROM main_marts.mart_member_purchase_behavior),
members AS (
    SELECT member_id, tier, join_date
    FROM main_foundation.dim_members
),
last_order AS (
    SELECT member_id, MAX(order_date) AS last_order_date
    FROM main_marts.mart_member_purchase_behavior CROSS JOIN max_d
    WHERE order_date <= d
    GROUP BY member_id
),
member_state AS (
    SELECT
        m.member_id,
        m.tier,
        m.join_date,
        COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) AS recency_days,
        CASE
            WHEN m.tier='Gold' AND COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) >= 14 THEN 1
            WHEN m.tier='Silver' AND COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) >= 21 THEN 1
            WHEN m.tier='Bronze' AND COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) >= 30 THEN 1
            ELSE 0
        END AS is_churn_risk
    FROM members m
    CROSS JOIN max_d
    LEFT JOIN last_order l ON m.member_id = l.member_id
),
curr_30 AS (
    SELECT member_id,
        SUM(total_orders) AS orders, SUM(total_spend) AS spend
    FROM main_marts.mart_member_purchase_behavior CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '29 days'
    GROUP BY member_id
),
curr_90 AS (
    SELECT member_id,
        SUM(total_orders) AS orders, SUM(total_spend) AS spend
    FROM main_marts.mart_member_purchase_behavior CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '89 days'
    GROUP BY member_id
),
all_orders_30 AS (
    SELECT SUM(total_orders) AS total_restaurant_orders,
           SUM(total_revenue) AS total_restaurant_revenue
    FROM main_marts.mart_daily_revenue CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '29 days'
      AND order_date <= d
),
all_orders_90 AS (
    SELECT SUM(total_orders) AS total_restaurant_orders,
           SUM(total_revenue) AS total_restaurant_revenue
    FROM main_marts.mart_daily_revenue CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '89 days'
      AND order_date <= d
),
new_member_activation_30 AS (
  SELECT 
    COUNT(*) as new_members_count,
    COUNT(CASE WHEN COALESCE(p.lifetime_visits, 0) >= 2 THEN 1 END) as activated_new_members
  FROM members m
  CROSS JOIN max_d
  LEFT JOIN (
    SELECT member_id, COUNT(DISTINCT order_date) as lifetime_visits
    FROM main_marts.mart_member_purchase_behavior
    GROUP BY member_id
  ) p ON m.member_id = p.member_id
  WHERE m.join_date >= d - INTERVAL '29 days'
),
new_member_activation_90 AS (
  SELECT 
    COUNT(*) as new_members_count,
    COUNT(CASE WHEN COALESCE(p.lifetime_visits, 0) >= 2 THEN 1 END) as activated_new_members
  FROM members m
  CROSS JOIN max_d
  LEFT JOIN (
    SELECT member_id, COUNT(DISTINCT order_date) as lifetime_visits
    FROM main_marts.mart_member_purchase_behavior
    GROUP BY member_id
  ) p ON m.member_id = p.member_id
  WHERE m.join_date >= d - INTERVAL '89 days'
)
SELECT '30d' AS period,
    COUNT(*) AS total_members,
    COUNT(CASE WHEN COALESCE(c.orders,0)>0 THEN 1 END) AS active_members,
    ROUND(COUNT(CASE WHEN COALESCE(c.orders,0)>0 THEN 1 END)*100.0/NULLIF(COUNT(*),0),1) AS active_rate_pct,
    MAX(n.new_members_count) AS new_members,
    ROUND(MAX(n.activated_new_members) * 100.0 / NULLIF(MAX(n.new_members_count), 0), 1) AS activation_rate_pct,
    SUM(COALESCE(c.orders,0)) AS total_member_orders,
    MAX(a.total_restaurant_orders) AS total_restaurant_orders,
    MAX(a.total_restaurant_revenue) AS total_restaurant_revenue,
    ROUND(SUM(COALESCE(c.orders,0))*100.0/NULLIF(MAX(a.total_restaurant_orders),0),1) AS pct_order_member,
    SUM(COALESCE(c.spend,0)) AS total_member_spend,
    ROUND(SUM(COALESCE(c.spend,0))*100.0/NULLIF(MAX(a.total_restaurant_revenue),0),1) AS pct_revenue_member,
    ROUND(SUM(COALESCE(c.spend,0))/NULLIF(SUM(COALESCE(c.orders,0)),0),0) AS avg_order_value,
    ROUND((MAX(a.total_restaurant_revenue) - SUM(COALESCE(c.spend,0))) / NULLIF(MAX(a.total_restaurant_orders) - SUM(COALESCE(c.orders,0)), 0), 0) AS avg_order_value_non_member,
    ROUND(SUM(COALESCE(c.orders,0))*1.0/NULLIF(COUNT(CASE WHEN COALESCE(c.orders,0)>0 THEN 1 END),0)/4.29,2) AS avg_orders_per_member,
    ROUND(SUM(COALESCE(c.orders,0))*1.0/NULLIF(COUNT(CASE WHEN COALESCE(c.orders,0)>0 THEN 1 END),0)/4.29,2) AS orders_per_member_per_week,
    SUM(ms.is_churn_risk) AS churn_risk_count,
    SUM(CASE WHEN ms.tier='Gold' AND ms.is_churn_risk=1 THEN 1 ELSE 0 END) AS gold_churn_risk
FROM member_state ms
CROSS JOIN all_orders_30 a
CROSS JOIN new_member_activation_30 n
LEFT JOIN curr_30 c ON ms.member_id = c.member_id
UNION ALL
SELECT '90d' AS period,
    COUNT(*) AS total_members,
    COUNT(CASE WHEN COALESCE(c.orders,0)>0 THEN 1 END) AS active_members,
    ROUND(COUNT(CASE WHEN COALESCE(c.orders,0)>0 THEN 1 END)*100.0/NULLIF(COUNT(*),0),1) AS active_rate_pct,
    MAX(n.new_members_count) AS new_members,
    ROUND(MAX(n.activated_new_members) * 100.0 / NULLIF(MAX(n.new_members_count), 0), 1) AS activation_rate_pct,
    SUM(COALESCE(c.orders,0)) AS total_member_orders,
    MAX(a.total_restaurant_orders) AS total_restaurant_orders,
    MAX(a.total_restaurant_revenue) AS total_restaurant_revenue,
    ROUND(SUM(COALESCE(c.orders,0))*100.0/NULLIF(MAX(a.total_restaurant_orders),0),1) AS pct_order_member,
    SUM(COALESCE(c.spend,0)) AS total_member_spend,
    ROUND(SUM(COALESCE(c.spend,0))*100.0/NULLIF(MAX(a.total_restaurant_revenue),0),1) AS pct_revenue_member,
    ROUND(SUM(COALESCE(c.spend,0))/NULLIF(SUM(COALESCE(c.orders,0)),0),0) AS avg_order_value,
    ROUND((MAX(a.total_restaurant_revenue) - SUM(COALESCE(c.spend,0))) / NULLIF(MAX(a.total_restaurant_orders) - SUM(COALESCE(c.orders,0)), 0), 0) AS avg_order_value_non_member,
    ROUND(SUM(COALESCE(c.orders,0))*1.0/NULLIF(COUNT(CASE WHEN COALESCE(c.orders,0)>0 THEN 1 END),0)/12.86,2) AS avg_orders_per_member,
    ROUND(SUM(COALESCE(c.orders,0))*1.0/NULLIF(COUNT(CASE WHEN COALESCE(c.orders,0)>0 THEN 1 END),0)/12.86,2) AS orders_per_member_per_week,
    SUM(ms.is_churn_risk) AS churn_risk_count,
    SUM(CASE WHEN ms.tier='Gold' AND ms.is_churn_risk=1 THEN 1 ELSE 0 END) AS gold_churn_risk
FROM member_state ms
CROSS JOIN all_orders_90 a
CROSS JOIN new_member_activation_90 n
LEFT JOIN curr_90 c ON ms.member_id = c.member_id

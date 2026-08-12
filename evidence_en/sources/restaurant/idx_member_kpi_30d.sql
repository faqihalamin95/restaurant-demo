WITH anchor_date AS (SELECT MAX(order_date) AS d FROM main_marts.mart_daily_revenue)
SELECT
    COUNT(DISTINCT member_id) AS member_aktif,
    ROUND(SUM(total_orders)*100.0/NULLIF(
        (SELECT SUM(total_orders) FROM main_marts.mart_daily_revenue
         WHERE order_date >= (SELECT d FROM anchor_date) - INTERVAL '29 days'
           AND order_date <= (SELECT d FROM anchor_date))
    ,0),1) AS pct_order_member,
    ROUND(SUM(total_orders)*1.0/NULLIF(COUNT(DISTINCT member_id),0),1) AS avg_frekuensi
FROM main_marts.mart_member_purchase_behavior
WHERE order_date >= (SELECT d FROM anchor_date) - INTERVAL '29 days'
  AND order_date <= (SELECT d FROM anchor_date)

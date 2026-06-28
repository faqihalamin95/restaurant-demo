WITH anchor_date AS (SELECT MAX(order_date) AS d FROM main_marts.mart_daily_revenue)
SELECT
    CAST(h.peak_hour AS INTEGER) || ':00' AS jam_puncak,
    h.day_part AS periode_puncak,
    h.peak_orders,
    ROUND(h.peak_orders * 100.0 / h.total_all, 1) AS pct_jam_puncak,
    CASE d.order_type
        WHEN 'dine_in'  THEN 'Dine In'
        WHEN 'takeaway' THEN 'Takeaway'
        WHEN 'delivery' THEN 'Delivery'
        ELSE d.order_type
    END AS order_type_dominan
FROM (
    SELECT order_hour AS peak_hour, day_part,
        SUM(total_orders) AS peak_orders,
        SUM(SUM(total_orders)) OVER () AS total_all
    FROM main_marts.mart_peak_hours
    WHERE order_date >= (SELECT d FROM anchor_date) - INTERVAL '29 days'
      AND order_date <= (SELECT d FROM anchor_date)
    GROUP BY order_hour, day_part
    ORDER BY peak_orders DESC LIMIT 1
) h
CROSS JOIN (
    SELECT order_type
    FROM main_marts.mart_peak_hours
    WHERE order_date >= (SELECT d FROM anchor_date) - INTERVAL '29 days'
      AND order_date <= (SELECT d FROM anchor_date)
    AND order_hour = (
        SELECT order_hour FROM main_marts.mart_peak_hours
        WHERE order_date >= (SELECT d FROM anchor_date) - INTERVAL '29 days'
          AND order_date <= (SELECT d FROM anchor_date)
        GROUP BY order_hour ORDER BY SUM(total_orders) DESC LIMIT 1
    )
    GROUP BY order_type ORDER BY SUM(total_orders) DESC LIMIT 1
) d

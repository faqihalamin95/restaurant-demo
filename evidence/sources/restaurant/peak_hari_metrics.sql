WITH daily AS (
    SELECT
        order_date,
        CASE DAYNAME(order_date)
            WHEN 'Monday' THEN 'Senin' WHEN 'Tuesday' THEN 'Selasa' WHEN 'Wednesday' THEN 'Rabu'
            WHEN 'Thursday' THEN 'Kamis' WHEN 'Friday' THEN 'Jumat'
            WHEN 'Saturday' THEN 'Sabtu' WHEN 'Sunday' THEN 'Minggu'
        END AS hari,
        CASE DAYNAME(order_date) WHEN 'Saturday' THEN 'Weekend' WHEN 'Sunday' THEN 'Weekend' ELSE 'Weekday' END AS tipe_hari,
        SUM(total_orders) AS total_orders
    FROM main_marts.mart_peak_hours
    WHERE order_date >= (SELECT MAX(order_date) FROM main_marts.mart_peak_hours) - INTERVAL '29 days'
    GROUP BY order_date, DAYNAME(order_date)
),
by_day AS (
    SELECT hari, tipe_hari, ROUND(AVG(total_orders), 0) AS avg_orders, SUM(total_orders) AS sum_orders
    FROM daily GROUP BY hari, tipe_hari
),
totals AS (SELECT SUM(sum_orders) AS grand_total FROM by_day),
busiest  AS (SELECT hari AS busiest_day,  avg_orders AS busiest_orders  FROM by_day ORDER BY avg_orders DESC LIMIT 1),
quietest AS (SELECT hari AS quietest_day, avg_orders AS quietest_orders FROM by_day ORDER BY avg_orders ASC  LIMIT 1),
weekend_t AS (SELECT SUM(sum_orders) AS weekend_orders FROM by_day WHERE tipe_hari = 'Weekend')
SELECT
    b.busiest_day,  b.busiest_orders,
    q.quietest_day, q.quietest_orders,
    ROUND((b.busiest_orders - q.quietest_orders) * 100.0 / NULLIF(q.quietest_orders, 0), 0) AS gap_pct,
    ROUND(w.weekend_orders * 100.0 / NULLIF(t.grand_total, 0), 1) AS weekend_share_pct,
    CASE
        WHEN ROUND(w.weekend_orders * 100.0 / NULLIF(t.grand_total, 0), 1) >= 35 THEN 'weekend_dominan'
        WHEN ROUND((b.busiest_orders - q.quietest_orders) * 100.0 / NULLIF(q.quietest_orders, 0), 0) >= 80 THEN 'gap_besar'
        ELSE 'merata'
    END AS pola
FROM busiest b, quietest q, weekend_t w, totals t

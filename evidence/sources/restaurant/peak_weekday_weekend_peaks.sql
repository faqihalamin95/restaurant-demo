WITH daily_hourly AS (
    SELECT
        order_date,
        CASE DAYNAME(order_date)
            WHEN 'Saturday' THEN 'Weekend'
            WHEN 'Sunday' THEN 'Weekend'
            ELSE 'Weekday'
        END AS tipe_hari,
        order_hour,
        SUM(total_orders) AS total_orders
    FROM main_marts.mart_peak_hours
    WHERE order_date >= (SELECT MAX(order_date) FROM main_marts.mart_peak_hours) - INTERVAL '29 days'
    GROUP BY order_date, DAYNAME(order_date), order_hour
),
hourly AS (
    SELECT tipe_hari, order_hour, ROUND(AVG(total_orders), 0) AS avg_orders
    FROM daily_hourly
    GROUP BY tipe_hari, order_hour
),
stats AS (
    SELECT tipe_hari, AVG(avg_orders) AS baseline_orders
    FROM hourly
    GROUP BY tipe_hari
),
peak_candidates AS (
    SELECT
        h.tipe_hari,
        CAST(h.order_hour AS INTEGER) AS order_hour,
        h.avg_orders,
        CAST(h.order_hour AS INTEGER) - ROW_NUMBER() OVER (PARTITION BY h.tipe_hari ORDER BY h.order_hour) AS grp
    FROM hourly h
    JOIN stats s USING (tipe_hari)
    WHERE h.avg_orders >= s.baseline_orders * 1.15
),
detected_windows AS (
    SELECT
        tipe_hari,
        MIN(order_hour) AS start_hour,
        MAX(order_hour) AS end_hour,
        arg_max(order_hour, avg_orders) AS peak_hour,
        MAX(avg_orders) AS peak_orders
    FROM peak_candidates
    GROUP BY tipe_hari, grp
),
fallback_window AS (
    SELECT tipe_hari, order_hour AS start_hour, order_hour AS end_hour, order_hour AS peak_hour, avg_orders AS peak_orders
    FROM (
        SELECT
            tipe_hari,
            CAST(order_hour AS INTEGER) AS order_hour,
            avg_orders,
            ROW_NUMBER() OVER (PARTITION BY tipe_hari ORDER BY avg_orders DESC) AS rn
        FROM hourly
    )
    WHERE rn = 1
),
peak_windows AS (
    SELECT * FROM detected_windows
    UNION ALL
    SELECT f.*
    FROM fallback_window f
    WHERE NOT EXISTS (
        SELECT 1 FROM detected_windows d WHERE d.tipe_hari = f.tipe_hari
    )
),
summary AS (
    SELECT
        tipe_hari,
        COUNT(*) AS peak_count,
        string_agg(CAST(peak_hour AS VARCHAR) || ':00', ' & ' ORDER BY start_hour) AS peak_hours,
        string_agg(
            CASE
                WHEN start_hour = end_hour THEN CAST(start_hour AS VARCHAR) || ':00'
                ELSE CAST(start_hour AS VARCHAR) || ':00-' || CAST(end_hour AS VARCHAR) || ':00'
            END,
            ', ' ORDER BY start_hour
        ) AS peak_windows
    FROM peak_windows
    GROUP BY tipe_hari
),
pivoted AS (
    SELECT
        MAX(CASE WHEN tipe_hari = 'Weekday' THEN peak_hours END) AS weekday_peak,
        MAX(CASE WHEN tipe_hari = 'Weekend' THEN peak_hours END) AS weekend_peak,
        MAX(CASE WHEN tipe_hari = 'Weekday' THEN peak_windows END) AS weekday_windows,
        MAX(CASE WHEN tipe_hari = 'Weekend' THEN peak_windows END) AS weekend_windows,
        MAX(CASE WHEN tipe_hari = 'Weekday' THEN peak_count END) AS weekday_peak_count,
        MAX(CASE WHEN tipe_hari = 'Weekend' THEN peak_count END) AS weekend_peak_count
    FROM summary
)
SELECT
    *,
    CASE
        WHEN weekday_peak = weekend_peak THEN 'mirip'
        ELSE 'berbeda'
    END AS pattern_status
FROM pivoted

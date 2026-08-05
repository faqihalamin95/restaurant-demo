WITH base_data AS (
    SELECT order_hour, day_part, SUM(total_orders) AS total_orders
    FROM main_marts.mart_peak_hours
    WHERE order_date >= (SELECT MAX(order_date) FROM main_marts.mart_peak_hours) - INTERVAL '29 days'
    GROUP BY order_hour, day_part
),
hourly AS (
    SELECT order_hour, SUM(total_orders) AS total_orders FROM base_data GROUP BY order_hour
),
daypart AS (
    SELECT day_part, SUM(total_orders) AS total_orders FROM base_data GROUP BY day_part
),
stats AS (
    SELECT ROUND(AVG(total_orders),1) AS avg_orders, MAX(total_orders) AS max_orders, SUM(total_orders) AS grand_total
    FROM hourly
),
top3 AS (
    SELECT SUM(total_orders) AS top3_total
    FROM (SELECT total_orders FROM hourly ORDER BY total_orders DESC LIMIT 3)
),
thresholded AS (
    SELECT
        h.order_hour,
        h.total_orders,
        s.avg_orders,
        ROUND(s.avg_orders * 1.15, 1) AS peak_threshold,
        CASE WHEN h.total_orders >= s.avg_orders * 1.15 THEN 1 ELSE 0 END AS is_peak
    FROM hourly h CROSS JOIN stats s
),
busiest AS (SELECT day_part AS peak_daypart FROM daypart ORDER BY total_orders DESC LIMIT 1),
peak_candidates AS (
    SELECT
        CAST(order_hour AS INTEGER) AS order_hour,
        total_orders,
        CAST(order_hour AS INTEGER) - ROW_NUMBER() OVER (ORDER BY order_hour) AS grp
    FROM thresholded
    WHERE is_peak = 1
),
detected_windows AS (
    SELECT
        MIN(order_hour) AS start_hour,
        MAX(order_hour) AS end_hour,
        arg_max(order_hour, total_orders) AS peak_hour,
        MAX(total_orders) AS peak_orders,
        SUM(total_orders) AS window_orders
    FROM peak_candidates
    GROUP BY grp
),
fallback_window AS (
    SELECT
        CAST(order_hour AS INTEGER) AS start_hour,
        CAST(order_hour AS INTEGER) AS end_hour,
        CAST(order_hour AS INTEGER) AS peak_hour,
        total_orders AS peak_orders,
        total_orders AS window_orders
    FROM hourly
    ORDER BY total_orders DESC
    LIMIT 1
),
peak_windows AS (
    SELECT * FROM detected_windows
    UNION ALL
    SELECT * FROM fallback_window
    WHERE NOT EXISTS (SELECT 1 FROM detected_windows)
),
ranked_windows AS (
    SELECT
        *,
        ROW_NUMBER() OVER (ORDER BY start_hour) AS peak_rank
    FROM peak_windows
),
window_summary AS (
    SELECT
        COUNT(*) AS peak_count,
        MIN(start_hour) AS peak_window_start,
        MAX(end_hour) AS peak_window_end,
        MAX(CASE WHEN peak_rank = 1 THEN peak_hour END) AS primary_peak_hour,
        MAX(CASE WHEN peak_rank = 2 THEN peak_hour END) AS secondary_peak_hour,
        string_agg(CAST(peak_hour AS VARCHAR) || ':00', ' & ' ORDER BY start_hour) AS peak_hours_label,
        string_agg(
            CASE
                WHEN start_hour = end_hour THEN CAST(start_hour AS VARCHAR) || ':00'
                ELSE CAST(start_hour AS VARCHAR) || ':00-' || CAST(end_hour AS VARCHAR) || ':00'
            END,
            ', ' ORDER BY start_hour
        ) AS peak_windows_label
    FROM ranked_windows
)
SELECT
    ROUND(stats.max_orders * 100.0 / NULLIF(stats.grand_total, 0), 1) AS peak_pct,
    ROUND(top3.top3_total * 100.0 / NULLIF(stats.grand_total, 0), 1) AS peak_share_pct,
    ROUND(stats.max_orders * 1.0   / NULLIF(stats.avg_orders,  0), 2) AS demand_surge,
    ws.peak_window_start,
    ws.peak_window_end,
    b.peak_daypart,
    ws.primary_peak_hour AS lunch_hour,
    ws.secondary_peak_hour AS dinner_hour,
    ws.peak_count,
    ws.peak_hours_label,
    ws.peak_windows_label,
    ROUND(stats.avg_orders * 1.15, 1) AS peak_threshold,
    CASE WHEN ws.peak_count = 2 THEN 1 ELSE 0 END AS is_bimodal,
    CASE
        WHEN ws.peak_count = 1 THEN 'single'
        WHEN ws.peak_count = 2 THEN 'dual'
        ELSE 'multi'
    END AS peak_pattern,
    CASE
        WHEN ROUND(top3.top3_total * 100.0 / NULLIF(stats.grand_total, 0), 1) > 65
          OR ROUND(stats.max_orders * 1.0   / NULLIF(stats.avg_orders,  0), 2) > 2.5 THEN 'kritis'
        WHEN ROUND(top3.top3_total * 100.0 / NULLIF(stats.grand_total, 0), 1) > 50
          OR ROUND(stats.max_orders * 1.0   / NULLIF(stats.avg_orders,  0), 2) > 1.5 THEN 'waspada'
        ELSE 'normal'
    END AS severity
FROM stats, top3, busiest b, window_summary ws

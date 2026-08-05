WITH 
-- 1. JAM SIBUK PER CABANG
daily_hourly AS (
    SELECT
        branch_name,
        order_date,
        CASE DAYNAME(order_date) WHEN 'Saturday' THEN 'Weekend' WHEN 'Sunday' THEN 'Weekend' ELSE 'Weekday' END AS tipe_hari,
        order_hour,
        SUM(total_orders) AS total_orders
    FROM main_marts.mart_peak_hours
    WHERE order_date >= (SELECT MAX(order_date) FROM main_marts.mart_peak_hours) - INTERVAL '29 days'
    GROUP BY branch_name, order_date, DAYNAME(order_date), order_hour
),
hourly AS (
    SELECT branch_name, tipe_hari, order_hour, ROUND(AVG(total_orders), 0) AS avg_orders
    FROM daily_hourly GROUP BY branch_name, tipe_hari, order_hour
),
stats AS (
    SELECT branch_name, tipe_hari, AVG(avg_orders) AS baseline_orders
    FROM hourly GROUP BY branch_name, tipe_hari
),
peak_candidates AS (
    SELECT
        h.branch_name, h.tipe_hari, CAST(h.order_hour AS INTEGER) AS order_hour, h.avg_orders,
        CAST(h.order_hour AS INTEGER) - ROW_NUMBER() OVER (PARTITION BY h.branch_name, h.tipe_hari ORDER BY h.order_hour) AS grp
    FROM hourly h JOIN stats s USING (branch_name, tipe_hari)
    WHERE h.avg_orders >= s.baseline_orders * 1.15
),
detected_windows AS (
    SELECT branch_name, tipe_hari, arg_max(order_hour, avg_orders) AS peak_hour, MIN(order_hour) AS start_hour, MAX(order_hour) AS end_hour
    FROM peak_candidates GROUP BY branch_name, tipe_hari, grp
),
fallback_window AS (
    SELECT branch_name, tipe_hari, order_hour AS peak_hour, order_hour AS start_hour, order_hour AS end_hour
    FROM (
        SELECT branch_name, tipe_hari, CAST(order_hour AS INTEGER) AS order_hour, ROW_NUMBER() OVER (PARTITION BY branch_name, tipe_hari ORDER BY avg_orders DESC) AS rn
        FROM hourly
    ) WHERE rn = 1
),
peak_windows AS (
    SELECT * FROM detected_windows
    UNION ALL
    SELECT f.* FROM fallback_window f
    WHERE NOT EXISTS (SELECT 1 FROM detected_windows d WHERE d.branch_name = f.branch_name AND d.tipe_hari = f.tipe_hari)
),
jam_summary AS (
    SELECT
        branch_name,
        MAX(CASE WHEN tipe_hari = 'Weekday' THEN peak_hours END) AS weekday_peak,
        MAX(CASE WHEN tipe_hari = 'Weekend' THEN peak_hours END) AS weekend_peak,
        MAX(CASE WHEN tipe_hari = 'Weekday' THEN peak_count END) AS weekday_peak_count,
        MAX(CASE WHEN tipe_hari = 'Weekend' THEN peak_count END) AS weekend_peak_count
    FROM (
        SELECT branch_name, tipe_hari, COUNT(*) AS peak_count, string_agg(CAST(peak_hour AS VARCHAR) || ':00', ' & ' ORDER BY start_hour) AS peak_hours
        FROM peak_windows GROUP BY branch_name, tipe_hari
    ) GROUP BY branch_name
),

-- 2. HARI RAMAI PER CABANG
daily AS (
    SELECT branch_name, order_date, DAYNAME(order_date) AS day_name, SUM(total_orders) AS daily_orders
    FROM main_marts.mart_peak_hours
    WHERE order_date >= (SELECT MAX(order_date) FROM main_marts.mart_peak_hours) - INTERVAL '29 days'
    GROUP BY branch_name, order_date, DAYNAME(order_date)
),
hari_avg AS (
    SELECT branch_name, day_name, AVG(daily_orders) AS avg_orders
    FROM daily GROUP BY branch_name, day_name
),
hari_busiest AS (
    SELECT branch_name, day_name AS busiest_day
    FROM (
        SELECT branch_name, day_name, ROW_NUMBER() OVER (PARTITION BY branch_name ORDER BY avg_orders DESC) as rn
        FROM hari_avg
    ) WHERE rn = 1
),

-- 3. VOLATILITAS PER CABANG
day_baseline AS (
    SELECT branch_name, day_name, AVG(daily_orders) AS expected_orders
    FROM daily GROUP BY branch_name, day_name
),
scored AS (
    SELECT d.branch_name, ROUND((d.daily_orders - b.expected_orders) * 100.0 / NULLIF(b.expected_orders, 0), 1) AS deviation_pct
    FROM daily d JOIN day_baseline b USING (branch_name, day_name)
),
volatility_branch AS (
    SELECT branch_name, ROUND(AVG(ABS(deviation_pct)), 1) AS cv_pct
    FROM scored GROUP BY branch_name
),

-- 4. MUSIMAN PER CABANG
quarterly AS (
    SELECT branch_name, YEAR(order_date) AS tahun, QUARTER(order_date) AS kuartal, SUM(total_orders) AS q_orders
    FROM main_marts.mart_peak_hours
    WHERE order_date >= (SELECT MAX(order_date) FROM main_marts.mart_peak_hours) - INTERVAL '365 days'
    GROUP BY branch_name, YEAR(order_date), QUARTER(order_date)
),
q_avg AS (
    SELECT branch_name, kuartal, AVG(q_orders) AS avg_q_orders
    FROM quarterly GROUP BY branch_name, kuartal
),
season_branch AS (
    SELECT branch_name, kuartal AS strongest_q
    FROM (
        SELECT branch_name, kuartal, ROW_NUMBER() OVER (PARTITION BY branch_name ORDER BY avg_q_orders DESC) as rn
        FROM q_avg
    ) WHERE rn = 1
)

SELECT 
    j.branch_name,
    j.weekday_peak,
    j.weekend_peak,
    CASE WHEN j.weekday_peak = j.weekend_peak THEN 'Mirip' ELSE 'Berbeda' END AS pola,
    CASE 
        WHEN j.weekday_peak_count > 1 AND j.weekend_peak_count = 1 THEN 'Weekday split shift; weekend fokus satu wave.'
        WHEN j.weekday_peak_count = 1 AND j.weekend_peak_count > 1 THEN 'Weekend perlu bbrp wave; weekday cukup satu window.'
        WHEN j.weekday_peak != j.weekend_peak THEN 'Buat template roster weekday/weekend terpisah.'
        ELSE 'SOP jam sibuk relatif seragam.'
    END AS rekomendasi,
    CASE h.busiest_day
        WHEN 'Monday' THEN 'Senin' WHEN 'Tuesday' THEN 'Selasa' WHEN 'Wednesday' THEN 'Rabu'
        WHEN 'Thursday' THEN 'Kamis' WHEN 'Friday' THEN 'Jumat'
        WHEN 'Saturday' THEN 'Sabtu' WHEN 'Sunday' THEN 'Minggu'
    END AS hari_puncak,
    v.cv_pct AS volatilitas,
    s.strongest_q AS puncak_musiman
FROM jam_summary j
LEFT JOIN hari_busiest h ON j.branch_name = h.branch_name
LEFT JOIN volatility_branch v ON j.branch_name = v.branch_name
LEFT JOIN season_branch s ON j.branch_name = s.branch_name
ORDER BY j.branch_name

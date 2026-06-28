-- Cache-breaker comment: force reload 2026-06-22
WITH max_n AS (SELECT MAX(metric_date) AS d FROM main_marts.mart_daily_net_revenue),
max_d AS (SELECT MAX(order_date) AS d FROM main_marts.mart_daily_revenue),
rev_stats AS (
    SELECT branch_name,
        SUM(CASE WHEN order_date >= d - INTERVAL '29 days' THEN total_revenue ELSE 0 END) AS active_revenue,
        SUM(CASE WHEN order_date >= d - INTERVAL '29 days' THEN total_orders ELSE 0 END) AS active_orders,
        SUM(CASE WHEN order_date >= d - INTERVAL '89 days' THEN total_orders ELSE 0 END) AS baseline_orders_90d
    FROM main_marts.mart_daily_revenue CROSS JOIN max_d
    GROUP BY branch_name
),
active_rev AS (
    SELECT branch_name,
        active_revenue,
        active_orders,
        ROUND(active_revenue / NULLIF(active_orders, 0), 0) AS active_aov,
        -- Bandingkan rata-rata order harian aktif (30h) vs baseline 90h
        ROUND(((active_orders / 30.0) - (baseline_orders_90d / 90.0)) / NULLIF(baseline_orders_90d / 90.0, 0) * 100, 1) AS baseline_change_pct
    FROM rev_stats
),
active_net AS (
    SELECT branch_name,
        ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS active_margin_pct
    FROM main_marts.mart_daily_net_revenue CROSS JOIN max_n
    WHERE metric_date >= d - INTERVAL '29 days'
    GROUP BY branch_name
),
recent_net AS (
    SELECT branch_name,
        ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS recent_margin_pct
    FROM main_marts.mart_daily_net_revenue CROSS JOIN max_n
    WHERE metric_date >= d - INTERVAL '89 days'
    GROUP BY branch_name
),
historical_net AS (
    SELECT branch_name,
        ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS historical_margin_pct
    FROM main_marts.mart_daily_net_revenue
    GROUP BY branch_name
),
classified AS (
    SELECT
        r.branch_name,
        r.active_revenue,
        r.active_orders,
        r.active_aov,
        r.baseline_change_pct,
        a.active_margin_pct,
        n.recent_margin_pct,
        h.historical_margin_pct,
        CASE
            WHEN a.active_margin_pct >= 15 AND n.recent_margin_pct >= 15 THEN 'Sehat'
            WHEN a.active_margin_pct >= 10 AND a.active_margin_pct < 15 AND n.recent_margin_pct >= 15 THEN 'Waspada'
            WHEN a.active_margin_pct < 10 AND n.recent_margin_pct >= 15 THEN 'Early Warning'
            WHEN a.active_margin_pct >= 15 AND n.recent_margin_pct < 15 THEN 'Recovery'
            WHEN a.active_margin_pct >= 10 AND a.active_margin_pct < 15 AND n.recent_margin_pct < 10 THEN 'Membaik'
            WHEN a.active_margin_pct >= 10 AND a.active_margin_pct < 15 AND n.recent_margin_pct >= 10 AND n.recent_margin_pct < 15 THEN 'Stabil Rendah'
            WHEN a.active_margin_pct < 10 AND n.recent_margin_pct >= 10 THEN 'Turnaround'
            WHEN a.active_margin_pct < 10 AND n.recent_margin_pct < 10 THEN 'Turnaround'
            ELSE 'Waspada'
        END AS health_status
    FROM active_rev r
    LEFT JOIN active_net a ON r.branch_name = a.branch_name
    LEFT JOIN recent_net n ON r.branch_name = n.branch_name
    LEFT JOIN historical_net h ON r.branch_name = h.branch_name
)
SELECT *,
    CASE health_status
        WHEN 'Sehat' THEN 'Margin 30H dan 90H sama-sama kuat. Jadikan benchmark operasional.'
        WHEN 'Waspada' THEN 'Margin 30H mulai melunak, tapi baseline 90H masih sehat. Pantau lebih dekat.'
        WHEN 'Early Warning' THEN 'Margin 30H turun tajam meski baseline 90H masih sehat. Audit 30 hari terakhir.'
        WHEN 'Recovery' THEN 'Margin 30H sudah sehat setelah baseline 90H lemah. Pertahankan momentum ini.'
        WHEN 'Membaik' THEN 'Margin 30H membaik dari baseline 90H yang lemah, tapi belum sehat. Lanjutkan perbaikan.'
        WHEN 'Stabil Rendah' THEN 'Margin 30H dan 90H sama-sama sedang. Bukan krisis, tapi belum optimal.'
        WHEN 'Turnaround' THEN 'Margin 30H dan 90H sama-sama lemah. Perlu pembenahan struktural.'
        ELSE 'Pantau perkembangan margin di beberapa hari ke depan.'
    END AS diagnosis,
    CASE health_status
        WHEN 'Sehat' THEN 'Analisis Lanjutan'
        WHEN 'Waspada' THEN 'Analisis Lanjutan'
        WHEN 'Early Warning' THEN 'Analisis Lanjutan / Deep Dive'
        WHEN 'Recovery' THEN 'Deep Dive'
        WHEN 'Membaik' THEN 'Analisis Lanjutan / Deep Dive'
        WHEN 'Stabil Rendah' THEN 'Analisis Lanjutan'
        WHEN 'Turnaround' THEN 'Pusat Aksi / Deep Dive'
        ELSE 'Ringkasan'
    END AS recommended_next_page,
    CASE health_status
        WHEN 'Turnaround' THEN 1
        WHEN 'Early Warning' THEN 2
        WHEN 'Stabil Rendah' THEN 3
        WHEN 'Membaik' THEN 4
        WHEN 'Waspada' THEN 5
        WHEN 'Recovery' THEN 6
        WHEN 'Sehat' THEN 7
        ELSE 7
    END AS sort_priority
FROM classified
ORDER BY sort_priority ASC, active_margin_pct ASC

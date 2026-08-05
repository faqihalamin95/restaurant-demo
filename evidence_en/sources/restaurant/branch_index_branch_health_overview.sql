WITH max_d AS (SELECT MAX(order_date) AS d FROM main_marts.mart_daily_revenue),
max_n AS (SELECT MAX(metric_date) AS d FROM main_marts.mart_daily_net_revenue),
y_rev AS (
    SELECT branch_name, SUM(total_revenue) AS revenue,
        ROUND(AVG(pct_change_vs_sdow_avg) * 100, 1) AS avg_pct
    FROM main_marts.mart_daily_revenue CROSS JOIN max_d
    WHERE order_date = d
    GROUP BY branch_name
),
y_net AS (
    SELECT branch_name, SUM(gross_revenue) AS gross, SUM(net_revenue) AS net,
        ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS margin
    FROM main_marts.mart_daily_net_revenue CROSS JOIN max_n
    WHERE metric_date = d
    GROUP BY branch_name
),
w_rev AS (
    SELECT branch_name, SUM(total_revenue) AS revenue,
        ROUND(AVG(pct_change_vs_sdow_avg) * 100, 1) AS avg_pct
    FROM main_marts.mart_daily_revenue CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '6 days'
    GROUP BY branch_name
),
w_net AS (
    SELECT branch_name, SUM(gross_revenue) AS gross, SUM(net_revenue) AS net,
        ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS margin
    FROM main_marts.mart_daily_net_revenue CROSS JOIN max_n
    WHERE metric_date >= d - INTERVAL '6 days'
    GROUP BY branch_name
),
m_rev AS (
    SELECT branch_name, SUM(total_revenue) AS revenue,
        ROUND(AVG(pct_change_vs_sdow_avg) * 100, 1) AS avg_pct
    FROM main_marts.mart_daily_revenue CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '29 days'
    GROUP BY branch_name
),
m_net AS (
    SELECT branch_name, SUM(gross_revenue) AS gross, SUM(net_revenue) AS net,
        ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS margin
    FROM main_marts.mart_daily_net_revenue CROSS JOIN max_n
    WHERE metric_date >= d - INTERVAL '29 days'
    GROUP BY branch_name
),
raw AS (
    SELECT
        (SELECT ROUND(SUM(net) / NULLIF(SUM(gross), 0) * 100, 1) FROM y_net) AS margin_y,
        (SELECT COUNT(*) FROM y_net WHERE margin < 10) AS critical_y,
        (SELECT COUNT(*) FROM y_rev WHERE avg_pct < -10) AS declining_y,
        (SELECT ROUND((MAX(revenue) - MIN(revenue)) / NULLIF(MIN(revenue), 0) * 100, 1) FROM y_rev) AS gap_y,
        (SELECT MAX(branch_name) FROM y_rev WHERE revenue = (SELECT MAX(revenue) FROM y_rev)) AS top_branch_y,
        (SELECT MAX(branch_name) FROM y_rev WHERE revenue = (SELECT MIN(revenue) FROM y_rev)) AS bottom_branch_y,

        (SELECT ROUND(SUM(net) / NULLIF(SUM(gross), 0) * 100, 1) FROM w_net) AS margin_7d,
        (SELECT COUNT(*) FROM w_net WHERE margin < 10) AS critical_7d,
        (SELECT COUNT(*) FROM w_rev WHERE avg_pct < -10) AS declining_7d,
        (SELECT ROUND((MAX(revenue) - MIN(revenue)) / NULLIF(MIN(revenue), 0) * 100, 1) FROM w_rev) AS gap_7d,
        (SELECT MAX(branch_name) FROM w_rev WHERE revenue = (SELECT MAX(revenue) FROM w_rev)) AS top_branch_7d,
        (SELECT MAX(branch_name) FROM w_rev WHERE revenue = (SELECT MIN(revenue) FROM w_rev)) AS bottom_branch_7d,

        (SELECT ROUND(SUM(net) / NULLIF(SUM(gross), 0) * 100, 1) FROM m_net) AS margin_30d,
        (SELECT COUNT(*) FROM m_net WHERE margin < 10) AS critical_30d,
        (SELECT COUNT(*) FROM m_rev WHERE avg_pct < -10) AS declining_30d,
        (SELECT ROUND((MAX(revenue) - MIN(revenue)) / NULLIF(MIN(revenue), 0) * 100, 1) FROM m_rev) AS gap_30d,
        (SELECT MAX(branch_name) FROM m_rev WHERE revenue = (SELECT MAX(revenue) FROM m_rev)) AS top_branch_30d,
        (SELECT MAX(branch_name) FROM m_rev WHERE revenue = (SELECT MIN(revenue) FROM m_rev)) AS bottom_branch_30d
)
SELECT *,
    CASE
        WHEN critical_y > 0 OR margin_y < 5 OR gap_y > 120 THEN 'Kritis'
        WHEN declining_y > 0 OR margin_y < 10 OR gap_y > 70 THEN 'Waspada'
        ELSE 'Sehat'
    END AS status_y,
    CASE
        WHEN critical_7d > 0 OR margin_7d < 5 OR gap_7d > 120 THEN 'Kritis'
        WHEN declining_7d > 0 OR margin_7d < 10 OR gap_7d > 70 THEN 'Waspada'
        ELSE 'Sehat'
    END AS status_7d,
    CASE
        WHEN critical_30d > 0 OR margin_30d < 5 OR gap_30d > 120 THEN 'Kritis'
        WHEN declining_30d > 0 OR margin_30d < 10 OR gap_30d > 70 THEN 'Waspada'
        ELSE 'Sehat'
    END AS status_30d,
    CASE
        WHEN critical_y > 0 THEN 'margin'
        WHEN declining_y > 0 THEN 'permintaan'
        WHEN gap_y > 70 THEN 'konsentrasi'
        ELSE 'stabil'
    END AS fokus_y,
    CASE
        WHEN critical_7d > 0 THEN 'margin'
        WHEN declining_7d > 0 THEN 'permintaan'
        WHEN gap_7d > 70 THEN 'konsentrasi'
        ELSE 'stabil'
    END AS fokus_7d,
    CASE
        WHEN critical_30d > 0 THEN 'margin'
        WHEN declining_30d > 0 THEN 'permintaan'
        WHEN gap_30d > 70 THEN 'konsentrasi'
        ELSE 'stabil'
    END AS fokus_30d,
    GREATEST(0, LEAST(100, ROUND(
        (100 - GREATEST(0, 15 - margin_y) * 4.5)
        - (critical_y * 18)
        - (declining_y * 8)
        - (LEAST(gap_y, 140) / 140 * 14)
    , 0))) AS score_y,
    GREATEST(0, LEAST(100, ROUND(
        (100 - GREATEST(0, 15 - margin_7d) * 4.5)
        - (critical_7d * 18)
        - (declining_7d * 8)
        - (LEAST(gap_7d, 140) / 140 * 14)
    , 0))) AS score_7d,
    GREATEST(0, LEAST(100, ROUND(
        (100 - GREATEST(0, 15 - margin_30d) * 4.5)
        - (critical_30d * 18)
        - (declining_30d * 8)
        - (LEAST(gap_30d, 140) / 140 * 14)
    , 0))) AS score_30d
FROM raw

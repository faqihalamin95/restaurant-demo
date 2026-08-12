WITH branches AS (
    SELECT DISTINCT branch_name FROM main_marts.mart_daily_revenue
),
max_d AS (SELECT MAX(order_date) AS d FROM main_marts.mart_daily_revenue),
max_nr AS (SELECT MAX(metric_date) AS d FROM main_marts.mart_daily_net_revenue),
rev AS (
    SELECT
        branch_name,
        SUM(CASE WHEN order_date = (SELECT d FROM max_d) THEN total_revenue END) AS rev_yesterday,
        SUM(CASE WHEN order_date >= (SELECT d FROM max_d) - INTERVAL '6 days' THEN total_revenue END) AS rev_7d,
        SUM(CASE WHEN order_date >= (SELECT d FROM max_d) - INTERVAL '29 days' THEN total_revenue END) AS rev_30d,
        SUM(CASE WHEN order_date >= (SELECT d FROM max_d) - INTERVAL '89 days' THEN total_revenue END) AS rev_90d,
        SUM(CASE WHEN order_date >= DATE_TRUNC('month', (SELECT d FROM max_d)) AND order_date <= (SELECT d FROM max_d) THEN total_revenue END) AS rev_mtd,
        SUM(CASE WHEN order_date = (SELECT d FROM max_d) - INTERVAL '7 days' THEN total_revenue END) AS rev_sdow_yesterday,
        SUM(CASE WHEN order_date >= (SELECT d FROM max_d) - INTERVAL '13 days' AND order_date < (SELECT d FROM max_d) - INTERVAL '6 days' THEN total_revenue END) AS rev_prev7d,
        SUM(CASE WHEN order_date >= (SELECT d FROM max_d) - INTERVAL '59 days' AND order_date < (SELECT d FROM max_d) - INTERVAL '29 days' THEN total_revenue END) AS rev_prev30d,
        SUM(CASE WHEN order_date >= (SELECT d FROM max_d) - INTERVAL '179 days' AND order_date < (SELECT d FROM max_d) - INTERVAL '89 days' THEN total_revenue END) AS rev_prev90d,
        SUM(CASE WHEN order_date >= DATE_TRUNC('month', (SELECT d FROM max_d) - INTERVAL '1 month') AND order_date <= ((SELECT d FROM max_d) - INTERVAL '1 month') THEN total_revenue END) AS rev_prev_mtd
    FROM main_marts.mart_daily_revenue
    GROUP BY branch_name
),
ord AS (
    SELECT
        branch_name,
        SUM(CASE WHEN order_date = (SELECT d FROM max_d) THEN total_orders END) AS ord_yesterday,
        SUM(CASE WHEN order_date >= (SELECT d FROM max_d) - INTERVAL '6 days' THEN total_orders END) AS ord_7d,
        SUM(CASE WHEN order_date >= (SELECT d FROM max_d) - INTERVAL '29 days' THEN total_orders END) AS ord_30d,
        SUM(CASE WHEN order_date >= (SELECT d FROM max_d) - INTERVAL '89 days' THEN total_orders END) AS ord_90d,
        SUM(CASE WHEN order_date >= DATE_TRUNC('month', (SELECT d FROM max_d)) AND order_date <= (SELECT d FROM max_d) THEN total_orders END) AS ord_mtd,
        SUM(CASE WHEN order_date = (SELECT d FROM max_d) - INTERVAL '7 days' THEN total_orders END) AS ord_sdow_yesterday,
        SUM(CASE WHEN order_date >= (SELECT d FROM max_d) - INTERVAL '13 days' AND order_date < (SELECT d FROM max_d) - INTERVAL '6 days' THEN total_orders END) AS ord_prev7d,
        SUM(CASE WHEN order_date >= (SELECT d FROM max_d) - INTERVAL '59 days' AND order_date < (SELECT d FROM max_d) - INTERVAL '29 days' THEN total_orders END) AS ord_prev30d,
        SUM(CASE WHEN order_date >= (SELECT d FROM max_d) - INTERVAL '179 days' AND order_date < (SELECT d FROM max_d) - INTERVAL '89 days' THEN total_orders END) AS ord_prev90d,
        SUM(CASE WHEN order_date >= DATE_TRUNC('month', (SELECT d FROM max_d) - INTERVAL '1 month') AND order_date <= ((SELECT d FROM max_d) - INTERVAL '1 month') THEN total_orders END) AS ord_prev_mtd
    FROM main_marts.mart_daily_revenue
    GROUP BY branch_name
),
net AS (
    SELECT
        branch_name,
        SUM(CASE WHEN metric_date = (SELECT d FROM max_nr) THEN net_revenue END) AS net_yesterday,
        SUM(CASE WHEN metric_date >= (SELECT d FROM max_nr) - INTERVAL '6 days' THEN net_revenue END) AS net_7d,
        SUM(CASE WHEN metric_date >= (SELECT d FROM max_nr) - INTERVAL '29 days' THEN net_revenue END) AS net_30d,
        SUM(CASE WHEN metric_date >= (SELECT d FROM max_nr) - INTERVAL '89 days' THEN net_revenue END) AS net_90d,
        SUM(CASE WHEN metric_date >= DATE_TRUNC('month', (SELECT d FROM max_nr)) AND metric_date <= (SELECT d FROM max_nr) THEN net_revenue END) AS net_mtd,
        SUM(CASE WHEN metric_date = (SELECT d FROM max_nr) THEN gross_revenue END) AS gross_yesterday,
        SUM(CASE WHEN metric_date >= (SELECT d FROM max_nr) - INTERVAL '6 days' THEN gross_revenue END) AS gross_7d,
        SUM(CASE WHEN metric_date >= (SELECT d FROM max_nr) - INTERVAL '29 days' THEN gross_revenue END) AS gross_30d,
        SUM(CASE WHEN metric_date >= (SELECT d FROM max_nr) - INTERVAL '89 days' THEN gross_revenue END) AS gross_90d,
        SUM(CASE WHEN metric_date >= DATE_TRUNC('month', (SELECT d FROM max_nr)) AND metric_date <= (SELECT d FROM max_nr) THEN gross_revenue END) AS gross_mtd,
        SUM(CASE WHEN metric_date >= (SELECT d FROM max_nr) - INTERVAL '13 days' AND metric_date < (SELECT d FROM max_nr) - INTERVAL '6 days' THEN net_revenue END) AS net_prev7d,
        SUM(CASE WHEN metric_date >= (SELECT d FROM max_nr) - INTERVAL '13 days' AND metric_date < (SELECT d FROM max_nr) - INTERVAL '6 days' THEN gross_revenue END) AS gross_prev7d,
        SUM(CASE WHEN metric_date >= (SELECT d FROM max_nr) - INTERVAL '59 days' AND metric_date < (SELECT d FROM max_nr) - INTERVAL '29 days' THEN net_revenue END) AS net_prev30d,
        SUM(CASE WHEN metric_date >= (SELECT d FROM max_nr) - INTERVAL '59 days' AND metric_date < (SELECT d FROM max_nr) - INTERVAL '29 days' THEN gross_revenue END) AS gross_prev30d,
        SUM(CASE WHEN metric_date >= (SELECT d FROM max_nr) - INTERVAL '179 days' AND metric_date < (SELECT d FROM max_nr) - INTERVAL '89 days' THEN net_revenue END) AS net_prev90d,
        SUM(CASE WHEN metric_date >= (SELECT d FROM max_nr) - INTERVAL '179 days' AND metric_date < (SELECT d FROM max_nr) - INTERVAL '89 days' THEN gross_revenue END) AS gross_prev90d,
        SUM(CASE WHEN metric_date >= DATE_TRUNC('month', (SELECT d FROM max_nr) - INTERVAL '1 month') AND metric_date <= ((SELECT d FROM max_nr) - INTERVAL '1 month') THEN net_revenue END) AS net_prev_mtd,
        SUM(CASE WHEN metric_date >= DATE_TRUNC('month', (SELECT d FROM max_nr) - INTERVAL '1 month') AND metric_date <= ((SELECT d FROM max_nr) - INTERVAL '1 month') THEN gross_revenue END) AS gross_prev_mtd
    FROM main_marts.mart_daily_net_revenue
    GROUP BY branch_name
),
hist AS (
    SELECT
        branch_name,
        SUM(gross_revenue) AS gross_historical,
        SUM(net_revenue) AS net_historical,
        MIN(metric_date) AS first_metric_date
    FROM main_marts.mart_daily_net_revenue
    GROUP BY branch_name
)
SELECT
    branches.branch_name AS selected_branch,
    rev_yesterday, rev_7d, rev_30d, rev_90d, rev_mtd, rev_sdow_yesterday, rev_prev7d, rev_prev30d,
    ROUND((rev_7d - rev_prev7d) / NULLIF(rev_prev7d, 0) * 100, 1) AS rev_pct_7d,
    ROUND((rev_30d - rev_prev30d) / NULLIF(rev_prev30d, 0) * 100, 1) AS rev_pct_30d,
    ROUND((rev_90d - rev_prev90d) / NULLIF(rev_prev90d, 0) * 100, 1) AS rev_pct_90d,
    ROUND((rev_mtd - rev_prev_mtd) / NULLIF(rev_prev_mtd, 0) * 100, 1) AS rev_pct_mtd,
    ord_yesterday, ord_7d, ord_30d, ord_90d, ord_mtd, ord_sdow_yesterday, ord_prev7d, ord_prev30d,
    ROUND(rev_yesterday / NULLIF(ord_yesterday, 0), 0) AS aov_yesterday,
    ROUND(rev_7d / NULLIF(ord_7d, 0), 0) AS aov_7d,
    ROUND(rev_30d / NULLIF(ord_30d, 0), 0) AS aov_30d,
    ROUND(rev_90d / NULLIF(ord_90d, 0), 0) AS aov_90d,
    ROUND(rev_mtd / NULLIF(ord_mtd, 0), 0) AS aov_mtd,
    ROUND(rev_sdow_yesterday / NULLIF(ord_sdow_yesterday, 0), 0) AS aov_sdow_yesterday,
    net_yesterday, net_7d, net_30d, net_90d, net_mtd,
    gross_yesterday, gross_7d, gross_30d, gross_90d, gross_mtd,
    ROUND(net_yesterday / NULLIF(gross_yesterday, 0) * 100, 1) AS margin_yesterday,
    ROUND(net_7d / NULLIF(gross_7d, 0) * 100, 1) AS margin_7d,
    ROUND(net_30d / NULLIF(gross_30d, 0) * 100, 1) AS margin_30d,
    ROUND(net_90d / NULLIF(gross_90d, 0) * 100, 1) AS margin_90d,
    ROUND(net_mtd / NULLIF(gross_mtd, 0) * 100, 1) AS margin_mtd,
    ROUND(net_historical / NULLIF(gross_historical, 0) * 100, 1) AS margin_historical,
    ROUND(net_prev7d / NULLIF(gross_prev7d, 0) * 100, 1) AS margin_prev7d,
    ROUND(net_prev30d / NULLIF(gross_prev30d, 0) * 100, 1) AS margin_prev30d,
    ROUND(net_prev90d / NULLIF(gross_prev90d, 0) * 100, 1) AS margin_prev90d,
    ROUND(net_prev_mtd / NULLIF(gross_prev_mtd, 0) * 100, 1) AS margin_prev_mtd,
    first_metric_date
FROM branches
LEFT JOIN rev ON branches.branch_name = rev.branch_name
LEFT JOIN ord ON branches.branch_name = ord.branch_name
LEFT JOIN net ON branches.branch_name = net.branch_name
LEFT JOIN hist ON branches.branch_name = hist.branch_name
ORDER BY selected_branch

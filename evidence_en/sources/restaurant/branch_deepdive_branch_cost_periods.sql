WITH max_d AS (SELECT MAX(metric_date) AS d FROM main_marts.mart_daily_net_revenue)
SELECT
    branch_name,
    SUM(CASE WHEN metric_date >= DATE_TRUNC('month', d) AND metric_date <= d THEN inventory_usage_cost END) AS ingr_mtd,
    SUM(CASE WHEN metric_date >= DATE_TRUNC('month', d) AND metric_date <= d THEN labor_total_cost END) AS labor_mtd,
    SUM(CASE WHEN metric_date >= DATE_TRUNC('month', d) AND metric_date <= d THEN operational_total_cost END) AS overhead_mtd,
    SUM(CASE WHEN metric_date >= DATE_TRUNC('month', d) AND metric_date <= d THEN gross_revenue END) AS gross_mtd,
    SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN inventory_usage_cost END) AS ingr_30d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN labor_total_cost END) AS labor_30d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN operational_total_cost END) AS overhead_30d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN gross_revenue END) AS gross_30d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN inventory_usage_cost END) AS ingr_90d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN labor_total_cost END) AS labor_90d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN operational_total_cost END) AS overhead_90d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN gross_revenue END) AS gross_90d
FROM main_marts.mart_daily_net_revenue CROSS JOIN max_d
GROUP BY branch_name
ORDER BY branch_name

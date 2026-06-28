WITH fin_quarter AS (
    SELECT
        YEAR(metric_date) AS tahun,
        CEIL(MONTH(metric_date) / 3.0) AS qnum,
        CAST(YEAR(metric_date) AS VARCHAR) || ' Q' || CAST(CAST(CEIL(MONTH(metric_date) / 3.0) AS INTEGER) AS VARCHAR) AS quarter_label,
        YEAR(metric_date) * 10 + CEIL(MONTH(metric_date) / 3.0) AS qsort,
        SUM(gross_revenue) AS gross,
        SUM(net_revenue) AS net,
        ROUND(SUM(net_revenue) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS margin_pct,
        SUM(inventory_usage_cost + labor_total_cost + operational_total_cost) AS total_biaya,
        ROUND(SUM(inventory_usage_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS bahan_pct,
        ROUND(SUM(labor_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS sdm_pct,
        ROUND(SUM(operational_total_cost) / NULLIF(SUM(gross_revenue), 0) * 100, 1) AS ops_pct
    FROM main_marts.mart_daily_net_revenue
    GROUP BY 1, 2, 3, 4
)
SELECT
    quarter_label, gross, net, margin_pct, total_biaya, bahan_pct, sdm_pct, ops_pct,
    LAG(net) OVER (ORDER BY qsort) AS net_prev_q,
    LAG(margin_pct) OVER (ORDER BY qsort) AS margin_prev_q,
    ROUND(margin_pct - LAG(margin_pct) OVER (ORDER BY qsort), 1) AS delta_margin_q,
    ROUND((net - LAG(net) OVER (ORDER BY qsort)) / NULLIF(LAG(net) OVER (ORDER BY qsort), 0) * 100, 1) AS pct_change_net_q
FROM fin_quarter
ORDER BY qsort DESC

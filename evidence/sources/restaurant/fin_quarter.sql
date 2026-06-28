SELECT * FROM (
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
    ORDER BY qsort DESC  -- ambil 8 terbaru
    LIMIT 8
) ORDER BY qsort ASC    -- lalu urutkan untuk chart

WITH max_d AS (SELECT MAX(metric_date)::DATE AS d FROM main_marts.mart_daily_net_revenue)
SELECT
    SUM(CASE WHEN metric_date = d THEN gross_revenue ELSE 0 END) AS gross_yesterday,
    SUM(CASE WHEN metric_date = d THEN net_revenue ELSE 0 END) AS net_yesterday,
    ROUND(
        SUM(CASE WHEN metric_date = d THEN net_revenue ELSE 0 END)
        / NULLIF(SUM(CASE WHEN metric_date = d THEN gross_revenue ELSE 0 END), 0) * 100
    , 1) AS margin_yesterday,
    SUM(CASE WHEN metric_date = d THEN inventory_usage_cost + labor_total_cost + operational_total_cost ELSE 0 END) AS biaya_yesterday,
    
    SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END) AS gross_30d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN net_revenue ELSE 0 END) AS net_30d,
    ROUND(
        SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN net_revenue ELSE 0 END)
        / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100
    , 1) AS margin_30d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN inventory_usage_cost + labor_total_cost + operational_total_cost ELSE 0 END) AS biaya_30d,
    
    SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END) AS gross_prev30d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN net_revenue ELSE 0 END) AS net_prev30d,
    ROUND(
        SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN net_revenue ELSE 0 END)
        / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100
    , 1) AS margin_prev30d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN inventory_usage_cost + labor_total_cost + operational_total_cost ELSE 0 END) AS biaya_prev30d,
    
    ROUND(
        ROUND(
            SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN net_revenue ELSE 0 END)
            / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100
        , 1)
        -
        ROUND(
            SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN net_revenue ELSE 0 END)
            / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100
        , 1)
    , 1) AS delta_margin_30d,
    ROUND(
        (SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END)
        - SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END))
        / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN gross_revenue ELSE 0 END), 0) * 100
    , 1) AS pct_change_gross_30d,
    ROUND(
        (SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN net_revenue ELSE 0 END)
        - SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN net_revenue ELSE 0 END))
        / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN net_revenue ELSE 0 END), 0) * 100
    , 1) AS pct_change_net_30d,
    ROUND(
        (SUM(CASE WHEN metric_date >= d - INTERVAL '29 days' THEN inventory_usage_cost + labor_total_cost + operational_total_cost ELSE 0 END)
        - SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN inventory_usage_cost + labor_total_cost + operational_total_cost ELSE 0 END))
        / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '59 days' AND metric_date < d - INTERVAL '29 days' THEN inventory_usage_cost + labor_total_cost + operational_total_cost ELSE 0 END), 0) * 100
    , 1) AS pct_change_biaya_30d,
    
    SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END) AS gross_90d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN net_revenue ELSE 0 END) AS net_90d,
    ROUND(
        SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN net_revenue ELSE 0 END)
        / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END), 0) * 100
    , 1) AS margin_90d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN inventory_usage_cost + labor_total_cost + operational_total_cost ELSE 0 END) AS biaya_90d,
    
    SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END) AS gross_prev90d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN net_revenue ELSE 0 END) AS net_prev90d,
    ROUND(
        SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN net_revenue ELSE 0 END)
        / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END), 0) * 100
    , 1) AS margin_prev90d,
    SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN inventory_usage_cost + labor_total_cost + operational_total_cost ELSE 0 END) AS biaya_prev90d,
    
    ROUND(
        ROUND(
            SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN net_revenue ELSE 0 END)
            / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END), 0) * 100
        , 1)
        -
        ROUND(
            SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN net_revenue ELSE 0 END)
            / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END), 0) * 100
        , 1)
    , 1) AS delta_margin_90d,
    ROUND(
        (SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END)
        - SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END))
        / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN gross_revenue ELSE 0 END), 0) * 100
    , 1) AS pct_change_gross_90d,
    ROUND(
        (SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN net_revenue ELSE 0 END)
        - SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN net_revenue ELSE 0 END))
        / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN net_revenue ELSE 0 END), 0) * 100
    , 1) AS pct_change_net_90d,
    ROUND(
        (SUM(CASE WHEN metric_date >= d - INTERVAL '89 days' THEN inventory_usage_cost + labor_total_cost + operational_total_cost ELSE 0 END)
        - SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN inventory_usage_cost + labor_total_cost + operational_total_cost ELSE 0 END))
        / NULLIF(SUM(CASE WHEN metric_date >= d - INTERVAL '179 days' AND metric_date < d - INTERVAL '89 days' THEN inventory_usage_cost + labor_total_cost + operational_total_cost ELSE 0 END), 0) * 100
    , 1) AS pct_change_biaya_90d
FROM main_marts.mart_daily_net_revenue CROSS JOIN max_d

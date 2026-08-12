SELECT
    MEDIAN(total_qty_sold_sum) AS median_qty,
    MEDIAN(total_revenue_sum)  AS median_revenue
FROM (
    SELECT SUM(total_qty_sold) AS total_qty_sold_sum, SUM(total_revenue) AS total_revenue_sum
    FROM main_marts.mart_menu_performance
    WHERE order_date >= (SELECT MAX(order_date) FROM main_marts.mart_menu_performance) - INTERVAL '29 days'
    GROUP BY menu_name
)

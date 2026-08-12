SELECT
    menu_name,
    SUM(total_qty_sold) AS total_qty,
    SUM(total_revenue)  AS total_revenue,
    CASE
        WHEN SUM(total_qty_sold) >= MEDIAN(SUM(total_qty_sold)) OVER () AND SUM(total_revenue) >= MEDIAN(SUM(total_revenue)) OVER () THEN 'Primadona'
        WHEN SUM(total_qty_sold) >= MEDIAN(SUM(total_qty_sold)) OVER () AND SUM(total_revenue) <  MEDIAN(SUM(total_revenue)) OVER () THEN 'Pekerja Keras'
        WHEN SUM(total_qty_sold) <  MEDIAN(SUM(total_qty_sold)) OVER () AND SUM(total_revenue) >= MEDIAN(SUM(total_revenue)) OVER () THEN 'Misteri'
        ELSE 'Lemah'
    END AS klasifikasi
FROM main_marts.mart_menu_performance
WHERE order_date >= (SELECT MAX(order_date) FROM main_marts.mart_menu_performance) - INTERVAL '29 days'
GROUP BY menu_name

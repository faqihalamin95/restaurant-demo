SELECT
    CASE WHEN MONTH(order_date) IN (1,2,3) THEN 'Q1'
         WHEN MONTH(order_date) IN (4,5,6) THEN 'Q2'
         WHEN MONTH(order_date) IN (7,8,9) THEN 'Q3'
         ELSE 'Q4' END AS kuartal,
    CASE WHEN MONTH(order_date) IN (1,2,3) THEN 1
         WHEN MONTH(order_date) IN (4,5,6) THEN 2
         WHEN MONTH(order_date) IN (7,8,9) THEN 3
         ELSE 4 END AS kuartal_urut,
    YEAR(order_date)       AS tahun,
    SUM(total_orders)      AS q_orders,
    SUM(total_revenue)     AS q_revenue
FROM main_marts.mart_peak_hours
GROUP BY
    CASE WHEN MONTH(order_date) IN (1,2,3) THEN 'Q1'
         WHEN MONTH(order_date) IN (4,5,6) THEN 'Q2'
         WHEN MONTH(order_date) IN (7,8,9) THEN 'Q3'
         ELSE 'Q4' END,
    CASE WHEN MONTH(order_date) IN (1,2,3) THEN 1
         WHEN MONTH(order_date) IN (4,5,6) THEN 2
         WHEN MONTH(order_date) IN (7,8,9) THEN 3
         ELSE 4 END,
    YEAR(order_date)
ORDER BY kuartal_urut, tahun

SELECT shift_name, SUM(orders_handled) AS total_orders, SUM(total_revenue) AS total_revenue,
    ROUND(AVG(avg_ticket),0) AS avg_ticket
FROM main_marts.mart_employee_shift_performance
WHERE attendance_date >= (SELECT MAX(attendance_date) FROM main_marts.mart_employee_shift_performance) - INTERVAL '29 days'
GROUP BY shift_name ORDER BY total_revenue DESC

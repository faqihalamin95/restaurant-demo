WITH base AS (
    SELECT menu_name,
        CASE category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman'
            WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert' WHEN 'side' THEN 'Pendamping' ELSE category END AS category,
        price_tier, SUM(total_qty_sold) AS total_qty, SUM(total_revenue) AS total_revenue,
        ROUND(SUM(total_revenue)/NULLIF(SUM(total_qty_sold),0),0) AS avg_price_realisasi
    FROM main_marts.mart_menu_performance
    WHERE order_date >= (SELECT MAX(order_date) FROM main_marts.mart_menu_performance) - INTERVAL '29 days'
    GROUP BY menu_name, category, price_tier
)
SELECT *,
    menu_name || ' · ' || category AS tooltip_label,
    CASE
        WHEN total_qty>=MEDIAN(total_qty) OVER () AND total_revenue>=MEDIAN(total_revenue) OVER () THEN 'Primadona'
        WHEN total_qty>=MEDIAN(total_qty) OVER () AND total_revenue< MEDIAN(total_revenue) OVER () THEN 'Pekerja Keras'
        WHEN total_qty< MEDIAN(total_qty) OVER () AND total_revenue>=MEDIAN(total_revenue) OVER () THEN 'Misteri'
        ELSE 'Lemah'
    END AS klasifikasi,
    CASE
        WHEN total_qty>=MEDIAN(total_qty) OVER () AND total_revenue>=MEDIAN(total_revenue) OVER () THEN 'Jaga stok & kualitas'
        WHEN total_qty>=MEDIAN(total_qty) OVER () AND total_revenue< MEDIAN(total_revenue) OVER () THEN 'Uji bundling / harga'
        WHEN total_qty< MEDIAN(total_qty) OVER () AND total_revenue>=MEDIAN(total_revenue) OVER () THEN 'Dorong visibilitas'
        ELSE 'Validasi tren dulu'
    END AS aksi_disarankan
FROM base
ORDER BY total_revenue DESC

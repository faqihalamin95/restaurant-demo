SELECT
    strftime('%d %b %Y', MAX(metric_date))                      AS tgl_akhir,
    strftime('%d %b %Y', MAX(metric_date) - INTERVAL '6 days')  AS tgl_7d_awal,
    strftime('%d %b %Y', MAX(metric_date) - INTERVAL '29 days') AS tgl_30d_awal,
    strftime('%d %b %Y', MAX(metric_date) - INTERVAL '89 days') AS tgl_90d_awal,
    DAY(MAX(metric_date)) || ' ' ||
    CASE MONTH(MAX(metric_date))
        WHEN 1 THEN 'Januari' WHEN 2 THEN 'Februari' WHEN 3 THEN 'Maret'
        WHEN 4 THEN 'April'   WHEN 5 THEN 'Mei'      WHEN 6 THEN 'Juni'
        WHEN 7 THEN 'Juli'    WHEN 8 THEN 'Agustus'  WHEN 9 THEN 'September'
        WHEN 10 THEN 'Oktober' WHEN 11 THEN 'November' WHEN 12 THEN 'Desember'
    END || ' ' || YEAR(MAX(metric_date))                        AS tgl_display,
    CASE DAYNAME(MAX(metric_date))
        WHEN 'Monday' THEN 'Senin' WHEN 'Tuesday' THEN 'Selasa'
        WHEN 'Wednesday' THEN 'Rabu' WHEN 'Thursday' THEN 'Kamis'
        WHEN 'Friday' THEN 'Jumat' WHEN 'Saturday' THEN 'Sabtu'
        WHEN 'Sunday' THEN 'Minggu'
    END                                                         AS nama_hari
FROM main_marts.mart_daily_net_revenue

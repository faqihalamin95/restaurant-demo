WITH max_d AS (SELECT MAX(order_date) AS d FROM main_marts.mart_menu_performance),
curr_7 AS (
    SELECT menu_name,
        CASE category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman'
            WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert' WHEN 'side' THEN 'Pendamping' ELSE category END AS category,
        SUM(total_qty_sold) AS qty_curr,
        SUM(total_revenue)  AS rev_curr
    FROM main_marts.mart_menu_performance CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '6 days'
    GROUP BY menu_name, category
),
prev_7 AS (
    SELECT menu_name, SUM(total_qty_sold) AS qty_prev
    FROM main_marts.mart_menu_performance CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '13 days' AND order_date < d - INTERVAL '6 days'
    GROUP BY menu_name
),
curr_30 AS (
    SELECT menu_name,
        CASE category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman'
            WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert' WHEN 'side' THEN 'Pendamping' ELSE category END AS category,
        SUM(total_qty_sold) AS qty_curr,
        SUM(total_revenue)  AS rev_curr
    FROM main_marts.mart_menu_performance CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '29 days'
    GROUP BY menu_name, category
),
prev_30 AS (
    SELECT menu_name, SUM(total_qty_sold) AS qty_prev
    FROM main_marts.mart_menu_performance CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '59 days' AND order_date < d - INTERVAL '29 days'
    GROUP BY menu_name
),
meds AS (SELECT MEDIAN(qty_curr) AS mq, MEDIAN(rev_curr) AS mr FROM curr_30),
top5_rev AS (
    SELECT ROUND(SUM(CASE WHEN rnk<=5 THEN rev_curr ELSE 0 END)*100.0/NULLIF(SUM(rev_curr),0),1) AS share
    FROM (SELECT rev_curr, ROW_NUMBER() OVER (ORDER BY rev_curr DESC) AS rnk FROM curr_30)
),
quick_decline AS (
    SELECT c.menu_name, c.category,
        ROUND((c.qty_curr - COALESCE(p.qty_prev,0))*100.0/NULLIF(p.qty_prev,0),1) AS pct_chg,
        ROW_NUMBER() OVER (
            ORDER BY ROUND((c.qty_curr - COALESCE(p.qty_prev,0))*100.0/NULLIF(p.qty_prev,0),1) ASC
        ) AS rn
    FROM curr_7 c
    LEFT JOIN prev_7 p ON c.menu_name=p.menu_name
    WHERE COALESCE(p.qty_prev,0)>0
      AND ROUND((c.qty_curr - COALESCE(p.qty_prev,0))*100.0/NULLIF(p.qty_prev,0),1) <= -20
),
classified AS (
    SELECT c.menu_name, c.category, c.qty_curr, c.rev_curr,
        COALESCE(p.qty_prev,0) AS qty_prev,
        ROUND((c.qty_curr - COALESCE(p.qty_prev,0))*100.0/NULLIF(p.qty_prev,0),1) AS pct_chg,
        CASE
            WHEN c.qty_curr>=m.mq AND c.rev_curr>=m.mr THEN 'Primadona'
            WHEN c.qty_curr>=m.mq AND c.rev_curr< m.mr THEN 'Pekerja Keras'
            WHEN c.qty_curr< m.mq AND c.rev_curr>=m.mr THEN 'Misteri'
            ELSE 'Lemah'
        END AS klasifikasi
    FROM curr_30 c
    LEFT JOIN prev_30 p ON c.menu_name=p.menu_name
    CROSS JOIN meds m
),
declining AS (
    SELECT menu_name, category, pct_chg,
        CASE WHEN pct_chg<=-40 THEN 'Kritis' ELSE 'Tinggi' END AS sev,
        ROW_NUMBER() OVER (ORDER BY pct_chg ASC) AS rn
    FROM classified WHERE pct_chg<=-20 AND qty_prev>0
),
misteri AS (
    SELECT menu_name, category, rev_curr,
        ROW_NUMBER() OVER (ORDER BY rev_curr DESC) AS rn
    FROM classified WHERE klasifikasi='Misteri'
),
pekerja AS (
    SELECT menu_name, category, qty_curr,
        ROW_NUMBER() OVER (ORDER BY qty_curr DESC) AS rn
    FROM classified WHERE klasifikasi='Pekerja Keras'
),
concentration AS (
    SELECT share FROM top5_rev WHERE share>=55
),
structural AS (
    SELECT menu_name, category, pct_change_90d, severity, declining_weeks_12,
        ROW_NUMBER() OVER (ORDER BY pct_change_90d ASC) AS rn
    FROM (
WITH max_d AS (SELECT MAX(order_date) AS d FROM main_marts.mart_menu_performance),
calendar AS (
    SELECT gs AS order_date
    FROM max_d, generate_series(d - INTERVAL '89 days', d, INTERVAL '1 day') AS t(gs)
),
menu_dim AS (
    SELECT
        menu_name,
        MAX(CASE category WHEN 'main' THEN 'Menu Utama' WHEN 'drink' THEN 'Minuman'
            WHEN 'snack' THEN 'Camilan' WHEN 'dessert' THEN 'Dessert'
            WHEN 'side' THEN 'Pendamping' ELSE category END) AS category
    FROM main_marts.mart_menu_performance CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '89 days'
    GROUP BY menu_name
),
daily AS (
    SELECT
        c.order_date,
        m.menu_name,
        m.category,
        COALESCE(SUM(p.total_qty_sold), 0) AS qty_daily,
        COALESCE(SUM(p.total_revenue), 0) AS revenue_daily
    FROM calendar c
    CROSS JOIN menu_dim m
    LEFT JOIN main_marts.mart_menu_performance p
        ON p.order_date = c.order_date
       AND p.menu_name = m.menu_name
    GROUP BY c.order_date, m.menu_name, m.category
),
rolling AS (
    SELECT
        order_date,
        menu_name,
        category,
        qty_daily,
        revenue_daily,
        DATE_DIFF('day', (SELECT d - INTERVAL '89 days' FROM max_d), order_date) AS day_index,
        AVG(qty_daily) OVER (
            PARTITION BY menu_name
            ORDER BY order_date
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS rolling_avg_qty,
        AVG(revenue_daily) OVER (
            PARTITION BY menu_name
            ORDER BY order_date
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS rolling_avg_revenue
    FROM daily
),
weekly AS (
    SELECT
        menu_name,
        MAX(category) AS category,
        CAST(FLOOR((day_index - 6) / 7) + 1 AS INTEGER) AS week_no,
        SUM(qty_daily) AS weekly_qty,
        SUM(revenue_daily) AS weekly_revenue
    FROM rolling
    WHERE day_index BETWEEN 6 AND 89
    GROUP BY menu_name, week_no
),
weekly_change AS (
    SELECT *,
        LAG(weekly_qty) OVER (PARTITION BY menu_name ORDER BY week_no) AS prev_weekly_qty
    FROM weekly
),
summary AS (
    SELECT
        menu_name,
        MAX(category) AS category,
        COUNT(*) AS weeks_observed,
        SUM(CASE WHEN prev_weekly_qty IS NOT NULL AND weekly_qty < prev_weekly_qty THEN 1 ELSE 0 END) AS declining_weeks_12,
        MAX(CASE WHEN week_no=1 THEN weekly_qty END) AS weekly_qty_awal,
        AVG(weekly_qty) FILTER (WHERE week_no BETWEEN 5 AND 8) AS weekly_qty_tengah,
        MAX(CASE WHEN week_no=12 THEN weekly_qty END) AS weekly_qty_akhir,
        MAX(CASE WHEN week_no=12 THEN weekly_revenue END) AS weekly_revenue_akhir,
        AVG(weekly_qty) FILTER (WHERE week_no BETWEEN 10 AND 12) AS recent_3w_avg
    FROM weekly_change
    GROUP BY menu_name
),
peak AS (
    SELECT menu_name, week_no AS peak_week_no, weekly_qty AS weekly_qty_peak
    FROM (
        SELECT
            menu_name,
            week_no,
            weekly_qty,
            ROW_NUMBER() OVER (
                PARTITION BY menu_name
                ORDER BY weekly_qty DESC, week_no DESC
            ) AS rn
        FROM weekly
    )
    WHERE rn = 1
),
scored AS (
    SELECT
        s.menu_name,
        s.category,
        p.peak_week_no,
        s.weeks_observed,
        s.declining_weeks_12,
        s.weekly_qty_awal,
        s.weekly_qty_tengah,
        p.weekly_qty_peak,
        s.weekly_qty_akhir,
        s.weekly_revenue_akhir,
        s.recent_3w_avg,
        ROUND((s.weekly_qty_akhir - p.weekly_qty_peak) * 100.0 / NULLIF(p.weekly_qty_peak, 0), 1) AS pct_change_90d
    FROM summary s
    JOIN peak p ON s.menu_name = p.menu_name
)
SELECT
    menu_name,
    category,
    peak_week_no,
    weeks_observed,
    declining_weeks_12,
    ROUND(weekly_qty_awal, 1) AS weekly_qty_awal,
    ROUND(weekly_qty_tengah, 1) AS weekly_qty_tengah,
    ROUND(weekly_qty_peak, 1) AS weekly_qty_peak,
    ROUND(weekly_qty_akhir, 1) AS weekly_qty_akhir,
    ROUND(weekly_revenue_akhir, 0) AS weekly_revenue_akhir,
    ROUND(weekly_qty_awal, 1) AS rolling_qty_awal,
    ROUND(weekly_qty_tengah, 1) AS rolling_qty_tengah,
    ROUND(weekly_qty_peak, 1) AS rolling_qty_peak,
    ROUND(weekly_qty_akhir, 1) AS rolling_qty_akhir,
    ROUND(weekly_revenue_akhir, 0) AS rolling_revenue_akhir,
    pct_change_90d,
    CASE
        WHEN declining_weeks_12 >= 9 AND pct_change_90d <= -25 AND weekly_qty_akhir <= recent_3w_avg * 1.10 THEN 'Kritis'
        WHEN declining_weeks_12 >= 8 AND pct_change_90d <= -15 THEN 'Waspada'
        ELSE 'Pantau'
    END AS severity,
    CAST(declining_weeks_12 AS VARCHAR) || ' dari 12 minggu turun' AS trend_status,
    CASE
        WHEN declining_weeks_12 >= 9 AND pct_change_90d <= -25 AND weekly_qty_akhir <= recent_3w_avg * 1.10 THEN '>=75% minggu turun + akhir turun >=25% + belum pulih'
        WHEN declining_weeks_12 >= 8 AND pct_change_90d <= -15 THEN '>=67% minggu turun + akhir turun >=15%'
        ELSE '>=60% minggu turun + akhir turun >=10%'
    END AS decline_rule,
    CASE WHEN weekly_qty_akhir <= recent_3w_avg * 1.10 THEN '3 minggu terakhir belum pulih signifikan' ELSE 'Ada indikasi pemulihan akhir' END AS recent_status
FROM scored
WHERE weekly_qty_peak >= 5
  AND weeks_observed = 12
  AND (
      (declining_weeks_12 >= 9 AND pct_change_90d <= -25 AND weekly_qty_akhir <= recent_3w_avg * 1.10)
      OR (declining_weeks_12 >= 8 AND pct_change_90d <= -15)
      OR (declining_weeks_12 >= 7 AND pct_change_90d <= -10)
  )
ORDER BY pct_change_90d ASC
) AS menu_a_structural_decline_90d
)
SELECT
    priority,
    action_group,
    severity,
    action_type,
    menu_name,
    category,
    metric_value,
    impact_text,
    recommended_action,
    evidence_window,
    first_step,
    guardrail
FROM (
    SELECT 10 + q.rn AS priority, 'Aksi Cepat' AS action_group,
        CASE WHEN q.pct_chg<=-35 THEN 'Tinggi' ELSE 'Sedang' END AS severity,
        'Drop Mingguan' AS action_type,
        q.menu_name, q.category,
        CAST(q.pct_chg AS VARCHAR) || '% qty vs 7H sebelumnya' AS metric_value,
        'Sinyal cepat: kemungkinan stok, kualitas, promo, atau eksekusi cabang berubah minggu ini' AS impact_text,
        'Cek stok, jam jual, kualitas plating/rasa, dan cabang yang paling turun sebelum membuat promo.' AS recommended_action,
        '7H vs 7H sebelumnya' AS evidence_window,
        'Audit cabang dan ketersediaan menu hari ini.' AS first_step,
        'Jangan reformulasi atau retire dari sinyal 7H saja.' AS guardrail
    FROM quick_decline q WHERE q.rn<=2
    UNION ALL
    SELECT 20 + s.rn, 'Evaluasi Serius',
        s.severity,
        'Tren 90H' AS action_type,
        s.menu_name, s.category,
        CAST(s.pct_change_90d AS VARCHAR) || '% dari peak mingguan 90H · ' || CAST(s.declining_weeks_12 AS VARCHAR) || '/12 minggu turun' AS metric_value,
        'Penurunan berulang dalam mayoritas minggu 90H, bukan sekadar drop sesaat' AS impact_text,
        'Bandingkan per cabang, margin, stok bahan, dan histori promo sebelum reformulasi, reprice, atau retire.' AS recommended_action,
        'Persistensi mingguan 90H' AS evidence_window,
        'Buka Pergerakan 90H dan Penurunan per Cabang untuk menu ini.' AS first_step,
        'Jangan promosi besar sebelum tahu penyebab turun: demand, harga, kualitas, atau stok.' AS guardrail
    FROM structural s WHERE s.rn<=2
    UNION ALL
    SELECT 30, 'Aksi Portofolio',
        CASE WHEN c.share>=70 THEN 'Tinggi' ELSE 'Sedang' END,
        'Konsentrasi Revenue', 'Portofolio', 'Semua Kategori',
        CAST(c.share AS VARCHAR) || '% revenue dari 5 menu teratas' AS metric_value,
        'Ketergantungan tinggi: gangguan menu andalan langsung memukul total revenue' AS impact_text,
        'Dorong menu tingkat dua lewat bundling, rekomendasi staf, atau pairing dengan menu andalan.' AS recommended_action,
        '30H portofolio' AS evidence_window,
        'Pilih 1-2 menu Misteri atau Pekerja Keras untuk eksperimen minggu ini.' AS first_step,
        'Jangan mengurangi stok menu andalan sebelum demand menu tingkat dua terbukti naik.' AS guardrail
    FROM concentration c
    UNION ALL
    SELECT 40 + d.rn, 'Aksi Portofolio', d.sev, 'Menu Turun 30H' AS action_type,
        d.menu_name, d.category,
        CAST(d.pct_chg AS VARCHAR) || '% qty vs 30H sebelumnya' AS metric_value,
        'Penurunan bulanan cukup kuat untuk masuk audit portofolio' AS impact_text,
        'Cek distribusi antar cabang dulu. Jika turun di satu cabang: audit stok dan kualitas lokal. Jika menyebar: pertimbangkan promo, bundling, atau repositioning.' AS recommended_action,
        '30H vs 30H sebelumnya' AS evidence_window,
        'Cek apakah drop menyebar ke banyak cabang.' AS first_step,
        'Jika menu juga masuk Evaluasi Serius 90H, prioritaskan diagnosis akar masalah dulu.' AS guardrail
    FROM declining d WHERE d.rn<=2
    UNION ALL
    SELECT 50 + m.rn, 'Aksi Portofolio', 'Sedang', 'Misteri', m.menu_name, m.category,
        'Revenue tinggi, volume rendah' AS metric_value,
        'Potensi revenue belum tergali karena kurang dikenal pelanggan' AS impact_text,
        'Rekomendasikan aktif saat pelanggan memesan menu andalan. Pertimbangkan posisi lebih menonjol di daftar menu.' AS recommended_action,
        '30H klasifikasi menu' AS evidence_window,
        'Uji rekomendasi staf atau placement selama 7 hari.' AS first_step,
        'Jika menu ini juga turun 90H, jangan langsung dipush tanpa cek kualitas dan harga.' AS guardrail
    FROM misteri m WHERE m.rn<=2
    UNION ALL
    SELECT 60 + p.rn, 'Aksi Portofolio', 'Sedang', 'Pekerja Keras', p.menu_name, p.category,
        'Volume tinggi, revenue rendah' AS metric_value,
        'Menu laris tapi belum dimonetisasi optimal' AS impact_text,
        'Uji bundling dengan item premium atau kenaikan harga kecil. Pantau apakah volume tetap stabil setelah perubahan.' AS recommended_action,
        '30H klasifikasi menu' AS evidence_window,
        'Buat satu bundle/add-on kecil dan ukur attach rate.' AS first_step,
        'Jangan naikkan harga tajam tanpa melihat sensitivitas volume.' AS guardrail
    FROM pekerja p WHERE p.rn=1
) ORDER BY priority ASC, severity DESC
LIMIT 8

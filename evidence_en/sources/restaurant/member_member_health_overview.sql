WITH max_d AS (SELECT MAX(order_date) AS d FROM main_marts.mart_member_purchase_behavior),
members AS (
    SELECT member_id, member_name, tier, city, join_date
    FROM main_foundation.dim_members
),
last_order AS (
    SELECT member_id, MAX(order_date) AS last_order_date
    FROM main_marts.mart_member_purchase_behavior CROSS JOIN max_d
    WHERE order_date <= d
    GROUP BY member_id
),
member_state AS (
    SELECT
        m.member_id,
        m.member_name,
        m.tier,
        m.city,
        m.join_date,
        l.last_order_date,
        COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) AS recency_days,
        CASE
            WHEN m.tier='Gold' AND COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) >= 14 THEN 1
            WHEN m.tier='Silver' AND COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) >= 21 THEN 1
            WHEN m.tier='Bronze' AND COALESCE(DATEDIFF('day', l.last_order_date, d), 9999) >= 30 THEN 1
            ELSE 0
        END AS is_churn_risk
    FROM members m
    CROSS JOIN max_d
    LEFT JOIN last_order l ON m.member_id = l.member_id
),
curr_30 AS (
    SELECT member_id,
        SUM(total_orders) AS orders,
        SUM(total_spend)  AS spend
    FROM main_marts.mart_member_purchase_behavior CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '29 days'
    GROUP BY member_id
),
prev_30 AS (
    SELECT member_id,
        SUM(total_orders) AS orders,
        SUM(total_spend)  AS spend
    FROM main_marts.mart_member_purchase_behavior CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '59 days'
      AND order_date <  d - INTERVAL '29 days'
    GROUP BY member_id
),
curr_90 AS (
    SELECT member_id,
        SUM(total_orders) AS orders,
        SUM(total_spend)  AS spend
    FROM main_marts.mart_member_purchase_behavior CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '89 days'
    GROUP BY member_id
),
prev_90 AS (
    SELECT member_id,
        SUM(total_orders) AS orders,
        SUM(total_spend)  AS spend
    FROM main_marts.mart_member_purchase_behavior CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '179 days'
      AND order_date <  d - INTERVAL '89 days'
    GROUP BY member_id
),
agg_30 AS (
    SELECT
        COUNT(CASE WHEN COALESCE(c.orders,0)>0 THEN 1 END) AS active,
        SUM(COALESCE(c.orders,0)) AS tot_orders,
        SUM(COALESCE(c.spend,0)) AS tot_spend,
        ROUND(SUM(COALESCE(c.spend,0))/NULLIF(SUM(COALESCE(c.orders,0)),0),0) AS aov,
        ROUND(SUM(COALESCE(c.orders,0))*1.0/NULLIF(COUNT(CASE WHEN COALESCE(c.orders,0)>0 THEN 1 END),0)/4.29,2) AS freq_pw,
        SUM(ms.is_churn_risk) AS churn,
        SUM(CASE WHEN ms.tier='Gold' AND ms.is_churn_risk=1 THEN 1 ELSE 0 END) AS gold_churn
    FROM member_state ms
    LEFT JOIN curr_30 c ON ms.member_id = c.member_id
),
comp_30 AS (
    SELECT
        ROUND((SUM(COALESCE(c.spend,0))/NULLIF(SUM(COALESCE(c.orders,0)),0) - SUM(COALESCE(p.spend,0))/NULLIF(SUM(COALESCE(p.orders,0)),0))
            / NULLIF(SUM(COALESCE(p.spend,0))/NULLIF(SUM(COALESCE(p.orders,0)),0),0)*100,1) AS aov_chg,
        ROUND((SUM(COALESCE(c.orders,0))*1.0/NULLIF(COUNT(CASE WHEN COALESCE(c.orders,0)>0 THEN 1 END),0)
            - SUM(COALESCE(p.orders,0))*1.0/NULLIF(COUNT(CASE WHEN COALESCE(p.orders,0)>0 THEN 1 END),0))
            / NULLIF(SUM(COALESCE(p.orders,0))*1.0/NULLIF(COUNT(CASE WHEN COALESCE(p.orders,0)>0 THEN 1 END),0),0)*100,1) AS freq_chg
    FROM member_state ms
    LEFT JOIN curr_30 c ON ms.member_id=c.member_id
    LEFT JOIN prev_30 p ON ms.member_id=p.member_id
),
agg_90 AS (
    SELECT
        COUNT(CASE WHEN COALESCE(c.orders,0)>0 THEN 1 END) AS active,
        SUM(COALESCE(c.orders,0)) AS tot_orders,
        SUM(COALESCE(c.spend,0)) AS tot_spend,
        ROUND(SUM(COALESCE(c.spend,0))/NULLIF(SUM(COALESCE(c.orders,0)),0),0) AS aov,
        ROUND(SUM(COALESCE(c.orders,0))*1.0/NULLIF(COUNT(CASE WHEN COALESCE(c.orders,0)>0 THEN 1 END),0)/12.86,2) AS freq_pw,
        SUM(ms.is_churn_risk) AS churn,
        SUM(CASE WHEN ms.tier='Gold' AND ms.is_churn_risk=1 THEN 1 ELSE 0 END) AS gold_churn
    FROM member_state ms
    LEFT JOIN curr_90 c ON ms.member_id = c.member_id
),
comp_90 AS (
    SELECT
        ROUND((SUM(COALESCE(c.spend,0))/NULLIF(SUM(COALESCE(c.orders,0)),0) - SUM(COALESCE(p.spend,0))/NULLIF(SUM(COALESCE(p.orders,0)),0))
            / NULLIF(SUM(COALESCE(p.spend,0))/NULLIF(SUM(COALESCE(p.orders,0)),0),0)*100,1) AS aov_chg,
        ROUND((SUM(COALESCE(c.orders,0))*1.0/NULLIF(COUNT(CASE WHEN COALESCE(c.orders,0)>0 THEN 1 END),0)
            - SUM(COALESCE(p.orders,0))*1.0/NULLIF(COUNT(CASE WHEN COALESCE(p.orders,0)>0 THEN 1 END),0))
            / NULLIF(SUM(COALESCE(p.orders,0))*1.0/NULLIF(COUNT(CASE WHEN COALESCE(p.orders,0)>0 THEN 1 END),0),0)*100,1) AS freq_chg
    FROM member_state ms
    LEFT JOIN curr_90 c ON ms.member_id=c.member_id
    LEFT JOIN prev_90 p ON ms.member_id=p.member_id
),
cohort_agg AS (
    SELECT
        DATE_TRUNC('month', join_date)                                              AS cb,
        ROUND(SUM(total_orders)*1.0/NULLIF(COUNT(DISTINCT member_id),0)/12.86, 2) AS fw,
        ROUND(SUM(total_spend)/NULLIF(COUNT(DISTINCT member_id),0), 0)            AS av
    FROM main_marts.mart_member_purchase_behavior CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '89 days'
    GROUP BY DATE_TRUNC('month', join_date)
),
cohort_stats AS (
    SELECT
        MAX(CASE WHEN cb = (SELECT MAX(cb) FROM cohort_agg) THEN fw END) AS newest_freq,
        MAX(CASE WHEN cb = (SELECT MAX(cb) FROM cohort_agg) THEN av  END) AS newest_value,
        ROUND(AVG(fw),2) AS avg_freq,
        ROUND(AVG(av),0) AS avg_value
    FROM cohort_agg
)
SELECT
    a3.active      AS active_30d,
    a3.tot_orders  AS orders_30d,
    a3.tot_spend   AS spend_30d,
    a3.aov         AS aov_30d,
    a3.freq_pw     AS freq_30d,
    a3.churn       AS churn_30d,
    a3.gold_churn  AS gold_churn_30d,
    c3.aov_chg     AS aov_change_30d,
    c3.freq_chg    AS freq_change_30d,
    CASE
        WHEN a3.gold_churn>=3 OR c3.freq_chg<=-25 OR c3.aov_chg<=-20 THEN 'Kritis'
        WHEN a3.gold_churn>=1 OR a3.churn>=5 OR c3.freq_chg<=-10 OR c3.aov_chg<=-10 THEN 'Waspada'
        ELSE 'Sehat'
    END AS status_30d,
    CASE
        WHEN a3.gold_churn>=1    THEN 'Churn risk'
        WHEN c3.freq_chg<=-10   THEN 'Frekuensi turun'
        WHEN c3.aov_chg<=-10    THEN 'Value turun'
        WHEN a3.active < 5       THEN 'Aktivasi rendah'
        ELSE 'Loyalitas sehat'
    END AS focus_30d,
    a9.active      AS active_90d,
    a9.tot_orders  AS orders_90d,
    a9.tot_spend   AS spend_90d,
    a9.aov         AS aov_90d,
    a9.freq_pw     AS freq_90d,
    a9.churn       AS churn_90d,
    a9.gold_churn  AS gold_churn_90d,
    c9.aov_chg     AS aov_change_90d,
    c9.freq_chg    AS freq_change_90d,
    CASE
        WHEN a9.gold_churn>=3 OR c9.freq_chg<=-25 OR c9.aov_chg<=-20 THEN 'Kritis'
        WHEN a9.gold_churn>=1 OR a9.churn>=5 OR c9.freq_chg<=-10 OR c9.aov_chg<=-10 THEN 'Waspada'
        ELSE 'Sehat'
    END AS status_90d,
    CASE
        WHEN a9.gold_churn>=1    THEN 'Churn risk'
        WHEN c9.freq_chg<=-10   THEN 'Frekuensi turun'
        WHEN c9.aov_chg<=-10    THEN 'Value turun'
        WHEN a9.active < 5       THEN 'Aktivasi rendah'
        ELSE 'Loyalitas sehat'
    END AS focus_90d,
    cs.newest_freq  AS cohort_newest_freq,
    cs.avg_freq     AS cohort_avg_freq,
    cs.newest_value AS cohort_newest_value,
    cs.avg_value    AS cohort_avg_value,
    CASE WHEN cs.newest_freq >= cs.avg_freq THEN 'Sehat' ELSE 'Waspada' END AS cohort_status,
    CASE WHEN cs.newest_freq < cs.avg_freq
        THEN 'Kualitas cohort baru menurun'
        ELSE 'Cohort baru berkualitas baik'
    END AS cohort_focus
FROM agg_30 a3, comp_30 c3, agg_90 a9, comp_90 c9, cohort_stats cs

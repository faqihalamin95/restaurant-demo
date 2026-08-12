{{ config(materialized='table') }}

WITH max_d AS (SELECT MAX(order_date) AS d FROM {{ ref('mart_menu_performance') }}),
curr_y AS (
    SELECT menu_name, SUM(total_qty_sold) AS qty, SUM(total_revenue) AS rev
    FROM {{ ref('mart_menu_performance') }} CROSS JOIN max_d
    WHERE order_date = d GROUP BY menu_name HAVING SUM(total_qty_sold) > 0
),
curr_7d AS (
    SELECT menu_name, SUM(total_qty_sold) AS qty, SUM(total_revenue) AS rev
    FROM {{ ref('mart_menu_performance') }} CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '6 days' GROUP BY menu_name HAVING SUM(total_qty_sold) > 0
),
curr_30d AS (
    SELECT menu_name, SUM(total_qty_sold) AS qty, SUM(total_revenue) AS rev
    FROM {{ ref('mart_menu_performance') }} CROSS JOIN max_d
    WHERE order_date >= d - INTERVAL '29 days' GROUP BY menu_name HAVING SUM(total_qty_sold) > 0
),
prev_y   AS (SELECT menu_name, SUM(total_qty_sold) AS qty FROM {{ ref('mart_menu_performance') }} CROSS JOIN max_d WHERE order_date = d - INTERVAL '7 days' GROUP BY menu_name),
prev_7d  AS (SELECT menu_name, SUM(total_qty_sold) AS qty FROM {{ ref('mart_menu_performance') }} CROSS JOIN max_d WHERE order_date >= d - INTERVAL '13 days' AND order_date < d - INTERVAL '6 days' GROUP BY menu_name),
prev_30d AS (SELECT menu_name, SUM(total_qty_sold) AS qty FROM {{ ref('mart_menu_performance') }} CROSS JOIN max_d WHERE order_date >= d - INTERVAL '59 days' AND order_date < d - INTERVAL '29 days' GROUP BY menu_name),
med_y    AS (SELECT MEDIAN(qty) AS mq, MEDIAN(rev) AS mr FROM curr_y),
med_7d   AS (SELECT MEDIAN(qty) AS mq, MEDIAN(rev) AS mr FROM curr_7d),
med_30d  AS (SELECT MEDIAN(qty) AS mq, MEDIAN(rev) AS mr FROM curr_30d),
sy AS (
    SELECT COUNT(*) AS ac, SUM(c.rev) AS tr, SUM(c.qty) AS tq,
        SUM(CASE WHEN c.qty < m.mq AND c.rev < m.mr THEN 1 ELSE 0 END) AS wk,
        MAX(CASE WHEN rn_q=1 THEN c.menu_name END) AS tvm,
        MAX(CASE WHEN rn_r=1 THEN c.menu_name END) AS trm,
        SUM(CASE WHEN COALESCE(p.qty,0)>=1 AND c.qty<=COALESCE(p.qty,0)*0.8 THEN 1 ELSE 0 END) AS dc,
        SUM(CASE WHEN COALESCE(p.qty,0)>=1 AND c.qty>=COALESCE(p.qty,0)*1.2 THEN 1 ELSE 0 END) AS rc
    FROM (SELECT *, ROW_NUMBER() OVER (ORDER BY qty DESC) AS rn_q, ROW_NUMBER() OVER (ORDER BY rev DESC) AS rn_r FROM curr_y) c
    LEFT JOIN prev_y p ON c.menu_name=p.menu_name CROSS JOIN med_y m
),
t5y  AS (SELECT COALESCE(SUM(rev),0) AS t5r FROM (SELECT rev FROM curr_y  ORDER BY rev DESC LIMIT 5)),
s7 AS (
    SELECT COUNT(*) AS ac, SUM(c.rev) AS tr, SUM(c.qty) AS tq,
        SUM(CASE WHEN c.qty < m.mq AND c.rev < m.mr THEN 1 ELSE 0 END) AS wk,
        MAX(CASE WHEN rn_q=1 THEN c.menu_name END) AS tvm,
        MAX(CASE WHEN rn_r=1 THEN c.menu_name END) AS trm,
        SUM(CASE WHEN COALESCE(p.qty,0)>=4 AND c.qty<=COALESCE(p.qty,0)*0.8 THEN 1 ELSE 0 END) AS dc,
        SUM(CASE WHEN COALESCE(p.qty,0)>=4 AND c.qty>=COALESCE(p.qty,0)*1.2 THEN 1 ELSE 0 END) AS rc
    FROM (SELECT *, ROW_NUMBER() OVER (ORDER BY qty DESC) AS rn_q, ROW_NUMBER() OVER (ORDER BY rev DESC) AS rn_r FROM curr_7d) c
    LEFT JOIN prev_7d p ON c.menu_name=p.menu_name CROSS JOIN med_7d m
),
t57  AS (SELECT COALESCE(SUM(rev),0) AS t5r FROM (SELECT rev FROM curr_7d  ORDER BY rev DESC LIMIT 5)),
s30 AS (
    SELECT COUNT(*) AS ac, SUM(c.rev) AS tr, SUM(c.qty) AS tq,
        SUM(CASE WHEN c.qty < m.mq AND c.rev < m.mr THEN 1 ELSE 0 END) AS wk,
        MAX(CASE WHEN rn_q=1 THEN c.menu_name END) AS tvm,
        MAX(CASE WHEN rn_r=1 THEN c.menu_name END) AS trm,
        SUM(CASE WHEN COALESCE(p.qty,0)>=15 AND c.qty<=COALESCE(p.qty,0)*0.8 THEN 1 ELSE 0 END) AS dc,
        SUM(CASE WHEN COALESCE(p.qty,0)>=15 AND c.qty>=COALESCE(p.qty,0)*1.2 THEN 1 ELSE 0 END) AS rc
    FROM (SELECT *, ROW_NUMBER() OVER (ORDER BY qty DESC) AS rn_q, ROW_NUMBER() OVER (ORDER BY rev DESC) AS rn_r FROM curr_30d) c
    LEFT JOIN prev_30d p ON c.menu_name=p.menu_name CROSS JOIN med_30d m
),
t530 AS (SELECT COALESCE(SUM(rev),0) AS t5r FROM (SELECT rev FROM curr_30d ORDER BY rev DESC LIMIT 5)),
raw AS (
    SELECT
        sy.ac AS active_y,  sy.tr AS rev_y,  sy.tq AS qty_y,  sy.wk AS weak_y,  sy.dc AS declining_y,  sy.rc AS rising_y,
        sy.tvm AS top_volume_menu_y,  sy.trm AS top_revenue_menu_y,
        ROUND(t5y.t5r*100.0/NULLIF(sy.tr,0),1) AS top5_share_y,
        s7.ac AS active_7d, s7.tr AS rev_7d, s7.tq AS qty_7d, s7.wk AS weak_7d, s7.dc AS declining_7d, s7.rc AS rising_7d,
        s7.tvm AS top_volume_menu_7d, s7.trm AS top_revenue_menu_7d,
        ROUND(t57.t5r*100.0/NULLIF(s7.tr,0),1) AS top5_share_7d,
        s30.ac AS active_30d,s30.tr AS rev_30d,s30.tq AS qty_30d,s30.wk AS weak_30d,s30.dc AS declining_30d,s30.rc AS rising_30d,
        s30.tvm AS top_volume_menu_30d,s30.trm AS top_revenue_menu_30d,
        ROUND(t530.t5r*100.0/NULLIF(s30.tr,0),1) AS top5_share_30d
    FROM sy CROSS JOIN t5y CROSS JOIN s7 CROSS JOIN t57 CROSS JOIN s30 CROSS JOIN t530
)
SELECT *,
    CASE WHEN top5_share_y>=70 OR declining_y>=5 OR (active_y>0 AND weak_y*1.0/NULLIF(active_y,0)>=0.40) THEN 'Kritis'
         WHEN top5_share_y>=55 OR declining_y>=2 OR (active_y>0 AND weak_y*1.0/NULLIF(active_y,0)>=0.25) THEN 'Waspada'
         ELSE 'Sehat' END AS status_y,
    CASE WHEN top5_share_y>=70 THEN 'Konsentrasi revenue' WHEN declining_y>=2 THEN 'Menu menurun'
         WHEN active_y>0 AND weak_y*1.0/NULLIF(active_y,0)>=0.25 THEN 'Menu lemah' ELSE 'Portofolio sehat' END AS focus_y,
    CASE WHEN top5_share_7d>=70 OR declining_7d>=5 OR (active_7d>0 AND weak_7d*1.0/NULLIF(active_7d,0)>=0.40) THEN 'Kritis'
         WHEN top5_share_7d>=55 OR declining_7d>=2 OR (active_7d>0 AND weak_7d*1.0/NULLIF(active_7d,0)>=0.25) THEN 'Waspada'
         ELSE 'Sehat' END AS status_7d,
    CASE WHEN top5_share_7d>=70 THEN 'Konsentrasi revenue' WHEN declining_7d>=2 THEN 'Menu menurun'
         WHEN active_7d>0 AND weak_7d*1.0/NULLIF(active_7d,0)>=0.25 THEN 'Menu lemah' ELSE 'Portofolio sehat' END AS focus_7d,
    CASE WHEN top5_share_30d>=70 OR declining_30d>=5 OR (active_30d>0 AND weak_30d*1.0/NULLIF(active_30d,0)>=0.40) THEN 'Kritis'
         WHEN top5_share_30d>=55 OR declining_30d>=2 OR (active_30d>0 AND weak_30d*1.0/NULLIF(active_30d,0)>=0.25) THEN 'Waspada'
         ELSE 'Sehat' END AS status_30d,
    CASE WHEN top5_share_30d>=70 THEN 'Konsentrasi revenue' WHEN declining_30d>=2 THEN 'Menu menurun'
         WHEN active_30d>0 AND weak_30d*1.0/NULLIF(active_30d,0)>=0.25 THEN 'Menu lemah' ELSE 'Portofolio sehat' END AS focus_30d
FROM raw
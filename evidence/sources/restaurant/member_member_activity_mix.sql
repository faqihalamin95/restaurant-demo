WITH max_d AS (SELECT MAX(order_date) AS d FROM main_marts.mart_member_purchase_behavior),
members AS (
    SELECT member_id
    FROM main_foundation.dim_members
),
activity AS (
    SELECT
        m.member_id,
        MAX(CASE WHEN p.order_date >= d - INTERVAL '89 days' THEN 1 ELSE 0 END) AS active_90d
    FROM members m
    CROSS JOIN max_d
    LEFT JOIN main_marts.mart_member_purchase_behavior p
        ON m.member_id = p.member_id
       AND p.order_date <= d
       AND p.order_date >= d - INTERVAL '89 days'
    GROUP BY m.member_id
),
status_dim AS (
    SELECT 'Aktif' AS status
    UNION ALL
    SELECT 'Belum aktif' AS status
),
raw_status AS (
    SELECT
        CASE WHEN active_90d = 1 THEN 'Aktif' ELSE 'Belum aktif' END AS status,
        COUNT(*) AS member_count
    FROM activity
    GROUP BY 1
),
status_mix AS (
    SELECT
        s.status,
        COALESCE(r.member_count, 0) AS member_count
    FROM status_dim s
    LEFT JOIN raw_status r USING (status)
),
totals AS (
    SELECT SUM(member_count) AS total_members
    FROM status_mix
)
SELECT
    status,
    member_count,
    ROUND(member_count * 100.0 / NULLIF(total_members, 0), 1) AS pct_members
FROM status_mix, totals
ORDER BY CASE status WHEN 'Aktif' THEN 1 ELSE 2 END

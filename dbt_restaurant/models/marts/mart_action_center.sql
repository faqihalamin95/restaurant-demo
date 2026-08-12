with max_dates as (
    select
        (select max(order_date) from {{ ref('mart_daily_revenue') }}) as revenue_date,
        (select max(metric_date) from {{ ref('mart_daily_net_revenue') }}) as finance_date,
        (select max(txn_date) from {{ ref('mart_inventory_stok') }}) as inventory_date,
        (select max(order_date) from {{ ref('mart_menu_performance') }}) as menu_date,
        (select max(order_date) from {{ ref('mart_peak_hours') }}) as peak_date,
        (select max(attendance_date) from {{ ref('mart_employee_shift_performance') }}) as workforce_date,
        (select max(order_date) from {{ ref('mart_member_purchase_behavior') }}) as member_date
),

finance_latest as (
    select
        sum(gross_revenue) as gross_latest,
        sum(net_revenue) as net_latest,
        round(sum(net_revenue) / nullif(sum(gross_revenue), 0) * 100, 1) as margin_latest,
        sum(inventory_usage_cost) as ingredients_latest,
        sum(labor_total_cost) as labor_latest,
        sum(operational_total_cost) as ops_latest
    from {{ ref('mart_daily_net_revenue') }}, max_dates
    where metric_date = finance_date
),

finance_30d as (
    select
        sum(gross_revenue) as gross_30d,
        sum(net_revenue) as net_30d,
        round(sum(net_revenue) / nullif(sum(gross_revenue), 0) * 100, 1) as margin_30d
    from {{ ref('mart_daily_net_revenue') }}, max_dates
    where metric_date >= finance_date - interval '29 days'
),

branch_worst as (
    select
        branch_name,
        sum(gross_revenue) as gross_30d,
        sum(net_revenue) as net_30d,
        round(sum(net_revenue) / nullif(sum(gross_revenue), 0) * 100, 1) as margin_30d
    from {{ ref('mart_daily_net_revenue') }}, max_dates
    where metric_date >= finance_date - interval '29 days'
    group by branch_name
    order by margin_30d asc
    limit 1
),

inventory as (
    select
        count(*) as stock_points,
        count(distinct item_name) as total_items,
        sum(case when stock_status = 'low' or days_remaining < 3 then 1 else 0 end) as low_points,
        sum(case when stock_status = 'overstock' or days_remaining > 14 then 1 else 0 end) as overstock_points,
        round(sum(stock_value), 0) as stock_value,
        round(sum(case when stock_status = 'overstock' or days_remaining > 14 then stock_value else 0 end), 0) as overstock_value,
        round(sum(case when stock_status = 'overstock' or days_remaining > 14 then stock_value else 0 end) / nullif(sum(stock_value), 0) * 100, 1) as overstock_value_pct
    from {{ ref('mart_inventory_stok') }}, max_dates
    where txn_date = inventory_date
),

menu_periods as (
    select
        menu_name,
        sum(case when order_date >= menu_date - interval '29 days' then total_qty_sold else 0 end) as qty_30d,
        sum(case when order_date >= menu_date - interval '29 days' then total_revenue else 0 end) as revenue_30d,
        sum(case when order_date < menu_date - interval '29 days' and order_date >= menu_date - interval '59 days' then total_qty_sold else 0 end) as qty_prev_30d
    from {{ ref('mart_menu_performance') }}, max_dates
    where order_date >= menu_date - interval '59 days'
    group by menu_name
),

menu_base as (
    select *
    from menu_periods
    where qty_30d > 0
),

menu_medians as (
    select
        median(qty_30d) as median_qty_30d,
        median(revenue_30d) as median_revenue_30d
    from menu_base
),

menu_top5 as (
    select sum(revenue_30d) as top5_revenue_30d
    from (
        select revenue_30d
        from menu_base
        order by revenue_30d desc
        limit 5
    )
),

menu_summary as (
    select
        count(*) as active_menu_count,
        sum(qty_30d) as qty_30d,
        sum(revenue_30d) as revenue_30d,
        round(t.top5_revenue_30d * 100.0 / nullif(sum(b.revenue_30d), 0), 1) as top5_share_pct,
        sum(case when b.qty_30d < m.median_qty_30d and b.revenue_30d < m.median_revenue_30d then 1 else 0 end) as weak_menu_count,
        round(sum(case when b.qty_30d < m.median_qty_30d and b.revenue_30d < m.median_revenue_30d then 1 else 0 end) * 100.0 / nullif(count(*), 0), 1) as weak_menu_pct,
        sum(case when b.qty_prev_30d > 0 and b.qty_30d <= b.qty_prev_30d * 0.8 then 1 else 0 end) as declining_menu_count_30d
    from menu_base b
    cross join menu_medians m
    cross join menu_top5 t
    group by t.top5_revenue_30d
),

peak_hourly as (
    select
        order_hour,
        sum(total_orders) as total_orders
    from {{ ref('mart_peak_hours') }}, max_dates
    where order_date >= peak_date - interval '29 days'
    group by order_hour
),

peak_stats as (
    select
        sum(total_orders) as total_orders_30d,
        avg(total_orders) as avg_orders_per_hour,
        max(total_orders) as max_orders_per_hour
    from peak_hourly
),

peak_top3 as (
    select sum(total_orders) as top3_orders
    from (
        select total_orders
        from peak_hourly
        order by total_orders desc
        limit 3
    )
),

peak_primary as (
    select order_hour as primary_peak_hour
    from peak_hourly
    order by total_orders desc
    limit 1
),

peak_count as (
    select count(*) as peak_hour_count
    from peak_hourly h
    cross join peak_stats s
    where h.total_orders >= s.avg_orders_per_hour * 1.15
),

peak_summary as (
    select
        p.primary_peak_hour,
        c.peak_hour_count,
        round(t.top3_orders * 100.0 / nullif(s.total_orders_30d, 0), 1) as peak_share_pct,
        round(s.max_orders_per_hour * 1.0 / nullif(s.avg_orders_per_hour, 0), 2) as demand_surge,
        s.total_orders_30d
    from peak_stats s
    cross join peak_top3 t
    cross join peak_primary p
    cross join peak_count c
),

workforce as (
    select
        round(sum(case when attendance_status in ('present', 'late') then 1 else 0 end) * 100.0 / nullif(count(*), 0), 1) as attendance_rate_30d,
        round(sum(case when attendance_status = 'late' then 1 else 0 end) * 100.0 / nullif(sum(case when attendance_status in ('present', 'late') then 1 else 0 end), 0), 1) as late_rate_30d,
        sum(case when attendance_status = 'absent' then 1 else 0 end) as absent_30d,
        round(sum(case when overtime_hours > 0 then 1 else 0 end) * 100.0 / nullif(count(*), 0), 1) as overtime_session_pct_30d
    from {{ ref('mart_employee_shift_performance') }}, max_dates
    where attendance_date >= workforce_date - interval '29 days'
),

member_state as (
    select
        m.member_id,
        m.tier,
        coalesce(datediff('day', max(mp.order_date), (select member_date from max_dates)), 9999) as recency_days
    from {{ ref('dim_members') }} m
    left join {{ ref('mart_member_purchase_behavior') }} mp
        on m.member_id = mp.member_id
    group by m.member_id, m.tier
),

member_risk as (
    select
        sum(case
            when tier = 'Gold' and recency_days >= 14 then 1
            when tier = 'Silver' and recency_days >= 21 then 1
            when tier = 'Bronze' and recency_days >= 30 then 1
            else 0
        end) as churn_risk_members,
        sum(case when tier = 'Gold' and recency_days >= 14 then 1 else 0 end) as gold_churn_risk
    from member_state
),

scored as (
    select
        d.revenue_date,
        strftime('%d %b %Y', d.revenue_date) as revenue_date_label,
        strftime('%d %b %Y', least(d.revenue_date, d.finance_date, d.inventory_date, d.menu_date, d.peak_date, d.workforce_date, d.member_date)) as oldest_source_label,
        strftime('%d %b %Y', greatest(d.revenue_date, d.finance_date, d.inventory_date, d.menu_date, d.peak_date, d.workforce_date, d.member_date)) as newest_source_label,
        f.gross_latest,
        f.net_latest,
        f.margin_latest,
        f30.margin_30d,
        bw.branch_name as worst_branch,
        bw.margin_30d as worst_branch_margin_30d,
        bw.net_30d as worst_branch_net_30d,
        i.overstock_value,
        i.overstock_value_pct,
        i.low_points,
        i.overstock_points,
        i.stock_value,
        m.active_menu_count,
        m.top5_share_pct,
        m.weak_menu_count,
        m.weak_menu_pct,
        m.declining_menu_count_30d,
        ps.primary_peak_hour,
        ps.peak_hour_count,
        ps.peak_share_pct,
        ps.demand_surge,
        w.attendance_rate_30d,
        w.late_rate_30d,
        w.absent_30d,
        w.overtime_session_pct_30d,
        mr.churn_risk_members,
        mr.gold_churn_risk,
        (case when f.margin_latest < 0 then 35 when f.margin_latest < 10 then 25 when f.margin_latest < 15 then 12 else 0 end) +
        (case when bw.margin_30d < 0 then 25 when bw.margin_30d < 10 then 18 when bw.margin_30d < 15 then 8 else 0 end) +
        (case when i.overstock_value_pct >= 50 then 16 when i.overstock_value_pct >= 25 then 10 else 0 end) +
        (case when i.low_points > 0 then 8 else 0 end) +
        (case when m.top5_share_pct >= 70 or m.declining_menu_count_30d >= 5 or m.weak_menu_pct >= 40 then 12
              when m.top5_share_pct >= 55 or m.declining_menu_count_30d >= 2 or m.weak_menu_pct >= 25 then 7 else 0 end) +
        (case when ps.peak_share_pct > 65 or ps.demand_surge > 2.5 then 8
              when ps.peak_share_pct > 50 or ps.demand_surge > 1.5 then 4 else 0 end) +
        (case when w.attendance_rate_30d < 85 or w.late_rate_30d >= 20 or w.absent_30d >= 5 or w.overtime_session_pct_30d >= 35 then 8
              when w.attendance_rate_30d < 92 or w.late_rate_30d >= 10 or w.absent_30d >= 2 or w.overtime_session_pct_30d >= 20 then 4 else 0 end) +
        (case when mr.gold_churn_risk >= 3 then 6 when mr.gold_churn_risk >= 1 then 3 else 0 end) as risk_score
    from max_dates d
    cross join finance_latest f
    cross join finance_30d f30
    cross join branch_worst bw
    cross join inventory i
    cross join menu_summary m
    cross join peak_summary ps
    cross join workforce w
    cross join member_risk mr
),

pulse as (
    select
        *,
        case when risk_score >= 70 then 'Kritis' when risk_score >= 35 then 'Waspada' else 'Sehat' end as business_status,
        case when risk_score >= 70 then 'critical' when risk_score >= 35 then 'warning' else 'healthy' end as status_class,
        case
            when margin_latest < 0 then 'Margin harian negatif. Prioritas pertama adalah menahan kebocoran biaya dan memeriksa cabang paling lemah.'
            when worst_branch_margin_30d < 10 then 'Profitabilitas belum merata. Ada cabang yang perlu intervensi margin sebelum skala demand.'
            when overstock_value_pct >= 25 then 'Modal tertahan di inventory. Jadwal pembelian dan transfer antar cabang perlu diprioritaskan.'
            when top5_share_pct >= 70 then 'Revenue terlalu bertumpu pada sedikit menu. Jaga stok menu utama dan siapkan menu cadangan.'
            when peak_share_pct > 65 or demand_surge > 2.5 then 'Demand terkonsentrasi di jam puncak. Roster dan prep bahan perlu mengikuti window peak.'
            when late_rate_30d >= 10 then 'Disiplin shift mulai menekan operasional. Cek cabang dan jam dengan keterlambatan tertinggi.'
            else 'Kondisi operasional relatif terkendali. Tetap pantau margin, inventory, jam puncak, dan konsentrasi menu.'
        end as primary_diagnosis,
        'Rp' || cast(round(gross_latest / 1000000.0, 1) as varchar) || ' jt' as gross_latest_label,
        'Rp' || cast(round(net_latest / 1000000.0, 1) as varchar) || ' jt' as net_latest_label,
        cast(margin_latest as varchar) || '%' as margin_latest_label,
        cast(margin_30d as varchar) || '%' as margin_30d_label,
        'Rp' || cast(round(overstock_value / 1000000.0, 1) as varchar) || ' jt' as overstock_value_label,
        cast(top5_share_pct as varchar) || '%' as top5_share_label,
        cast(peak_share_pct as varchar) || '%' as peak_share_label,
        cast(late_rate_30d as varchar) || '%' as late_rate_label
    from scored
),

action_rows as (
    select
        1 as priority_rank,
        case when margin_latest < 10 then 'Kritis' when margin_latest < 15 then 'Waspada' else 'Pantau' end as severity,
        'Finance' as area,
        'Margin harian ' || cast(margin_latest as varchar) || '%' as issue,
        case when net_latest < 0 then 'Kerugian hari terakhir sekitar Rp' || cast(round(abs(net_latest) / 1000000.0, 1) as varchar) || ' jt'
             else 'Net revenue hari terakhir Rp' || cast(round(net_latest / 1000000.0, 1) as varchar) || ' jt' end as impact,
        'Cek komponen bahan, SDM, dan operasional. Mulai dari transaksi/cost terbesar hari terakhir.' as recommended_action,
        '/01-laporan-keuangan' as detail_path,
        110 + case when margin_latest < 0 then 30 when margin_latest < 10 then 20 when margin_latest < 15 then 8 else 0 end as sort_score
    from pulse

    union all

    select
        2,
        case when worst_branch_margin_30d < 10 then 'Kritis' when worst_branch_margin_30d < 15 then 'Waspada' else 'Pantau' end,
        'Branch',
        worst_branch || ' margin 30 hari ' || cast(worst_branch_margin_30d as varchar) || '%',
        case when worst_branch_net_30d < 0 then 'Kerugian 30 hari sekitar Rp' || cast(round(abs(worst_branch_net_30d) / 1000000.0, 1) as varchar) || ' jt'
             else 'Net 30 hari Rp' || cast(round(worst_branch_net_30d / 1000000.0, 1) as varchar) || ' jt' end,
        'Audit cabang terlemah: food cost, roster, promo, dan order mix. Jangan tambah demand sebelum margin bocor ditutup.',
        '/02-branch-performance',
        100 + case when worst_branch_margin_30d < 0 then 25 when worst_branch_margin_30d < 10 then 15 when worst_branch_margin_30d < 15 then 7 else 0 end
    from pulse

    union all

    select
        3,
        case when overstock_value_pct >= 50 then 'Kritis' when overstock_value_pct >= 25 or low_points > 0 then 'Waspada' else 'Pantau' end,
        'Inventory',
        'Overstock ' || cast(overstock_value_pct as varchar) || '% dari nilai stok',
        'Modal tertahan sekitar Rp' || cast(round(overstock_value / 1000000.0, 1) as varchar) || ' jt; ' || cast(low_points as varchar) || ' titik low stock',
        'Tahan PO item berlebih, cek kandidat transfer antar cabang, lalu push menu yang memakai stok tersebut.',
        '/03-inventori-stok',
        90 + case when overstock_value_pct >= 50 then 20 when overstock_value_pct >= 25 then 10 when low_points > 0 then 6 else 0 end
    from pulse

    union all

    select
        4,
        case when peak_share_pct > 65 or demand_surge > 2.5 then 'Kritis' when peak_share_pct > 50 or demand_surge > 1.5 then 'Waspada' else 'Pantau' end,
        'Peak Hours',
        'Top 3 jam menyumbang ' || cast(peak_share_pct as varchar) || '% order',
        'Jam tersibuk ' || cast(demand_surge as varchar) || 'x volume normal; peak utama sekitar ' || cast(primary_peak_hour as varchar) || ':00',
        'Sesuaikan roster, prep bahan, dan briefing ke window puncak. Pisahkan template weekday/weekend di halaman detail.',
        '/04-peak-hours',
        80 + case when peak_share_pct > 65 or demand_surge > 2.5 then 16 when peak_share_pct > 50 or demand_surge > 1.5 then 8 else 0 end
    from pulse

    union all

    select
        5,
        case when top5_share_pct >= 70 or declining_menu_count_30d >= 5 or weak_menu_pct >= 40 then 'Kritis'
             when top5_share_pct >= 55 or declining_menu_count_30d >= 2 or weak_menu_pct >= 25 then 'Waspada' else 'Pantau' end,
        'Menu',
        'Top 5 menu menyumbang ' || cast(top5_share_pct as varchar) || '% revenue',
        cast(weak_menu_count as varchar) || ' menu lemah; ' || cast(declining_menu_count_30d as varchar) || ' menu turun >=20% vs 30H sebelumnya',
        'Jaga stok menu utama, dorong menu alternatif, dan pilih menu lemah untuk promo, bundling, atau pensiun.',
        '/05-menu-performance',
        70 + case when top5_share_pct >= 70 or declining_menu_count_30d >= 5 or weak_menu_pct >= 40 then 18
                  when top5_share_pct >= 55 or declining_menu_count_30d >= 2 or weak_menu_pct >= 25 then 8 else 0 end
    from pulse

    union all

    select
        6,
        case when attendance_rate_30d < 85 or late_rate_30d >= 20 or absent_30d >= 5 or overtime_session_pct_30d >= 35 then 'Kritis'
             when attendance_rate_30d < 92 or late_rate_30d >= 10 or absent_30d >= 2 or overtime_session_pct_30d >= 20 then 'Waspada' else 'Pantau' end,
        'Workforce',
        'Late rate 30 hari ' || cast(late_rate_30d as varchar) || '%',
        cast(absent_30d as varchar) || ' sesi absent; attendance ' || cast(attendance_rate_30d as varchar) || '%',
        'Review cabang/shift dengan keterlambatan tertinggi. Perbaiki roster sebelum jam puncak siang dan malam.',
        '/07-employee-performance',
        60 + case when attendance_rate_30d < 85 or late_rate_30d >= 20 or absent_30d >= 5 or overtime_session_pct_30d >= 35 then 12
                  when attendance_rate_30d < 92 or late_rate_30d >= 10 or absent_30d >= 2 or overtime_session_pct_30d >= 20 then 6 else 0 end
    from pulse

    union all

    select
        7,
        case when gold_churn_risk >= 3 then 'Kritis' when gold_churn_risk >= 1 or churn_risk_members >= 5 then 'Waspada' else 'Pantau' end,
        'Member',
        cast(gold_churn_risk as varchar) || ' Gold member berisiko churn',
        cast(churn_risk_members as varchar) || ' total member masuk daftar win-back',
        'Hubungi Gold member terlebih dulu dengan benefit personal. Hindari broadcast generik untuk member bernilai tinggi.',
        '/06-member-behavior',
        50 + case when gold_churn_risk >= 3 then 10 when gold_churn_risk >= 1 or churn_risk_members >= 5 then 5 else 0 end
    from pulse
),

kpi_rows as (
    select 'Gross Revenue' as metric, gross_latest_label as value, 'Hari terakhir' as context, 'Finance' as area, 1 as sort_order from pulse
    union all select 'Net Margin', margin_latest_label, 'Hari terakhir', 'Finance', 2 from pulse
    union all select 'Margin 30 Hari', margin_30d_label, 'Semua cabang', 'Finance', 3 from pulse
    union all select 'Cabang Terlemah', worst_branch || ' · ' || cast(worst_branch_margin_30d as varchar) || '%', 'Margin 30 hari', 'Branch', 4 from pulse
    union all select 'Overstock', overstock_value_label, 'Modal tertahan', 'Inventory', 5 from pulse
    union all select 'Top 5 Menu Share', top5_share_label, 'Konsentrasi revenue', 'Menu', 6 from pulse
    union all select 'Peak Share', peak_share_label, 'Top 3 jam order', 'Peak Hours', 7 from pulse
    union all select 'Late Rate', late_rate_label, '30 hari terakhir', 'Workforce', 8 from pulse
),

diagnosis_rows as (
    select
        'Finance' as area,
        case when margin_latest < 10 then 'Kritis' when margin_latest < 15 then 'Waspada' else 'Sehat' end as status,
        'Margin hari terakhir ' || margin_latest_label || ', margin 30 hari ' || margin_30d_label || '.' as diagnosis,
        'Tutup kebocoran biaya sebelum mengejar pertumbuhan revenue.' as next_action,
        '/01-laporan-keuangan' as detail_path,
        1 as sort_order
    from pulse
    union all
    select 'Branch',
        case when worst_branch_margin_30d < 10 then 'Kritis' when worst_branch_margin_30d < 15 then 'Waspada' else 'Sehat' end,
        worst_branch || ' menjadi cabang margin terlemah 30 hari: ' || cast(worst_branch_margin_30d as varchar) || '%.',
        'Pisahkan masalah demand dari masalah biaya sebelum membuat promo cabang.',
        '/02-branch-performance',
        2
    from pulse
    union all
    select 'Inventory',
        case when overstock_value_pct >= 50 then 'Kritis' when overstock_value_pct >= 25 or low_points > 0 then 'Waspada' else 'Sehat' end,
        'Overstock ' || cast(overstock_value_pct as varchar) || '% dengan nilai ' || overstock_value_label || '; ' || cast(low_points as varchar) || ' titik low stock.',
        'Tahan PO, transfer stok, dan push menu yang menyerap item berlebih.',
        '/03-inventori-stok',
        3
    from pulse
    union all
    select 'Peak Hours',
        case when peak_share_pct > 65 or demand_surge > 2.5 then 'Kritis' when peak_share_pct > 50 or demand_surge > 1.5 then 'Waspada' else 'Sehat' end,
        'Top 3 jam menyumbang ' || peak_share_label || ' order; surge jam tersibuk ' || cast(demand_surge as varchar) || 'x.',
        'Sesuaikan roster dan prep bahan berdasarkan window peak aktual.',
        '/04-peak-hours',
        4
    from pulse
    union all
    select 'Menu',
        case when top5_share_pct >= 70 or declining_menu_count_30d >= 5 or weak_menu_pct >= 40 then 'Kritis'
             when top5_share_pct >= 55 or declining_menu_count_30d >= 2 or weak_menu_pct >= 25 then 'Waspada' else 'Sehat' end,
        'Top 5 menu menyumbang ' || top5_share_label || ' revenue; ' || cast(weak_menu_count as varchar) || ' menu lemah.',
        'Lindungi stok menu utama dan siapkan eksperimen menu alternatif.',
        '/05-menu-performance',
        5
    from pulse
    union all
    select 'Member',
        case when gold_churn_risk >= 3 then 'Kritis' when gold_churn_risk >= 1 or churn_risk_members >= 5 then 'Waspada' else 'Sehat' end,
        cast(gold_churn_risk as varchar) || ' Gold berisiko churn dari total ' || cast(churn_risk_members as varchar) || ' member risk.',
        'Prioritaskan win-back personal untuk Gold sebelum broadcast massal.',
        '/06-member-behavior',
        6
    from pulse
    union all
    select 'Workforce',
        case when attendance_rate_30d < 85 or late_rate_30d >= 20 or absent_30d >= 5 or overtime_session_pct_30d >= 35 then 'Kritis'
             when attendance_rate_30d < 92 or late_rate_30d >= 10 or absent_30d >= 2 or overtime_session_pct_30d >= 20 then 'Waspada' else 'Sehat' end,
        'Late rate 30 hari ' || late_rate_label || ', attendance ' || cast(attendance_rate_30d as varchar) || '%.',
        'Cek shift dan cabang yang mendorong keterlambatan.',
        '/07-employee-performance',
        7
    from pulse
),


summary_rows as (
    select
        1 as sort_order,
        'Status' as metric,
        business_status as value,
        'Margin terbaru ' || margin_latest_label || '.' as context,
        case when business_status = 'Kritis' then 'kritis' when business_status = 'Waspada' then 'waspada' else 'sehat' end as status,
        'Business' as area
    from pulse

    union all

    select
        2,
        'Margin',
        net_latest_label,
        '30 hari: ' || margin_30d_label || '.',
        case when margin_latest < 10 then 'kritis' when margin_latest < 15 then 'waspada' else 'sehat' end,
        'Finance'
    from pulse

    union all

    select
        3,
        'Cabang',
        worst_branch,
        'Margin 30 hari ' || cast(worst_branch_margin_30d as varchar) || '%.',
        case when worst_branch_margin_30d < 10 then 'kritis' when worst_branch_margin_30d < 15 then 'waspada' else 'sehat' end,
        'Branch'
    from pulse

    union all

    select
        4,
        'Risiko',
        case
            when overstock_value_pct >= 25 then 'Inventory'
            when top5_share_pct >= 55 then 'Menu'
            when late_rate_30d >= 10 then 'Workforce'
            when gold_churn_risk >= 1 then 'Member'
            else 'Stabil'
        end,
        case
            when overstock_value_pct >= 25 then 'Overstock ' || cast(overstock_value_pct as varchar) || '% · ' || overstock_value_label || '.'
            when top5_share_pct >= 55 then 'Top 5 menu ' || top5_share_label || ' revenue.'
            when late_rate_30d >= 10 then 'Late rate ' || late_rate_label || '.'
            when gold_churn_risk >= 1 then cast(gold_churn_risk as varchar) || ' Gold risk.'
            else 'Tidak ada sinyal besar.'
        end,
        case
            when overstock_value_pct >= 50 or top5_share_pct >= 70 or late_rate_30d >= 20 or gold_churn_risk >= 3 then 'kritis'
            when overstock_value_pct >= 25 or top5_share_pct >= 55 or late_rate_30d >= 10 or gold_churn_risk >= 1 then 'waspada'
            else 'netral'
        end,
        case
            when overstock_value_pct >= 25 then 'Inventory'
            when top5_share_pct >= 55 then 'Menu'
            when late_rate_30d >= 10 then 'Workforce'
            when gold_churn_risk >= 1 then 'Member'
            else 'Operations'
        end
    from pulse
),
menu_movers_7d as (
    select
        menu_name,
        sum(case when order_date >= menu_date - interval '6 days' then total_qty_sold else 0 end) as qty_7d,
        sum(case when order_date < menu_date - interval '6 days' and order_date >= menu_date - interval '13 days' then total_qty_sold else 0 end) as qty_prev_7d
    from {{ ref('mart_menu_performance') }}, max_dates
    where order_date >= menu_date - interval '13 days'
    group by menu_name
),

declining_menu as (
    select
        menu_name,
        round((qty_7d - qty_prev_7d) * 100.0 / nullif(qty_prev_7d, 0), 1) as qty_change_pct,
        row_number() over (order by round((qty_7d - qty_prev_7d) * 100.0 / nullif(qty_prev_7d, 0), 1) asc) as rn
    from menu_movers_7d
    where qty_prev_7d > 0
      and (qty_7d - qty_prev_7d) * 100.0 / nullif(qty_prev_7d, 0) <= -20
),

supplier_alert as (
    select
        item_name,
        round((avg(avg_unit_cost) - avg(base_unit_cost)) / nullif(avg(base_unit_cost), 0) * 100, 1) as price_variance_pct,
        row_number() over (order by round((avg(avg_unit_cost) - avg(base_unit_cost)) / nullif(avg(base_unit_cost), 0) * 100, 1) desc) as rn
    from {{ ref('mart_inventory_stok') }}, max_dates
    where txn_date >= inventory_date - interval '29 days'
    group by item_name
    having (avg(avg_unit_cost) - avg(base_unit_cost)) / nullif(avg(base_unit_cost), 0) * 100 > 10
),

low_stock_alert as (
    select
        item_name,
        branch_name,
        days_remaining,
        row_number() over (order by days_remaining asc) as rn
    from {{ ref('mart_inventory_stok') }}, max_dates
    where txn_date = inventory_date
      and (stock_status = 'low' or days_remaining < 3)
),

watchlist_rows as (
    select
        'Menu' as area,
        menu_name as item,
        'Qty 7 hari turun ' || cast(qty_change_pct as varchar) || '% vs minggu sebelumnya' as reason,
        'Validasi stok, harga, kualitas, dan display menu.' as next_check,
        rn as sort_order
    from declining_menu
    where rn <= 3

    union all

    select
        'Supplier',
        item_name,
        'Harga beli rata-rata naik ' || cast(price_variance_pct as varchar) || '% vs harga dasar',
        'Bandingkan supplier dan cek kontrak harga.',
        10 + rn
    from supplier_alert
    where rn <= 3

    union all

    select
        'Inventory',
        item_name || ' · ' || branch_name,
        'Coverage tinggal ' || cast(round(days_remaining, 1) as varchar) || ' hari',
        'Cek reorder atau transfer antar cabang hari ini.',
        20 + rn
    from low_stock_alert
    where rn <= 2
),

final_rows as (
    select
        'data_freshness' as section,
        'data_freshness' as row_key,
        1 as sort_order,
        cast(null as integer) as priority_rank,
        cast(null as varchar) as severity,
        cast(null as varchar) as status,
        cast(null as varchar) as area,
        cast(null as varchar) as metric,
        cast(null as varchar) as value,
        cast(null as varchar) as context,
        cast(null as varchar) as issue,
        cast(null as varchar) as impact,
        cast(null as varchar) as recommended_action,
        cast(null as varchar) as detail_path,
        cast(null as double) as sort_score,
        cast(null as varchar) as diagnosis,
        cast(null as varchar) as next_action,
        cast(null as varchar) as item,
        cast(null as varchar) as reason,
        cast(null as varchar) as next_check,
        revenue_date as revenue_date,
        revenue_date_label as revenue_date_label,
        oldest_source_label as oldest_source_label,
        newest_source_label as newest_source_label,
        cast(null as varchar) as business_status,
        cast(null as varchar) as status_class,
        cast(null as varchar) as primary_diagnosis,
        cast(null as double) as gross_latest,
        cast(null as double) as net_latest,
        cast(null as double) as margin_latest,
        cast(null as double) as margin_30d,
        cast(null as varchar) as worst_branch,
        cast(null as double) as worst_branch_margin_30d,
        cast(null as double) as overstock_value,
        cast(null as double) as overstock_value_pct,
        cast(null as integer) as low_points,
        cast(null as integer) as overstock_points,
        cast(null as integer) as active_menu_count,
        cast(null as double) as top5_share_pct,
        cast(null as integer) as weak_menu_count,
        cast(null as double) as weak_menu_pct,
        cast(null as integer) as declining_menu_count_30d,
        cast(null as integer) as primary_peak_hour,
        cast(null as double) as peak_share_pct,
        cast(null as double) as demand_surge,
        cast(null as double) as attendance_rate_30d,
        cast(null as double) as late_rate_30d,
        cast(null as integer) as absent_30d,
        cast(null as double) as overtime_session_pct_30d,
        cast(null as integer) as churn_risk_members,
        cast(null as integer) as gold_churn_risk,
        cast(null as double) as risk_score,
        cast(null as varchar) as gross_latest_label,
        cast(null as varchar) as net_latest_label,
        cast(null as varchar) as margin_latest_label,
        cast(null as varchar) as margin_30d_label,
        cast(null as varchar) as overstock_value_label,
        cast(null as varchar) as top5_share_label,
        cast(null as varchar) as peak_share_label,
        cast(null as varchar) as late_rate_label
    from pulse

    union all

    select
        'business_pulse' as section,
        'business_pulse' as row_key,
        1 as sort_order,
        cast(null as integer) as priority_rank,
        cast(null as varchar) as severity,
        cast(null as varchar) as status,
        cast(null as varchar) as area,
        cast(null as varchar) as metric,
        cast(null as varchar) as value,
        cast(null as varchar) as context,
        cast(null as varchar) as issue,
        cast(null as varchar) as impact,
        cast(null as varchar) as recommended_action,
        cast(null as varchar) as detail_path,
        cast(null as double) as sort_score,
        cast(null as varchar) as diagnosis,
        cast(null as varchar) as next_action,
        cast(null as varchar) as item,
        cast(null as varchar) as reason,
        cast(null as varchar) as next_check,
        revenue_date as revenue_date,
        revenue_date_label as revenue_date_label,
        oldest_source_label as oldest_source_label,
        newest_source_label as newest_source_label,
        business_status as business_status,
        status_class as status_class,
        primary_diagnosis as primary_diagnosis,
        gross_latest as gross_latest,
        net_latest as net_latest,
        margin_latest as margin_latest,
        margin_30d as margin_30d,
        worst_branch as worst_branch,
        worst_branch_margin_30d as worst_branch_margin_30d,
        overstock_value as overstock_value,
        overstock_value_pct as overstock_value_pct,
        cast(low_points as integer) as low_points,
        cast(overstock_points as integer) as overstock_points,
        cast(active_menu_count as integer) as active_menu_count,
        top5_share_pct as top5_share_pct,
        cast(weak_menu_count as integer) as weak_menu_count,
        weak_menu_pct as weak_menu_pct,
        cast(declining_menu_count_30d as integer) as declining_menu_count_30d,
        cast(primary_peak_hour as integer) as primary_peak_hour,
        peak_share_pct as peak_share_pct,
        demand_surge as demand_surge,
        attendance_rate_30d as attendance_rate_30d,
        late_rate_30d as late_rate_30d,
        cast(absent_30d as integer) as absent_30d,
        overtime_session_pct_30d as overtime_session_pct_30d,
        cast(churn_risk_members as integer) as churn_risk_members,
        cast(gold_churn_risk as integer) as gold_churn_risk,
        risk_score as risk_score,
        gross_latest_label as gross_latest_label,
        net_latest_label as net_latest_label,
        margin_latest_label as margin_latest_label,
        margin_30d_label as margin_30d_label,
        overstock_value_label as overstock_value_label,
        top5_share_label as top5_share_label,
        peak_share_label as peak_share_label,
        late_rate_label as late_rate_label
    from pulse

    union all

    select
        'summary_cards' as section,
        'summary_' || cast(sort_order as varchar) as row_key,
        sort_order as sort_order,
        cast(null as integer) as priority_rank,
        cast(null as varchar) as severity,
        status as status,
        area as area,
        metric as metric,
        value as value,
        context as context,
        cast(null as varchar) as issue,
        cast(null as varchar) as impact,
        cast(null as varchar) as recommended_action,
        cast(null as varchar) as detail_path,
        cast(null as double) as sort_score,
        cast(null as varchar) as diagnosis,
        cast(null as varchar) as next_action,
        cast(null as varchar) as item,
        cast(null as varchar) as reason,
        cast(null as varchar) as next_check,
        cast(null as date) as revenue_date,
        cast(null as varchar) as revenue_date_label,
        cast(null as varchar) as oldest_source_label,
        cast(null as varchar) as newest_source_label,
        cast(null as varchar) as business_status,
        cast(null as varchar) as status_class,
        cast(null as varchar) as primary_diagnosis,
        cast(null as double) as gross_latest,
        cast(null as double) as net_latest,
        cast(null as double) as margin_latest,
        cast(null as double) as margin_30d,
        cast(null as varchar) as worst_branch,
        cast(null as double) as worst_branch_margin_30d,
        cast(null as double) as overstock_value,
        cast(null as double) as overstock_value_pct,
        cast(null as integer) as low_points,
        cast(null as integer) as overstock_points,
        cast(null as integer) as active_menu_count,
        cast(null as double) as top5_share_pct,
        cast(null as integer) as weak_menu_count,
        cast(null as double) as weak_menu_pct,
        cast(null as integer) as declining_menu_count_30d,
        cast(null as integer) as primary_peak_hour,
        cast(null as double) as peak_share_pct,
        cast(null as double) as demand_surge,
        cast(null as double) as attendance_rate_30d,
        cast(null as double) as late_rate_30d,
        cast(null as integer) as absent_30d,
        cast(null as double) as overtime_session_pct_30d,
        cast(null as integer) as churn_risk_members,
        cast(null as integer) as gold_churn_risk,
        cast(null as double) as risk_score,
        cast(null as varchar) as gross_latest_label,
        cast(null as varchar) as net_latest_label,
        cast(null as varchar) as margin_latest_label,
        cast(null as varchar) as margin_30d_label,
        cast(null as varchar) as overstock_value_label,
        cast(null as varchar) as top5_share_label,
        cast(null as varchar) as peak_share_label,
        cast(null as varchar) as late_rate_label
    from summary_rows

    union all

    select
        'action_queue' as section,
        'action_' || cast(priority_rank as varchar) as row_key,
        priority_rank as sort_order,
        priority_rank as priority_rank,
        severity as severity,
        cast(null as varchar) as status,
        area as area,
        cast(null as varchar) as metric,
        cast(null as varchar) as value,
        cast(null as varchar) as context,
        issue as issue,
        impact as impact,
        recommended_action as recommended_action,
        detail_path as detail_path,
        sort_score as sort_score,
        cast(null as varchar) as diagnosis,
        cast(null as varchar) as next_action,
        cast(null as varchar) as item,
        cast(null as varchar) as reason,
        cast(null as varchar) as next_check,
        cast(null as date) as revenue_date,
        cast(null as varchar) as revenue_date_label,
        cast(null as varchar) as oldest_source_label,
        cast(null as varchar) as newest_source_label,
        cast(null as varchar) as business_status,
        cast(null as varchar) as status_class,
        cast(null as varchar) as primary_diagnosis,
        cast(null as double) as gross_latest,
        cast(null as double) as net_latest,
        cast(null as double) as margin_latest,
        cast(null as double) as margin_30d,
        cast(null as varchar) as worst_branch,
        cast(null as double) as worst_branch_margin_30d,
        cast(null as double) as overstock_value,
        cast(null as double) as overstock_value_pct,
        cast(null as integer) as low_points,
        cast(null as integer) as overstock_points,
        cast(null as integer) as active_menu_count,
        cast(null as double) as top5_share_pct,
        cast(null as integer) as weak_menu_count,
        cast(null as double) as weak_menu_pct,
        cast(null as integer) as declining_menu_count_30d,
        cast(null as integer) as primary_peak_hour,
        cast(null as double) as peak_share_pct,
        cast(null as double) as demand_surge,
        cast(null as double) as attendance_rate_30d,
        cast(null as double) as late_rate_30d,
        cast(null as integer) as absent_30d,
        cast(null as double) as overtime_session_pct_30d,
        cast(null as integer) as churn_risk_members,
        cast(null as integer) as gold_churn_risk,
        cast(null as double) as risk_score,
        cast(null as varchar) as gross_latest_label,
        cast(null as varchar) as net_latest_label,
        cast(null as varchar) as margin_latest_label,
        cast(null as varchar) as margin_30d_label,
        cast(null as varchar) as overstock_value_label,
        cast(null as varchar) as top5_share_label,
        cast(null as varchar) as peak_share_label,
        cast(null as varchar) as late_rate_label
    from action_rows

    union all

    select
        'kpi_summary' as section,
        'kpi_' || cast(sort_order as varchar) as row_key,
        sort_order as sort_order,
        cast(null as integer) as priority_rank,
        cast(null as varchar) as severity,
        cast(null as varchar) as status,
        area as area,
        metric as metric,
        value as value,
        context as context,
        cast(null as varchar) as issue,
        cast(null as varchar) as impact,
        cast(null as varchar) as recommended_action,
        cast(null as varchar) as detail_path,
        cast(null as double) as sort_score,
        cast(null as varchar) as diagnosis,
        cast(null as varchar) as next_action,
        cast(null as varchar) as item,
        cast(null as varchar) as reason,
        cast(null as varchar) as next_check,
        cast(null as date) as revenue_date,
        cast(null as varchar) as revenue_date_label,
        cast(null as varchar) as oldest_source_label,
        cast(null as varchar) as newest_source_label,
        cast(null as varchar) as business_status,
        cast(null as varchar) as status_class,
        cast(null as varchar) as primary_diagnosis,
        cast(null as double) as gross_latest,
        cast(null as double) as net_latest,
        cast(null as double) as margin_latest,
        cast(null as double) as margin_30d,
        cast(null as varchar) as worst_branch,
        cast(null as double) as worst_branch_margin_30d,
        cast(null as double) as overstock_value,
        cast(null as double) as overstock_value_pct,
        cast(null as integer) as low_points,
        cast(null as integer) as overstock_points,
        cast(null as integer) as active_menu_count,
        cast(null as double) as top5_share_pct,
        cast(null as integer) as weak_menu_count,
        cast(null as double) as weak_menu_pct,
        cast(null as integer) as declining_menu_count_30d,
        cast(null as integer) as primary_peak_hour,
        cast(null as double) as peak_share_pct,
        cast(null as double) as demand_surge,
        cast(null as double) as attendance_rate_30d,
        cast(null as double) as late_rate_30d,
        cast(null as integer) as absent_30d,
        cast(null as double) as overtime_session_pct_30d,
        cast(null as integer) as churn_risk_members,
        cast(null as integer) as gold_churn_risk,
        cast(null as double) as risk_score,
        cast(null as varchar) as gross_latest_label,
        cast(null as varchar) as net_latest_label,
        cast(null as varchar) as margin_latest_label,
        cast(null as varchar) as margin_30d_label,
        cast(null as varchar) as overstock_value_label,
        cast(null as varchar) as top5_share_label,
        cast(null as varchar) as peak_share_label,
        cast(null as varchar) as late_rate_label
    from kpi_rows

    union all

    select
        'area_diagnosis' as section,
        'diagnosis_' || cast(sort_order as varchar) as row_key,
        sort_order as sort_order,
        cast(null as integer) as priority_rank,
        cast(null as varchar) as severity,
        status as status,
        area as area,
        cast(null as varchar) as metric,
        cast(null as varchar) as value,
        cast(null as varchar) as context,
        cast(null as varchar) as issue,
        cast(null as varchar) as impact,
        cast(null as varchar) as recommended_action,
        detail_path as detail_path,
        cast(null as double) as sort_score,
        diagnosis as diagnosis,
        next_action as next_action,
        cast(null as varchar) as item,
        cast(null as varchar) as reason,
        cast(null as varchar) as next_check,
        cast(null as date) as revenue_date,
        cast(null as varchar) as revenue_date_label,
        cast(null as varchar) as oldest_source_label,
        cast(null as varchar) as newest_source_label,
        cast(null as varchar) as business_status,
        cast(null as varchar) as status_class,
        cast(null as varchar) as primary_diagnosis,
        cast(null as double) as gross_latest,
        cast(null as double) as net_latest,
        cast(null as double) as margin_latest,
        cast(null as double) as margin_30d,
        cast(null as varchar) as worst_branch,
        cast(null as double) as worst_branch_margin_30d,
        cast(null as double) as overstock_value,
        cast(null as double) as overstock_value_pct,
        cast(null as integer) as low_points,
        cast(null as integer) as overstock_points,
        cast(null as integer) as active_menu_count,
        cast(null as double) as top5_share_pct,
        cast(null as integer) as weak_menu_count,
        cast(null as double) as weak_menu_pct,
        cast(null as integer) as declining_menu_count_30d,
        cast(null as integer) as primary_peak_hour,
        cast(null as double) as peak_share_pct,
        cast(null as double) as demand_surge,
        cast(null as double) as attendance_rate_30d,
        cast(null as double) as late_rate_30d,
        cast(null as integer) as absent_30d,
        cast(null as double) as overtime_session_pct_30d,
        cast(null as integer) as churn_risk_members,
        cast(null as integer) as gold_churn_risk,
        cast(null as double) as risk_score,
        cast(null as varchar) as gross_latest_label,
        cast(null as varchar) as net_latest_label,
        cast(null as varchar) as margin_latest_label,
        cast(null as varchar) as margin_30d_label,
        cast(null as varchar) as overstock_value_label,
        cast(null as varchar) as top5_share_label,
        cast(null as varchar) as peak_share_label,
        cast(null as varchar) as late_rate_label
    from diagnosis_rows

    union all

    select
        'watchlist' as section,
        'watch_' || cast(sort_order as varchar) as row_key,
        sort_order as sort_order,
        cast(null as integer) as priority_rank,
        cast(null as varchar) as severity,
        cast(null as varchar) as status,
        area as area,
        cast(null as varchar) as metric,
        cast(null as varchar) as value,
        cast(null as varchar) as context,
        cast(null as varchar) as issue,
        cast(null as varchar) as impact,
        cast(null as varchar) as recommended_action,
        cast(null as varchar) as detail_path,
        cast(null as double) as sort_score,
        cast(null as varchar) as diagnosis,
        cast(null as varchar) as next_action,
        item as item,
        reason as reason,
        next_check as next_check,
        cast(null as date) as revenue_date,
        cast(null as varchar) as revenue_date_label,
        cast(null as varchar) as oldest_source_label,
        cast(null as varchar) as newest_source_label,
        cast(null as varchar) as business_status,
        cast(null as varchar) as status_class,
        cast(null as varchar) as primary_diagnosis,
        cast(null as double) as gross_latest,
        cast(null as double) as net_latest,
        cast(null as double) as margin_latest,
        cast(null as double) as margin_30d,
        cast(null as varchar) as worst_branch,
        cast(null as double) as worst_branch_margin_30d,
        cast(null as double) as overstock_value,
        cast(null as double) as overstock_value_pct,
        cast(null as integer) as low_points,
        cast(null as integer) as overstock_points,
        cast(null as integer) as active_menu_count,
        cast(null as double) as top5_share_pct,
        cast(null as integer) as weak_menu_count,
        cast(null as double) as weak_menu_pct,
        cast(null as integer) as declining_menu_count_30d,
        cast(null as integer) as primary_peak_hour,
        cast(null as double) as peak_share_pct,
        cast(null as double) as demand_surge,
        cast(null as double) as attendance_rate_30d,
        cast(null as double) as late_rate_30d,
        cast(null as integer) as absent_30d,
        cast(null as double) as overtime_session_pct_30d,
        cast(null as integer) as churn_risk_members,
        cast(null as integer) as gold_churn_risk,
        cast(null as double) as risk_score,
        cast(null as varchar) as gross_latest_label,
        cast(null as varchar) as net_latest_label,
        cast(null as varchar) as margin_latest_label,
        cast(null as varchar) as margin_30d_label,
        cast(null as varchar) as overstock_value_label,
        cast(null as varchar) as top5_share_label,
        cast(null as varchar) as peak_share_label,
        cast(null as varchar) as late_rate_label
    from watchlist_rows
)

select * from final_rows

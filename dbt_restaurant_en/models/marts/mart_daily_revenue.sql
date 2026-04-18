with daily as (
    select
        order_date,
        branch_id,
        count(distinct order_id)        as total_orders,
        sum(subtotal)                   as total_revenue,
        sum(qty)                        as total_items_sold,
        count(distinct case when order_type = 'delivery' then order_id end) as delivery_orders,
        count(distinct case when order_type = 'dine_in'  then order_id end) as dine_in_orders,
        count(distinct case when order_type = 'takeaway' then order_id end) as takeaway_orders
    from {{ ref('fct_orders') }}
    group by order_date, branch_id
),

-- Same-day-of-week (SDOW) rolling average — excludes current day
with_rolling as (
    select
        d.order_date,
        d.branch_id,
        b.branch_name,
        b.branch_location,
        d.total_orders,
        d.total_revenue,
        d.total_items_sold,
        d.delivery_orders,
        d.dine_in_orders,
        d.takeaway_orders,
        avg(d2.total_revenue) as revenue_sdow_avg
    from daily d
    left join daily d2
        on  d.branch_id              = d2.branch_id
        and d2.order_date            < d.order_date
        and d2.order_date            >= d.order_date - interval '30 days'
        and dayofweek(d2.order_date) = dayofweek(d.order_date)
    left join {{ ref('dim_branches') }} b
        on d.branch_id = b.branch_id
    group by
        d.order_date, d.branch_id,
        b.branch_name, b.branch_location,
        d.total_orders, d.total_revenue, d.total_items_sold,
        d.delivery_orders, d.dine_in_orders, d.takeaway_orders
),

final_calc as (
    select
        *,
        case
            when revenue_sdow_avg = 0 or revenue_sdow_avg is null then null
            else round(
                (total_revenue - revenue_sdow_avg) / revenue_sdow_avg, 4
            )
        end as pct_change_vs_sdow_avg
    from with_rolling
)

select * from final_calc
order by order_date desc, total_revenue desc

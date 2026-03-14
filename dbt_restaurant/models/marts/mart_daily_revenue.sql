with daily as (
    select
        order_date,
        branch_id,
        count(distinct order_id)        as total_orders,
        sum(subtotal)                   as total_revenue,
        sum(qty)                        as total_items_sold,
        count(distinct case
            when order_type = 'delivery' then order_id
        end)                            as delivery_orders,
        count(distinct case
            when order_type = 'dine_in' then order_id
        end)                            as dine_in_orders,
        count(distinct case
            when order_type = 'takeaway' then order_id
        end)                            as takeaway_orders
    from {{ ref('fct_orders') }}
    group by order_date, branch_id
),

-- 7-day rolling average per branch for anomaly detection
with_rolling as (
    select
        d.*,
        b.branch_name,
        b.branch_location,
        avg(d.total_revenue) over (
            partition by d.branch_id
            order by d.order_date
            rows between 6 preceding and current row
        )                               as revenue_7d_avg,

        -- % change vs 7-day avg — drives Telegram early warning
        case
            when avg(d.total_revenue) over (
                partition by d.branch_id
                order by d.order_date
                rows between 6 preceding and current row
            ) = 0 then null
            else round(
                (d.total_revenue - avg(d.total_revenue) over (
                    partition by d.branch_id
                    order by d.order_date
                    rows between 6 preceding and current row
                )) / avg(d.total_revenue) over (
                    partition by d.branch_id
                    order by d.order_date
                    rows between 6 preceding and current row
                ), 4
            )
        end                             as pct_change_vs_7d_avg

    from daily d
    left join {{ ref('dim_branches') }} b
        on d.branch_id = b.branch_id
)

select * from with_rolling
order by order_date desc, total_revenue desc

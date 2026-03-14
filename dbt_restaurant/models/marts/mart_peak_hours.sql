with hourly as (
    select
        order_date,
        branch_id,
        order_hour,
        order_type,
        count(distinct order_id)        as total_orders,
        sum(subtotal)                   as total_revenue,
        sum(qty)                        as total_items_sold
    from {{ ref('fct_orders') }}
    group by
        order_date,
        branch_id,
        order_hour,
        order_type
),

with_branch as (
    select
        h.*,
        b.branch_name,

        -- Label hour buckets for dashboard display
        case
            when h.order_hour between 8  and 10 then 'Morning'
            when h.order_hour between 11 and 13 then 'Lunch Peak'
            when h.order_hour between 14 and 16 then 'Afternoon'
            when h.order_hour between 17 and 20 then 'Dinner Peak'
            else                                     'Late Night'
        end                             as day_part,

        -- Flag peak hours (top traffic periods)
        case
            when h.order_hour in (12, 13, 18, 19) then true
            else false
        end                             as is_peak_hour

    from hourly h
    left join {{ ref('dim_branches') }} b
        on h.branch_id = b.branch_id
)

select * from with_branch
order by order_date desc, branch_id, order_hour

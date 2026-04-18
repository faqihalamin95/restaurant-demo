with daily_menu as (
    select
        f.order_date,
        f.branch_id,
        b.branch_name,
        f.menu_id,
        m.menu_name,
        m.category,
        m.price,
        m.price_tier,
        count(distinct f.order_id) as total_orders,
        sum(f.qty)                 as total_qty_sold,
        sum(f.subtotal)            as total_revenue
    from {{ ref('fct_orders') }} f
    left join {{ ref('dim_menu_items') }} m
        on f.menu_id = m.menu_id
    left join {{ ref('dim_branches') }} b
        on f.branch_id = b.branch_id
    group by
        f.order_date, f.branch_id, b.branch_name,
        f.menu_id, m.menu_name, m.category, m.price, m.price_tier
),

with_trend as (
    select
        *,
        sum(total_qty_sold) over (
            partition by branch_id, menu_id
            order by order_date
            rows between 29 preceding and current row
        ) as qty_30d_rolling,
        sum(total_qty_sold) over (
            partition by branch_id, menu_id
            order by order_date
            rows between 6 preceding and current row
        ) as qty_last_7d,
        sum(total_qty_sold) over (
            partition by branch_id, menu_id
            order by order_date
            rows between 13 preceding and 7 preceding
        ) as qty_prior_7d
    from daily_menu
),

final as (
    select
        *,
        case
            when qty_prior_7d = 0 then null
            else round(
                (qty_last_7d - qty_prior_7d) * 1.0 / qty_prior_7d, 4
            )
        end as qty_wow_change
    from with_trend
)

select * from final
order by order_date desc, total_qty_sold desc

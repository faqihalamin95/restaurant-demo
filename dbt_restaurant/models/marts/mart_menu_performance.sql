with daily_menu as (
    select
        f.order_date,
        f.menu_id,
        m.menu_name,
        m.category,
        m.price,
        m.price_tier,
        count(distinct f.order_id)      as total_orders,
        sum(f.qty)                      as total_qty_sold,
        sum(f.subtotal)                 as total_revenue
    from {{ ref('fct_orders') }} f
    left join {{ ref('dim_menu_items') }} m
        on f.menu_id = m.menu_id
    group by
        f.order_date,
        f.menu_id,
        m.menu_name,
        m.category,
        m.price,
        m.price_tier
),

-- 30-day rolling qty to detect declining trend
with_trend as (
    select
        *,
        sum(total_qty_sold) over (
            partition by menu_id
            order by order_date
            rows between 29 preceding and current row
        )                               as qty_30d_rolling,

        -- Compare recent 7 days vs prior 7 days
        -- Negative = declining, drives "menu losing traction" insight
        sum(total_qty_sold) over (
            partition by menu_id
            order by order_date
            rows between 6 preceding and current row
        )                               as qty_last_7d,

        sum(total_qty_sold) over (
            partition by menu_id
            order by order_date
            rows between 13 preceding and 7 preceding
        )                               as qty_prior_7d

    from daily_menu
),

final as (
    select
        *,
        case
            when qty_prior_7d = 0 then null
            else round(
                (qty_last_7d - qty_prior_7d) * 1.0 / qty_prior_7d,
                4
            )
        end                             as qty_wow_change  -- week-over-week

    from with_trend
)

select * from final
order by order_date desc, total_qty_sold desc

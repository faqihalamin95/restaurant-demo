with member_orders as (
    select
        order_date,
        member_id,
        count(distinct order_id)  as total_orders,
        sum(subtotal)             as total_spend,
        sum(qty)                  as total_items,
        count(distinct branch_id) as branch_visited,
        count(distinct order_type) as order_type_used
    from {{ ref('fct_orders') }}
    where member_id is not null
    group by 1, 2
),

joined as (
    select
        mo.order_date,
        mo.member_id,
        m.member_name,
        m.tier,
        m.city,
        mo.total_orders,
        mo.total_spend,
        mo.total_items,
        round(mo.total_spend / nullif(mo.total_orders, 0), 2) as avg_order_value,
        mo.branch_visited,
        mo.order_type_used,
        datediff('day', mo.order_date, current_date) as recency_days,
        m.join_date
    from member_orders mo
    left join {{ ref('dim_members') }} m
        on mo.member_id = m.member_id
)

select * from joined

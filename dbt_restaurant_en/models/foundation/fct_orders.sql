with orders as (
    select * from {{ ref('stg_orders') }}
),

order_items as (
    select * from {{ ref('stg_order_items') }}
),

order_totals as (
    select
        order_id,
        sum(subtotal) as order_revenue,
        sum(qty)      as total_items
    from order_items
    group by order_id
),

line_items as (
    select
        oi.order_item_id,
        oi.order_id,
        o.branch_id,
        o.order_date,
        o.order_hour,
        o.order_time,
        o.payment_method,
        o.order_type,
        o.shift_id,
        o.handler_employee_id,
        o.member_id,
        oi.menu_id,
        oi.qty,
        oi.subtotal
    from order_items oi
    left join orders o
        on oi.order_id = o.order_id
)

select * from line_items

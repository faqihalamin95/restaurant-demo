with order_level as (
    select
        order_date,
        branch_id,
        shift_id,
        handler_employee_id as employee_id,
        count(distinct order_id) as orders_handled,
        sum(subtotal) as total_revenue
    from {{ ref('fct_orders') }}
    group by 1, 2, 3, 4
),

attendance as (
    select
        attendance_date,
        employee_id,
        shift_id,
        status,
        overtime_hours
    from {{ ref('stg_employee_attendance') }}
),

joined as (
    select
        o.order_date,
        o.branch_id,
        b.branch_name,
        o.shift_id,
        case o.shift_id
            when 'S1' then 'Pagi'
            when 'S2' then 'Siang'
            when 'S3' then 'Malam'
            else 'Lainnya'
        end as shift_name,
        o.employee_id,
        e.employee_name,
        e.role,
        o.orders_handled,
        o.total_revenue,
        round(o.total_revenue / nullif(o.orders_handled, 0), 0) as avg_ticket,
        coalesce(a.status, 'off') as attendance_status,
        coalesce(a.overtime_hours, 0) as overtime_hours
    from order_level o
    left join {{ ref('dim_employees') }} e
        on o.employee_id = e.employee_id
    left join {{ ref('dim_branches') }} b
        on o.branch_id = b.branch_id
    left join attendance a
        on o.order_date = a.attendance_date
        and o.employee_id = a.employee_id
        and o.shift_id = a.shift_id
)

select * from joined

with attendance as (
    select * from {{ ref('fct_employee_attendance') }}
),

orders as (
    select
        order_date,
        branch_id,
        handler_employee_id as employee_id,
        count(distinct order_id) as orders_handled,
        sum(subtotal)            as total_revenue
    from {{ ref('fct_orders') }}
    group by order_date, branch_id, handler_employee_id
),

joined as (
    select
        a.attendance_date,
        a.employee_id,
        e.employee_name,
        e.role,
        a.branch_id,
        b.branch_name,
        a.shift_id,
        s.shift_name,
        a.status              as attendance_status,
        a.overtime_hours,
        a.is_present,
        a.is_late,
        a.is_absent,
        a.is_on_leave,
        coalesce(o.orders_handled, 0)                           as orders_handled,
        coalesce(o.total_revenue,  0)                           as total_revenue,
        round(o.total_revenue / nullif(o.orders_handled, 0), 2) as avg_ticket
    from attendance a
    left join orders o
        on  a.attendance_date = o.order_date
        and a.employee_id     = o.employee_id
    left join {{ ref('dim_employees') }} e
        on a.employee_id = e.employee_id
    left join {{ ref('dim_branches') }} b
        on a.branch_id = b.branch_id
    left join {{ ref('dim_shifts') }} s
        on a.shift_id = s.shift_id
)

select * from joined

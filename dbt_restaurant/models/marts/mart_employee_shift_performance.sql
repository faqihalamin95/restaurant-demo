with attendance as (
    select * from {{ ref('fct_employee_attendance') }}   -- ← dari fact, bukan staging
),

orders as (
    select
        order_date,
        branch_id,
        shift_id,
        handler_employee_id as employee_id,
        count(distinct order_id) as orders_handled,
        sum(subtotal)           as total_revenue
    from {{ ref('fct_orders') }}
    group by 1, 2, 3, 4
),

joined as (
    select
        -- dimensi waktu
        a.attendance_date,

        -- dimensi karyawan
        a.employee_id,
        e.employee_name,
        e.role,

        -- dimensi lokasi
        a.branch_id,
        b.branch_name,

        -- dimensi shift
        a.shift_id,
        s.shift_name,

        -- kehadiran
        a.status              as attendance_status,
        a.overtime_hours,
        a.is_present,
        a.is_late,
        a.is_absent,
        a.is_on_leave,

        -- performa (null kalau tidak ada order hari itu)
        coalesce(o.orders_handled, 0)  as orders_handled,
        coalesce(o.total_revenue, 0)   as total_revenue,
        round(
            o.total_revenue / nullif(o.orders_handled, 0), 0
        )                              as avg_ticket

    from attendance a  -- ← base dari attendance, bukan orders
    left join orders o
        on  a.attendance_date = o.order_date
        and a.employee_id     = o.employee_id
        and a.shift_id        = o.shift_id
    left join {{ ref('dim_employees') }} e
        on a.employee_id = e.employee_id
    left join {{ ref('dim_branches') }} b
        on a.branch_id = b.branch_id
    left join {{ ref('dim_shifts') }} s      -- ← dari dim, bukan hardcode CASE
        on a.shift_id = s.shift_id
)

select * from joined
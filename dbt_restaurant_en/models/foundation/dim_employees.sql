with employees as (
    select * from {{ ref('stg_employees') }}
),

branches as (
    select branch_id, branch_name from {{ ref('dim_branches') }}
),

final as (
    select
        e.employee_id,
        e.employee_name,
        e.branch_id,
        b.branch_name,
        e.role,
        e.assigned_shift_id,
        e.start_date,
        datediff('day', e.start_date, current_date) as tenure_days,
        e.is_active
    from employees e
    left join branches b
        on e.branch_id = b.branch_id
)

select * from final

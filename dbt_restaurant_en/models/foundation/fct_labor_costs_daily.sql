with attendance as (
    select * from {{ ref('fct_employee_attendance') }}
),

comp as (
    select * from {{ ref('stg_employee_compensation') }}
),

joined as (
    select
        a.attendance_date as cost_date,
        a.branch_id,
        a.employee_id,
        a.status,
        a.overtime_hours,
        c.base_salary_monthly,
        c.meal_allowance_daily,
        c.overtime_rate_hourly,
        coalesce(c.base_salary_monthly, 0) / 30.0 as salary_daily_allocated,
        case
            when a.status in ('present', 'late') then coalesce(c.meal_allowance_daily, 0)
            else 0
        end as meal_allowance_cost,
        case
            when a.status in ('present', 'late') then coalesce(a.overtime_hours, 0) * coalesce(c.overtime_rate_hourly, 0)
            else 0
        end as overtime_cost
    from attendance a
    left join comp c
        on a.employee_id = c.employee_id
        and a.branch_id  = c.branch_id
),

agg as (
    select
        cost_date,
        branch_id,
        sum(salary_daily_allocated)                                                   as salary_cost,
        sum(meal_allowance_cost)                                                      as meal_allowance_cost,
        sum(overtime_cost)                                                            as overtime_cost,
        sum(salary_daily_allocated + meal_allowance_cost + overtime_cost)             as labor_total_cost
    from joined
    group by 1, 2
)

select * from agg

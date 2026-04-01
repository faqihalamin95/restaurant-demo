with source as (
    select * from {{ source('raw', 'employee_compensation') }}
),

renamed as (
    select
        employee_id,
        branch_id,
        cast(base_salary_monthly as decimal(18,2))   as base_salary_monthly,
        cast(meal_allowance_daily as decimal(18,2))  as meal_allowance_daily,
        cast(overtime_rate_hourly as decimal(18,2))  as overtime_rate_hourly,
        cast(effective_from as date)                 as effective_from
    from source
)

select * from renamed
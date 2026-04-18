with source as (
    select * from {{ source('raw', 'employees') }}
),

renamed as (
    select
        employee_id,
        employee_name,
        branch_id,
        role,
        assigned_shift_id,
        cast(start_date as date)   as start_date,
        cast(is_active as boolean) as is_active
    from source
)

select * from renamed

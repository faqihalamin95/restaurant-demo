with source as (
    select * from {{ source('raw', 'employee_attendance') }}
),

renamed as (
    select
        attendance_id,
        employee_id,
        branch_id,
        shift_id,
        cast(attendance_date as date)   as attendance_date,
        lower(trim(status))             as status,
        cast(overtime_hours as numeric) as overtime_hours
    from source
)

select * from renamed

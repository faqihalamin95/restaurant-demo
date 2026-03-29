with source as (
    select * from {{ source('raw', 'employee_attendance') }}
),

renamed as (
    select
        attendance_id,
        cast(attendance_date as date) as attendance_date,
        employee_id,
        branch_id,
        shift_id,
        status,
        cast(overtime_hours as integer) as overtime_hours
    from source
)

select * from renamed

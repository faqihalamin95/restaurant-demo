with attendance as (
    select * from {{ ref('stg_employee_attendance') }}
),

valid as (
    select *
    from attendance
    where status in ('present', 'late', 'leave', 'absent')  -- filter dipindah dari staging ke sini
),

enriched as (
    select
        -- surrogate key
        {{ dbt_utils.generate_surrogate_key([
            'attendance_date', 'employee_id', 'shift_id'
        ]) }}                                               as attendance_sk,

        -- foreign keys
        attendance_id,
        employee_id,
        branch_id,
        shift_id,

        -- date
        attendance_date,

        -- measures
        status,
        overtime_hours,

        -- derived flags
        case when status = 'present' then 1 else 0 end      as is_present,
        case when status = 'late'    then 1 else 0 end      as is_late,
        case when status = 'absent'  then 1 else 0 end      as is_absent,
        case when status = 'leave'   then 1 else 0 end      as is_on_leave,
        case when overtime_hours > 0 then 1 else 0 end      as has_overtime

    from valid
)

select * from enriched
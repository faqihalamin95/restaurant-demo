with attendance as (
    select * from {{ ref('stg_employee_attendance') }}
),

valid as (
    select *
    from attendance
    where status in ('present', 'late', 'leave', 'absent')
),

enriched as (
    select
        {{ dbt_utils.generate_surrogate_key([
            'attendance_date', 'employee_id', 'shift_id'
        ]) }}                                               as attendance_sk,

        attendance_id,
        employee_id,
        branch_id,
        shift_id,
        attendance_date,
        status,
        coalesce(overtime_hours, 0)                         as overtime_hours,

        case when status = 'present' then 1 else 0 end      as is_present,
        case when status = 'late'    then 1 else 0 end      as is_late,
        case when status = 'absent'  then 1 else 0 end      as is_absent,
        case when status = 'leave'   then 1 else 0 end      as is_on_leave,
        case when overtime_hours > 0 then 1 else 0 end      as has_overtime

    from valid
)

select * from enriched

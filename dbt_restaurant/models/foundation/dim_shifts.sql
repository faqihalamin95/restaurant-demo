with shifts as (
    select distinct
        shift_id,
        case shift_id
            when 'S1' then 'Pagi'
            when 'S2' then 'Siang'
            when 'S3' then 'Malam'
            else 'Lainnya'
        end as shift_name,
        case shift_id
            when 'S1' then '07:00'
            when 'S2' then '14:00'
            when 'S3' then '21:00'
        end as shift_start_time
    from {{ ref('stg_employee_attendance') }}
)

select * from shifts
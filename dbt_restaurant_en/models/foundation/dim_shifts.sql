with shifts as (
    select distinct
        shift_id,
        case shift_id
            when 'S1' then 'Morning'
            when 'S2' then 'Afternoon'
            when 'S3' then 'Evening'
            else 'Other'
        end as shift_name,
        case shift_id
            when 'S1' then '08:00'
            when 'S2' then '12:00'
            when 'S3' then '16:00'
        end as shift_start_time
    from {{ ref('stg_employee_attendance') }}
)

select * from shifts

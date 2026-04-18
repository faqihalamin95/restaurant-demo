with members as (
    select * from {{ ref('stg_members') }}
)

select
    member_id,
    member_name,
    gender,
    birth_year,
    city,
    tier,
    join_date,
    datediff('day', join_date, current_date) as membership_age_days,
    is_active
from members

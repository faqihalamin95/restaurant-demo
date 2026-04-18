with source as (
    select * from {{ ref('stg_branches') }}
)

select
    branch_id,
    branch_name,
    branch_location,
    opened_date,
    datediff('day', opened_date, current_date) as days_since_opening
from source

with costs as (
    select * from {{ ref('stg_branch_daily_operational_costs') }}
)

select
    cost_date,
    branch_id,
    building_rent_daily,
    water_cost,
    electricity_cost,
    other_utilities_cost,
    building_rent_daily + water_cost + electricity_cost + other_utilities_cost
        as total_operational_cost
from costs

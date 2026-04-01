with source as (
    select * from {{ source('raw', 'branch_daily_operational_costs') }}
),

renamed as (
    select
        cast(cost_date as date)                     as cost_date,
        branch_id,
        cast(building_rent_daily as decimal(18,2))  as building_rent_daily,
        cast(water_cost as decimal(18,2))           as water_cost,
        cast(electricity_cost as decimal(18,2))     as electricity_cost,
        cast(other_utilities_cost as decimal(18,2)) as other_utilities_cost
    from source
)

select * from renamed

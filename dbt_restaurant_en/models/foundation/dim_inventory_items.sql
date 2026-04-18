with source as (
    select * from {{ ref('stg_inventory_catalog') }}
)

select
    inventory_id,
    item_name,
    category,
    unit,
    base_unit_cost,
    case
        when base_unit_cost < 3  then 'low'
        when base_unit_cost < 10 then 'medium'
        else 'high'
    end as cost_tier
from source

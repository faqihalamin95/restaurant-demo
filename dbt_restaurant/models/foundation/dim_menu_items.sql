with source as (
    select * from {{ ref('stg_menu_items') }}
)

select
    menu_id,
    menu_name,
    category,
    price,
    is_active,

    -- Derived: price tier for grouping in dashboard
    case
        when price <= 10000  then 'budget'
        when price <= 30000  then 'standard'
        when price <= 50000  then 'premium'
        else                      'bundle'
    end                             as price_tier

from source

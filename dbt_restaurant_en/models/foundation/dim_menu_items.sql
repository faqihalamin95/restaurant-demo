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
        when price <= 3    then 'budget'
        when price <= 12   then 'standard'
        when price <= 20   then 'premium'
        else                    'bundle'
    end                         as price_tier

from source

with source as (
    select * from {{ ref('stg_menu_items') }}
)

select
    menu_id,
    menu_name,
    category,
    price,
    is_active,

    -- Derived: segmen harga untuk pengelompokan di dashboard
    case
        when price <= 10000  then 'Hemat'
        when price <= 30000  then 'Standar'
        when price <= 50000  then 'Premium'
        else                      'Paket'
    end                             as price_tier

from source
with source as (
    select * from {{ source('raw', 'inventory_catalog') }}
),

renamed as (
    select
        inventory_id,
        item_name,
        category,
        unit,
        cast(base_unit_cost as decimal(18,2)) as base_unit_cost
    from source
)

select * from renamed

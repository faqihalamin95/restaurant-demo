with source as (
    select * from {{ source('raw', 'menu_items') }}
),

renamed as (
    select
        menu_id,
        name                            as menu_name,
        category,
        cast(price as decimal(10, 2))   as price,
        cast(is_active as boolean)      as is_active
    from source
)

select * from renamed

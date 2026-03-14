with source as (
    select * from {{ source('raw', 'order_items') }}
),

renamed as (
    select
        order_item_id,
        order_id,
        menu_id,
        cast(qty as integer)            as qty,
        cast(subtotal as decimal(10, 2)) as subtotal
    from source
)

select * from renamed

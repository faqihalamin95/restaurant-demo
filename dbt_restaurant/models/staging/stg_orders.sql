with source as (
    select * from {{ source('raw', 'orders') }}
),

renamed as (
    select
        order_id,
        branch_id,
        cast(order_time as timestamp)   as order_time,
        date_trunc('day', cast(order_time as timestamp))::date
                                        as order_date,
        hour(cast(order_time as timestamp))
                                        as order_hour,
        payment_method,                 -- nullable (chaos injection)
        order_type
    from source
)

select * from renamed

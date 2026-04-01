with source as (
    select * from {{ source('raw', 'inventory_transactions') }}
),

renamed as (
    select
        inventory_txn_id,
        cast(txn_date as date)                    as txn_date,
        branch_id,
        inventory_id,
        txn_type,
        cast(qty as decimal(18,2))                as qty,
        cast(unit_cost as decimal(18,2))          as unit_cost,
        cast(total_cost as decimal(18,2))         as total_cost
    from source
)

select * from renamed

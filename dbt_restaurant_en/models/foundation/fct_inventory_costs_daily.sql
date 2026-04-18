with txns as (
    select * from {{ ref('stg_inventory_transactions') }}
),

agg as (
    select
        txn_date as cost_date,
        branch_id,
        sum(case when txn_type = 'usage'    then total_cost else 0 end) as inventory_usage_cost,
        sum(case when txn_type = 'purchase' then total_cost else 0 end) as inventory_purchase_cost,
        sum(total_cost)                                                  as inventory_total_cost
    from txns
    group by 1, 2
)

select * from agg

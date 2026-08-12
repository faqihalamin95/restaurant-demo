with txns as (
    select * from {{ ref('stg_inventory_transactions') }}
),

catalog as (
    select * from {{ ref('dim_inventory_items') }}
),

branches as (
    select branch_id, branch_name from {{ ref('dim_branches') }}
),

daily as (
    select
        t.txn_date,
        t.branch_id,
        t.inventory_id,
        sum(case when t.txn_type = 'usage'    then t.qty        else 0 end) as usage_qty,
        sum(case when t.txn_type = 'purchase' then t.qty        else 0 end) as purchase_qty,
        sum(case when t.txn_type = 'usage'    then t.total_cost else 0 end) as usage_cost,
        sum(case when t.txn_type = 'purchase' then t.total_cost else 0 end) as purchase_cost,
        sum(t.total_cost)                                                    as total_cost,
        avg(t.unit_cost)                                                     as avg_unit_cost
    from txns t
    group by 1, 2, 3
),

joined as (
    select
        d.txn_date,
        d.branch_id,
        b.branch_name,
        d.inventory_id,
        c.item_name,
        c.category,
        c.unit,
        c.base_unit_cost,
        c.cost_tier,
        d.usage_qty,
        d.purchase_qty,
        d.usage_cost,
        d.purchase_cost,
        d.total_cost,
        round(d.avg_unit_cost, 2) as avg_unit_cost,

        -- Relative stock delta (no opening balance available)
        sum(d.purchase_qty - d.usage_qty) over (
            partition by d.branch_id, d.inventory_id
            order by d.txn_date
            rows between unbounded preceding and current row
        ) as estimated_stock_delta
    from daily d
    left join catalog  c on d.inventory_id = c.inventory_id
    left join branches b on d.branch_id    = b.branch_id
)

select *,
    case
        when estimated_stock_delta < usage_qty * 3 then 'low'
        when estimated_stock_delta > usage_qty * 14 then 'overstock'
        else 'ok'
    end as stock_status,
    case
        when usage_qty > 0 then estimated_stock_delta / usage_qty
        else 99
    end as days_remaining,
    estimated_stock_delta * base_unit_cost as stock_value
from joined
order by txn_date desc, branch_id, inventory_id

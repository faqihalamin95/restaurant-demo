with revenue as (
    select
        order_date as metric_date,
        branch_id,
        sum(subtotal) as gross_revenue
    from {{ ref('fct_orders') }}
    group by 1, 2
),

inventory as (
    select
        cost_date as metric_date,
        branch_id,
        inventory_usage_cost,
        inventory_purchase_cost,
        inventory_total_cost
    from {{ ref('fct_inventory_costs_daily') }}
),

labor as (
    select
        cost_date as metric_date,
        branch_id,
        salary_cost,
        meal_allowance_cost,
        overtime_cost,
        labor_total_cost
    from {{ ref('fct_labor_costs_daily') }}
),

operational as (
    select
        cost_date as metric_date,
        branch_id,
        building_rent_daily,
        water_cost,
        electricity_cost,
        other_utilities_cost,
        total_operational_cost
    from {{ ref('fct_branch_operational_costs_daily') }}
),

base as (
    select metric_date, branch_id from revenue
    union
    select metric_date, branch_id from inventory
    union
    select metric_date, branch_id from labor
    union
    select metric_date, branch_id from operational
)

select
    b.metric_date,
    b.branch_id,
    d.branch_name,
    coalesce(r.gross_revenue,            0) as gross_revenue,
    coalesce(i.inventory_usage_cost,     0) as inventory_usage_cost,
    coalesce(i.inventory_purchase_cost,  0) as inventory_purchase_cost,
    coalesce(i.inventory_total_cost,     0) as inventory_total_cost,
    coalesce(l.salary_cost,              0) as salary_cost,
    coalesce(l.meal_allowance_cost,      0) as meal_allowance_cost,
    coalesce(l.overtime_cost,            0) as overtime_cost,
    coalesce(l.labor_total_cost,         0) as labor_total_cost,
    coalesce(o.building_rent_daily,      0) as building_rent_daily,
    coalesce(o.water_cost,               0) as water_cost,
    coalesce(o.electricity_cost,         0) as electricity_cost,
    coalesce(o.other_utilities_cost,     0) as other_utilities_cost,
    coalesce(o.total_operational_cost,   0) as operational_total_cost,
    coalesce(r.gross_revenue, 0)
      - coalesce(i.inventory_usage_cost, 0)
      - coalesce(l.labor_total_cost,     0)
      - coalesce(o.total_operational_cost, 0)   as net_revenue,
    coalesce(r.gross_revenue, 0)
      - coalesce(i.inventory_total_cost, 0)
      - coalesce(l.labor_total_cost,     0)
      - coalesce(o.total_operational_cost, 0)   as net_cash_flow_after_purchases
from base b
left join revenue    r on b.metric_date = r.metric_date and b.branch_id = r.branch_id
left join inventory  i on b.metric_date = i.metric_date and b.branch_id = i.branch_id
left join labor      l on b.metric_date = l.metric_date and b.branch_id = l.branch_id
left join operational o on b.metric_date = o.metric_date and b.branch_id = o.branch_id
left join {{ ref('dim_branches') }} d on b.branch_id = d.branch_id
order by b.metric_date desc, b.branch_id

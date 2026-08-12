import re

with open('/home/faqih/projects/restaurant-demo/evidence/pages/03-inventori-stok/index.md', 'r') as f:
    content = f.read()

new_query = """```sql inv_branch_health
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM restaurant.inventory_stok),
branch_issues AS (
    SELECT 
        branch_name,
        SUM(CASE WHEN stock_status = 'low' OR days_remaining < 3 THEN 1 ELSE 0 END) AS low_count,
        SUM(CASE WHEN stock_status = 'overstock' OR days_remaining > 14 THEN 1 ELSE 0 END) AS overstock_count,
        SUM(CASE WHEN stock_status = 'overstock' OR days_remaining > 14 THEN stock_value ELSE 0 END) / NULLIF(SUM(stock_value), 0) * 100 AS overstock_pct
    FROM restaurant.inventory_stok CROSS JOIN max_d
    WHERE txn_date = d
    GROUP BY 1
)
SELECT 
    b.branch_name, 
    COALESCE(b.low_count, 0) AS low_count,
    COALESCE(b.overstock_count, 0) AS overstock_count,
    COALESCE(b.overstock_pct, 0) AS overstock_pct
FROM branch_issues b
```
"""

# Replace the old query
content = re.sub(r'```sql inv_branch_health.*?```\n', new_query, content, flags=re.DOTALL)

# Update the javascript block logic
js_logic = """{@const totalBranches = inv_branch_health.length}
{@const healthyBranches = inv_branch_health.filter(b => b.low_count === 0 && b.overstock_pct <= 25).length}
{@const heroStatusClass = healthyBranches === totalBranches ? 'status-sehat' : healthyBranches >= Math.ceil(totalBranches/2) ? 'status-biru' : healthyBranches > 0 ? 'status-waspada' : 'status-kritis'}
{@const overstockVal = (inv_inventory_overview[0]?.overstock_value ?? 0)}
{@const overstockPct = (inv_inventory_overview[0]?.overstock_value_pct ?? 0)}
{@const lowItems = (inv_inventory_overview[0]?.low_items ?? 0)}
<div class="inv-page">"""

content = re.sub(r'{@const totalBranches = inv_branch_health\.length}.*?<div class="inv-page">', js_logic, content, flags=re.DOTALL)

# Update the text inside the hero card
hero_text = """        <div class="hero-subtitle">
          {#if healthyBranches === totalBranches}
            Stok sehat di seluruh cabang. Tidak ada barang habis atau modal tertahan berlebih.
          {:else if healthyBranches >= Math.ceil(totalBranches/2)}
            Mayoritas cabang dalam kondisi stok terkendali, sisanya butuh reorder/transfer.
          {:else}
            Sebagian besar cabang mengalami kelangkaan bahan atau overstock berlebih.
          {/if}
        </div>"""
content = re.sub(r'<div class="hero-subtitle">.*?</div>', hero_text, content, flags=re.DOTALL)

with open('/home/faqih/projects/restaurant-demo/evidence/pages/03-inventori-stok/index.md', 'w') as f:
    f.write(content)

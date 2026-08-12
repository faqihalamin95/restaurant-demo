import re

filepath = "/home/faqih/projects/restaurant-demo/evidence/pages/03-inventori-stok/index.md"
with open(filepath, 'r') as f:
    content = f.read()

# 1. Update SQL Query
old_sql_regex = r"```sql inv_branch_health.*?```"
new_sql = """```sql inv_branch_health
WITH max_d AS (SELECT MAX(txn_date)::DATE AS d FROM restaurant.inventory_stok),
latest AS (
    SELECT * FROM (
        SELECT *, ROW_NUMBER() OVER(PARTITION BY branch_name, item_name ORDER BY txn_date DESC) as rn
        FROM restaurant.inventory_stok
    ) WHERE rn = 1
),
movement_item AS (
    SELECT branch_name, item_name, ROUND(SUM(usage_qty)/30,2) AS avg_daily_usage
    FROM restaurant.inventory_stok CROSS JOIN max_d
    WHERE txn_date >= d - INTERVAL '29 days'
    GROUP BY 1, 2
),
branch_issues AS (
    SELECT 
        l.branch_name,
        COUNT(l.item_name) AS total_items,
        SUM(CASE WHEN COALESCE(l.stock_on_hand / NULLIF(m.avg_daily_usage, 0), l.days_remaining) < 3 THEN 1 ELSE 0 END) AS low_count,
        SUM(CASE WHEN COALESCE(l.stock_on_hand / NULLIF(m.avg_daily_usage, 0), l.days_remaining) > 14 THEN 1 ELSE 0 END) AS overstock_count,
        SUM(CASE WHEN COALESCE(l.stock_on_hand / NULLIF(m.avg_daily_usage, 0), l.days_remaining) > 14 THEN l.stock_value ELSE 0 END) / NULLIF(SUM(l.stock_value), 0) * 100 AS overstock_pct,
        SUM(CASE WHEN COALESCE(l.stock_on_hand / NULLIF(m.avg_daily_usage, 0), l.days_remaining) > 14 THEN l.stock_value ELSE 0 END) AS overstock_value,
        SUM(l.stock_value) AS total_stock_value
    FROM latest l
    LEFT JOIN movement_item m ON l.item_name = m.item_name AND l.branch_name = m.branch_name
    GROUP BY 1
),
branch_purchases AS (
    SELECT branch_name, SUM(purchase_cost) AS purchase_cost, SUM(usage_cost) AS usage_cost
    FROM restaurant.inventory_stok CROSS JOIN max_d
    WHERE txn_date >= d - INTERVAL '29 days'
    GROUP BY 1
)
SELECT 
    b.branch_name, 
    COALESCE(b.total_items, 0) AS total_items,
    COALESCE(b.total_items, 0) - COALESCE(b.low_count, 0) - COALESCE(b.overstock_count, 0) AS healthy_count,
    COALESCE(b.low_count, 0) AS low_count,
    COALESCE(b.overstock_count, 0) AS overstock_count,
    COALESCE(ROUND(b.overstock_pct, 1), 0) AS overstock_pct,
    COALESCE(b.overstock_value, 0) AS overstock_value,
    COALESCE(b.total_stock_value, 0) AS total_stock_value,
    COALESCE(bp.purchase_cost, 0) AS purchase_cost,
    COALESCE(bp.usage_cost, 0) AS usage_cost,
    ROUND(COALESCE(bp.purchase_cost, 0) / NULLIF(bp.usage_cost, 0), 2) AS purchase_ratio,
    CASE 
        WHEN COALESCE(b.low_count, 0) > 0 THEN 'Turnaround'
        WHEN COALESCE(b.overstock_pct, 0) > 30 THEN 'Waspada'
        WHEN COALESCE(b.overstock_pct, 0) > 20 THEN 'Stabil Rendah'
        ELSE 'Sehat'
    END AS health_status,
    CASE 
        WHEN COALESCE(b.low_count, 0) > 0 THEN 'Terdapat ' || b.low_count || ' item dengan sisa < 3 hari. Risiko sold out tinggi, segera restock.'
        WHEN COALESCE(b.overstock_pct, 0) > 30 THEN 'Porsi overstock sangat tinggi (' || ROUND(b.overstock_pct, 1) || '%). Kurangi pemesanan baru untuk menjaga cashflow.'
        WHEN COALESCE(b.overstock_pct, 0) > 20 THEN 'Ada sedikit potensi overstock (' || ROUND(b.overstock_pct, 1) || '%). Pantau pergerakan item slow-moving.'
        ELSE 'Kondisi stok sangat baik. Distribusi dan coverage hari aman.'
    END AS diagnosis
FROM branch_issues b
LEFT JOIN branch_purchases bp ON b.branch_name = bp.branch_name
```"""
content = re.sub(old_sql_regex, new_sql, content, flags=re.DOTALL)

# 2. Update HTML Structure
old_html_regex = r'<div class="branch-margin-section">.*?<div class="branch-diagnosis-box {branchStatusClass}">'
new_html = """<div class="branch-margin-section" style="border-bottom: 1px dashed rgba(128, 128, 128, 0.15); margin-bottom: 8px; padding-bottom: 12px;">
          <div class="branch-margin-active-box" style="display: flex; flex-direction: column; align-items: center; justify-content: center; text-align: center;">
            <div class="branch-margin-main {branchStatusClass}">{row.healthy_count}/{row.total_items}</div>
            <div class="branch-margin-label">Item Sehat</div>
          </div>

          <div class="branch-margin-benchmarks">
            <div class="benchmark-item">
              <span class="benchmark-label">Nilai Stok</span>
              <strong class="benchmark-val">Rp {(row.total_stock_value/1000000).toFixed(1)}jt</strong>
            </div>
            <div class="benchmark-item">
              <span class="benchmark-label">Nilai Overstok</span>
              <strong class="benchmark-val" style={row.overstock_value > 0 ? "color: #dc2626;" : ""}>Rp {(row.overstock_value/1000000).toFixed(1)}jt</strong>
            </div>
          </div>
        </div>

        <div class="branch-stats-grid">
          <div class="stat-pill">
            <span class="stat-label">Lowstock</span>
            <span class="stat-value {row.low_count > 0 ? 'text-down' : 'text-up'}">{row.low_count} Item</span>
          </div>
          <div class="stat-pill">
            <span class="stat-label">Overstock</span>
            <span class="stat-value {row.overstock_count > 0 ? 'text-down' : 'text-up'}">{row.overstock_count} Item</span>
          </div>
          <div class="stat-pill">
            <span class="stat-label">Beli (30H)</span>
            <span class="stat-value">Rp {(row.purchase_cost/1000000).toFixed(1)}jt</span>
          </div>
          <div class="stat-pill">
            <span class="stat-label">Rasio Beli</span>
            <span class="stat-value {row.purchase_ratio > 1.2 ? 'text-down' : 'text-up'}">{row.purchase_ratio}x</span>
          </div>
        </div>

        <div class="branch-diagnosis-box {branchStatusClass}">"""
content = re.sub(old_html_regex, new_html, content, flags=re.DOTALL)

with open(filepath, 'w') as f:
    f.write(content)
print("Done")

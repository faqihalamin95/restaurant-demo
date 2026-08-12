import re

filepath = "/home/faqih/projects/restaurant-demo/evidence/pages/03-inventori-stok/index.md"
with open(filepath, 'r') as f:
    content = f.read()

# 1. Add low_pct to branch_issues
old_branch_issues = """        SUM(CASE WHEN COALESCE(l.stock_on_hand / NULLIF(m.avg_daily_usage, 0), l.days_remaining) < 3 THEN 1 ELSE 0 END) AS low_count,"""
new_branch_issues = """        SUM(CASE WHEN COALESCE(l.stock_on_hand / NULLIF(m.avg_daily_usage, 0), l.days_remaining) < 3 THEN 1 ELSE 0 END) AS low_count,
        SUM(CASE WHEN COALESCE(l.stock_on_hand / NULLIF(m.avg_daily_usage, 0), l.days_remaining) < 3 THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(l.item_name), 0) AS low_pct,"""
content = content.replace(old_branch_issues, new_branch_issues)

# 2. Add low_pct to final SELECT
old_select = """    COALESCE(b.low_count, 0) AS low_count,"""
new_select = """    COALESCE(b.low_count, 0) AS low_count,
    COALESCE(ROUND(b.low_pct, 1), 0) AS low_pct,"""
content = content.replace(old_select, new_select)

# 3. Update health_status CASE
old_health = """    CASE 
        WHEN COALESCE(b.low_count, 0) > 0 THEN 'Kritis'
        WHEN COALESCE(b.overstock_pct, 0) > 30 THEN 'Waspada'
        WHEN COALESCE(b.overstock_pct, 0) > 20 THEN 'Early Warning'
        ELSE 'Sehat'
    END AS health_status,"""
new_health = """    CASE 
        WHEN COALESCE(b.low_pct, 0) >= 15 THEN 'Kritis'
        WHEN COALESCE(b.low_pct, 0) > 0 THEN 'Waspada'
        WHEN COALESCE(b.overstock_pct, 0) > 30 THEN 'Waspada'
        WHEN COALESCE(b.overstock_pct, 0) > 20 THEN 'Early Warning'
        ELSE 'Sehat'
    END AS health_status,"""
content = content.replace(old_health, new_health)

# 4. Update diagnosis CASE
old_diag = """    CASE 
        WHEN COALESCE(b.low_count, 0) > 0 THEN 'Terdapat ' || b.low_count || ' item dengan sisa < 3 hari. Risiko sold out tinggi, segera restock.'
        WHEN COALESCE(b.overstock_pct, 0) > 30 THEN 'Porsi overstock sangat tinggi (' || ROUND(b.overstock_pct, 1) || '%). Kurangi pemesanan baru untuk menjaga cashflow.'
        WHEN COALESCE(b.overstock_pct, 0) > 20 THEN 'Ada sedikit potensi overstock (' || ROUND(b.overstock_pct, 1) || '%). Pantau pergerakan item slow-moving.'
        ELSE 'Kondisi stok sangat baik. Distribusi dan coverage hari aman.'
    END AS diagnosis"""
new_diag = """    CASE 
        WHEN COALESCE(b.low_pct, 0) >= 15 THEN 'Terdapat ' || b.low_count || ' item (' || ROUND(b.low_pct, 1) || '%) dengan sisa < 3 hari. Segera restock untuk cegah kelangkaan masif.'
        WHEN COALESCE(b.low_pct, 0) > 0 THEN 'Terdapat ' || b.low_count || ' item (' || ROUND(b.low_pct, 1) || '%) menipis. Pantau ketersediaan agar tidak mengganggu operasional.'
        WHEN COALESCE(b.overstock_pct, 0) > 30 THEN 'Porsi overstock sangat tinggi (' || ROUND(b.overstock_pct, 1) || '%). Kurangi pemesanan baru untuk menjaga cashflow.'
        WHEN COALESCE(b.overstock_pct, 0) > 20 THEN 'Ada sedikit potensi overstock (' || ROUND(b.overstock_pct, 1) || '%). Pantau pergerakan item slow-moving.'
        ELSE 'Kondisi stok sangat baik. Distribusi dan coverage hari aman.'
    END AS diagnosis"""
content = content.replace(old_diag, new_diag)

with open(filepath, 'w') as f:
    f.write(content)
print("Updated SQL logic for percentage based lowstock.")

import re

filepath = "/home/faqih/projects/restaurant-demo/evidence/pages/03-inventori-stok/index.md"
with open(filepath, 'r') as f:
    content = f.read()

# 1. Update SQL health_status
old_case_sql = """    CASE 
        WHEN COALESCE(b.low_count, 0) > 0 THEN 'Turnaround'
        WHEN COALESCE(b.overstock_pct, 0) > 30 THEN 'Waspada'
        WHEN COALESCE(b.overstock_pct, 0) > 20 THEN 'Stabil Rendah'
        ELSE 'Sehat'
    END AS health_status,"""

new_case_sql = """    CASE 
        WHEN COALESCE(b.low_count, 0) > 0 THEN 'Kritis'
        WHEN COALESCE(b.overstock_pct, 0) > 30 THEN 'Waspada'
        WHEN COALESCE(b.overstock_pct, 0) > 20 THEN 'Early Warning'
        ELSE 'Sehat'
    END AS health_status,"""
content = content.replace(old_case_sql, new_case_sql)

# 2. Update HTML class assignment
old_html_class = """{@const branchStatusClass = row.health_status === 'Sehat' ? 'sehat' : row.health_status === 'Waspada' ? 'waspada' : row.health_status === 'Early Warning' ? 'early-warning' : row.health_status === 'Recovery' ? 'recovery' : row.health_status === 'Membaik' ? 'membaik' : row.health_status === 'Stabil Rendah' ? 'stabil-rendah' : 'turnaround'}"""

new_html_class = """{@const branchStatusClass = row.health_status === 'Sehat' ? 'sehat' : row.health_status === 'Waspada' ? 'waspada' : row.health_status === 'Early Warning' ? 'early-warning' : 'turnaround'}"""
content = content.replace(old_html_class, new_html_class)

# 3. Update Emoji Logic
old_html_emoji = """{row.health_status === 'Sehat' ? '✅' : row.health_status === 'Waspada' ? '⚠️' : row.health_status === 'Early Warning' ? '🟠' : row.health_status === 'Recovery' ? '🔵' : row.health_status === 'Membaik' ? '🟢' : row.health_status === 'Stabil Rendah' ? '🟡' : '🚨'} {row.health_status}"""

new_html_emoji = """{row.health_status === 'Sehat' ? '✅' : row.health_status === 'Waspada' ? '🟠' : row.health_status === 'Early Warning' ? '⚠️' : '🚨'} {row.health_status}"""
content = content.replace(old_html_emoji, new_html_emoji)

with open(filepath, 'w') as f:
    f.write(content)
print("Done")

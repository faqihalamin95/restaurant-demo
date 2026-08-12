import re

filepath = "/home/faqih/projects/restaurant-demo/evidence/pages/03-inventori-stok/index.md"
with open(filepath, 'r') as f:
    content = f.read()

# 1. Add idFormat function to script block
if "function idFormat" not in content:
    old_script = "<script>"
    new_script = """<script>
  function idFormat(num, dec = 0) {
    if (num === null || num === undefined) return '0';
    return new Intl.NumberFormat('id-ID', { minimumFractionDigits: dec, maximumFractionDigits: dec }).format(num);
  }"""
    content = content.replace(old_script, new_script)

# 2. Add clean-cta CSS
old_style_start = "#makro-fix p { margin: 0 !important; padding: 0 !important; line-height: normal !important; }"
new_style_add = """#makro-fix p { margin: 0 !important; padding: 0 !important; line-height: normal !important; }
#makro-fix .clean-cta-banner { margin-top: 32px; margin-bottom: 40px; padding: 24px 28px; border-radius: 16px; background: rgba(13, 148, 136, 0.03); border: 1px solid rgba(13, 148, 136, 0.15); display: flex; align-items: center; justify-content: space-between; box-shadow: 0 4px 12px rgba(13, 148, 136, 0.03); transition: all 0.3s ease; }
#makro-fix .clean-cta-banner:hover { background: rgba(13, 148, 136, 0.05); border-color: rgba(13, 148, 136, 0.25); box-shadow: 0 8px 24px rgba(13, 148, 136, 0.06); }
#makro-fix .clean-cta-content { display: flex; align-items: center; gap: 20px; }
#makro-fix .clean-cta-icon { font-size: 2.2rem; line-height: 1; filter: drop-shadow(0 2px 4px rgba(13, 148, 136, 0.15)); }
#makro-fix .clean-cta-title { margin: 0 0 4px 0; font-size: 1.1rem; font-weight: 800; letter-spacing: -0.01em; color: #0f766e; }
#makro-fix .clean-cta-desc { margin: 0; font-size: 0.88rem; color: var(--color-text-secondary); font-weight: 400; max-width: 65ch; line-height: 1.6; }
#makro-fix .clean-cta-button { background: white !important; border: 1px solid rgba(13, 148, 136, 0.3) !important; color: #0d9488 !important; font-weight: 800 !important; font-size: 0.9rem !important; padding: 12px 20px !important; border-radius: 8px !important; text-decoration: none !important; display: inline-flex !important; align-items: center !important; justify-content: center !important; transition: all 0.2s ease !important; box-shadow: 0 2px 6px rgba(13, 148, 136, 0.06) !important; line-height: 1 !important; margin: 0 !important; white-space: nowrap !important; }
#makro-fix .clean-cta-button:hover { background: #f0fdfa !important; color: #0f766e !important; border-color: #0d9488 !important; transform: translateY(-1px) !important; box-shadow: 0 4px 12px rgba(13, 148, 136, 0.1) !important; }"""
content = content.replace(old_style_start, new_style_add)


# 3. Replace raw values in branch cards with idFormat
content = content.replace("{(row.total_stock_value/1000000).toFixed(1)}", "{idFormat(row.total_stock_value/1000000, 1)}")
content = content.replace("{(row.overstock_value/1000000).toFixed(1)}", "{idFormat(row.overstock_value/1000000, 1)}")
content = content.replace("{(row.purchase_cost/1000000).toFixed(1)}", "{idFormat(row.purchase_cost/1000000, 1)}")
content = content.replace("{row.purchase_ratio}x", "{idFormat(row.purchase_ratio, 2)}x")
content = content.replace("{row.active_margin_pct}%", "{idFormat(row.active_margin_pct, 1)}%")

# 4. Replace raw values in makro section with idFormat
content = content.replace("{(inv_macro_strategic[0].total_stock_value/1000000).toFixed(1)}", "{idFormat(inv_macro_strategic[0].total_stock_value/1000000, 1)}")
content = content.replace("{inv_macro_strategic[0].rasio_beli}x", "{idFormat(inv_macro_strategic[0].rasio_beli, 2)}x")
content = content.replace("{inv_macro_strategic[0].tren_harga_pct}%", "{idFormat(inv_macro_strategic[0].tren_harga_pct, 1)}%")
content = content.replace("{inv_macro_strategic[0].ketepatan_pengiriman_pct}%", "{idFormat(inv_macro_strategic[0].ketepatan_pengiriman_pct, 1)}%")
content = content.replace("{inv_macro_strategic[0].reject_rate_pct}%", "{idFormat(inv_macro_strategic[0].reject_rate_pct, 1)}%")

with open(filepath, 'w') as f:
    f.write(content)
print("Done")

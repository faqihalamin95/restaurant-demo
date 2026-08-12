import re

filepath = "/home/faqih/projects/restaurant-demo/evidence/pages/03-inventori-stok/index.md"
with open(filepath, 'r') as f:
    content = f.read()

# 1. Update the branch-margin-active-box CSS to center items
old_css_box = """.branch-margin-active-box {
  display: flex;
  flex-direction: column;
}"""
new_css_box = """.branch-margin-active-box {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
}"""
content = content.replace(old_css_box, new_css_box)

# 2. Update the background colors to be default, not just on hover
old_css_hover_1 = """.branch-health-card.sehat:hover {
  border-color: rgba(22, 163, 74, 0.5) !important;
  background: linear-gradient(160deg, rgba(22, 163, 74, 0.12), rgba(16, 185, 129, 0.06)) !important;
}"""
new_css_hover_1 = """.branch-health-card.sehat {
  border-color: rgba(22, 163, 74, 0.5) !important;
  background: linear-gradient(160deg, rgba(22, 163, 74, 0.12), rgba(16, 185, 129, 0.06)) !important;
}"""
content = content.replace(old_css_hover_1, new_css_hover_1)

old_css_hover_2 = """.branch-health-card.waspada:hover {
  border-color: rgba(245, 158, 11, 0.52) !important;
  background: linear-gradient(160deg, rgba(245, 158, 11, 0.14), rgba(251, 191, 36, 0.06)) !important;
}"""
new_css_hover_2 = """.branch-health-card.waspada {
  border-color: rgba(245, 158, 11, 0.52) !important;
  background: linear-gradient(160deg, rgba(245, 158, 11, 0.14), rgba(251, 191, 36, 0.06)) !important;
}"""
content = content.replace(old_css_hover_2, new_css_hover_2)

old_css_hover_3 = """.branch-health-card.early-warning:hover {
  border-color: rgba(249, 115, 22, 0.55) !important;
  background: linear-gradient(160deg, rgba(249, 115, 22, 0.14), rgba(251, 146, 60, 0.06)) !important;
}"""
new_css_hover_3 = """.branch-health-card.early-warning {
  border-color: rgba(249, 115, 22, 0.55) !important;
  background: linear-gradient(160deg, rgba(249, 115, 22, 0.14), rgba(251, 146, 60, 0.06)) !important;
}"""
content = content.replace(old_css_hover_3, new_css_hover_3)

old_css_hover_4 = """.branch-health-card.stabil-rendah:hover {
  border-color: rgba(245, 158, 11, 0.48) !important;
  background: linear-gradient(160deg, rgba(245, 158, 11, 0.1), rgba(251, 191, 36, 0.04)) !important;
}"""
new_css_hover_4 = """.branch-health-card.stabil-rendah {
  border-color: rgba(245, 158, 11, 0.48) !important;
  background: linear-gradient(160deg, rgba(245, 158, 11, 0.1), rgba(251, 191, 36, 0.04)) !important;
}"""
content = content.replace(old_css_hover_4, new_css_hover_4)

old_css_hover_5 = """.branch-health-card.turnaround:hover {
  border-color: rgba(239, 68, 68, 0.5) !important;
  background: linear-gradient(160deg, rgba(239, 68, 68, 0.14), rgba(220, 38, 38, 0.06)) !important;
}"""
new_css_hover_5 = """.branch-health-card.turnaround {
  border-color: rgba(239, 68, 68, 0.5) !important;
  background: linear-gradient(160deg, rgba(239, 68, 68, 0.14), rgba(220, 38, 38, 0.06)) !important;
}"""
content = content.replace(old_css_hover_5, new_css_hover_5)

# 3. Increase font size of Item Sehat main text and rename "Modal Mandek" to "Nilai Over"
old_html = """          <div class="branch-margin-active-box">
            <div class="branch-margin-main {branchStatusClass}" style="font-size: 1.5rem;">{row.healthy_count}/{row.total_items}</div>
            <div class="branch-margin-label">Item Sehat</div>
          </div>

          <div class="branch-margin-benchmarks">
            <div class="benchmark-item">
              <span class="benchmark-label">Stok Aktual</span>
              <strong class="benchmark-val">Rp {(row.total_stock_value/1000000).toFixed(1)}jt</strong>
            </div>
            <div class="benchmark-item">
              <span class="benchmark-label">Modal Mandek</span>
              <strong class="benchmark-val" style={row.overstock_value > 0 ? "color: #dc2626;" : ""}>Rp {(row.overstock_value/1000000).toFixed(1)}jt</strong>
            </div>
          </div>"""

new_html = """          <div class="branch-margin-active-box">
            <div class="branch-margin-main {branchStatusClass}" style="font-size: 2.2rem;">{row.healthy_count}/{row.total_items}</div>
            <div class="branch-margin-label">Item Sehat</div>
          </div>

          <div class="branch-margin-benchmarks">
            <div class="benchmark-item">
              <span class="benchmark-label">Stok Aktual</span>
              <strong class="benchmark-val">Rp {(row.total_stock_value/1000000).toFixed(1)}jt</strong>
            </div>
            <div class="benchmark-item">
              <span class="benchmark-label">Nilai Over</span>
              <strong class="benchmark-val" style={row.overstock_value > 0 ? "color: #dc2626;" : ""}>Rp {(row.overstock_value/1000000).toFixed(1)}jt</strong>
            </div>
          </div>"""
content = content.replace(old_html, new_html)

with open(filepath, 'w') as f:
    f.write(content)
print("Done")

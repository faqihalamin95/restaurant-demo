import re

filepath = "/home/faqih/projects/restaurant-demo/evidence/pages/03-inventori-stok/index.md"
with open(filepath, 'r') as f:
    content = f.read()

# Restore the :hover pseudo-classes
old_css_hover_1 = """.branch-health-card.sehat {
  border-color: rgba(22, 163, 74, 0.5) !important;
  background: linear-gradient(160deg, rgba(22, 163, 74, 0.12), rgba(16, 185, 129, 0.06)) !important;
}"""
new_css_hover_1 = """.branch-health-card.sehat:hover {
  border-color: rgba(22, 163, 74, 0.5) !important;
  background: linear-gradient(160deg, rgba(22, 163, 74, 0.12), rgba(16, 185, 129, 0.06)) !important;
}"""
content = content.replace(old_css_hover_1, new_css_hover_1)

old_css_hover_2 = """.branch-health-card.waspada {
  border-color: rgba(245, 158, 11, 0.52) !important;
  background: linear-gradient(160deg, rgba(245, 158, 11, 0.14), rgba(251, 191, 36, 0.06)) !important;
}"""
new_css_hover_2 = """.branch-health-card.waspada:hover {
  border-color: rgba(245, 158, 11, 0.52) !important;
  background: linear-gradient(160deg, rgba(245, 158, 11, 0.14), rgba(251, 191, 36, 0.06)) !important;
}"""
content = content.replace(old_css_hover_2, new_css_hover_2)

old_css_hover_3 = """.branch-health-card.early-warning {
  border-color: rgba(249, 115, 22, 0.55) !important;
  background: linear-gradient(160deg, rgba(249, 115, 22, 0.14), rgba(251, 146, 60, 0.06)) !important;
}"""
new_css_hover_3 = """.branch-health-card.early-warning:hover {
  border-color: rgba(249, 115, 22, 0.55) !important;
  background: linear-gradient(160deg, rgba(249, 115, 22, 0.14), rgba(251, 146, 60, 0.06)) !important;
}"""
content = content.replace(old_css_hover_3, new_css_hover_3)

old_css_hover_4 = """.branch-health-card.stabil-rendah {
  border-color: rgba(245, 158, 11, 0.48) !important;
  background: linear-gradient(160deg, rgba(245, 158, 11, 0.1), rgba(251, 191, 36, 0.04)) !important;
}"""
new_css_hover_4 = """.branch-health-card.stabil-rendah:hover {
  border-color: rgba(245, 158, 11, 0.48) !important;
  background: linear-gradient(160deg, rgba(245, 158, 11, 0.1), rgba(251, 191, 36, 0.04)) !important;
}"""
content = content.replace(old_css_hover_4, new_css_hover_4)

old_css_hover_5 = """.branch-health-card.turnaround {
  border-color: rgba(239, 68, 68, 0.5) !important;
  background: linear-gradient(160deg, rgba(239, 68, 68, 0.14), rgba(220, 38, 38, 0.06)) !important;
}"""
new_css_hover_5 = """.branch-health-card.turnaround:hover {
  border-color: rgba(239, 68, 68, 0.5) !important;
  background: linear-gradient(160deg, rgba(239, 68, 68, 0.14), rgba(220, 38, 38, 0.06)) !important;
}"""
content = content.replace(old_css_hover_5, new_css_hover_5)

with open(filepath, 'w') as f:
    f.write(content)
print("Done")

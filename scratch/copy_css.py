import re

# 1. Read source CSS from 02-branch-performance
with open("/home/faqih/projects/restaurant-demo/evidence/pages/02-branch-performance/index.md", "r") as f:
    perf_content = f.read()

# Extract the CSS block we want
# It starts at /* ── Branch Health Card Hover ── */
# And ends at /* -- KPI & Macro Strategic -- */
start_marker = "/* ── Branch Health Card Hover ── */"
end_marker = "/* -- KPI & Macro Strategic -- */"

start_idx = perf_content.find(start_marker)
end_idx = perf_content.find(end_marker)

if start_idx != -1 and end_idx != -1:
    extracted_css = perf_content[start_idx:end_idx].strip()
else:
    print("Could not find CSS markers in 02-branch-performance")
    exit(1)

# We also need .branch-health-grid which might not be in the extracted block.
grid_css = ".branch-health-grid { display: grid; gap: 16px; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); }\n"

final_css = grid_css + extracted_css + "\n\n.branch-margin-main { font-size: 2.2rem; font-weight: 800; line-height: 1.1; }\n.branch-margin-label { font-size: 0.75rem; color: var(--color-text-secondary); font-weight: 600; margin-top: 2px; }\n"

# 2. Read target file 03-inventori-stok
with open("/home/faqih/projects/restaurant-demo/evidence/pages/03-inventori-stok/index.md", "r") as f:
    inv_content = f.read()

# Replace everything from .branch-health-grid to the end of the <style> block.
target_start_marker = ".branch-health-grid"
target_end_marker = "</style>"

t_start_idx = inv_content.find(target_start_marker)
t_end_idx = inv_content.find(target_end_marker)

if t_start_idx != -1 and t_end_idx != -1:
    new_inv_content = inv_content[:t_start_idx] + final_css + "\n" + inv_content[t_end_idx:]
    with open("/home/faqih/projects/restaurant-demo/evidence/pages/03-inventori-stok/index.md", "w") as f:
        f.write(new_inv_content)
    print("Successfully replaced CSS")
else:
    print("Could not find CSS markers in 03-inventori-stok")

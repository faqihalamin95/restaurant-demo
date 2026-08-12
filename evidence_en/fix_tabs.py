import os
import re

components_dir = "components"

replacements = {
    # Finance
    r'href="/01-financial-report/trend"': r'href="/01-financial-report/02-trend"',
    r'href="/01-financial-report/cost-breakdown"': r'href="/01-financial-report/03-cost-breakdown"',
    
    # Branch Performance
    r'href="/02-branch-performance/deepdive"': r'href="/02-branch-performance/02-deepdive"',
    r'href="/02-branch-performance/analysis"': r'href="/02-branch-performance/03-analysis"',
    r'href="/02-branch-performance/data-directory"': r'href="/02-branch-performance/04-data-directory"',
    
    # Inventory
    r'href="/03-inventory/deepdive"': r'href="/03-inventory/02-deepdive"',
    r'href="/03-inventory/analysis"': r'href="/03-inventory/03-analysis"',
    r'href="/03-inventory/data-directory"': r'href="/03-inventory/04-data-directory"',
    
    # Peak Hours
    r'href="/04-peak-hours/deepdive"': r'href="/04-peak-hours/02-deepdive"',
    
    # Menu Performance
    r'href="/05-menu-performance/deepdive"': r'href="/05-menu-performance/02-deepdive"',
    r'href="/05-menu-performance/evaluasi"': r'href="/05-menu-performance/03-analysis"',
    r'href="/05-menu-performance/direktori"': r'href="/05-menu-performance/04-data-directory"',
    r'href="/05-menu-performance/rapor"': r'href="/05-menu-performance/05-report-card"',
    
    # Member Behavior
    r'href="/06-member-behavior/02-aksi-taktis"': r'href="/06-member-behavior/02-tactical-action"',
    r'href="/06-member-behavior/03-evaluasi-strategis"': r'href="/06-member-behavior/03-analysis"',
    r'href="/06-member-behavior/04-direktori-member"': r'href="/06-member-behavior/04-data-directory"',
    
    # Employee Performance (assuming similar old indonesian names)
    r'href="/07-employee-performance/02-aksi-taktis"': r'href="/07-employee-performance/02-tactical-action"',
    r'href="/07-employee-performance/03-evaluasi-strategis"': r'href="/07-employee-performance/03-analysis"',
    r'href="/07-employee-performance/04-direktori-staff"': r'href="/07-employee-performance/04-data-directory"',
    r'href="/07-employee-performance/05-data-directory"': r'href="/07-employee-performance/04-data-directory"'
}

for root, dirs, files in os.walk(components_dir):
    for file in files:
        if file.endswith("Tabs.svelte"):
            path = os.path.join(root, file)
            with open(path, "r") as f:
                content = f.read()
            
            for old, new in replacements.items():
                content = content.replace(old, new)
                
            with open(path, "w") as f:
                f.write(content)
            print(f"Updated {path}")

import os
import re

pages_dir = "pages"

replacements = {
    # Finance
    r'/01-financial-report/trend': r'/01-financial-report/02-trend',
    r'/01-financial-report/cost-breakdown': r'/01-financial-report/03-cost-breakdown',
    
    # Branch
    r'/02-branch-performance/deepdive': r'/02-branch-performance/02-deepdive',
    r'/02-branch-performance/analysis': r'/02-branch-performance/03-analysis',
    r'/02-branch-performance/data-directory': r'/02-branch-performance/04-data-directory',
    
    # Inventory
    r'/03-inventory/deepdive': r'/03-inventory/02-deepdive',
    r'/03-inventory/analysis': r'/03-inventory/03-analysis',
    r'/03-inventory/data-directory': r'/03-inventory/04-data-directory',
    
    # Peak Hours
    r'/04-peak-hours/deepdive': r'/04-peak-hours/02-deepdive',
    
    # Menu Performance
    r'/05-menu-performance/deepdive': r'/05-menu-performance/02-deepdive',
    r'/05-menu-performance/evaluasi': r'/05-menu-performance/03-analysis',
    r'/05-menu-performance/direktori': r'/05-menu-performance/04-data-directory',
    r'/05-menu-performance/rapor': r'/05-menu-performance/05-report-card',
    
    # Member Behavior
    r'/06-member-behavior/02-aksi-taktis': r'/06-member-behavior/02-tactical-action',
    r'/06-member-behavior/03-evaluasi-strategis': r'/06-member-behavior/03-analysis',
    r'/06-member-behavior/04-direktori-member': r'/06-member-behavior/04-data-directory',
    
    # Employee
    r'/07-employee-performance/02-aksi-taktis': r'/07-employee-performance/02-tactical-action',
    r'/07-employee-performance/03-evaluasi-strategis': r'/07-employee-performance/03-analysis',
    r'/07-employee-performance/04-direktori-staff': r'/07-employee-performance/04-data-directory',
    r'/07-employee-performance/05-data-directory': r'/07-employee-performance/04-data-directory'
}

for root, dirs, files in os.walk(pages_dir):
    for file in files:
        if file.endswith(".md"):
            path = os.path.join(root, file)
            with open(path, "r") as f:
                content = f.read()
            
            original_content = content
            for old, new in replacements.items():
                content = content.replace(old, new)
                
            if content != original_content:
                with open(path, "w") as f:
                    f.write(content)
                print(f"Updated links in {path}")

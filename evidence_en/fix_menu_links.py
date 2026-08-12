import os
import re

pages_dir = "pages/05-menu-performance"

for root, dirs, files in os.walk(pages_dir):
    for file in files:
        if file.endswith(".md"):
            path = os.path.join(root, file)
            with open(path, "r") as f:
                content = f.read()
            
            original_content = content
            # Swap using a placeholder
            content = content.replace("/05-menu-performance/05-report-card", "/05-menu-performance/TEMP-REPORT")
            content = content.replace("/05-menu-performance/04-data-directory", "/05-menu-performance/05-data-directory")
            content = content.replace("/05-menu-performance/TEMP-REPORT", "/05-menu-performance/04-report-card")
                
            if content != original_content:
                with open(path, "w") as f:
                    f.write(content)
                print(f"Updated links in {path}")

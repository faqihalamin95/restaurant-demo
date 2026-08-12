import os
import re

dir_path = "/home/faqih/projects/restaurant-demo/evidence/pages/en/06-member-behavior"

replacements = {
    r'activeTab="taktis"': 'activeTab="tactical"',
    r'activeTab="strategis"': 'activeTab="strategic"',
    r"status-sehat": "status-healthy",
    r"status-waspada": "status-warning",
    r"status-kritis": "status-critical",
    r"penetrasiState": "penetrationState",
    r'id="ringkasan-risiko"': 'id="risk-summary"',
    r'02-aksi-taktis': '02-tactical-action',
    r'03-evaluasi-strategis': '03-strategic-evaluation',
}

for root, _, files in os.walk(dir_path):
    for file in files:
        if file.endswith(".md"):
            file_path = os.path.join(root, file)
            with open(file_path, "r", encoding="utf-8") as f:
                content = f.read()
            
            new_content = content
            for k, v in replacements.items():
                new_content = re.sub(k, v, new_content)
            
            if new_content != content:
                with open(file_path, "w", encoding="utf-8") as f:
                    f.write(new_content)
                print(f"Updated {file_path}")

print("Done")

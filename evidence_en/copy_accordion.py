import re

# Read source file
with open("pages/06-member-behavior/index.md", "r") as f:
    source_content = f.read()

# Extract the accordion block from source
match_source = re.search(r'<details class="guide-acc"[^>]*>.*?<summary>📖 Analytics Page Operational Guide</summary>.*?</details>', source_content, re.DOTALL)
if not match_source:
    print("Could not find source accordion")
    exit(1)

source_accordion = match_source.group(0)

# Read target file
with open("pages/07-employee-performance/index.md", "r") as f:
    target_content = f.read()

# Replace the accordion block in target
target_content_new = re.sub(r'<details class="guide-acc"[^>]*>.*?<summary>📖 Quick Guide to Using This Page</summary>.*?</details>', source_accordion, target_content, flags=re.DOTALL)

with open("pages/07-employee-performance/index.md", "w") as f:
    f.write(target_content_new)

print("Accordion replaced successfully.")

import re

filepath = "/home/faqih/projects/restaurant-demo/evidence/pages/07-employee-performance/02-aksi-taktis.md"
with open(filepath, 'r') as f:
    content = f.read()

# Fix window reference
old_logic = "$: if (isLoaded && !hashHandled) {"
new_logic = "$: if (isLoaded && !hashHandled && typeof window !== 'undefined') {"

content = content.replace(old_logic, new_logic)

with open(filepath, 'w') as f:
    f.write(content)
print("Done")

with open('/home/faqih/projects/restaurant-demo/evidence/pages/04-peak-hours/deepdive.md', 'r') as f:
    content = f.read()

# Strings to remove for Accordion 1
acc1_start = """    <details class="acc-strategic" style="margin-top: 16px;">
      <summary>📊 Detail Analisis Makro &amp; Profil Trafik</summary>
      <div class="acc-body">"""

acc1_end = """      </div>
    </details>"""

# Strings to remove for Accordion 2
acc2_start = """    <details class="acc-strategic" style="margin-top: 16px;">
      <summary>📊 Detail Analisis Titik Kritis &amp; Distribusi Sesi</summary>
      <div class="acc-body">"""

acc2_end = """      </div>
    </details>"""

# We just do string replacement
if acc1_start in content:
    content = content.replace(acc1_start, '')
    # For end, we just replace the first occurrence that comes after the removed start
    # But doing a simple replace might be tricky if there are multiple.
    # We will use regex to find the first occurrence of the closing tag and remove it
    
import re

content = re.sub(r'    <details class="acc-strategic" style="margin-top: 16px;">\s*<summary>📊 Detail Analisis Makro &amp; Profil Trafik</summary>\s*<div class="acc-body">', '', content)
content = re.sub(r'    <details class="acc-strategic" style="margin-top: 16px;">\s*<summary>📊 Detail Analisis Titik Kritis &amp; Distribusi Sesi</summary>\s*<div class="acc-body">', '', content)

# Now we need to remove two occurrences of `      </div>\n    </details>`
# Wait, if we look at the file, the closing tags are exactly at lines 1041-1042 and 1252-1253 (before we removed lines)
# Let's just remove the first two occurrences of `      </div>\n    </details>`
content = content.replace("      </div>\n    </details>", "", 2)

with open('/home/faqih/projects/restaurant-demo/evidence/pages/04-peak-hours/deepdive.md', 'w') as f:
    f.write(content)
print("Stripped accordions")

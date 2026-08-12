import re
from pathlib import Path

f1 = Path('/home/faqih/projects/restaurant-demo/scratch/old_deepdive.md')
old_c = f1.read_text()
# Find line 631 (0-indexed 630) to 1132
old_lines = old_c.split('\n')
missing_lines = '\n'.join(old_lines[630:1132])

f2 = Path('/home/faqih/projects/restaurant-demo/evidence_en/pages/02-branch-performance/deepdive.md')
new_c = f2.read_text()
new_lines = new_c.split('\n')

# Find the injection point: "    </div>\n\n\n  {:else}"
# It is around line 895. Let's find "  {:else}" and insert it before that.

injection_idx = -1
for i, line in enumerate(new_lines):
    if line.startswith('  {:else}'):
        injection_idx = i
        break

if injection_idx != -1:
    new_lines.insert(injection_idx, missing_lines)
    f2.write_text('\n'.join(new_lines))
    print("SUCCESS")
else:
    print("FAILED")


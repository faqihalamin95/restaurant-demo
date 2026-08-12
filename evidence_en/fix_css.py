from pathlib import Path
import re

f = Path('/home/faqih/projects/restaurant-demo/evidence_en/pages/02-branch-performance/deepdive.md')
c = f.read_text()

c = c.replace('borders-radius', 'border-radius')
c = c.replace('borders-color', 'border-color')
c = c.replace('borders-bottom', 'border-bottom')
c = c.replace('borders-right', 'border-right')
c = c.replace('borders-top', 'border-top')
c = c.replace('borders-left', 'border-left')
c = c.replace('borders:', 'border:')
c = c.replace('--color-borders', '--color-border')

f.write_text(c)
print("SUCCESS")

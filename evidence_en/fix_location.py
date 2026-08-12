import re
from pathlib import Path

# Fix data-directory.md
p = Path('/home/faqih/projects/restaurant-demo/evidence_en/pages/02-branch-performance/data-directory.md')
c = p.read_text()
c = c.replace('WHERE (Location =', 'WHERE (Cabang =')
c = c.replace('ORDER BY Tanggal DESC, Location ASC', 'ORDER BY Tanggal DESC, Cabang ASC')
c = c.replace('value="Location"', 'value="Cabang"')
c = c.replace('<Column id="Location" />', '<Column id="Cabang" title="Location" />')
p.write_text(c)

# We should also check if any other files have WHERE Location = or ORDER BY Location
for f in Path('/home/faqih/projects/restaurant-demo/evidence_en/pages/02-branch-performance').glob('*.md'):
    content = f.read_text()
    new_content = content.replace('WHERE Location =', 'WHERE Cabang =')
    new_content = new_content.replace('WHERE (Location =', 'WHERE (Cabang =')
    new_content = new_content.replace('GROUP BY Location', 'GROUP BY Cabang')
    new_content = new_content.replace('ORDER BY Location', 'ORDER BY Cabang')
    if new_content != content:
        f.write_text(new_content)
        print(f"Fixed SQL in {f.name}")

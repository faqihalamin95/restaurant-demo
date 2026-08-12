import re
from pathlib import Path

f = Path('/home/faqih/projects/restaurant-demo/evidence_en/pages/02-branch-performance/deepdive.md')
c = f.read_text()

# We need to find the block under `{#if activeAdvisorsCount === 1}` and unindent it, 
# or ensure it's not treated as markdown by wrapping it carefully.

# Actually, the safest way to prevent mdsvex from messing up HTML inside {#if} is to use a standard Svelte layout, 
# but simply putting a blank line before and after, and removing the 14-space indentation.

def dedent_html(match):
    content = match.group(0)
    # Remove up to 14 spaces of indentation from every line
    lines = content.split('\n')
    dedented_lines = []
    for line in lines:
        if line.startswith('              '):
            dedented_lines.append(line[14:])
        elif line.startswith('            '):
            dedented_lines.append(line[12:])
        else:
            dedented_lines.append(line)
    return '\n'.join(dedented_lines)

# Find the advisor-wrapper block
start_str = '<div class="advisor-wrapper">'
end_str = '{:else}'

start_idx = c.find(start_str)
end_idx = c.find(end_str, start_idx)

if start_idx != -1 and end_idx != -1:
    target_block = c[start_idx:end_idx]
    
    # Dedent everything inside it
    new_block = dedent_html(re.match(r'.*', target_block, re.DOTALL))
    
    c = c[:start_idx] + new_block + c[end_idx:]
    f.write_text(c)
    print("SUCCESS")
else:
    print("FAILED")

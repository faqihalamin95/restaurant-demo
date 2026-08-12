import re
from pathlib import Path

f = Path('/home/faqih/projects/restaurant-demo/evidence_en/pages/02-branch-performance/deepdive.md')
c = f.read_text()

# CSS to inject
css_to_add = """
/* Individual Pill Themes */
.risk-pill.theme-slate { background: rgba(15,23,42,0.02); border-color: rgba(15,23,42,0.06); }
.risk-pill.theme-slate:hover { background: rgba(15,23,42,0.04); }
.risk-pill.theme-slate .risk-pill-anchor { background: rgba(15,23,42,0.08); }
.risk-pill.theme-slate .pros-cons-box { background: rgba(15,23,42,0.03); border-color: rgba(15,23,42,0.08); }

.risk-pill.theme-amber { background: rgba(245,158,11,0.04); border-color: rgba(245,158,11,0.15); }
.risk-pill.theme-amber:hover { background: rgba(245,158,11,0.08); }
.risk-pill.theme-amber .risk-pill-anchor { background: rgba(245,158,11,0.15); }
.risk-pill.theme-amber .pros-cons-box { background: rgba(245,158,11,0.05); border-color: rgba(245,158,11,0.15); }

.risk-pill.theme-orange { background: rgba(249,115,22,0.04); border-color: rgba(249,115,22,0.15); }
.risk-pill.theme-orange:hover { background: rgba(249,115,22,0.08); }
.risk-pill.theme-orange .risk-pill-anchor { background: rgba(249,115,22,0.15); }
.risk-pill.theme-orange .pros-cons-box { background: rgba(249,115,22,0.05); border-color: rgba(249,115,22,0.15); }

.risk-pill.theme-rose { background: rgba(244,63,94,0.03); border-color: rgba(244,63,94,0.12); }
.risk-pill.theme-rose:hover { background: rgba(244,63,94,0.06); }
.risk-pill.theme-rose .risk-pill-anchor { background: rgba(244,63,94,0.12); }
.risk-pill.theme-rose .pros-cons-box { background: rgba(244,63,94,0.04); border-color: rgba(244,63,94,0.1); }

.risk-pill.theme-violet { background: rgba(139,92,246,0.03); border-color: rgba(139,92,246,0.12); }
.risk-pill.theme-violet:hover { background: rgba(139,92,246,0.06); }
.risk-pill.theme-violet .risk-pill-anchor { background: rgba(139,92,246,0.12); }
.risk-pill.theme-violet .pros-cons-box { background: rgba(139,92,246,0.04); border-color: rgba(139,92,246,0.1); }

.risk-pill.theme-blue { background: rgba(59,130,246,0.03); border-color: rgba(59,130,246,0.12); }
.risk-pill.theme-blue:hover { background: rgba(59,130,246,0.06); }
.risk-pill.theme-blue .risk-pill-anchor { background: rgba(59,130,246,0.12); }
.risk-pill.theme-blue .pros-cons-box { background: rgba(59,130,246,0.04); border-color: rgba(59,130,246,0.1); }

.risk-pill.theme-emerald { background: rgba(16,185,129,0.04); border-color: rgba(16,185,129,0.15); }
.risk-pill.theme-emerald:hover { background: rgba(16,185,129,0.08); }
.risk-pill.theme-emerald .risk-pill-anchor { background: rgba(16,185,129,0.15); }
.risk-pill.theme-emerald .pros-cons-box { background: rgba(16,185,129,0.05); border-color: rgba(16,185,129,0.15); }
"""

# Modify base CSS of .risk-pill to add gap and border
c = c.replace('.risk-pill {\n  display: flex;', '.risk-pill {\n  display: flex;\n  border: 1px solid transparent; border-radius: 12px; margin: 4px;')

# Remove old :hover backgrounds from the global theme so they don't override our new specific ones
c = re.sub(r'\.risk-row\.[a-z\-]+ \.risk-pill:hover \{ background: [^}]+ \}\n', '', c)
c = re.sub(r'\.risk-row\.[a-z\-]+ \.risk-pill-anchor \{ background: [^}]+ \}\n', '', c)
c = re.sub(r'\.risk-row\.[a-z\-]+ \.pros-cons-box \{ background: [^}]+ border-color: [^}]+ \}\n', '', c)

# Inject CSS at the end of the style block
c = c.replace('</style>', css_to_add + '\n</style>')

# Now update the HTML tags
emoji_map = {
    '🕵️': 'theme-slate',
    '🏷️': 'theme-amber',
    '🍔': 'theme-orange',
    '✂️': 'theme-rose',
    '🚀': 'theme-violet',
    '📱': 'theme-blue',
    '🔌': 'theme-slate',
    '🏪': 'theme-emerald',
    '🤝': 'theme-blue',
    '🎯': 'theme-rose'
}

def replace_pill(match):
    prefix = match.group(1)
    emoji = match.group(2).strip()
    suffix = match.group(3)
    
    # We want to replace <div class="risk-pill"> with <div class="risk-pill theme-XYZ">
    # Wait, the match is just the inner part. I need a regex that captures the div too.
    return match.group(0)

# Actually it's easier to find <div class="risk-pill"> and look ahead
for emoji, theme in emoji_map.items():
    # Replace `<div class="risk-pill">\n                  <span class="risk-pill-anchor">EMOJI`
    # with `<div class="risk-pill THEME">\n                  <span class="risk-pill-anchor">EMOJI`
    
    # regex pattern
    pattern = r'(<div class="risk-pill)(">\s*<span class="risk-pill-anchor">)' + re.escape(emoji)
    c = re.sub(pattern, r'\1 ' + theme + r'\2' + emoji, c)

f.write_text(c)
print("SUCCESS")

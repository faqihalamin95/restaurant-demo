import re
from pathlib import Path

f = Path('/home/faqih/projects/restaurant-demo/evidence_en/pages/02-branch-performance/deepdive.md')
c = f.read_text()

css_to_remove = """
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
c = c.replace(css_to_remove, '')

# 2. Revert the risk-pill base class
c = c.replace('.risk-pill {\n  display: flex;\n  border: 1px solid transparent; border-radius: 12px; margin: 4px;', '.risk-pill {\n  display: flex;')

# 3. Add back the deleted hover rules right before .risk-pill-anchor {
old_hover_rules = """
.risk-row.purple-theme .risk-pill:hover { background: rgba(168,85,247,0.05); }
.risk-row.blue-theme .risk-pill:hover { background: rgba(59,130,246,0.05); }
.risk-row.slate-theme .risk-pill:hover { background: rgba(15,23,42,0.03); }

"""
c = c.replace('.risk-pill-anchor {\n  font-size: 1.15rem;', old_hover_rules + '.risk-pill-anchor {\n  font-size: 1.15rem;')

# Add back anchor backgrounds
old_anchor_rules = """
.risk-row.purple-theme .risk-pill-anchor { background: rgba(168,85,247,0.10); }
.risk-row.blue-theme .risk-pill-anchor { background: rgba(59,130,246,0.10); }
.risk-row.slate-theme .risk-pill-anchor { background: rgba(15,23,42,0.06); }
"""
c = c.replace('.risk-pill-content {', old_anchor_rules + '\n.risk-pill-content {')

# Add back pros-cons-box backgrounds
old_pros_rules = """
.risk-row.purple-theme .pros-cons-box { background: rgba(168,85,247,0.03); border-color: rgba(168,85,247,0.1); }
.risk-row.blue-theme .pros-cons-box { background: rgba(59,130,246,0.03); border-color: rgba(59,130,246,0.1); }
.risk-row.slate-theme .pros-cons-box { background: rgba(15,23,42,0.02); border-color: rgba(15,23,42,0.06); }
"""
c = c.replace('</style>', old_pros_rules + '</style>')


# 4. Remove the theme-XYZ classes from the HTML
# Because I added `class="risk-pill theme-XYZ"`, I can just regex replace `class="risk-pill theme-[a-z]+"` back to `class="risk-pill"`
c = re.sub(r'class="risk-pill theme-[a-z]+"', 'class="risk-pill"', c)

f.write_text(c)
print("SUCCESS")

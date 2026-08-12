import re

def read_file(path):
    with open(path, 'r') as f:
        return f.read()

jam_raw = read_file('/home/faqih/projects/restaurant-demo/evidence/_backups/04-peak-hours/jam-sibuk.md')
musiman_raw = read_file('/home/faqih/projects/restaurant-demo/evidence/_backups/04-peak-hours/musiman.md')

# Extract SQL blocks
def get_sqls(text):
    return re.findall(r'```sql\s+\w+\n.*?```\n', text, re.DOTALL)

jam_sqls = get_sqls(jam_raw)
musiman_sqls = get_sqls(musiman_raw)

sql_dict = {}
for sql in jam_sqls + musiman_sqls:
    match = re.match(r'```sql\s+(\w+)\n', sql)
    if match:
        name = match.group(1)
        if name not in sql_dict:
            sql_dict[name] = sql

all_sqls_text = '\n'.join(sql_dict.values())

# Extract imports and styles
script_match_jam = re.search(r'<script>(.*?)</script>', jam_raw, re.DOTALL)
script_match_mus = re.search(r'<script>(.*?)</script>', musiman_raw, re.DOTALL)
style_match_jam = re.search(r'<style>(.*?)</style>', jam_raw, re.DOTALL)
style_match_mus = re.search(r'<style>(.*?)</style>', musiman_raw, re.DOTALL)

imports = set()
if script_match_jam:
    imports.update(script_match_jam.group(1).strip().split('\n'))
if script_match_mus:
    imports.update(script_match_mus.group(1).strip().split('\n'))

# Ensure PeakTabs is not missing
if "import PeakTabs" not in str(imports):
    pass # we don't need to import PeakTabs if it's auto-imported or not used in script

styles = []
if style_match_jam:
    styles.append(style_match_jam.group(1).strip())
if style_match_mus:
    styles.append(style_match_mus.group(1).strip())

script_text = f"<script>\n{chr(10).join(sorted(imports))}\n</script>\n" if imports else ""
style_text = f"<style>\n{chr(10).join(styles)}\n</style>\n" if styles else ""

# Extract UI body inside {#if branch_list.length > 0} ... {/if}
def extract_body(raw_text):
    start_tag = '{#if branch_list.length > 0}'
    start_idx = raw_text.find(start_tag)
    if start_idx == -1: return ""
    start_idx += len(start_tag)
    
    style_idx = raw_text.rfind('<style>')
    if style_idx == -1: style_idx = len(raw_text)
    
    end_idx = raw_text.rfind('{/if}', 0, style_idx)
    return raw_text[start_idx:end_idx].strip()

jam_body = extract_body(jam_raw)
mus_body = extract_body(musiman_raw)

# Remove the branch selector from both
btn_group_regex = r'<div style="margin-top: 24px; margin-bottom: 24px;">.*?<SectionCard.*?<ButtonGroup.*?</ButtonGroup>.*?</SectionCard>.*?</div>'
btn_group_match = re.search(btn_group_regex, jam_body, re.DOTALL)
branch_selector = btn_group_match.group(0) if btn_group_match else ""

if branch_selector:
    jam_body = jam_body.replace(branch_selector, "")

mus_btn_group_match = re.search(btn_group_regex, mus_body, re.DOTALL)
if mus_btn_group_match:
    mus_body = mus_body.replace(mus_btn_group_match.group(0), "")

deepdive_content = f"""---
title: Deepdive & Tren Musiman
sidebar_link: false
---

{script_text}

<PeakTabs activeTab="deepdive" />

{style_text}

{all_sqls_text}

{{#if branch_list.length > 0}}
  {{@const selectedBranch = String(inputs.pilih_cabang?.value ?? inputs.pilih_cabang ?? branch_list[0].branch_name)}}

  {branch_selector}

  <Tabs fullWidth=true>
    <Tab label="⏰ Jam & Hari Sibuk">
      <div class="tab-content-wrapper">
        {{#if true}}
        {jam_body}
        {{/if}}
      </div>
    </Tab>
    <Tab label="🔁 Tren Musiman">
      <div class="tab-content-wrapper">
        {{#if true}}
        {mus_body}
        {{/if}}
      </div>
    </Tab>
  </Tabs>

{{/if}}
"""

with open('/home/faqih/projects/restaurant-demo/evidence/pages/04-peak-hours/deepdive.md', 'w') as f:
    f.write(deepdive_content)
print("Merge script fixed and executed successfully.")

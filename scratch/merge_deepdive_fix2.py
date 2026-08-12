import re

def read_file(path):
    with open(path, 'r') as f:
        return f.read()

jam_raw = read_file('/home/faqih/projects/restaurant-demo/evidence/_backups/04-peak-hours/jam-sibuk.md')
musiman_raw = read_file('/home/faqih/projects/restaurant-demo/evidence/_backups/04-peak-hours/musiman.md')

def get_sqls(text):
    return re.findall(r'```sql\s+\w+\n.*?```\n', text, re.DOTALL)

sql_dict = {}
for sql in get_sqls(jam_raw) + get_sqls(musiman_raw):
    match = re.match(r'```sql\s+(\w+)\n', sql)
    if match: sql_dict[match.group(1)] = sql

all_sqls_text = '\n'.join(sql_dict.values())

imports = set()
for raw in [jam_raw, musiman_raw]:
    m = re.search(r'<script>(.*?)</script>', raw, re.DOTALL)
    if m: imports.update(m.group(1).strip().split('\n'))

styles = []
for raw in [jam_raw, musiman_raw]:
    m = re.search(r'<style>(.*?)</style>', raw, re.DOTALL)
    if m: styles.append(m.group(1).strip())

script_text = f"<script>\n{chr(10).join(sorted(imports))}\n</script>\n" if imports else ""
style_text = f"<style>\n{chr(10).join(styles)}\n</style>\n" if styles else ""

# Jam sibuk body:
s1 = jam_raw.find('{#if branch_list.length > 0}') + len('{#if branch_list.length > 0}')
e1 = jam_raw.rfind('{/if}')
# wait, there are two {/if} at the end of jam_raw. And <style> is after.
# let's just find the last {/if} before <style>
s_style = jam_raw.find('<style>')
e1 = jam_raw.rfind('{/if}', 0, s_style)
jam_body = jam_raw[s1:e1].strip()

# Musiman body:
s2 = musiman_raw.find('{#if branch_list.length > 0}') + len('{#if branch_list.length > 0}')
# musiman ends with </div> \n {/if}. We want to exclude the final {/if} because we will wrap it ourselves.
e2 = musiman_raw.rfind('{/if}')
mus_body = musiman_raw[s2:e2].strip()

# Remove the branch selector
btn_group_regex = r'<div style="margin-top: 24px; margin-bottom: 24px;">.*?<SectionCard.*?<ButtonGroup.*?</ButtonGroup>.*?</SectionCard>.*?</div>'

m1 = re.search(btn_group_regex, jam_body, re.DOTALL)
if m1: jam_body = jam_body.replace(m1.group(0), "")

m2 = re.search(btn_group_regex, mus_body, re.DOTALL)
if m2: mus_body = mus_body.replace(m2.group(0), "")

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

  {m1.group(0) if m1 else ""}

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
print("Done")

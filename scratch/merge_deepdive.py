import re

def read_file(path):
    with open(path, 'r') as f:
        return f.read()

jam_raw = read_file('/home/faqih/projects/restaurant-demo/evidence/pages/04-peak-hours/jam-sibuk.md')
musiman_raw = read_file('/home/faqih/projects/restaurant-demo/evidence/pages/04-peak-hours/musiman.md')

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

styles = []
if style_match_jam:
    styles.append(style_match_jam.group(1).strip())
if style_match_mus:
    styles.append(style_match_mus.group(1).strip())

script_text = f"<script>\n{chr(10).join(sorted(imports))}\n</script>\n" if imports else ""
style_text = f"<style>\n{chr(10).join(styles)}\n</style>\n" if styles else ""

# Extract UI body
# In jam-sibuk, UI starts at `{#if branch_list.length > 0}`
# We want to extract the ButtonGroup part once, and then the rest into Tab 1.
# But it's easier if we just find `{#if branch_list.length > 0}` and get the block.
# Actually, the user wants the Branch Selector to be at the top, then Tabs.

jam_body_match = re.search(r'{#if branch_list.length > 0}(.*?){/if}', jam_raw, re.DOTALL)
mus_body_match = re.search(r'{#if branch_list.length > 0}(.*?){/if}', musiman_raw, re.DOTALL)

jam_body = jam_body_match.group(1) if jam_body_match else ""
mus_body = mus_body_match.group(1) if mus_body_match else ""

# The branch selector in jam_body is inside `<SectionCard>`
# Let's remove it from the tabs and put it at the top.
btn_group_regex = r'<div style="margin-top: 24px; margin-bottom: 24px;">.*?<SectionCard.*?<ButtonGroup.*?</ButtonGroup>.*?</SectionCard>.*?</div>'
btn_group_match = re.search(btn_group_regex, jam_body, re.DOTALL)

branch_selector = btn_group_match.group(0) if btn_group_match else ""

if branch_selector:
    jam_body = jam_body.replace(branch_selector, "")

# Same for musiman.md
mus_btn_group_match = re.search(btn_group_regex, mus_body, re.DOTALL)
if mus_btn_group_match:
    mus_body = mus_body.replace(mus_btn_group_match.group(0), "")

# Some consts might be duplicated, but since they are in different Tabs (which we can put in different {#if true} blocks or similar to scope them), or we can just leave them. Wait, Svelte `{@const}` is block-scoped! So wrapping each tab in `<div>` or `{#if true}` works.

deepdive_content = f"""---
title: Deepdive & Tren Musiman
sidebar_link: true
---

{script_text}

{style_text}

{all_sqls_text}

{{#if branch_list.length > 0}}
  {{@const selectedBranch = String(inputs.pilih_cabang?.value ?? inputs.pilih_cabang ?? branch_list[0].branch_name)}}

  {branch_selector}

  <Tabs fullWidth=true>
    <Tab label="Jam & Hari Sibuk">
      <div class="tab-content-wrapper">
        {{#if true}}
        {jam_body}
        {{/if}}
      </div>
    </Tab>
    <Tab label="Tren Musiman">
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
print("Merge script executed successfully.")

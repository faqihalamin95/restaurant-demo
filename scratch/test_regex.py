import re
def read_file(path):
    with open(path, 'r') as f: return f.read()

jam_raw = read_file('/home/faqih/projects/restaurant-demo/evidence/_backups/04-peak-hours/jam-sibuk.md')
musiman_raw = read_file('/home/faqih/projects/restaurant-demo/evidence/_backups/04-peak-hours/musiman.md')

def get_body(raw):
    s = raw.find('{#if branch_list.length > 0}') + len('{#if branch_list.length > 0}')
    e = raw.rfind('{/if}', 0, raw.rfind('<style>'))
    return raw[s:e]

j = get_body(jam_raw)
m = get_body(musiman_raw)

btn_group_regex = r'<div style="margin-top: 24px; margin-bottom: 24px;">.*?<SectionCard.*?<ButtonGroup.*?</ButtonGroup>.*?</SectionCard>.*?</div>'
match_j = re.search(btn_group_regex, j, re.DOTALL)
match_m = re.search(btn_group_regex, m, re.DOTALL)

print("Jam match:", match_j.group(0).count('<div') - match_j.group(0).count('</div'))
print("Mus match:", match_m.group(0).count('<div') - match_m.group(0).count('</div') if match_m else "No match")

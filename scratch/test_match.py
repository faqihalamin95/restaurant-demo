import re
raw = open('/home/faqih/projects/restaurant-demo/evidence/_backups/04-peak-hours/jam-sibuk.md').read()
btn_group_regex = r'<div style="margin-top: 24px; margin-bottom: 24px;">.*?<SectionCard.*?<ButtonGroup.*?</ButtonGroup>.*?</SectionCard>.*?</div>'
m1 = re.search(btn_group_regex, raw, re.DOTALL)
print(m1.group(0))

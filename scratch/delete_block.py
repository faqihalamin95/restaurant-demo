import re

with open('/home/faqih/projects/restaurant-demo/evidence/pages/04-peak-hours/deepdive.md', 'r') as f:
    content = f.read()

# Pattern to match everything from <SectionHeader "Diagnosis Pola Traffic" up to <Tabs fullWidth=true>
pattern = r'<SectionHeader\s+eyebrow="📊 Diagnosis Pola Traffic".*?</SectionCard>\s*</div>\s*(?=<Tabs fullWidth=true>)'

new_content = re.sub(pattern, '', content, flags=re.DOTALL)

with open('/home/faqih/projects/restaurant-demo/evidence/pages/04-peak-hours/deepdive.md', 'w') as f:
    f.write(new_content)

print("Block deleted successfully")

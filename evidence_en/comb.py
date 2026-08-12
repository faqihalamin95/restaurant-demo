import re
from pathlib import Path

f = Path('/home/faqih/projects/restaurant-demo/evidence_en/pages/02-branch-performance/deepdive.md')
c = f.read_text()

# Provide a list of common Indonesian words to scan for remaining untranslated text
indo_words = [r'\buntuk\b', r'\bdan\b', r'\batau\b', r'\byang\b', r'\bdari\b', r'\bke\b', r'\bdi\b', r'\bini\b', r'\bitu\b', r'\bdengan\b', r'\bakan\b', r'\bpada\b', r'\bjika\b', r'\bbisa\b', r'\bsudah\b', r'\bbelum\b']

for i, line in enumerate(c.splitlines()):
    for word in indo_words:
        if re.search(word, line, re.IGNORECASE):
            print(f"L{i+1}: {line.strip()}")
            break

import os
from pathlib import Path

def replace_in_files(directory):
    for path in Path(directory).rglob('*.md'):
        content = path.read_text()
        if 'restaurant_en.' in content:
            new_content = content.replace('restaurant_en.', 'restaurant.')
            path.write_text(new_content)
            print(f"Updated {path}")

if __name__ == '__main__':
    replace_in_files('evidence_en/pages')

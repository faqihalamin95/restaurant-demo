import os
import re

def process_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    original_content = content
    
    # 1. Replace id-ID with en-US
    content = content.replace("'id-ID'", "'en-US'")
    content = content.replace('"id-ID"', '"en-US"')
    
    # 2. Remove .replace('.', ',') which was used to convert dot to comma for Indonesian decimals
    content = content.replace(".replace('.', ',')", "")
    
    # 3. Rename idFormat to usFormat
    content = content.replace("function idFormat(", "function usFormat(")
    content = content.replace("idFormat(", "usFormat(")
    
    if content != original_content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Updated {filepath}")

def main():
    pages_dir = '/home/faqih/projects/restaurant-demo/evidence_en/pages'
    for root, dirs, files in os.walk(pages_dir):
        for file in files:
            if file.endswith('.md'):
                process_file(os.path.join(root, file))
                
if __name__ == '__main__':
    main()

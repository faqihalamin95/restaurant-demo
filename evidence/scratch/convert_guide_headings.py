import os
import re

pages_dir = "/home/faqih/projects/restaurant-demo/evidence/pages"

details_block_pattern = re.compile(
    r'(<div class=\"guide-body\">)(.*?)(</div>)',
    re.DOTALL | re.IGNORECASE
)

def process_block(match):
    prefix = match.group(1)
    body = match.group(2)
    suffix = match.group(3)
    
    # Replace bold emoji headings: **📦 Title** or **📦 Title — Sub**
    new_body = re.sub(
        r'(^|\n)([ \t]*)\*\*([^\w\s\d\*\[\]\(\)\<\>\&]+.*?)\*\*[ \t]*(?=\n|$)',
        r'\1\2<h4 class="guide-heading">\3</h4>',
        body
    )
    return prefix + new_body + suffix

# Run over all markdown files
for root, dirs, files in os.walk(pages_dir):
    for file in files:
        if file.endswith(".md") and not file.endswith(".md.bak"):
            file_path = os.path.join(root, file)
            with open(file_path, "r", encoding="utf-8") as f:
                content = f.read()
                
            new_content, count = details_block_pattern.subn(process_block, content)
            if count > 0:
                with open(file_path, "w", encoding="utf-8") as f:
                    f.write(new_content)
                print(f"Updated {count} guide-body blocks in {file_path}")

print("Completed guide headings conversion successfully!")

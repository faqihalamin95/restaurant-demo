import os
import re

pages_dir = "/home/faqih/projects/restaurant-demo/evidence/pages"

def parse_and_fix_grids(content):
    pos = 0
    while True:
        # Search for guide-grid opening tag
        match = re.search(r'<div class="guide-grid"[^>]*>', content[pos:])
        if not match:
            break
        
        start_idx = pos + match.start()
        grid_tag_end = pos + match.end()
        
        # Find the matching closing </div> by tracking div depth
        depth = 1
        curr = grid_tag_end
        while depth > 0 and curr < len(content):
            next_open = content.find('<div', curr)
            next_close = content.find('</div>', curr)
            
            if next_close == -1:
                break
                
            if next_open != -1 and next_open < next_close:
                depth += 1
                curr = next_open + 4
            else:
                depth -= 1
                curr = next_close + 6
        
        grid_end_idx = curr
        grid_body = content[grid_tag_end : grid_end_idx - 6]
        
        # Count actual guide-cards (using regex that avoids matching guide-card-icon/content/label/etc.)
        card_count = len(re.findall(r'<div class="guide-card\s', grid_body))
        
        # Determine the columns style:
        # 1. kurang dari 3 jadikan satu baris (N=1: 1 col, N=2: 2 cols)
        # 2. N=3: 3 cols (1 row)
        # 3. lebih dari 3 tapi genap (e.g. 4): 2 cols (2-2 layout)
        # 4. lebih dari 3 dan ganjil (e.g. 5): 3 cols (3 on top, remaining below)
        if card_count == 1:
            style = 'style="grid-template-columns: repeat(1, minmax(0, 1fr));"'
        elif card_count == 2:
            style = 'style="grid-template-columns: repeat(2, minmax(0, 1fr));"'
        elif card_count == 3:
            style = 'style="grid-template-columns: repeat(3, minmax(0, 1fr));"'
        elif card_count > 3 and card_count % 2 == 0:
            style = 'style="grid-template-columns: repeat(2, minmax(0, 1fr));"'
        else:
            style = 'style="grid-template-columns: repeat(3, minmax(0, 1fr));"'
            
        new_grid_tag = f'<div class="guide-grid" {style}>'
        
        # Replace tag
        content = content[:start_idx] + new_grid_tag + content[grid_tag_end:]
        
        # Update pos for next search
        pos = start_idx + len(new_grid_tag) + len(grid_body) + 6

    return content

# Run over all markdown files
for root, dirs, files in os.walk(pages_dir):
    for file in files:
        if file.endswith(".md") and not file.endswith(".md.bak"):
            file_path = os.path.join(root, file)
            with open(file_path, "r", encoding="utf-8") as f:
                content = f.read()
                
            new_content = parse_and_fix_grids(content)
            if new_content != content:
                with open(file_path, "w", encoding="utf-8") as f:
                    f.write(new_content)
                print(f"Fixed grid layouts in {file_path}")

print("Completed grid layout adjustment successfully!")

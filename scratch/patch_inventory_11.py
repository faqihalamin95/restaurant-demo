import re

filepath = "/home/faqih/projects/restaurant-demo/evidence/pages/03-inventori-stok/index.md"
with open(filepath, 'r') as f:
    content = f.read()

# Find the <style> block inside #makro-fix
style_start = content.find("<style>", content.find('id="makro-fix"'))
style_end = content.find("</style>", style_start) + 8

if style_start != -1 and style_end != -1:
    style_block = content[style_start:style_end]
    # Remove it from the current location
    content = content[:style_start] + content[style_end:]
    
    # Put it at the top, just below <InvStyles />
    insert_pos = content.find("<InvStyles />") + 13
    content = content[:insert_pos] + "\n\n" + style_block + content[insert_pos:]
    
    with open(filepath, 'w') as f:
        f.write(content)
    print("Extracted style block.")
else:
    print("Could not find style block.")

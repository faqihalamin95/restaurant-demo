import re

filepath = "/home/faqih/projects/restaurant-demo/evidence/pages/03-inventori-stok/index.md"
with open(filepath, 'r') as f:
    content = f.read()

# Find the second <style> tag
first_style_end = content.find("</style>")
second_style_start = content.find("<style>", first_style_end)

if second_style_start != -1:
    second_style_end = content.find("</style>", second_style_start) + 8
    
    # Extract inner content of the second style tag
    inner_css = content[second_style_start + 7 : second_style_end - 8].strip()
    
    # Remove the second style tag completely from the document
    content = content[:second_style_start] + content[second_style_end:]
    
    # Append the inner css to the first style tag
    content = content[:first_style_end] + "\n" + inner_css + "\n" + content[first_style_end:]
    
    with open(filepath, 'w') as f:
        f.write(content)
    print("Merged style tags successfully.")
else:
    print("Could not find second style tag.")

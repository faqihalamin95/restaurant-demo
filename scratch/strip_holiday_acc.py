with open('/home/faqih/projects/restaurant-demo/evidence/pages/04-peak-hours/deepdive.md', 'r') as f:
    content = f.read()

# Target start block to remove
start_block = """\t    <details class="acc-strategic">
\t      <summary>🎯 Efek Musim Liburan · Head-to-Head</summary>
\t      <div class="acc-body">"""

# Target end block to remove
end_block = """  </div>
</details>"""

if start_block in content:
    content = content.replace(start_block, '')
    # Replace the last occurrence of end_block before the {:else} tag
    pos = content.find('  <div>\n{:else}')
    if pos != -1:
        # find end_block before pos
        end_pos = content.rfind('  </div>\n</details>', 0, pos)
        if end_pos != -1:
            content = content[:end_pos] + content[end_pos + len('  </div>\n</details>'):]

with open('/home/faqih/projects/restaurant-demo/evidence/pages/04-peak-hours/deepdive.md', 'w') as f:
    f.write(content)

print("Stripped holiday accordion wrapper!")

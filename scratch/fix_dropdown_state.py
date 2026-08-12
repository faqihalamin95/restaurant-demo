import re

with open('/home/faqih/projects/restaurant-demo/evidence/pages/04-peak-hours/deepdive.md', 'r') as f:
    content = f.read()

# 1. Replace the selectedBranch definition
old_const = "{@const selectedBranch = String(inputs.pilih_cabang?.value ?? inputs.pilih_cabang ?? branch_list[0].branch_name)}"
new_const = """{@const isBranchSelected = inputs.pilih_cabang && !String(inputs.pilih_cabang).includes('SELECT NULL')}
  {@const selectedBranch = isBranchSelected ? String(inputs.pilih_cabang?.value ?? inputs.pilih_cabang) : null}"""
content = content.replace(old_const, new_const)

# 2. Add {#if isBranchSelected} before <SectionHeader eyebrow="📊 Diagnosis Pola Traffic"
insert_marker = '<SectionHeader \n    eyebrow="📊 Diagnosis Pola Traffic"'
if_block = """
  {#if isBranchSelected}

  <SectionHeader 
    eyebrow="📊 Diagnosis Pola Traffic\""""

# Handle potential variations in spacing
import re
content = re.sub(r'<SectionHeader\s+eyebrow="📊 Diagnosis Pola Traffic"', 
                 r'{#if isBranchSelected}\n\n  <SectionHeader \n    eyebrow="📊 Diagnosis Pola Traffic"', 
                 content)

# 3. Add {:else} ... {/if} right before the last {/if} of the file
# We'll split the content by the last {/if}
last_if_idx = content.rfind('{/if}')
if last_if_idx != -1:
    else_block = """
  {:else}
    <div style="text-align: center; padding: 60px 20px; background: #f9fafb; border-radius: 12px; margin-top: 32px; border: 1px dashed #cbd5e1;">
      <h3 style="margin-bottom: 12px; color: #475569;">☝️ Silakan Pilih Cabang Terlebih Dahulu</h3>
      <p style="color: #64748b; font-size: 1.05rem;">Gunakan menu pilihan cabang di atas untuk memuat diagnosis pola traffic, jam sibuk harian, dan tren musiman secara spesifik.</p>
    </div>
  {/if}
"""
    content = content[:last_if_idx] + else_block + content[last_if_idx:]

with open('/home/faqih/projects/restaurant-demo/evidence/pages/04-peak-hours/deepdive.md', 'w') as f:
    f.write(content)

print("Done wrapping in isBranchSelected")

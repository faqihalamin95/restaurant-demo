with open('/home/faqih/projects/restaurant-demo/evidence/pages/04-peak-hours/deepdive.md', 'r') as f:
    lines = f.readlines()

# Section 2 starts at line 964 (index 963) and ends at line 1040 (index 1040 inclusive)
# Let's double check lines[963] and lines[1040]
print("Start line 964:", lines[963].strip())
print("End line 1040:", lines[1040].strip())

sec2_lines = lines[963:1041]

# Insert missing </div> right before the last </div> in sec2_lines to close div 995
sec2_text = "".join(sec2_lines)
# We add </div> before the last </div>
last_div = sec2_text.rfind('</div>')
sec2_text_fixed = sec2_text[:last_div] + '</div>\n  ' + sec2_text[last_div:]

# Remove sec2_lines from original lines
remaining_lines = lines[:963] + lines[1041:]
full_text = "".join(remaining_lines)

# Rename Tab 1 label to ⏰ Jam Sibuk
full_text = full_text.replace('<Tab label="⏰ Jam &amp; Hari Sibuk">', '<Tab label="⏰ Jam Sibuk">')
full_text = full_text.replace('<Tab label="⏰ Jam & Hari Sibuk">', '<Tab label="⏰ Jam Sibuk">')

# Prepare Tab 2 HTML
tab2_html = f"""    </Tab>
    <Tab label="📅 Hari Sibuk">
      <div class="tab-content-wrapper">
        {{#if true}}
        {{@const activeBranchData = branch_peak_metrics.find(row => row.branch_name === selectedBranch)}}
        {{@const branchDayData = day_analysis.filter(row => row.branch_name === selectedBranch)}}
        {{@const branchWeekendData = weekend_analysis.filter(row => row.branch_name === selectedBranch)}}
        {{@const totalWeekday = branchWeekendData.find(r => r.period_type.includes('Weekday'))?.total_orders || 0}}
        {{@const totalWeekend = branchWeekendData.find(r => r.period_type.includes('Weekend'))?.total_orders || 0}}
        {{@const avgWeekday = totalWeekday / 4}}
        {{@const avgWeekend = totalWeekend / 3}}
        {{@const ratio = avgWeekday > 0 ? avgWeekend / avgWeekday : 99}}
        {{@const badgeText = ratio > 1.4 ? '🔥 Akhir Pekan Ekstrem' : ratio > 1.1 ? '🎉 Cenderung Akhir Pekan' : ratio > 0.9 ? '⚖️ Merata Stabil' : ratio > 0.7 ? '👔 Cenderung Hari Kerja' : '🏢 Hari Kerja Ekstrem'}}
        {{@const badgeBg = ratio > 1.4 ? '#fee2e2' : ratio > 1.1 ? '#fef3c7' : ratio > 0.9 ? '#dcfce7' : ratio > 0.7 ? '#eff6ff' : '#f3f4f6'}}
        {{@const badgeBorder = ratio > 1.4 ? '#fca5a5' : ratio > 1.1 ? '#fcd34d' : ratio > 0.9 ? '#86efac' : ratio > 0.7 ? '#bfdbfe' : '#d1d5db'}}
        {{@const badgeColor = ratio > 1.4 ? '#991b1b' : ratio > 1.1 ? '#92400e' : ratio > 0.9 ? '#166534' : ratio > 0.7 ? '#1e40af' : '#374151'}}
        {{@const badgeDesc = ratio > 1.4 ? 'Akhir pekan mendominasi telak. Maksimalkan stok Jumat-Minggu, tekan biaya operasional hari kerja.' : ratio > 1.1 ? 'Lebih ramai di akhir pekan. Geser jadwal libur staf inti ke awal minggu (Senin/Selasa).' : ratio > 0.9 ? 'Volume pesanan sangat konsisten tiap hari. Terapkan jadwal shift dan stok yang merata.' : ratio > 0.7 ? 'Ditopang pekerja kantoran. Jam makan siang krusial, siapkan promo keluarga di akhir pekan.' : 'Sangat bergantung jam kantor. Tekan drastis jumlah staf saat akhir pekan untuk efisiensi.'}}

{sec2_text_fixed}

        {{:else}}
          <div style="padding: 60px 20px; text-align: center; background: var(--color-background-secondary); border: 1px dashed var(--color-border-tertiary); border-radius: 12px; margin-top: 24px;">
            <h3 style="margin: 0 0 8px 0; color: var(--color-text-primary);">Data Tidak Ditemukan</h3>
            <p style="color: var(--color-text-secondary); margin: 0;">Silakan pilih minimal satu cabang yang valid di kotak filter di atas.</p>
          </div>
        {{/if}}
      </div>
"""

# Insert Tab 2 before <Tab label="🔁 Tren Musiman">
new_full_text = full_text.replace('<Tab label="🔁 Tren Musiman">', tab2_html + '    <Tab label="🔁 Tren Musiman">')

with open('/home/faqih/projects/restaurant-demo/evidence/pages/04-peak-hours/deepdive.md', 'w') as f:
    f.write(new_full_text)

print("Line-exact extraction successful!")

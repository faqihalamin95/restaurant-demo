def read_file(path):
    with open(path, 'r') as f:
        return f.read()

path = '/home/faqih/projects/restaurant-demo/evidence/pages/04-peak-hours/deepdive.md'
content = read_file(path)

css = """
.archetype-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 16px;
  margin-bottom: 32px;
  margin-top: 24px;
}
.archetype-card {
  border-radius: 12px;
  padding: 18px;
  border: 2px solid transparent;
  transition: all 0.3s ease;
  background: var(--color-background-secondary);
}
.archetype-card.inactive {
  opacity: 0.35;
  filter: grayscale(100%);
  transform: scale(0.98);
}
.archetype-card.active {
  opacity: 1;
  filter: none;
  transform: scale(1);
  box-shadow: 0 10px 25px -5px rgba(0,0,0,0.1);
}
.archetype-card.active.steady {
  border-color: #3b82f6;
  background: linear-gradient(to bottom right, #ffffff, #eff6ff);
}
.archetype-card.active.twin {
  border-color: #f97316;
  background: linear-gradient(to bottom right, #ffffff, #fff7ed);
}
.archetype-card.active.surge {
  border-color: #a855f7;
  background: linear-gradient(to bottom right, #ffffff, #faf5ff);
}
.arch-header {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 12px;
}
.arch-icon {
  font-size: 2rem;
  line-height: 1;
}
.arch-title {
  margin: 0;
  font-size: 1.15rem;
  font-weight: 800;
  color: var(--color-text-primary);
}
.arch-desc {
  font-size: 0.85rem;
  color: var(--color-text-secondary);
  line-height: 1.4;
  margin-bottom: 12px;
}
.arch-hr {
  font-size: 0.82rem;
  padding: 10px;
  border-radius: 8px;
  background: rgba(255,255,255,0.7);
  color: var(--color-text-primary);
  border-left: 3px solid #cbd5e1;
}
.active.steady .arch-hr { border-left-color: #3b82f6; }
.active.twin .arch-hr { border-left-color: #f97316; }
.active.surge .arch-hr { border-left-color: #a855f7; }
"""

html = """
  <SectionHeader 
    eyebrow="📊 Diagnosis Pola Traffic"
    title="Karakteristik Cabang"
    description="Sistem membaca pergerakan pesanan di cabang ini lalu mencocokkannya dengan 3 kepribadian operasional di bawah. Kartu yang menyala adalah taktik shift yang paling optimal."
  />

  {@const activePeak = branch_peak_metrics.find(row => row.branch_name === selectedBranch)}
  {@const surge = activePeak?.max_demand_surge ?? 0}
  {@const isSteady = surge > 0 && surge < 1.6}
  {@const isTwin = surge >= 1.6 && surge <= 2.5}
  {@const isSurge = surge > 2.5}

  <div class="archetype-grid">
    <!-- Card 1: Steady Stream -->
    <div class="archetype-card {isSteady ? 'active steady' : 'inactive'}">
       <div class="arch-header">
         <span class="arch-icon">🌊</span>
         <h4 class="arch-title">Aliran Tenang</h4>
       </div>
       <div class="arch-body">
         <p class="arch-desc"><strong>Data:</strong> Rasio lonjakan rendah (< 1.6x). Traffic stabil sepanjang hari tanpa gelombang drastis.</p>
         <div class="arch-hr"><strong>Adaptasi HR:</strong> Ideal untuk <strong>Shift Blok Standar</strong> (mis: 8-to-4). Prioritaskan staf full-time.</div>
       </div>
    </div>

    <!-- Card 2: Twin Peaks -->
    <div class="archetype-card {isTwin ? 'active twin' : 'inactive'}">
       <div class="arch-header">
         <span class="arch-icon">🎢</span>
         <h4 class="arch-title">Gunung Kembar</h4>
       </div>
       <div class="arch-body">
         <p class="arch-desc"><strong>Data:</strong> Rasio lonjakan medium (1.6x - 2.5x). Traffic meledak khusus di jam makan siang & malam.</p>
         <div class="arch-hr"><strong>Adaptasi HR:</strong> Terapkan <strong>Split Shift</strong> (Jeda istirahat panjang) untuk memotong idle cost sore hari.</div>
       </div>
    </div>

    <!-- Card 3: Flash Surge -->
    <div class="archetype-card {isSurge ? 'active surge' : 'inactive'}">
       <div class="arch-header">
         <span class="arch-icon">⛈️</span>
         <h4 class="arch-title">Badai Singkat</h4>
       </div>
       <div class="arch-body">
         <p class="arch-desc"><strong>Data:</strong> Rasio lonjakan ekstrem (> 2.5x). Sebagian besar omzet dicetak dalam jendela waktu sempit.</p>
         <div class="arch-hr"><strong>Adaptasi HR:</strong> Ekosistem keras. Kerahkan <strong>Part-timer</strong> sebagai pasukan bantuan harian khusus di jam puncak.</div>
       </div>
    </div>
  </div>
"""

# Inject CSS
if '.archetype-grid' not in content:
    content = content.replace('</style>', css + '\n</style>')

# Inject HTML
if 'class="archetype-grid"' not in content:
    content = content.replace('  <Tabs fullWidth=true>', html + '\n  <Tabs fullWidth=true>')

with open(path, 'w') as f:
    f.write(content)
print("Injected Archetype Cards")

with open('/home/faqih/projects/restaurant-demo/evidence/pages/04-peak-hours/deepdive.md', 'r') as f:
    content = f.read()

css = """
.theory-box {
  display: flex; gap: 12px; margin-top: 24px; padding: 16px;
  background: #f8fafc; border-radius: 12px; border: 1px dashed #cbd5e1;
}
.theory-icon { font-size: 1.5rem; }
.theory-text { font-size: 0.9rem; color: #475569; line-height: 1.5; }
.rec-block h4 { margin: 0 0 12px 0; font-size: 1.05rem; color: #1e293b; }
.rec-block p { font-size: 0.9rem; color: #475569; line-height: 1.5; margin-bottom: 12px; }
.rec-pro { color: #059669 !important; font-weight: 500; }
.rec-con { color: #d97706 !important; font-weight: 500; }
"""
if '.theory-box' not in content:
    content = content.replace('</style>', css + '\n</style>')

html = """
  <div style="margin-top: 32px; margin-bottom: 32px;">
    <SectionCard 
      eyebrow="<span style='font-size: 12px;'>⚖️ Solusi Kapasitas</span>" 
      title="Rekomendasi Adaptasi Penjadwalan & Operasional" 
      description="Pilihan strategi untuk menghadapi volatilitas traffic harian dan mingguan tanpa membengkakkan biaya tenaga kerja (labor cost)."
    >
      <div class="kpi-row-3">
        <div class="rec-block" style="border-top: 4px solid #3b82f6; background: #fff;">
           <h4>⏱️ Opsi A: Split Shift (Shift Jeda)</h4>
           <p>Pecah shift karyawan menjadi dua blok terpisah (misal: 10:00-14:00 & 17:00-21:00) khusus untuk mencakup dua jendela jam puncak.</p>
           <p class="rec-pro">✅ Pro: Menghilangkan 100% idle cost di jam sepi sore hari.</p>
           <p class="rec-con">⚠️ Kontra: Sulit diterima karyawan karena waktu tunggu yang lama. Membutuhkan insentif tambahan.</p>
        </div>
        
        <div class="rec-block" style="border-top: 4px solid #f59e0b; background: #fff;">
           <h4>🧑‍🤝‍🧑 Opsi B: Pasukan Part-Timer</h4>
           <p>Pertahankan jadwal kru inti tetap datar, dan suntikkan tenaga paruh waktu (part-timer) hanya di hari akhir pekan atau musim liburan panjang.</p>
           <p class="rec-pro">✅ Pro: Fleksibel dan murah. Margin profit akhir pekan dan Q4 akan maksimal.</p>
           <p class="rec-con">⚠️ Kontra: Kualitas pelayanan rentan menurun jika training part-timer tidak memadai.</p>
        </div>
        
        <div class="rec-block" style="border-top: 4px solid #10b981; background: #fff;">
           <h4>🔄 Opsi C: Rotasi Libur Silang</h4>
           <p>Geser jatah libur mingguan staf inti dari akhir pekan (Sabtu-Minggu) ke hari kerja yang secara data paling sepi (Senin-Selasa).</p>
           <p class="rec-pro">✅ Pro: Kapasitas maksimal di hari krusial tanpa menambah total beban gaji bulanan.</p>
           <p class="rec-con">⚠️ Kontra: Menimbulkan ketidakpuasan jika rotasi libur tidak digilir dengan adil antar kru.</p>
        </div>
      </div>

      <div class="theory-box">
         <div class="theory-icon">📎</div>
         <div class="theory-text">
            Biaya tenaga kerja (<em>Labor Cost</em>) yang sehat maksimal berada di angka 15-20% dari total omzet. Volatilitas <i>traffic</i> ekstrem memaksa Anda merancang <i>roster</i> secara dinamis agar persentase ini tidak membengkak akibat menggaji staf yang menganggur (<em>idle</em>) di jam sepi.<br>
            <strong>Landasan Teori: Konsep Lean Staffing & Penjadwalan Dinamis</strong>
         </div>
      </div>
    </SectionCard>
  </div>
"""

if 'Opsi A: Split Shift' not in content:
    content = content.replace('<Tabs fullWidth=true>', html + '\n  <Tabs fullWidth=true>')

with open('/home/faqih/projects/restaurant-demo/evidence/pages/04-peak-hours/deepdive.md', 'w') as f:
    f.write(content)
print("Injected HR Edu Cards")

with open('/home/faqih/projects/restaurant-demo/evidence/pages/04-peak-hours/deepdive.md', 'r') as f:
    lines = f.readlines()

# Let's inspect the lines around section-eyebrow 📈 KURVA NADI DEMAND
start_idx = None
end_idx = None
for idx, line in enumerate(lines):
    if '📈 KURVA NADI DEMAND' in line:
        start_idx = idx - 2 # <div class="section-head...
    if '📌 <strong>Rostering (Meso):</strong>' in line:
        end_idx = idx + 4 # closing divs

print(f"start_idx: {start_idx}, end_idx: {end_idx}")

new_section_html = """        <div class="section-head tight" style="margin-bottom: 20px;">
          <div>
            <div class="section-eyebrow">📈 KURVA NADI DEMAND (08:00 - 22:00)</div>
            <h3 class="section-title">Bagaimana bentuk lonjakan pesanan di setiap hari pada jam operasional?</h3>
            <p class="section-copy">Perbandingan kurva lonjakan jam sibuk (08:00–22:00). Garis Biru Putus-putus (Senin–Kamis) mewakili hari kerja, sedangkan Garis Oranye/Amber Tebal (Jumat–Minggu) mewakili akhir pekan.</p>
          </div>
        </div>

        <div style="width: 100%; height: 420px; margin-top: 12px;">
          <ECharts config={{
            tooltip: {
              trigger: 'axis',
              axisPointer: { type: 'cross' },
              formatter: function(params) {
                if (!params || params.length === 0) return '';
                let hour = params[0].axisValue;
                let html = "<div style='font-weight:700;margin-bottom:6px;border-bottom:1px solid rgba(0,0,0,0.1);padding-bottom:4px;'>⏰ Jam " + hour + "</div>";
                params.forEach(function(item) {
                  const isWeekend = ['Jumat', 'Sabtu', 'Minggu'].includes(item.seriesName);
                  const icon = isWeekend ? '🟧' : '🟦';
                  html += "<div style='display:flex;justify-content:space-between;gap:16px;font-size:12px;margin:3px 0;'>" +
                    "<span>" + icon + " " + item.seriesName + "</span>" +
                    "<span style='font-weight:700;'>" + Math.round(item.value[1]).toLocaleString('id-ID') + " order</span></div>";
                });
                return html;
              }
            },
            legend: {
              data: ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'],
              top: 0,
              textStyle: { fontSize: 12 }
            },
            grid: { top: 40, right: 20, bottom: 30, left: 50 },
            xAxis: {
              type: 'category',
              data: Array.from({length: 15}, (_, i) => (i + 8) + ':00'),
              boundaryGap: false,
              axisLabel: { interval: 0 }
            },
            yAxis: { type: 'value', name: 'Total Order' },
            color: ['#93c5fd', '#60a5fa', '#3b82f6', '#1d4ed8', '#fbbf24', '#f97316', '#dc2626'],
            series: ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'].map(function(day) {
              const isWknd = ['Jumat', 'Sabtu', 'Minggu'].includes(day);
              const dayRows = branchHeatmap.filter(function(r) { return r.hari === day; });
              const rowMap = Object.fromEntries(dayRows.map(function(r) { return [r.order_hour, r.total_orders]; }));
              const points = Array.from({length: 15}, (_, i) => {
                const h = i + 8;
                return [`${h}:00`, rowMap[h] || 0];
              });
              return {
                name: day,
                type: 'line',
                smooth: true,
                symbol: 'circle',
                symbolSize: isWknd ? 6 : 4,
                lineStyle: {
                  width: isWknd ? 3 : 2,
                  type: isWknd ? 'solid' : 'dashed'
                },
                data: points
              };
            })
          }} />
        </div>

        <div class="chart-insight-bar" style="margin-top: 16px;">
          📌 <strong>Manajemen Shift (Mikro):</strong> Perhatikan pergeseran puncak kurva di jam operasional (08:00 - 22:00). Garis Oranye/Tebal (Akhir Pekan) yang melonjak di jam makan malam membutuhkan formasi dapur maksimal, sementara Garis Biru/Putus-putus (Hari Kerja) cenderung melandai lebih cepat.
          
          <details style="margin-top: 16px; font-size: 0.85rem; cursor: pointer;">
            <summary class="crisis-btn">
              🆘 Dapur kewalahan saat jam sibuk? Lakukan salah satu taktik darurat ini.
            </summary>
            <div style="display: flex; flex-direction: column; gap: 12px; margin-top: 8px; cursor: default; background: #f8fafc; padding: 16px; border-radius: 8px;">
              <div class="crisis-card crisis-card-1">
                <div class="crisis-emoji">⏳</div>
                <div>
                  <strong style="color: #0f172a; font-size: 0.9rem; display: block; margin-bottom: 4px;">Opsi A: Perpanjang Waktu Tunggu</strong>
                  <span style="color: #475569; line-height: 1.5; display: block;">Ubah estimasi waktu <i>prep-time</i> di aplikasi Ojol agar <i>driver</i> lambat datang dan dapur punya ruang napas melayani antrean <i>Dine-In</i>.</span>
                </div>
              </div>
              <div class="crisis-card crisis-card-2">
                <div class="crisis-emoji">⛔</div>
                <div>
                  <strong style="color: #0f172a; font-size: 0.9rem; display: block; margin-bottom: 4px;">Opsi B: Batasi Menu Ojol</strong>
                  <span style="color: #475569; line-height: 1.5; display: block;">"Sold Out"-kan sementara menu <i>online</i> yang proses pembuatannya paling lama atau butuh banyak alat.</span>
                </div>
              </div>
              <div class="crisis-card crisis-card-3">
                <div class="crisis-emoji">🔄</div>
                <div>
                  <strong style="color: #0f172a; font-size: 0.9rem; display: block; margin-bottom: 4px;">Opsi C: Rotasi Kilat</strong>
                  <span style="color: #475569; line-height: 1.5; display: block;">Tarik sementara staf dari stasiun persiapan atau kasir, dan perbantukan semua tangan ke jalur perakitan makanan.</span>
                </div>
              </div>
              <div style="font-size: 0.8rem; color: #64748b; margin-top: 6px; padding: 0 4px; font-style: italic;">
                *Catatan: Jika kemacetan sangat ekstrem, opsi-opsi di atas dapat dikombinasikan sesuai kebutuhan operasional.
              </div>
            </div>
          </details>
        </div>
"""

updated_lines = lines[:start_idx] + [new_section_html] + lines[end_idx:]

with open('/home/faqih/projects/restaurant-demo/evidence/pages/04-peak-hours/deepdive.md', 'w') as f:
    f.writelines(updated_lines)

print("Standalone Tab 1 updated successfully!")

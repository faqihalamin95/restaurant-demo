with open('/home/faqih/projects/restaurant-demo/evidence/pages/04-peak-hours/deepdive.md', 'r') as f:
    content = f.read()

# 1. Inject SQL Query after heatmap_data query
sql_to_inject = """

```sql hourly_ordertype_breakdown
SELECT
    branch_name,
    order_hour,
    CASE dayofweek(order_date)
        WHEN 0 THEN 7
        ELSE dayofweek(order_date)
    END AS sort_order,
    CASE dayofweek(order_date)
        WHEN 0 THEN 'Minggu'
        WHEN 1 THEN 'Senin'
        WHEN 2 THEN 'Selasa'
        WHEN 3 THEN 'Rabu'
        WHEN 4 THEN 'Kamis'
        WHEN 5 THEN 'Jumat'
        WHEN 6 THEN 'Sabtu'
    END AS hari,
    CASE 
        WHEN order_type = 'dine_in' THEN '🍽️ Dine-In'
        WHEN order_type = 'takeaway' THEN '🥡 Takeaway'
        ELSE '🛵 Delivery'
    END AS order_type,
    SUM(total_orders) AS total_orders
FROM restaurant.peak_hours
WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.peak_hours) - INTERVAL '29 days'
GROUP BY branch_name, order_hour, sort_order, hari, 
    CASE 
        WHEN order_type = 'dine_in' THEN '🍽️ Dine-In'
        WHEN order_type = 'takeaway' THEN '🥡 Takeaway'
        ELSE '🛵 Delivery'
    END
ORDER BY branch_name, sort_order, order_hour
```"""

content = content.replace("ORDER BY branch_name, sort_order, order_hour\n```\n\n```sql daypart_data", "ORDER BY branch_name, sort_order, order_hour\n```" + sql_to_inject + "\n\n```sql daypart_data")

# 2. Inject UI Component right after crisis details in Tab 1
ui_component = """
        <hr style="border: none; border-top: 2px dashed var(--color-border-tertiary, #e5e7eb); margin: 40px 0 32px 0;" />

        <div class="section-head tight" style="margin-bottom: 16px;">
          <div>
            <div class="section-eyebrow">📊 KOMPOSISI TIPE PESANAN PER JAM</div>
            <h3 class="section-title">Bagaimana pergeseran proporsi Dine-In vs Takeaway vs Delivery di setiap jam?</h3>
            <p class="section-copy">Pilih hari tertentu untuk membedah rincian persentase tipe pesanan (08:00–22:00). Gunakan data ini untuk mengantisipasi kebutuhan piring/meja vs kantong pembungkus.</p>
          </div>
        </div>

        <div style="margin-bottom: 20px;">
          <ButtonGroup name="pilih_hari_breakdown">
            <ButtonGroupItem value="Semua Hari" valueLabel="🌐 Rata-rata Semua Hari" default />
            <ButtonGroupItem value="Senin" valueLabel="Senin" />
            <ButtonGroupItem value="Selasa" valueLabel="Selasa" />
            <ButtonGroupItem value="Rabu" valueLabel="Rabu" />
            <ButtonGroupItem value="Kamis" valueLabel="Kamis" />
            <ButtonGroupItem value="Jumat" valueLabel="Jumat" />
            <ButtonGroupItem value="Sabtu" valueLabel="Sabtu" />
            <ButtonGroupItem value="Minggu" valueLabel="Minggu" />
          </ButtonGroup>
        </div>

        {@const selectedHari = String(inputs.pilih_hari_breakdown?.value ?? inputs.pilih_hari_breakdown ?? 'Semua Hari')}
        {@const branchBreakdownData = hourly_ordertype_breakdown.filter(r => r.branch_name === selectedBranch)}
        {@const activeDayData = selectedHari === 'Semua Hari' || selectedHari.includes('SELECT NULL') ? branchBreakdownData : branchBreakdownData.filter(r => r.hari === selectedHari)}

        {@const tDineIn = activeDayData.filter(r => r.order_type.includes('Dine-In')).reduce((a,b) => a + Number(b.total_orders), 0)}
        {@const tTakeaway = activeDayData.filter(r => r.order_type.includes('Takeaway')).reduce((a,b) => a + Number(b.total_orders), 0)}
        {@const tDelivery = activeDayData.filter(r => r.order_type.includes('Delivery')).reduce((a,b) => a + Number(b.total_orders), 0)}
        {@const tTotal = tDineIn + tTakeaway + tDelivery}

        {@const pctDineIn = tTotal > 0 ? ((tDineIn / tTotal) * 100).toFixed(1) : '0.0'}
        {@const pctTakeaway = tTotal > 0 ? ((tTakeaway / tTotal) * 100).toFixed(1) : '0.0'}
        {@const pctDelivery = tTotal > 0 ? ((tDelivery / tTotal) * 100).toFixed(1) : '0.0'}

        <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 24px;">
          <div style="background: #eff6ff; border: 1px solid #bfdbfe; padding: 16px 20px; border-radius: 12px; display: flex; align-items: center; gap: 16px;">
             <div style="font-size: 2rem;">🍽️</div>
             <div>
                <div style="font-size: 0.8rem; color: #1e40af; font-weight: 700; text-transform: uppercase;">Dine-In ({selectedHari.includes('SELECT NULL') ? 'Semua Hari' : selectedHari})</div>
                <div style="font-size: 1.4rem; font-weight: 800; color: #1e3a8a;">{pctDineIn}% <span style="font-size: 0.85rem; font-weight: 500; color: #3b82f6;">({tDineIn.toLocaleString('id-ID')} order)</span></div>
             </div>
          </div>

          <div style="background: #ecfdf5; border: 1px solid #a7f3d0; padding: 16px 20px; border-radius: 12px; display: flex; align-items: center; gap: 16px;">
             <div style="font-size: 2rem;">🥡</div>
             <div>
                <div style="font-size: 0.8rem; color: #065f46; font-weight: 700; text-transform: uppercase;">Takeaway ({selectedHari.includes('SELECT NULL') ? 'Semua Hari' : selectedHari})</div>
                <div style="font-size: 1.4rem; font-weight: 800; color: #064e3b;">{pctTakeaway}% <span style="font-size: 0.85rem; font-weight: 500; color: #10b981;">({tTakeaway.toLocaleString('id-ID')} order)</span></div>
             </div>
          </div>

          <div style="background: #fff7ed; border: 1px solid #fed7aa; padding: 16px 20px; border-radius: 12px; display: flex; align-items: center; gap: 16px;">
             <div style="font-size: 2rem;">🛵</div>
             <div>
                <div style="font-size: 0.8rem; color: #9a3412; font-weight: 700; text-transform: uppercase;">Delivery / Ojol ({selectedHari.includes('SELECT NULL') ? 'Semua Hari' : selectedHari})</div>
                <div style="font-size: 1.4rem; font-weight: 800; color: #7c2d12;">{pctDelivery}% <span style="font-size: 0.85rem; font-weight: 500; color: #f97316;">({tDelivery.toLocaleString('id-ID')} order)</span></div>
             </div>
          </div>
        </div>

        <div style="width: 100%; height: 380px; margin-top: 12px;">
          <ECharts config={{
            tooltip: {
              trigger: 'axis',
              axisPointer: { type: 'shadow' },
              formatter: function(params) {
                if (!params || params.length === 0) return '';
                let hour = params[0].axisValue;
                let total = params.reduce(function(acc, p) { return acc + Number(p.value || 0); }, 0);
                let dayLabel = selectedHari.includes('SELECT NULL') ? 'Semua Hari' : selectedHari;
                let html = "<div style='font-weight:700;margin-bottom:6px;border-bottom:1px solid rgba(0,0,0,0.1);padding-bottom:4px;'>⏰ Jam " + hour + " — " + dayLabel + "</div>";
                params.forEach(function(p) {
                  let val = Number(p.value || 0);
                  let pct = total > 0 ? ((val / total) * 100).toFixed(1) : '0.0';
                  let marker = "<span style='display:inline-block;margin-right:4px;border-radius:10px;width:10px;height:10px;background-color:" + p.color + ";'></span>";
                  html += "<div style='display:flex;justify-content:space-between;gap:16px;font-size:12px;margin:3px 0;'>" +
                    "<span>" + marker + " " + p.seriesName + "</span>" +
                    "<span style='font-weight:700;'>" + Math.round(val).toLocaleString('id-ID') + " order (" + pct + "%)</span></div>";
                });
                return html;
              }
            },
            legend: {
              data: ['🍽️ Dine-In', '🥡 Takeaway', '🛵 Delivery'],
              top: 0,
              textStyle: { fontSize: 12 }
            },
            grid: { top: 40, right: 20, bottom: 30, left: 50 },
            xAxis: {
              type: 'category',
              data: Array.from({length: 15}, (_, i) => (i + 8) + ':00'),
              boundaryGap: true
            },
            yAxis: {
              type: 'value',
              name: 'Total Order',
              axisLabel: { formatter: '{value}' }
            },
            color: ['#3b82f6', '#10b981', '#f97316'],
            series: ['🍽️ Dine-In', '🥡 Takeaway', '🛵 Delivery'].map(function(type) {
              const hours = Array.from({length: 15}, (_, i) => i + 8);
              const points = hours.map(function(h) {
                const typeRows = activeDayData.filter(function(r) { return r.order_hour === h && r.order_type === type; });
                const val = typeRows.reduce(function(a, b) { return a + Number(b.total_orders); }, 0);
                return [`${h}:00`, val];
              });
              return {
                name: type,
                type: 'bar',
                stack: 'total',
                data: points
              };
            })
          }} />
        </div>

        <div class="chart-insight-bar" style="margin-top: 16px;">
          📌 <strong>Taktik Operasional Dapur ({selectedHari.includes('SELECT NULL') ? 'Semua Hari' : selectedHari}):</strong> Perhatikan porsi warna hijau (Takeaway) dan oranye (Delivery). Jika porsi bungkus/ojol melonjak melebihi 40% di jam tertentu, pastikan meja pengemasan (*packaging station*) sudah terisi stok dus & plastik yang cukup.
        </div>"""

target_marker = "*Catatan: Jika kemacetan sangat ekstrem, opsi-opsi di atas dapat dikombinasikan sesuai kebutuhan operasional.\n                </div>\n              </div>\n            </details>\n          </div>"

if target_marker in content:
    content = content.replace(target_marker, target_marker + "\n" + ui_component)

with open('/home/faqih/projects/restaurant-demo/evidence/pages/04-peak-hours/deepdive.md', 'w') as f:
    f.write(content)

print("Injected Breakdown SQL & Component successfully!")

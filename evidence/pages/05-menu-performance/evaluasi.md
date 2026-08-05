---
title: Evaluasi
---

<script>
  import SectionCard from '$lib/SectionCard.svelte';
  
  $: donutData = typeof concentration_data !== 'undefined' ? Array.from(concentration_data).map(r => ({ value: r.rev, name: r.group_name })) : [];
  $: activeTop5Share = typeof menu_health_overview !== 'undefined' && menu_health_overview.length > 0 ? menu_health_overview[0].top5_share_30d : 0;
  
  $: donutConfig = {
    tooltip: { 
      trigger: 'item',
      formatter: function(params) {
        return params.name + ': Rp ' + Number(params.value).toLocaleString('id-ID') + ' (' + params.percent + '%)';
      }
    },
    legend: { show: false },
    series: [
      {
        name: 'Revenue',
        type: 'pie',
        radius: ['40%', '80%'],
        avoidLabelOverlap: true,
        itemStyle: { borderRadius: 4, borderColor: '#fff', borderWidth: 2 },
        label: { show: true, formatter: '{b}\n{d}%', position: 'outside', color: '#64748b', fontSize: 11 },
        color: ['#6366f1', '#6366f1', '#6366f1', '#6366f1', '#6366f1', '#cbd5e1'],
        data: donutData
      }
    ]
  };
</script>

<style>
.section-head { margin-bottom: 24px; }
.section-eyebrow { font-size: 12px; font-weight: 800; letter-spacing: 0.1em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 6px; }
.section-title { font-size: 1.5rem; font-weight: 800; color: var(--color-text-primary); margin: 0 0 8px; letter-spacing: -0.02em; }
.section-copy { font-size: 0.95rem; line-height: 1.6; color: var(--color-text-secondary); margin: 0; max-width: 65ch; }
.chart-insight-bar { margin-top: 14px; padding: 14px 16px; border-radius: 12px; border-left: 3px solid rgba(99,102,241,0.3); background: rgba(99,102,241,0.04); font-size: 0.85rem; line-height: 1.6; color: var(--color-text-secondary); }
.signal-card.safe { padding: 24px; border-radius: 16px; border: 1px solid rgba(22,163,74,0.2); background: linear-gradient(135deg, rgba(22,163,74,0.05), rgba(16,185,129,0.02)); text-align: center; }
.signal-label { font-size: 12px; font-weight: 800; text-transform: uppercase; color: #16a34a; letter-spacing: 0.1em; margin-bottom: 12px; }
.signal-title { font-size: 1.2rem; font-weight: 800; color: var(--color-text-primary); margin-bottom: 8px; }
.signal-copy { font-size: 0.9rem; color: var(--color-text-secondary); line-height: 1.6; max-width: 50ch; margin: 0 auto; }

.strategic-stack { border: 1px solid var(--color-border-tertiary); border-radius: 20px; background: var(--color-background-primary); overflow: hidden; box-shadow: 0 4px 20px rgba(0,0,0,0.03); }
.strategic-header { padding: 24px; border-bottom: 1px solid var(--color-border-tertiary); background: linear-gradient(135deg, rgba(0,0,0,0.02), rgba(0,0,0,0)); }
.strategic-eyebrow { font-size: 10px; font-weight: 800; letter-spacing: 0.12em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 8px; }
.strategic-title { font-size: 1.2rem; font-weight: 800; color: var(--color-text-primary); margin: 0 0 6px; letter-spacing: -0.01em; }
.strategic-copy { font-size: 0.9rem; line-height: 1.6; color: var(--color-text-secondary); margin: 0; max-width: 75ch; }
.acc-strategic { border-bottom: 1px solid var(--color-border-tertiary); }
.acc-strategic:last-child { border-bottom: none; }
.acc-strategic > summary { padding: 16px 24px; cursor: pointer; font-weight: 700; color: var(--color-text-primary); list-style: none; display: flex; align-items: center; justify-content: space-between; background: var(--color-background-secondary); font-size: 0.95rem; }
.acc-strategic > summary::-webkit-details-marker { display: none; }
.acc-strategic > summary::after { content: '+'; font-size: 1.2rem; font-weight: 400; color: var(--color-text-tertiary); transition: transform 0.2s; }
.acc-strategic[open] > summary::after { content: '−'; }
.acc-strategic[open] > summary { border-bottom: 1px solid var(--color-border-tertiary); background: var(--color-background-primary); }
</style>

<MenuTabs activeTab="evaluasi" />

```sql menu_health_overview
SELECT * FROM restaurant.mart_menu_health_overview
```

```sql top_movers
WITH movers AS (
  SELECT menu_name, pct_change_qty, qty_previous, qty_current,
         (qty_current - qty_previous) as qty_diff,
         ROW_NUMBER() OVER(ORDER BY pct_change_qty DESC) as rn_desc,
         ROW_NUMBER() OVER(ORDER BY pct_change_qty ASC) as rn_asc
  FROM restaurant.mart_movers_30d
  WHERE qty_previous >= 15
)
SELECT menu_name, pct_change_qty, qty_previous, qty_current, qty_diff
FROM movers 
WHERE rn_desc <= 3 OR rn_asc <= 3
ORDER BY pct_change_qty DESC
```

```sql concentration_data
WITH ranked AS (
  SELECT menu_name, total_revenue,
         ROW_NUMBER() OVER(ORDER BY total_revenue DESC) as rn
  FROM restaurant.mart_menu_engineering_30d
)
SELECT menu_name as group_name, total_revenue as rev, rn as sort_order FROM ranked WHERE rn <= 5
UNION ALL
SELECT 'Sisa Menu Lainnya' as group_name, SUM(total_revenue) as rev, 6 as sort_order FROM ranked WHERE rn > 5
ORDER BY sort_order
```

```sql passive_data
SELECT menu_name, category, total_qty as porsi, total_revenue as rev, (total_revenue / NULLIF(total_qty, 0)) as price
FROM restaurant.mart_menu_engineering_30d
WHERE total_qty < 15
ORDER BY total_qty ASC
```



<div class="strategic-stack" style="margin-top: 32px;">
  <div class="strategic-header">
    <div class="strategic-eyebrow">📈 Analisis Kesehatan Operasional</div>
    <div class="toc-anchor" style="position: absolute; opacity: 0; pointer-events: none; margin: 0; padding: 0; height: 0; overflow: hidden; font-size: 0px;">

## Keseimbangan Penjualan & Performa Menu

</div>
<h2 class="strategic-title">Keseimbangan Penjualan & Performa Menu</h2>
    <p class="strategic-copy">Gunakan view ini untuk mendeteksi apakah ritme penjualan seimbang dengan target, serta memantau ketimpangan revenue dan daftar hitam menu pasif.</p>
  </div>

  <details class="acc-strategic" open>
    <summary>📊 Detail Analisis Penjualan & Performa Menu</summary>
    <div class="acc-body" style="padding: 20px 16px 16px 16px;">
      
      <div style="display: flex; flex-direction: column; gap: 32px; padding-bottom: 20px;">
  {#if top_movers.length > 0}
  <div>
    <div class="section-head tight" style="margin-bottom: 12px;">
      <div>
        <div class="section-eyebrow">📈 Top Movers (Menu Stabil)</div>
        <h3 class="section-title">Menu mana yang mengalami perubahan tren terbesar?</h3>
        <p class="section-copy">Menampilkan menu dengan lonjakan dan penurunan persentase penjualan terbesar bulan ini.</p>
      </div>
    </div>
    <div>
      <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; align-items: start;">
        <div>
          <BarChart 
            data={top_movers} 
            x="menu_name" 
            y="pct_change_qty" 
            swapXY=true 
            title=""
          />
        </div>
        <div>
          <DataTable data={top_movers}>
            <Column id="menu_name" title="Menu" />
            <Column id="qty_previous" title="Sebelum" />
            <Column id="qty_current" title="Sekarang" />
            <Column id="qty_diff" title="Selisih" />
          </DataTable>
        </div>
      </div>
      <div class="chart-insight-bar" style="margin-top: 12px;">
        📌 <strong>Anomali Pergerakan:</strong> Perhatikan arah dan panjang batang pada grafik untuk melihat tren persentase. Lalu, cek tabel di sebelahnya untuk memvalidasi apakah persentase tersebut berdampak signifikan secara porsi riil.
      </div>
    </div>
  </div>
  {/if}

  <div>
    <div class="section-head tight" style="margin-bottom: 12px;">
      <div>
        <div class="section-eyebrow">🎯 Ketimpangan Revenue</div>
        <h3 class="section-title">Apakah omzet terlalu bergantung pada sedikit menu?</h3>
        <p class="section-copy">Top 5 menu unggulan menyumbang {activeTop5Share}% dari total revenue keseluruhan.</p>
      </div>
    </div>
    <div style="display: flex; align-items: center; justify-content: center;">
      <div style="height: 280px; width: 100%;">
        <ECharts config={donutConfig} />
      </div>
    </div>
    <div class="chart-insight-bar" style="margin-top: 16px;">
      📌 <strong>Risiko Ketergantungan:</strong> Jika porsi menu Top 5 mendominasi terlalu besar (Rasio >55%), pastikan ketersediaan bahan baku untuk menu tersebut tidak pernah putus, karena jika kosong, restoran kehilangan mayoritas omzetnya.
    </div>
  </div>

  <div>
    <div class="section-head tight" style="margin-bottom: 12px;">
      <div>
        <div class="section-eyebrow">🧊 Daftar Hitam Menu Pasif</div>
        <h3 class="section-title">Menu mana yang berisiko memicu food waste?</h3>
        <p class="section-copy">Menu sangat lambat (&lt;15 porsi/bulan). Rawan menumpuk di kulkas &amp; memicu food waste bahan bakunya.</p>
      </div>
    </div>
    <div>
      {#if passive_data.length > 0}
      <DataTable data={passive_data}>
        <Column id="menu_name" title="Menu" />
        <Column id="category" title="Kategori" />
        <Column id="price" title="Harga" fmt="idr" />
        <Column id="porsi" title="Terjual (Porsi)" />
      </DataTable>
      <div class="chart-insight-bar" style="margin-top: 12px;">
        📌 <strong>Evaluasi Pembaruan:</strong> Menu di tabel ini memiliki perputaran terlalu lambat. Pertimbangkan untuk merevisi resep, memberikan promo, atau menghapusnya sama sekali agar tidak menjadi beban inventori mati.
      </div>
      {:else}
      <div class="signal-card safe" style="margin-top:0;">
        <div class="signal-label">✅ Bersih</div>
        <div class="signal-title">Tidak ada menu yang terdeteksi pasif bulan ini.</div>
        <div class="signal-copy">Semua menu berhasil terjual dengan volume memadai. Beban inventori bahan baku lebih sehat!</div>
      </div>
      {/if}
    </div>
  </div>
      </div>
    </div>
  </details>
</div>

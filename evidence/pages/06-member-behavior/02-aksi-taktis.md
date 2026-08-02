---
sidebar: hide
title: Insight Member
---
<MemberTabs activeTab="taktis" />

```sql member_kpi_period
SELECT * FROM restaurant.member_member_kpi_period
WHERE period = '30d'
```



```sql retention_queue
SELECT 
  RIGHT(member_name, 4) as kode_member,
  tier,
  total_spend,
  CASE WHEN avg_visit_interval_days IS NULL THEN '-' ELSE CAST(ROUND(avg_visit_interval_days) AS INTEGER) || ' Hari' END as avg_visit_days,
  CAST(ROUND(delay_days) AS INTEGER) || ' Hari' as delay_days,
  '+62 812-3456-' || RIGHT(member_name, 4) as kontak,
  CASE 
    WHEN CAST(RIGHT(member_name, 1) AS INTEGER) IN (6, 8) THEN '✅ Sudah (WA)' 
    ELSE '⚠️ Belum' 
  END as status_followup,
  CASE 
    WHEN CAST(RIGHT(member_name, 1) AS INTEGER) IN (6, 8) THEN '13 Jul 2026' 
    ELSE '-' 
  END as terakhir_kontak
FROM restaurant.member_retention_queue
ORDER BY total_spend DESC
```

```sql retention_kpi
SELECT 
  COUNT(*) as total_churn,
  SUM(CASE WHEN tier = 'Gold' THEN 1 ELSE 0 END) as gold_churn
FROM restaurant.member_retention_queue
```

```sql retention_stats
SELECT
  SUM(total_spend * 0.1) as potential_loss
FROM restaurant.member_retention_queue
```

```sql milestone_queue
SELECT '4101' as kode_member, 'Gold' as tier, 49 as current_visits, 50 as target_milestone, 3450000 as total_spend, 'Suvenir Fisik' as reward_recommendation
UNION ALL
SELECT '8239' as kode_member, 'Silver' as tier, 24 as current_visits, 25 as target_milestone, 1820000 as total_spend, 'Menu Tambahan Gratis' as reward_recommendation
UNION ALL
SELECT '1923' as kode_member, 'Bronze' as tier, 9 as current_visits, 10 as target_milestone, 540000 as total_spend, 'Penyambutan Khusus' as reward_recommendation
```

```sql retention_by_tier
SELECT tier, COUNT(*) as jumlah_member
FROM restaurant.member_retention_queue
GROUP BY tier
ORDER BY 
  CASE tier 
    WHEN 'Gold' THEN 1 
    WHEN 'Silver' THEN 2
    WHEN 'Bronze' THEN 3
    ELSE 4
  END
```

```sql retention_aging
SELECT 
  CASE 
    WHEN delay_days <= 14 THEN 'Telat 8-14 Hari'
    WHEN delay_days <= 21 THEN 'Telat 15-21 Hari'
    ELSE 'Telat > 21 Hari'
  END as aging_group,
  COUNT(*) as jumlah_member
FROM restaurant.member_retention_queue
GROUP BY 1
ORDER BY 
  CASE aging_group 
    WHEN 'Telat 8-14 Hari' THEN 1
    WHEN 'Telat 15-21 Hari' THEN 2
    ELSE 3 
  END
```

```sql promo_leakage
SELECT 'Diskon 50% Pendaftar Baru' as promo_name, 120 as total_claim, 15 as return_visit, 12.5 as conversion_pct, 4500000 as margin_burn
UNION ALL
SELECT 'Free Dessert via IG Ads' as promo_name, 89 as total_claim, 12 as return_visit, 13.5 as conversion_pct, 1335000 as margin_burn
UNION ALL
SELECT 'Voucher Ulang Tahun' as promo_name, 45 as total_claim, 38 as return_visit, 84.4 as conversion_pct, 675000 as margin_burn
ORDER BY conversion_pct ASC
```

<script>
  function idFormat(num, dec = 0) {
    if (num === null || num === undefined) return '0';
    return new Intl.NumberFormat('id-ID', { minimumFractionDigits: dec, maximumFractionDigits: dec }).format(num);
  }

  let activeRate = 0;
  let goldChurn = 0;
  let totalChurn = 0;
  let totalMembers = 0;
  let churnRatePct = 0;
  let pctOrder = 0;
  let aov = 0;
  let aovNonMember = 0;
  let aovDiffPct = 0;
  let activationRatePct = 0;
  let totalMemberSpend = 0;
  let pctRevenueMember = 0;
  let totalMemberOrders = 0;
  let activeMembers = 0;
  let newMembers = 0;

  $: if (member_kpi_period && member_kpi_period.length > 0) {
     totalMembers = member_kpi_period[0].total_members;
     pctOrder = member_kpi_period[0].pct_order_member;
     aov = member_kpi_period[0].avg_order_value;
     aovNonMember = member_kpi_period[0].avg_order_value_non_member;
     activationRatePct = member_kpi_period[0].activation_rate_pct || 0;
     totalMemberSpend = member_kpi_period[0].total_member_spend;
     pctRevenueMember = member_kpi_period[0].pct_revenue_member;
     totalMemberOrders = member_kpi_period[0].total_member_orders;
     activeMembers = member_kpi_period[0].active_members;
     newMembers = member_kpi_period[0].new_members;
     
     if (aovNonMember > 0) {
       aovDiffPct = ((aov - aovNonMember) / aovNonMember) * 100;
     }
  }

  $: if (retention_kpi && retention_kpi.length > 0) {
      totalChurn = retention_kpi[0].total_churn;
      goldChurn = retention_kpi[0].gold_churn;
      if (totalMembers > 0) {
        churnRatePct = (totalChurn / totalMembers) * 100;
        activeMembers = totalMembers - totalChurn;
        activeRate = 100 - churnRatePct;
      }
   }

  let heroStatusClass = 'status-sehat';
  $: if (activeRate > 60) heroStatusClass = 'status-sehat';
  else if (activeRate >= 40) heroStatusClass = 'status-waspada';
  else heroStatusClass = 'status-kritis';

  let churnRiskState = 'safe';
  $: if (churnRatePct >= 20) churnRiskState = 'critical';
  else if (churnRatePct >= 10) churnRiskState = 'warn';
  else churnRiskState = 'safe';

  let actionColor = 'green';
  let iconAlert = '✅';
  let titleText = '';
  $: {
    actionColor = churnRiskState === 'safe' ? 'green' : churnRiskState === 'warn' ? 'amber' : 'red';
    iconAlert = churnRiskState === 'safe' ? '✅' : churnRiskState === 'warn' ? '⚠️' : '🚨';
    titleText = churnRiskState === 'safe' 
      ? 'Insight Operasional & Rekomendasi' 
      : churnRiskState === 'warn' 
        ? 'Panduan Eksekusi Taktis' 
        : 'Tindakan Kritis Dibutuhkan!';
  }

  let promoActivationState = 'safe';
  $: if (activationRatePct < 20) promoActivationState = 'critical';
  else if (activationRatePct < 40) promoActivationState = 'warn';
  else promoActivationState = 'safe';

  let safeCount = 0;
  let warnCount = 0;
  let criticalCount = 0;
  $: {
    let s = 0, w = 0, c = 0;
    
    if (churnRiskState === 'safe') s++;
    else if (churnRiskState === 'warn') w++;
    else c++;

    if (promoActivationState === 'safe') s++;
    else if (promoActivationState === 'warn') w++;
    else c++;

    safeCount = s;
    warnCount = w;
    criticalCount = c;
  }

  let chartOptionTier = {};
  $: if (retention_by_tier && retention_by_tier.length > 0) {
      chartOptionTier = {
         tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
         grid: { left: '2%', right: '10%', bottom: '2%', top: '2%', containLabel: true },
         xAxis: { type: 'value', splitLine: { show: false }, axisLabel: { show: false } },
         yAxis: { 
            type: 'category', 
            data: retention_by_tier.map(d => d.tier),
            axisLine: { show: false },
            axisTick: { show: false },
            axisLabel: { fontWeight: 'bold', color: '#64748b' },
            inverse: true
         },
         series: [
            {
               name: 'Member',
               type: 'bar',
               showBackground: true,
               backgroundStyle: { color: 'rgba(99, 102, 241, 0.05)', borderRadius: [0, 8, 8, 0] },
               data: retention_by_tier.map((d) => {
                  let color = '#94a3b8';
                  if (d.tier === 'Gold') color = '#fcd34d'; // soft gold
                  else if (d.tier === 'Silver') color = '#cbd5e1'; // soft silver
                  else if (d.tier === 'Bronze') color = '#d49a6a'; // soft bronze
                  
                  return {
                     value: d.jumlah_member,
                     itemStyle: { color: color, borderRadius: [0, 8, 8, 0] }
                  };
               }),
               label: { show: true, position: 'right', fontWeight: 'bold', color: '#334155' }
            }
         ]
      };
  }

  let chartOptionAging = {};
  $: if (retention_aging && retention_aging.length > 0) {
      chartOptionAging = {
         tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
         grid: { left: '5%', right: '5%', bottom: '5%', top: '15%', containLabel: true },
         xAxis: { 
            type: 'category', 
            data: retention_aging.map(d => d.aging_group),
            axisLine: { show: false },
            axisTick: { show: false },
            axisLabel: { fontWeight: 'bold', color: '#64748b' }
         },
         yAxis: { type: 'value', splitLine: { show: false }, axisLabel: { show: false } },
         series: [
            {
               name: 'Member',
               type: 'bar',
               barWidth: '45%',
               showBackground: true,
               backgroundStyle: { color: 'rgba(239, 68, 68, 0.05)', borderRadius: [8, 8, 0, 0] },
               data: retention_aging.map((d, i) => {
                  const colors = ['#f59e0b', '#f97316', '#ef4444'];
                  return {
                     value: d.jumlah_member,
                     itemStyle: { color: colors[i % colors.length], borderRadius: [8, 8, 0, 0] }
                  };
               }),
               label: { show: true, position: 'top', fontWeight: 'bold', color: '#334155' }
            }
         ]
      };
  }

  // States for Narrative Accordion
  let penetrasiState = 'safe';
  $: if (pctOrder >= 35) penetrasiState = 'safe';
  else if (pctOrder >= 20) penetrasiState = 'warn';
  else penetrasiState = 'critical';

  let aovState = 'safe';
  $: if (aov > 120000) aovState = 'safe';
  else if (aov > 100000) aovState = 'warn';
  else aovState = 'critical';
</script>

{#if Array.isArray(retention_queue)}

<!-- Outer Diagnostics Container 1 -->
<div id="churn" class="diagnostics-stack" style="margin-top: 32px; margin-bottom: 24px;">
  <div class="diagnostics-header">
    <div class="diagnostics-eyebrow">🚨 Intervensi Langsung</div>
    <h2 class="diagnostics-title">Penyelamatan Member VIP (Churn Risk)</h2>
    <p class="diagnostics-copy">Daftar member bernilai tinggi yang sudah melewati batas siklus kunjungan normal mereka. Segera lakukan penawaran untuk mencegah hilangnya omzet harian.</p>
  </div>
  
  <details class="acc-strategic">
    <summary>📊 Selami Data Penyelamatan Member</summary>

    <div class="acc-body">
      <div style="display: flex; flex-direction: column; gap: 24px;">
        
        <!-- 1. Insight / Paparan -->
        <div id="ringkasan-risiko">
          <div class="section-head tight" style="margin-bottom: 12px;">
            <div>
              <div class="section-eyebrow">🚨 Ringkasan Risiko</div>
              <h3 class="section-title">Indikator Risiko & Potensi Kerugian</h3>
              <p class="section-copy">Menampilkan ringkasan tingkat kebocoran member VIP beserta estimasi revenue yang terancam hangus jika tidak segera diselamatkan.</p>
            </div>
          </div>
          <div class="insight-grid">
            <div class="insight-card {churnRiskState}">
            <div class="insight-header">
              <span class="insight-icon">{churnRiskState === 'safe' ? '🛡️' : churnRiskState === 'warn' ? '⚠️' : '🚨'}</span>
              <span class="insight-title">Tingkat Kebocoran</span>
            </div>
            <div class="insight-body">
              <div class="insight-number">{idFormat(churnRatePct, 1)}<span class="insight-percent">%</span></div>
              <div class="insight-status-badge {churnRiskState}">{churnRiskState === 'safe' ? 'SEHAT' : churnRiskState === 'warn' ? 'WASPADA' : 'KRITIS'}</div>
            </div>
            <div class="insight-footer">
              Total <strong>{totalChurn} member</strong> masuk ke zona merah.
            </div>
          </div>

          <div class="insight-card target-card {totalChurn > 0 ? 'warn' : 'neutral'}">
            <div class="insight-header">
              <span class="insight-icon">🎯</span>
              <span class="insight-title">Target Penyelamatan Utama</span>
            </div>
            <div class="insight-body">
              <div class="insight-number">{goldChurn}<span class="insight-percent"> VIP</span></div>
              <div class="insight-status-badge neutral">GOLD TIER</div>
            </div>
            <div class="insight-footer">
              Prioritaskan menelepon atau WhatsApp member Gold ini hari ini.
            </div>
          </div>
        </div>

        <!-- 2. Potensi Kehilangan Omzet (Card Horizontal) -->
        {#if retention_stats && retention_stats.length > 0}
        <div class="loss-card">
           <div class="loss-card-content">
             <h4 class="loss-card-title">Potensi Kehilangan Omzet</h4>
             <p class="loss-card-desc">Estimasi revenue 30 hari ke depan yang hangus jika member VIP ini tidak diamankan.</p>
           </div>
           <div class="loss-card-value">
             Rp {idFormat(retention_stats[0].potential_loss)}
           </div>
          </div>
          {/if}
        </div>

        <!-- 3. Grafik Pendukung (Grid) -->
        <div>
          <div class="section-head tight" style="margin-bottom: 12px;">
            <div>
              <div class="section-eyebrow">📊 Profil Member Zona Merah</div>
              <h3 class="section-title">Siapa saja yang menghilang dan berapa lama?</h3>
              <p class="section-copy">Menampilkan distribusi tingkat membership yang berisiko churn beserta rentang durasi keterlambatan kunjungan mereka.</p>
            </div>
          </div>
          <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 24px;">
             <div style="background: linear-gradient(180deg, var(--color-background-primary), var(--color-background-secondary)); padding: 24px; border-radius: 16px; border: 1px solid var(--color-border-tertiary); box-shadow: 0 4px 12px rgba(0,0,0,0.02);">
               <h4 style="font-size: 13px; font-weight: 700; letter-spacing: 0.05em; text-transform: uppercase; color: var(--color-text-tertiary); margin-top: 0; margin-bottom: 24px;">Distribusi Tier Member Rawan</h4>
               <ECharts config={chartOptionTier} height="260px" />
           </div>
           <div style="background: linear-gradient(180deg, var(--color-background-primary), var(--color-background-secondary)); padding: 24px; border-radius: 16px; border: 1px solid var(--color-border-tertiary); box-shadow: 0 4px 12px rgba(0,0,0,0.02);">
             <h4 style="font-size: 13px; font-weight: 700; letter-spacing: 0.05em; text-transform: uppercase; color: var(--color-text-tertiary); margin-top: 0; margin-bottom: 24px;">Tingkat Keterlambatan Kunjungan</h4>
             <ECharts config={chartOptionAging} height="260px" />
           </div>
          </div>
          
          <div style="margin-top: 24px; padding: 14px 18px; border-radius: 12px; background: linear-gradient(135deg, rgba(99,102,241,0.06), rgba(139,92,246,0.02)); border: 1px solid rgba(99,102,241,0.25); font-size: 0.9rem; line-height: 1.6; color: var(--color-text-secondary);">
            <strong style="color: var(--color-text-primary); display: flex; align-items: center; gap: 6px; margin-bottom: 6px; font-size: 0.95rem;">
              <span>🧠</span> Deteksi Churn Dinamis AI
            </strong>
            Kelompok "Telat" pada grafik di atas tidak dihitung menggunakan standar baku untuk semua orang, melainkan <strong>disesuaikan dengan rutinitas unik setiap pelanggan</strong>. Sistem AI memprediksi kapan member VIP akan pindah ke kompetitor (<i>churn</i>) dengan cara menghitung selisih keterlambatan antara kunjungan terakhir mereka dengan <i>rata-rata siklus kunjungan historis mereka sendiri</i>.
          </div>
        </div>

        <!-- 4. Kesimpulan & Data Pendukung (Digabung) -->
        <div>
          <div class="section-head tight" style="margin-bottom: 16px;">
            <div>
              <div class="section-eyebrow">📝 Eksekusi Taktis</div>
              <h3 class="section-title">Langkah Penyelamatan Member</h3>
              <p class="section-copy">Menyediakan daftar member prioritas yang perlu segera dihubungi, didukung dengan analisis otomatis dari sistem.</p>
            </div>
          </div>
          <div class="decision-box {actionColor}">
            <div class="decision-content">
              <div class="decision-title">
                <span style="display: flex; align-items: center; gap: 8px;">
                  <span style="font-size: 1.1em;">{iconAlert}</span>
                  {titleText}
                </span>
                <div class="ai-badge">✨ AI Generated</div>
              </div>
              <p class="decision-text">
                {#if churnRiskState === 'safe'}
                  Hanya sedikit member yang masuk zona churn. Pertahankan standar layanan prima agar mereka terus mereferensikan restoran kita. Berikut adalah daftar member yang mulai terlambat berkunjung:
                {:else if churnRiskState === 'warn'}
                  Cek data {goldChurn} Member VIP yang termasuk dalam {totalChurn} member berisiko ini. Segera hubungi mereka via WhatsApp dan berikan penawaran personal agar mereka kembali minggu ini. Berikut adalah daftar prioritasnya:
                {:else}
                  <strong>{goldChurn} Member Gold</strong> berisiko pindah ke kompetitor. Segera berikan penawaran diskon 30% hari ini juga sebelum kehilangan mereka secara permanen. Eksekusi daftar prioritas berikut:
                {/if}
              </p>
              
              <div class="table-container">
                <DataTable data={retention_queue} rows={10} search={true}>
                  <Column id="kode_member" title="Kode Member" />
                  <Column id="tier" title="Status Tier" />
                  <Column id="total_spend" title="Total Transaksi (Rp)" align="right" fmt="#,##0" />
                  <Column id="avg_visit_days" title="Rata-rata Kunjungan" align="center" />
                  <Column id="delay_days" title="Keterlambatan" align="center" />
                  <Column id="kontak" title="No. WhatsApp" />
                  <Column id="status_followup" title="Status Follow-Up" />
                  <Column id="terakhir_kontak" title="Tgl Kontak" align="center" />
                </DataTable>
              </div>

              <div class="decision-footer">
                <em>*Disclaimer: Panduan dan urutan prioritas ini dihitung otomatis berdasarkan tier dan jumlah hari keterlambatan. Pastikan tim Front-of-House (FOH) memberikan layanan personal saat mereka kembali.</em>
              </div>
            </div>
          </div>
        </div>

      </div>
    </div>

  </details>
</div>

<!-- Outer Diagnostics Container 2 -->
<div id="milestone" class="diagnostics-stack" style="margin-top: 32px; margin-bottom: 24px;">
  <div class="diagnostics-header">
    <div class="diagnostics-eyebrow">💎 Eksekusi Apresiasi</div>
    <h2 class="diagnostics-title">Apresiasi Pencapaian Milestone</h2>
    <p class="diagnostics-copy">Daftar member yang telah mencapai target kunjungan berkala (Milestone). Berikan apresiasi terukur untuk mempertahankan tren kunjungan aktif mereka.</p>
  </div>

  <details class="acc-strategic">
    <summary>🎁 Selami Daftar Penerima Reward</summary>

    <div class="acc-body">
      <div style="display: flex; flex-direction: column; gap: 24px;">

        <!-- 1. Insight / Paparan -->
        <div>
          <div class="section-head tight" style="margin-bottom: 12px;">
            <div>
              <div class="section-eyebrow">💎 Ringkasan Milestone</div>
              <h3 class="section-title">Pencapaian Loyalitas Berkala</h3>
              <p class="section-copy">Member-member di bawah ini baru saja mencapai target kunjungan loyalitas (ke-10, 25, atau 50). Momentum psikologis ini sangat krusial; pelanggan yang merasa diapresiasi pada titik ini memiliki probabilitas tinggi untuk merekomendasikan restoran secara sukarela.</p>
            </div>
          </div>
        </div>

        <!-- 2. Data Pendukung -->
        <div>
          <div class="table-container">
            {#if milestone_queue.length > 0}
              <DataTable data={milestone_queue} rows=10 search={true}>
                <Column id="kode_member" title="Kode Member" />
                <Column id="tier" title="Status Tier" />
                <Column id="current_visits" title="Kunjungan Saat Ini" align="center" />
                <Column id="target_milestone" title="Target Kunjungan" align="center" />
                <Column id="reward_recommendation" title="Hak Apresiasi" />
                <Column id="total_spend" title="Total Belanja (LTV)" align="right" fmt="#,##0" />
              </DataTable>
            {:else}
              <div style="padding: 24px; text-align: center; border: 1px dashed var(--color-border-tertiary); border-radius: 12px; color: var(--color-text-tertiary);">
                <strong>Belum ada target Milestone</strong><br/>
                Saat ini belum ada member yang potensial mencapai target kunjungan ke-10, 25, atau 50 hari ini.
              </div>
            {/if}
          </div>
        </div>

        <!-- 3. Rekomendasi / Kesimpulan -->
        <div>
          <div class="section-head tight" style="margin-bottom: 16px;">
            <div>
              <div class="section-eyebrow">💎 Program Loyalitas</div>
              <h3 class="section-title">Opsi Eksekusi Kejutan Apresiasi</h3>
              <p class="section-copy">Pilih salah satu atau kombinasikan opsi di bawah ini sebagai bentuk apresiasi kejutan (<em>Surprise & Delight</em>). Sesuaikan besaran hadiah dengan tingginya pencapaian <em>milestone</em> kunjungan member.</p>
            </div>
          </div>
          <div class="guide-grid" style="grid-template-columns: repeat(2, minmax(0, 1fr));">
            <div class="guide-card blue">
              <div class="guide-card-icon">👋</div>
              <div class="guide-card-content">
                <div class="guide-card-label">Opsi Eksekusi 1</div>
                <h4 class="guide-card-title">Penyambutan Khusus</h4>
                <p class="guide-card-desc">Sambut member dengan sapaan apresiasi langsung dari manajer atau kasir untuk membangun koneksi personal (<em>Surprise & Delight</em>).</p>
              </div>
            </div>
            <div class="guide-card orange">
              <div class="guide-card-icon">🎁</div>
              <div class="guide-card-content">
                <div class="guide-card-label">Opsi Eksekusi 2</div>
                <h4 class="guide-card-title">Suvenir Fisik</h4>
                <p class="guide-card-desc">Berikan cenderamata kecil (<em>merchandise</em> atau hadiah fisik) yang bisa mereka bawa pulang sebagai simbol apresiasi <em>brand</em>.</p>
              </div>
            </div>
            <div class="guide-card purple">
              <div class="guide-card-icon">🍰</div>
              <div class="guide-card-content">
                <div class="guide-card-label">Opsi Eksekusi 3</div>
                <h4 class="guide-card-title">Menu Tambahan Gratis</h4>
                <p class="guide-card-desc">Berikan traktiran spontan berupa <em>free dessert</em>, <em>appetizer</em>, atau minuman spesial langsung ke meja mereka.</p>
              </div>
            </div>
            <div class="guide-card teal">
              <div class="guide-card-icon">🎟️</div>
              <div class="guide-card-content">
                <div class="guide-card-label">Opsi Eksekusi 4</div>
                <h4 class="guide-card-title">Promo / Voucher Eksklusif</h4>
                <p class="guide-card-desc">Beri mereka voucher potongan harga khusus dengan batas waktu untuk memancing kunjungan <em>milestone</em> berikutnya lebih cepat.</p>
              </div>
            </div>
          </div>
        </div>

      </div>
    </div>

  </details>
</div>

{:else}
  <GlobalLoading />
{/if}

<style>
.member-page { display: flex; flex-direction: column; gap: 24px; margin-top: 10px; }
.section-card { padding: 16px; border-radius: 16px; border: 1px solid var(--color-border-tertiary); background: var(--color-background-secondary); }
.strategic-title { margin: 0 0 10px; font-size: 1.5rem; line-height: 1.1; letter-spacing: -0.035em; color: var(--color-text-primary); }
.section-eyebrow { font-size: 10px; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 6px; display: flex; align-items: center; gap: 6px; }
.section-head.tight { margin-bottom: 12px; }

/* ── AI Decision Box CSS ── */
.decision-box {
  display: flex;
  gap: 24px;
  padding: 24px 32px;
  border-radius: 16px;
  border: 1px solid var(--color-border-tertiary);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 4px 12px rgba(0,0,0,0.02);
  background: var(--color-background-secondary);
}
.decision-box.red {
  border-color: rgba(239, 68, 68, 0.2);
  background: rgba(239, 68, 68, 0.03);
}
.decision-box.red:hover {
  box-shadow: 0 8px 24px rgba(239, 68, 68, 0.06);
  border-color: rgba(239, 68, 68, 0.4);
  transform: translateY(-2px);
}
.decision-box.green {
  border-color: rgba(16, 185, 129, 0.2);
  background: rgba(16, 185, 129, 0.03);
}
.decision-box.green:hover {
  box-shadow: 0 8px 24px rgba(16, 185, 129, 0.06);
  border-color: rgba(16, 185, 129, 0.4);
  transform: translateY(-2px);
}
.decision-box.amber {
  border-color: rgba(245, 158, 11, 0.2);
  background: rgba(245, 158, 11, 0.03);
}
.decision-box.amber:hover {
  box-shadow: 0 8px 24px rgba(245, 158, 11, 0.06);
  border-color: rgba(245, 158, 11, 0.4);
  transform: translateY(-2px);
}
.decision-box.blue {
  border-color: rgba(59, 130, 246, 0.2);
  background: rgba(59, 130, 246, 0.03);
}
.decision-box.blue:hover {
  box-shadow: 0 8px 24px rgba(59, 130, 246, 0.06);
  border-color: rgba(59, 130, 246, 0.4);
  transform: translateY(-2px);
}



.decision-content {
  flex: 1;
  min-width: 0;
}
.decision-title {
  font-size: 1.25rem;
  font-weight: 800;
  margin-bottom: 12px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.decision-text {
  font-size: 1.05rem;
  line-height: 1.6;
  font-weight: 500;
  margin: 0;
}
.decision-footer {
  margin-top: 16px;
  font-size: 0.8rem;
  opacity: 0.8;
  border-top: 1px dashed currentColor;
  padding-top: 12px;
}
.ai-badge {
  background: rgba(0,0,0,0.08);
  padding: 6px 12px;
  border-radius: 8px;
  font-size: 0.65rem;
  text-transform: uppercase;
  font-weight: 800;
  letter-spacing: 0.1em;
  display: flex;
  align-items: center;
  gap: 4px;
}
.table-container {
  margin-top: 24px;
  background: var(--color-background-primary);
  border-radius: 12px;
  overflow-x: auto;
  border: 1px solid var(--color-border-tertiary);
  box-shadow: 0 4px 15px rgba(0,0,0,0.03);
}

/* ── Hero CSS ── */
.hero {
  display: flex;
  flex-direction: column;
  gap: 16px;
  padding: 24px;
  border-radius: 22px;
  border: 1px solid rgba(37, 99, 235, 0.12);
  background:
    radial-gradient(circle at top right, rgba(69, 161, 191, 0.18), transparent 35%),
    radial-gradient(circle at bottom left, rgba(99,102,241,0.08), transparent 40%),
    linear-gradient(135deg, rgba(37, 99, 235, 0.06), rgba(194, 65, 12, 0.04)),
    var(--color-background-secondary);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.02), 0 1px 3px rgba(0, 0, 0, 0.01);
}
.hero-grid {
  display: grid;
  grid-template-columns: minmax(0, 1.7fr) minmax(280px, 1fr);
  gap: 18px;
}
.hero-eyebrow {
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.13em;
  text-transform: uppercase;
  color: var(--color-text-tertiary);
  display: flex;
  align-items: center;
  gap: 6px;
}
.hero-main-card {
  padding: 24px;
  border-radius: 16px;
  border: 1.5px solid transparent;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03), 0 1px 3px rgba(0, 0, 0, 0.02);
}
.hero-main-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.05), 0 2px 5px rgba(0, 0, 0, 0.03);
}
.hero-main-card.status-sehat {
  background: rgba(22, 163, 74, 0.08);
  border-color: rgba(22, 163, 74, 0.22);
}
.hero-main-card.status-waspada {
  background: rgba(245, 158, 11, 0.09);
  border-color: rgba(245, 158, 11, 0.24);
}
.hero-main-card.status-kritis {
  background: rgba(220, 38, 38, 0.08);
  border-color: rgba(239, 68, 68, 0.22);
}

.hero-stat-number {
  font-size: 3.8rem;
  font-weight: 900;
  letter-spacing: -0.04em;
  line-height: 1;
  margin-top: 8px;
  margin-bottom: 2px;
}

.hero-main-card.status-sehat .hero-stat-number { color: #15803d; }
.hero-main-card.status-waspada .hero-stat-number { color: #b45309; }
.hero-main-card.status-kritis .hero-stat-number { color: #b91c1c; }

.hero-stat-label {
  font-size: 0.8rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  font-weight: 700;
  color: var(--color-text-tertiary);
  margin-bottom: 12px;
}
.hero-subtitle {
  font-size: 1.15rem;
  font-weight: 700;
  letter-spacing: -0.02em;
  color: var(--color-text-primary);
  margin-bottom: 0;
}
.hero-side {
  display: flex;
  flex-direction: column;
  gap: 10px;
}
.hero-side-card { 
  padding: 14px 15px; 
  border-radius: 14px; 
  border: 1px solid var(--color-border-tertiary); 
  background: rgba(255,255,255,0.72); 
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
}
.hero-side-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.04), 0 2px 4px rgba(0, 0, 0, 0.02);
  background: rgba(255, 255, 255, 0.9);
}
.hero-side-label { font-size: 10px; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 4px; }
.hero-side-value { font-size: 0.98rem; font-weight: 800; color: var(--color-text-primary); letter-spacing: -0.02em; }
.hero-side-note  { margin-top: 3px; font-size: 0.8rem; line-height: 1.55; color: var(--color-text-secondary); }

/* ── Menu Health CSS ── */
.menu-health { padding: 17px 18px; border-radius: 16px; border: 1px solid var(--color-border-tertiary); background: var(--color-background-secondary); box-shadow: 0 1px 3px rgba(0,0,0,0.035); }
.menu-health-head { display: flex; align-items: center; justify-content: space-between; gap: 10px; flex-wrap: wrap; padding-bottom: 12px; margin-bottom: 12px; border-bottom: 1px solid var(--color-border-tertiary); }
.menu-health-label { font-size: 10px; font-weight: 850; letter-spacing: 0.11em; text-transform: uppercase; color: var(--color-text-tertiary); }
.menu-health-badges { display: flex; align-items: center; gap: 8px; flex-wrap: wrap; }
.menu-health-badge { display: inline-flex; align-items: center; gap: 5px; padding: 4px 10px; border-radius: 999px; font-size: 11px; font-weight: 800; border: 1px solid; transition: all 0.2s ease; cursor: pointer; }
.menu-health-badge:hover { transform: translateY(-2px); box-shadow: 0 4px 8px rgba(0, 0, 0, 0.08); }
.menu-health-badge.safe { background: rgba(22,163,74,0.10); color: #166534; border-color: rgba(22,163,74,0.22); }
.menu-health-badge.warn { background: rgba(234,179,8,0.10); color: #854d0e; border-color: rgba(234,179,8,0.26); }
.menu-health-badge.critical { background: rgba(220,38,38,0.08); color: #991b1b; border-color: rgba(220,38,38,0.20); }
.menu-health-list { display: flex; flex-direction: column; gap: 6px; }
.menu-health-row { display: flex; align-items: flex-start; gap: 10px; padding: 9px 10px; border-radius: 10px; font-size: 0.84rem; line-height: 1.55; border: 1px solid transparent; transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1); cursor: pointer; }
.menu-health-row:hover { transform: translateX(4px) translateY(-1px); box-shadow: 0 4px 12px rgba(0,0,0,0.06); }
.menu-health-row.safe { background: rgba(22,163,74,0.045); border-color: rgba(22,163,74,0.12); }
.menu-health-row.warn { background: rgba(234,179,8,0.045); border-color: rgba(234,179,8,0.16); }
.menu-health-row.critical { background: rgba(220,38,38,0.04); border-color: rgba(220,38,38,0.13); }
.menu-health-icon { width: 18px; flex: 0 0 18px; margin-top: 1px; font-size: 14px; line-height: 1.2; text-align: center; }
.menu-health-title { font-weight: 850; color: var(--color-text-primary); }
.menu-health-copy { color: var(--color-text-secondary); }
.menu-health-value { font-weight: 850; color: var(--color-text-primary); }

/* ── KPI Grid ── */
.trend-indicator { font-size: 0.82rem; font-weight: 700; display: inline-flex; align-items: center; gap: 3px; }
.trend-indicator.up { color: #16a34a; }
.trend-indicator.down { color: #dc2626; }
.trend-indicator.neutral { color: var(--color-text-tertiary); }

.kpi-grid { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 12px; }
.kpi-card { padding: 18px 16px; border-radius: 18px; border: 1.5px solid var(--color-border-tertiary); background: var(--color-background-secondary); box-shadow: 0 4px 10px rgba(0, 0, 0, 0.02), 0 1px 3px rgba(0, 0, 0, 0.01); transition: all 0.22s ease; }
.kpi-card:hover { transform: translateY(-2px); box-shadow: 0 8px 16px rgba(0, 0, 0, 0.04), 0 2px 4px rgba(0, 0, 0, 0.02); }
.kpi-label { font-size: 10px; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 8px; display: flex; align-items: center; gap: 5px; }
.kpi-value { font-size: 1.15rem; font-weight: 800; letter-spacing: -0.03em; color: var(--color-text-primary); }
.kpi-meta { margin-top: 6px; font-size: 0.82rem; line-height: 1; }
.kpi-prev { margin-top: 6px; font-size: 0.78rem; color: var(--color-text-secondary); line-height: 1.4; }
.kpi-card.revenue { border-color: rgba(37,99,235,0.18); background: linear-gradient(145deg, rgba(37,99,235,0.06), rgba(99,102,241,0.03)); }
.kpi-card.net { border-color: rgba(16,185,129,0.22); background: linear-gradient(145deg, rgba(16,185,129,0.07), rgba(22,163,74,0.03)); }
.kpi-card.margin { border-color: rgba(245,158,11,0.22); background: linear-gradient(145deg, rgba(245,158,11,0.07), rgba(251,191,36,0.03)); }
.kpi-card.expense { border-color: rgba(239,68,68,0.18); background: linear-gradient(145deg, rgba(239,68,68,0.06), rgba(220,38,38,0.02)); }



.diagnostics-stack { display: flex; flex-direction: column; gap: 16px; margin-top: 14px; }
.diagnostics-header { padding: 0 2px; margin-bottom: 2px; }
.diagnostics-eyebrow { font-size: 10px; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 6px; display: flex; align-items: center; gap: 6px; }
.diagnostics-title { font-size: 1.3rem; font-weight: 800; letter-spacing: -0.025em; color: var(--color-text-primary); margin: 0 0 4px; }
.diagnostics-copy { font-size: 0.9rem; line-height: 1.7; color: var(--color-text-secondary); max-width: 68ch; margin: 0; }

/* ── Signal grid ── */
.signal-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 14px;
}

.signal-card {
  padding: 18px;
  border-radius: 16px;
  border: 1px solid var(--color-border-tertiary);
  background: var(--color-background-secondary);
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
}

.signal-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.04), 0 2px 4px rgba(0, 0, 0, 0.02);
}

.signal-card.safe {
  border-color: rgba(22, 163, 74, 0.25);
  background: linear-gradient(135deg, rgba(22,163,74,0.08), rgba(16,185,129,0.03));
}

.signal-card.warn {
  border-color: rgba(245, 158, 11, 0.3);
  background: linear-gradient(135deg, rgba(245,158,11,0.09), rgba(251,191,36,0.03));
}

.signal-card.critical {
  border-color: rgba(239, 68, 68, 0.25);
  background: linear-gradient(135deg, rgba(239,68,68,0.09), rgba(220,38,38,0.03));
}

.signal-card.neutral {
  border-color: rgba(99, 102, 241, 0.2);
  background: linear-gradient(135deg, rgba(99,102,241,0.07), rgba(139,92,246,0.03));
}

.signal-label {
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.09em;
  text-transform: uppercase;
  color: var(--color-text-tertiary);
  margin-bottom: 6px;
  display: flex;
  align-items: center;
  gap: 5px;
}

.signal-title {
  font-size: 1rem;
  font-weight: 800;
  letter-spacing: -0.02em;
  color: var(--color-text-primary);
  margin-bottom: 6px;
}

.signal-copy {
  font-size: 0.9rem;
  line-height: 1.7;
  color: var(--color-text-secondary);
}

.loss-card {
  background: linear-gradient(135deg, rgba(220,38,38,0.08), rgba(239,68,68,0.02));
  border: 1px solid rgba(220,38,38,0.2);
  border-left: 4px solid #dc2626;
  border-radius: 12px;
  padding: 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 16px;
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 2px 4px rgba(0,0,0,0.02);
}
.loss-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 16px rgba(220,38,38,0.08), 0 2px 5px rgba(220,38,38,0.04);
  border-color: rgba(220,38,38,0.3);
}
.loss-card-content {
  flex: 1;
}
.loss-card-title {
  margin: 0; font-size: 14px; font-weight: 800; color: #b91c1c; text-transform: uppercase; letter-spacing: 0.05em;
}
.loss-card-desc {
  margin: 6px 0 0 0; font-size: 13px; color: var(--color-text-secondary); line-height: 1.5; max-width: 90%;
}
.loss-card-value {
  font-size: 24px; font-weight: 900; color: #991b1b; white-space: nowrap; flex-shrink: 0; letter-spacing: -0.02em;
}

/* ── Insight Cards ── */
.insight-grid {
  display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 16px;
}
.insight-card {
  padding: 20px; border-radius: 16px; border: 1px solid var(--color-border-tertiary);
  background: var(--color-background-secondary);
  display: flex; flex-direction: column; justify-content: space-between;
  transition: all 0.25s ease; position: relative; overflow: hidden;
}
.insight-card:hover {
  transform: translateY(-2px); box-shadow: 0 8px 24px rgba(0,0,0,0.06);
}
.insight-card.safe { background: linear-gradient(145deg, rgba(22,163,74,0.03), rgba(22,163,74,0.01)); border-color: rgba(22,163,74,0.2); }

.insight-card.warn { background: linear-gradient(145deg, rgba(245,158,11,0.04), rgba(245,158,11,0.01)); border-color: rgba(245,158,11,0.25); }

.insight-card.critical { background: linear-gradient(145deg, rgba(220,38,38,0.05), rgba(220,38,38,0.01)); border-color: rgba(220,38,38,0.25); }

.insight-card.neutral { background: linear-gradient(145deg, rgba(99,102,241,0.04), rgba(99,102,241,0.01)); border-color: rgba(99,102,241,0.2); }

.insight-header { display: flex; align-items: center; gap: 8px; margin-bottom: 16px; }
.insight-icon { font-size: 1.2rem; }
.insight-title { font-size: 0.85rem; font-weight: 800; letter-spacing: 0.08em; text-transform: uppercase; color: var(--color-text-tertiary); }

.insight-body { display: flex; align-items: baseline; gap: 12px; margin-bottom: 12px; }
.insight-number { font-size: 3rem; font-weight: 900; line-height: 1; letter-spacing: -0.04em; color: var(--color-text-primary); }
.insight-percent { font-size: 1.25rem; font-weight: 700; color: var(--color-text-secondary); margin-left: 2px; }

.insight-status-badge {
  padding: 4px 10px; border-radius: 999px; font-size: 0.75rem; font-weight: 800; letter-spacing: 0.05em;
}
.insight-status-badge.safe { background: rgba(22,163,74,0.15); color: #166534; }
.insight-status-badge.warn { background: rgba(245,158,11,0.15); color: #92400e; }
.insight-status-badge.critical { background: rgba(220,38,38,0.15); color: #991b1b; }
.insight-status-badge.neutral { background: rgba(99,102,241,0.15); color: #4338ca; }

.insight-footer { font-size: 0.9rem; color: var(--color-text-secondary); line-height: 1.5; }
.insight-footer strong { color: var(--color-text-primary); }

/* ── Standard Accordion ── */
details.acc-strategic {
  border-radius: 20px;
  border: 1.5px solid rgba(99,102,241,0.18);
  background: linear-gradient(135deg, rgba(99,102,241,0.04), rgba(139,92,246,0.03));
}
details.acc-strategic > summary {
  padding: 18px 20px; background: transparent;
  font-size: 1rem; font-weight: 800; color: var(--color-text-primary);
  cursor: pointer; list-style: none; display: flex; align-items: center;
}
details.acc-strategic > summary::-webkit-details-marker { display: none; }
details.acc-strategic > summary::after {
  content: '›'; margin-left: auto; font-size: 1.3rem; font-weight: 400;
  color: var(--color-text-tertiary); transition: transform 0.2s; display: inline-block;
}
details.acc-strategic[open] > summary::after { transform: rotate(90deg); }
details.acc-strategic[open] > summary { border-bottom: 1.5px solid rgba(99,102,241,0.14); }
details.acc-strategic .acc-body { padding: 20px; }
</style>

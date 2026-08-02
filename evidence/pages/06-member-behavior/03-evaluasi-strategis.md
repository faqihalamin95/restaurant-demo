---

title: Evaluasi Strategis
---


```sql member_kpi_period
SELECT * FROM restaurant.member_member_kpi_period
WHERE period = '30d'
```

```sql cohort_retention
WITH cohort_data AS (
  SELECT 
    DATE_TRUNC('month', join_date) AS cohort_month,
    DATE_TRUNC('month', order_date) AS order_month,
    COUNT(DISTINCT member_id) AS active_members
  FROM restaurant.member_purchase_behavior
  WHERE join_date IS NOT NULL
  GROUP BY 1, 2
),
cohort_sizes AS (
  SELECT cohort_month, active_members AS total_cohort_size
  FROM cohort_data
  WHERE cohort_month = order_month
)
SELECT 
  strftime(c.cohort_month, '%b %Y') AS "Cohort",
  'Bulan ke-' || datediff('month', c.cohort_month, c.order_month) AS "Bulan",
  datediff('month', c.cohort_month, c.order_month) AS sort_bulan,
  c.active_members,
  ROUND(LEAST(c.active_members * 1.0 / NULLIF(s.total_cohort_size, 0), 1.0), 3) AS "Retensi"
FROM cohort_data c
JOIN cohort_sizes s ON c.cohort_month = s.cohort_month
WHERE c.cohort_month >= (SELECT MAX(join_date) FROM restaurant.member_purchase_behavior) - INTERVAL '6 months'
AND datediff('month', c.cohort_month, c.order_month) > 0
ORDER BY c.cohort_month, sort_bulan
```

```sql freq_dist
WITH max_d AS (SELECT MAX(order_date) AS d FROM restaurant.member_purchase_behavior),
member_stats AS (
    SELECT 
        m.member_id,
        SUM(m.total_orders) AS orders_last_30d
    FROM restaurant.member_purchase_behavior m
    CROSS JOIN max_d
    WHERE m.order_date >= max_d.d - INTERVAL '30 days'
    GROUP BY 1
),
binned AS (
    SELECT 
        CASE 
            WHEN orders_last_30d = 1 THEN '1x'
            WHEN orders_last_30d = 2 THEN '2x'
            WHEN orders_last_30d BETWEEN 3 AND 5 THEN '3-5x'
            WHEN orders_last_30d BETWEEN 6 AND 10 THEN '6-10x'
            ELSE '> 10x'
        END AS visit_bucket,
        CASE 
            WHEN orders_last_30d = 1 THEN 1
            WHEN orders_last_30d = 2 THEN 2
            WHEN orders_last_30d BETWEEN 3 AND 5 THEN 3
            WHEN orders_last_30d BETWEEN 6 AND 10 THEN 4
            ELSE 5
        END AS sort_order,
        COUNT(member_id) AS member_count
    FROM member_stats
    GROUP BY 1, 2
)
SELECT visit_bucket, member_count
FROM binned
ORDER BY sort_order DESC
```



<script>
  // 1. Ambil Metrik Utama dari SQL
  let aovMember = 0;
  let aovNonMember = 0;
  let pctRevenue = 0;
  let pctTransaksi = 0;
  let frekuensi = 0;
  let akuisisi = 0;
  let activeMembers = 0;

  $: if (member_kpi_period && member_kpi_period.length > 0) {
     aovMember = member_kpi_period[0].avg_order_value || 0;
     aovNonMember = member_kpi_period[0].avg_order_value_non_member || 0;
     pctRevenue = member_kpi_period[0].pct_revenue_member || 0;
     pctTransaksi = member_kpi_period[0].pct_order_member || 0;
     activeMembers = member_kpi_period[0].active_members || 0;
     frekuensi = activeMembers > 0 
                  ? (member_kpi_period[0].total_member_orders / activeMembers) 
                  : 0;
     akuisisi = member_kpi_period[0].new_members || 0;
  }

  let boxColorClass = "blue";
  let executiveHeadline = "";
  let iconHeadline = "";
  let kalInti = "";
  let kalDampak = "";
  let kalAkuisisi = "";

  $: {
      // Benchmark Sederhana
      let isAovTurun = aovMember < aovNonMember;
      let isFrekuensiNaik = frekuensi >= 3.0; // Anggap 3x sebulan adalah batas habit sehat
      let acquisitionRate = activeMembers > 0 ? (akuisisi / activeMembers) * 100 : 0;
      let isAkuisisiMati = akuisisi === 0;

      // Evaluasi Trade-off & Kondisi Inti
      if (isAovTurun && isFrekuensiNaik) {
          boxColorClass = "blue";
          iconHeadline = "🔍";
          executiveHeadline = "Observasi: Pergeseran Habit Transaksi";
          let mcv = Math.round(aovMember * frekuensi);
          kalInti = `Member bertransaksi lebih kecil dibanding non-member (Rp${aovMember.toLocaleString('id-ID')} vs Rp${aovNonMember.toLocaleString('id-ID')}) namun kunjungan mereka jauh lebih rutin (${frekuensi.toFixed(1)}x/bulan). Secara agregat, restoran menerima Nilai Bulanan (MCV) sebesar <strong>Rp${mcv.toLocaleString('id-ID')}</strong> per member aktif. Member telah menjadikan restoran Anda sebagai rutinitas harian/mingguan yang kuat.`;
      } 
      else if (!isAovTurun && isFrekuensiNaik) {
          boxColorClass = isAkuisisiMati ? "amber" : "green";
          iconHeadline = isAkuisisiMati ? "⚠️" : "✅";
          executiveHeadline = isAkuisisiMati ? "Peringatan Isolasi: Akuisisi Stagnan" : "Kinerja Ekspansi Optimal";
          kalInti = `Kinerja ideal tercapai. Frekuensi kunjungan tinggi (${frekuensi.toFixed(1)}x/bulan) didukung oleh daya beli yang melampaui non-member (Rp${aovMember.toLocaleString('id-ID')} vs Rp${aovNonMember.toLocaleString('id-ID')}). Program loyalitas beroperasi pada tingkat retensi dan margin maksimal.`;
      } 
      else if (!isAovTurun && !isFrekuensiNaik) {
          boxColorClass = "amber";
          iconHeadline = "⚠️";
          executiveHeadline = "Peringatan: Potensi Penurunan Keterlibatan";
          kalInti = `Daya beli member terjaga dominan (Rp${aovMember.toLocaleString('id-ID')} vs Rp${aovNonMember.toLocaleString('id-ID')}), namun intensitas kunjungan melambat (${frekuensi.toFixed(1)}x/bulan). Member didominasi oleh transaksi yang sifatnya sesekali. Dibutuhkan stimulus untuk mendorong kedatangan yang lebih rutin.`;
      } 
      else {
          boxColorClass = "red";
          iconHeadline = "🚨";
          executiveHeadline = "Kritis: Penyusutan Margin & Retensi";
          kalInti = `Kunjungan member melemah (${frekuensi.toFixed(1)}x/bulan) disertai nilai transaksi yang tertinggal dari non-member (Rp${aovMember.toLocaleString('id-ID')} vs Rp${aovNonMember.toLocaleString('id-ID')}). Terdeteksi risiko kehilangan pelanggan (<em>churn</em>) dalam jumlah besar akibat kejenuhan program.`;
      }

      // Evaluasi Akuisisi Berbasis Persentase (Growth Rate)
      if (isAkuisisiMati) {
          kalAkuisisi = `<strong>Fokus Tindakan:</strong> Ekspansi terhenti (0 member baru bulan ini). Jika tidak ada member baru untuk menggantikan member lama yang mulai berhenti datang, pendapatan dari program membership terancam akan terus menurun secara perlahan.`;
      } else if (acquisitionRate <= 10) {
          kalAkuisisi = `Pertumbuhan lambat (bertambah ${akuisisi} member baru, setara rasio ${acquisitionRate.toFixed(1)}%). Optimalisasi kampanye akuisisi dibutuhkan untuk memastikan laju pendaftar baru lebih cepat daripada member lama yang mungkin berhenti datang.`;
      } else {
          kalAkuisisi = `Akuisisi sehat (bertambah ${akuisisi} member baru, laju ekspansi ${acquisitionRate.toFixed(1)}%). Pertumbuhan pendaftar yang kuat ini menjamin aliran revenue organik yang berkelanjutan.`;
      }

      // Evaluasi Dampak Berdasarkan Kontribusi Revenue
      if (pctRevenue > 30) {
          kalDampak = `Dengan kontribusi dominan sebesar ${pctRevenue.toFixed(1)}% terhadap total revenue bulanan, segmen member bertindak sebagai kontributor utama bagi stabilitas finansial restoran.`;
      } else if (pctRevenue >= 15) {
          kalDampak = `Menyumbang ${pctRevenue.toFixed(1)}% dari total revenue, segmen member bertindak sebagai salah satu pilar penyokong yang sehat bagi kelangsungan operasional.`;
      } else {
          kalDampak = `Meskipun kontribusinya baru mencapai ${pctRevenue.toFixed(1)}% terhadap revenue, segmen ini merupakan potensi pasar terselubung yang belum dimaksimalkan secara optimal.`;
      }
  }
</script>

<div class="member-page" style="margin-top: 24px;">
    
    <!-- HEADER BAB 1 -->
    <div class="diagnostics-header">
      <div class="diagnostics-eyebrow">🧠 DIAGNOSTIK UTAMA</div>
      <h2 class="diagnostics-title">Sintesis Kesehatan Makro</h2>
      <p class="diagnostics-copy">Evaluasi menyeluruh terhadap kesehatan struktural program loyalitas restoran bulan ini.</p>
    </div>

    {#if member_kpi_period && member_kpi_period.length > 0}
    <!-- Kesimpulan Eksekutif (Puncak Piramida) -->
    <div class="decision-box {boxColorClass}">
      <div class="decision-content">
        <div class="decision-title">
          <span style="display: flex; align-items: center; gap: 8px;">
            💡 Insight Operasional & Rekomendasi
          </span>
          <div class="ai-badge">✨ AI Generated</div>
        </div>
        
        <p class="decision-text" style="color: var(--color-text-primary); margin-bottom: 12px;">
          <strong>{iconHeadline} {executiveHeadline}</strong>
        </p>
        
        <p class="decision-text" style="color: var(--color-text-primary); margin-bottom: 16px;">
          {@html kalInti}
        </p>
        
        <p class="decision-text" style="color: var(--color-text-primary); margin-top: 20px; margin-bottom: 16px;">
          {@html kalDampak}
        </p>

        <p class="decision-text" style="color: var(--color-text-primary); margin-top: 20px; margin-bottom: 20px;">
          {@html kalAkuisisi}
        </p>
        
        <div class="metrics-row" style="margin-top: 24px;">
            <div class="metric-pill">💰 AOV: Rp {aovMember.toLocaleString('id-ID')}</div>
            <div class="metric-pill">💳 Rev: {pctRevenue.toFixed(1)}%</div>
            <div class="metric-pill">🌱 Akuisisi: {akuisisi}</div>
            <div class="metric-pill">📦 Trx: {pctTransaksi.toFixed(1)}%</div>
            <div class="metric-pill">🔁 Freq: {frekuensi.toFixed(1)}x</div>
        </div>

        <div class="decision-footer" style="margin-top: 24px;">
          <em>*Disclaimer: Panduan ini dikalkulasi otomatis berdasarkan kuantifikasi margin dan frekuensi. Gunakan sebagai alat bantu keputusan, dipadukan dengan pemahaman kontekstual Anda terhadap dinamika eksternal yang belum tertangkap data.</em>
        </div>
      </div>
    </div>

    <!-- HEADER BAB 2 & TRANSISI -->
    <div style="margin-top: 56px; border-top: 2px dotted rgba(128, 128, 128, 0.35); padding-top: 40px;">
      <div class="diagnostics-header" style="margin-bottom: 24px;">
        <div class="diagnostics-eyebrow">🔬 ANALISIS PENDUKUNG (DEEP-DIVE)</div>
        <h2 class="diagnostics-title">Siklus Retensi & Kebosanan Pelanggan</h2>
        <p class="diagnostics-copy">Membedah daya tahan loyalitas, mendeteksi titik jenuh pelanggan, serta memetakan pola frekuensi riil kunjungan mereka.</p>
      </div>
      
      <!-- Tempat untuk Analisis Pendukung dengan Tabs -->
      <Tabs id="deep-dive" fullWidth=true>
        <Tab label="📉 Heatmap (Cohort Retention)">
          <div style="margin-top: 24px;">
            <p style="color: var(--color-text-secondary); margin-bottom: 24px;">Menganalisis probabilitas pelanggan lama untuk kembali berbelanja di bulan-bulan berikutnya setelah bulan pendaftaran mereka.</p>
            <div style="padding: 24px; background: var(--color-background-primary); border-radius: 12px; border: 1px solid var(--color-border-tertiary); margin-bottom: 16px; box-shadow: 0 4px 12px rgba(0,0,0,0.02);">
                <Heatmap 
                  data={cohort_retention} 
                  x=Bulan
                  y=Cohort
                  value=Retensi
                  valueFmt="pct"
                  colorPalette={['#f8fafc', '#bae6fd', '#3b82f6', '#1d4ed8']}
                  title="Tingkat Retensi Member per Kohort (%)"
                  echartsOptions={{
                    xAxis: {
                      axisLabel: {
                        formatter: function(val) { return val.replace('Bulan ke-', ''); }
                      }
                    }
                  }}
                />
            </div>
            <details class="guide-acc" style="margin-top: 16px; margin-bottom: 24px;">
              <summary>🎯 Potensi Aksi (How to Use This)</summary>
              <div class="guide-body">
                <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
                  Tiga langkah kerangka berpikir untuk mengekstrak nilai maksimal dari grafik ini, mulai dari memahami tujuan, mendeteksi sinyal bahaya, hingga mengambil keputusan.
                </p>
                <div class="guide-grid" style="grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 12px;">
                  <div class="guide-card blue">
                    <div class="guide-card-icon">💡</div>
                    <div class="guide-card-content">
                      <div class="guide-card-label">Misi Utama</div>
                      <h4 class="guide-card-title">Temukan Bulan Kebosanan</h4>
                      <p class="guide-card-desc">Di bulan ke-berapa mayoritas member baru biasanya berhenti datang? Inilah titik kritis yang menentukan apakah program loyalitas Anda berhasil membentuk habit.</p>
                    </div>
                  </div>
                  <div class="guide-card orange">
                    <div class="guide-card-icon">🔎</div>
                    <div class="guide-card-content">
                      <div class="guide-card-label">Deteksi Dini</div>
                      <h4 class="guide-card-title">Warna Memudar = Zona Kritis</h4>
                      <p class="guide-card-desc">Jika warna drastis memudar di "Bulan ke-2" atau "Bulan ke-3", itu adalah sinyal bahwa mayoritas member baru "kabur" sebelum habit terbentuk.</p>
                    </div>
                  </div>
                  <div class="guide-card teal">
                    <div class="guide-card-icon">🚀</div>
                    <div class="guide-card-content">
                      <div class="guide-card-label">Aksi Taktis</div>
                      <h4 class="guide-card-title">Intervensi Tepat Sasaran</h4>
                      <p class="guide-card-desc">Tembakkan diskon progresif <em>hanya</em> kepada member yang sedang berada di bulan kritis tersebut, bukan promo acak yang mengikis margin tanpa tujuan.</p>
                    </div>
                  </div>
                </div>
              </div>
            </details>
          </div>
        </Tab>
        <Tab label="📊 Distribusi Kunjungan">
          <div style="margin-top: 24px;">
            <p style="color: var(--color-text-secondary); margin-bottom: 24px;">Membedah pemerataan rutinitas kunjungan. Menjawab: Apakah rata-rata kunjungan didorong oleh semua member, atau hanya segelintir pelanggan fanatik?</p>
            <div style="padding: 24px; background: var(--color-background-primary); border-radius: 12px; border: 1px solid var(--color-border-tertiary); margin-bottom: 16px; box-shadow: 0 4px 12px rgba(0,0,0,0.02);">
                <BarChart 
                  data={freq_dist} 
                  x=visit_bucket 
                  y=member_count 
                  title="Distribusi Kunjungan Member (30 Hari Terakhir)"
                  fillColor="#6366f1"
                  sort=false
                />
            </div>
            <details class="guide-acc" style="margin-top: 16px; margin-bottom: 24px;">
              <summary>🎯 Potensi Aksi (How to Use This)</summary>
              <div class="guide-body">
                <p style="margin-top: 4px; margin-bottom: 16px; font-weight: 500; color: var(--color-text-secondary);">
                  Kerangka berpikir untuk membaca grafik ini secara kontekstual dan disesuaikan dengan konsep serta tujuan bisnis Anda.
                </p>
                <div class="guide-grid" style="grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 12px;">
                  <div class="guide-card blue">
                    <div class="guide-card-icon">💡</div>
                    <div class="guide-card-content">
                      <div class="guide-card-label">Misi Utama</div>
                      <h4 class="guide-card-title">Bedah Profil Keterlibatan</h4>
                      <p class="guide-card-desc">Apakah omzet bisnis ini digerakkan oleh <strong>frekuensi tinggi</strong> (habit rutin) atau oleh <strong>transaksi bernilai besar</strong> yang sesekali? Jawabannya menentukan strategi yang tepat.</p>
                    </div>
                  </div>
                  <div class="guide-card orange">
                    <div class="guide-card-icon">🔎</div>
                    <div class="guide-card-content">
                      <div class="guide-card-label">Deteksi Dini</div>
                      <h4 class="guide-card-title">Bandingkan dengan AOV</h4>
                      <p class="guide-card-desc">Jika menumpuk di "1x–2x", segera bandingkan AOV member vs non-member. Jika sama saja → lampu merah: program loyalitas Anda belum memberikan nilai tambah nyata.</p>
                    </div>
                  </div>
                  <div class="guide-card teal">
                    <div class="guide-card-icon">🚀</div>
                    <div class="guide-card-content">
                      <div class="guide-card-label">Aksi Taktis</div>
                      <h4 class="guide-card-title">Sesuaikan Konsep Bisnis</h4>
                      <p class="guide-card-desc"><em>Kafe/Cepat saji:</em> wajib kejar frekuensi. <em>Fine Dining:</em> wajar di 1x–2x asal AOV jauh lebih tinggi. Tujuan koleksi data? Abaikan metrik frekuensi ini.</p>
                    </div>
                  </div>
                </div>
              </div>
            </details>
          </div>
        </Tab>
      </Tabs>

      <!-- PANDUAN EKSEKUSI & BATASAN ETIKA (DUA KOLOM) -->
      <div style="margin-top: 56px; border-top: 2px dotted rgba(128, 128, 128, 0.35); padding-top: 40px;">
        <div class="diagnostics-header" style="margin-bottom: 24px;">
          <div class="diagnostics-eyebrow">🛡️ PANDUAN OPERASIONAL</div>
          <h2 class="diagnostics-title">Tata Cara Eksekusi & Batasan Etika</h2>
          <p class="diagnostics-copy">Panduan taktis mengeksekusi insight data tanpa mengorbankan kenyamanan pelanggan dan reputasi merek jangka panjang.</p>
        </div>
      <div style="margin-top: 16px; display: grid; grid-template-columns: repeat(auto-fit, minmax(400px, 1fr)); gap: 24px;">
        
        <!-- Kolom Kiri: Panduan Taktis -->
        <div style="display: flex; flex-direction: column;">
          <h4 style="margin: 0 0 16px 0; font-weight: 800; display: flex; align-items: center; gap: 8px; color: var(--color-text-primary);">
            <span>📈</span> Panduan Optimasi Angka
          </h4>

          <div class="opt-action-stack">
            <div class="opt-action-card blue">
              <div class="opt-action-badge">💰 TARGET AOV</div>
              <div class="opt-action-title">Gunakan Bundling Ringan</div>
              <div class="opt-action-desc">Terapkan <em>cross-selling</em> (misal: paket hidangan + minuman spesial) alih-alih memaksa pelanggan membeli item yang tidak mereka inginkan.</div>
            </div>
            <div class="opt-action-card orange">
              <div class="opt-action-badge">🔁 TARGET FREKUENSI</div>
              <div class="opt-action-title">Bangun Rutinitas Natural</div>
              <div class="opt-action-desc">Buat program kunjungan yang mengalir (seperti <em>Coffee Morning</em> atau menu akhir pekan) agar member punya alasan datang kembali.</div>
            </div>
            <div class="opt-action-card teal">
              <div class="opt-action-badge">🤝 AKUISISI & ETOS</div>
              <div class="opt-action-title">Tawarkan di Momen Puncak</div>
              <div class="opt-action-desc">Pastikan pelayan menawarkan membership saat pelanggan puas (selesai makan), bukan dengan memaksa mereka di depan kasir.</div>
            </div>
          </div>


        </div>

        <!-- Kolom Kanan: Guardrail Etika -->
        <div style="display: flex; flex-direction: column;">
          <h4 style="margin: 0 0 16px 0; font-weight: 800; display: flex; align-items: center; gap: 8px; color: var(--color-text-primary);">
            <span>🛡️</span> Perspektif Etika Loyalitas
          </h4>
          <div class="ethic-preview-1">
            <div class="ethic-content-1">
              <p>Mengejar kenaikan transaksi adalah hal yang mutlak demi profitabilitas bisnis. Namun, pahami bahwa tidak ada pertumbuhan yang tak terhingga (<em>infinite growth</em>) pada basis pelanggan yang sama.</p>
              <p class="ethic-quote-1">"Waspadai <strong>titik jenuh (fatigue)</strong> pelanggan. Mengeksploitasi basis member melalui taktik upselling paksa atau rentetan promosi diskon tiada henti justru memicu brand resentment. Loyalitas sejati dibangun di atas ikatan emosional dan kualitas konsisten, bukan sekadar memandang pelanggan sebagai sapi perah metrik."</p>
            </div>
          </div>
        </div>

      </div>

    </div>
    </div>
    {:else}
      <GlobalLoading />
    {/if}
</div>

<style>
.member-page { display: flex; flex-direction: column; gap: 24px; margin-top: 10px; }

/* Decision Box Styles moved to app.css */

.diagnostics-stack { display: flex; flex-direction: column; gap: 16px; margin-top: 14px; }
.diagnostics-header { padding: 0 2px; margin-bottom: 24px; }
.diagnostics-eyebrow { font-size: 10px; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; color: var(--color-text-tertiary); margin-bottom: 6px; display: flex; align-items: center; gap: 6px; }
.diagnostics-title { font-size: 1.3rem; font-weight: 800; letter-spacing: -0.025em; color: var(--color-text-primary); margin: 0 0 4px; }
.diagnostics-copy { font-size: 0.9rem; line-height: 1.7; color: var(--color-text-secondary); max-width: 68ch; margin: 0; }

/* Override Evidence Tabs agar merentang penuh (50-50) jika isinya 2 */
:global(#deep-dive > div:first-child) { display: flex; width: 100%; border-bottom: 2px solid var(--color-border-tertiary); gap: 8px; margin-bottom: 24px; }
:global(#deep-dive > div:first-child > a) { flex: 1; text-align: center; padding: 12px 16px; border-radius: 8px 8px 0 0; font-weight: 700; color: var(--color-text-secondary); transition: all 0.2s ease; border-bottom: 2px solid transparent; margin-bottom: -2px; }
:global(#deep-dive > div:first-child > a:hover) { background: var(--color-background-secondary); color: var(--color-text-primary); }
:global(#deep-dive > div:first-child > a[aria-current="true"]), 
:global(#deep-dive > div:first-child > a[data-active="true"]) { color: #2563eb; border-bottom-color: #2563eb; background: rgba(37, 99, 235, 0.04); }

/* ── PREVIEW OPSI 1: Action Queue ── */
.opt-action-stack { display: flex; flex-direction: column; gap: 12px; margin-left: 28px; }
.opt-action-card { padding: 16px 18px; border-radius: 12px; border-left: 4px solid; border-top: 1px solid; border-right: 1px solid; border-bottom: 1px solid; display: flex; flex-direction: column; gap: 4px; transition: transform 0.2s; }
.opt-action-card:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
.opt-action-card.blue { border-left-color: #3b82f6; border-color: rgba(59,130,246,0.2); background: rgba(59,130,246,0.04); }
.opt-action-card.orange { border-left-color: #f59e0b; border-color: rgba(245,158,11,0.2); background: rgba(245,158,11,0.04); }
.opt-action-card.teal { border-left-color: #10b981; border-color: rgba(16,185,129,0.2); background: rgba(16,185,129,0.04); }
.opt-action-badge { font-size: 10px; font-weight: 800; letter-spacing: 0.1em; text-transform: uppercase; padding: 2px 8px; border-radius: 999px; display: inline-block; width: max-content; margin-bottom: 4px; }
.opt-action-card.blue .opt-action-badge { background: rgba(59,130,246,0.15); color: #1d4ed8; }
.opt-action-card.orange .opt-action-badge { background: rgba(245,158,11,0.15); color: #b45309; }
.opt-action-card.teal .opt-action-badge { background: rgba(16,185,129,0.15); color: #047857; }
.opt-action-title { font-size: 0.95rem; font-weight: 800; color: var(--color-text-primary); }
.opt-action-desc { font-size: 0.88rem; line-height: 1.6; color: var(--color-text-secondary); margin-top: 2px; }

/* ── ETHIC PREVIEW 1: The Golden Rule ── */
.ethic-preview-1 { background: rgba(220, 38, 38, 0.04); border-radius: 12px; padding: 24px; border: 1px solid rgba(220, 38, 38, 0.15); position: relative; overflow: hidden; margin-left: 28px; }
.ethic-preview-1::before { content: '"'; position: absolute; top: -20px; left: -10px; font-size: 140px; font-family: serif; font-weight: 900; color: rgba(220, 38, 38, 0.08); line-height: 1; pointer-events: none; }
.ethic-content-1 { position: relative; z-index: 1; margin: 0; color: var(--color-text-secondary); line-height: 1.6; font-size: 0.95rem; display: flex; flex-direction: column; gap: 12px; }
.ethic-content-1 p { margin: 0; }
.ethic-quote-1 { font-style: italic; font-weight: 600; border-left: 3px solid rgba(220, 38, 38, 0.4); padding-left: 12px; color: var(--color-text-primary); }

</style>

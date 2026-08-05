---
title: "Wekadata: Ringkasan Performa Bisnis"
sidebar_link: true
---

<script>
  const depts = [
    { id: 'Cabang', name: 'Performa Cabang', icon: '🏪', link: '/02-branch-performance', desc: 'Audit omzet, profitabilitas, dan perbandingan margin harian tiap outlet.' },
    { id: 'Inventori', name: 'Inventori Stok', icon: '📦', link: '/03-inventori-stok', desc: 'Pantau ketersediaan bahan baku, reorder level, dan pergerakan stok.' },
    { id: 'Jam Sibuk', name: 'Jam Sibuk (Peak Hours)', icon: '⏰', link: '/04-peak-hours', desc: 'Pemetaan jam operasional, optimalisasi staf, dan analisis kapasitas restoran.' },
    { id: 'Menu', name: 'Performa Menu', icon: '🍔', link: '/05-menu-performance', desc: 'Analisis menu terlaris, deteksi dead stock, dan evaluasi matriks BCG.' },
    { id: 'Member', name: 'Insight Member', icon: '💎', link: '/06-member-behavior', desc: 'Analisis pola transaksi pelanggan, retensi, dan performa tier loyalty.' },
    { id: 'Pegawai', name: 'Performa Pegawai', icon: '👥', link: '/07-employee-performance', desc: 'Evaluasi produktivitas, absensi, jam lembur, dan efisiensi tim restoran.' }
  ];
  
  const getDeptStatus = (healthData, deptId) => {
    if (!healthData) return 'sehat';
    const items = healthData.filter(r => r.section === deptId);
    if (items.some(r => r.status === 'kritis')) return 'kritis';
    if (items.some(r => r.status === 'perhatian')) return 'waspada';
    return 'sehat';
  };

  const getSyncedDesc = (d, branch_status, inv_overview, peak_vol, menu_health, member_kpi, workforce_overview) => {
    if (d.id === 'Cabang' && branch_status && branch_status.length > 0) {
      let count = branch_status[0].sehat_count + branch_status[0].recovery_count;
      if (count === 4) return 'Semua cabang sehat dan berjalan optimal.';
      if (count === 3) return 'Mayoritas cabang dalam kondisi sehat dan aman.';
      if (count === 2) return 'Setengah cabang mulai tertekan, perlu pengawasan aktif.';
      return 'Mayoritas cabang tertekan secara margin operasional.';
    }
    if (d.id === 'Inventori' && inv_overview && inv_overview.length > 0) {
      if (inv_overview[0].low_points === 0 && inv_overview[0].overstock_value_pct <= 25) return 'Seluruh cabang dalam kondisi terkendali. Tidak ada krisis stok.';
      if (inv_overview[0].low_points <= 2) return 'Mayoritas cabang beroperasi secara terkendali. Segera tindak lanjuti cabang berstatus kritis.';
      return 'Terlalu banyak cabang berstatus kritis (merah). Rantai pasok sedang di luar kendali.';
    }
    if (d.id === 'Jam Sibuk' && peak_vol && peak_vol.length > 0) {
      let lvl = peak_vol[0].volatility_level;
      if (lvl === 'tinggi') return 'Dinamis & Sulit Ditebak. Rata-rata deviasi harian: ±' + peak_vol[0].cv_pct + '%.';
      if (lvl === 'sedang') return 'Terkendali & Sesekali Meleset. Rata-rata deviasi harian: ±' + peak_vol[0].cv_pct + '%.';
      return 'Karakteristik Demand Sangat Stabil & Terprediksi. Rata-rata deviasi harian: ±' + peak_vol[0].cv_pct + '%.';
    }
    if (d.id === 'Menu' && menu_health && menu_health.length > 0) {
      if (menu_health[0].declining_30d >= 5) return `Terdapat ${menu_health[0].declining_30d} dari ${menu_health[0].active_30d} menu aktif yang penjualannya anjlok >20%. Butuh perhatian khusus.`;
      if (menu_health[0].declining_30d >= 2) return `Terdapat ${menu_health[0].declining_30d} dari ${menu_health[0].active_30d} menu aktif yang penjualannya turun >20%.`;
      return `Mayoritas dari ${menu_health[0].active_30d} menu aktif menunjukkan tren volume penjualan yang stabil.`;
    }
    if (d.id === 'Member' && member_kpi && member_kpi.length > 0) {
      return `Dari total ${member_kpi[0].total_members} member, mayoritas terpantau aktif berkunjung sesuai dengan ritmenya masing-masing.`;
    }
    if (d.id === 'Pegawai' && workforce_overview && workforce_overview.length > 0) {
      let rate = workforce_overview[0].attendance_30d;
      if (rate >= 92) return 'Mayoritas jadwal shift terpenuhi secara optimal bulan ini.';
      if (rate >= 85) return 'Kehadiran cukup baik, namun waspadai beberapa shift kosong.';
      return 'Banyak shift kosong yang berisiko mengganggu operasional.';
    }
    return d.desc;
  };

  const getSyncedStatus = (d, health_30d, branch_status, inv_overview, peak_vol, menu_health, member_kpi, retention_kpi, workforce_overview) => {
    if (d.id === 'Cabang' && branch_status && branch_status.length > 0) {
      let count = branch_status[0].sehat_count + branch_status[0].recovery_count;
      return count >= 3 ? 'sehat' : count === 2 ? 'waspada' : 'kritis';
    }
    if (d.id === 'Inventori' && inv_overview && inv_overview.length > 0) {
      return (inv_overview[0].low_points === 0 && inv_overview[0].overstock_value_pct <= 25) ? 'sehat' : (inv_overview[0].low_points <= 2) ? 'waspada' : 'kritis';
    }
    if (d.id === 'Jam Sibuk' && peak_vol && peak_vol.length > 0) {
      let lvl = peak_vol[0].volatility_level;
      return lvl === 'tinggi' ? 'kritis' : lvl === 'sedang' ? 'waspada' : 'sehat';
    }
    if (d.id === 'Menu' && menu_health && menu_health.length > 0) {
      return menu_health[0].declining_30d >= 5 ? 'kritis' : menu_health[0].declining_30d >= 2 ? 'waspada' : 'sehat';
    }
    if (d.id === 'Member' && member_kpi && member_kpi.length > 0 && retention_kpi && retention_kpi.length > 0) {
      let activeRate = 100 - (retention_kpi[0].total_churn / member_kpi[0].total_members) * 100;
      return activeRate > 60 ? 'sehat' : activeRate >= 40 ? 'waspada' : 'kritis';
    }
    if (d.id === 'Pegawai' && workforce_overview && workforce_overview.length > 0) {
      let rate = workforce_overview[0].attendance_30d;
      return rate >= 92 ? 'sehat' : rate >= 85 ? 'waspada' : 'kritis';
    }
    return getDeptStatus(health_30d, d.id);
  };

  const getSyncedTitle = (d, menu_health, member_kpi, retention_kpi, workforce_overview) => {
    return d.name;
  };
</script>


<style>


/* Sidebar homepage link: teal text only when on this page */
/* Glassmorphism Cockpit Card */
.hero-health-card {
  border-radius: 20px;
  padding: 28px;
  margin-bottom: 24px;
  border: 1px solid rgba(255, 255, 255, 0.4);
  box-shadow: 0 10px 30px -10px rgba(0, 0, 0, 0.08), 
              inset 0 1px 1px 0 rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(8px);
  transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
  position: relative;
  overflow: hidden;
  display: block;
  text-decoration: none !important;
  color: inherit;
}
.hero-health-card::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  width: 6px;
  height: 100%;
}
.hero-health-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 20px 40px -15px rgba(0, 0, 0, 0.12);
}

/* Status: Sehat */
.hero-health-card.status-sehat {
  background: linear-gradient(135deg, rgba(16, 185, 129, 0.08) 0%, rgba(5, 150, 105, 0.03) 100%);
  border-color: rgba(16, 185, 129, 0.25);
}
.hero-health-card.status-sehat::before {
  background: #10b981;
}

/* Status: Waspada */
.hero-health-card.status-waspada {
  background: linear-gradient(135deg, rgba(245, 158, 11, 0.08) 0%, rgba(217, 119, 6, 0.03) 100%);
  border-color: rgba(245, 158, 11, 0.25);
}
.hero-health-card.status-waspada::before {
  background: #f59e0b;
}

/* Status: Kritis */
.hero-health-card.status-kritis {
  background: linear-gradient(135deg, rgba(239, 68, 68, 0.08) 0%, rgba(220, 38, 38, 0.03) 100%);
  border-color: rgba(239, 68, 68, 0.25);
}
.hero-health-card.status-kritis::before {
  background: #ef4444;
}

/* Header */
.hero-card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}
.hero-card-badge {
  font-size: 0.75rem;
  font-weight: 700;
  text-transform: uppercase;
  padding: 6px 14px;
  border-radius: 99px;
  letter-spacing: 0.06em;
  display: inline-flex;
  align-items: center;
  gap: 6px;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
}
.hero-health-card.status-sehat .hero-card-badge {
  background: rgba(16, 185, 129, 0.15);
  color: #065f46;
}
.hero-health-card.status-waspada .hero-card-badge {
  background: rgba(245, 158, 11, 0.15);
  color: #92400e;
}
.hero-health-card.status-kritis .hero-card-badge {
  background: rgba(239, 68, 68, 0.15);
  color: #991b1b;
}

.hero-card-title {
  font-size: 1.65rem;
  font-weight: 800;
  margin-bottom: 10px;
  line-height: 1.2;
  letter-spacing: -0.02em;
}

.hero-card-desc {
  font-size: 0.95rem;
  line-height: 1.65;
  color: var(--color-text-secondary);
  margin-bottom: 24px;
}

.hero-click-hint {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  font-size: 0.8rem;
  font-weight: 700;
  color: var(--color-text-secondary);
  background: rgba(0, 0, 0, 0.04);
  border: 1px solid rgba(0, 0, 0, 0.08);
  border-radius: 99px;
  padding: 6px 14px;
  transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
  margin-top: 4px;
}
.hero-health-card:hover .hero-click-hint {
  transform: translateX(10px);
  background: rgba(0, 0, 0, 0.08);
  color: var(--color-text-primary);
  border-color: rgba(0, 0, 0, 0.15);
}
.hero-click-hint span {
  transition: transform 0.3s cubic-bezier(0.16, 1, 0.3, 1);
}
.hero-health-card:hover .hero-click-hint span {
  transform: translateX(4px);
}

/* Metrics Row */
.hero-card-metrics {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 20px;
  border-top: 1px dashed rgba(128, 128, 128, 0.15);
  padding-top: 20px;
}
.hero-metric-item {
  display: flex;
  flex-direction: column;
}
.hero-metric-label {
  font-size: 0.72rem;
  text-transform: uppercase;
  color: var(--color-text-tertiary);
  font-weight: 700;
  margin-bottom: 6px;
  letter-spacing: 0.05em;
}
.hero-metric-value {
  font-size: 1.45rem;
  font-weight: 800;
  color: var(--color-text-primary);
  letter-spacing: -0.01em;
}

/* Live Status Badge Capsule */
.live-status-badge {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  background: rgba(0, 0, 0, 0.05);
  border: 1px solid rgba(0, 0, 0, 0.1);
  border-radius: 99px;
  padding: 6px 14px;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.02);
}

.live-status-text {
  font-size: 0.78rem;
  font-weight: 700;
  color: #000000;
}

.live-dot {
  width: 6px;
  height: 6px;
  background-color: #6b7280;
  border-radius: 50%;
  position: relative;
  display: inline-block;
}
.live-dot::after {
  content: '';
  width: 6px;
  height: 6px;
  background-color: #6b7280;
  border-radius: 50%;
  position: absolute;
  top: 0;
  left: 0;
  animation: pulse-dot 1.8s infinite ease-in-out;
}
@keyframes pulse-dot {
  0% {
    transform: scale(1);
    opacity: 0.8;
  }
  100% {
    transform: scale(2.8);
    opacity: 0;
  }
}

/* Portal Navigasi Cards */
.portal-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 16px;
  margin-top: 16px;
}
.portal-card {
  background: white;
  border: 1px solid rgba(0,0,0,0.08);
  border-radius: 12px;
  padding: 20px;
  text-decoration: none !important;
  color: inherit;
  transition: all 0.2s ease-in-out;
  display: flex;
  flex-direction: column;
  gap: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.02);
  position: relative;
}
.portal-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 10px 20px rgba(0,0,0,0.08);
  border-color: rgba(0,0,0,0.15);
}
.portal-icon {
  font-size: 2rem;
  margin-bottom: 4px;
}
.portal-title {
  font-weight: 800;
  font-size: 1.1rem;
  color: var(--color-text-primary);
}
.portal-desc {
  font-size: 0.85rem;
  color: #000000;
  line-height: 1.45;
}

/* Dynamic Status Backgrounds for Portal Cards */
.portal-card.status-sehat {
  background-color: rgba(22, 163, 74, 0.04);
  border-color: rgba(22, 163, 74, 0.2);
}
.portal-card.status-sehat:hover {
  background-color: rgba(22, 163, 74, 0.08);
  border-color: rgba(22, 163, 74, 0.4);
}
.portal-card.status-sehat .portal-title { color: #166534; }

.portal-card.status-waspada {
  background-color: rgba(202, 138, 4, 0.05);
  border-color: rgba(202, 138, 4, 0.2);
}
.portal-card.status-waspada:hover {
  background-color: rgba(202, 138, 4, 0.1);
  border-color: rgba(202, 138, 4, 0.4);
}
.portal-card.status-waspada .portal-title { color: #854d0e; }

.portal-card.status-kritis {
  background-color: rgba(220, 38, 38, 0.04);
  border-color: rgba(220, 38, 38, 0.2);
}
.portal-card.status-kritis:hover {
  background-color: rgba(220, 38, 38, 0.08);
  border-color: rgba(220, 38, 38, 0.4);
}
.portal-card.status-kritis .portal-title { color: #991b1b; }

.section-title {
    font-size: 1.2rem;
    font-weight: 800;
    color: #0f172a;
    margin-top: 48px;
    margin-bottom: 20px;
    display: flex;
    align-items: center;
    gap: 10px;
}

.radar-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 16px;
}
.radar-card {
    display: flex;
    align-items: flex-start;
    gap: 16px;
    padding: 20px;
    background: #ffffff;
    border-radius: 16px;
    border: 1px solid rgba(15, 23, 42, 0.06);
    box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02);
}
.radar-icon {
    font-size: 1.8rem;
    line-height: 1;
    padding: 12px;
    border-radius: 12px;
}
.radar-card.alert .radar-icon { background: #fef2f2; color: #ef4444; }
.radar-card.warning .radar-icon { background: #fffbeb; color: #f59e0b; }
.radar-card.success .radar-icon { background: #f0fdf4; color: #10b981; }

.radar-content h3 {
    margin: 0 0 4px 0;
    font-size: 1rem;
    font-weight: 700;
    color: #0f172a;
}
.radar-content p {
    margin: 0;
    font-size: 0.85rem;
    color: #64748b;
    line-height: 1.5;
}

.quick-links {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 16px;
}
.ql-card {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    text-align: center;
    padding: 32px 24px;
    background: #ffffff;
    border-radius: 20px;
    border: 1px solid rgba(15, 23, 42, 0.06);
    text-decoration: none;
    color: inherit;
    transition: all 0.25s ease;
}
.ql-card:hover {
    background: #f8fafc;
    border-color: #cbd5e1;
    transform: translateY(-4px);
    box-shadow: 0 10px 20px -5px rgba(0,0,0,0.04);
}
.ql-icon {
    font-size: 2.5rem;
    margin-bottom: 12px;
}
.ql-title {
    font-size: 1.1rem;
    font-weight: 800;
    color: #0f172a;
    margin-bottom: 4px;
}
.ql-desc {
    font-size: 0.85rem;
    color: #64748b;
}

/* CTA Banner — identical to Laporan Keuangan */
.clean-cta-banner {
    margin-top: -8px;
    margin-bottom: 40px;
    padding: 24px 28px;
    border-radius: 16px;
    background: rgba(13, 148, 136, 0.03);
    border: 1px solid rgba(13, 148, 136, 0.15);
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    gap: 24px;
    box-shadow: 0 4px 12px rgba(13, 148, 136, 0.03);
}
.clean-cta-content {
    display: flex;
    align-items: center;
    gap: 20px;
    flex: 1;
    min-width: 0;
}
.clean-cta-icon {
    font-size: 2.2rem;
    line-height: 1;
    filter: drop-shadow(0 2px 4px rgba(13, 148, 136, 0.15));
    flex-shrink: 0;
}
.clean-cta-text {
    min-width: 0;
}
.clean-cta-desc {
    margin: 0;
    font-size: 0.88rem;
    color: #475569;
    font-weight: 400;
    line-height: 1.6;
}

@media (max-width: 768px) {
    .radar-grid, .quick-links { grid-template-columns: 1fr; }
}
</style>

```sql hud_finance
SELECT * FROM restaurant.idx_fin_kpi_30d
```

```sql hud_branch
SELECT * FROM restaurant.idx_branch_kpi_30d
```

```sql hud_menu
SELECT * FROM restaurant.idx_menu_kpi_agg_30d
```

```sql hud_menu_passive
SELECT COUNT(DISTINCT menu_name) as pasif_count
FROM (
  SELECT menu_name, SUM(total_qty_sold) as qty
  FROM restaurant.menu_performance
  WHERE order_date >= (SELECT MAX(order_date) FROM restaurant.menu_performance) - INTERVAL '29 days'
  GROUP BY menu_name
) WHERE qty < 15
```

```sql top_branch
SELECT branch_name, total_revenue, total_orders FROM restaurant.idx_branch_kpi_30d ORDER BY total_revenue DESC LIMIT 1
```

```sql bot_branch
SELECT branch_name, total_revenue, total_orders FROM restaurant.idx_branch_kpi_30d ORDER BY total_revenue ASC LIMIT 1
```

```sql hud_alerts
WITH fin AS (SELECT * FROM restaurant.idx_fin_kpi_30d)
SELECT 
    CASE WHEN net_margin_pct < 15 THEN 'Kritis' ELSE 'Sehat' END as margin_status
FROM fin
```

```sql health_30d
SELECT * FROM restaurant.idx_health_30d
```

```sql branch_status
SELECT * FROM restaurant.branch_index_branch_status_counts
```

```sql inv_overview
SELECT * FROM restaurant.inv_index_inv_inventory_overview
```

```sql inv_branch_status
SELECT * FROM restaurant.inv_index_branch_status_counts
```

```sql peak_vol
SELECT * FROM restaurant.peak_volatility_metrics
```

```sql peak_branch_directory
SELECT * FROM restaurant.peak_branch_directory
```

```sql menu_health
SELECT * FROM restaurant.mart_menu_health_overview
```

```sql menu_engineering_30d
SELECT * FROM restaurant.mart_menu_engineering_30d
```

```sql member_kpi
SELECT * FROM restaurant.member_member_kpi_period WHERE period = '30d'
```

```sql retention_kpi
SELECT COUNT(*) as total_churn FROM restaurant.member_retention_queue
```

```sql workforce_overview
SELECT * FROM restaurant.workforce_health_overview
```

```sql burnout_risk
SELECT COUNT(*) as count 
FROM restaurant.top_overtime_employees_period
WHERE period = '30d' AND total_overtime_hours >= 10
```

```sql total_employees
SELECT COUNT(DISTINCT employee_id) as count
FROM restaurant.employee_shift_performance
WHERE attendance_date >= (SELECT MAX(attendance_date) - INTERVAL '29 days' FROM restaurant.employee_shift_performance)
```

```sql tgl_30d
SELECT
    -- End Date Format
    DAY(MAX(order_date)) || ' ' ||
    CASE MONTH(MAX(order_date))
        WHEN 1 THEN 'Januari' WHEN 2 THEN 'Februari' WHEN 3 THEN 'Maret'
        WHEN 4 THEN 'April'   WHEN 5 THEN 'Mei'       WHEN 6 THEN 'Juni'
        WHEN 7 THEN 'Juli'    WHEN 8 THEN 'Agustus'   WHEN 9 THEN 'September'
        WHEN 10 THEN 'Oktober' WHEN 11 THEN 'November' WHEN 12 THEN 'Desember'
    END || ' ' || YEAR(MAX(order_date)) AS tanggal_akhir,
    -- Start Date Format (30 days ago)
    DAY(MAX(order_date) - INTERVAL '29 days') || ' ' ||
    CASE MONTH(MAX(order_date) - INTERVAL '29 days')
        WHEN 1 THEN 'Januari' WHEN 2 THEN 'Februari' WHEN 3 THEN 'Maret'
        WHEN 4 THEN 'April'   WHEN 5 THEN 'Mei'       WHEN 6 THEN 'Juni'
        WHEN 7 THEN 'Juli'    WHEN 8 THEN 'Agustus'   WHEN 9 THEN 'September'
        WHEN 10 THEN 'Oktober' WHEN 11 THEN 'November' WHEN 12 THEN 'Desember'
    END || ' ' ||
    CASE WHEN YEAR(MAX(order_date) - INTERVAL '29 days') != YEAR(MAX(order_date))
         THEN CAST(YEAR(MAX(order_date) - INTERVAL '29 days') AS VARCHAR)
         ELSE ''
    END AS tanggal_awal
FROM restaurant.daily_revenue
```

<p style="margin-top: 12px; margin-bottom: 32px; color: var(--color-text-secondary);"><em>Dashboard intelijen bisnis untuk membantu Business Owner memantau kesehatan operasional, profitabilitas, dan tren bisnis.</em></p>

{#if health_30d && health_30d.length > 0}

<!-- 1. EXECUTIVE HUD (RINGKASAN KINERJA 30 HARI) -->
{#if hud_finance && hud_finance.length > 0 && health_30d && health_30d.length > 0}
  {@const margin = hud_finance[0].net_margin_pct}
  {@const status = margin < 5 ? 'kritis' : margin < 10 ? 'waspada' : 'sehat'}
  <div class="hero-health-card status-{status}" style="cursor: pointer;" onclick="window.location.href='/01-laporan-keuangan'">
    <div class="hero-card-header">
      <span class="hero-card-badge">
        {#if status === 'sehat'}
          🟢 Bisnis Sehat
        {:else if status === 'waspada'}
          🟡 Waspada
        {:else}
          🔴 Kritis
        {/if}
      </span>
      {#if tgl_30d}
        {#each tgl_30d as t}
          <span class="live-status-badge">
            <span class="live-dot"></span>
            <span class="live-status-text">Live: {t.tanggal_awal} {t.tanggal_awal === '' ? '' : '- '} {t.tanggal_akhir} (30H)</span>
          </span>
        {/each}
      {/if}
    </div>
    
    <div class="toc-anchor" style="position: absolute; opacity: 0; pointer-events: none; margin: 0; padding: 0; height: 0; overflow: hidden; font-size: 0px;">

## {#if status === 'sehat'}
        🎉 Finansial Sehat (Target 10% Tercapai)
      {:else if status === 'waspada'}
        ⚠️ Finansial Melandai (Di Bawah Target 10%)
      {:else}
        🚨 Keuangan Kritis (Margin Tergerus Parah)
      {/if}

</div>
<h2 class="hero-card-title">
      {#if status === 'sehat'}
        🎉 Finansial Sehat (Target 10% Tercapai)
      {:else if status === 'waspada'}
        ⚠️ Finansial Melandai (Di Bawah Target 10%)
      {:else}
        🚨 Keuangan Kritis (Margin Tergerus Parah)
      {/if}
    </h2>
    
    <p class="hero-card-desc" style="color: #000000; margin-bottom: 12px;">
      Net margin operasional saat ini berada di angka <strong>{margin}%</strong>. 
      {#if status === 'sehat'}
        Margin masih sehat untuk basis operasional utama.
      {:else if status === 'waspada'}
        Margin sudah masuk zona waspada dalam 30 hari.
      {:else}
        Margin sudah kritis secara operasional.
      {/if}
    </p>
    
    <div class="hero-click-hint">
      Lihat Detail Laporan Keuangan <span>→</span>
    </div>
  </div>
{/if}

<div style="display: flex; align-items: center; gap: 8px; margin-bottom: 24px; border-top: 1px dashed rgba(0,0,0,0.15); padding-top: 32px; margin-top: 32px;">
  <div style="font-size: 2rem;">📋</div>
  <div>
    <h2 style="margin: 0; font-size: 1.25rem; font-weight: 800; color: var(--color-text-primary); letter-spacing: -0.02em; text-transform: uppercase;">KENDALI OPERASIONAL LINTAS SEKTOR</h2>
    <div style="font-size: 0.85rem; color: black; font-weight: 500;">Fokus: Pantau anomali dan peluang optimasi di seluruh departemen. Klik modul di bawah untuk masuk ke analisis mendalam.</div>
  </div>
</div>

<div class="portal-grid">
  {#if health_30d}
    {#each depts as d}
      {@const dStat = getDeptStatus(health_30d, d.id)}
      {@const totalBranches = 4}
      
      {@const s_title = getSyncedTitle(d, typeof menu_health !== 'undefined' ? menu_health : null, typeof member_kpi !== 'undefined' ? member_kpi : null, typeof retention_kpi !== 'undefined' ? retention_kpi : null, typeof workforce_overview !== 'undefined' ? workforce_overview : null)}
      {@const s_desc = getSyncedDesc(d, typeof branch_status !== 'undefined' ? branch_status : null, typeof inv_overview !== 'undefined' ? inv_overview : null, typeof peak_vol !== 'undefined' ? peak_vol : null, typeof menu_health !== 'undefined' ? menu_health : null, typeof member_kpi !== 'undefined' ? member_kpi : null, typeof workforce_overview !== 'undefined' ? workforce_overview : null)}
      {@const s_status = getSyncedStatus(d, health_30d, typeof branch_status !== 'undefined' ? branch_status : null, typeof inv_overview !== 'undefined' ? inv_overview : null, typeof peak_vol !== 'undefined' ? peak_vol : null, typeof menu_health !== 'undefined' ? menu_health : null, typeof member_kpi !== 'undefined' ? member_kpi : null, typeof retention_kpi !== 'undefined' ? retention_kpi : null, typeof workforce_overview !== 'undefined' ? workforce_overview : null)}

      {@const c_sehat = typeof branch_status !== 'undefined' && branch_status.length > 0 ? branch_status[0].sehat_count + branch_status[0].recovery_count + branch_status[0].membaik_count : 0}
      {@const c_waspada = typeof branch_status !== 'undefined' && branch_status.length > 0 ? branch_status[0].waspada_count + branch_status[0].stabil_rendah_count : 0}
      {@const c_kritis = typeof branch_status !== 'undefined' && branch_status.length > 0 ? branch_status[0].early_warning_count + branch_status[0].turnaround_count : 0}

      {@const i_sehat = typeof inv_branch_status !== 'undefined' && inv_branch_status.length > 0 ? inv_branch_status[0].sehat_count : 0}
      {@const i_waspada = typeof inv_branch_status !== 'undefined' && inv_branch_status.length > 0 ? inv_branch_status[0].waspada_count : 0}
      {@const i_kritis = typeof inv_branch_status !== 'undefined' && inv_branch_status.length > 0 ? inv_branch_status[0].kritis_count : 0}

      {@const m_churnRate = (typeof member_kpi !== 'undefined' && typeof retention_kpi !== 'undefined' && member_kpi.length > 0 && retention_kpi.length > 0 && member_kpi[0].total_members > 0) ? (retention_kpi[0].total_churn / member_kpi[0].total_members) * 100 : 0}
      {@const m_sehat = typeof retention_kpi !== 'undefined' && retention_kpi.length > 0 ? (m_churnRate < 10 ? 1 : 0) : 0}
      {@const m_waspada = typeof retention_kpi !== 'undefined' && retention_kpi.length > 0 ? (m_churnRate >= 10 && m_churnRate < 20 ? 1 : 0) : 0}
      {@const m_kritis = typeof retention_kpi !== 'undefined' && retention_kpi.length > 0 ? (m_churnRate >= 20 ? 1 : 0) : 0}

      {@const p_problem = typeof workforce_overview !== 'undefined' && workforce_overview.length > 0 ? Number(workforce_overview[0].problem_employees_30d) : 0}
      {@const p_burnout = typeof burnout_risk !== 'undefined' && burnout_risk.length > 0 ? Number(burnout_risk[0].count) : 0}
      {@const p_total = typeof total_employees !== 'undefined' && total_employees.length > 0 ? Number(total_employees[0].count) || 100 : 100}
      {@const lateState = (p_problem / p_total) * 100 >= 15 ? 'critical' : ((p_problem / p_total) * 100 >= 5 ? 'warn' : 'safe')}
      {@const overtimeState = (p_burnout / p_total) * 100 >= 15 ? 'critical' : ((p_burnout / p_total) * 100 >= 5 ? 'warn' : 'safe')}
      {@const p_sehat = (lateState === 'safe' ? 1 : 0) + (overtimeState === 'safe' ? 1 : 0)}
      {@const p_waspada = (lateState === 'warn' ? 1 : 0) + (overtimeState === 'warn' ? 1 : 0)}
      {@const p_kritis = (lateState === 'critical' ? 1 : 0) + (overtimeState === 'critical' ? 1 : 0)}

      {@const mnu_active = typeof menu_health !== 'undefined' && menu_health.length > 0 ? menu_health[0].active_30d : 0}
      {@const mnu_declining = typeof menu_health !== 'undefined' && menu_health.length > 0 ? menu_health[0].declining_30d : 0}
      {@const mnu_stable = mnu_active - mnu_declining}
      {@const mnu_passive = typeof menu_engineering_30d !== 'undefined' && menu_engineering_30d.length > 0 ? menu_engineering_30d.filter(m => m.total_qty < 15).length : 0}

      {@const tf_liar = typeof peak_branch_directory !== 'undefined' && peak_branch_directory.length > 0 ? peak_branch_directory.filter(b => b.volatilitas > 20).length : 0}
      {@const tf_terkendali = typeof peak_branch_directory !== 'undefined' && peak_branch_directory.length > 0 ? peak_branch_directory.filter(b => b.volatilitas > 10 && b.volatilitas <= 20).length : 0}
      {@const tf_stabil = typeof peak_branch_directory !== 'undefined' && peak_branch_directory.length > 0 ? peak_branch_directory.filter(b => b.volatilitas <= 10).length : 0}

      <a href="{d.link}" class="portal-card status-{s_status}" data-sveltekit-reload>
        <div class="portal-icon">{d.icon}</div>
        <div class="portal-title">{s_title}</div>
        <div class="portal-desc">{s_desc}</div>
        {#if d.id === 'Cabang'}
          <div style="position: absolute; top: 16px; right: 16px; display: flex; gap: 10px; font-size: 0.85rem; font-weight: 700; background: rgba(0,0,0,0.04); border: 1px solid rgba(0,0,0,0.06); padding: 4px 12px; border-radius: 99px;">
            <span style="color: #15803d;" title="{c_sehat} Cabang Sehat">✓ {c_sehat}</span>
            <span style="color: #b45309;" title="{c_waspada} Cabang Waspada">! {c_waspada}</span>
            <span style="color: #b91c1c;" title="{c_kritis} Cabang Kritis">x {c_kritis}</span>
          </div>
        {/if}
        {#if d.id === 'Inventori'}
          <div style="position: absolute; top: 16px; right: 16px; display: flex; gap: 10px; font-size: 0.85rem; font-weight: 700; background: rgba(0,0,0,0.04); border: 1px solid rgba(0,0,0,0.06); padding: 4px 12px; border-radius: 99px;">
            <span style="color: #15803d;" title="{i_sehat} Cabang Sehat">✓ {i_sehat}</span>
            <span style="color: #b45309;" title="{i_waspada} Cabang Waspada">! {i_waspada}</span>
            <span style="color: #b91c1c;" title="{i_kritis} Cabang Kritis">x {i_kritis}</span>
          </div>
        {/if}
        {#if d.id === 'Member'}
          <div style="position: absolute; top: 16px; right: 16px; display: flex; gap: 10px; font-size: 0.85rem; font-weight: 700; background: rgba(0,0,0,0.04); border: 1px solid rgba(0,0,0,0.06); padding: 4px 12px; border-radius: 99px;">
            <span style="color: #15803d;" title="{m_sehat} Sehat">✓ {m_sehat}</span>
            <span style="color: #b45309;" title="{m_waspada} Waspada">! {m_waspada}</span>
            <span style="color: #b91c1c;" title="{m_kritis} Kritis">x {m_kritis}</span>
            <span style="color: #0284c7;" title="1 Spesial">★ 1</span>
          </div>
        {/if}
        {#if d.id === 'Pegawai'}
          <div style="position: absolute; top: 16px; right: 16px; display: flex; gap: 10px; font-size: 0.85rem; font-weight: 700; background: rgba(0,0,0,0.04); border: 1px solid rgba(0,0,0,0.06); padding: 4px 12px; border-radius: 99px;">
            <span style="color: #15803d;" title="{p_sehat} Indikator Sehat">✓ {p_sehat}</span>
            <span style="color: #b45309;" title="{p_waspada} Indikator Waspada">! {p_waspada}</span>
            <span style="color: #b91c1c;" title="{p_kritis} Indikator Kritis">x {p_kritis}</span>
          </div>
        {/if}
        {#if d.id === 'Menu'}
          <div style="position: absolute; top: 16px; right: 16px; display: flex; gap: 10px; font-size: 0.85rem; font-weight: 700; background: rgba(0,0,0,0.04); border: 1px solid rgba(0,0,0,0.06); padding: 4px 12px; border-radius: 99px;">
            <span style="color: #15803d;" title="{mnu_stable} Menu Aktif/Stabil">▲ {mnu_stable}</span>
            <span style="color: #b91c1c;" title="{mnu_declining} Menu Anjlok">▼ {mnu_declining}</span>
            <span style="color: #475569;" title="{mnu_passive} Menu Pasif (Risiko Food Waste)">■ {mnu_passive}</span>
          </div>
        {/if}
        {#if d.id === 'Jam Sibuk'}
          <div style="position: absolute; top: 16px; right: 16px; display: flex; gap: 10px; font-size: 0.85rem; font-weight: 700; background: rgba(0,0,0,0.04); border: 1px solid rgba(0,0,0,0.06); padding: 4px 12px; border-radius: 99px;">
            <span style="color: #b91c1c;" title="{tf_liar} Cabang Dinamis/Liar">≈ {tf_liar}</span>
            <span style="color: #b45309;" title="{tf_terkendali} Cabang Terkendali">≃ {tf_terkendali}</span>
            <span style="color: #15803d;" title="{tf_stabil} Cabang Sangat Stabil">= {tf_stabil}</span>
          </div>
        {/if}
      </a>
    {/each}
  {/if}
</div>
{:else}
  <GlobalLoading title="Menyiapkan Dashboard Utama..." desc="Menyinkronkan seluruh metrik operasional restoran. Mohon tunggu sebentar." />
{/if}

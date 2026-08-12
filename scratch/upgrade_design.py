import re

def upgrade_design():
    # Read the original backup
    with open("evidence/pages/index.md.bak") as f:
        content = f.read()

    # Split into lines
    lines = content.splitlines()

    # Preamble: lines 1-4
    preamble = "\n".join(lines[:4])

    # SQL Code Blocks
    sql_blocks = []
    sql_block_re = re.compile(r"^```sql\s+(\w+)")
    
    current_block = None
    in_sql = False
    
    for i, line in enumerate(lines):
        m = sql_block_re.match(line)
        if m:
            in_sql = True
            current_block = {
                "name": m.group(1),
                "start": i,
                "lines": [line]
            }
        elif in_sql:
            current_block["lines"].append(line)
            if line.strip() == "```":
                in_sql = False
                sql_blocks.append(current_block)
                current_block = None

    # Determine which SQL blocks go to which page
    sql_7d = []
    sql_30d = []
    sql_y = []

    for sb in sql_blocks:
        name = sb["name"]
        code = "\n".join(sb["lines"])
        
        if name == "tgl":
            sql_7d.append(code)
            sql_30d.append(code)
            sql_y.append(code)
        elif name.endswith("_7d"):
            sql_7d.append(code)
        elif name.endswith("_30d"):
            sql_30d.append(code)
        else:
            sql_y.append(code)

    # Markup section
    last_sql_end = max(sb["start"] + len(sb["lines"]) for sb in sql_blocks)
    markup_lines = lines[last_sql_end:]

    # Styles Block with restored period tab styles and live status capsule on the right (no border-bottom)
    style_content = """<style>
.table-scroll-container {
  overflow-x: auto;
  width: 100%;
  -webkit-overflow-scrolling: touch;
  margin: 14px 0;
  border-radius: 8px;
}

.table-scroll-container table {
  width: 100%;
  min-width: 650px;
}

.table-scroll-container th,
.table-scroll-container td {
  white-space: nowrap;
}

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

/* Header Row Container (No separating lines) */
.cockpit-header-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 12px;
  margin-bottom: 24px;
  flex-wrap: wrap;
  gap: 16px;
}

/* Live Status Badge Capsule on the right */
.live-status-badge {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  background: rgba(34, 197, 94, 0.06);
  border: 1px solid rgba(34, 197, 94, 0.15);
  border-radius: 99px;
  padding: 6px 14px;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.02);
}

.live-status-text {
  font-size: 0.78rem;
  font-weight: 700;
  color: #15803d;
  letter-spacing: 0.01em;
}

.live-dot {
  width: 6px;
  height: 6px;
  background-color: #22c55e;
  border-radius: 50%;
  position: relative;
  display: inline-block;
}
.live-dot::after {
  content: '';
  width: 6px;
  height: 6px;
  background-color: #22c55e;
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
</style>"""

    # Upgraded Cockpit and Restored Indicator list markup
    card_7d = """
{#if fin_kpi_7d && fin_kpi_7d.length > 0 && health_7d && health_7d.length > 0}
  {@const margin = fin_kpi_7d[0].net_margin_pct}
  {@const kritisCount = health_7d.filter(r => r.status === 'kritis').length}
  {@const waspadaCount = health_7d.filter(r => r.status === 'perhatian').length}
  {@const status = (margin < 10 || kritisCount >= 3) ? 'kritis' : (margin < 15 || kritisCount > 0 || waspadaCount > 0) ? 'waspada' : 'sehat'}
  
  <div class="hero-health-card status-{status}">
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
      <span style="font-size: 0.75rem; color: var(--color-text-tertiary); font-weight: 600;">RINGKASAN KINERJA 7 HARI</span>
    </div>
    
    <h2 class="hero-card-title">
      {#if status === 'sehat'}
        🎉 Bisnis Sehat tapi masih bisa dioptimalisasi
      {:else if status === 'waspada'}
        ⚠️ Kinerja Melandai & Butuh Pengawasan
      {:else}
        🚨 Kinerja Kritis (Butuh Tindakan Segera)
      {/if}
    </h2>
    
    <p class="hero-card-desc">
      {#if status === 'sehat'}
        Margin keuntungan bersih berada di tingkat sehat ({margin}%). Tidak ada masalah kritis yang terdeteksi, namun beberapa area dapat dioptimalkan.
      {:else if status === 'waspada'}
        {#if margin < 15 && margin >= 10}
          Margin keuntungan bersih melandai ke angka <strong>{margin}%</strong> (zona waspada 10% - 15%).
        {:else}
          Margin keuntungan bersih berada di tingkat sehat ({margin}%), namun terdapat <strong>{kritisCount} parameter kritis</strong> dan <strong>{waspadaCount} parameter waspada</strong> yang perlu diperhatikan.
        {/if}
      {:else}
        {#if margin < 10}
          Margin keuntungan bersih turun ke angka kritis <strong>{margin}%</strong> (di bawah batas aman 10%).
        {:else}
          Margin keuntungan bersih berada di tingkat sehat ({margin}%), tetapi terdapat <strong>{kritisCount} parameter operasional kritis</strong> yang memerlukan tindakan korektif segera.
        {/if}
      {/if}
    </p>
    
    <div class="hero-card-metrics">
      <div class="hero-metric-item">
        <span class="hero-metric-label">Net Margin</span>
        <span class="hero-metric-value">{margin}%</span>
      </div>
      <div class="hero-metric-item">
        <span class="hero-metric-label">Parameter Kritis</span>
        <span class="hero-metric-value" style="color: {kritisCount > 0 ? '#b91c1c' : 'var(--color-text-primary)'}">{kritisCount}</span>
      </div>
      <div class="hero-metric-item">
        <span class="hero-metric-label">Parameter Waspada</span>
        <span class="hero-metric-value" style="color: {waspadaCount > 0 ? '#a16207' : 'var(--color-text-primary)'}">{waspadaCount}</span>
      </div>
    </div>
  </div>
{/if}

<div style="background:var(--color-background-secondary);border:1px solid var(--color-border-tertiary);border-radius:12px;padding:1.1rem 1.3rem;margin-bottom:24px;box-shadow:0 1px 3px rgba(0,0,0,0.04);">

<div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:14px;padding-bottom:12px;border-bottom:1px solid var(--color-border-tertiary);flex-wrap:wrap;gap:8px;">
<span style="font-size:12px;font-weight:600;letter-spacing:0.05em;text-transform:uppercase;color:var(--color-text-tertiary);">Ringkasan {health_7d.length} Indikator</span>
<div style="display:flex;align-items:center;gap:8px;flex-wrap:wrap;">
<span style="display:inline-flex;align-items:center;gap:5px;padding:3px 10px;border-radius:20px;font-size:12px;font-weight:600;background:rgba(22,163,74,0.10);color:#166534;border:1px solid rgba(22,163,74,0.2);">
<svg width="10" height="10" viewBox="0 0 10 10" fill="none"><path d="M2 5l2.5 2.5L8 3" stroke="#166534" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
{health_7d.filter(r => r.status === 'sehat').length} sehat
</span>
<span style="display:inline-flex;align-items:center;gap:5px;padding:3px 10px;border-radius:20px;font-size:12px;font-weight:600;background:rgba(234,179,8,0.10);color:#854d0e;border:1px solid rgba(234,179,8,0.25);">
<svg width="10" height="10" viewBox="0 0 10 10" fill="none"><path d="M5 2v3.5M5 7.5v.5" stroke="#854d0e" stroke-width="1.5" stroke-linecap="round"/></svg>
{health_7d.filter(r => r.status === 'perhatian').length} perlu perhatian
</span>
<span style="display:inline-flex;align-items:center;gap:5px;padding:3px 10px;border-radius:20px;font-size:12px;font-weight:600;background:rgba(220,38,38,0.08);color:#991b1b;border:1px solid rgba(220,38,38,0.2);">
<svg width="10" height="10" viewBox="0 0 10 10" fill="none"><path d="M3 3l4 4M7 3l-4 4" stroke="#991b1b" stroke-width="1.5" stroke-linecap="round"/></svg>
{health_7d.filter(r => r.status === 'kritis').length} kritis
</span>
</div>
</div>

{#if health_7d.filter(r => r.status === 'kritis').length === 0 && health_7d.filter(r => r.status === 'perhatian').length === 0}
<div style="display:flex;align-items:center;gap:10px;padding:10px 12px;background:rgba(22,163,74,0.06);border-radius:8px;font-size:13px;color:#166534;">
<svg width="16" height="16" viewBox="0 0 16 16" fill="none"><circle cx="8" cy="8" r="7" stroke="#16a34a" stroke-width="1.5"/><path d="M5 8l2.5 2.5L11 5.5" stroke="#16a34a" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
<strong>Semua indikator sehat</strong> — tidak ada area yang perlu perhatian dalam 7 hari terakhir
</div>
{:else}
{#each health_7d.filter(r => r.status === 'kritis') as row}
<div style="display:flex;align-items:flex-start;gap:10px;padding:8px 10px;margin-bottom:4px;background:rgba(220,38,38,0.04);border:1px solid rgba(220,38,38,0.12);border-radius:8px;font-size:13px;">
<div style="width:7px;height:7px;border-radius:50%;background:#dc2626;flex-shrink:0;margin-top:4px;"></div>
<div><span style="font-weight:600;color:#991b1b;">{row.icon} {row.section}</span> <span style="color:var(--color-text-secondary);">·</span> <span style="color:var(--color-text-secondary);">{row.metrik}</span> — {row.label}</div>
</div>
{/each}
{#each health_7d.filter(r => r.status === 'perhatian') as row}
<div style="display:flex;align-items:flex-start;gap:10px;padding:8px 10px;margin-bottom:4px;background:rgba(234,179,8,0.04);border:1px solid rgba(234,179,8,0.18);border-radius:8px;font-size:13px;">
<div style="width:7px;height:7px;border-radius:50%;background:#ca8a04;flex-shrink:0;margin-top:4px;"></div>
<div><span style="font-weight:600;color:#854d0e;">{row.icon} {row.section}</span> <span style="color:var(--color-text-secondary);">·</span> <span style="color:var(--color-text-secondary);">{row.metrik}</span> — {row.label}</div>
</div>
{/each}
{/if}

</div>
"""

    card_30d = """
{#if fin_kpi_30d && fin_kpi_30d.length > 0 && health_30d && health_30d.length > 0}
  {@const margin = fin_kpi_30d[0].net_margin_pct}
  {@const kritisCount = health_30d.filter(r => r.status === 'kritis').length}
  {@const waspadaCount = health_30d.filter(r => r.status === 'perhatian').length}
  {@const status = (margin < 10 || kritisCount >= 3) ? 'kritis' : (margin < 15 || kritisCount > 0 || waspadaCount > 0) ? 'waspada' : 'sehat'}
  
  <div class="hero-health-card status-{status}">
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
      <span style="font-size: 0.75rem; color: var(--color-text-tertiary); font-weight: 600;">RINGKASAN KINERJA 30 HARI</span>
    </div>
    
    <h2 class="hero-card-title">
      {#if status === 'sehat'}
        🎉 Bisnis Sehat tapi masih bisa dioptimalisasi
      {:else if status === 'waspada'}
        ⚠️ Kinerja Melandai & Butuh Pengawasan
      {:else}
        🚨 Kinerja Kritis (Butuh Tindakan Segera)
      {/if}
    </h2>
    
    <p class="hero-card-desc">
      {#if status === 'sehat'}
        Margin keuntungan bersih berada di tingkat sehat ({margin}%). Tidak ada masalah kritis yang terdeteksi, namun beberapa area dapat dioptimalkan.
      {:else if status === 'waspada'}
        {#if margin < 15 && margin >= 10}
          Margin keuntungan bersih melandai ke angka <strong>{margin}%</strong> (zona waspada 10% - 15%).
        {:else}
          Margin keuntungan bersih berada di tingkat sehat ({margin}%), namun terdapat <strong>{kritisCount} parameter kritis</strong> dan <strong>{waspadaCount} parameter waspada</strong> yang perlu diperhatikan.
        {/if}
      {:else}
        {#if margin < 10}
          Margin keuntungan bersih turun ke angka kritis <strong>{margin}%</strong> (di bawah batas aman 10%).
        {:else}
          Margin keuntungan bersih berada di tingkat sehat ({margin}%), tetapi terdapat <strong>{kritisCount} parameter operasional kritis</strong> yang memerlukan tindakan korektif segera.
        {/if}
      {/if}
    </p>
    
    <div class="hero-card-metrics">
      <div class="hero-metric-item">
        <span class="hero-metric-label">Net Margin</span>
        <span class="hero-metric-value">{margin}%</span>
      </div>
      <div class="hero-metric-item">
        <span class="hero-metric-label">Parameter Kritis</span>
        <span class="hero-metric-value" style="color: {kritisCount > 0 ? '#b91c1c' : 'var(--color-text-primary)'}">{kritisCount}</span>
      </div>
      <div class="hero-metric-item">
        <span class="hero-metric-label">Parameter Waspada</span>
        <span class="hero-metric-value" style="color: {waspadaCount > 0 ? '#a16207' : 'var(--color-text-primary)'}">{waspadaCount}</span>
      </div>
    </div>
  </div>
{/if}

<div style="background:var(--color-background-secondary);border:1px solid var(--color-border-tertiary);border-radius:12px;padding:1.1rem 1.3rem;margin-bottom:24px;box-shadow:0 1px 3px rgba(0,0,0,0.04);">

<div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:14px;padding-bottom:12px;border-bottom:1px solid var(--color-border-tertiary);flex-wrap:wrap;gap:8px;">
<span style="font-size:12px;font-weight:600;letter-spacing:0.05em;text-transform:uppercase;color:var(--color-text-tertiary);">Ringkasan {health_30d.length} Indikator</span>
<div style="display:flex;align-items:center;gap:8px;flex-wrap:wrap;">
<span style="display:inline-flex;align-items:center;gap:5px;padding:3px 10px;border-radius:20px;font-size:12px;font-weight:600;background:rgba(22,163,74,0.10);color:#166534;border:1px solid rgba(22,163,74,0.2);">
<svg width="10" height="10" viewBox="0 0 10 10" fill="none"><path d="M2 5l2.5 2.5L8 3" stroke="#166534" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
{health_30d.filter(r => r.status === 'sehat').length} sehat
</span>
<span style="display:inline-flex;align-items:center;gap:5px;padding:3px 10px;border-radius:20px;font-size:12px;font-weight:600;background:rgba(234,179,8,0.10);color:#854d0e;border:1px solid rgba(234,179,8,0.25);">
<svg width="10" height="10" viewBox="0 0 10 10" fill="none"><path d="M5 2v3.5M5 7.5v.5" stroke="#854d0e" stroke-width="1.5" stroke-linecap="round"/></svg>
{health_30d.filter(r => r.status === 'perhatian').length} perlu perhatian
</span>
<span style="display:inline-flex;align-items:center;gap:5px;padding:3px 10px;border-radius:20px;font-size:12px;font-weight:600;background:rgba(220,38,38,0.08);color:#991b1b;border:1px solid rgba(220,38,38,0.2);">
<svg width="10" height="10" viewBox="0 0 10 10" fill="none"><path d="M3 3l4 4M7 3l-4 4" stroke="#991b1b" stroke-width="1.5" stroke-linecap="round"/></svg>
{health_30d.filter(r => r.status === 'kritis').length} kritis
</span>
</div>
</div>

{#if health_30d.filter(r => r.status === 'kritis').length === 0 && health_30d.filter(r => r.status === 'perhatian').length === 0}
<div style="display:flex;align-items:center;gap:10px;padding:10px 12px;background:rgba(22,163,74,0.06);border-radius:8px;font-size:13px;color:#166534;">
<svg width="16" height="16" viewBox="0 0 16 16" fill="none"><circle cx="8" cy="8" r="7" stroke="#16a34a" stroke-width="1.5"/><path d="M5 8l2.5 2.5L11 5.5" stroke="#16a34a" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
<strong>Semua indikator sehat</strong> — tidak ada area yang perlu perhatian dalam 30 hari terakhir
</div>
{:else}
{#each health_30d.filter(r => r.status === 'kritis') as row}
<div style="display:flex;align-items:flex-start;gap:10px;padding:8px 10px;margin-bottom:4px;background:rgba(220,38,38,0.04);border:1px solid rgba(220,38,38,0.12);border-radius:8px;font-size:13px;">
<div style="width:7px;height:7px;border-radius:50%;background:#dc2626;flex-shrink:0;margin-top:4px;"></div>
<div><span style="font-weight:600;color:#991b1b;">{row.icon} {row.section}</span> <span style="color:var(--color-text-secondary);">·</span> <span style="color:var(--color-text-secondary);">{row.metrik}</span> — {row.label}</div>
</div>
{/each}
{#each health_30d.filter(r => r.status === 'perhatian') as row}
<div style="display:flex;align-items:flex-start;gap:10px;padding:8px 10px;margin-bottom:4px;background:rgba(234,179,8,0.04);border:1px solid rgba(234,179,8,0.18);border-radius:8px;font-size:13px;">
<div style="width:7px;height:7px;border-radius:50%;background:#ca8a04;flex-shrink:0;margin-top:4px;"></div>
<div><span style="font-weight:600;color:#854d0e;">{row.icon} {row.section}</span> <span style="color:var(--color-text-secondary);">·</span> <span style="color:var(--color-text-secondary);">{row.metrik}</span> — {row.label}</div>
</div>
{/each}
{/if}

</div>
"""

    card_y = """
{#if fin_kpi_yesterday && fin_kpi_yesterday.length > 0 && health_yesterday && health_yesterday.length > 0}
  {@const margin = fin_kpi_yesterday[0].net_margin_pct}
  {@const kritisCount = health_yesterday.filter(r => r.status === 'kritis').length}
  {@const waspadaCount = health_yesterday.filter(r => r.status === 'perhatian').length}
  {@const status = (margin < 10 || kritisCount >= 3) ? 'kritis' : (margin < 15 || kritisCount > 0 || waspadaCount > 0) ? 'waspada' : 'sehat'}
  
  <div class="hero-health-card status-{status}">
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
      <span style="font-size: 0.75rem; color: var(--color-text-tertiary); font-weight: 600;">RINGKASAN KINERJA KEMARIN ({tgl[0].nama_hari})</span>
    </div>
    
    <h2 class="hero-card-title">
      {#if status === 'sehat'}
        🎉 Bisnis Sehat tapi masih bisa dioptimalisasi
      {:else if status === 'waspada'}
        ⚠️ Kinerja Melandai & Butuh Pengawasan
      {:else}
        🚨 Kinerja Kritis (Butuh Tindakan Segera)
      {/if}
    </h2>
    
    <p class="hero-card-desc">
      {#if status === 'sehat'}
        Margin keuntungan bersih kemarin berada di tingkat sehat ({margin}%). Tidak ada masalah kritis yang terdeteksi, namun beberapa area dapat dioptimalkan.
      {:else if status === 'waspada'}
        {#if margin < 15 && margin >= 10}
          Margin keuntungan bersih kemarin melandai ke angka <strong>{margin}%</strong> (zona waspada 10% - 15%).
        {:else}
          Margin keuntungan bersih kemarin berada di tingkat sehat ({margin}%), namun terdapat <strong>{kritisCount} parameter kritis</strong> dan <strong>{waspadaCount} parameter waspada</strong> yang perlu diperhatikan.
        {/if}
      {:else}
        {#if margin < 10}
          Margin keuntungan bersih kemarin turun ke angka kritis <strong>{margin}%</strong> (di bawah batas aman 10%).
        {:else}
          Margin keuntungan bersih kemarin berada di tingkat sehat ({margin}%), tetapi terdapat <strong>{kritisCount} parameter operasional kritis</strong> yang memerlukan tindakan korektif segera.
        {/if}
      {/if}
    </p>
    
    <div class="hero-card-metrics">
      <div class="hero-metric-item">
        <span class="hero-metric-label">Net Margin</span>
        <span class="hero-metric-value">{margin}%</span>
      </div>
      <div class="hero-metric-item">
        <span class="hero-metric-label">Parameter Kritis</span>
        <span class="hero-metric-value" style="color: {kritisCount > 0 ? '#b91c1c' : 'var(--color-text-primary)'}">{kritisCount}</span>
      </div>
      <div class="hero-metric-item">
        <span class="hero-metric-label">Parameter Waspada</span>
        <span class="hero-metric-value" style="color: {waspadaCount > 0 ? '#a16207' : 'var(--color-text-primary)'}">{waspadaCount}</span>
      </div>
    </div>
  </div>
{/if}

<div style="background:var(--color-background-secondary);border:1px solid var(--color-border-tertiary);border-radius:12px;padding:1.1rem 1.3rem;margin-bottom:24px;box-shadow:0 1px 3px rgba(0,0,0,0.04);">

<div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:14px;padding-bottom:12px;border-bottom:1px solid var(--color-border-tertiary);flex-wrap:wrap;gap:8px;">
<span style="font-size:12px;font-weight:600;letter-spacing:0.05em;text-transform:uppercase;color:var(--color-text-tertiary);">Ringkasan {health_yesterday.length} Indikator</span>
<div style="display:flex;align-items:center;gap:8px;flex-wrap:wrap;">
<span style="display:inline-flex;align-items:center;gap:5px;padding:3px 10px;border-radius:20px;font-size:12px;font-weight:600;background:rgba(22,163,74,0.10);color:#166534;border:1px solid rgba(22,163,74,0.2);">
<svg width="10" height="10" viewBox="0 0 10 10" fill="none"><path d="M2 5l2.5 2.5L8 3" stroke="#166534" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
{health_yesterday.filter(r => r.status === 'sehat').length} sehat
</span>
<span style="display:inline-flex;align-items:center;gap:5px;padding:3px 10px;border-radius:20px;font-size:12px;font-weight:600;background:rgba(234,179,8,0.10);color:#854d0e;border:1px solid rgba(234,179,8,0.25);">
<svg width="10" height="10" viewBox="0 0 10 10" fill="none"><path d="M5 2v3.5M5 7.5v.5" stroke="#854d0e" stroke-width="1.5" stroke-linecap="round"/></svg>
{health_yesterday.filter(r => r.status === 'perhatian').length} perlu perhatian
</span>
<span style="display:inline-flex;align-items:center;gap:5px;padding:3px 10px;border-radius:20px;font-size:12px;font-weight:600;background:rgba(220,38,38,0.08);color:#991b1b;border:1px solid rgba(220,38,38,0.2);">
<svg width="10" height="10" viewBox="0 0 10 10" fill="none"><path d="M3 3l4 4M7 3l-4 4" stroke="#991b1b" stroke-width="1.5" stroke-linecap="round"/></svg>
{health_yesterday.filter(r => r.status === 'kritis').length} kritis
</span>
</div>
</div>

{#if health_yesterday.filter(r => r.status === 'kritis').length === 0 && health_yesterday.filter(r => r.status === 'perhatian').length === 0}
<div style="display:flex;align-items:center;gap:10px;padding:10px 12px;background:rgba(22,163,74,0.06);border-radius:8px;font-size:13px;color:#166534;">
<svg width="16" height="16" viewBox="0 0 16 16" fill="none"><circle cx="8" cy="8" r="7" stroke="#16a34a" stroke-width="1.5"/><path d="M5 8l2.5 2.5L11 5.5" stroke="#16a34a" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
<strong>Semua indikator sehat</strong> — tidak ada area yang perlu perhatian kemarin
</div>
{:else}
{#each health_yesterday.filter(r => r.status === 'kritis') as row}
<div style="display:flex;align-items:flex-start;gap:10px;padding:8px 10px;margin-bottom:4px;background:rgba(220,38,38,0.04);border:1px solid rgba(220,38,38,0.12);border-radius:8px;font-size:13px;">
<div style="width:7px;height:7px;border-radius:50%;background:#dc2626;flex-shrink:0;margin-top:4px;"></div>
<div><span style="font-weight:600;color:#991b1b;">{row.icon} {row.section}</span> <span style="color:var(--color-text-secondary);">·</span> <span style="color:var(--color-text-secondary);">{row.metrik}</span> — {row.label}</div>
</div>
{/each}
{#each health_yesterday.filter(r => r.status === 'perhatian') as row}
<div style="display:flex;align-items:flex-start;gap:10px;padding:8px 10px;margin-bottom:4px;background:rgba(234,179,8,0.04);border:1px solid rgba(234,179,8,0.18);border-radius:8px;font-size:13px;">
<div style="width:7px;height:7px;border-radius:50%;background:#ca8a04;flex-shrink:0;margin-top:4px;"></div>
<div><span style="font-weight:600;color:#854d0e;">{row.icon} {row.section}</span> <span style="color:var(--color-text-secondary);">·</span> <span style="color:var(--color-text-secondary);">{row.metrik}</span> — {row.label}</div>
</div>
{/each}
{/if}

</div>
"""

    out_7d = []
    out_30d = []
    out_y = []

    stack = []
    in_cockpit_block = False
    cockpit_block_done = False

    def get_current_period_branch():
        for item in reversed(stack):
            if item["period_branch"] is not None:
                return item["period_branch"]
        return "common"

    for line in markup_lines:
        if "<ButtonGroup" in line or "<ButtonGroupItem" in line or "</ButtonGroup>" in line:
            continue

        # Match {#if inputs.period === '7d'}
        if "{#if inputs.period === '7d'}" in line:
            stack.append({"type": "if", "period_branch": "7d"})
            if not cockpit_block_done:
                in_cockpit_block = True
            continue
        
        # Match {:else if inputs.period === '30d'}
        if "{:else if inputs.period === '30d'}" in line:
            if stack and stack[-1]["type"] == "if":
                stack[-1]["period_branch"] = "30d"
            continue
        
        # Match {:else}
        if "{:else}" in line:
            if stack and stack[-1]["type"] == "if" and stack[-1]["period_branch"] in ["7d", "30d"]:
                stack[-1]["period_branch"] = "yesterday"
                continue

        # Match other {#if ...}
        if "{#if" in line and "inputs.period" not in line:
            stack.append({"type": "if", "period_branch": None})

        # Match {#each ...}
        if "{#each" in line:
            stack.append({"type": "each", "period_branch": None})

        # Match {/if}
        if "{/if}" in line:
            if stack:
                top = stack.pop()
                if top["period_branch"] in ["7d", "30d", "yesterday"]:
                    if in_cockpit_block:
                        in_cockpit_block = False
                        cockpit_block_done = True
                        # Insert the new cards
                        out_7d.append(card_7d)
                        out_30d.append(card_30d)
                        out_y.append(card_y)
                    continue

        # Match {/each}
        if "{/each}" in line:
            if stack:
                stack.pop()

        if in_cockpit_block:
            continue

        branch = get_current_period_branch()
        if branch == "7d":
            out_7d.append(line)
        elif branch == "30d":
            out_30d.append(line)
        elif branch == "yesterday":
            out_y.append(line)
        else: # common
            # Skip the redundant update notice lines inside markup
            if "Data diperbarui otomatis setiap hari." in line or "Laporan berikut mencakup operasional" in line or line.strip() == "---" and len(out_y) < 10:
                continue
            out_7d.append(line)
            out_30d.append(line)
            out_y.append(line)

    markup_7d = "\n".join(out_7d)
    markup_30d = "\n".join(out_30d)
    markup_y = "\n".join(out_y)

    # Period tabs on the left, live notice capsule badge on the right
    header_y = """
<div class="cockpit-header-row">
  <div class="evidence-tabs-container" style="margin: 0;">
    <a href="/00-cockpit" class="tab-button active">📅 Kemarin</a>
    <a href="/00-cockpit/7d" class="tab-button">📊 7 Hari</a>
    <a href="/00-cockpit/30d" class="tab-button">🔭 30 Hari</a>
  </div>
  <div class="live-status-badge">
    <span class="live-dot"></span>
    <span class="live-status-text">Live: {tgl[0].nama_hari}, {tgl[0].tanggal_display}</span>
  </div>
</div>
"""

    header_7d = """
<div class="cockpit-header-row">
  <div class="evidence-tabs-container" style="margin: 0;">
    <a href="/00-cockpit" class="tab-button">📅 Kemarin</a>
    <a href="/00-cockpit/7d" class="tab-button active">📊 7 Hari</a>
    <a href="/00-cockpit/30d" class="tab-button">🔭 30 Hari</a>
  </div>
  <div class="live-status-badge">
    <span class="live-dot"></span>
    <span class="live-status-text">Live: {tgl[0].nama_hari}, {tgl[0].tanggal_display}</span>
  </div>
</div>
"""

    header_30d = """
<div class="cockpit-header-row">
  <div class="evidence-tabs-container" style="margin: 0;">
    <a href="/00-cockpit" class="tab-button">📅 Kemarin</a>
    <a href="/00-cockpit/7d" class="tab-button">📊 7 Hari</a>
    <a href="/00-cockpit/30d" class="tab-button active">🔭 30 Hari</a>
  </div>
  <div class="live-status-badge">
    <span class="live-dot"></span>
    <span class="live-status-text">Live: {tgl[0].nama_hari}, {tgl[0].tanggal_display}</span>
  </div>
</div>
"""

    # We enforce sidebar_link: false on ALL three cockpit page frontmatters
    frontmatter_y = preamble.replace("title: Wekadata — Ringkasan Performa Bisnis", "title: Wekadata — Ringkasan Performa Bisnis\nsidebar_link: false")
    frontmatter_7d = preamble.replace("title: Wekadata — Ringkasan Performa Bisnis", "title: Wekadata — Ringkasan Performa Bisnis\nsidebar_link: false")
    frontmatter_30d = preamble.replace("title: Wekadata — Ringkasan Performa Bisnis", "title: Wekadata — Ringkasan Performa Bisnis\nsidebar_link: false")

    sub_text = "Kesehatan finansial bisnis: margin, tekanan biaya, dan konteks musiman dalam satu halaman."

    # Yesterday Page (index.md) - NO separating markdown rules (---)
    content_y = f"{frontmatter_y}\n\n{sub_text}\n\n{style_content}\n\n" + "\n\n".join(sql_y) + f"\n\n{header_y}\n\n" + markup_y
    with open("evidence/pages/00-cockpit/index.md", "w") as out:
        out.write(content_y)

    # 7d Page (7d.md) - NO separating markdown rules (---)
    content_7d = f"{frontmatter_7d}\n\n{sub_text}\n\n{style_content}\n\n" + "\n\n".join(sql_7d) + f"\n\n{header_7d}\n\n" + markup_7d
    with open("evidence/pages/00-cockpit/7d.md", "w") as out:
        out.write(content_7d)

    # 30d Page (30d.md) - NO separating markdown rules (---)
    content_30d = f"{frontmatter_30d}\n\n{sub_text}\n\n{style_content}\n\n" + "\n\n".join(sql_30d) + f"\n\n{header_30d}\n\n" + markup_30d
    with open("evidence/pages/00-cockpit/30d.md", "w") as out:
        out.write(content_30d)

    print("Success! Subtitle added successfully.")

if __name__ == "__main__":
    upgrade_design()

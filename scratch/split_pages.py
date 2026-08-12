import re

def parse_and_split():
    with open("evidence/pages/index.md") as f:
        content = f.read()

    # Split into lines
    lines = content.splitlines()

    # Preamble: lines 1-4
    preamble = "\n".join(lines[:4])

    # Style block: find <style> to </style>
    style_content = ""
    in_style = False
    style_start = 0
    style_end = 0
    for i, line in enumerate(lines):
        if "<style>" in line:
            in_style = True
            style_start = i
        if "</style>" in line:
            style_end = i
            style_content = "\n".join(lines[style_start:style_end+1])
            break

    # SQL Code Blocks
    # Find all SQL code blocks and their names
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

    # Status Cards Svelte Code
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
          Bisnis Sehat
        {:else if status === 'waspada'}
          Waspada
        {:else}
          Kritis
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
          Bisnis Sehat
        {:else if status === 'waspada'}
          Waspada
        {:else}
          Kritis
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
          Bisnis Sehat
        {:else if status === 'waspada'}
          Waspada
        {:else}
          Kritis
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
            out_7d.append(line)
            out_30d.append(line)
            out_y.append(line)

    markup_7d = "\n".join(out_7d)
    markup_30d = "\n".join(out_30d)
    markup_y = "\n".join(out_y)

    nav_y = """
<div class="evidence-tabs-container" style="margin-bottom: 24px;">
  <a href="/" class="tab-button active">📅 Kemarin</a>
  <a href="/7d" class="tab-button">📊 7 Hari</a>
  <a href="/30d" class="tab-button">🔭 30 Hari</a>
</div>
"""

    nav_7d = """
<div class="evidence-tabs-container" style="margin-bottom: 24px;">
  <a href="/" class="tab-button">📅 Kemarin</a>
  <a href="/7d" class="tab-button active">📊 7 Hari</a>
  <a href="/30d" class="tab-button">🔭 30 Hari</a>
</div>
"""

    nav_30d = """
<div class="evidence-tabs-container" style="margin-bottom: 24px;">
  <a href="/" class="tab-button">📅 Kemarin</a>
  <a href="/7d" class="tab-button">📊 7 Hari</a>
  <a href="/30d" class="tab-button active">🔭 30 Hari</a>
</div>
"""

    # Yesterday Page (index.md)
    content_y = f"{preamble}\n\n{style_content}\n\n" + "\n\n".join(sql_y) + "\n\n---\n\n_Data diperbarui otomatis setiap hari. Laporan berikut mencakup operasional **{tgl[0].nama_hari}, {tgl[0].tanggal_display}**._\n\n---\n\n" + nav_y + "\n\n" + markup_y
    with open("evidence/pages/index.md", "w") as out:
        out.write(content_y)

    # 7d Page (7d.md)
    content_7d = f"{preamble}\n\n{style_content}\n\n" + "\n\n".join(sql_7d) + "\n\n---\n\n_Data diperbarui otomatis setiap hari. Laporan berikut mencakup operasional **{tgl[0].nama_hari}, {tgl[0].tanggal_display}**._\n\n---\n\n" + nav_7d + "\n\n" + markup_7d
    with open("evidence/pages/7d.md", "w") as out:
        out.write(content_7d)

    # 30d Page (30d.md)
    content_30d = f"{preamble}\n\n{style_content}\n\n" + "\n\n".join(sql_30d) + "\n\n---\n\n_Data diperbarui otomatis setiap hari. Laporan berikut mencakup operasional **{tgl[0].nama_hari}, {tgl[0].tanggal_display}**._\n\n---\n\n" + nav_30d + "\n\n" + markup_30d
    with open("evidence/pages/30d.md", "w") as out:
        out.write(content_30d)

    print("Success! Split completed and files written to pages/ directory.")

if __name__ == "__main__":
    parse_and_split()

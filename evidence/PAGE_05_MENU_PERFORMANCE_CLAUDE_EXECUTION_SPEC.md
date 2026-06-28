# Claude Execution Spec: Rework Page 05 Menu Performance

This document is intended to be sent directly to Claude or another coding agent. It is a detailed implementation brief for reworking `evidence/pages/05-menu-performance.md` into a final **Menu Portfolio Cockpit**.

## 0. One-Sentence Goal

Rework `evidence/pages/05-menu-performance.md` from a report-style menu analysis page into a decision cockpit that helps a restaurant owner decide which menus to protect, promote, bundle/reprice, reformulate, or retire.

## 1. Repository Context

Project type:

- Evidence dashboard project.
- Main working directory for this task: `evidence/`.
- Target file: `evidence/pages/05-menu-performance.md`.

Primary reference page:

- `evidence/pages/01-laporan-keuangan.md`

Use page 01 as the strongest UI reference because it already has:

- local `<style>` block,
- `.over-container` hidden,
- page wrapper,
- `ButtonGroup`,
- period strip,
- hero cockpit,
- KPI grid,
- signal cards,
- section cards,
- strategic accordions,
- responsive behavior.

Other useful references:

- `evidence/pages/02-branch-performance.md` for portfolio cockpit and action framing.
- `evidence/pages/03-inventori-stok.md` for action queue and operational severity.
- `evidence/pages/04-peak-hours.md` for concise executive narrative and use of `{@const ...}`.

Do not edit these reference files unless explicitly asked:

- `evidence/pages/01-laporan-keuangan.md`
- `evidence/pages/02-branch-performance.md`
- `evidence/pages/03-inventori-stok.md`
- `evidence/pages/04-peak-hours.md`
- any `evidence_en/` directory if present.

## 2. Current Page Problem

Current `05-menu-performance.md` has useful analysis but weak decision hierarchy.

Current useful content:

- 30-day summary.
- top menu by volume.
- top menu by revenue.
- declining and rising alerts.
- category mix.
- price tier mix.
- menu reference table.
- hero menu by branch.
- menu engineering scatter plot.
- WoW table.
- 90-day declining trend.

Current problems:

- Page reads like a conventional report.
- Top summary uses `BigValue`; it does not establish a clear diagnosis.
- Menu engineering appears too late even though it is the strategic core.
- No central `menu_health_overview` query drives status and focus.
- No clear period switch for Kemarin / 7 Hari / 30 Hari.
- No top-level action queue.
- Too many sections are standalone reports rather than one cohesive management cockpit.

## 3. Product Intent

The page should answer these questions within the first screen or two:

1. Is the menu portfolio healthy?
2. Are we too dependent on a few menus?
3. Which menu is the revenue engine?
4. Which menu sells well but under-monetizes?
5. Which menu has high revenue potential but needs more visibility?
6. Which menu is declining and needs intervention?
7. Which action should management take next?

The page should not merely show "menu paling laku". It should recommend what to do with the portfolio.

## 4. Target User

Primary user:

- Restaurant owner, area manager, or operations manager.

They need:

- fast diagnosis,
- clear prioritization,
- business language,
- enough proof to trust the recommendation,
- but not a raw analyst report as the first experience.

Secondary user:

- Analyst or dashboard builder.

They need:

- detailed tables,
- methodology,
- classification definitions,
- caveats.

Therefore use 3 layers:

1. L1 cockpit: status, diagnosis, action.
2. L2 diagnostic evidence: key charts/tables.
3. L3 analyst detail: methodology and caveats in accordions.

## 5. Design Positioning

Final page name:

- `Performa Menu`

Final page concept:

- **Menu Portfolio Cockpit**

Suggested subtitle:

> Cockpit portofolio menu: mana yang harus dijaga, didorong, dinaikkan nilainya, atau dievaluasi.

Tone:

- Direct.
- Operational.
- Business-friendly.
- Avoid overexplaining in the top sections.
- Use Indonesian business terms already present in the project.

Key vocabulary:

- menu andalan,
- menu mulai turun,
- revenue terlalu terkonsentrasi,
- menu aktif,
- menu lemah,
- kandidat promo,
- kandidat bundling,
- kandidat naik harga,
- kandidat reformulasi,
- jaga stok,
- jaga kualitas.

Avoid:

- implying a menu should be removed based on one short-term decline alone,
- overusing finance language such as margin unless source has actual cost/margin,
- presenting revenue as profit.

## 6. Data Source Contract

Use only:

```sql
restaurant.menu_performance
```

Known columns used by the current page:

- `order_date`
- `branch_name`
- `menu_name`
- `category`
- `price_tier`
- `price`
- `total_qty_sold`
- `total_revenue`
- `qty_wow_change`

Important data rule:

- Anchor all date logic to `MAX(order_date)` from `restaurant.menu_performance`.
- Do not use `CURRENT_DATE`.
- "Kemarin" means latest available data date in the dataset, not necessarily calendar yesterday.

Category label mapping:

```sql
CASE category
    WHEN 'main'    THEN 'Menu Utama'
    WHEN 'drink'   THEN 'Minuman'
    WHEN 'snack'   THEN 'Camilan'
    WHEN 'dessert' THEN 'Dessert'
    WHEN 'side'    THEN 'Pendamping'
    ELSE category
END
```

## 7. File Scope

Edit:

- `evidence/pages/05-menu-performance.md`

Do not edit:

- other page files,
- source configuration,
- dbt files,
- generated build artifacts,
- package files.

The implementation can replace most of the existing file. Preserve useful analytical sections by reimplementing them in the new structure.

## 8. Final Page Structure

The final file should follow this order:

1. YAML frontmatter.
2. Short subtitle.
3. Local `<style>` block.
4. SQL queries.
5. `ButtonGroup name=period`.
6. Main guard.
7. `.menu-page` wrapper.
8. Page intro.
9. Period strip.
10. Active-period hero cockpit.
11. KPI grid.
12. Signal cards.
13. Menu Portfolio Map.
14. Revenue Drivers.
15. Category and Price Tier Mix.
16. Branch Playbook.
17. Movers and Declining Trend.
18. Action Queue.
19. Methodology accordions.
20. Empty state fallback.

Recommended render skeleton:

```svelte
---
title: Performa Menu
---

_Cockpit portofolio menu: mana yang harus dijaga, didorong, dinaikkan nilainya, atau dievaluasi._

<style>
/* local page styles */
</style>

```sql menu_dates
...
```

...

<ButtonGroup name=period>
  <ButtonGroupItem valueLabel="Kemarin" value="y" />
  <ButtonGroupItem valueLabel="7 Hari" value="7d" default />
  <ButtonGroupItem valueLabel="30 Hari" value="30d" />
</ButtonGroup>

{#if menu_health_overview.length > 0 && menu_dates.length > 0}
<div class="menu-page">
  ...
</div>
{:else}
<div class="section-card">
  <h3 class="section-title">Data menu belum tersedia.</h3>
  <p class="section-copy">Pastikan source restaurant.menu_performance sudah ter-refresh.</p>
</div>
{/if}
```

## 9. UI Style Requirements

Create a local style block in `05-menu-performance.md`.

Use page 01 style as the visual base, but rename classes where domain-specific.

### 9.1 Base Classes

Required:

- `.over-container`
- `details`
- `details > summary`
- `.acc-body`
- `details.acc-strategic`
- `.menu-page`
- `.page-intro`
- `.inline-link`

Behavior:

- Hide `.over-container`.
- `details` should be visually consistent with page 01.
- `.menu-page` should be flex column with gap around `24px`.
- `.page-intro` should be max width around `70ch`.

### 9.2 Period Strip

Required:

- `.period-strip`
- `.period-pill`
- `.period-pill.sehat`
- `.period-pill.waspada`
- `.period-pill.kritis`
- `.period-pill-label`
- `.period-pill-value`
- `.pill-badge`
- `.pill-badge.sehat`
- `.pill-badge.waspada`
- `.pill-badge.kritis`
- `.period-pill-copy`

Purpose:

- Compare Kemarin / 7 Hari / 30 Hari without forcing the user to switch periods.
- Each pill must show status, metric, and one-line interpretation.

Content per pill:

- Kemarin: status + declining count or top5 share.
- 7 Hari: status + active menus / top5 share.
- 30 Hari: status + active menus / portfolio health.

### 9.3 Hero

Required:

- `.hero`
- `.hero-eyebrow`
- `.hero-title`
- `.hero-copy`
- `.hero-side`
- `.hero-side-card`
- `.hero-side-label`
- `.hero-side-value`
- `.hero-side-note`

Hero purpose:

- Make the active-period diagnosis obvious.
- Explain the highest priority concern.
- Tell user what to do next.

Hero should change with `inputs.period`.

### 9.4 KPI Grid

Required:

- `.kpi-grid`
- `.kpi-card`
- `.kpi-card.volume`
- `.kpi-card.revenue`
- `.kpi-card.mix`
- `.kpi-card.alert`
- `.kpi-label`
- `.kpi-value`
- `.kpi-meta`

Recommended cards:

1. Total Revenue Menu.
2. Total Qty Terjual.
3. Menu Aktif.
4. Share Top 5 Menu.
5. Menu Turun.
6. Menu Naik.

If layout feels crowded, show 4 cards only:

1. Total Revenue.
2. Qty Terjual.
3. Menu Aktif.
4. Top 5 Share / Menu Turun.

### 9.5 Signal Cards

Required:

- `.signal-grid`
- `.signal-card`
- `.signal-card.safe`
- `.signal-card.warn`
- `.signal-card.critical`
- `.signal-card.neutral`
- `.signal-label`
- `.signal-title`
- `.signal-copy`

Recommended signal cards:

1. Apa yang sehat.
2. Yang perlu perhatian.
3. Aksi paling masuk akal.

Dynamic copy rules:

- If focus is `Konsentrasi revenue`: talk about dependency on top menus.
- If focus is `Menu menurun`: talk about checking stock, quality, branch concentration, and promo fatigue.
- If focus is `Menu lemah`: talk about simplifying or reformulating weak items.
- If healthy: talk about protecting stock and quality for hero menus.

### 9.6 Section Cards

Required:

- `.section-card`
- `.section-head`
- `.section-head.tight`
- `.section-eyebrow`
- `.section-title`
- `.section-copy`

Every major chart/table should be inside `.section-card`.

### 9.7 Menu Engineering Classes

Required:

- `.classification-grid`
- `.classification-card`
- `.classification-card.star`
- `.classification-card.mystery`
- `.classification-card.workhorse`
- `.classification-card.weak`
- `.classification-label`
- `.classification-title`
- `.classification-copy`

Classification labels:

- `Primadona`: volume tinggi, revenue tinggi.
- `Misteri`: volume rendah, revenue tinggi.
- `Pekerja Keras`: volume tinggi, revenue rendah.
- `Lemah`: volume rendah, revenue rendah.

### 9.8 Action Queue Classes

Required:

- `.action-stack`
- `.action-card`
- `.action-card.critical`
- `.action-card.high`
- `.action-card.moderate`
- `.action-card.low`
- `.action-header`
- `.action-severity`
- `.action-badge`
- `.action-title`
- `.action-impact`
- `.action-rec`

Action queue should be compact. Maximum 6 cards.

### 9.9 Responsive Rules

Add:

```css
@media (max-width: 900px) {
  .period-strip,
  .kpi-grid,
  .signal-grid,
  .classification-grid {
    grid-template-columns: 1fr;
  }

  .hero {
    grid-template-columns: 1fr;
  }
}
```

Also ensure:

- no chart text overlaps on mobile,
- no nested cards inside cards,
- no overly wide fixed-width layout,
- tables can scroll naturally if needed.

## 10. SQL Query Contract

Use these query names unless there is a strong reason to split or rename:

1. `menu_dates`
2. `menu_health_period`
3. `menu_health_overview`
4. `menu_kpi_period`
5. `menu_engineering_period`
6. `menu_movers_period`
7. `category_mix_period`
8. `price_tier_mix_period`
9. `branch_menu_playbook`
10. `declining_trend_90d`
11. `declining_by_branch`
12. `menu_action_queue`

If Evidence build fails because a query is too complex, split it into smaller named queries. Keep render contract the same.

### 10.1 `menu_dates`

Purpose:

- Date labels for period strip and hero side card.

Expected columns:

- `tgl_akhir`
- `tgl_7_awal`
- `tgl_30_awal`
- `tgl_90_awal`

Template:

```sql
SELECT
    strftime('%d %b %Y', MAX(order_date)) AS tgl_akhir,
    strftime('%d %b %Y', MAX(order_date) - INTERVAL '6 days') AS tgl_7_awal,
    strftime('%d %b %Y', MAX(order_date) - INTERVAL '29 days') AS tgl_30_awal,
    strftime('%d %b %Y', MAX(order_date) - INTERVAL '89 days') AS tgl_90_awal
FROM restaurant.menu_performance
```

### 10.2 Shared Period Logic

Use this conceptual period table in multiple queries:

```sql
WITH max_d AS (
    SELECT MAX(order_date) AS d
    FROM restaurant.menu_performance
),
periods AS (
    SELECT 'y' AS period, d AS start_date, d AS end_date,
           d - INTERVAL '7 days' AS prev_start, d - INTERVAL '7 days' AS prev_end
    FROM max_d
    UNION ALL
    SELECT '7d', d - INTERVAL '6 days', d,
           d - INTERVAL '13 days', d - INTERVAL '7 days'
    FROM max_d
    UNION ALL
    SELECT '30d', d - INTERVAL '29 days', d,
           d - INTERVAL '59 days', d - INTERVAL '30 days'
    FROM max_d
)
```

Meaning:

- `y`: latest data date compared to same weekday one week earlier.
- `7d`: last 7 days compared to prior 7 days.
- `30d`: last 30 days compared to prior 30 days.

### 10.3 `menu_health_period`

Purpose:

- One row per period with health status and core diagnostic fields.

Expected columns:

- `period`
- `status`
- `focus`
- `active_menu_count`
- `total_qty`
- `total_revenue`
- `top5_revenue_share`
- `declining_count`
- `rising_count`
- `weak_count`
- `workhorse_count`
- `mystery_count`
- `star_count`
- `top_volume_menu`
- `top_revenue_menu`
- `top_volume_qty`
- `top_revenue_value`

Definitions:

- Active menu: menu with `SUM(total_qty_sold) > 0` in the period.
- Top 5 revenue share: revenue from top 5 menus divided by total period menu revenue.
- Declining menu: qty current vs previous period <= -20%.
- Rising menu: qty current vs previous period >= +20%.
- Classification is based on period medians of total qty and total revenue.

Status rules:

- `Kritis` if:
  - `top5_revenue_share >= 70`, or
  - `declining_count >= 5`, or
  - `weak_count / active_menu_count >= 0.40`
- `Waspada` if:
  - `top5_revenue_share >= 55`, or
  - `declining_count >= 2`, or
  - `weak_count / active_menu_count >= 0.25`
- `Sehat` otherwise.

Focus rules:

- `Konsentrasi revenue` if top5 share is the strongest concern.
- `Menu menurun` if declining count is the strongest concern.
- `Menu lemah` if weak menu ratio is the strongest concern.
- `Portofolio sehat` otherwise.

Implementation note:

- Do not use aggregate window functions directly on grouped expressions if DuckDB/Evidence complains.
- Safer pattern:
  1. `menu_period_agg`: aggregate per period/menu.
  2. `menu_period_with_median`: compute medians over aggregated rows.
  3. `classified`: assign classification.
  4. `ranked`: rank by revenue and qty.
  5. `movers`: join current vs previous period.
  6. final aggregate by period.

### 10.4 `menu_health_overview`

Purpose:

- Pivot `menu_health_period` into one row for easy period strip markup.

Expected columns:

- `status_y`, `focus_y`, `active_y`, `top5_share_y`, `declining_y`, `rising_y`, `weak_y`, `top_volume_menu_y`, `top_revenue_menu_y`
- `status_7d`, `focus_7d`, `active_7d`, `top5_share_7d`, `declining_7d`, `rising_7d`, `weak_7d`, `top_volume_menu_7d`, `top_revenue_menu_7d`
- `status_30d`, `focus_30d`, `active_30d`, `top5_share_30d`, `declining_30d`, `rising_30d`, `weak_30d`, `top_volume_menu_30d`, `top_revenue_menu_30d`

Template:

```sql
SELECT
    MAX(CASE WHEN period = 'y' THEN status END) AS status_y,
    MAX(CASE WHEN period = 'y' THEN focus END) AS focus_y,
    MAX(CASE WHEN period = 'y' THEN active_menu_count END) AS active_y,
    MAX(CASE WHEN period = 'y' THEN top5_revenue_share END) AS top5_share_y,
    MAX(CASE WHEN period = 'y' THEN declining_count END) AS declining_y,
    MAX(CASE WHEN period = 'y' THEN rising_count END) AS rising_y,
    MAX(CASE WHEN period = 'y' THEN weak_count END) AS weak_y,
    MAX(CASE WHEN period = 'y' THEN top_volume_menu END) AS top_volume_menu_y,
    MAX(CASE WHEN period = 'y' THEN top_revenue_menu END) AS top_revenue_menu_y,

    MAX(CASE WHEN period = '7d' THEN status END) AS status_7d,
    MAX(CASE WHEN period = '7d' THEN focus END) AS focus_7d,
    MAX(CASE WHEN period = '7d' THEN active_menu_count END) AS active_7d,
    MAX(CASE WHEN period = '7d' THEN top5_revenue_share END) AS top5_share_7d,
    MAX(CASE WHEN period = '7d' THEN declining_count END) AS declining_7d,
    MAX(CASE WHEN period = '7d' THEN rising_count END) AS rising_7d,
    MAX(CASE WHEN period = '7d' THEN weak_count END) AS weak_7d,
    MAX(CASE WHEN period = '7d' THEN top_volume_menu END) AS top_volume_menu_7d,
    MAX(CASE WHEN period = '7d' THEN top_revenue_menu END) AS top_revenue_menu_7d,

    MAX(CASE WHEN period = '30d' THEN status END) AS status_30d,
    MAX(CASE WHEN period = '30d' THEN focus END) AS focus_30d,
    MAX(CASE WHEN period = '30d' THEN active_menu_count END) AS active_30d,
    MAX(CASE WHEN period = '30d' THEN top5_revenue_share END) AS top5_share_30d,
    MAX(CASE WHEN period = '30d' THEN declining_count END) AS declining_30d,
    MAX(CASE WHEN period = '30d' THEN rising_count END) AS rising_30d,
    MAX(CASE WHEN period = '30d' THEN weak_count END) AS weak_30d,
    MAX(CASE WHEN period = '30d' THEN top_volume_menu END) AS top_volume_menu_30d,
    MAX(CASE WHEN period = '30d' THEN top_revenue_menu END) AS top_revenue_menu_30d
FROM menu_health_period
```

If Evidence cannot reference another query by name in SQL, duplicate the CTE logic or build only `menu_health_overview` directly.

### 10.5 `menu_kpi_period`

Purpose:

- Feed KPI grid and active period summary.

Expected columns:

- `period`
- `total_qty`
- `total_revenue`
- `active_menu_count`
- `avg_revenue_per_menu`
- `top_volume_menu`
- `top_volume_qty`
- `top_revenue_menu`
- `top_revenue_value`
- `top5_revenue_share`
- `declining_count`
- `rising_count`

Can reuse the same CTE logic as `menu_health_period`.

### 10.6 `menu_engineering_period`

Purpose:

- Feed scatter plot and menu engineering table.

Expected columns:

- `period`
- `menu_name`
- `category`
- `price_tier`
- `total_qty`
- `total_revenue`
- `avg_price_realisasi`
- `klasifikasi`

Classification:

- `Primadona`: qty >= period median qty and revenue >= period median revenue.
- `Pekerja Keras`: qty >= median qty and revenue < median revenue.
- `Misteri`: qty < median qty and revenue >= median revenue.
- `Lemah`: qty < median qty and revenue < median revenue.

Important:

- Use period-specific medians.
- Do not use one global median across all periods.

### 10.7 `menu_movers_period`

Purpose:

- Feed movers table, signal cards, and action queue.

Expected columns:

- `period`
- `menu_name`
- `category`
- `qty_current`
- `qty_previous`
- `pct_change_qty`
- `revenue_current`
- `revenue_previous`
- `pct_change_revenue`
- `movement_status`

Movement logic:

- `Baru` if previous qty is null/0 and current qty > 0.
- `Tidak Aktif` if current qty is null/0 and previous qty > 0.
- `Turun` if `pct_change_qty <= -20`.
- `Naik` if `pct_change_qty >= 20`.
- `Stabil` otherwise.

Use `NULLIF(previous_qty, 0)` to avoid divide-by-zero.

### 10.8 `category_mix_period`

Purpose:

- Feed category mix chart and table.

Expected columns:

- `period`
- `category`
- `total_menu`
- `total_qty`
- `total_revenue`
- `avg_price_realisasi`
- `pct_revenue`

### 10.9 `price_tier_mix_period`

Purpose:

- Feed price tier mix chart and table.

Expected columns:

- `period`
- `price_tier`
- `total_menu`
- `total_qty`
- `total_revenue`
- `pct_revenue`

### 10.10 `branch_menu_playbook`

Purpose:

- Replace existing "Andalan per Cabang" with period-aware operational playbook.

Expected columns:

- `period`
- `branch_name`
- `top_volume_menu`
- `top_volume_qty`
- `top_revenue_menu`
- `top_revenue_value`
- `recommended_focus`

Recommended focus:

```sql
CASE
  WHEN top_volume_menu = top_revenue_menu THEN 'Jaga stok dan kualitas menu andalan'
  ELSE 'Pisahkan strategi stok dan upsell'
END
```

### 10.11 `declining_trend_90d`

Purpose:

- Preserve existing 90-day declining line chart.

Definition:

- A menu is structurally declining if last 30 days qty is lower than the first 30 days inside the 90-day window.

Wording in UI must clarify this:

> Menu dianggap menurun jika total 30 hari terakhir lebih rendah dari total 30 hari awal dalam window 90 hari.

### 10.12 `declining_by_branch`

Purpose:

- Preserve branch-level decline diagnostic.

Expected columns:

- `branch_name`
- `menu_name`
- `qty_30_awal`
- `qty_30_akhir`
- `pct_change`

### 10.13 `menu_action_queue`

Purpose:

- Feed compact action cards.

Expected columns:

- `priority`
- `severity`
- `action_type`
- `menu_name`
- `category`
- `metric_value`
- `impact_text`
- `recommended_action`

Max rows:

- 6

Action source priority:

1. Declining menu:
   - `Kritis` if qty change <= -40%.
   - `Tinggi` if qty change <= -20%.
   - Action: check stock availability, quality consistency, promo fatigue, and branch concentration.
2. `Pekerja Keras`:
   - high volume, lower revenue.
   - Action: test bundle, add-on, or small price increase.
3. `Misteri`:
   - high revenue, lower volume.
   - Action: improve visibility, staff recommendation, menu placement.
4. `Lemah`:
   - low volume, low revenue.
   - Action: reformulate, reposition, or consider removing after validation.
5. Revenue concentration:
   - if top5 share > 55 or 70.
   - Action: push second-tier menu, bundles, and cross-sell.

Keep action language concrete.

Example action:

> Ayam Penyet turun -28% qty vs periode sebelumnya. Cek apakah penurunan terjadi di semua cabang atau hanya cabang tertentu. Jika menyebar, uji promo atau bundling; jika lokal, audit stok dan kualitas cabang tersebut.

## 11. Rendering Contract

### 11.1 Main Guard

Do not access `[0]` before the main guard.

Use:

```svelte
{#if menu_health_overview.length > 0 && menu_dates.length > 0}
  ...
{:else}
  ...
{/if}
```

Inside the guard, define active constants using `{@const}`. This project already uses `{@const}` in `pages/04-peak-hours.md`, so it is acceptable.

Example:

```svelte
{@const activeStatus = inputs.period === 'y'
  ? menu_health_overview[0].status_y
  : inputs.period === '30d'
    ? menu_health_overview[0].status_30d
    : menu_health_overview[0].status_7d}
```

Define similar constants for:

- `activeFocus`
- `activeMenuCount`
- `activeTop5Share`
- `activeDeclining`
- `activeRising`
- `activeTopVolume`
- `activeTopRevenue`

For active rows from period queries, prefer:

```svelte
{@const activeKpi = menu_kpi_period.find(r => r.period === inputs.period) ?? menu_kpi_period.find(r => r.period === '7d')}
```

Then guard usage if needed:

```svelte
{#if activeKpi}
  ...
{/if}
```

### 11.2 ButtonGroup

Use:

```svelte
<ButtonGroup name=period>
  <ButtonGroupItem valueLabel="Kemarin" value="y" />
  <ButtonGroupItem valueLabel="7 Hari" value="7d" default />
  <ButtonGroupItem valueLabel="30 Hari" value="30d" />
</ButtonGroup>
```

### 11.3 Period Strip

Each pill:

- label,
- status badge,
- core metric,
- one-line interpretation.

Example:

```svelte
<div class="period-pill {menu_health_overview[0].status_7d === 'Sehat' ? 'sehat' : menu_health_overview[0].status_7d === 'Waspada' ? 'waspada' : 'kritis'}">
  <div class="period-pill-label">7 Hari · {menu_dates[0].tgl_7_awal}-{menu_dates[0].tgl_akhir}</div>
  <div class="period-pill-value">
    <span class="pill-badge ...">{menu_health_overview[0].status_7d}</span>
    Top 5: {menu_health_overview[0].top5_share_7d}%
  </div>
  <div class="period-pill-copy">
    {menu_health_overview[0].declining_7d} menu turun, {menu_health_overview[0].active_7d} menu aktif.
  </div>
</div>
```

### 11.4 Hero

Hero headline logic:

If active status is `Kritis` and focus is `Konsentrasi revenue`:

> Revenue menu terlalu terkonsentrasi: top 5 menu menyumbang {activeTop5Share}% dari revenue.

If active status is `Kritis` and focus is `Menu menurun`:

> {activeDeclining} menu turun tajam; portofolio butuh tindakan minggu ini.

If active status is `Kritis` and focus is `Menu lemah`:

> Terlalu banyak menu lemah; portofolio perlu disederhanakan.

If `Waspada`:

> Portofolio menu masih berjalan, tapi ada sinyal yang perlu diawasi.

If `Sehat`:

> Portofolio menu sehat; fokus utama adalah menjaga stok dan momentum menu andalan.

Hero side cards:

1. Periode aktif.
2. Top volume vs top revenue menu.

### 11.5 KPI Grid

Show:

- Total revenue.
- Total qty.
- Active menu count.
- Top 5 share.
- Declining count.
- Rising count.

Formatting:

```svelte
Rp {(activeKpi.total_revenue ?? 0).toLocaleString('id-ID', { maximumFractionDigits: 0 })}
```

### 11.6 Signal Cards

Use 3 cards:

1. `Apa yang sehat`
2. `Yang perlu perhatian`
3. `Aksi berikutnya`

Signal copy should be concise: 2-3 sentences max per card.

### 11.7 Menu Portfolio Map

This must appear before category, branch, and long trend sections.

Components:

- Classification explanation grid.
- Scatter plot.
- Data table.

Data:

- Use `menu_engineering_period` filtered to active period.

If component prop filtering works:

```svelte
<ScatterPlot data={menu_engineering_period.filter(r => r.period === inputs.period)} ... />
```

If build fails, use explicit period branches:

```svelte
{#if inputs.period === 'y'}
  <ScatterPlot data={menu_engineering_y} ... />
{:else if inputs.period === '30d'}
  <ScatterPlot data={menu_engineering_30d} ... />
{:else}
  <ScatterPlot data={menu_engineering_7d} ... />
{/if}
```

The current project uses `.filter(...)` in markup but not necessarily inside all chart props. Prefer maintainability, then adjust if build complains.

### 11.8 Revenue Drivers

Use two charts:

- Top menu by volume.
- Top menu by revenue.

Use active period data.

Add interpretation:

- If same top menu: stocking and quality priority are aligned.
- If different: stock strategy and upsell strategy should be separated.

### 11.9 Category and Price Tier Mix

Use:

- category chart,
- price tier chart,
- category table,
- price tier table.

Add one insight:

- If top category > 70% revenue: category concentration warning.
- Else: mix is reasonably balanced.

### 11.10 Branch Playbook

Use `branch_menu_playbook`.

Context copy:

> Cabang dengan menu volume dan menu revenue yang berbeda butuh playbook berbeda: stok mengikuti volume, upsell mengikuti menu revenue.

Table columns:

- Cabang.
- Menu paling laku.
- Qty.
- Menu revenue terbesar.
- Revenue.
- Fokus.

### 11.11 Movers and Declining Trend

Use:

- `menu_movers_period` table for active period.
- `declining_trend_90d` line chart.
- `declining_by_branch` table.

Make wording precise:

- Period movers are short/mid-term signals.
- 90-day trend is structural.
- Do not recommend deleting a menu from 1-week signal alone.

### 11.12 Action Queue

Place before methodology accordions.

Use `menu_action_queue`.

Render:

```svelte
{#if menu_action_queue.length > 0}
  <div class="section-card">
    <div class="section-head">
      <div>
        <div class="section-eyebrow">Pusat Aksi</div>
        <h3 class="section-title">Tindakan menu yang paling masuk akal sekarang</h3>
        <p class="section-copy">Urut dari risiko tertinggi berdasarkan penurunan, konsentrasi revenue, dan klasifikasi menu.</p>
      </div>
    </div>
    <div class="action-stack">
      {#each menu_action_queue as action}
        <div class="action-card {action.severity === 'Kritis' ? 'critical' : action.severity === 'Tinggi' ? 'high' : action.severity === 'Sedang' ? 'moderate' : 'low'}">
          ...
        </div>
      {/each}
    </div>
  </div>
{:else}
  <div class="section-card">
    <h3 class="section-title">Belum ada aksi menu prioritas.</h3>
    <p class="section-copy">Portofolio menu tidak menunjukkan alarm besar pada periode aktif.</p>
  </div>
{/if}
```

### 11.13 Methodology Accordions

Add two accordions:

1. `Cara membaca klasifikasi menu`
2. `Catatan sebelum mengambil keputusan menu`

Accordion 1 content:

- Primadona: volume tinggi, revenue tinggi. Protect stock and quality.
- Misteri: revenue tinggi, volume rendah. Improve visibility and staff recommendation.
- Pekerja Keras: volume tinggi, revenue rendah. Bundle, add-on, price test.
- Lemah: volume rendah, revenue rendah. Reformulate, reposition, or remove after validation.

Accordion 2 content:

- One-week decline does not automatically mean remove menu.
- Check stock availability and branch concentration first.
- Revenue is not margin.
- If ingredient cost exists elsewhere, connect with inventory/finance before final pricing decisions.
- "Kemarin" means latest available data date.

## 12. Content to Remove or Replace

Remove/replace:

- Old top `BigValue` summary.
- Old top inline alerts.
- Old free-floating headings without section cards.
- Old isolated `tip` tooltip style if not reused.

Keep/rebuild:

- top volume vs top revenue,
- category mix,
- price tier mix,
- branch hero menu,
- menu engineering,
- WoW/movers,
- 90-day decline trend.

## 13. Evidence Syntax Notes

This repo already uses:

- Svelte `{#if}` blocks.
- Svelte `{#each}` loops.
- Svelte `{@const ...}` in `pages/04-peak-hours.md`.
- Evidence core components:
  - `ButtonGroup`
  - `ButtonGroupItem`
  - `BarChart`
  - `LineChart`
  - `ScatterPlot`
  - `DataTable`
  - `Column`
  - `ReferenceArea`
  - `ReferenceLine`

Prefer simple, buildable Svelte over clever abstraction.

Avoid:

- complex inline ternary chains repeated many times,
- unguarded `[0]`,
- accessing properties on undefined active rows,
- relying on `CURRENT_DATE`,
- adding external libraries.

## 14. Visual Quality Rules

The final page should feel like a business cockpit, not a marketing page.

Use:

- compact cards,
- restrained colors,
- status badges,
- section cards,
- direct labels,
- responsive grids.

Avoid:

- oversized hero marketing layout,
- decorative backgrounds,
- nested cards inside cards,
- long prose blocks at top,
- too many emojis in one area,
- chart overload.

Emoji policy:

- Existing project uses emojis in labels, so they are acceptable.
- Use them sparingly in section eyebrows and status labels.
- Do not depend on emoji alone for meaning; always include text.

## 15. Implementation Sequence

Recommended steps:

1. Open `evidence/pages/01-laporan-keuangan.md` and inspect style patterns.
2. Open current `evidence/pages/05-menu-performance.md`.
3. Replace the local style block with the new cockpit style.
4. Replace old SQL with new query set.
5. Add `ButtonGroup name=period`.
6. Add main guard.
7. Build `.menu-page`.
8. Build period strip.
9. Build active hero.
10. Build KPI grid.
11. Build signal cards.
12. Build Menu Portfolio Map.
13. Build Revenue Drivers.
14. Build Category and Price Tier Mix.
15. Build Branch Playbook.
16. Build Movers and Declining Trend.
17. Build Action Queue.
18. Build methodology accordions.
19. Run build.
20. Fix Evidence/Svelte/SQL errors.

## 16. Build and Verification

From `evidence/`:

```bash
npm run build
```

Expected:

- Build succeeds.
- No Svelte syntax errors.
- No DuckDB SQL errors.
- No component prop errors.

If build fails:

1. Fix SQL first.
2. Fix unguarded undefined values.
3. If chart data filtering fails, split period-specific chart queries or render branches.
4. If a CTE is too complex, split into simpler queries.

Do not stop after writing code without running build unless environment prevents it.

## 17. Acceptance Criteria

Implementation is complete when:

1. `npm run build` succeeds from `evidence/`.
2. `05-menu-performance.md` has period switch for `Kemarin`, `7 Hari`, `30 Hari`.
3. Page top includes:
   - period strip,
   - hero cockpit,
   - KPI grid,
   - signal cards.
4. Menu engineering appears near the top, before category/branch/trend details.
5. Action queue exists and shows concrete menu recommendations.
6. Existing useful analysis is preserved or replaced:
   - top volume vs top revenue,
   - category mix,
   - price tier mix,
   - branch-specific top menus,
   - menu engineering,
   - period movers,
   - 90-day declining trend.
7. Date logic uses max available menu date.
8. There are no unguarded top-level `[0]` references.
9. Page visually aligns with `01-laporan-keuangan.md`.
10. Page reads as a decision cockpit, not a raw report.

## 18. Non-Goals

Do not:

- redesign the whole dashboard,
- edit `index.md`,
- edit other pages,
- add new datasource,
- add external dependencies,
- change dbt models,
- change package versions,
- implement margin if actual menu cost/margin is unavailable.

## 19. Final Quality Target

Target score after rework:

- 8.8 to 9.0 out of 10.

Most important outcome:

> A restaurant owner can open the page and immediately know which menu items to protect, promote, bundle/reprice, reformulate, or investigate.

## 20. Suggested Final Copy Blocks

Use these as copy inspiration, not mandatory exact text.

Hero healthy:

> Portofolio menu sehat; fokus utama adalah menjaga stok dan kualitas menu andalan.

Hero concentration:

> Revenue menu terlalu terkonsentrasi. Top 5 menu menyumbang {share}% dari revenue, sehingga gangguan pada menu andalan bisa langsung memukul penjualan.

Hero declining:

> {count} menu turun tajam pada periode ini. Sebelum memutuskan promo atau penghapusan, cek dulu apakah penurunan terjadi di semua cabang atau hanya cabang tertentu.

Hero weak:

> Terlalu banyak menu lemah. Beberapa item menghabiskan ruang menu dan kompleksitas stok tanpa memberi kontribusi cukup.

Menu engineering intro:

> Peta ini memisahkan menu berdasarkan volume dan revenue. Tujuannya bukan sekadar ranking, tetapi menentukan perlakuan: jaga, dorong, monetisasi, atau evaluasi.

Branch playbook intro:

> Cabang dengan menu volume dan menu revenue yang berbeda butuh playbook berbeda: stok mengikuti volume, upsell mengikuti menu revenue.

Action queue intro:

> Urutan aksi ini menggabungkan sinyal penurunan, konsentrasi revenue, dan klasifikasi menu. Gunakan sebagai daftar kerja sebelum mengubah harga, promo, atau komposisi menu.


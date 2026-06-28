# Technical Design: Rework Page 05 Menu Performance

Target file to edit:

- `evidence/pages/05-menu-performance.md`

Do not edit:

- `evidence_en/`
- `evidence/pages/01-laporan-keuangan.md`
- `evidence/pages/02-branch-performance.md`
- `evidence/pages/03-inventori-stok.md`
- `evidence/pages/04-peak-hours.md`

Use `evidence/pages/01-laporan-keuangan.md` as the primary UI and interaction reference. Pages `02`, `03`, and `04` are in progress and intentionally moving toward the same pattern.

## Objective

Rework `05-menu-performance.md` from a conventional report into a **Menu Portfolio Cockpit** that matches the visual and decision-making style of `01-laporan-keuangan.md`.

The page should answer these questions quickly:

1. Is the menu portfolio healthy right now?
2. Which menu items drive revenue?
3. Which menu items sell well but under-monetize?
4. Which menu items are declining and need intervention?
5. Are we too dependent on a small set of menu items or categories?
6. What concrete actions should management take next?

Keep the page tighter than `02`, `03`, and `04`. This page should be rich but still maintainable. Target length is roughly 900-1200 lines, not 2000+ lines.

## Current State

The current `05-menu-performance.md` already has useful analytical content:

- 30-day menu summary
- top menu by volume
- top menu by revenue
- declining and rising alerts
- category and price tier contribution
- branch-level hero menu table
- menu engineering scatter plot
- week-over-week table
- 90-day declining trend

The problem is mostly presentation and decision hierarchy:

- It uses simple headings and `BigValue` components instead of the custom cockpit style used in page `01`.
- It reads like a report, not a decision dashboard.
- Menu engineering appears too late, even though it is the most strategic section.
- There is no single `menu_health_overview` query that centralizes status, severity, and focus.
- There is no explicit period switch like page `01`.
- There is no top-level action queue.

## Design Principles

Follow these principles:

1. Match page `01` layout language:
   - hide `.over-container`
   - custom page wrapper
   - `ButtonGroup name=period`
   - period strip
   - hero cockpit
   - KPI grid
   - signal cards
   - section cards
   - accordions for methodology and action explanation

2. Do not blindly copy finance wording.
   Page 05 should be about **menu portfolio management**, not finance margin.

3. Keep business language clear and direct:
   - "menu andalan"
   - "menu mulai turun"
   - "revenue terlalu terkonsentrasi"
   - "perlu promo"
   - "perlu stok aman"
   - "kandidat bundling / naik harga / reformulasi / hapus menu"

4. Avoid overbuilding.
   Page 05 should stay easier to scan than `02`, `03`, and `04`.

5. Make empty states safe.
   Guard all rendered blocks with `.length > 0` before using `[0]`.

6. Use existing source table:
   - `restaurant.menu_performance`

## Final Page Structure

Recommended final render order:

1. YAML frontmatter
2. `<style>` block
3. Shared SQL
4. `ButtonGroup name=period`
5. Main guard: `{#if menu_health_overview.length > 0}`
6. `.menu-page` wrapper
7. Page intro
8. Period strip: Kemarin, 7 Hari, 30 Hari
9. Active period hero cockpit
10. KPI grid for active period
11. Signal cards
12. Section: Menu Portfolio Map
13. Section: Revenue Drivers
14. Section: Category and Price Tier Mix
15. Section: Branch Playbook
16. Section: Trend and Declining Menus
17. Section: Action Queue
18. Accordions: methodology, classification definitions, data caveats
19. Empty-state fallback if no data

## UI Classes To Implement

Create a local `<style>` block in `05-menu-performance.md`. It should be structurally similar to page `01`, but use `menu-` naming where useful.

Required class groups:

### Base

- `.over-container`
- `details`
- `details > summary`
- `.acc-body`
- `details.acc-strategic`
- `.menu-page`
- `.page-intro`
- `.inline-link`

### Period Strip

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

Use the same visual treatment as page `01`.

### Hero

- `.hero`
- `.hero-eyebrow`
- `.hero-title`
- `.hero-copy`
- `.hero-side`
- `.hero-side-card`
- `.hero-side-label`
- `.hero-side-value`
- `.hero-side-note`

Use page `01` as the exact visual reference.

### KPI Grid

- `.kpi-grid`
- `.kpi-card`
- `.kpi-card.volume`
- `.kpi-card.revenue`
- `.kpi-card.mix`
- `.kpi-card.alert`
- `.kpi-label`
- `.kpi-value`
- `.kpi-meta`

The card styles can follow page `01`, but the class names should map to menu concepts.

### Signal Cards

- `.signal-grid`
- `.signal-card`
- `.signal-card.safe`
- `.signal-card.warn`
- `.signal-card.critical`
- `.signal-card.neutral`
- `.signal-label`
- `.signal-title`
- `.signal-copy`

### Section Cards

- `.section-card`
- `.section-head`
- `.section-head.tight`
- `.section-eyebrow`
- `.section-title`
- `.section-copy`

### Menu Engineering / Portfolio

Add a small grid explaining the four classifications:

- `.classification-grid`
- `.classification-card`
- `.classification-card.star`
- `.classification-card.mystery`
- `.classification-card.workhorse`
- `.classification-card.weak`
- `.classification-label`
- `.classification-title`
- `.classification-copy`

### Action Queue

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
- `.action-acc`

Keep this lighter than page `03`. Page 05 only needs a compact action queue.

### Responsive Behavior

Add responsive rules:

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

Use page `01` responsive conventions if it has additional relevant rules.

## New SQL Queries

Prefer one central health query plus several supporting queries.

### 1. `menu_dates`

Purpose:

- Display date ranges for yesterday/data terakhir, 7 days, and 30 days.
- Use `MAX(order_date)` from `restaurant.menu_performance`, not `CURRENT_DATE`.

Suggested SQL:

```sql
SELECT
    strftime('%d %b %Y', MAX(order_date)) AS tgl_akhir,
    strftime('%d %b %Y', MAX(order_date) - INTERVAL '6 days') AS tgl_7_awal,
    strftime('%d %b %Y', MAX(order_date) - INTERVAL '29 days') AS tgl_30_awal
FROM restaurant.menu_performance
```

### 2. `menu_health_overview`

Purpose:

- Central status query, similar in spirit to `fin_operational_overview`.
- Return status and focus for y, 7d, and 30d.
- This should drive the period strip and hero copy.

Recommended business rules:

- `declining_count`: menu items with quantity down more than 20% vs previous comparable period.
- `rising_count`: menu items with quantity up more than 20% vs previous comparable period.
- `top5_revenue_share`: percent of revenue from the top 5 menu items.
- `active_menu_count`: number of active menu items.
- `weak_count`: menu engineering classification `Lemah`.
- `workhorse_count`: classification `Pekerja Keras`.
- `mystery_count`: classification `Misteri`.
- `star_count`: classification `Primadona`.

Status logic:

- `Kritis` if:
  - top 5 revenue share >= 70, or
  - declining_count >= 5, or
  - weak_count >= 40% of active_menu_count

- `Waspada` if:
  - top 5 revenue share >= 55, or
  - declining_count >= 2, or
  - weak_count >= 25% of active_menu_count

- `Sehat` otherwise.

Focus logic:

- `Menu menurun` if declining_count is the dominant concern.
- `Konsentrasi revenue` if top5_revenue_share is the dominant concern.
- `Menu lemah` if weak_count ratio is the dominant concern.
- `Portofolio sehat` if no major concern.

Implementation hint:

For maintainability, use CTEs for each period:

- `periods` with rows:
  - `y`: start = max_date, end = max_date, prev_start = max_date - 7 days, prev_end = max_date - 7 days
  - `7d`: start = max_date - 6 days, end = max_date, prev_start = max_date - 13 days, prev_end = max_date - 7 days
  - `30d`: start = max_date - 29 days, end = max_date, prev_start = max_date - 59 days, prev_end = max_date - 30 days

Then aggregate by period and pivot to one row:

Expected output columns:

- `status_y`
- `focus_y`
- `declining_y`
- `rising_y`
- `active_y`
- `top5_share_y`
- `weak_y`
- `workhorse_y`
- `mystery_y`
- `star_y`
- `top_volume_menu_y`
- `top_revenue_menu_y`
- `status_7d`
- `focus_7d`
- `declining_7d`
- `rising_7d`
- `active_7d`
- `top5_share_7d`
- `weak_7d`
- `workhorse_7d`
- `mystery_7d`
- `star_7d`
- `top_volume_menu_7d`
- `top_revenue_menu_7d`
- `status_30d`
- `focus_30d`
- `declining_30d`
- `rising_30d`
- `active_30d`
- `top5_share_30d`
- `weak_30d`
- `workhorse_30d`
- `mystery_30d`
- `star_30d`
- `top_volume_menu_30d`
- `top_revenue_menu_30d`

If this query becomes too complex, split it into:

- `menu_health_by_period`
- `menu_health_overview`

But keep final rendering simple.

### 3. `menu_kpi_period`

Purpose:

- Active-period KPI grid.
- Can return one row per period, then UI filters with `inputs.period`.

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

### 4. `menu_engineering_period`

Purpose:

- Use active period for scatter plot and classification table.
- Return one row per menu per period.

Expected columns:

- `period`
- `menu_name`
- `category`
- `total_qty`
- `total_revenue`
- `avg_price_realisasi`
- `klasifikasi`

Classification rules:

- `Primadona`: quantity >= median quantity and revenue >= median revenue
- `Pekerja Keras`: quantity >= median quantity and revenue < median revenue
- `Misteri`: quantity < median quantity and revenue >= median revenue
- `Lemah`: quantity < median quantity and revenue < median revenue

Use period-aware medians, not global medians across all periods.

### 5. `menu_movers_period`

Purpose:

- Week-over-week / period-over-period movers.
- Feed the trend/action sections.

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
- `movement_status`: `Naik`, `Turun`, `Stabil`, `Baru`, `Tidak Aktif`

Business logic:

- `Turun` if `pct_change_qty <= -20`
- `Naik` if `pct_change_qty >= 20`
- `Stabil` otherwise
- `Baru` if previous qty is null/0 and current qty > 0
- `Tidak Aktif` if current qty is null/0 and previous qty > 0

### 6. `category_mix_period`

Purpose:

- Revenue and quantity by category for active period.

Expected columns:

- `period`
- `category`
- `total_menu`
- `total_qty`
- `total_revenue`
- `avg_price_realisasi`
- `pct_revenue`

### 7. `price_tier_mix_period`

Purpose:

- Revenue and quantity by price tier for active period.

Expected columns:

- `period`
- `price_tier`
- `total_menu`
- `total_qty`
- `total_revenue`
- `pct_revenue`

### 8. `branch_menu_playbook`

Purpose:

- Keep existing "Andalan per Cabang", but make it period-aware.

Expected columns:

- `period`
- `branch_name`
- `top_volume_menu`
- `top_volume_qty`
- `top_revenue_menu`
- `top_revenue_value`
- `recommended_focus`

Recommended focus logic:

- If top volume menu equals top revenue menu: `Jaga stok dan kualitas`
- Else: `Pisahkan strategi stok dan upsell`

### 9. `declining_trend_90d`

Purpose:

- Keep existing 90-day declining trend.
- Rename from `declining_trend` to `declining_trend_90d` for clarity.

Use existing logic, but fix the period semantics if needed:

Current query compares last 30 days against early 30 days in the 90-day range. That is acceptable for demo use, but the wording must make this clear:

> Menu dianggap menurun jika total 30 hari terakhir lebih rendah dari total 30 hari awal dalam window 90 hari.

### 10. `menu_action_queue`

Purpose:

- Create concrete action cards.

Expected columns:

- `priority`
- `severity`
- `action_type`
- `menu_name`
- `category`
- `metric_value`
- `impact_text`
- `recommended_action`

Suggested action sources:

1. Declining menu:
   - severity `Kritis` if pct_change_qty <= -40
   - severity `Tinggi` if pct_change_qty <= -20
   - action: evaluate promo, availability, quality, or branch-specific issue

2. `Pekerja Keras`:
   - high volume but lower revenue
   - action: test bundle, add-on, or small price increase

3. `Misteri`:
   - high revenue but low volume
   - action: improve visibility, staff recommendation, menu placement

4. `Lemah`:
   - low volume and low revenue
   - action: reformulate, reposition, or consider removing

5. Revenue concentration:
   - if top5 share > 55 or 70
   - action: reduce dependency by pushing second-tier menu

Keep action queue compact: max 6 cards.

## UI Rendering Details

### ButtonGroup

Place before main content:

```svelte
<ButtonGroup name=period>
  <ButtonGroupItem valueLabel="Kemarin" value="y" />
  <ButtonGroupItem valueLabel="7 Hari" value="7d" default />
  <ButtonGroupItem valueLabel="30 Hari" value="30d" />
</ButtonGroup>
```

Use emoji only if the rest of the page already uses them consistently. Page `01` does, so acceptable.

### Main Guard

Wrap the whole dashboard:

```svelte
{#if menu_health_overview.length > 0 && menu_dates.length > 0}
  <div class="menu-page">
    ...
  </div>
{:else}
  <div class="section-card">
    <div class="section-title">Data menu belum tersedia.</div>
    <p class="section-copy">Pastikan source `restaurant.menu_performance` sudah ter-refresh.</p>
  </div>
{/if}
```

### Period Strip

Each pill should show:

- period label
- status badge
- key metric
- one-line interpretation

Examples:

- Kemarin: `3 menu turun`, `Top 5: 61% revenue`
- 7 Hari: `2 menu naik`, `Top 5: 58% revenue`
- 30 Hari: `Portofolio sehat`, `24 menu aktif`

### Hero Copy

Use dynamic copy based on active period and status.

For active period, define readable aliases:

```svelte
{@const activeStatus = inputs.period === 'y'
  ? menu_health_overview[0].status_y
  : inputs.period === '30d'
    ? menu_health_overview[0].status_30d
    : menu_health_overview[0].status_7d}
```

Do the same for:

- active focus
- active top 5 share
- active declining count
- active rising count
- active top volume menu
- active top revenue menu
- active menu count

Avoid too many long inline ternaries in markup. Use `{@const ...}` where possible.

Hero headline examples:

If status is `Kritis` and focus is concentration:

> Revenue menu terlalu terkonsentrasi: top 5 menu menyumbang {share}% dari revenue.

If status is `Kritis` and focus is declining:

> {declining_count} menu turun tajam; portofolio butuh tindakan minggu ini.

If status is `Waspada`:

> Portofolio menu masih berjalan, tapi ada sinyal yang perlu diawasi.

If status is `Sehat`:

> Portofolio menu sehat; fokus utama adalah menjaga stok dan momentum menu andalan.

Hero side cards:

1. Active period date range
2. Top volume vs top revenue menu

### KPI Grid

For active period show 4-6 cards:

1. Total revenue menu
2. Total quantity sold
3. Active menu count
4. Top 5 revenue share
5. Declining menu count
6. Rising menu count

For value formatting in Svelte:

```svelte
Rp {activeRevenue.toLocaleString('id-ID', { maximumFractionDigits: 0 })}
```

Guard null values with `?? 0` if necessary.

### Signal Cards

Use 2 or 3 cards:

1. "Apa yang sehat"
2. "Yang perlu perhatian"
3. "Aksi paling masuk akal"

Signal card content should depend on active status/focus:

- If revenue concentration high: recommend pushing second-tier menu, bundles, and staff recommendation.
- If declining menu count high: recommend checking stock availability, quality consistency, branch concentration, and promo fatigue.
- If many weak menu: recommend reformulation or menu simplification.
- If healthy: recommend protecting stock, quality, and supplier availability for hero menu.

### Menu Portfolio Map

Move this section earlier than in current file.

Components:

- `ScatterPlot` using `menu_engineering_period.filter(r => r.period === inputs.period)`
- `DataTable` using same filtered dataset
- classification explanation grid

Important:

Current Evidence syntax may not support arbitrary `.filter()` inside all component props reliably depending on version. If already used elsewhere, okay. Safer option: create separate queries:

- `menu_engineering_y`
- `menu_engineering_7d`
- `menu_engineering_30d`

Then render with `{#if inputs.period === ...}` blocks.

Preferred maintainable approach:

- If Evidence supports filtered expressions in data prop in this project, use `data={menu_engineering_period.filter(r => r.period === inputs.period)}`.
- If not certain, use three render branches.

### Revenue Drivers

Keep top volume vs top revenue charts, but wrap in `.section-card`.

Add interpretation under the charts:

- If top volume menu equals top revenue menu:
  - "Menu utama yang sama memimpin volume dan revenue; jaga stok dan kualitas."
- Else:
  - "Menu yang paling laku berbeda dari menu revenue terbesar; strategi stok dan upsell perlu dipisah."

### Category and Price Tier

Keep both charts and tables.

Add one insight:

- If top category revenue share > 70:
  - concentration warning
- Else:
  - category mix is balanced enough

If implementing this dynamically is too much, static interpretation is acceptable but less ideal.

### Branch Playbook

Keep existing `andalan_per_cabang`, but rename and improve:

- `branch_menu_playbook`
- add `recommended_focus`
- display with `DataTable`

Context copy:

> Cabang dengan menu volume dan menu revenue yang berbeda butuh playbook berbeda: stok mengikuti volume, upsell mengikuti menu revenue.

### Trend and Declining Menus

Keep:

- `menu_movers_period` table
- `declining_trend_90d` line chart
- declining branch detail table

Improve wording:

- Make clear whether the decline is period-over-period or 90-day structural.
- Avoid telling management to remove a menu based only on one-week decline.

### Action Queue

Add near the bottom but before methodology.

Use `menu_action_queue`.

Render:

```svelte
{#if menu_action_queue.length > 0}
  <div class="section-card">
    <div class="section-head">
      ...
    </div>
    <div class="action-stack">
      {#each menu_action_queue as action}
        <div class="action-card ...">
          ...
        </div>
      {/each}
    </div>
  </div>
{:else}
  <div class="section-card">
    ...
  </div>
{/if}
```

Action cards should be explicit:

- what happened
- why it matters
- what to do next
- where to inspect further

Example:

> Ayam Penyet turun -28% qty vs periode sebelumnya. Cek apakah penurunan terjadi di semua cabang atau hanya cabang tertentu. Jika menyebar, uji promo/bundling; jika lokal, audit stok dan kualitas eksekusi cabang tersebut.

## Content Changes To Make

### Rename Page Subtitle

Current:

> Analisis penjualan, tren, dan potensi menu restoran.

Replace with:

> Cockpit portofolio menu: mana yang harus dijaga, didorong, dinaikkan nilainya, atau dievaluasi.

### Replace First Summary

Current `BigValue` summary should be replaced by hero + KPI grid.

Do not keep the old `BigValue` components at the top.

### Move Menu Engineering Earlier

Current menu engineering section appears after branch and category sections.

Move it near the top after KPI/signal cards because it is the strategic core.

### Keep Detailed Tables But Put Them In Section Cards

The page can still include detailed tables, but every major table should sit inside a `section-card` with:

- eyebrow
- title
- short interpretation

### Add Methodology Accordion

Add an accordion at the bottom:

Title:

> Cara membaca klasifikasi menu

Body:

- `Primadona`: volume tinggi, revenue tinggi. Protect stock and quality.
- `Misteri`: revenue tinggi, volume rendah. Improve visibility and staff recommendation.
- `Pekerja Keras`: volume tinggi, revenue rendah. Bundle, add-on, price test.
- `Lemah`: volume rendah, revenue rendah. Reformulate, reposition, or remove after validation.

### Add Data Caveat Accordion

Title:

> Catatan sebelum mengambil keputusan menu

Body:

- One-week decline does not automatically mean remove menu.
- Check stock availability and branch concentration first.
- Revenue is not margin; if ingredient cost exists elsewhere, connect with inventory/finance before final pricing decisions.
- "Kemarin" means latest available data date, not always calendar yesterday.

## Avoid These Pitfalls

1. Do not make page 05 as long or complex as page 02/03.
2. Do not use `CURRENT_DATE`; always anchor to `MAX(order_date)` from `restaurant.menu_performance`.
3. Do not access `[0]` without guarding query length first.
4. Do not leave old `BigValue` top summary alongside new cockpit; it will feel redundant.
5. Do not make every section a giant essay. Keep interpretation concise.
6. Do not imply "hapus menu" based on short-term decline alone.
7. Do not remove useful existing analytical sections unless replaced by stronger equivalents.
8. Do not edit `evidence_en`.

## Suggested Implementation Sequence

1. Read `01-laporan-keuangan.md` CSS and copy/adapt relevant UI classes.
2. Replace current style block in `05-menu-performance.md` with page-05-specific cockpit styles.
3. Add new shared SQL:
   - `menu_dates`
   - `menu_health_overview`
   - `menu_kpi_period`
   - `menu_engineering_period`
   - `menu_movers_period`
   - `category_mix_period`
   - `price_tier_mix_period`
   - `branch_menu_playbook`
   - `declining_trend_90d`
   - `declining_by_branch`
   - `menu_action_queue`
4. Replace top-level content with ButtonGroup + guarded `.menu-page`.
5. Build period strip.
6. Build active-period hero.
7. Build KPI grid.
8. Build signal cards.
9. Rebuild sections in this order:
   - portfolio map
   - revenue drivers
   - category/price tier
   - branch playbook
   - movers and declining trend
   - action queue
   - methodology accordions
10. Run Evidence build:
    - `cd evidence`
    - `npm run build`
11. Fix any Svelte/Evidence syntax errors.
12. Check visual output locally if possible.

## Acceptance Criteria

The rework is complete when:

1. `npm run build` succeeds from `evidence/`.
2. `05-menu-performance.md` visually matches the UI language of `01-laporan-keuangan.md`.
3. The top of the page has:
   - period switch
   - period strip
   - hero/cockpit
   - KPI grid
   - signal cards
4. Menu engineering appears before the lower detail tables.
5. There is an action queue with concrete recommendations.
6. Existing useful analysis is preserved or replaced:
   - top volume vs top revenue
   - category mix
   - price tier mix
   - branch-specific hero menu
   - menu engineering
   - movers / WoW
   - 90-day declining trend
7. No references to `evidence_en`.
8. No unguarded top-level `[0]` access outside a safe `{#if ...length > 0}` block.
9. All date logic is anchored to max available menu data date.
10. The page reads like a decision cockpit, not a raw report.

## Quality Bar

Aim for:

- UI consistency with page `01`: high
- Business actionability: high
- Maintainability: medium-high
- Complexity: moderate

Expected outcome:

- Current score around 8.3/10.
- After rework, target 8.8-9.0/10.

The most important design decision is this:

> Page 05 should help the restaurant owner decide what to do with each menu item, not merely show which menu item sold the most.


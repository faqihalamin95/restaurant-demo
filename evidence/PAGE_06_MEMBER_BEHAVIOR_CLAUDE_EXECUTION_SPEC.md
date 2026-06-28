# Claude Execution Spec: Rework Page 06 Member Behavior

This document is intended to be sent directly to Claude or another coding agent. It is a detailed implementation brief for reworking `evidence/pages/06-member-behavior.md` into a final **Loyalty & Retention Cockpit**.

## 0. One-Sentence Goal

Rework `evidence/pages/06-member-behavior.md` from a report-style member analysis page into a decision cockpit that helps a restaurant owner identify whether the loyalty program is healthy, which member segments drive value, who is at risk of churn, and what retention action should happen next.

## 1. Repository Context

Project type:

- Evidence dashboard project.
- Main working directory for this task: `evidence/`.
- Target file: `evidence/pages/06-member-behavior.md`.

Primary UI reference:

- `evidence/pages/01-laporan-keuangan.md`

Use page 01 as the base UI pattern because it already has:

- local `<style>` block,
- `.over-container` hidden,
- page wrapper,
- period strip,
- hero cockpit,
- KPI grid,
- signal cards,
- section cards,
- accordions,
- responsive behavior.

Other references:

- `evidence/pages/05-menu-performance.md` if it has already been reworked into cockpit style.
- `evidence/pages/02-branch-performance.md` for portfolio/action framing.
- `evidence/pages/03-inventori-stok.md` for action queue patterns.
- `evidence/pages/04-peak-hours.md` for concise executive narrative and use of `{@const ...}`.

Do not edit these files unless explicitly asked:

- `evidence/pages/01-laporan-keuangan.md`
- `evidence/pages/02-branch-performance.md`
- `evidence/pages/03-inventori-stok.md`
- `evidence/pages/04-peak-hours.md`
- `evidence/pages/05-menu-performance.md`
- any `evidence_en/` directory if present.

## 2. Current Page Problem

Current `06-member-behavior.md` already has useful analysis:

- 90-day member summary.
- AOV comparison vs previous 90 days.
- churn count.
- tier spending.
- tier WoW.
- spending trend.
- city contribution.
- top member table.
- tier distribution by city.
- cohort analysis.
- churn risk table.

The problem is hierarchy:

- Page opens as a 90-day report, not as a retention cockpit.
- Important churn risk appears too low on the page.
- Cohort analysis appears before churn risk and takes too much cognitive space.
- Top member table is useful but not tied to actions such as maintain, win-back, upsell, or upgrade.
- There is no central `member_health_overview` that controls status, severity, and focus.
- There is no top-level retention action queue.
- The page uses `BigValue`, free-floating headings, and inline alert blocks rather than the cockpit UI used by page 01.

## 3. Product Intent

The page should answer these questions quickly:

1. Is the loyalty/member program healthy?
2. Are members contributing meaningful orders and revenue?
3. Are high-value members becoming inactive?
4. Which tier is most valuable?
5. Which members or segments need outreach now?
6. Are members returning frequently enough?
7. Is the issue activation, value, frequency, or churn?
8. What should management do next?

The page should not primarily be a historical report. It should be a retention management cockpit.

## 4. Target User

Primary user:

- Restaurant owner, CRM manager, area manager, or operations lead.

They need:

- quick loyalty health diagnosis,
- clear retention priorities,
- high-value member risk,
- tier-level strategy,
- recommended actions.

Secondary user:

- Analyst/dashboard builder.

They need:

- cohort analysis,
- detailed tables,
- methodology and caveats.

Therefore use 3 layers:

1. L1 cockpit: status, diagnosis, retention priority.
2. L2 diagnostic evidence: tier economics, retention queue, trends, city view.
3. L3 analyst detail: cohort, definitions, caveats in accordions or lower sections.

## 5. Design Positioning

Final page name:

- `Analisis Perilaku Member`

Final page concept:

- **Loyalty & Retention Cockpit**

Suggested subtitle:

> Cockpit loyalitas member: siapa yang aktif, siapa yang bernilai tinggi, dan siapa yang perlu dijaga sebelum churn.

Tone:

- Direct.
- Retention-oriented.
- Business-friendly.
- Careful with churn wording: use "berisiko churn" or "perlu outreach", not "hilang" unless data proves it.

Key vocabulary:

- member aktif,
- kontribusi order member,
- frekuensi kembali,
- value member,
- tier bernilai tinggi,
- churn risk,
- win-back,
- outreach,
- retensi Gold,
- upgrade Bronze/Silver,
- high-value inactive,
- loyalitas sehat,
- loyalty program belum maksimal.

Avoid:

- making cohort the main story,
- treating all inactive members equally,
- implying churn is final based only on recency,
- using raw spend without frequency/recency context,
- presenting member count as success if active contribution is weak.

## 6. Data Source Contract

Use only:

```sql
restaurant.member_purchase_behavior
```

Known columns used by the current page:

- `order_date`
- `member_id`
- `member_name`
- `tier`
- `city`
- `join_date`
- `total_orders`
- `total_items`
- `total_spend`
- `avg_order_value`
- `recency_days`

Important data rule:

- Anchor all date logic to `MAX(order_date)` from `restaurant.member_purchase_behavior`.
- Do not use `CURRENT_DATE`.
- "Kemarin" or "data terakhir" means latest available data date in the dataset, not necessarily calendar yesterday.

Tier assumptions:

- Gold is high-value/high-priority.
- Silver is mid-value.
- Bronze is early/upgrade opportunity.

Churn thresholds:

- Gold: recency >= 14 days.
- Silver: recency >= 21 days.
- Bronze: recency >= 30 days.

These are demo thresholds and should be documented as configurable assumptions.

## 7. File Scope

Edit:

- `evidence/pages/06-member-behavior.md`

Do not edit:

- other page files,
- datasource config,
- dbt files,
- package files,
- generated build artifacts.

Implementation may replace most of the existing file. Preserve useful analytics by reimplementing them in the new structure.

## 8. Final Page Structure

The final file should follow this order:

1. YAML frontmatter.
2. Short subtitle.
3. Local `<style>` block.
4. SQL queries.
5. `ButtonGroup name=period`.
6. Main guard.
7. `.member-page` wrapper.
8. Page intro.
9. Period strip.
10. Active-period hero cockpit.
11. KPI grid.
12. Signal cards.
13. Retention Queue.
14. Tier Economics.
15. Member Value Map or Top Member Segments.
16. Spending Trend and City/Geography.
17. Top Members table.
18. Cohort Analysis in accordion or lower analyst section.
19. Methodology and caveat accordions.
20. Empty state fallback.

Recommended render skeleton:

```svelte
---
title: Analisis Perilaku Member
---

_Cockpit loyalitas member: siapa yang aktif, siapa yang bernilai tinggi, dan siapa yang perlu dijaga sebelum churn._

<style>
/* local page styles */
</style>

```sql member_dates
...
```

...

<ButtonGroup name=period>
  <ButtonGroupItem valueLabel="30 Hari" value="30d" />
  <ButtonGroupItem valueLabel="90 Hari" value="90d" default />
  <ButtonGroupItem valueLabel="Cohort" value="cohort" />
</ButtonGroup>

{#if member_health_overview.length > 0 && member_dates.length > 0}
<div class="member-page">
  ...
</div>
{:else}
<div class="section-card">
  <h3 class="section-title">Data member belum tersedia.</h3>
  <p class="section-copy">Pastikan source restaurant.member_purchase_behavior sudah ter-refresh.</p>
</div>
{/if}
```

## 9. Period Strategy

Use:

- `30d`: operational loyalty pulse.
- `90d`: default structural retention view.
- `cohort`: analyst view for cohort quality.

Do not use "Kemarin" as a main period for this page. Member behavior is usually too sparse/noisy daily. If daily data is needed, mention latest data date in side cards but keep analysis at 30/90 day horizon.

Default:

- `90d`

Why:

- Current page is already 90-day oriented.
- Churn thresholds and tier value are more meaningful on 90-day windows.
- 30 days is useful for near-term pulse.
- Cohort is important but not daily management.

## 10. UI Style Requirements

Create a local style block in `06-member-behavior.md`.

Use page 01 style as base. Use member-specific class names where useful.

### 10.1 Base Classes

Required:

- `.over-container`
- `details`
- `details > summary`
- `.acc-body`
- `details.acc-strategic`
- `.member-page`
- `.page-intro`
- `.inline-link`

Behavior:

- Hide `.over-container`.
- `.member-page` uses flex column with ~24px gap.
- `.page-intro` max width around 70ch.

### 10.2 Period Strip

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

- Compare 30d / 90d / cohort quality without forcing the user to switch.

Content:

- 30 Hari: member active, member order contribution, churn risk.
- 90 Hari: active members, repeat frequency, churn risk.
- Cohort: newest cohort frequency/value vs older cohort.

### 10.3 Hero

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

- Diagnose whether loyalty is healthy, underused, or retention-risky.
- Tell user where to focus: activation, frequency, value, or churn.

Hero side cards:

1. Active period date range.
2. Priority segment: Gold churn, high-value inactive, or tier opportunity.

### 10.4 KPI Grid

Required:

- `.kpi-grid`
- `.kpi-card`
- `.kpi-card.member`
- `.kpi-card.orders`
- `.kpi-card.value`
- `.kpi-card.frequency`
- `.kpi-card.churn`
- `.kpi-label`
- `.kpi-value`
- `.kpi-meta`

Recommended KPI cards:

1. Member Aktif.
2. Kontribusi Order Member.
3. Total Belanja Member.
4. AOV Member.
5. Frekuensi per Member.
6. Member Churn Risk.

If top area feels crowded, show 4 cards only:

1. Member Aktif.
2. Kontribusi Order Member.
3. Frekuensi per Member.
4. Churn Risk.

Move total belanja and AOV into supporting cards/sections if needed.

### 10.5 Signal Cards

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
2. Risiko utama.
3. Aksi berikutnya.

Dynamic focus:

- `Churn risk`: prioritize outreach.
- `Kontribusi rendah`: improve member capture/activation.
- `Frekuensi rendah`: create return incentive.
- `Value turun`: investigate tier mix or basket size.
- `Sehat`: maintain Gold and upgrade high-potential Bronze/Silver.

### 10.6 Section Cards

Required:

- `.section-card`
- `.section-head`
- `.section-head.tight`
- `.section-eyebrow`
- `.section-title`
- `.section-copy`

Every major chart/table should be inside a section card.

### 10.7 Retention Queue Classes

Required:

- `.retention-stack`
- `.retention-card`
- `.retention-card.critical`
- `.retention-card.high`
- `.retention-card.moderate`
- `.retention-card.low`
- `.retention-header`
- `.retention-severity`
- `.retention-badge`
- `.retention-title`
- `.retention-impact`
- `.retention-rec`

Retention queue should be prominent and appear before cohort.

### 10.8 Tier and Segment Classes

Required:

- `.tier-grid`
- `.tier-card`
- `.tier-card.gold`
- `.tier-card.silver`
- `.tier-card.bronze`
- `.tier-label`
- `.tier-title`
- `.tier-value`
- `.tier-copy`
- `.segment-grid`
- `.segment-card`

Use tier cards to summarize tier economics without making the user read a table first.

### 10.9 Responsive Rules

Add:

```css
@media (max-width: 900px) {
  .period-strip,
  .kpi-grid,
  .signal-grid,
  .tier-grid,
  .segment-grid {
    grid-template-columns: 1fr;
  }

  .hero {
    grid-template-columns: 1fr;
  }
}
```

Also ensure:

- no table is the only way to understand the section,
- no text blocks are too long on mobile,
- no nested cards inside cards,
- no huge cohort section above retention queue.

## 11. SQL Query Contract

Use these query names unless there is a strong reason to split or rename:

1. `member_dates`
2. `member_health_period`
3. `member_health_overview`
4. `member_kpi_period`
5. `retention_queue`
6. `tier_economics_period`
7. `tier_movement_period`
8. `member_value_segments`
9. `top_member_period`
10. `spending_trend_30d`
11. `spending_by_city`
12. `tier_city_mix`
13. `cohort_summary`
14. `cohort_total`

If Evidence build fails due to query complexity, split into smaller queries. Keep the rendered page contract the same.

### 11.1 `member_dates`

Purpose:

- Date labels for period strip and hero side card.

Expected columns:

- `tgl_akhir`
- `tgl_30_awal`
- `tgl_90_awal`
- `tgl_180_awal`

Template:

```sql
SELECT
    strftime('%d %b %Y', MAX(order_date)) AS tgl_akhir,
    strftime('%d %b %Y', MAX(order_date) - INTERVAL '29 days') AS tgl_30_awal,
    strftime('%d %b %Y', MAX(order_date) - INTERVAL '89 days') AS tgl_90_awal,
    strftime('%d %b %Y', MAX(order_date) - INTERVAL '179 days') AS tgl_180_awal
FROM restaurant.member_purchase_behavior
```

### 11.2 Shared Period Logic

Use this conceptual period table:

```sql
WITH max_d AS (
    SELECT MAX(order_date) AS d
    FROM restaurant.member_purchase_behavior
),
periods AS (
    SELECT '30d' AS period,
           d - INTERVAL '29 days' AS start_date,
           d AS end_date,
           d - INTERVAL '59 days' AS prev_start,
           d - INTERVAL '30 days' AS prev_end
    FROM max_d
    UNION ALL
    SELECT '90d',
           d - INTERVAL '89 days',
           d,
           d - INTERVAL '179 days',
           d - INTERVAL '90 days'
    FROM max_d
)
```

Meaning:

- `30d`: last 30 days vs previous 30 days.
- `90d`: last 90 days vs previous 90 days.
- Cohort is handled separately.

### 11.3 `member_health_period`

Purpose:

- One row per period with health status and core loyalty diagnostics.

Expected columns:

- `period`
- `status`
- `focus`
- `active_members`
- `total_member_orders`
- `total_member_spend`
- `avg_order_value`
- `avg_orders_per_member`
- `member_order_contribution_proxy`
- `churn_risk_count`
- `gold_churn_risk`
- `silver_churn_risk`
- `bronze_churn_risk`
- `high_value_inactive_count`
- `aov_change_pct`
- `frequency_change_pct`
- `top_tier`
- `top_tier_spend`

Notes:

- Source only has member orders, not all restaurant orders. If no all-orders denominator exists, call the metric `member_order_volume` or `member_activity_index`, not "share of all orders".
- If this page needs contribution vs all orders, only compute it if an appropriate all-order source is joined safely. Otherwise avoid false precision.

Health status rules:

- `Kritis` if:
  - `gold_churn_risk >= 3`, or
  - `high_value_inactive_count >= 5`, or
  - `frequency_change_pct <= -25`, or
  - `aov_change_pct <= -20`
- `Waspada` if:
  - `gold_churn_risk >= 1`, or
  - `churn_risk_count >= 5`, or
  - `frequency_change_pct <= -10`, or
  - `aov_change_pct <= -10`
- `Sehat` otherwise.

Focus rules:

- `Churn risk` if Gold/high-value churn is the strongest concern.
- `Frekuensi turun` if frequency decline is the strongest concern.
- `Value turun` if AOV/spend decline is the strongest concern.
- `Aktivasi rendah` if active member count or orders/member is weak.
- `Loyalitas sehat` otherwise.

Implementation suggestion:

1. Aggregate per period/member.
2. Aggregate current period.
3. Aggregate previous period.
4. Compute AOV and frequency deltas.
5. Compute churn risk from latest recency per member.
6. Compute high-value inactive members from top spenders with recency beyond threshold.
7. Aggregate by period.

### 11.4 `member_health_overview`

Purpose:

- Pivot `member_health_period` into one row for period strip and hero.

Expected columns:

- `status_30d`, `focus_30d`, `active_30d`, `orders_30d`, `spend_30d`, `aov_30d`, `freq_30d`, `churn_30d`, `gold_churn_30d`, `aov_change_30d`, `freq_change_30d`
- `status_90d`, `focus_90d`, `active_90d`, `orders_90d`, `spend_90d`, `aov_90d`, `freq_90d`, `churn_90d`, `gold_churn_90d`, `aov_change_90d`, `freq_change_90d`
- `cohort_status`, `cohort_focus`, `newest_cohort_freq`, `avg_cohort_freq`, `newest_cohort_value`, `avg_cohort_value`

If SQL cannot reference another query by name, duplicate CTE logic or build overview directly.

### 11.5 `member_kpi_period`

Purpose:

- Feed KPI grid.

Expected columns:

- `period`
- `active_members`
- `total_member_orders`
- `total_member_spend`
- `avg_order_value`
- `avg_orders_per_member`
- `orders_per_member_per_week`
- `churn_risk_count`
- `gold_churn_risk`
- `aov_change_pct`
- `frequency_change_pct`

Frequency:

- For 30d, weekly frequency = `total_orders / active_members / 4.29`.
- For 90d, weekly frequency = `total_orders / active_members / 12.86`.

### 11.6 `retention_queue`

Purpose:

- Feed prominent retention action cards.

Expected columns:

- `priority`
- `severity`
- `action_type`
- `member_name`
- `tier`
- `city`
- `metric_value`
- `impact_text`
- `recommended_action`

Max rows:

- 6 to 8.

Action source priority:

1. Gold churn risk:
   - severity `Kritis` if Gold recency >= 21.
   - severity `Tinggi` if Gold recency >= 14.
   - action: personal outreach / VIP offer / reservation invitation.
2. High-value inactive:
   - member in top spenders with recency beyond tier threshold.
   - action: win-back message or manager follow-up.
3. Silver upgrade opportunity:
   - frequent Silver with high spend.
   - action: upgrade incentive.
4. Bronze activation:
   - many orders but low AOV or early engagement.
   - action: bundle/add-on incentive.
5. Frequency decline:
   - segment/tier with declining frequency.
   - action: return visit campaign.
6. Value decline:
   - AOV/spend down.
   - action: upsell, set menu, tier benefit review.

Do not make action cards too verbose. Each should include:

- what happened,
- why it matters,
- what to do next.

### 11.7 `tier_economics_period`

Purpose:

- Feed tier economics cards, chart, and table.

Expected columns:

- `period`
- `tier`
- `active_members`
- `total_orders`
- `total_spend`
- `avg_order_value`
- `orders_per_member`
- `orders_per_member_per_week`
- `spend_per_member`
- `pct_spend`
- `pct_members`

Recommended sort:

- Gold, Silver, Bronze, or by total spend.

### 11.8 `tier_movement_period`

Purpose:

- Compare tier performance current vs previous period.

Expected columns:

- `period`
- `tier`
- `spend_current`
- `spend_previous`
- `spend_change_pct`
- `orders_current`
- `orders_previous`
- `orders_change_pct`
- `freq_current`
- `freq_previous`
- `freq_change_pct`
- `movement_status`

Movement logic:

- `Naik` if spend or frequency change >= 10.
- `Turun` if spend or frequency change <= -10.
- `Stabil` otherwise.

### 11.9 `member_value_segments`

Purpose:

- Segment members into actionable groups.

Expected columns:

- `period`
- `member_name`
- `tier`
- `city`
- `total_orders`
- `orders_per_week`
- `total_spend`
- `avg_order_value`
- `recency_days`
- `segment`
- `recommended_action`

Suggested segments:

- `VIP Aktif`: high spend, recent.
- `VIP Berisiko`: high spend, not recent.
- `Sering Datang`: high frequency, moderate/low AOV.
- `Upsell Candidate`: frequent but low AOV.
- `Win-back`: inactive beyond threshold.
- `Normal`: no immediate action.

Use period-specific percentiles or simple thresholds:

- high spend: above 75th percentile of member spend.
- high frequency: above 75th percentile of orders per week.
- low AOV: below median AOV.

If percentiles are hard in Evidence SQL, use rank/NTILE if supported by DuckDB.

### 11.10 `top_member_period`

Purpose:

- Preserve top member table but add action labels.

Expected columns:

- `period`
- `member_name`
- `tier`
- `city`
- `total_orders`
- `orders_per_week`
- `total_items`
- `total_spend`
- `avg_order_value`
- `recency_days`
- `member_action`

Action examples:

- `Pertahankan VIP`
- `Win-back`
- `Upsell add-on`
- `Upgrade tier`
- `Pantau`

### 11.11 `spending_trend_30d`

Purpose:

- Preserve trend by tier.

Expected columns:

- `order_date`
- `tier`
- `total_spend`
- `total_orders`
- `active_members`

Use only in a lower diagnostic section, not top hero.

### 11.12 `spending_by_city`

Purpose:

- Preserve city contribution.

Expected columns:

- `city`
- `active_members`
- `total_spend`
- `avg_order_value`
- `orders_per_member`
- `top_tier`

### 11.13 `tier_city_mix`

Purpose:

- Preserve tier per city analysis.

Expected columns:

- `city`
- `tier`
- `active_members`
- `total_spend`
- `avg_order_value`
- `pct_members_in_city`
- `pct_spend_in_city`

### 11.14 `cohort_summary`

Purpose:

- Preserve cohort analysis as analyst section.

Expected columns:

- `cohort_bulan`
- `tier`
- `total_member`
- `avg_spend_per_member`
- `avg_frekuensi_mingguan`

Use current logic, but move below retention and top member sections.

### 11.15 `cohort_total`

Purpose:

- Cohort summary chart.

Expected columns:

- `cohort_bulan`
- `total_member`
- `avg_spend_per_member`
- `avg_frekuensi_mingguan`

## 12. Rendering Contract

### 12.1 Main Guard

Do not access `[0]` before the main guard.

Use:

```svelte
{#if member_health_overview.length > 0 && member_dates.length > 0}
  ...
{:else}
  ...
{/if}
```

Inside the guard, define active constants using `{@const}`. This project already uses `{@const}` in `pages/04-peak-hours.md`.

Example:

```svelte
{@const activeStatus = inputs.period === '30d'
  ? member_health_overview[0].status_30d
  : inputs.period === 'cohort'
    ? member_health_overview[0].cohort_status
    : member_health_overview[0].status_90d}
```

Define similar constants for:

- `activeFocus`
- `activeMembers`
- `activeOrders`
- `activeSpend`
- `activeAov`
- `activeFrequency`
- `activeChurn`
- `activeGoldChurn`

For active period rows:

```svelte
{@const activeKpi = member_kpi_period.find(r => r.period === inputs.period) ?? member_kpi_period.find(r => r.period === '90d')}
```

For `inputs.period === 'cohort'`, use cohort overview values and hide KPI cards that do not apply.

### 12.2 ButtonGroup

Use:

```svelte
<ButtonGroup name=period>
  <ButtonGroupItem valueLabel="30 Hari" value="30d" />
  <ButtonGroupItem valueLabel="90 Hari" value="90d" default />
  <ButtonGroupItem valueLabel="Cohort" value="cohort" />
</ButtonGroup>
```

### 12.3 Period Strip

Each pill:

- label,
- status badge,
- core metric,
- one-line interpretation.

Example content:

- 30 Hari: `{active_30d} member aktif · {churn_30d} churn risk`
- 90 Hari: `{active_90d} member aktif · {freq_90d} order/member/minggu`
- Cohort: `cohort terbaru {newest_cohort_freq} order/minggu`

### 12.4 Hero

Hero headline logic:

If active status is `Kritis` and focus is `Churn risk`:

> Member bernilai tinggi mulai berisiko churn.

If active status is `Kritis` and focus is `Frekuensi turun`:

> Frekuensi kembali member turun tajam pada periode ini.

If active status is `Kritis` and focus is `Value turun`:

> Nilai transaksi member turun; cek tier mix dan basket size.

If `Waspada`:

> Program member masih aktif, tapi ada sinyal retensi yang perlu ditangani.

If `Sehat`:

> Loyalitas member sehat; fokusnya menjaga Gold dan mendorong upgrade tier berikutnya.

Hero copy max 2-3 sentences.

Hero side cards:

1. Periode aktif.
2. Segment prioritas:
   - Gold churn risk,
   - high-value inactive,
   - upgrade opportunity,
   - or top tier value.

### 12.5 KPI Grid

For `30d` and `90d`, show:

- Member Aktif.
- Total Order Member.
- Frekuensi / Member / Minggu.
- AOV Member.
- Total Belanja.
- Churn Risk.

If too crowded, reduce to:

- Member Aktif.
- Frekuensi / Member / Minggu.
- AOV Member.
- Churn Risk.

For `cohort`, show:

- Total cohort.
- Cohort terbaru frequency.
- Cohort terbaru value.
- Gap vs cohort average.

### 12.6 Signal Cards

Use 3 cards:

1. `Apa yang sehat`
2. `Risiko utama`
3. `Aksi berikutnya`

Signal examples:

- Healthy:
  - "Gold masih menjadi sumber value utama."
  - "Retensi tidak menunjukkan alarm besar."
- Churn:
  - "Gold churn risk harus diprioritaskan karena value per member tinggi."
- Frequency:
  - "Member masih belanja, tapi frekuensi kembali melemah."
- Activation:
  - "Member aktif belum cukup banyak untuk menopang program loyalitas."

### 12.7 Retention Queue

This section must appear before cohort.

Use `retention_queue`.

Render:

```svelte
{#if retention_queue.length > 0}
  <div class="section-card">
    <div class="section-head">
      <div>
        <div class="section-eyebrow">Retention Queue</div>
        <h3 class="section-title">Member yang perlu ditindak lebih dulu</h3>
        <p class="section-copy">Urut dari risiko tertinggi berdasarkan tier, recency, dan nilai belanja.</p>
      </div>
    </div>
    <div class="retention-stack">
      {#each retention_queue as action}
        <div class="retention-card {action.severity === 'Kritis' ? 'critical' : action.severity === 'Tinggi' ? 'high' : action.severity === 'Sedang' ? 'moderate' : 'low'}">
          ...
        </div>
      {/each}
    </div>
  </div>
{:else}
  <div class="section-card">
    <h3 class="section-title">Belum ada member prioritas untuk outreach.</h3>
    <p class="section-copy">Tidak ada alarm churn besar pada periode aktif. Lanjutkan pemantauan dan jaga benefit tier utama.</p>
  </div>
{/if}
```

Important:

- If page hero says `Kritis` due to churn, retention queue must not be empty.
- Avoid contradiction between health status and action queue.

### 12.8 Tier Economics

Use:

- tier cards for Gold/Silver/Bronze,
- bar chart spend by tier,
- table for detail.

Main question:

- Which tier creates the most value?
- Which tier needs activation/upgrade?

Recommended copy:

> Tier Gold biasanya kecil secara jumlah, tetapi besar secara value. Bronze yang banyak tetapi rendah frequency adalah kandidat upgrade, bukan sekadar angka member besar.

### 12.9 Member Value Segments

Use `member_value_segments`.

Display:

- compact segment cards or table.

Recommended segments:

- VIP Aktif.
- VIP Berisiko.
- Sering Datang.
- Upsell Candidate.
- Win-back.

This section bridges top member table and action queue.

### 12.10 Spending Trend and Geography

Keep current:

- trend per tier,
- city contribution,
- tier per city.

But make it lower than retention queue.

Do not let geography dominate the page unless there is a clear business decision.

### 12.11 Top Members

Use `top_member_period`.

Main table columns:

- Member.
- Tier.
- Kota.
- Order/minggu.
- Total belanja.
- AOV.
- Recency.
- Action.

Keep rows around 15-25.

### 12.12 Cohort

Cohort should be:

- a separate `cohort` period view, or
- a lower accordion/section titled `Analisis Cohort`.

Do not place cohort before retention queue.

Cohort purpose:

- evaluate quality of members by join month,
- identify whether newly acquired members are better/worse,
- not a daily management action.

### 12.13 Methodology Accordions

Add at bottom:

1. `Cara membaca health member`
2. `Cara membaca churn risk`
3. `Catatan data member`

Content:

Health:

- Sehat/waspada/kritis based on churn, frequency, value.

Churn:

- Gold 14 days, Silver 21 days, Bronze 30 days.
- These are demo thresholds and should be calibrated.

Caveats:

- Recency risk is not final churn.
- Some members naturally buy less frequently depending on restaurant type.
- Member revenue is not all customer revenue.
- Cohort needs longer data to be truly conclusive.

## 13. Content to Remove or Replace

Remove/replace:

- Old top `BigValue` summary.
- Long intro explanation at top.
- Inline alert blocks near the top.
- Free-floating headings not wrapped in section cards.
- Cohort explanation before churn/retention.

Keep/rebuild:

- tier spending,
- tier WoW/movement,
- spending trend by tier,
- city contribution,
- top members,
- tier per city,
- cohort,
- churn risk.

## 14. Evidence Syntax Notes

This repo already uses:

- Svelte `{#if}` blocks.
- Svelte `{#each}` loops.
- Svelte `{@const ...}` in `pages/04-peak-hours.md`.
- Evidence core components:
  - `ButtonGroup`
  - `ButtonGroupItem`
  - `BarChart`
  - `LineChart`
  - `DataTable`
  - `Column`

Prefer simple, buildable Svelte over clever abstraction.

Avoid:

- complex inline ternary chains repeated many times,
- unguarded `[0]`,
- accessing properties on undefined active rows,
- relying on `CURRENT_DATE`,
- adding external libraries.

If filtering inside component props fails:

- split data into period-specific queries, or
- use explicit `{#if inputs.period === ...}` render branches.

## 15. Visual Quality Rules

The final page should feel like a CRM/retention cockpit, not a generic BI report.

Use:

- compact cards,
- tier cards,
- retention action cards,
- status badges,
- restrained semantic colors,
- direct section titles.

Avoid:

- massive first-screen text,
- cohort appearing too early,
- too many tables in sequence,
- table-only retention diagnosis,
- nested cards inside cards,
- chart overload.

Emoji policy:

- Existing project uses emojis; acceptable in moderation.
- Do not rely on emoji alone for status.
- Pair emoji with text labels.

## 16. Implementation Sequence

Recommended steps:

1. Open `evidence/pages/01-laporan-keuangan.md` and inspect style patterns.
2. Open current `evidence/pages/06-member-behavior.md`.
3. Replace local content with cockpit structure.
4. Add local style block.
5. Add SQL query set:
   - `member_dates`
   - `member_health_period`
   - `member_health_overview`
   - `member_kpi_period`
   - `retention_queue`
   - `tier_economics_period`
   - `tier_movement_period`
   - `member_value_segments`
   - `top_member_period`
   - `spending_trend_30d`
   - `spending_by_city`
   - `tier_city_mix`
   - `cohort_summary`
   - `cohort_total`
6. Add `ButtonGroup name=period`.
7. Add main guard.
8. Build `.member-page`.
9. Build period strip.
10. Build hero.
11. Build KPI grid.
12. Build signal cards.
13. Build retention queue.
14. Build tier economics.
15. Build member value segments.
16. Build trend/geography.
17. Build top member table.
18. Build cohort section or cohort view.
19. Build methodology accordions.
20. Run build.
21. Fix SQL/Svelte/component errors.

## 17. Build and Verification

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
2. Fix undefined active rows.
3. If component prop filtering fails, split period-specific queries or render branches.
4. If a health query is too complex, split it into smaller queries.

Do not stop after writing code without running build unless environment prevents it.

## 18. Acceptance Criteria

Implementation is complete when:

1. `npm run build` succeeds from `evidence/`.
2. `06-member-behavior.md` has period switch: `30 Hari`, `90 Hari`, `Cohort`.
3. Page top includes:
   - period strip,
   - hero cockpit,
   - KPI grid,
   - signal cards.
4. Retention queue appears before cohort analysis.
5. Churn risk or Gold risk is visible early if present.
6. Existing useful analysis is preserved or replaced:
   - tier economics,
   - tier movement,
   - spending trend,
   - city/tier distribution,
   - top members,
   - cohort,
   - churn risk.
7. Date logic uses max available member date.
8. No unguarded top-level `[0]` references.
9. Page visually aligns with page 01 and page 05 cockpit style.
10. Page reads as a retention cockpit, not a raw report.
11. Health status and retention queue do not contradict each other.

## 19. Non-Goals

Do not:

- redesign the whole dashboard,
- edit `index.md`,
- edit other pages,
- add new datasource,
- add external dependencies,
- change dbt models,
- change package versions,
- compute contribution vs all orders unless the all-order denominator is available and correct,
- claim true churn from recency alone.

## 20. Final Quality Target

Target score after rework:

- 8.7 to 9.0 out of 10.

Most important outcome:

> A restaurant owner can open the page and immediately know whether the member program is healthy, which high-value members need outreach, and which tier/segment deserves the next retention campaign.

## 21. Suggested Final Copy Blocks

Use these as copy inspiration, not mandatory exact text.

Subtitle:

> Cockpit loyalitas member: siapa yang aktif, siapa yang bernilai tinggi, dan siapa yang perlu dijaga sebelum churn.

Hero healthy:

> Loyalitas member sehat; fokusnya menjaga Gold dan mendorong upgrade tier berikutnya.

Hero churn:

> Member bernilai tinggi mulai berisiko churn. Prioritas minggu ini adalah outreach ke Gold dan high-value inactive sebelum mereka benar-benar berhenti kembali.

Hero frequency:

> Frekuensi kembali member melemah. Member masih belanja, tetapi kebiasaan kunjungannya mulai turun.

Hero value:

> Nilai transaksi member turun. Cek apakah penurunan datang dari tier mix, basket size, atau member bernilai tinggi yang mulai jarang kembali.

Retention queue intro:

> Urutan ini memprioritaskan member berdasarkan tier, nilai belanja, dan recency. Gunakan sebagai daftar kerja outreach sebelum membuat promo massal.

Tier economics intro:

> Tier tidak hanya dibaca dari jumlah member. Gold bisa kecil secara populasi tetapi besar secara value; Bronze bisa besar secara jumlah tetapi masih perlu aktivasi dan upgrade.

Cohort intro:

> Cohort membantu melihat apakah member yang baru bergabung semakin berkualitas atau justru lebih cepat melemah dibanding cohort lama.


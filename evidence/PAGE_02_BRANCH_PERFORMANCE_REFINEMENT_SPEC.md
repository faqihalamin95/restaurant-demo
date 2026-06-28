# Technical Spec: Refine Page 02 Branch Performance

This document defines the next refinement pass for `evidence/pages/02-branch-performance.md`.

The goal is not to add more analysis. The goal is to make every subpage easier to read by giving each subpage one clear mental job.

## 0. Core Philosophy

Page 02 is intentionally split into subpages so the reader does not have to process every branch analysis at once.

Principle:

> One subpage = one mental job.

For branch performance:

| Subpage | Mental Job |
|---|---|
| Ringkasan | Which branches are healthy or unhealthy right now? |
| Pertumbuhan | Which branches are rising, declining, or diverging? |
| Profitabilitas | Why is margin healthy or leaking? |
| Deep Dive | What is happening inside one selected branch? |
| Strategi | What role should each branch play in the portfolio? |
| Pusat Aksi | What should management do first? |

The Ringkasan subpage should not try to prove everything. It is a triage screen.

## 1. Target File

Edit:

- `evidence/pages/02-branch-performance.md`

Do not edit:

- `evidence/pages/01-laporan-keuangan.md`
- `evidence/pages/03-inventori-stok.md`
- `evidence/pages/04-peak-hours.md`
- `evidence/pages/05-menu-performance.md`
- `evidence/pages/06-member-behavior.md`
- `evidence/pages/07-employee-performance.md`
- datasource files
- dbt files
- generated build files

## 2. Current State Observations

The page already has strong analytical content:

- view tabs: Ringkasan, Pertumbuhan, Profitabilitas, Deep Dive, Strategi, Pusat Aksi
- period switch: Kemarin, 7 Hari, 30 Hari
- branch health overview
- branch ranking
- revenue vs margin matrix
- growth and WoW queries
- profitability queries
- deep dive selector
- strategy/action queries

Main issue:

- The Ringkasan view still feels like a mini complete dashboard.
- It uses a portfolio score, but the client can understand branch health faster from margin per branch.
- It has too much proof too early.
- Methodology explanations should not be dumped at the bottom. Use just-in-time accordions near the relevant section.

## 3. Required Design Shift

### From

Portfolio score + multiple signal cards + ranking table + matrix + scatter.

### To

Branch health triage:

1. Which branches are healthy?
2. Which branches are early warning?
3. Which branches are recovery?
4. Which branches are turnaround?
5. Which subpage should the user open next?

## 4. Data Horizon Strategy

Branches are long-lived assets. The page needs more horizon context than menu/member/employee pages.

Current available data range verified locally:

- `2024-01-01` to `2026-05-11`
- 862 days
- 4 branches

Therefore the branch page can support:

Operational horizons:

- `y`: latest data date
- `7d`: last 7 days
- `30d`: last 30 days
- `90d`: last 90 days

Structural horizons:

- `ytd`: year-to-date
- `12m`: last 12 months
- `24m`: last 24 months or all available data if less than 24 months
- `all`: all available data

Important:

- Ringkasan should compare active/current health vs structural health.
- Do not judge branch health from 7/30 days alone.
- A branch with weak 30-day margin but healthy 12-month margin is **Early Warning**, not automatically turnaround.
- A branch with weak current and weak structural margin is **Turnaround**.

## 5. Health Classification

Use margin as the primary health metric.

Basic margin thresholds:

- `Sehat`: margin >= 15%
- `Waspada`: margin >= 10% and < 15%
- `Kritis`: margin < 10%

Combined current vs structural classification:

| Current Margin | Structural Margin | Status | Meaning |
|---|---|---|---|
| >= 15% | >= 15% | Sehat | Healthy now and historically healthy. |
| 10-15% | >= 15% | Waspada | Still okay, but active period softened. |
| < 10% | >= 15% | Early Warning | New decline; investigate before major decisions. |
| >= 15% | < 10% | Recovery | Recently improved after weak history. |
| >= 15% | 10-15% | Recovery / Membaik | Current period healthy, historical base still moderate. |
| 10-15% | 10-15% | Stabil Rendah | Consistently moderate, not broken but not ideal. |
| < 10% | < 10% | Turnaround | Current and historical margins are both weak. |
| < 10% | 10-15% | Turnaround Watch | Current weak and history was already mediocre. |

Recommended simplified labels for UI:

- `Sehat`
- `Waspada`
- `Early Warning`
- `Recovery`
- `Stabil Rendah`
- `Turnaround`

Color semantics:

- Sehat: green
- Waspada: yellow
- Early Warning: orange
- Recovery: blue/green
- Stabil Rendah: amber
- Turnaround: red

## 6. Global UI Rules for Page 02

### 6.1 Keep Subpages Light

Each subpage should show at most:

- 1 primary diagnostic section
- 1 supporting chart/table
- 1 optional details section
- 1 small just-in-time accordion

Avoid turning subpages into full dashboards.

### 6.2 Use Just-In-Time Accordions

Do not place all methodology at the bottom.

Instead:

- Put a short accordion before the section where the context is needed.
- Keep each accordion short: 4-6 bullets.
- Default collapsed.
- Do not repeat the same definitions in multiple sections.

### 6.3 Avoid Score-Based Ringkasan

Remove or de-emphasize portfolio health score in Ringkasan.

Use:

- branch margin
- branch health status
- active vs structural classification

### 6.4 Query Result Boxes Must Not Show

The screenshot shows Evidence query result boxes above the page:

- `branch_list`
- `branch_dates`
- `branch_health_overview`
- etc.

These should not be visible in the client-facing page.

Likely causes:

- code fences not being treated as hidden queries because of syntax/layout issue,
- debug/dev display behavior,
- markdown/render issue after refactor.

Acceptance criterion:

- User-facing page must start with title/subtitle/tabs, not query result cards.

## 7. Page-Level Layout

Suggested global top structure:

```text
Title: Performa Cabang
Subtitle: Dashboard portofolio cabang: kesehatan margin, pertumbuhan, profitabilitas, strategi, dan prioritas aksi.

Guide accordion: Cara memilih subpage
Tabs:
[Ringkasan] [Pertumbuhan] [Profitabilitas] [Deep Dive] [Strategi] [Pusat Aksi]
```

The "Cara memilih subpage" accordion should be optional and compact.

Content:

- Ringkasan: cek sehat/tidak sehat per cabang.
- Pertumbuhan: cek cabang naik/turun.
- Profitabilitas: cek penyebab margin bocor.
- Deep Dive: bedah satu cabang.
- Strategi: lihat peran cabang dalam portofolio.
- Pusat Aksi: lihat prioritas kerja.

## 8. Subpage: Ringkasan

### 8.1 Mental Job

Answer:

> Cabang mana sehat, cabang mana baru bermasalah, cabang mana sedang pulih, dan cabang mana bermasalah struktural?

This subpage should be a health triage screen.

### 8.2 What It Should Not Do

Do not include:

- full profitability breakdown
- full growth trend
- long action queue
- deep dive selector
- many charts
- portfolio score as main UI
- too many tables

### 8.3 Controls

Use two-level period control.

Option A, preferred:

```text
Mode Analisis:
[Operasional] [Struktural]

If Operasional:
[Kemarin] [7 Hari] [30 Hari] [90 Hari]

If Struktural:
[YTD] [12 Bulan] [24 Bulan / Semua Data]
```

If Evidence input nesting becomes annoying, use one ButtonGroup with grouped labels:

```text
[Kemarin] [7 Hari] [30 Hari] [90 Hari] [YTD] [12 Bulan] [24 Bulan]
```

But visual grouping should still be clear.

Default:

- `30d`

Reason:

- Branch health is less noisy than daily, but still responsive enough.

### 8.4 Ringkasan UI Order

Final order:

```text
1. Period control
2. Executive hero
3. Branch health cards
4. Current vs structural matrix
5. Optional compact ranking table
6. CTA strip to other subpages
```

If still too dense, remove ranking table from default view and put it in accordion.

### 8.5 Executive Hero

Purpose:

- Give portfolio-level diagnosis without score.

Content:

- count of branches by status
- worst priority branch
- whether issue is short-term or structural
- one next click recommendation

Example:

```text
1 cabang turnaround, 1 early warning, 2 sehat.

Cabang Utara menjadi prioritas karena margin aktif negatif.
Namun margin 12 bulan masih sehat, jadi ini lebih mirip penurunan baru daripada masalah struktural.
```

Hero side card:

```text
Cabang prioritas: Cabang Utara
Margin aktif: -5.0%
Margin 12B: 16.2%
Status: Early Warning
Lanjutkan ke: Profitabilitas / Deep Dive
```

Do not show:

- score number
- long paragraph
- too many metrics

### 8.6 Just-In-Time Accordion Before Branch Cards

Title:

```text
Cara membaca status cabang
```

Content max 6 bullets:

- Sehat: margin aktif dan historis sama-sama sehat.
- Waspada: margin mulai melemah, tapi belum kritis.
- Early Warning: margin aktif buruk, historis masih sehat.
- Recovery: margin aktif membaik, historis masih lemah.
- Stabil Rendah: margin aktif dan historis sama-sama sedang.
- Turnaround: margin aktif dan historis sama-sama lemah.

### 8.7 Branch Health Cards

This is the core of Ringkasan.

One card per branch.

Each card must show:

- Branch name
- Status badge
- Active margin as the largest number
- Structural margin as secondary number
- Active revenue
- Orders
- vs baseline if available
- one short diagnosis
- one suggested subpage link/action

Example:

```text
Cabang Pusat
[Sehat]
Margin 30H: 37.3%

Margin 12B: 22.1%
Revenue 30H: Rp57.6jt
Orders: 709
vs baseline: -1.5%

Diagnosis:
Sehat dan masih layak jadi benchmark.

Lanjut:
Strategi / Pertumbuhan
```

Sort order:

1. Turnaround
2. Early Warning
3. Stabil Rendah
4. Waspada
5. Recovery
6. Sehat

Within same status, sort by active margin ascending.

### 8.8 Current vs Structural Matrix

Purpose:

- Explain short-term vs structural branch condition with one visual.

Accordion before matrix:

Title:

```text
Kenapa bandingkan margin sekarang vs historis?
```

Content:

- Margin 30 hari buruk belum tentu cabang buruk.
- Jika historis sehat, masalahnya mungkin baru muncul.
- Jika historis juga buruk, masalahnya lebih struktural.
- Matrix ini membantu menentukan apakah cabang perlu audit cepat, recovery monitoring, atau turnaround.

Matrix layout:

```text
                    Historis Sehat       Historis Lemah

Sekarang Sehat      Sehat/Benchmark      Recovery

Sekarang Lemah      Early Warning        Turnaround
```

Place branch names inside quadrants.

This matrix should be visually simpler than scatter plot.

### 8.9 Compact Ranking Table

Optional, but useful if kept compact.

Accordion before table:

Title:

```text
Kenapa margin jadi tolak ukur utama?
```

Content:

- Revenue besar belum tentu sehat jika margin bocor.
- Margin aktif menunjukkan kondisi sekarang.
- Margin historis menunjukkan apakah masalahnya baru atau lama.
- Revenue, orders, dan AOV hanya konteks pendukung.

Columns:

- Cabang
- Status
- Revenue aktif
- Orders
- AOV
- Margin aktif
- Margin 12B
- vs baseline
- Diagnosis

Sort:

- worst status first, then active margin ascending.

If branch cards already show all information clearly, table can be collapsed by default.

### 8.10 CTA Strip

At end of Ringkasan, show navigation guidance:

```text
Mau tahu kenapa cabang turun? Buka Profitabilitas.
Mau tahu cabang mana tumbuh? Buka Pertumbuhan.
Mau bedah satu cabang? Buka Deep Dive.
Mau prioritas kerja? Buka Pusat Aksi.
```

This reinforces why subpages exist.

## 9. Subpage: Pertumbuhan

### 9.1 Mental Job

Answer:

> Cabang mana yang naik, turun, stagnan, atau divergen?

This subpage is about movement, not margin diagnosis.

### 9.2 Primary Data

Use only 1-2 data views:

1. Branch growth table/cards.
2. Revenue trend line or WoW/period comparison.

### 9.3 UI Order

```text
1. Period control for growth horizon
2. Hero: growth summary
3. Accordion: Cara membaca pertumbuhan cabang
4. Growth cards/table
5. Trend chart
6. CTA to Profitabilitas/Deep Dive
```

### 9.4 Recommended Periods

For growth:

- 7d vs previous 7d
- 30d vs previous 30d
- 90d vs previous 90d
- 12m trend

Default:

- `30d`

### 9.5 Hero Content

Example:

```text
2 cabang tumbuh, 1 stabil, 1 melemah.

Cabang Utara turun paling tajam dibanding periode sebelumnya.
Jika margin juga turun, lanjutkan ke Profitabilitas.
```

### 9.6 Accordion Before Growth Table

Title:

```text
Cara membaca pertumbuhan cabang
```

Content:

- Pertumbuhan dibaca relatif terhadap periode sebelumnya.
- Revenue naik belum tentu margin sehat.
- Revenue turun belum tentu buruk jika margin membaik.
- Gunakan tab Profitabilitas untuk melihat apakah pertumbuhan menghasilkan laba.

### 9.7 Growth Table/Card

Columns:

- Cabang
- Revenue sekarang
- Revenue sebelumnya
- Perubahan %
- Orders sekarang
- Orders change %
- AOV change %
- Growth status

Status:

- Tumbuh: revenue change >= +10%
- Stabil: -5% to +10%
- Melemah: -5% to -15%
- Turun tajam: < -15%

### 9.8 Trend Chart

Use one chart:

- LineChart revenue by branch over 30/90/365 days.

Do not include too many additional trend charts.

### 9.9 CTA Strip

At bottom:

- If revenue down and margin down: go to Profitabilitas.
- If one branch abnormal: go to Deep Dive.
- If growth positive but revenue concentration high: go to Strategi.

## 10. Subpage: Profitabilitas

### 10.1 Mental Job

Answer:

> Kenapa margin cabang sehat atau bocor?

This subpage is about cost structure and net margin, not growth or strategy.

### 10.2 Primary Data

Use 1-2 main data views:

1. Margin and cost breakdown by branch.
2. Gross vs net or cost component stacked chart.

### 10.3 UI Order

```text
1. Period control
2. Hero: profitability pressure summary
3. Accordion: Cara membaca profitabilitas cabang
4. Margin by branch cards/table
5. Cost breakdown chart
6. Margin trend compact
7. CTA to Deep Dive/Pusat Aksi
```

### 10.4 Periods

Use:

- 30d
- 90d
- YTD
- 12m

Default:

- `90d` or `30d`.

Recommendation:

- If Ringkasan default is 30d, Profitabilitas default can be 90d to avoid overreacting.

### 10.5 Hero Content

Example:

```text
Margin bocor terutama di Cabang Utara.

Biaya bahan dan operasional perlu dicek lebih dulu karena gap margin terhadap target sehat paling besar.
```

### 10.6 Accordion Before Margin Section

Title:

```text
Cara membaca profitabilitas cabang
```

Content:

- Gross revenue menunjukkan skala penjualan.
- Net revenue menunjukkan sisa setelah biaya.
- Net margin adalah ukuran kesehatan utama.
- Cabang omzet besar bisa tidak sehat jika margin rendah.
- Bandingkan margin dengan biaya bahan, SDM, dan operasional.

### 10.7 Main Table/Card

Columns:

- Cabang
- Gross revenue
- Net revenue
- Net margin
- Cost bahan %
- Cost SDM %
- Cost operasional %
- Pressure point

### 10.8 Cost Breakdown Chart

Use one chart:

- stacked cost by branch

or:

- grouped gross vs net and cost breakdown.

Do not show too many charts in Profitabilitas.

### 10.9 Margin Trend Compact

Use small line chart or table:

- branch
- margin 30d
- margin 90d
- margin 12m
- trend status

This section helps separate short-term pressure from structural leak.

## 11. Subpage: Deep Dive

### 11.1 Mental Job

Answer:

> Apa cerita satu cabang tertentu?

This subpage is branch-specific.

### 11.2 Controls

Use branch selector:

```text
Cabang:
[Cabang Pusat] [Cabang Selatan] [Cabang Timur] [Cabang Utara]
```

Optional period selector:

- 30d
- 90d
- 12m

Do not show all branches here.

### 11.3 UI Order

```text
1. Branch selector
2. Branch hero diagnosis
3. Accordion: Cara membaca deep dive cabang
4. Branch scorecard
5. One trend chart
6. One cost/profitability table
7. Next action / link to Pusat Aksi
```

### 11.4 Hero Content

Example:

```text
Cabang Utara sedang early warning.

Margin 30 hari turun tajam, tetapi margin 12 bulan masih sehat.
Fokus audit: 30 hari terakhir, terutama biaya dan demand lokal.
```

### 11.5 Accordion Before Scorecard

Title:

```text
Cara membaca deep dive cabang
```

Content:

- Mulai dari margin aktif.
- Bandingkan dengan margin historis.
- Lihat apakah revenue ikut turun.
- Jika revenue stabil tapi margin turun, cari cost leak.
- Jika revenue turun dan margin turun, cek demand dan operasional.

### 11.6 Branch Scorecard

Show only key metrics:

- Revenue active
- Orders active
- AOV
- Margin active
- Margin 12m
- vs baseline
- cost pressure

### 11.7 Trend Chart

One chart:

- revenue and/or margin trend for selected branch

Do not put many charts here unless they are hidden in accordions.

### 11.8 Diagnostic Table

One compact table:

- metric
- active period
- previous period
- 12m baseline
- interpretation

## 12. Subpage: Strategi

### 12.1 Mental Job

Answer:

> Apa peran tiap cabang dalam portofolio?

This is not about urgent issues. This is about strategic role.

### 12.2 Primary Data

Use:

- revenue scale
- margin health
- growth potential
- structural health

### 12.3 UI Order

```text
1. Strategy hero
2. Accordion: Cara membaca peran cabang
3. Branch role cards
4. Portfolio role matrix
5. Strategic recommendations
```

### 12.4 Role Labels

Suggested roles:

- `Benchmark / Mesin Utama`: revenue high, margin high, stable.
- `Scale-Up Candidate`: margin high, revenue not yet high.
- `Margin Optimization`: revenue high, margin weak.
- `Turnaround`: revenue weak and margin weak.
- `Recovery`: recently improved after weak history.
- `Early Warning`: historically healthy but current decline.

### 12.5 Accordion Before Role Cards

Title:

```text
Cara membaca peran strategis cabang
```

Content:

- Cabang revenue tinggi margin tinggi = benchmark.
- Cabang margin tinggi revenue kecil = kandidat scale-up.
- Cabang revenue tinggi margin rendah = optimasi margin.
- Cabang revenue dan margin rendah = turnaround.
- Peran cabang tidak sama dengan status harian.

### 12.6 Branch Role Cards

One card per branch:

- Branch name
- Strategic role
- Revenue percentile/rank
- Margin 12m
- Growth 90d/12m
- Suggested strategic move

Example:

```text
Cabang Pusat
Role: Benchmark / Mesin Utama
Revenue rank: #1
Margin 12B: 22.1%
Strategi: jadikan standar operasional untuk cabang lain.
```

### 12.7 Matrix

Use matrix:

- X axis: revenue scale
- Y axis: structural margin

Quadrants:

- Benchmark
- Scale-Up
- Margin Optimization
- Turnaround

This matrix can be similar to the existing branch matrix but with strategic language.

## 13. Subpage: Pusat Aksi

### 13.1 Mental Job

Answer:

> Apa yang harus dikerjakan dulu?

This page consolidates action. It should not introduce many new charts.

### 13.2 UI Order

```text
1. Action hero
2. Accordion: Bagaimana prioritas aksi ditentukan
3. Action queue
4. Action grouped by type
5. Optional action detail table
```

### 13.3 Action Hero

Example:

```text
Ada 3 aksi prioritas minggu ini.

Prioritas pertama: audit Cabang Utara karena margin aktif negatif meski historis masih sehat.
```

### 13.4 Accordion Before Action Queue

Title:

```text
Bagaimana prioritas aksi ditentukan?
```

Content:

- Turnaround lebih tinggi dari early warning.
- Early warning tetap penting jika historis sehat tapi margin aktif jatuh.
- Cabang revenue besar dan margin bocor punya dampak lebih besar.
- Recovery dipantau, bukan langsung ditekan.
- Benchmark dipakai sebagai contoh operasi.

### 13.5 Action Queue

Use max 6-8 action cards.

Each action card:

- Severity
- Branch
- Issue
- Evidence
- Impact
- Recommended action
- Suggested next subpage

Example:

```text
[High] Cabang Utara - Early Warning
Evidence: Margin 30H -5%, margin 12B 16%.
Impact: Penurunan baru pada cabang yang sebelumnya sehat.
Action: Audit 30 hari terakhir: biaya bahan, staffing, promo, dan demand lokal.
Next: Profitabilitas + Deep Dive
```

### 13.6 Action Types

Suggested action types:

- Audit margin leak
- Review demand/growth
- Benchmark healthy branch
- Turnaround planning
- Monitor recovery
- Rebalance portfolio dependency

### 13.7 Optional Action Detail Table

Columns:

- Priority
- Branch
- Status
- Active margin
- Structural margin
- Issue
- Action
- Next page

Keep this table compact and below cards.

## 14. Query Design Recommendations

### 14.1 Branch Period Summary

Create or refine one normalized query:

`branch_health_by_period`

Expected columns:

- `period`
- `branch_name`
- `gross_revenue`
- `net_revenue`
- `net_margin_pct`
- `total_orders`
- `aov`
- `baseline_change_pct`
- `status_margin`

Periods:

- y
- 7d
- 30d
- 90d
- ytd
- 12m
- 24m
- all

### 14.2 Branch Health Classification

Create:

`branch_health_classification`

Expected columns:

- `branch_name`
- `active_period`
- `active_margin_pct`
- `structural_margin_pct`
- `active_revenue`
- `active_orders`
- `active_aov`
- `baseline_change_pct`
- `health_status`
- `diagnosis`
- `recommended_next_page`
- `sort_priority`

Default active period:

- 30d

Default structural period:

- 12m, fallback to all if data < 12 months.

### 14.3 Portfolio Counts

Create:

`branch_status_counts`

Expected columns:

- `active_period`
- `sehat_count`
- `waspada_count`
- `early_warning_count`
- `recovery_count`
- `stabil_rendah_count`
- `turnaround_count`
- `priority_branch`
- `priority_status`

### 14.4 Matrix Query

Create:

`branch_current_vs_structural_matrix`

Expected columns:

- `branch_name`
- `current_bucket`: `Sekarang Sehat` / `Sekarang Lemah`
- `structural_bucket`: `Historis Sehat` / `Historis Lemah`
- `quadrant`
- `active_margin_pct`
- `structural_margin_pct`

### 14.5 Action Queue Query

Create/refine:

`branch_action_queue`

Expected columns:

- `priority`
- `severity`
- `branch_name`
- `issue_type`
- `evidence_text`
- `impact_text`
- `recommended_action`
- `next_page`

## 15. UI Components and Classes

Add/refine these classes if not already present:

Base:

- `.branch-page`
- `.page-intro`
- `.inline-link`

Controls:

- `.mode-switch`
- `.period-strip`
- `.period-pill`
- `.pill-badge`

Hero:

- `.hero`
- `.hero-title`
- `.hero-copy`
- `.hero-side`
- `.hero-side-card`

Branch health:

- `.branch-health-grid`
- `.branch-health-card`
- `.branch-health-card.sehat`
- `.branch-health-card.waspada`
- `.branch-health-card.early-warning`
- `.branch-health-card.recovery`
- `.branch-health-card.stabil-rendah`
- `.branch-health-card.turnaround`
- `.branch-status-badge`
- `.branch-margin-main`
- `.branch-margin-structural`
- `.branch-diagnosis`
- `.branch-next-link`

Matrix:

- `.health-matrix`
- `.matrix-cell`
- `.matrix-cell.benchmark`
- `.matrix-cell.early-warning`
- `.matrix-cell.recovery`
- `.matrix-cell.turnaround`
- `.matrix-branch-chip`

Actions:

- `.action-stack`
- `.action-card`
- `.action-card.critical`
- `.action-card.high`
- `.action-card.moderate`
- `.action-card.low`

Accordions:

- `.context-acc`
- `.context-acc .acc-body`

Responsive:

```css
@media (max-width: 900px) {
  .branch-health-grid,
  .period-strip,
  .health-matrix {
    grid-template-columns: 1fr;
  }

  .hero {
    grid-template-columns: 1fr;
  }
}
```

## 16. Just-In-Time Accordion Placement Summary

Use these, not one giant methodology block.

| Section | Accordion Title |
|---|---|
| Page tabs | Cara memilih subpage |
| Branch Health Cards | Cara membaca status cabang |
| Ranking table | Kenapa margin jadi tolak ukur utama? |
| Current vs Structural Matrix | Kenapa bandingkan sekarang vs historis? |
| Growth | Cara membaca pertumbuhan cabang |
| Profitability | Cara membaca profitabilitas cabang |
| Deep Dive | Cara membaca deep dive cabang |
| Strategy | Cara membaca peran strategis cabang |
| Action Queue | Bagaimana prioritas aksi ditentukan? |

Keep every accordion compact.

## 17. Acceptance Criteria

The refinement is complete when:

1. Query debug/result boxes do not appear in client-facing page.
2. Ringkasan no longer relies on a 0-100 score.
3. Ringkasan shows one health card per branch.
4. Each branch card uses margin as the primary health signal.
5. Ringkasan compares active margin vs structural margin.
6. Ringkasan distinguishes at least:
   - Sehat
   - Early Warning
   - Recovery
   - Turnaround
7. Ringkasan contains no more than 1-2 main data sections before CTA.
8. Methodology is distributed as short accordions near relevant sections.
9. Pertumbuhan focuses on movement only.
10. Profitabilitas focuses on margin/cost only.
11. Deep Dive focuses on one branch only.
12. Strategi focuses on portfolio role only.
13. Pusat Aksi focuses on prioritized action only.
14. `npm run build` succeeds from `evidence/`.

## 18. Non-Goals

Do not:

- redesign all pages,
- edit index,
- add external dependencies,
- implement real payback/balik modal unless initial investment data exists,
- call a branch "balik modal" without investment/opening cost data,
- make Ringkasan a complete proof page,
- make every subpage show all available data.

## 19. Payback / Balik Modal Note

The idea of branch payback is valid, but current available dashboard data appears to contain revenue and net revenue, not initial investment.

Do not claim "sudah balik modal" unless a branch investment table exists.

Needed fields:

- `branch_name`
- `opening_date`
- `initial_investment`
- `payback_target_months`

With those fields, a future strategy/deep dive section can calculate:

- cumulative net contribution since opening
- remaining payback amount
- payback progress %
- estimated payback month

Until then, use:

- cumulative net revenue
- all-time net margin
- long-term branch contribution

But label it clearly as contribution, not payback.

## 20. Suggested Final Ringkasan Copy

Hero:

```text
1 cabang turnaround, 1 early warning, 2 sehat.

Cabang Utara menjadi prioritas karena margin aktif turun tajam.
Namun margin 12 bulan masih sehat, jadi ini lebih mirip penurunan baru daripada masalah struktural.
```

Branch cards intro:

```text
Mulai dari status per cabang. Margin aktif menunjukkan kondisi sekarang; margin historis membantu membedakan masalah baru dari masalah struktural.
```

Matrix intro:

```text
Matrix ini memisahkan cabang yang sedang turun sementara dari cabang yang memang perlu turnaround struktural.
```

CTA strip:

```text
Jika ingin tahu cabang mana tumbuh, buka Pertumbuhan.
Jika ingin tahu penyebab margin bocor, buka Profitabilitas.
Jika ingin membedah satu cabang, buka Deep Dive.
Jika ingin daftar kerja, buka Pusat Aksi.
```


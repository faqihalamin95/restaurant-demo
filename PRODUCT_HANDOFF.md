# Restaurant Demo Product Handoff

Last updated: 2026-05-21

## Goal

Turn the Indonesian Evidence dashboard in `evidence/` into a sellable restaurant SaaS pilot. The immediate direction is to rework pages first, not migrate away from Evidence yet.

## Decision

Keep Evidence for now as the analytics/reporting layer. Do not start a full rewrite before the dashboard is sharp enough to sell as a pilot.

The product should move from "dashboard showing data" to "daily action system for restaurant operators."

## Current Product Assessment

- Strong as demo/pitch: 8/10
- Not yet SaaS-ready: 5.5-6/10
- Potential after productization: 8.5/10

Main blockers:
- Build output is too large, about 935 MB.
- Pages are too long and hard to maintain.
- Too much SQL and CSS lives directly in Markdown pages.
- User experience is dense and analyst-oriented.
- No SaaS shell yet: no tenant, auth, role, billing, onboarding, alert workflow, or data sync UI.
- Thresholds are hardcoded and generic.
- PII appears in member/employee pages.

## Verified Technical Status

Command run:

```bash
cd /home/faqih/projects/restaurant-demo/evidence
npm run build
```

Result:
- Build succeeded.
- Build output: `evidence/build`
- Warning: deprecated chart colors for `ReferenceLine` / `ReferenceArea` using values such as `green`, `red`, `yellow`.

Data:
- Main warehouse: `/home/faqih/projects/restaurant-demo/data/warehouse.duckdb`
- Latest observed data date: 2026-05-20

## Business Metrics Snapshot

Latest day:
- Gross revenue: Rp17,402,000
- Net revenue: -Rp2,851,757
- Net margin: -16.4%
- Orders: 268
- AOV: about Rp64,933

30-day branch margin:
- Cabang Utara: -14.2%
- Cabang Timur: 8.1%
- Cabang Selatan: 22.0%
- Cabang Pusat: 34.9%

Menu:
- 16 active menus in 30 days
- Top 5 menus contribute 78.1% of revenue
- 6 weak menus

Inventory:
- 32 stock points
- 8 items
- 4 branches
- 0 low-stock points
- 23 overstock points
- Stock value about Rp169.9M
- Overstock value about Rp130.4M

Peak hours:
- Strongest hours: 12:00, 19:00, 13:00, 18:00, 20:00

Members:
- 700 active members in 90 days
- 9,858 orders
- Rp791.165M spend
- AOV about Rp80,256
- Churn risk: Bronze 1, Gold 7, Silver 9

Workforce:
- 30-day attendance: 92.0%
- Late rate: 11.4%
- Absent count: 35
- Overtime session rate: 19.5%

## Page Rework Priority

1. `evidence/pages/index.md`
   - Rework into Action Center / daily command center.
   - Should be the first screen for selling.
   - Show 3-7 prioritized actions, impact, owner/cabang/menu/item, and status.

2. `evidence/pages/01-laporan-keuangan.md`
   - Keep because it is one of the strongest pages.
   - Make it more decision-first: margin leakage, biggest cost driver, branch needing intervention.

3. `evidence/pages/03-inventori-stok.md`
   - Very SaaS-worthy.
   - Emphasize reorder, overstock, transfer, supplier action.
   - Needs future lead time, shelf life, PO workflow.

4. `evidence/pages/05-menu-performance.md`
   - Very strong commercially.
   - Needs menu margin / food cost before it becomes truly decision-grade.

5. `evidence/pages/02-branch-performance.md`
   - Useful for multi-branch operators.
   - Needs simplification and cleanup of legacy/rework route artifacts.

Second phase:
- `evidence/pages/04-peak-hours.md`
- `evidence/pages/06-member-behavior.md`
- `evidence/pages/07-employee-performance.md`

## Target Page Pattern

Every page should be reworked toward:

1. "Apa yang perlu dilakukan hari ini?"
2. Key KPI/status
3. Diagnosis
4. Recommended action
5. Estimated financial impact if possible
6. Supporting charts
7. Detail table

Avoid making pages feel like analyst notebooks. The buyer is likely an owner/operator who wants decisions.

## Future SaaS Shell

After page rework, build or plan:
- Auth
- Multi-tenant organizations
- Branch-level permissions
- Billing
- Data onboarding/import
- POS connector or CSV upload
- Sync status and data quality checks
- Alerting through WhatsApp/email
- Action/task workflow
- PII masking and audit log

## Worktree Warning

Before any edits, check `git status --short`. There are existing user/local changes. Do not revert unrelated files.


## 2026-05-21 Update - Homepage Rework Started

Completed first V1 rework for `evidence/pages/index.md`:

- Replaced the old 3,701-line dashboard summary with a compact Action Center page.
- New index size is about 32 KB, down from about 199 KB.
- Page now contains:
  - Business Pulse hero
  - Priority Action Queue
  - KPI ringkas
  - Diagnosis per area
  - 7-Day Watchlist
  - Trust Layer
- Build verification passed with `npm run build` from `evidence/`.
- Remaining Evidence deprecation warnings come from other pages, especially `01-laporan-keuangan.md` and `02-branch-performance.md`, not from the new index page.

Current known limitation:
- Action Center SQL still lives inside `index.md` for fast iteration. Later, move repeated logic into dbt marts/source queries: business pulse, action queue, area diagnosis, and watchlist.

Recommended next step:
- Review the new homepage content/UI in browser. If approved, rework `01-laporan-keuangan.md` next into Margin & Cost Control.


## 2026-05-21 Update - Homepage UI Polish

`evidence/pages/index.md` received a visual polish after initial Action Center rework:

- Hero/status panel made more premium and compact.
- Priority cards now have severity treatment and clearer impact column.
- KPI cards tightened into a cleaner strip.
- Diagnosis Area, 7-Day Watchlist, and Trust Layer moved into `details.acc-strategic` accordions similar to Menu Performance page patterns.
- Build verification passed again with `npm run build`.
- Remaining deprecation warnings are still from unreworked pages, not the new homepage.


## 2026-05-21 Update - Homepage Color/Density Polish

Action Center UI was adjusted after feedback that it felt too blended/monotone and KPI cards were too cramped:

- Hero palette made brighter and more differentiated.
- Priority cards now use stronger severity backgrounds and left bars.
- KPI grid changed from 6 narrow columns to 3 larger columns.
- KPI cards now have larger typography and distinct colored accent bars.
- Accordion headers and cards now use cleaner white surfaces with more contrast.
- Build verification passed again.


## 2026-05-21 Update - Homepage Aligned To Finance Design

After feedback, homepage styling was reset to use `01-laporan-keuangan.md` as the design baseline:

- Added finance-style `period-strip` at the top.
- Hero, status side cards, section cards, KPI cards, and accordions now follow the finance page's softer gradient/border language.
- KPI remains 3 columns to avoid cramped cards, but uses finance-like card treatment.
- Removed the louder palette from the previous attempt.
- Build verification passed.


## 2026-05-21 Update - Premium Homepage Pass

Action Center received another premium UI pass after feedback that it still did not feel sellable enough:

- More executive cockpit feel in hero with stronger hierarchy and refined shadows.
- Period strip upgraded with top accent rails and stronger status emphasis.
- Priority queue cards refined with left severity rails, stronger typography, and better impact column.
- KPI cards made larger and more premium with top accent bars and bigger values.
- Accordions/cards use cleaner solid surfaces and more depth.
- Build verification passed.

## 2026-05-21 Update - Action Center Mart Extraction

Action Center logic was moved out of `evidence/pages/index.md` and into dbt:

- Added `dbt_restaurant/models/marts/mart_action_center.sql`.
- Added Evidence source `evidence/sources/restaurant/action_center.sql` pointing to `main_marts.mart_action_center`.
- Updated `dbt_restaurant/models/marts/schema.yml` with section/row tests for the new mart.
- Refactored `evidence/pages/index.md` so its SQL blocks only read `restaurant.action_center` by section.
- The mart includes page-ready sections: `data_freshness`, `business_pulse`, `action_queue`, `kpi_summary`, `area_diagnosis`, and `watchlist`.
- Thresholds consolidated from existing pages: finance margin 10/15%, branch margin 10/15%, inventory low <3 days and overstock >14 days, menu top5 55/70% plus weak/declining menu thresholds, peak share/surge thresholds, member churn recency by tier, workforce attendance/late/absent/overtime thresholds.
- Action Center now includes all main modules, including Peak Hours, Member, and Workforce.

Validation run:

```bash
cd /home/faqih/projects/restaurant-demo/dbt_restaurant
../.venv/bin/dbt run --select mart_action_center
../.venv/bin/dbt test --select mart_action_center

cd /home/faqih/projects/restaurant-demo/evidence
npm run sources
npm run build
```

Results:
- `dbt run`: PASS, created `main_marts.mart_action_center`.
- `dbt test`: PASS, 5 tests.
- `npm run sources`: PASS, `action_center` wrote 27 rows.
- `npm run build`: PASS.
- Remaining build warnings are old Evidence `ReferenceLine color=green/red` warnings from unreworked pages.
- Preview server is responding at `http://localhost:3000/`.

## 2026-05-22 Update - Index Cleanup After UI Feedback

The previous index implementation was not acceptable: it still carried old heavy SQL and duplicated the top flow. It was corrected by replacing `evidence/pages/index.md` with a clean mart-driven page.

Changes:
- `index.md` now has 610 lines and only queries `restaurant.action_center` sections.
- No direct `restaurant.daily_*`, inventory, menu, member, employee, peak source logic remains in `index.md`.
- Removed the duplicate hero flow. Top structure is now: title/description, four summary cards, Priority Queue, KPI, Diagnosis, Watchlist, Trust Layer.
- Added `summary_cards` section to `mart_action_center`; card label/value/copy/status class now comes from dbt, not Svelte conditional logic.
- Summary cards use soft semantic classes: `kritis`, `waspada`, `sehat`, `netral`.

Validation:
- `dbt run --select mart_action_center`: PASS.
- `dbt test --select mart_action_center`: PASS.
- `npm run sources`: PASS, `action_center` wrote 32 rows.
- `npm run build`: PASS.
- Preview responds at `http://localhost:3000/`.

## 2026-05-22 Update - Index Minimal Redesign

After direct feedback that the index design was ugly, repetitive, over-headed, and hard to read, the page was simplified again:

- `evidence/pages/index.md` is now 562 lines.
- Removed repeated headings/eyebrows from the first viewport.
- Top copy is reduced to one title and one short paragraph.
- Summary cards now use short labels: Status, Margin, Cabang, Risiko.
- Summary card copy is shortened in `mart_action_center` rather than hardcoded in Svelte.
- KPI, diagnosis, watchlist, and trust layer are moved into quieter accordions so they do not compete with the action queue.
- Typography switched to system UI style, lower font weight, no negative letter spacing.
- The page no longer contains direct heavy source logic or old SQL blocks.

Validation:
- `dbt run --select mart_action_center`: PASS.
- `dbt test --select mart_action_center`: PASS.
- `npm run sources`: PASS.
- `npm run build`: PASS.
- Preview responds at `http://localhost:3000/`.

## 2026-05-22 Update - Original Index Restored With SQL Extracted

User asked to go back to the original repo index design, but clean the SQL out of the page.

Implemented:
- Restored `evidence/pages/index.md` content/structure from `HEAD:evidence/pages/index.md` (original `Wekadata — Ringkasan Performa Bisnis`).
- Extracted all 78 original SQL blocks into Evidence source files named `evidence/sources/restaurant/idx_*.sql`.
- Replaced every SQL block in `index.md` with a short `SELECT * FROM restaurant.idx_*` query.
- Source SQL table references were remapped from Evidence page names to warehouse tables, e.g. `restaurant.daily_revenue` -> `main_marts.mart_daily_revenue`.

Validation:
- Confirmed `index.md` has 78 SQL blocks and all 78 are short source selects.
- `npm run sources`: PASS; all `idx_*` sources processed.
- `npm run build`: PASS.
- Preview responds at `http://localhost:3000/`.

Notes:
- The original index design/warnings are back, including old `ReferenceLine`/`ReferenceArea` color deprecation warnings from the original page.
- `mart_action_center` still exists from the previous Action Center work, but the restored original index no longer depends on it.

## 2026-05-28 Update - Employee Performance Cockpit Polish

`evidence/pages/07-employee-performance.md` was polished using `01-laporan-keuangan.md` as the visual/executive-flow reference and `05-menu-performance.md` as the action-triage reference.

Implemented:
- Added page intro explaining the Finance-style diagnosis + Menu-style action triage pattern.
- Added `workforce_today_actions` so urgent roster actions are based only on the latest attendance date, separate from 30-day structural coaching/capacity signals.
- Split `Pusat Aksi Workforce` into `Aksi Hari Ini` and `Pola 30 Hari`, with snapshot counts for daily actions, discipline issues, and capacity pressure.
- Refined coverage framing: `leave`/cuti is shown separately from `absent`; cuti is treated as a valid employee status that still requires operational backfill.
- Updated KPI/period copy and hero notes to show coverage gap, absent, cuti, and overtime distinctly.
- Moved `Total Revenue Ditangani` into a strategic accordion so total revenue remains context, not the main employee ranking.

Validation:
- `npm run sources` from `evidence/`: PASS.
- `npm run build` from `evidence/`: PASS.
- Build still emits existing Evidence deprecation warnings for old `ReferenceLine`/`ReferenceArea` color names; no new blocking errors.

## 2026-05-28 Update - Employee Performance Subpage Refactor

`evidence/pages/07-employee-performance.md` was refactored from one long linear page into a Performa Menu-style view/subpage experience using `ButtonGroup name=workforce_view`.

Views now available:
- `Ringkasan`: default cockpit with period strip, hero, KPI, signal cards, and Pusat Aksi Workforce.
- `Coverage`: shift/cabang coverage, absent/cuti distribution, attendance trend, and status mix.
- `Overtime`: overtime pressure by shift/cabang, overtime trend, and top overtime employees.
- `Produktivitas`: normalized productivity, role diagnostics, and total revenue handled as an accordion-only context section.
- `Coaching`: coaching queue plus workforce health/productivity/caveat methodology.

Reasoning:
- Keeps the manager-facing first screen lighter and closer to Finance/Menu executive patterns.
- Preserves detailed analytics without forcing every chart/table into one scroll.
- Keeps implementation in one Evidence page for now; it is a UX subpage pattern, not route splitting.

Validation:
- `npm run build` from `evidence/`: PASS.
- Existing Evidence color deprecation warnings remain from older chart components; no blocking errors.

## 2026-06-01 Update - Employee Performance KISS Pass

`evidence/pages/07-employee-performance.md` was refactored toward the KISS / owner decision notebook direction:

- Ringkasan now behaves like a mini command center: Status Utama, Analisis Primer, Analisis Sekunder, Perlu Perhatian, Masih Aman, and a deep-dive map.
- The dense Kesiapan Shift evidence was moved out of Ringkasan into the `Kesiapan Shift` subpage branch so the summary stays readable for non-technical owners.
- The `Coverage` user-facing label is now `Kesiapan Shift`; internal value remains `coverage` to preserve existing logic.
- Kesiapan Shift keeps period-specific framing: Kemarin = evaluation, 7 Hari = short-term pattern, 30 Hari = structural roster decision.
- Added responsive rules for the new summary grids.
- Validation: `npm run build` in `evidence/` passed. Preview returned HTTP 200 at `http://localhost:3000/07-employee-performance`. Remaining warnings are old deprecated Evidence `ReferenceArea/ReferenceLine` color warnings.

## 2026-06-02 Update - Employee Performance Index-Style Thresholds

`evidence/pages/07-employee-performance.md` was adjusted after feedback to make the summary read more like the index page:

- Added a `Ringkasan 4 Indikator Pegawai` panel that counts healthy / warning / critical signals.
- The four signals are Kesiapan Shift, Kehadiran, Keterlambatan, and Overtime.
- Each signal now shows its current value plus the explicit threshold for Sehat / Waspada / Kritis.
- Primary analysis cards now also include threshold lines so non-technical owners can immediately see why a metric is considered safe or risky.
- Thresholds were aligned with the page's workforce health methodology: attendance Sehat >=92%, Waspada 85-91%, Kritis <85%; late Sehat <10%, Waspada 10-19%, Kritis >=20%; overtime Sehat <20%, Waspada 20-34%, Kritis >=35%.
- Validation: `npm run build` in `evidence/` passed; preview returned HTTP 200 at `/07-employee-performance`. Remaining warnings are old deprecated Evidence chart color warnings.

## 2026-06-02 Update - Employee Performance Indicator Hierarchy

After discussion, the employee performance summary now uses a hierarchy instead of treating all workforce indicators equally:

- Index should remain lightweight with the two primary workforce indicators: Kehadiran and Keterlambatan.
- Employee Performance page keeps deeper context but separates it into tiers.
- Ringkasan now has `Ringkasan 2 Indikator Utama`: Kehadiran and Keterlambatan.
- `Analisis Pendukung Operasional` now contains Kesiapan Shift and Overtime.
- `Analisis Primer` cards show Kehadiran and Keterlambatan.
- `Analisis Sekunder` cards explain Kesiapan Shift and Overtime as capacity/roster context.
- `Analisis Tersier` contains Role Rawan, Cabang Rawan, Produktivitas, and Coaching.
- Validation: `npm run build` in `evidence/` passed; preview returned HTTP 200 at `/07-employee-performance`.

## 2026-06-02 Update - Employee Summary Accordion Context

Employee Performance summary was refined again based on feedback:

- Explanatory cards for the two primary workforce indicators are now inside an accordion directly under `Ringkasan 2 Indikator Utama`.
- Explanatory cards for Kesiapan Shift and Overtime are now inside an accordion directly under `Sinyal Penyebab Operasional`.
- Removed user-facing labels `Analisis Primer`, `Analisis Sekunder`, and `Analisis Tersier`; current labels are more owner-friendly: `Makna Angka Utama`, `Penyebab Operasional`, and `Konteks Lanjutan`.
- Validation: `npm run build` in `evidence/` passed; preview returned HTTP 200 at `/07-employee-performance`.


## 2026-06-02 Update - Employee Shift Risk Pattern Reframe

`evidence/pages/07-employee-performance.md` coverage subpage was reframed from future/present readiness into historical reporting and pattern reading:

- User-facing label changed from `Kesiapan Shift` to `Pola Risiko Shift`; internal view value remains `coverage`.
- The page explicitly says it does not read today/tomorrow readiness because there is no future roster integration yet.
- `Kemarin` is simple reporting/evaluation: employees absent/late and shift/cabang/role issues from the latest data date.
- `7 Hari` reads short-term daily patterns.
- `30 Hari` reads weekly/structural patterns for roster, backup staff, or hiring review.
- Added weekly 30H query and period-specific accordions so tables are not side-by-side and cognitive load stays low.

Validation:
- `timeout 180s npm run build` in `evidence/`: PASS.
- Static build output contains `Pola Risiko Shift` and no `Kesiapan Shift` label.
- Existing deprecated Evidence `ReferenceArea/ReferenceLine` color warnings remain.

## 2026-06-02 Update - Employee Overtime Reframe

`evidence/pages/07-employee-performance.md` overtime subpage was reframed as capacity pressure, not individual achievement:

- Overtime is now explained as a signal of capacity pressure, understaffing, demand spike, or roster imbalance.
- `Kemarin` is a simple report: who had overtime and where it happened.
- `7 Hari` reads daily short-term patterns: days, shifts, and branches that repeatedly create overtime.
- `30 Hari` reads weekly/structural patterns for roster, backup staff, or hiring review.
- Added `overtime_weekly_30d` and period-specific helper constants.
- Heavy tables are now inside accordions and stacked vertically.

Validation:
- `timeout 180s npm run build` in `evidence/`: PASS.
- Existing deprecated Evidence `ReferenceArea/ReferenceLine` color warnings remain.


## 2026-06-03 Update - Overtime Definition Copy

`evidence/pages/07-employee-performance.md` overtime subpage copy was clarified for non-technical owners:

- `Cara membaca Tekanan Overtime` now defines overtime as working beyond the scheduled/normal shift hours.
- Added a concrete example: scheduled 08:00-15:00 but working until 17:00 means 2 overtime hours.
- Reinforced that overtime is a capacity/operational pressure signal, not automatic proof that an employee is better or more diligent.

Validation:
- `timeout 180s npm run build` in `evidence/`: PASS.
- Existing deprecated Evidence `ReferenceArea/ReferenceLine` color warnings remain.


## 2026-06-03 Update - Overtime Date Labels and 7H Employee Sync

`evidence/pages/07-employee-performance.md` was adjusted after finding a mismatch in the Overtime 7H subpage:

- Daily tables now use a formatted `tanggal` label (`dd Mon yyyy`) instead of raw date rendering.
- Weekly 30H tables now use `periode` as a date range (`start - end`) instead of showing only the week start date.
- `top_overtime_employees_period` no longer applies a global `LIMIT 30`, which could let 30H rows crowd out 7H rows before the UI filtered `activePeriod`.
- This fixes the case where shift/cabang showed overtime in 7H but `Pegawai dengan overtime 7H` was empty.

Validation:
- `timeout 180s npm run build` in `evidence/`: PASS.
- Existing deprecated Evidence `ReferenceArea/ReferenceLine` color warnings remain.


## 2026-06-03 Update - Employee Productivity Subpage KISS Pass

`evidence/pages/07-employee-performance.md` productivity subpage was reframed for owner-friendly reading:

- Added `Cara membaca Produktivitas` explaining productivity as output per labor hour, not raw total revenue.
- `Kemarin` is treated as too short for productivity ranking; users are directed to 7H/30H.
- `7 Hari` reads short-term productivity patterns; `30 Hari` reads more stable benchmark/training/roster patterns.
- Main summary now highlights Revenue/Jam + Order/Jam, top shift-role combination, and standout employee with context.
- Deep dives are accordion-based: Shift x Role, Pegawai, Role diagnosis, and Total Revenue as context only.
- `productivity_by_shift_role` and `role_diagnostics_period` ordering now prioritizes `revenue_per_hour` so top cards match the primary metric.
- During the edit, summary/coverage/overtime branches were restored into the activeView structure after an initial replace hit the period-copy occurrence; final build passed.

Validation:
- `timeout 180s npm run build` in `evidence/`: PASS.
- Existing deprecated Evidence `ReferenceArea/ReferenceLine` color warnings remain.


## 2026-06-03 Update - Employee Follow-Up Actions Subpage

`evidence/pages/07-employee-performance.md` final employee subpage was reframed from `Coaching` into `Tindak Lanjut Pegawai`:

- Tab label changed to `Tindak Lanjut`; internal activeView value remains `coaching` to preserve wiring.
- Subpage now explains that recommendations can include coaching, review/rotasi shift, backup coverage, and reward/benchmark.
- Uses existing `workforce_action_queue`, `structuralCapacityActions`, `structuralDisciplineActions`, `activeAttendanceProblems`, and benchmark actions.
- Adds an action summary at the top: total priority actions, roster/capacity actions, and coaching actions.
- Adds accordion deep dives: roster/rotasi/backup coverage, coaching discipline/jadwal, reward/benchmark employees, and full action table.
- Copy points owners to `Pola Risiko Shift`, `Overtime`, `Produktivitas`, and `Jam Sibuk` for deep dives before changing rosters.

Validation:
- `timeout 180s npm run build` in `evidence/`: PASS.
- Existing deprecated Evidence `ReferenceArea/ReferenceLine` color warnings remain.


## 2026-06-03 Update - Employee Follow-Up Simplification

`evidence/pages/07-employee-performance.md` Tindak Lanjut subpage was simplified after feedback that it was too table-heavy:

- Removed the separate explanatory accordion; explanation is now integrated directly into the main sections.
- Reduced tables to one optional `Detail rekomendasi lengkap` accordion used as an audit trail.
- Added a primary `Rekomendasi Jadwal Shift` section with cards for rotasi beban, backup coverage, and coaching jadwal.
- Added practical copy that recommends using `Jam Sibuk`, `Pola Risiko Shift`, `Overtime`, and `Produktivitas` before manually arranging shifts.
- Reward/retention remains a card-based section instead of a table-first section.

Validation:
- `timeout 180s npm run build` in `evidence/`: PASS.
- Existing deprecated Evidence `ReferenceArea/ReferenceLine` color warnings remain.


## 2026-06-03 Update - Follow-Up UI Full Redesign

`evidence/pages/07-employee-performance.md` Tindak Lanjut subpage was redesigned again after feedback that the UI still felt messy:

- Replaced the multi-section/card-heavy layout with one main decision panel.
- Final structure: one primary panel, three action cards (`Atur Shift`, `Coaching`, `Reward`), one short recommendation list, and one detail-data accordion.
- Added dedicated follow-up CSS classes (`followup-panel`, `followup-grid`, `followup-card`, `followup-list`, `followup-item`) for cleaner visual hierarchy.
- Removed separate recommendation shift/reward sections and kept the table only in `Detail data rekomendasi` as audit trail.
- Copy now emphasizes roster fairness: do not keep assigning the best employees to the busiest shifts; rotate load, prepare backup coverage, and use benchmark employees as mentors/SOP examples.

Validation:
- `timeout 180s npm run build` in `evidence/`: PASS.
- Existing deprecated Evidence `ReferenceArea/ReferenceLine` color warnings remain.


## 2026-06-03 Update - Follow-Up Matches Member Action Center

`evidence/pages/07-employee-performance.md` Tindak Lanjut subpage was changed to match the `Pusat Aksi` design pattern from `evidence/pages/06-member-behavior.md`:

- Renamed the visible subpage heading to `Pusat Aksi Pegawai` with `Daftar Kerja` tag.
- Structure now mirrors Member Action Center: context accordion, section-card header, 3 `analysis-card` explanation cards, priority action cards, chart insight, and one detail table accordion.
- Added `retention-stack`, `retention-card`, and related classes to the employee page so action cards visually match member retention cards.
- Removed unused `followup-*` CSS from the previous redesign.
- Action cards show severity + rank, action label, subject, reason, impact, and recommended step, similar to member action center cards.

Validation:
- `timeout 180s npm run build` in `evidence/`: PASS.
- Existing deprecated Evidence `ReferenceArea/ReferenceLine` color warnings remain.

## 2026-06-03 Update - Employee Action Center Methodology Integration

`evidence/pages/07-employee-performance.md` Pusat Aksi Pegawai bottom methodology stack was removed and integrated into relevant analysis contexts:

- Removed the final stacked accordions for workforce health, productivity/hour, and coaching caveats.
- Moved productivity/hour calculation into `Cara membaca Produktivitas`, where the metric is actually used.
- Moved coaching/triage caveats into `Cara membaca Pusat Aksi Pegawai`, including leave rights and validation before personal action.
- Kept attendance/late thresholds in the main Ringkasan indicator context instead of repeating a global workforce-health block at the end.
- Result: the page now ends after the action cards/detail audit table, without a heavy methodology dump.

Validation:
- `timeout 180s npm run build` in `evidence/`: PASS.
- Existing deprecated Evidence `ReferenceArea/ReferenceLine` color warnings remain.


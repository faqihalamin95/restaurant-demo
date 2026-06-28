# Claude Execution Spec: Rework Page 07 Employee Performance

This document is intended to be sent directly to Claude or another coding agent. It is a detailed implementation brief for reworking `evidence/pages/07-employee-performance.md` into a final **Workforce Cockpit**.

## 0. One-Sentence Goal

Rework `evidence/pages/07-employee-performance.md` from a report-style employee analysis page into a decision cockpit that helps a restaurant manager identify staffing coverage risk, attendance discipline issues, overtime pressure, productivity patterns, and coaching priorities.

## 1. Repository Context

Project type:

- Evidence dashboard project.
- Main working directory for this task: `evidence/`.
- Target file: `evidence/pages/07-employee-performance.md`.

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

Other useful references:

- `evidence/pages/05-menu-performance.md` if it has already been reworked into cockpit style.
- `evidence/pages/06-member-behavior.md` if it has already been reworked into cockpit style.
- `evidence/pages/03-inventori-stok.md` for action queue patterns.
- `evidence/pages/04-peak-hours.md` for concise executive narrative and use of `{@const ...}`.

Do not edit these files unless explicitly asked:

- `evidence/pages/01-laporan-keuangan.md`
- `evidence/pages/02-branch-performance.md`
- `evidence/pages/03-inventori-stok.md`
- `evidence/pages/04-peak-hours.md`
- `evidence/pages/05-menu-performance.md`
- `evidence/pages/06-member-behavior.md`
- any `evidence_en/` directory if present.

## 2. Current Page Problem

Current `07-employee-performance.md` already has useful analysis:

- 30-day employee summary.
- attendance alert.
- attendance problem count.
- attendance distribution.
- attendance daily trend.
- attendance by day of week.
- shift performance.
- overtime by shift/branch/role.
- top overtime employees.
- role performance.
- top employees by revenue handled.
- revenue per hour normalization.
- attendance problem table.

The problem is hierarchy:

- Page opens as a 30-day HR/performance report, not as an operational workforce cockpit.
- Important coaching/attendance risk appears too low on the page.
- Overtime is present, but not integrated into a single staffing pressure diagnosis.
- Top employees by total revenue can be misleading because shift duration, role, traffic, and attendance context matter.
- Revenue per hour is good, but appears late.
- There is no central `workforce_health_overview` that controls status and focus.
- There is no top-level coaching or scheduling action queue.
- The page uses `BigValue`, free-floating headings, and inline alert blocks rather than cockpit UI.

## 3. Product Intent

The page should answer these questions quickly:

1. Is workforce coverage healthy?
2. Are attendance issues threatening operations?
3. Is overtime becoming a staffing pressure signal?
4. Which shift/branch is most under pressure?
5. Is productivity being measured fairly across shift and role?
6. Which employee needs coaching, support, schedule adjustment, or recognition?
7. What should the manager do next?

The page should not feel like a generic HR report. It should help managers run shifts better.

## 4. Target User

Primary user:

- Restaurant manager, area manager, shift lead, or owner.

They need:

- quick coverage diagnosis,
- attendance and late-risk visibility,
- overtime pressure detection,
- normalized productivity,
- coaching priorities,
- schedule adjustment recommendations.

Secondary user:

- Analyst/dashboard builder.

They need:

- detailed tables,
- role/shift diagnostics,
- definitions and caveats.

Therefore use 3 layers:

1. L1 cockpit: status, diagnosis, priority action.
2. L2 diagnostic evidence: shift coverage, overtime, productivity, coaching queue.
3. L3 analyst detail: role/branch tables, definitions, caveats.

## 5. Design Positioning

Final page name:

- `Performa Pegawai`

Final page concept:

- **Workforce Cockpit**

Suggested subtitle:

> Cockpit tenaga kerja: pantau kehadiran, tekanan shift, overtime, produktivitas, dan prioritas coaching.

Tone:

- Operational.
- Fair.
- Specific.
- Avoid blaming employees without context.

Important framing:

- Attendance and lateness are operational signals, but causes can include schedule design, role pressure, branch demand, or personal issues.
- Overtime is not automatically good. It can mean understaffing.
- Total revenue handled is not a fair employee ranking by itself.
- Normalized metrics such as revenue/hour or orders/hour are more useful for comparison.

Key vocabulary:

- coverage risk,
- disiplin kehadiran,
- keterlambatan,
- absent,
- shift pressure,
- overtime pressure,
- coaching queue,
- schedule adjustment,
- productivity normalized,
- revenue per jam,
- order per jam,
- role context,
- branch pressure.

Avoid:

- framing employees as problems without context,
- celebrating overtime as productivity,
- using total revenue handled as the main ranking,
- comparing roles directly without role context,
- implying punitive action from one-week signal alone.

## 6. Data Source Contract

Use only:

```sql
restaurant.employee_shift_performance
```

Known columns used by the current page:

- `attendance_date`
- `employee_id`
- `employee_name`
- `role`
- `branch_name`
- `shift_id`
- `shift_name`
- `attendance_status`
- `orders_handled`
- `total_revenue`
- `avg_ticket`
- `overtime_hours`

Important data rule:

- Anchor all date logic to `MAX(attendance_date)` from `restaurant.employee_shift_performance`.
- Do not use `CURRENT_DATE`.
- "Kemarin" means latest available attendance date in the dataset, not necessarily calendar yesterday.

Attendance status assumptions:

- `present`: attended on time.
- `late`: attended but late.
- `absent`: absent.
- `leave`: approved leave/cuti.

Use `present` and `late` as working sessions. Treat `absent` and `leave` separately in analysis; do not equate leave with misconduct.

Shift duration assumption used by current page:

```sql
CASE shift_id
    WHEN 'S1' THEN 7
    WHEN 'S2' THEN 8
    WHEN 'S3' THEN 7
    ELSE 7
END AS shift_duration_hours
```

This is a demo assumption and must be documented.

## 7. File Scope

Edit:

- `evidence/pages/07-employee-performance.md`

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
7. `.workforce-page` wrapper.
8. Page intro.
9. Period strip.
10. Active-period hero cockpit.
11. KPI grid.
12. Signal cards.
13. Workforce Action Queue.
14. Shift Coverage and Attendance.
15. Overtime Pressure.
16. Normalized Productivity.
17. Role and Branch Diagnostics.
18. Employee Detail Tables.
19. Methodology and caveat accordions.
20. Empty state fallback.

Recommended render skeleton:

```svelte
---
title: Performa Pegawai
---

_Cockpit tenaga kerja: pantau kehadiran, tekanan shift, overtime, produktivitas, dan prioritas coaching._

<style>
/* local page styles */
</style>

```sql workforce_dates
...
```

...

<ButtonGroup name=period>
  <ButtonGroupItem valueLabel="Kemarin" value="y" />
  <ButtonGroupItem valueLabel="7 Hari" value="7d" default />
  <ButtonGroupItem valueLabel="30 Hari" value="30d" />
</ButtonGroup>

{#if workforce_health_overview.length > 0 && workforce_dates.length > 0}
<div class="workforce-page">
  ...
</div>
{:else}
<div class="section-card">
  <h3 class="section-title">Data pegawai belum tersedia.</h3>
  <p class="section-copy">Pastikan source restaurant.employee_shift_performance sudah ter-refresh.</p>
</div>
{/if}
```

## 9. Period Strategy

Use:

- `y`: latest attendance date, for immediate coverage/absence issues.
- `7d`: default weekly operating pulse.
- `30d`: structural workforce pattern.

Default:

- `7d`

Why:

- Daily data is useful for urgent staffing.
- 7 days is better for schedule/action decisions.
- 30 days is better for patterns such as repeated lateness, overtime, and productivity.

## 10. UI Style Requirements

Create a local style block in `07-employee-performance.md`.

Use page 01 style as base. Use workforce-specific class names where useful.

### 10.1 Base Classes

Required:

- `.over-container`
- `details`
- `details > summary`
- `.acc-body`
- `details.acc-strategic`
- `.workforce-page`
- `.page-intro`
- `.inline-link`

Behavior:

- Hide `.over-container`.
- `.workforce-page` uses flex column with ~24px gap.
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

Content:

- Kemarin: attendance rate, absent count, late count.
- 7 Hari: attendance rate, late rate, overtime sessions.
- 30 Hari: attendance problem count, overtime pressure, productivity baseline.

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

- Diagnose workforce status.
- Identify main pressure: coverage, lateness, overtime, productivity gap, or healthy.
- Recommend next managerial action.

Hero side cards:

1. Active period date range.
2. Priority branch/shift/role under pressure.

### 10.4 KPI Grid

Required:

- `.kpi-grid`
- `.kpi-card`
- `.kpi-card.attendance`
- `.kpi-card.late`
- `.kpi-card.coverage`
- `.kpi-card.overtime`
- `.kpi-card.productivity`
- `.kpi-label`
- `.kpi-value`
- `.kpi-meta`

Recommended KPI cards:

1. Attendance Rate.
2. Late Rate.
3. Absent Count.
4. Overtime Hours or Overtime Session %.
5. Revenue per Labor Hour.
6. Orders per Labor Hour.

If top area feels crowded, show 4 cards:

1. Attendance Rate.
2. Late Rate.
3. Overtime Pressure.
4. Revenue per Labor Hour.

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

- `Coverage risk`: schedule backup / branch or shift coverage.
- `Attendance discipline`: review recurring absent/late patterns.
- `Overtime pressure`: audit staffing capacity.
- `Productivity gap`: compare by role and shift before action.
- `Sehat`: maintain roster and recognize high normalized productivity.

### 10.6 Section Cards

Required:

- `.section-card`
- `.section-head`
- `.section-head.tight`
- `.section-eyebrow`
- `.section-title`
- `.section-copy`

Every major chart/table should be inside a section card.

### 10.7 Workforce Action Queue Classes

Required:

- `.workforce-action-stack`
- `.workforce-action-card`
- `.workforce-action-card.critical`
- `.workforce-action-card.high`
- `.workforce-action-card.moderate`
- `.workforce-action-card.low`
- `.action-header`
- `.action-severity`
- `.action-badge`
- `.action-title`
- `.action-impact`
- `.action-rec`

The action queue should appear before detailed charts and tables.

### 10.8 Coverage and Coaching Classes

Required:

- `.coverage-grid`
- `.coverage-card`
- `.pressure-grid`
- `.pressure-card`
- `.coaching-stack`
- `.coaching-card`
- `.coaching-card.attendance`
- `.coaching-card.overtime`
- `.coaching-card.productivity`
- `.coaching-label`
- `.coaching-title`
- `.coaching-copy`

Use these to present operational actions without relying only on tables.

### 10.9 Responsive Rules

Add:

```css
@media (max-width: 900px) {
  .period-strip,
  .kpi-grid,
  .signal-grid,
  .coverage-grid,
  .pressure-grid {
    grid-template-columns: 1fr;
  }

  .hero {
    grid-template-columns: 1fr;
  }
}
```

Also ensure:

- no table is the only way to understand the section,
- no chart/table sequence becomes too long,
- no text blocks are too long on mobile,
- no nested cards inside cards.

## 11. SQL Query Contract

Use these query names unless there is a strong reason to split or rename:

1. `workforce_dates`
2. `workforce_health_period`
3. `workforce_health_overview`
4. `workforce_kpi_period`
5. `workforce_action_queue`
6. `attendance_mix_period`
7. `attendance_by_branch_period`
8. `attendance_daily_trend`
9. `attendance_by_dayofweek`
10. `shift_coverage_period`
11. `shift_movement_period`
12. `overtime_pressure_period`
13. `overtime_by_branch_period`
14. `overtime_trend`
15. `productivity_by_employee_period`
16. `productivity_by_shift_role`
17. `role_diagnostics_period`
18. `attendance_problem_period`
19. `top_overtime_employees_period`

If Evidence build fails due to query complexity, split into smaller queries. Keep rendered page contract the same.

### 11.1 `workforce_dates`

Purpose:

- Date labels for period strip and hero side card.

Expected columns:

- `tgl_akhir`
- `tgl_7_awal`
- `tgl_30_awal`

Template:

```sql
SELECT
    strftime('%d %b %Y', MAX(attendance_date)) AS tgl_akhir,
    strftime('%d %b %Y', MAX(attendance_date) - INTERVAL '6 days') AS tgl_7_awal,
    strftime('%d %b %Y', MAX(attendance_date) - INTERVAL '29 days') AS tgl_30_awal
FROM restaurant.employee_shift_performance
```

### 11.2 Shared Period Logic

Use this conceptual period table:

```sql
WITH max_d AS (
    SELECT MAX(attendance_date) AS d
    FROM restaurant.employee_shift_performance
),
periods AS (
    SELECT 'y' AS period,
           d AS start_date,
           d AS end_date,
           d - INTERVAL '7 days' AS prev_start,
           d - INTERVAL '7 days' AS prev_end
    FROM max_d
    UNION ALL
    SELECT '7d',
           d - INTERVAL '6 days',
           d,
           d - INTERVAL '13 days',
           d - INTERVAL '7 days'
    FROM max_d
    UNION ALL
    SELECT '30d',
           d - INTERVAL '29 days',
           d,
           d - INTERVAL '59 days',
           d - INTERVAL '30 days'
    FROM max_d
)
```

Meaning:

- `y`: latest attendance date compared with same weekday one week earlier.
- `7d`: last 7 days vs previous 7 days.
- `30d`: last 30 days vs previous 30 days.

### 11.3 `workforce_health_period`

Purpose:

- One row per period with status and core workforce diagnostics.

Expected columns:

- `period`
- `status`
- `focus`
- `total_employees`
- `scheduled_sessions`
- `working_sessions`
- `attendance_rate`
- `late_rate`
- `absent_count`
- `leave_count`
- `problem_employee_count`
- `total_orders`
- `total_revenue`
- `revenue_per_labor_hour`
- `orders_per_labor_hour`
- `total_overtime_hours`
- `overtime_session_pct`
- `top_pressure_branch`
- `top_pressure_shift`
- `top_pressure_role`

Definitions:

- `scheduled_sessions`: all rows in period.
- `working_sessions`: `attendance_status IN ('present', 'late')`.
- `attendance_rate`: working sessions / scheduled sessions.
- `late_rate`: late sessions / working sessions or scheduled sessions; pick one and document it. Recommended: late / working sessions.
- `absent_count`: count of absent sessions.
- `leave_count`: count of leave sessions.
- `problem_employee_count`: employees with absent >= 2 or late >= 4 in 30d, adjusted proportionally for shorter periods if needed.
- `revenue_per_labor_hour`: total revenue / estimated working labor hours.
- `orders_per_labor_hour`: total orders / estimated working labor hours.
- `overtime_session_pct`: working sessions with overtime > 0 / working sessions.

Health status rules:

- `Kritis` if:
  - `attendance_rate < 85`, or
  - `late_rate >= 20`, or
  - `absent_count >= 5` for 7d/30d or `absent_count >= 3` for y, or
  - `overtime_session_pct >= 35`, or
  - `problem_employee_count >= 5`
- `Waspada` if:
  - `attendance_rate < 92`, or
  - `late_rate >= 10`, or
  - `absent_count >= 2`, or
  - `overtime_session_pct >= 20`, or
  - `problem_employee_count >= 2`
- `Sehat` otherwise.

Focus rules:

- `Coverage risk` if absent count or attendance rate is the strongest concern.
- `Keterlambatan` if late rate is the strongest concern.
- `Overtime pressure` if overtime session pct or total overtime is the strongest concern.
- `Produktivitas` if productivity drops materially vs previous period.
- `Workforce sehat` otherwise.

Implementation suggestion:

1. Aggregate base rows by period.
2. Calculate labor hours only for present/late rows.
3. Calculate attendance and overtime metrics.
4. Calculate problem employees separately and join.
5. Calculate top pressure branch/shift/role from a pressure score.

### 11.4 `workforce_health_overview`

Purpose:

- Pivot `workforce_health_period` into one row for period strip and hero.

Expected columns:

- `status_y`, `focus_y`, `attendance_y`, `late_y`, `absent_y`, `overtime_pct_y`, `rev_per_hour_y`, `pressure_branch_y`, `pressure_shift_y`
- `status_7d`, `focus_7d`, `attendance_7d`, `late_7d`, `absent_7d`, `overtime_pct_7d`, `rev_per_hour_7d`, `pressure_branch_7d`, `pressure_shift_7d`
- `status_30d`, `focus_30d`, `attendance_30d`, `late_30d`, `absent_30d`, `overtime_pct_30d`, `rev_per_hour_30d`, `problem_employees_30d`, `pressure_branch_30d`, `pressure_shift_30d`

If SQL cannot reference another query by name, duplicate CTE logic or build overview directly.

### 11.5 `workforce_kpi_period`

Purpose:

- Feed KPI grid.

Expected columns:

- `period`
- `total_employees`
- `attendance_rate`
- `late_rate`
- `absent_count`
- `total_overtime_hours`
- `overtime_session_pct`
- `total_orders`
- `total_revenue`
- `revenue_per_labor_hour`
- `orders_per_labor_hour`
- `problem_employee_count`

### 11.6 `workforce_action_queue`

Purpose:

- Feed prominent operational/coaching action cards.

Expected columns:

- `priority`
- `severity`
- `action_type`
- `subject_name`
- `subject_type`
- `branch_name`
- `shift_name`
- `metric_value`
- `impact_text`
- `recommended_action`

Max rows:

- 6 to 8.

Action source priority:

1. Coverage risk:
   - branch/shift with high absent or low attendance.
   - action: schedule backup / adjust roster.
2. Repeated absent:
   - employee absent >= 2 in 30d.
   - action: coaching conversation and schedule review.
3. Repeated late:
   - employee late >= 4 in 30d.
   - action: coaching, transport/schedule check, shift reassignment if needed.
4. Overtime pressure:
   - branch/shift/role with high overtime session pct.
   - action: capacity audit, add staff, rebalance roster.
5. High overtime employee:
   - employee with repeated overtime.
   - action: check workload and burnout risk.
6. Productivity outlier:
   - low revenue/hour or order/hour within role/shift.
   - action: training or role-specific coaching.
7. Recognition:
   - high revenue/hour without excessive overtime/attendance issues.
   - action: recognize or use as benchmark.

Important:

- Avoid punitive wording.
- Frame actions as coaching/support/schedule adjustment.
- If hero says `Kritis`, action queue must not be empty.

### 11.7 `attendance_mix_period`

Purpose:

- Feed attendance distribution by period.

Expected columns:

- `period`
- `attendance_status`
- `sessions`
- `pct`

### 11.8 `attendance_by_branch_period`

Purpose:

- Feed branch attendance diagnostics.

Expected columns:

- `period`
- `branch_name`
- `attendance_status`
- `sessions`
- `pct`
- `attendance_rate`
- `late_rate`
- `absent_count`

### 11.9 `attendance_daily_trend`

Purpose:

- Preserve daily attendance trend.

Expected columns:

- `attendance_date`
- `present`
- `late`
- `absent`
- `leave_count`
- `pct_tidak_hadir`
- `late_rate`

Use 30-day window.

### 11.10 `attendance_by_dayofweek`

Purpose:

- Preserve day-of-week pattern.

Expected columns:

- `nama_hari`
- `urutan_hari`
- `avg_pct_absent`
- `avg_pct_late`

### 11.11 `shift_coverage_period`

Purpose:

- Diagnose shift-level capacity and coverage.

Expected columns:

- `period`
- `shift_name`
- `scheduled_sessions`
- `working_sessions`
- `attendance_rate`
- `late_rate`
- `absent_count`
- `total_orders`
- `total_revenue`
- `revenue_per_labor_hour`
- `orders_per_labor_hour`
- `overtime_session_pct`
- `pressure_score`

Pressure score suggestion:

```sql
(100 - attendance_rate) + late_rate + overtime_session_pct
```

### 11.12 `shift_movement_period`

Purpose:

- Compare shift demand/productivity current vs previous period.

Expected columns:

- `period`
- `shift_name`
- `orders_current`
- `orders_previous`
- `orders_change_pct`
- `revenue_current`
- `revenue_previous`
- `revenue_change_pct`
- `overtime_current`
- `overtime_previous`
- `overtime_change_pct`
- `movement_status`

### 11.13 `overtime_pressure_period`

Purpose:

- Feed overtime pressure chart/table.

Expected columns:

- `period`
- `shift_name`
- `total_employees`
- `total_overtime_hours`
- `avg_overtime_per_person`
- `overtime_sessions`
- `overtime_session_pct`

### 11.14 `overtime_by_branch_period`

Purpose:

- Branch-level overtime pressure.

Expected columns:

- `period`
- `branch_name`
- `total_overtime_hours`
- `avg_overtime_per_person`
- `overtime_session_pct`
- `pressure_score`

### 11.15 `overtime_trend`

Purpose:

- Preserve daily overtime trend.

Expected columns:

- `attendance_date`
- `shift_name`
- `total_overtime_hours`

Use 30-day window.

### 11.16 `productivity_by_employee_period`

Purpose:

- Replace "Top employee by revenue" as the main productivity table.

Expected columns:

- `period`
- `employee_name`
- `role`
- `branch_name`
- `shift_name`
- `hari_hadir`
- `total_orders`
- `total_revenue`
- `avg_ticket`
- `estimated_labor_hours`
- `revenue_per_hour`
- `orders_per_hour`
- `total_overtime_hours`
- `late_count`
- `absent_count`
- `productivity_label`

Productivity label examples:

- `Benchmark`
- `Perlu coaching`
- `Beban tinggi`
- `Pantau`

Do not rank primarily by total revenue. Rank by `revenue_per_hour` or `orders_per_hour`, with role/shift context.

### 11.17 `productivity_by_shift_role`

Purpose:

- Preserve normalized shift × role chart.

Expected columns:

- `period`
- `shift_name`
- `role`
- `revenue_per_hour`
- `orders_per_hour`

### 11.18 `role_diagnostics_period`

Purpose:

- Preserve role performance, attendance, and overtime context.

Expected columns:

- `period`
- `role`
- `total_employees`
- `total_orders`
- `total_revenue`
- `avg_order_value`
- `orders_per_employee`
- `attendance_rate`
- `late_rate`
- `absent_rate`
- `overtime_session_pct`
- `revenue_per_hour`
- `orders_per_hour`

### 11.19 `attendance_problem_period`

Purpose:

- Feed coaching queue and detail table.

Expected columns:

- `period`
- `employee_name`
- `role`
- `branch_name`
- `shift_name`
- `total_workdays`
- `total_absent`
- `total_late`
- `total_leave`
- `total_overtime_hours`
- `risk_label`
- `recommended_action`

Risk logic:

- `Kritis`: absent >= 3 or late >= 6 in 30d.
- `Tinggi`: absent >= 2 or late >= 4 in 30d.
- `Sedang`: absent >= 1 or late >= 2 in 7d.

Adjust thresholds for y/7d period if rendered.

### 11.20 `top_overtime_employees_period`

Purpose:

- Preserve top overtime employees.

Expected columns:

- `period`
- `employee_name`
- `role`
- `branch_name`
- `shift_name`
- `total_overtime_hours`
- `overtime_days`
- `avg_hours_per_overtime_session`
- `recommended_action`

## 12. Rendering Contract

### 12.1 Main Guard

Do not access `[0]` before the main guard.

Use:

```svelte
{#if workforce_health_overview.length > 0 && workforce_dates.length > 0}
  ...
{:else}
  ...
{/if}
```

Inside the guard, define active constants using `{@const}`. This project already uses `{@const}` in `pages/04-peak-hours.md`.

Example:

```svelte
{@const activeStatus = inputs.period === 'y'
  ? workforce_health_overview[0].status_y
  : inputs.period === '30d'
    ? workforce_health_overview[0].status_30d
    : workforce_health_overview[0].status_7d}
```

Define similar constants for:

- `activeFocus`
- `activeAttendance`
- `activeLate`
- `activeAbsent`
- `activeOvertimePct`
- `activeRevenuePerHour`
- `activePressureBranch`
- `activePressureShift`

For active period rows:

```svelte
{@const activeKpi = workforce_kpi_period.find(r => r.period === inputs.period) ?? workforce_kpi_period.find(r => r.period === '7d')}
```

Then guard if needed:

```svelte
{#if activeKpi}
  ...
{/if}
```

### 12.2 ButtonGroup

Use:

```svelte
<ButtonGroup name=period>
  <ButtonGroupItem valueLabel="Kemarin" value="y" />
  <ButtonGroupItem valueLabel="7 Hari" value="7d" default />
  <ButtonGroupItem valueLabel="30 Hari" value="30d" />
</ButtonGroup>
```

### 12.3 Period Strip

Each pill:

- label,
- status badge,
- core metric,
- one-line interpretation.

Example content:

- Kemarin: `{attendance_y}% hadir · {absent_y} absent`
- 7 Hari: `{attendance_7d}% hadir · {overtime_pct_7d}% sesi overtime`
- 30 Hari: `{problem_employees_30d} pegawai perlu coaching`

### 12.4 Hero

Hero headline logic:

If active status is `Kritis` and focus is `Coverage risk`:

> Coverage shift mulai kritis; absensi mengganggu kapasitas operasional.

If active status is `Kritis` and focus is `Keterlambatan`:

> Keterlambatan sudah mengganggu kesiapan shift.

If active status is `Kritis` and focus is `Overtime pressure`:

> Overtime tinggi menunjukkan tekanan kapasitas staf.

If active status is `Kritis` and focus is `Produktivitas`:

> Produktivitas per jam melemah; cek role dan shift sebelum menilai individu.

If `Waspada`:

> Workforce masih berjalan, tetapi ada sinyal operasional yang perlu ditangani.

If `Sehat`:

> Workforce stabil; fokusnya menjaga roster dan menguatkan benchmark produktivitas.

Hero copy max 2-3 sentences.

Hero side cards:

1. Periode aktif.
2. Cabang/shift tekanan tertinggi.

### 12.5 KPI Grid

Show:

- Attendance Rate.
- Late Rate.
- Absent Count.
- Overtime Session %.
- Revenue per Labor Hour.
- Orders per Labor Hour.

If too crowded, show 4:

- Attendance Rate.
- Late Rate.
- Overtime Session %.
- Revenue per Labor Hour.

### 12.6 Signal Cards

Use 3 cards:

1. `Apa yang sehat`
2. `Risiko utama`
3. `Aksi berikutnya`

Signal examples:

- Healthy:
  - "Kehadiran stabil dan overtime terkendali."
- Coverage:
  - "Absensi mulai menekan kapasitas shift."
- Late:
  - "Keterlambatan berulang membuat opening/prep shift rawan terlambat."
- Overtime:
  - "Overtime berulang lebih mirip sinyal understaffing daripada produktivitas tinggi."
- Productivity:
  - "Bandingkan pegawai dalam role dan shift yang sama sebelum coaching."

### 12.7 Workforce Action Queue

This section must appear before detailed charts.

Use `workforce_action_queue`.

Render:

```svelte
{#if workforce_action_queue.length > 0}
  <div class="section-card">
    <div class="section-head">
      <div>
        <div class="section-eyebrow">Pusat Aksi Workforce</div>
        <h3 class="section-title">Tindakan staffing dan coaching yang perlu diprioritaskan</h3>
        <p class="section-copy">Urut dari risiko tertinggi berdasarkan coverage, attendance, overtime, dan produktivitas.</p>
      </div>
    </div>
    <div class="workforce-action-stack">
      {#each workforce_action_queue as action}
        <div class="workforce-action-card {action.severity === 'Kritis' ? 'critical' : action.severity === 'Tinggi' ? 'high' : action.severity === 'Sedang' ? 'moderate' : 'low'}">
          ...
        </div>
      {/each}
    </div>
  </div>
{:else}
  <div class="section-card">
    <h3 class="section-title">Belum ada aksi workforce prioritas.</h3>
    <p class="section-copy">Tidak ada alarm besar pada periode aktif. Lanjutkan pemantauan roster, attendance, dan produktivitas normal.</p>
  </div>
{/if}
```

Important:

- If page hero says `Kritis`, action queue must not be empty.
- Use coaching/support wording.

### 12.8 Shift Coverage and Attendance

Use:

- `shift_coverage_period`
- `attendance_mix_period`
- `attendance_by_branch_period`
- `attendance_daily_trend`
- `attendance_by_dayofweek`

Main question:

- Which shift/branch has coverage pressure?

Recommended visuals:

- bar chart by shift pressure score,
- branch attendance status stacked bar,
- daily trend line.

Do not show every attendance table in the main flow; move long detail table to accordion if needed.

### 12.9 Overtime Pressure

Use:

- `overtime_pressure_period`
- `overtime_by_branch_period`
- `overtime_trend`
- `top_overtime_employees_period`

Main question:

- Is overtime isolated or structural?

Recommended copy:

> Overtime tinggi di shift/cabang tertentu biasanya sinyal kapasitas, bukan semata performa individu. Cek apakah overtime muncul bersamaan dengan absent/late.

### 12.10 Normalized Productivity

Use:

- `productivity_by_employee_period`
- `productivity_by_shift_role`

This section is important and should appear before raw top revenue employee table.

Main question:

- Who performs well after normalizing for hours, shift, and role?

Recommended chart:

- grouped bar: revenue per hour by shift and role.

Recommended table:

- top 15 by revenue/hour or orders/hour, with attendance/overtime context.

Avoid:

- ranking employees mainly by total revenue.

### 12.11 Role and Branch Diagnostics

Use:

- `role_diagnostics_period`
- branch attendance/overtime queries.

Main question:

- Is this a person issue, role issue, branch issue, or schedule issue?

Display:

- role table,
- branch pressure table,
- optional charts.

### 12.12 Employee Detail Tables

Keep lower/detail sections:

- attendance problem table,
- top overtime employees,
- productivity table,
- optional raw top revenue table if still useful.

If keeping raw top revenue table, label it clearly:

> Total revenue handled is context, not a fair performance ranking.

### 12.13 Methodology Accordions

Add at bottom:

1. `Cara membaca workforce health`
2. `Cara membaca produktivitas per jam`
3. `Catatan sebelum coaching`

Content:

Workforce health:

- Sehat/waspada/kritis based on attendance, late, overtime, problem employees.

Productivity:

- Revenue/hour and orders/hour normalize differences in shift duration.
- Compare within role and shift when possible.

Coaching caveats:

- One absence does not equal performance problem.
- Leave/cuti should not be treated the same as absent.
- Overtime can signal understaffing or demand spike.
- Role context matters.
- Use dashboard as a triage tool, not final HR decision.

## 13. Content to Remove or Replace

Remove/replace:

- Old top `BigValue` summary.
- Long report-style intro.
- Inline alert blocks at the top.
- Free-floating headings not wrapped in section cards.
- Raw top revenue as primary employee ranking.

Keep/rebuild:

- attendance distribution,
- attendance trends,
- shift performance,
- overtime analysis,
- role diagnostics,
- revenue/hour normalization,
- attendance problem table.

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

The final page should feel like an operations cockpit, not a generic HR report.

Use:

- compact cards,
- status badges,
- action cards,
- direct section titles,
- restrained semantic colors,
- charts only where they clarify decisions.

Avoid:

- massive first-screen text,
- too many tables in sequence,
- table-only coaching diagnosis,
- nested cards inside cards,
- chart overload,
- blame-heavy wording.

Emoji policy:

- Existing project uses emojis; acceptable in moderation.
- Do not rely on emoji alone for status.
- Pair emoji with text labels.

## 16. Implementation Sequence

Recommended steps:

1. Open `evidence/pages/01-laporan-keuangan.md` and inspect style patterns.
2. Open current `evidence/pages/07-employee-performance.md`.
3. Replace local content with cockpit structure.
4. Add local style block.
5. Add SQL query set:
   - `workforce_dates`
   - `workforce_health_period`
   - `workforce_health_overview`
   - `workforce_kpi_period`
   - `workforce_action_queue`
   - `attendance_mix_period`
   - `attendance_by_branch_period`
   - `attendance_daily_trend`
   - `attendance_by_dayofweek`
   - `shift_coverage_period`
   - `shift_movement_period`
   - `overtime_pressure_period`
   - `overtime_by_branch_period`
   - `overtime_trend`
   - `productivity_by_employee_period`
   - `productivity_by_shift_role`
   - `role_diagnostics_period`
   - `attendance_problem_period`
   - `top_overtime_employees_period`
6. Add `ButtonGroup name=period`.
7. Add main guard.
8. Build `.workforce-page`.
9. Build period strip.
10. Build hero.
11. Build KPI grid.
12. Build signal cards.
13. Build workforce action queue.
14. Build shift coverage and attendance section.
15. Build overtime pressure section.
16. Build normalized productivity section.
17. Build role/branch diagnostics.
18. Build employee detail tables.
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
2. `07-employee-performance.md` has period switch: `Kemarin`, `7 Hari`, `30 Hari`.
3. Page top includes:
   - period strip,
   - hero cockpit,
   - KPI grid,
   - signal cards.
4. Workforce action queue appears before detailed charts and tables.
5. Attendance/coverage risk is visible early if present.
6. Overtime is framed as capacity pressure, not automatically good performance.
7. Normalized productivity appears before raw top revenue ranking.
8. Existing useful analysis is preserved or replaced:
   - attendance distribution,
   - attendance trends,
   - shift performance,
   - overtime pressure,
   - role diagnostics,
   - revenue/hour productivity,
   - attendance problem table.
9. Date logic uses max available attendance date.
10. No unguarded top-level `[0]` references.
11. Page visually aligns with page 01 and the cockpit style of pages 05/06 if already reworked.
12. Page reads as an operations/workforce cockpit, not a raw HR report.
13. Health status and action queue do not contradict each other.

## 19. Non-Goals

Do not:

- redesign the whole dashboard,
- edit `index.md`,
- edit other pages,
- add new datasource,
- add external dependencies,
- change dbt models,
- change package versions,
- create disciplinary HR conclusions from dashboard data alone,
- treat approved leave as equivalent to absent,
- rank employees only by total revenue handled.

## 20. Final Quality Target

Target score after rework:

- 8.7 to 9.0 out of 10.

Most important outcome:

> A restaurant manager can open the page and immediately know whether staffing is healthy, which shift or branch is under pressure, who needs coaching/support, and whether productivity is being measured fairly.

## 21. Suggested Final Copy Blocks

Use these as copy inspiration, not mandatory exact text.

Subtitle:

> Cockpit tenaga kerja: pantau kehadiran, tekanan shift, overtime, produktivitas, dan prioritas coaching.

Hero healthy:

> Workforce stabil; fokusnya menjaga roster dan menggunakan pegawai produktif sebagai benchmark internal.

Hero coverage:

> Coverage shift mulai tertekan. Absensi dan keterlambatan membuat kapasitas operasional lebih tipis pada periode ini.

Hero overtime:

> Overtime tinggi menunjukkan tekanan kapasitas staf. Cek apakah beban ini terkonsentrasi di shift, cabang, atau role tertentu sebelum menambah jadwal.

Hero productivity:

> Produktivitas per jam perlu ditinjau dengan konteks role dan shift. Jangan pakai total revenue handled sebagai satu-satunya ukuran.

Action queue intro:

> Urutan ini menggabungkan sinyal coverage, attendance, overtime, dan produktivitas. Gunakan sebagai daftar kerja roster dan coaching, bukan keputusan HR final.

Normalized productivity intro:

> Revenue per jam dan order per jam membantu membandingkan pegawai dengan lebih adil karena memperhitungkan durasi shift dan jumlah hari hadir.

Coaching caveat:

> Dashboard ini menunjukkan area yang perlu dibicarakan. Validasi dengan konteks jadwal, role, kondisi cabang, dan percakapan langsung sebelum mengambil tindakan personal.


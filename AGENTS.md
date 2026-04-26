# Wekadata — AI Agent Context

## Project Overview
Restaurant multi-branch analytics platform. End-to-end data pipeline demo
targeting restaurant owners who need automated daily reporting and branch
performance monitoring. Built as a portfolio project.

## Tech Stack
| Layer | Tool |
|---|---|
| Warehouse | DuckDB (`data/warehouse.duckdb`, `data/warehouse_en.duckdb`) |
| Transform | dbt-core + dbt-duckdb |
| Orchestration | Dagster |
| Dashboard | Evidence.dev (SvelteKit-based) |
| Alerting | Telegram Bot |
| Language | Python 3, SQL (DuckDB dialect) |

## Project Structure
```
restaurant-demo/
├── data/
│   ├── raw/                  # Generated CSVs — ID version (gitignored)
│   └── raw_en/               # Generated CSVs — EN version (gitignored)
├── ingestion/
│   ├── generate_data_id.py   # Synthetic data generator — ID (Bahasa)
│   ├── generate_data_en.py   # Synthetic data generator — EN (US)
│   └── load_raw.py           # Load CSVs → DuckDB raw schema
├── dbt_restaurant/           # dbt project — ID version
│   └── models/
│       ├── staging/          # stg_* — clean & cast raw
│       ├── foundation/       # dim_* & fct_* — core data model
│       └── marts/            # mart_* — business-ready aggregations
├── dbt_restaurant_en/        # dbt project — EN version (simplified)
├── evidence/                 # Dashboard — ID version (Bahasa Indonesia)
│   └── pages/                # .md files = dashboard pages
├── evidence_en/              # Dashboard — EN version
├── pipeline/
│   ├── definitions.py        # Dagster entry point
│   └── assets/
│       ├── ingestion.py      # Dagster ingestion assets
│       └── dbt_assets.py     # Dagster dbt + alert + publish assets
└── scripts/
    ├── telegram_alert.py     # Daily summary alert — ID
    └── telegram_alert_en.py  # Daily summary alert — EN
```

## Two Versions (ID vs EN)
- **ID version** — full featured, Bahasa Indonesia, IDR currency, Indonesian
  restaurant context (ayam bakar, etc.), 4 branches in Jabodetabek
- **EN version** — simplified (no employees/attendance/inventory), English,
  USD currency, burger restaurant in Chicago
- EN pipeline is commented out in Dagster — ID is the active pipeline

## Data Model

### Sources (raw schema in DuckDB)
`branches`, `menu_items`, `employees`, `members`, `shifts`,
`employee_attendance`, `orders`, `order_items`, `employee_compensation`,
`inventory_catalog`, `inventory_transactions`, `branch_daily_operational_costs`

### Staging Layer (`+schema: staging`, materialized as view)
All prefixed `stg_*`. Responsibilities: cast types, rename columns, normalize
casing, basic null handling. No business logic here.

### Foundation Layer (`+schema: foundation`, materialized as table)
- **Dimensions:** `dim_branches`, `dim_menu_items`, `dim_employees`,
  `dim_members`, `dim_shifts`, `dim_inventory_items`
- **Facts:** `fct_orders` (grain: one row per order line item),
  `fct_employee_attendance`, `fct_inventory_costs_daily`,
  `fct_labor_costs_daily`, `fct_branch_operational_costs_daily`

### Marts Layer (`+schema: marts`, materialized as table)
| Mart | Description |
|---|---|
| `mart_daily_revenue` | Daily revenue per branch, SDOW rolling avg, pct_change |
| `mart_daily_net_revenue` | Gross revenue minus all cost components |
| `mart_menu_performance` | Daily menu sales, 30d rolling, WoW change |
| `mart_peak_hours` | Hourly orders by branch and order type |
| `mart_employee_shift_performance` | Employee productivity + attendance |
| `mart_member_purchase_behavior` | Member spending patterns by tier |
| `mart_inventory_stok` | Daily inventory usage vs purchase per branch |

### Key Business Logic
- `pct_change_vs_sdow_avg` — compares today vs same day of week average
  (last 30 days), used for early warning alerts in Telegram and dashboard
- `qty_wow_change` — week-over-week menu sales change, drives declining
  menu detection
- `net_revenue` = gross_revenue - inventory_usage_cost - labor_total_cost
  - operational_total_cost
- Labor cost = salary_daily_allocated + meal_allowance_cost + overtime_cost
- Attendance statuses: `present`, `late`, `leave`, `absent`

## Branch Data (ID version)
| ID | Name | Location | Narrative |
|---|---|---|---|
| BR01 | Cabang Pusat | Jakarta Selatan | Stable flagship, baseline |
| BR02 | Cabang Selatan | Depok | Consistent growth |
| BR03 | Cabang Utara | Bekasi | Opens month 4, slow ramp-up |
| BR04 | Cabang Timur | Tangerang | Drop months 6-8 (competitor), recovery |

## Menu Categories & Notes (ID version)
Categories: `main`, `drink`, `snack`, `dessert`, `side`
Special menu behavior in generator:
- `bestseller` — M01 Ayam Bakar Madu, weight 3.0x
- `declining` — M03 Ayam Geprek, M06 Ayam Penyet, drop from month 8
- `weekend_spike` — M05 Paket Keluarga, 3.5x on weekend
- `hidden_gem` — M14 Puding Coklat, low volume high margin

## Employee & Shift (ID version)
- 32 employees, 8 per branch, roles: `kasir`, `pramusaji`, `supervisor`
- Shifts: S1 Pagi (07-14), S2 Siang (12-20), S3 Malam (16-23)
- Attendance generated with deterministic off-days per employee
- Compensation: base_salary_monthly / 30 + meal_allowance + overtime

## Dagster Pipeline
Daily schedule: 23:00 UTC (06:00 WIB)
```
generate_daily_data → load_raw_to_duckdb → dbt_build
                                                ├── send_telegram_alert
                                                ├── build_evidence_dashboard
                                                └── push_to_github
```

## Evidence Dashboard Pages (ID)
| File | Title | Key Content |
|---|---|---|
| `index.md` | Ringkasan | Daily KPI, branch table, alerts, hourly chart |
| `00-panduan.md` | Panduan | User guide, glossary |
| `01-laporan-keuangan.md` | Laporan Keuangan | Net revenue, margin, cost structure |
| `02-branch-performance.md` | Performa Cabang | 30d trend, profitability, WoW |
| `03-inventori-stok.md` | Inventori | Usage vs purchase, price variance |
| `04-peak-hours.md` | Jam Sibuk | Hourly distribution, prediction |
| `05-menu-performance.md` | Performa Menu | Menu engineering, WoW, declining |
| `06-member-behavior.md` | Perilaku Member | Tier analysis, cohort, churn risk |
| `07-employee-performance.md` | Performa Pegawai | Attendance, overtime, productivity |

## Evidence SQL Source
Evidence reads from DuckDB marts via source defined in
`evidence/sources/restaurant/`. SQL files query `restaurant.{mart_name}`.
DuckDB connection path: `data/warehouse.duckdb`.

## Conventions & Rules
- dbt model names: always prefixed `stg_`, `dim_`, `fct_`, `mart_`
- SQL dialect: DuckDB — use `date_trunc`, `datediff`, `dayofweek`, `hour()`,
  `strftime`, `INTERVAL '30 days'` syntax
- Evidence pages: SQL blocks first, then components. Use `{variable}` syntax
  for dynamic text. Always filter with `MAX(date_col)` subquery for latest data
- All monetary values in IDR (integer, no decimal) for ID version
- Null payment_method is intentional (chaos injection, ~3% of orders)
- Always use `coalesce(..., 0)` when joining cost tables to revenue
- dbt refs: use `{{ ref('model_name') }}` not direct table names
- Dagster assets use subprocess to call dbt and python scripts — not
  dagster-dbt library
- Do NOT modify `.env` directly
- Do NOT change `BASE_SEED` values in generators (breaks determinism)
- Do NOT add `shift_id`/`handler_employee_id`/`member_id` to EN version
  (simplified schema)

## Current Active Work
- ID pipeline is fully active and running daily
- EN pipeline is commented out (ingestion.py and dbt_assets.py)
- `evidence_en` exists but EN dbt assets not wired to Dagster yet
- `push_to_github` asset in dbt_assets.py pushes DuckDB file to GitHub
  for demo purposes

## Common Tasks Reference
```bash
# Run dbt
cd dbt_restaurant && dbt build

# Generate backfill data
python ingestion/generate_data_id.py --mode backfill

# Load to DuckDB
python ingestion/load_raw.py --lang id

# Start Dagster
dagster dev

# Start Evidence dashboard
cd evidence && npm run dev

# Test Telegram alert
python scripts/telegram_alert.py
```

---

# Wekadata Website (wekadata.id)

## Overview
Marketing + client portal website untuk product Wekadata. Dibangun di atas
Foxi Astro theme (MIT), dikustomisasi penuh untuk Wekadata. Deployed ke
Vercel, domain wekadata.id.

## Tech Stack Website
| Layer | Tool |
|---|---|
| Framework | Astro v6 (`output: server`) |
| Styling | Tailwind CSS v3 + custom design tokens |
| Auth | Clerk (`@clerk/astro`) |
| Adapter | Vercel (`@astrojs/vercel`) |
| Icons | astro-icon + Heroicons SVG di `src/icons/` |
| Fonts | Inter Variable + Outfit Variable (Fontsource) |
| Forms | Web3Forms (no backend needed) |
| Storage | Cloudflare R2 (file upload dari client portal) |
| Analytics | Google Analytics + Google Tag Manager |

## Folder Structure Website
```
src/
├── assets/               # Images, logos, illustrations
├── components/
│   ├── blocks/           # Section-level components
│   │   ├── CTA/          # Call-to-action sections
│   │   ├── FAQ/          # FAQ sections
│   │   ├── contact/      # Contact & support forms
│   │   ├── features/     # Feature showcase sections
│   │   ├── hero/         # Hero sections per page type
│   │   ├── highlights/   # Text+image rows
│   │   ├── modal/        # SignUp modal
│   │   ├── pricing/      # Pricing calculator + columns
│   │   └── socialproof/  # POS logo strip
│   ├── scripts/          # Astro script components (GA, GTM, etc.)
│   └── ui/               # Atomic UI components
│       ├── cards/        # BasicCard, BlogCard, FeatureCard
│       ├── forms/        # InputField, TextArea, Toggle
│       └── pricing-tables/ # PricingTable component
├── config/
│   ├── config.ts         # Site title, description, logo, mode
│   ├── navigationBar.ts  # Nav items & CTA buttons
│   ├── footerNavigation.ts # Footer columns & social links
│   ├── socialLinks.ts    # Facebook, Instagram links
│   └── analytics.ts      # GA ID, GTM ID
├── content/blog/         # Blog posts (.md)
├── data/
│   ├── json-files/       # featuresData, faqData, pricingTablesdata,
│   │                     # changelogData, clientsData
│   └── markdown-files/   # about.md, careers.md, terms.md, privacy.md
├── icons/                # SVG icons (Heroicons)
├── layouts/
│   ├── Layout.astro      # Main layout (nav + footer + modal + toast)
│   └── PostLayout.astro  # Blog post layout
├── pages/
│   ├── index.astro       # Homepage
│   ├── pricing.astro     # Pricing page (calculator)
│   ├── features.astro    # Features page (sticky sidebar)
│   ├── features-comparison.astro # Feature comparison table
│   ├── faq.astro         # FAQ page
│   ├── contact.astro     # Contact page
│   ├── support.astro     # Support ticket page (client only)
│   ├── about.astro       # About page + founder photo
│   ├── careers.astro     # Careers page
│   ├── changelog.astro   # Changelog feed
│   ├── terms.astro       # Syarat & Ketentuan
│   ├── privacy.astro     # Kebijakan Privasi
│   ├── daftar.astro      # Registration form (from pricing calculator)
│   ├── thank-you.astro   # Post-registration thank you
│   ├── portal.astro      # Client portal (auth-protected)
│   ├── admin.astro       # Admin panel (auth-protected, admin only)
│   ├── sign-in.astro     # Clerk sign-in page
│   └── api/              # API routes
│       ├── clients.ts    # GET all clients (Clerk users + invites)
│       ├── invite.ts     # POST invite new client via Clerk
│       ├── update-client.ts # POST update dashboardUrl in Clerk metadata
│       ├── upload-url.ts # POST get R2 presigned URL for file upload
│       └── sign-out.ts   # POST revoke session
└── styles/global.css     # Global Tailwind base styles
```

## Auth & Access Control
- Auth provider: **Clerk** via `@clerk/astro`
- Middleware: `src/middleware.ts`
  - `/portal/*` → requires login (any user)
  - `/admin/*` → requires login AND email === `wekadata.analitika@gmail.com`
- Client metadata stored in Clerk `publicMetadata`:
  - `restoran` — nama restoran client
  - `dashboardUrl` — URL Evidence dashboard client

## Client Portal Flow
1. Admin invite client via `/admin` → Clerk sends invite email
2. Client signs up via invite link → redirect to `/portal`
3. Portal shows dashboard link (from `publicMetadata.dashboardUrl`)
4. Client can upload CSV/Excel → goes to R2 via presigned URL
5. Admin sets `dashboardUrl` via `/admin` edit modal

## Pricing Model (from `pricingTablesdata.json` & `PricingCalculator.astro`)
**Base plans:**
| Plan | Cabang | Harga Tahunan | Harga Bulanan |
|---|---|---|---|
| Solo | 1 | 79k/bln | 99k/bln |
| Basic | ≤3 | 249k/bln | 329k/bln |
| Growth | ≤5 | 499k/bln | 649k/bln |
| Enterprise | >5 | Custom | Custom |

**Add-ons (per akun, semua cabang):**
- Inventori & Biaya Bahan Baku: +79k/bln
- Pegawai & Absensi: +99k/bln
- Member & CRM: +149k/bln

PPN 11% ditambahkan di total estimasi kalkulator.

## Design System
- **Primary color:** Teal — `primary-500: #0d9488` (Tailwind teal-600 range)
- **Neutral:** Slate-based custom scale
- **Font headings:** Outfit Variable
- **Font body:** Inter Variable
- **Dark mode:** supported via `[darkMode: selector]`, toggle di navbar
- **Scroll animations:** col elements fade-up on scroll (`.scroll-animation`)

## Key Components
- `PricingCalculator.astro` — interactive calculator, billing toggle,
  addon checkboxes, breakdown total, CTA links to `/daftar`
- `SignUp.astro` (modal) — Web3Forms submission, success/error state,
  anti-double-submit, auto-reset on reopen
- `BasicForm.astro` & `SupportForm.astro` — contact forms via Web3Forms
- `Toast.astro` — dismissible popup, re-shows after 7 days
- `NavigationBar.astro` — sticky, mobile hamburger, submenu dropdown,
  shows "Akun" vs "Login" based on Clerk auth state

## Content Files to Edit for Copy Changes
| What | Where |
|---|---|
| Features list | `src/data/json-files/featuresData.json` |
| FAQ | `src/data/json-files/faqData.json` |
| Pricing tables | `src/data/json-files/pricingTablesdata.json` |
| Changelog | `src/data/json-files/changelogData.json` |
| Nav links | `src/config/navigationBar.ts` |
| Footer | `src/config/footerNavigation.ts` |
| About page | `src/data/markdown-files/about.md` |
| Terms | `src/data/markdown-files/terms.md` |
| Privacy | `src/data/markdown-files/privacy.md` |
| Careers | `src/data/markdown-files/careers.md` |

## Website Conventions & Rules
- Language: **Bahasa Indonesia** untuk semua copy user-facing
- No `<form>` HTML tags di React/interactive components — gunakan event
  handlers (`onClick`, `onChange`)
- Semua form submission via **Web3Forms** (tidak ada backend form handler)
- Icons: tambah SVG baru di `src/icons/`, nama file = nama icon,
  referensi via `astro-icon` dengan `<Icon name="nama-file" />`
- Tailwind: gunakan hanya utility classes yang ada di base stylesheet
  (tidak ada custom compiler), safelist di `tailwind.config.mjs`
- Astro page transitions: `ClientRouter` aktif, script UI pakai
  `document.addEventListener('astro:page-load', ...)` bukan DOMContentLoaded
- Do NOT use `localStorage` atau `sessionStorage` — tidak didukung
- Do NOT hardcode API keys di source code — gunakan `import.meta.env.*`
- Form access key Web3Forms sudah ada di masing-masing form component,
  jangan diganti sembarangan

## Dev Commands Website
```bash
# Dev server
npm run dev

# Build
npm run build

# Preview build
npm run preview
```

## Deployment
- Platform: **Vercel** (auto-deploy on push to main)
- Adapter: `@astrojs/vercel` dengan `output: server`
- Environment variables di Vercel dashboard:
  - `PUBLIC_CLERK_PUBLISHABLE_KEY`
  - `CLERK_SECRET_KEY`
  - `R2_ACCOUNT_ID`, `R2_ACCESS_KEY_ID`, `R2_SECRET_ACCESS_KEY`, `R2_BUCKET_NAME`
  - `PUBLIC_GA_TRACKING_ID`

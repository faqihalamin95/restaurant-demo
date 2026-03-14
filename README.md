# Restaurant Analytics — Demo Project

End-to-end data pipeline demo for restaurant multi-branch analytics.
Built as a portfolio project targeting restaurant owners who need
automated daily reporting and branch performance monitoring.

---

## Stack

| Layer          | Tool                        |
|----------------|-----------------------------|
| Data Storage   | Cloudflare R2 (Parquet)     |
| Warehouse      | DuckDB                      |
| Transform      | dbt-core + dbt-duckdb       |
| Orchestration  | Dagster                     |
| Dashboard      | Evidence.dev                |
| Alerting       | Telegram Bot                |

---

## Project Structure

```
restaurant-demo/
│
├── data/
│   └── raw/                   # Generated CSVs (gitignored in prod)
│
├── ingestion/                 # Data loading utilities
│
├── dbt/
│   ├── models/
│   │   ├── staging/           # stg_* — clean & cast raw data
│   │   ├── foundation/        # dim_* & fct_* — core data model
│   │   └── marts/             # mart_* — business-ready aggregations
│   ├── seeds/                 # Static reference data
│   ├── tests/                 # Custom data tests
│   └── macros/                # Reusable SQL macros
│
├── dagster/
│   ├── assets/
│   │   ├── ingestion_assets.py   # Load CSVs → DuckDB raw schema
│   │   └── dbt_assets.py         # dbt models as Dagster assets
│   ├── jobs/
│   │   └── pipeline_job.py       # Full pipeline job definition
│   └── schedules/
│       └── daily_schedule.py     # 06:00 WIB daily trigger
│
├── evidence/                  # Evidence.dev dashboard source
│   ├── pages/                 # .md files = dashboard pages
│   └── sources/               # DuckDB connection config
│
├── scripts/
│   └── telegram_alert.py      # Daily summary alert to owner
│
├── generate_data.py           # Synthetic data generator
├── requirements.txt
└── .env.example
```

---

## Data Model

```
raw.orders ──────────────┐
raw.order_items ──────────┤
raw.menu_items ───────────┤──► staging ──► foundation ──► marts
raw.branches ─────────────┘
```

**Staging** — cast types, rename columns, basic null handling  
**Foundation** — `dim_branches`, `dim_menu_items`, `fct_orders`  
**Marts** — `mart_daily_revenue`, `mart_menu_performance`, `mart_peak_hours`

---

## Dashboard Pages (Evidence.dev)

| Page                | Business Question                              |
|---------------------|------------------------------------------------|
| Overview            | How is the business doing today?               |
| Branch Performance  | Which branch is under/over-performing?         |
| Menu Performance    | What's selling and what's declining?           |
| Peak Hours          | When are customers coming?                     |

---

## Quick Start

```bash
# 1. Install dependencies
pip install -r requirements.txt

# 2. Generate synthetic data
python generate_data.py

# 3. Run dbt
cd dbt
dbt deps
dbt seed
dbt run
dbt test

# 4. Launch Dagster UI
cd ..
dagster dev -f dagster/definitions.py

# 5. Launch Evidence dashboard (requires Node.js)
cd evidence
npm install
npm run dev
```

---

## Alerting Setup

1. Create a Telegram bot via [@BotFather](https://t.me/BotFather)
2. Get your chat ID via [@userinfobot](https://t.me/userinfobot)
3. Copy `.env.example` → `.env` and fill in the values
4. Test: `python scripts/telegram_alert.py`

---

## Narrative (Demo Story)

The synthetic data is designed to tell a story:

- **Cabang Pusat** — Stable, highest revenue. Baseline for comparison.
- **Cabang Selatan** — Consistent growth throughout the year.
- **Cabang Utara** — Opened May 2024. Ramp-up story.
- **Cabang Timur** — Significant revenue drop Jul–Sep (competitor opens nearby), then recovery. This triggers the early warning alert.

Menu highlights:
- **Ayam Bakar Madu** — Bestseller, high volume
- **Ayam Geprek & Ayam Penyet** — Declining from month 8
- **Puding Coklat** — Hidden gem: low volume but healthy margin

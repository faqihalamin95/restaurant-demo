"""
Dagster Definitions
===================
Entry point for dagster dev.
Registers all assets, jobs, and schedules for both ID and EN pipelines.
"""

from dagster import (
    Definitions,
    define_asset_job,
    AssetSelection,
    ScheduleDefinition,
    load_assets_from_modules,
)

from pipeline.assets import ingestion, dbt_assets

# ── Assets ────────────────────────────────────────────────────────────────────
all_assets = load_assets_from_modules([ingestion, dbt_assets])

# ── Jobs ──────────────────────────────────────────────────────────────────────
daily_pipeline_job = define_asset_job(
    name="daily_pipeline",
    selection=AssetSelection.all(),
    description="Daily: generate data → load raw → dbt build (ID + EN)",
)

# ── Schedules ─────────────────────────────────────────────────────────────────
# 23:00 UTC = 06:00 WIB
daily_schedule = ScheduleDefinition(
    job=daily_pipeline_job,
    cron_schedule="0 23 * * *",
    name="daily_pipeline_schedule",
)

# ── Definitions ───────────────────────────────────────────────────────────────
defs = Definitions(
    assets=all_assets,
    jobs=[daily_pipeline_job],
    schedules=[daily_schedule],
)

"""
dbt Assets
==========
Runs dbt build after ingestion completes.
Uses subprocess for simplicity — no dagster-dbt dependency needed.
"""

import subprocess
from pathlib import Path

from dagster import asset, Output, MetadataValue
from pipeline.assets.ingestion import load_raw_to_duckdb, load_raw_to_duckdb_en

import subprocess

ROOT_DIR = Path(__file__).parent.parent.parent
DBT_DIR  = ROOT_DIR / "dbt_restaurant"


@asset(group_name="dbt", compute_kind="dbt", deps=[load_raw_to_duckdb])
def dbt_build():
    """
    Runs dbt build — executes all models and tests.
    Fails fast if any model or test fails.
    """
    result = subprocess.run(
        ["dbt", "build"],
        capture_output=True,
        text=True,
        cwd=str(DBT_DIR),
    )

    output_text = result.stdout + result.stderr

    if result.returncode != 0:
        raise Exception(f"dbt build failed:\n{output_text}")

    return Output(
        value=output_text,
        metadata={"dbt_output": MetadataValue.text(output_text)},
    )

@asset(group_name="dbt_en", compute_kind="dbt", deps=[load_raw_to_duckdb_en])
def dbt_build_en():
    result = subprocess.run(
        ["dbt", "build"],
        capture_output=True, text=True,
        cwd=str(ROOT_DIR / "dbt_restaurant_en"),
    )
    output_text = result.stdout + result.stderr
    if result.returncode != 0:
        raise Exception(f"dbt build EN failed:\n{output_text}")
    return Output(value=output_text, metadata={"dbt_output": MetadataValue.text(output_text)})

@asset(group_name="alert", compute_kind="python", deps=[dbt_build])
def send_telegram_alert():
    """
    Sends daily Restaurant Report to owner via Telegram.
    Runs after both ID and EN dbt builds complete.
    """
    result = subprocess.run(
        ["python", str(ROOT_DIR / "scripts" / "telegram_alert.py")],
        capture_output=True,
        text=True,
        cwd=str(ROOT_DIR),
    )
    if result.returncode != 0:
        raise Exception(f"Telegram alert failed:\n{result.stderr}")
    return Output(
        value=result.stdout,
        metadata={"output": MetadataValue.text(result.stdout)},
    )

@asset(group_name="alert", compute_kind="python", deps=[dbt_build_en])
def send_telegram_alert_en():
    """
    Sends daily Restaurant Report (EN) to owner via Telegram.
    """
    result = subprocess.run(
        ["python", str(ROOT_DIR / "scripts" / "telegram_alert_en.py")],
        capture_output=True,
        text=True,
        cwd=str(ROOT_DIR),
    )
    if result.returncode != 0:
        raise Exception(f"Telegram alert EN failed:\n{result.stderr}")
    return Output(
        value=result.stdout,
        metadata={"output": MetadataValue.text(result.stdout)},
    )
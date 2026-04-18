"""
dbt Assets
==========
Runs dbt build for both ID and EN projects after ingestion completes.
"""

from datetime import date
import subprocess
from pathlib import Path

from dagster import asset, Output, MetadataValue
from pipeline.assets.ingestion import load_raw_to_duckdb, load_raw_to_duckdb_en

ROOT_DIR = Path(__file__).parent.parent.parent


# ── Indonesian dbt build ──────────────────────────────────────────────────────

@asset(group_name="dbt", compute_kind="dbt", deps=[load_raw_to_duckdb])
def dbt_build():
    """Runs dbt build for the Indonesian project."""
    result = subprocess.run(
        ["dbt", "build"],
        capture_output=True, text=True,
        cwd=str(ROOT_DIR / "dbt_restaurant"),
    )
    output_text = result.stdout + result.stderr
    if result.returncode != 0:
        raise Exception(f"dbt build (ID) failed:\n{output_text}")
    return Output(value=output_text, metadata={"dbt_output": MetadataValue.text(output_text)})


@asset(group_name="alert", compute_kind="python", deps=[dbt_build])
def send_telegram_alert():
    """Sends daily Restaurant Report (ID) to owner via Telegram."""
    result = subprocess.run(
        ["python", str(ROOT_DIR / "scripts" / "telegram_alert.py")],
        capture_output=True, text=True, cwd=str(ROOT_DIR),
    )
    if result.returncode != 0:
        raise Exception(f"Telegram alert (ID) failed:\n{result.stderr}")
    return Output(value=result.stdout, metadata={"output": MetadataValue.text(result.stdout)})


@asset(group_name="dashboard", compute_kind="evidence", deps=[dbt_build])
def build_evidence_dashboard():
    """Rebuilds the Indonesian Evidence dashboard."""
    for cmd in [["npm", "run", "sources"], ["npm", "run", "build"]]:
        result = subprocess.run(
            cmd, capture_output=True, text=True,
            cwd=str(ROOT_DIR / "evidence"),
        )
        if result.returncode != 0:
            raise Exception(f"{' '.join(cmd)} failed:\n{result.stderr}")
    return Output(value="Dashboard (ID) rebuilt successfully")


# ── English dbt build ─────────────────────────────────────────────────────────

@asset(group_name="dbt_en", compute_kind="dbt", deps=[load_raw_to_duckdb_en])
def dbt_build_en():
    """Runs dbt build for the English project."""
    result = subprocess.run(
        ["dbt", "build"],
        capture_output=True, text=True,
        cwd=str(ROOT_DIR / "dbt_restaurant_en"),
    )
    output_text = result.stdout + result.stderr
    if result.returncode != 0:
        raise Exception(f"dbt build (EN) failed:\n{output_text}")
    return Output(value=output_text, metadata={"dbt_output": MetadataValue.text(output_text)})


@asset(group_name="alert_en", compute_kind="python", deps=[dbt_build_en])
def send_telegram_alert_en():
    """Sends daily Restaurant Report (EN) to owner via Telegram."""
    result = subprocess.run(
        ["python", str(ROOT_DIR / "scripts" / "telegram_alert_en.py")],
        capture_output=True, text=True, cwd=str(ROOT_DIR),
    )
    if result.returncode != 0:
        raise Exception(f"Telegram alert (EN) failed:\n{result.stderr}")
    return Output(value=result.stdout, metadata={"output": MetadataValue.text(result.stdout)})


@asset(group_name="dashboard_en", compute_kind="evidence", deps=[dbt_build_en])
def build_evidence_dashboard_en():
    """Rebuilds the English Evidence dashboard."""
    for cmd in [["npm", "run", "sources"], ["npm", "run", "build"]]:
        result = subprocess.run(
            cmd, capture_output=True, text=True,
            cwd=str(ROOT_DIR / "evidence_en"),
        )
        if result.returncode != 0:
            raise Exception(f"{' '.join(cmd)} failed:\n{result.stderr}")
    return Output(value="Dashboard (EN) rebuilt successfully")


# ── Git publish (shared) ──────────────────────────────────────────────────────

@asset(group_name="publish", compute_kind="git", deps=[dbt_build, dbt_build_en])
def push_to_github():
    """Pushes updated DuckDB files to GitHub after both builds complete."""
    for cmd in [
        ["git", "add", "data/warehouse.duckdb", "data/warehouse_en.duckdb"],
        ["git", "commit", "-m", f"chore: update daily data {date.today()}"],
        ["git", "push", "origin", "main"],
    ]:
        result = subprocess.run(cmd, capture_output=True, text=True, cwd=str(ROOT_DIR))
        if result.returncode != 0:
            raise Exception(f"Git command failed:\n{result.stderr}")
    return Output(value="GitHub updated successfully")

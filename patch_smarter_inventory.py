import re
from pathlib import Path

TARGET = Path("ingestion/generate_data_id.py")
src = TARGET.read_text()

OLD_INJECT = '''                # INJECT DEMO DATA
                if target_date == date_range[-1]:
                    if item["inventory_id"] == "INV01" and branch["branch_id"] == "BR01":
                        closing_stock = avg_daily_usage * 1.5
                    elif item["inventory_id"] == "INV02" and branch["branch_id"] == "BR02":
                        closing_stock = avg_daily_usage * 1.0
                    elif item["inventory_id"] == "INV03" and branch["branch_id"] == "BR03":
                        closing_stock = avg_daily_usage * 20.0'''

NEW_INJECT = '''                # INJECT DEMO DATA (SMART ENGINEERED SCENARIOS)
                # Overstock Scenario: Kopi / Teh Celup (INV06) at Cabang Pusat (BR01)
                if item["inventory_id"] == "INV06" and branch["branch_id"] == "BR01":
                    closing_stock = avg_daily_usage * 28.0  # 28 days coverage
                # Low Stock Scenario: Daging Ayam (INV01) at Cabang Selatan (BR02)
                elif item["inventory_id"] == "INV01" and branch["branch_id"] == "BR02":
                    closing_stock = avg_daily_usage * 1.2   # 1.2 days coverage
                # Mutasi Scenario: Daging Ayam (INV01) at Cabang Utara (BR03)
                elif item["inventory_id"] == "INV01" and branch["branch_id"] == "BR03":
                    closing_stock = avg_daily_usage * 18.0  # 18 days coverage
                # Mutasi Scenario: Minyak Goreng (INV03) at Cabang Timur (BR04) needs it, Cabang Pusat (BR01) has it
                elif item["inventory_id"] == "INV03" and branch["branch_id"] == "BR04":
                    closing_stock = avg_daily_usage * 0.8
                elif item["inventory_id"] == "INV03" and branch["branch_id"] == "BR01":
                    closing_stock = avg_daily_usage * 15.0'''

if OLD_INJECT in src:
    src = src.replace(OLD_INJECT, NEW_INJECT)
    TARGET.write_text(src)
    print("Patch applied successfully.")
else:
    print("Old inject block not found.")

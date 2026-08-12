import glob
import os

for f in glob.glob("sources/restaurant/*.sql"):
    with open(f, "r") as file:
        content = file.read()
    
    if "estimated_stock_depletion" in content:
        content = content.replace("estimated_stock_depletion", "stock_on_hand")
        with open(f, "w") as file:
            file.write(content)

if os.path.exists("sources/restaurant/inventory_stok.sql"):
    os.rename("sources/restaurant/inventory_stok.sql", "sources/restaurant/inventory_stock.sql")

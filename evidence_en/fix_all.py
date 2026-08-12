import glob

# Replace all column references to estimated_stock_delta
def process(file_pattern):
    for f in glob.glob(file_pattern, recursive=True):
        try:
            with open(f, "r") as file:
                content = file.read()
            
            if "stock_on_hand" in content or "estimated_stock_depletion" in content:
                content = content.replace("stock_on_hand", "estimated_stock_delta")
                content = content.replace("estimated_stock_depletion", "estimated_stock_delta")
                with open(f, "w") as file:
                    file.write(content)
                print(f"Fixed {f}")
        except Exception as e:
            pass

process("pages/**/*.md")
process("sources/restaurant/**/*.sql")

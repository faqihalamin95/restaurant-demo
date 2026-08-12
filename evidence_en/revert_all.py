import glob

def process(file_pattern):
    for f in glob.glob(file_pattern, recursive=True):
        try:
            with open(f, "r") as file:
                content = file.read()
            
            if "estimated_stock_delta" in content:
                content = content.replace("estimated_stock_delta", "stock_on_hand")
                with open(f, "w") as file:
                    file.write(content)
                print(f"Reverted {f}")
        except Exception as e:
            pass

process("pages/**/*.md")
process("sources/restaurant/**/*.sql")

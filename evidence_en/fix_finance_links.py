import os

path = "pages/01-financial-report/index.md"
with open(path, "r") as f:
    content = f.read()

# Swap the links. Because one is 02 and one is 03, we can use a temporary placeholder.
content = content.replace("/01-financial-report/03-cost-breakdown", "/01-financial-report/TEMP-COST")
content = content.replace("/01-financial-report/02-trend", "/01-financial-report/03-trend")
content = content.replace("/01-financial-report/TEMP-COST", "/01-financial-report/02-cost-breakdown")

with open(path, "w") as f:
    f.write(content)
print("Updated index.md")

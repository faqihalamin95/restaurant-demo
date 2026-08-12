const fs = require('fs');
const dir = 'dbt_restaurant_en/models/marts/menu_performance';
const files = ['mart_menu_engineering_30d.sql', 'mart_menu_engineering_7d.sql', 'mart_menu_engineering_y.sql', 'mart_menu_branch_detail.sql'];
for (const file of files) {
  const filePath = `${dir}/${file}`;
  if (!fs.existsSync(filePath)) continue;
  let content = fs.readFileSync(filePath, 'utf8');
  content = content.replace(/total_margin>=MEDIAN\(total_margin\)/g, 'total_revenue>=MEDIAN(total_revenue)');
  content = content.replace(/total_margin<\s*MEDIAN\(total_margin\)/g, 'total_revenue< MEDIAN(total_revenue)');
  content = content.replace(/SUM\(total_revenue\) AS total_revenue, SUM\(total_margin\) AS total_margin,/g, 'SUM(total_revenue) AS total_revenue,');
  fs.writeFileSync(filePath, content);
  console.log(`Updated ${filePath}`);
}

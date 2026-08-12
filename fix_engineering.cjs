const fs = require('fs');

const dir = 'dbt_restaurant/models/marts/menu_performance';
const files = ['mart_menu_engineering_30d.sql', 'mart_menu_engineering_7d.sql', 'mart_menu_engineering_y.sql', 'mart_menu_branch_detail.sql'];

for (const file of files) {
  const filePath = `${dir}/${file}`;
  if (!fs.existsSync(filePath)) continue;
  
  let content = fs.readFileSync(filePath, 'utf8');

  // Replace total_revenue with total_margin in the MEDIAN logic
  // "total_revenue>=MEDIAN(total_revenue)" -> "total_margin>=MEDIAN(total_margin)"
  content = content.replace(/total_revenue>=MEDIAN\(total_revenue\)/g, 'total_margin>=MEDIAN(total_margin)');
  content = content.replace(/total_revenue<\s*MEDIAN\(total_revenue\)/g, 'total_margin< MEDIAN(total_margin)');
  
  // Also need to fetch total_margin in the base CTEs
  // e.g. SUM(total_revenue) AS total_revenue -> SUM(total_revenue) AS total_revenue, SUM(total_margin) AS total_margin
  content = content.replace(/SUM\(total_revenue\) AS total_revenue,/g, 'SUM(total_revenue) AS total_revenue, SUM(total_margin) AS total_margin,');

  fs.writeFileSync(filePath, content);
  console.log(`Updated ${filePath}`);
}

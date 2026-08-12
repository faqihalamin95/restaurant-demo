const duckdb = require('duckdb');
const db = new duckdb.Database('/home/faqih/projects/restaurant-demo/evidence/sources/restaurant/warehouse.duckdb', duckdb.OPEN_READONLY);
db.all("SELECT stock_on_hand, estimated_stock_delta FROM main_marts.mart_inventory_stok LIMIT 10;", function(err, res) {
  if (err) { console.error(err); }
  else { console.log(res); }
});

{{ config(materialized='table') }}

SELECT DISTINCT branch_name
FROM {{ ref('mart_menu_performance') }}
ORDER BY branch_name
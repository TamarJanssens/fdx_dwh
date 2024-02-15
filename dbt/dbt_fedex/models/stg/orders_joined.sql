{{ config(materialized='view') }}

SELECT
{{ dbt_utils.star(from=ref('orders'), relation_alias = 'o') }}
, {{ dbt_utils.star(from=ref('orderItems'),except=['order_id'], relation_alias = 'i') }}
,{{ dbt_utils.star(from=ref('date'),except=['date_id'], relation_alias = 'd') }}
,{{ dbt_utils.star(from=ref('sku'),except=['sku_id'], relation_alias = 's') }}
,{{ dbt_utils.star(from=ref('cityState'),except=['cityState_id','country_id'], relation_alias = 'cs') }}
,{{ dbt_utils.star(from=ref('country'),except=['country_id'], relation_alias = 'c') }}
FROM {{ref('orders')}} o
INNER JOIN {{ref('orderItems')}} i ON i.order_id = o.order_id
LEFT JOIN {{ref('date')}} d ON d.date_id = o.date_id
LEFT JOIN {{ref('sku')}} s ON s.sku_id = i.sku_id
LEFT JOIN {{ref('cityState')}} cs ON cs.cityState_id = o.cityState_id
LEFT JOIN {{ref('country')}} c ON c.country_id = o.country_id
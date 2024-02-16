{% set year_query %}
    SELECT DISTINCT year
    FROM {{ ref('orders_joined') }}
    WHERE country_id = 'IN'
{% endset %}

{% set years = [] %}
{% if execute %}
    {% set results = run_query(year_query) %}
    {% for row in results.rows %}
        {% do years.append(row[0]) %}
    {% endfor %}
{% endif %}

WITH selected_data AS (
    SELECT
        sku_id
        , CAST(year as nvarchar) as year
        , COUNT(order_id) as n_orders
    FROM {{ref('orders_joined')}}
    WHERE country_id = 'IN'
    GROUP BY sku_id, year
    
)
SELECT
    sku_id
    {% for year in years %}
        , SUM(CASE WHEN year = '{{ year }}' THEN n_orders ELSE 0 END) AS "year_{{ year }}"
    {% endfor %}
FROM selected_data
GROUP BY sku_id



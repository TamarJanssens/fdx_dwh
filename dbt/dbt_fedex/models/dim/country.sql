{{ config({
    "post-hook": [
        "{{ create_nonclustered_index(columns = ['country_id']) }}"
    ]
    })
}}
WITH countries AS (
    SELECT
    [ISO3166-1-Alpha-2] as country_id
    *
    FROM ref('countries')

)
SELECT
CAST(country AS nvarchar(3) AS country_id
, CASE 
    WHEN country IS NULL THEN 'NOT_SET'
    ELSE country
END AS country
FROM countries
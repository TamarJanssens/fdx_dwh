{{ config({
    "post-hook": [
        "{{ create_nonclustered_index(columns = ['sku_id']) }}"
    ]
    })
}}
with sku_data AS (
    SELECT
        CAST(sku as nvarchar(29)) as sku_id
        , style
        , category
        , size
        , [asin]
    FROM {{source('raw','raw_data')}}
)
SELECT 
    sku.*
FROM sku_data sku
{{ config({
    "post-hook": [
        "{{ create_nonclustered_index(columns = ['orderItem_id']) }}"
        ,"{{ create_nonclustered_index(columns = ['order_id']) }}"
        ,"{{ create_nonclustered_index(columns = ['sku_id']) }}"
    ]
    })
}}

with orderItems_data AS (
    SELECT
        CAST(orderId AS varchar(19)) as order_id
        , CAST(sku AS varchar(29)) as sku_id
        , qty
        , currency
        , amount
        , promotionIds
        , courierStatus
        , fulfilledBy
    FROM {{source('raw','raw_data')}}
)
SELECT 
    {{dbt_utils.generate_surrogate_key(['o.order_id','sku.sku_id'])}} AS orderItem_id
    , o.order_id as order_id
    , sku.sku_id as sku_id
    , qty
    , currency
    , amount
    , promotionIds
    , courierStatus
    , fulfilledBy
FROM orderItems_data i
LEFT JOIN {{ref('sku')}} sku ON sku.sku_id = i.sku_id {# not really needed but if logic would change, this would retrieve the right id #}
LEFT JOIN {{ref('orders')}} o ON o.order_id = i.order_id {# not really needed but if logic would change, this would retrieve the right id #}
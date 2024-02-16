{{ config({
    "post-hook": [
        "{{ create_nonclustered_index(columns = ['order_id']) }}"
        ,"{{ create_nonclustered_index(columns = ['date_id']) }}"
    ]
    })
}}
with order_data AS (
    SELECT
        CAST(orderId as varchar(19)) as order_id
        , CONVERT(INT, REPLACE(CONVERT(VARCHAR, [date], 112), '-', '')) AS full_date
        , status
        , b2b
        , fulfilment
        , salesChannel
        , shipServiceLevel
        , {{dbt_utils.generate_surrogate_key(['shipCity','shipState'])}} AS cityState_id
        , shipPostalCode
        , c.country_id
    FROM {{source('raw','raw_data')}} s
    LEFT JOIN {{ref('country')}} c ON c.country_id = s.shipCountry
)
SELECT 
    DISTINCT u.order_id 
    , d.date_id as date_id
    , o.status
    , o.b2b
    , o.fulfilment
    , o.salesChannel
    , o.shipServiceLevel
    , u.cityState_id
    , u.shipPostalCode
    , u.country_id
FROM order_data u
LEFT JOIN {{ref('date')}} d ON d.date_id = u.full_date
LEFT JOIN order_data o ON o.order_id = u.order_id {# dbt_utils.deduplicate() would also be feasible, however this join will create duplites if my assumptions are violated and will be catched with dbt test #}

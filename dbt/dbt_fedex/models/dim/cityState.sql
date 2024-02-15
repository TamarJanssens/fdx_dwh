with cityState AS (
{{ config({
    "post-hook": [
        "{{ create_nonclustered_index(columns = ['cityState_id']) }}"
    ]
    })
}}


SELECT DISTINCT
      shipCity
      ,shipState
      ,shipCountry
  FROM {{source('raw','raw_data')}}
)
SELECT 
{{dbt_utils.generate_surrogate_key(['shipCity','shipState'])}} AS cityState_id
    , cs.shipCity
    , cs.shipState
    , c.country_id
from cityState cs
LEFT JOIN country c ON c.country_id = cs.shipCountry
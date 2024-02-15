{% set start_date_query %}
WITH min_date AS (
    SELECT 
    MIN(date) AS minimum_date
    FROM {{source('raw','raw_data')}}
)
select 
    CAST(DATEFROMPARTS(
            CAST(YEAR(minimum_date) AS INT),
            1,
            1
        )
    AS DATE) AS start_date
    FROM min_date
{% endset %}
    

{% set end_date_query %}
WITH max_date AS (
    SELECT 
    MAX(date) AS maximum_date
    FROM {{source('raw','raw_data')}}
)
select 
    DATEADD(day,1,CAST(DATEFROMPARTS(
            CAST(YEAR(maximum_date) AS INT),
            12,
            31
        )
    AS DATE)) AS end_date
    FROM max_date
{% endset %}


{% if execute %}

    {% set results_start_date = run_query(start_date_query) %}
    {% set results_end_date = run_query(end_date_query) %}
    
    with 
    date_dimension as (

        {{ dim_date_azure(results_start_date.columns[0][0], results_end_date.columns[0][0]) }}

    )
    SELECT
    CONVERT(VARCHAR, full_date, 112) AS date_id
    , CAST(full_date as date) as date
    , YEAR(full_date) AS year
    , MONTH(full_date) AS month
    , DAY(full_date) AS day
    from date_dimension

{% endif %}

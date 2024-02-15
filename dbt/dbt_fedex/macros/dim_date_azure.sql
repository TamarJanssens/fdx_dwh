
{% macro dim_date_azure(start_date, end_date) %}
    {#
        credits: https://medium.com/@moralescas/creating-date-dimensions-using-dbt-in-azure-synapse-custom-macros-e1afb211bb5d
    #}
    select 
    cast(dateadd(day, rn - 1, '{{ start_date }}') as date) as full_date
    from 
    (
        select 
        top (datediff(day, '{{ start_date }}', '{{ end_date }}')) 
        row_number() over (order by s1.[object_id]) as rn
        from 
            sys.all_objects as s1
        cross join 
            sys.all_objects as s2
        order by 
            s1.[object_id]

    ) as system_row

{% endmacro %}
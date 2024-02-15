{% macro create_clustered_index(columns, unique=False) -%}

{{ log("Creating clustered index...") }}

{% set idx_name = "clustered_" + local_md5(columns | join("_")) %}

if not exists(select *
                from sys.indexes {{ information_schema_hints() }}
                where name = '{{ idx_name }}'
                and object_id = OBJECT_ID('{{ this }}')
)
begin

create
{% if unique -%}
unique
{% endif %}
clustered index
    {{ idx_name }}
      on {{ this }} ({{ '[' + columns|join("], [") + ']' }})
end
{%- endmacro %}

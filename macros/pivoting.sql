{% macro unpivot(relation, cast_to, exclude, remove, field_name, value_name) %}
    {{ dbt_utils.unpivot(
        relation=relation,
        cast_to=cast_to,
        exclude=exclude,
        remove=remove,
        field_name=field_name,
        value_name=value_name
    ) }}
{% endmacro %}
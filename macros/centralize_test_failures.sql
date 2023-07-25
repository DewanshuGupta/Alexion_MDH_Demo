{% macro centralize_test_failures(results) %}

  {%- set test_results = [] -%}
  {%- for result in results -%}
    {%- if result.node.resource_type == 'test' and result.status != 'skipped' and (
          result.node.config.get('store_failures') or flags.STORE_FAILURES
      )
    -%}
      {%- do test_results.append(result) -%}
    {%- endif -%}
  {%- endfor -%}

  {%- set central_tbl -%} {{ target.schema }}.test_failure_central {%- endset -%}

  {{ log("Centralizing test failures in " + central_tbl, info=true) if execute }}

  CREATE OR REPLACE TABLE {{ central_tbl }} AS (

  {% for result in test_results %}

    SELECT
      '{{ result.node.name }}' AS test_name,
      OBJECT_CONSTRUCT_KEEP_NULL(*) AS test_failures_json,
      CASE
        WHEN '{{ result.node.name }}' LIKE '%source_not_null_tpch_lineitem_l_suppkey%' THEN 'High'  -- Modify 'your_substring' with the substring you want to match
        ELSE 'Unknown'
      END AS severity -- Modify the conditions as per your specific requirements

    FROM {{ result.node.relation_name }}

    {{ "UNION ALL" if not loop.last }}

  {% endfor %}

  );

{% endmacro %}

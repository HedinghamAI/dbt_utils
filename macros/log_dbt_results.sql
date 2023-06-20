-- Gets the results of a dbt run as an input parameter
-- Flattens the results using parse_dbt_results
-- Inserts into dbt_results table 

-- ref: https://medium.com/@oravidov/dbt-observability-101-how-to-monitor-dbt-run-and-test-results-f7e5f270d6b6

{% macro log_dbt_results(results) %}
    -- depends_on: {{ ref('dbt_results') }}
    {%- if execute -%}
        {%- set parsed_results = dbt_utils_hedingham.parse_dbt_results(results) -%}
        {%- if parsed_results | length  > 0 -%}
            {% set insert_dbt_results_query -%}
                insert into {{ ref('dbt_results') }}
                    (
                        `result_id`,
                        `invocation_id`,
                        `unique_id`,
                        `database_name`,
                        `schema_name`,
                        `name`,
                        `resource_type`,
                        `status`,
                        `execution_time`,
                        `rows_affected`, 
                        `created_at`, 
                        `message`
                ) values
                    {%- for parsed_result_dict in parsed_results -%}
                        (
                            '{{ parsed_result_dict.get('result_id') }}',
                            '{{ parsed_result_dict.get('invocation_id') }}',
                            '{{ parsed_result_dict.get('unique_id') }}',
                            '{{ parsed_result_dict.get('database_name') }}',
                            '{{ parsed_result_dict.get('schema_name') }}',
                            '{{ parsed_result_dict.get('name') }}',
                            '{{ parsed_result_dict.get('resource_type') }}',
                            '{{ parsed_result_dict.get('status') }}',
                            {{ parsed_result_dict.get('execution_time') }},
                            {{ parsed_result_dict.get('rows_affected') }}, 
                            current_timestamp, 
                            '{{ parsed_result_dict.get('message') }}'
                        ) {{- "," if not loop.last else "" -}}
                    {%- endfor -%}
            {%- endset -%}
        {{ return (insert_dbt_results_query) }}   
        {%- endif -%}
    {%- endif -%}
    
{% endmacro %}
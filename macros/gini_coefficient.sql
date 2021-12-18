{% macro gini_coefficient(source_table, value_column) %}
    {{ return(adapter.dispatch('gini_coefficient','dbt_stats') (source_table, value_column)) }}
{% endmacro %}


{% macro default__gini_coefficient(source_table, value_column) -%}
with cum_values as (
    select
        source_table.{{ value_column }} as {{ value_column }},
        sum(source_table.{{ value_column }}) over (
            order by source_table.{{ value_column }} asc
            rows between unbounded preceding and current row) as cumsum_{{ value_column }},
        sum(source_table.{{ value_column }}) over () as sum_{{ value_column }},
        count(source_table.{{ value_column }}) over (
            order by source_table.{{ value_column }} asc 
            rows between unbounded preceding and current row) as cumcount_{{ value_column }},
        count(source_table.{{ value_column }}) over () as count_{{ value_column }}
    from
        {{ source_table }} as source_table
    order by source_table.{{ value_column }}
),
gini_curve as (
    select
        null as {{ value_column }},
        0 as prop_sum_{{ value_column }},
        {{ min_value }} as prop_count_


    select
        cum_values.{{ value_column }} as {{ value_column }},
        cum_values.cumsum_{{ value_column }}/nullif(cum_values.sum_{{ value_column }},0) as prop_sum_{{ value_column }},
        cum_values.cumcount_{{ value_column }}/nullif(cum_values.count_{{ value_column }},0) as prop_count_{{ value_column }},
    from
        cum_values
    order by cum_values.{{ value_column }} asc
),
gini_curve_lags as (
    select
        gini_curve.{{ value_column }},
        gini_curve.prop_sum_{{ value_column }},
        lag(gini_curve.prop_sum_{{ value_column }},1) over (order by gini_curve.{{ value_column }} asc) as prop_sum_{{ value_column }}_lag,
        gini_curve.prop_count_{{ value_column }},
        lag(gini_curve.prop_count_{{ value_column }},1) over (order by gini_curve.{{ value_column }} asc) as prop_count_{{ value_column }}_lag
    from
        gini_curve
    order by gini_curve.{{ value_column }} asc
),
gini_curve_areas as (
    select
        gini_curve_lags.{{ value_column }},
        1/2 * (gini_curve_lags.prop_sum_{{ value_column }} + gini_curve_lags.prop_sum_{{ value_column }}_lag)/nullif(gini_curve_lags.prop_count_{{ value_column }} - prop_count_{{ value_column }}_lag,0) as area
    from
        gini_curve_lags
    order by gini_curve_lags.{{ value_column }} asc
)

select
    1- 2* sum(coalesce(gini_curve_areas.areas,0)) as gini_coefficient_{{ value_column }}
from gini_curve_areas
{% endmacro %}
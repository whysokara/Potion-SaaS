with growth as (
    select * from {{ ref('int_analytics__growth_metrics') }}
),
kpis as (
    select * from {{ ref('int_analytics__business_kpis') }}
),
final as (
    select
        growth.*,
        kpis.metric_type,
        kpis.metric_value_1,
        kpis.metric_value_2
    from growth
    left join kpis on growth.report_month = kpis.activity_month
)
select * from final

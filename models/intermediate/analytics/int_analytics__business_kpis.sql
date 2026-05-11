with dau_mau as (
    select * from {{ ref('stg_analytics__dau_mau') }}
),
cohorts as (
    select * from {{ ref('stg_analytics__cohorts') }}
),
funnel as (
    select * from {{ ref('stg_analytics__funnel') }}
),
final as (
    select
        'engagement' as metric_type,
        report_month as activity_month,
        daily_active_users as metric_value_1,
        monthly_active_users as metric_value_2,
        null as metric_value_3
    from dau_mau
    
    union all
    
    select
        'funnel' as metric_type,
        report_month as activity_month,
        signups as metric_value_1,
        activated_users as metric_value_2,
        converted_to_paid as metric_value_3
    from funnel
)
select * from final

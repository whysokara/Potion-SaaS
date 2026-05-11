with source as (
    select * from {{ source('analytics', 'analytics_cac_ltv') }}
),
renamed as (
    select
        month as report_month,
        channel,
        new_signups,
        converted_to_paid,
        conversion_rate_pct,
        cac_usd as customer_acquisition_cost,
        avg_ltv_usd as lifetime_value,
        ltv_to_cac_ratio,
        payback_period_months
    from source
)
select * from renamed

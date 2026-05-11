with cac_ltv as (
    select * from {{ ref('stg_analytics__cac_ltv') }}
),
final as (
    select
        report_month,
        channel,
        new_signups,
        converted_to_paid,
        conversion_rate_pct,
        customer_acquisition_cost,
        lifetime_value,
        ltv_to_cac_ratio,
        payback_period_months
    from cac_ltv
)
select * from final

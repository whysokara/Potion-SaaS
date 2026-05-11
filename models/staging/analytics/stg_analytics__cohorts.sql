with source as (
    select * from {{ source('analytics', 'analytics_cohorts') }}
),
renamed as (
    select
        cohort_month,
        cohort_size,
        m1_retention_pct as month_1_retention_pct,
        m3_retention_pct as month_3_retention_pct,
        m6_retention_pct as month_6_retention_pct
    from source
)
select * from renamed

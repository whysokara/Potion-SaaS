with source as (
    select * from {{ source('analytics', 'analytics_dau_mau') }}
),
renamed as (
    select
        month as report_month,
        dau_avg as daily_active_users,
        mau as monthly_active_users,
        dau_mau_ratio as stickiness_ratio
    from source
)
select * from renamed

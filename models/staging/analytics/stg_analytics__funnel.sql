with source as (
    select * from {{ source('analytics', 'analytics_funnel') }}
),
renamed as (
    select
        month as report_month,
        visitors,
        signups,
        activated_users,
        converted_to_paid
    from source
)
select * from renamed

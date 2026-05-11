with source as (
    select * from {{ source('product', 'product_feature_usage') }}
),
renamed as (
    select
        usage_id,
        user_id,
        feature as feature_name,
        plan as user_plan,
        usage_count,
        first_used_date as first_used_at,
        last_used_date as last_used_at
    from source
)
select * from renamed

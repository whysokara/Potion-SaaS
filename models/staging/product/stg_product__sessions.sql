with source as (
    select * from {{ source('product', 'product_sessions') }}
),
renamed as (
    select
        session_id,
        user_id,
        plan as user_plan,
        session_start as started_at_timestamp,
        duration_seconds,
        device,
        browser,
        country
    from source
)
select * from renamed

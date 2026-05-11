with source as (
    select * from {{ source('product', 'product_events') }}
),
renamed as (
    select
        event_id,
        session_id,
        user_id,
        event_type,
        event_time as event_at_timestamp,
        plan as user_plan,
        properties as event_properties
    from source
)
select * from renamed

{{
    config(
        materialized='incremental',
        unique_key='event_id'
    )
}}

with source as (
    select * from {{ source('product', 'product_events') }}
    {% if is_incremental() %}
    -- 6 hour lookback for late arriving data
    where event_time > (select dateadd('hour', -6, max(event_at_timestamp)) from {{ this }})
    {% endif %}
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

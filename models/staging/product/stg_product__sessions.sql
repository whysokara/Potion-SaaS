{{
    config(
        materialized='incremental',
        unique_key='session_id'
    )
}}

with source as (
    select * from {{ source('product', 'product_sessions') }}
    {% if is_incremental() %}
    -- 6 hour lookback for late arriving data
    where session_start > (select dateadd('hour', -6, max(started_at_timestamp)) from {{ this }})
    {% endif %}
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

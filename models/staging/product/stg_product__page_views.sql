{{
    config(
        materialized='incremental',
        unique_key='page_view_id'
    )
}}

with source as (
    select * from {{ source('product', 'product_page_views') }}
    {% if is_incremental() %}
    -- 6 hour lookback for late arriving data
    where viewed_at > (select dateadd('hour', -6, max(viewed_at_timestamp)) from {{ this }})
    {% endif %}
),
renamed as (
    select
        pv_id as page_view_id,
        session_id,
        user_id,
        page as url,
        viewed_at as viewed_at_timestamp,
        time_on_page_seconds as duration_seconds
    from source
)
select * from renamed

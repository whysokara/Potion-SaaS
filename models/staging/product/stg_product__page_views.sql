with source as (
    select * from {{ source('product', 'product_page_views') }}
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

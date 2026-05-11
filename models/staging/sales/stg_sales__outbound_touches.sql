with source as (
    select * from {{ source('sales', 'sales_outbound_touches') }}
),
renamed as (
    select
        touch_id,
        target_id as user_id,
        touch_type,
        sent_at as touched_at_timestamp,
        responded as is_responded,
        owner as touch_owner
    from source
)
select * from renamed

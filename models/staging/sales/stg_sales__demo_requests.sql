with source as (
    select * from {{ source('sales', 'sales_demo_requests') }}
),
renamed as (
    select
        demo_id,
        user_id,
        source as demo_source,
        requested_at as requested_at_timestamp,
        scheduled as is_scheduled,
        showed_up as is_showed_up,
        converted_to_paid as is_converted_to_paid,
        owner as demo_owner,
        notes
    from source
)
select * from renamed

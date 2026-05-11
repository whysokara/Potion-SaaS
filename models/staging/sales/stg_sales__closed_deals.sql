with source as (
    select * from {{ source('sales', 'sales_closed_deals') }}
),
renamed as (
    select
        deal_id,
        user_id,
        deal_name,
        deal_value_usd as amount,
        stage as deal_stage,
        created_date as created_at_timestamp,
        close_date as closed_at_timestamp,
        deal_type,
        owner as deal_owner,
        sales_cycle_days,
        competitor_mentioned
    from source
)
select * from renamed

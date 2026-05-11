with source as (

    select * from {{ source('hubspot', 'hubspot_deals') }}

),

renamed as (

    select
        deal_id,
        user_id,
        deal_name,
        amount_usd as amount,
        stage as deal_stage,
        created_date as created_at_timestamp,
        close_date as closed_at_timestamp,
        deal_type,
        owner as deal_owner

    from source

)

select * from renamed

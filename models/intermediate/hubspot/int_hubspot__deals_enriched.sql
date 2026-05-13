with deals as (

    select * from {{ ref('stg_hubspot__deals') }}

),

contacts as (

    select * from {{ ref('stg_hubspot__contacts') }}

),

joined as (

    select
        deals.deal_id,
        deals.user_id,
        deals.deal_name,
        deals.amount,
        deals.deal_stage,
        deals.created_at_timestamp,
        deals.closed_at_timestamp,
        deals.deal_type,
        deals.deal_owner,
        contacts.lead_source,
        contacts.country as contact_country

    from deals
    inner join contacts 
        on deals.user_id = contacts.user_id

)

select * from joined

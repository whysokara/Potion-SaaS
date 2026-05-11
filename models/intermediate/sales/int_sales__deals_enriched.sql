with deals as (
    select * from {{ ref('stg_sales__closed_deals') }}
),
contacts as (
    select * from {{ ref('stg_hubspot__contacts') }}
),
joined as (
    select
        deals.*,
        contacts.lead_source,
        contacts.industry,
        contacts.company_size
    from deals
    left join contacts on deals.user_id = contacts.user_id
)
select * from joined

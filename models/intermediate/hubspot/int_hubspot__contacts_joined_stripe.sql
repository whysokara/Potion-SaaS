with contacts as (

    select * from {{ ref('stg_hubspot__contacts') }}

),

stripe_customers as (

    select * from {{ ref('stg_stripe__customers') }}

),

joined as (

    select
        contacts.user_id,
        contacts.hs_contact_id,
        stripe_customers.stripe_customer_id,
        contacts.email,
        contacts.first_name,
        contacts.last_name,
        contacts.country,
        contacts.lifecycle_stage,
        contacts.lead_source,
        contacts.plan as hubspot_plan,
        stripe_customers.currency,
        contacts.created_at_timestamp as contact_created_at,
        stripe_customers.created_at_timestamp as stripe_customer_created_at,
        contacts.industry,
        contacts.company_size,
        contacts.is_subscribed_to_marketing

    from contacts
    left join stripe_customers 
        on contacts.user_id = stripe_customers.user_id

)

select * from joined

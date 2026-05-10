with source as (

    select * from {{ source('stripe', 'stripe_subscriptions') }}

),

renamed as (

    select
        subscription_id,
        stripe_customer_id,
        user_id,
        plan as plan_name,
        status as subscription_status,
        amount_usd,
        billing_interval,
        started_at as started_at_timestamp,
        canceled_at as canceled_at_timestamp,
        upgraded_to_business as is_upgraded_to_business

    from source

)

select * from renamed

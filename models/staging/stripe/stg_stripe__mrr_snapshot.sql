with source as (

    select * from {{ source('stripe', 'stripe_mrr_snapshot') }}

),

renamed as (

    select
        month,
        mrr_usd,
        active_subscriptions,
        new_subscriptions,
        churned_subscriptions,
        pro_subs,
        business_subs

    from source

)

select * from renamed

with source as (

    select * from {{ source('stripe', 'stripe_customers') }}

),

renamed as (

    select
        stripe_customer_id,
        user_id,
        email,
        country,
        created_at as created_at_timestamp,
        delinquent as is_delinquent,
        currency,
        default_payment_method

    from source

)

select * from renamed

{{
    config(
        materialized='incremental',
        unique_key='invoice_id'
    )
}}

with source as (

    select * from {{ source('stripe', 'stripe_invoices') }}

),

renamed as (

    select
        invoice_id,
        subscription_id,
        user_id,
        amount_usd,
        status as invoice_status,
        invoice_date,
        plan as plan_name

    from source

)

select * from renamed

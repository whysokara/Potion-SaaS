{{
    config(
        materialized='incremental',
        unique_key='stripe_customer_id'
    )
}}

with intermediate_customers as (
    select * from {{ ref('int_stripe__customers') }}
)

select * from intermediate_customers

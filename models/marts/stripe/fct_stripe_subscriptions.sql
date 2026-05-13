{{
    config(
        materialized='incremental',
        unique_key='subscription_id'
    )
}}

with intermediate_subscriptions as (
    select * from {{ ref('int_stripe__subscriptions') }}
)

select * from intermediate_subscriptions

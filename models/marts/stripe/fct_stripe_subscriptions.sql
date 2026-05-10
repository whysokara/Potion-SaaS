with intermediate_subscriptions as (
    select * from {{ ref('int_stripe__subscriptions') }}
)

select * from intermediate_subscriptions

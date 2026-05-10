with subscriptions as (
    select * from {{ ref('stg_stripe__subscriptions') }}
),
customers as (
    select * from {{ ref('stg_stripe__customers') }}
)

select
    s.subscription_id,
    s.stripe_customer_id,
    s.user_id,
    c.email,
    c.country,
    s.plan_name,
    s.subscription_status,
    s.amount_usd,
    s.billing_interval,
    s.started_at_timestamp,
    s.canceled_at_timestamp,
    s.is_upgraded_to_business,
    c.is_delinquent
from subscriptions s
left join customers c on s.user_id = c.user_id

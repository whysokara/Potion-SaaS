with invoices as (
    select * from {{ ref('stg_stripe__invoices') }}
),
customers as (
    select * from {{ ref('stg_stripe__customers') }}
)

select
    i.invoice_id,
    i.subscription_id,
    i.user_id,
    c.stripe_customer_id,
    c.email,
    c.country,
    i.amount_usd,
    i.invoice_status,
    i.invoice_date,
    i.plan_name,
    c.is_delinquent
from invoices i
left join customers c on i.user_id = c.user_id

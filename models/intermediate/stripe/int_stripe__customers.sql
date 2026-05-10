with customers as (
    select * from {{ ref('stg_stripe__customers') }}
),
metrics as (
    select * from {{ ref('int_stripe__customer_metrics') }}
)

select
    c.stripe_customer_id,
    c.user_id,
    c.email,
    c.country,
    c.created_at_timestamp,
    c.is_delinquent,
    c.currency,
    c.default_payment_method,
    coalesce(m.total_invoices, 0) as total_invoices,
    coalesce(m.total_revenue_usd, 0) as total_revenue_usd,
    m.first_invoice_date,
    m.latest_invoice_date,
    m.current_subscription_id,
    m.current_plan_name,
    m.current_subscription_status,
    coalesce(m.current_mrr, 0) as current_mrr
from customers c
left join metrics m on c.user_id = m.user_id

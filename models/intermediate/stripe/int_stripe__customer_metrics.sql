with invoices as (
    select * from {{ ref('stg_stripe__invoices') }}
),
subscriptions as (
    select * from {{ ref('stg_stripe__subscriptions') }}
),
customer_invoices as (
    select
        user_id,
        count(invoice_id) as total_invoices,
        sum(case when invoice_status = 'paid' then amount_usd else 0 end) as total_revenue_usd,
        min(invoice_date) as first_invoice_date,
        max(invoice_date) as latest_invoice_date
    from invoices
    group by 1
),
active_subscriptions as (
    select
        user_id,
        subscription_id as current_subscription_id,
        plan_name as current_plan_name,
        subscription_status as current_subscription_status,
        amount_usd as current_mrr
    from (
        select *,
               row_number() over (partition by user_id order by started_at_timestamp desc) as rn
        from subscriptions
        where subscription_status in ('active', 'past_due')
    )
    where rn = 1
)

select
    coalesce(ci.user_id, subs.user_id) as user_id,
    coalesce(ci.total_invoices, 0) as total_invoices,
    coalesce(ci.total_revenue_usd, 0) as total_revenue_usd,
    ci.first_invoice_date,
    ci.latest_invoice_date,
    subs.current_subscription_id,
    subs.current_plan_name,
    subs.current_subscription_status,
    coalesce(subs.current_mrr, 0) as current_mrr
from customer_invoices ci
full outer join active_subscriptions subs on ci.user_id = subs.user_id

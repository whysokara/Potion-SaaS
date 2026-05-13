{{
    config(
        materialized='incremental',
        unique_key='user_id'
    )
}}

with customer_base as (

    select * from {{ ref('int_hubspot__contacts_joined_stripe') }}

),

customer_metrics as (

    select * from {{ ref('int_stripe__customer_metrics') }}

),

final as (

    select
        customer_base.user_id,
        customer_base.hs_contact_id,
        customer_base.stripe_customer_id,
        customer_base.email,
        customer_base.first_name,
        customer_base.last_name,
        customer_base.country,
        customer_base.lifecycle_stage,
        customer_base.lead_source,
        customer_base.industry,
        customer_base.company_size,
        
        -- Revenue metrics from Stripe
        coalesce(customer_metrics.total_revenue_usd, 0) as total_revenue,
        coalesce(customer_metrics.total_invoices, 0) as total_invoices_paid,
        customer_metrics.latest_invoice_date as last_payment_date,
        
        -- Subscription Status
        customer_metrics.current_plan_name,
        customer_metrics.current_subscription_status,
        
        -- Customer Status
        case 
            when customer_metrics.total_revenue_usd > 0 then 'paying'
            else 'non-paying'
        end as customer_status,

        customer_base.contact_created_at

    from customer_base
    left join customer_metrics 
        on customer_base.user_id = customer_metrics.user_id

)

select * from final

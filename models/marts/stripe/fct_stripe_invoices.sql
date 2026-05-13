{{
    config(
        materialized='incremental',
        unique_key='invoice_id'
    )
}}

with intermediate_invoices as (
    select * from {{ ref('int_stripe__invoices') }}
)

select * from intermediate_invoices

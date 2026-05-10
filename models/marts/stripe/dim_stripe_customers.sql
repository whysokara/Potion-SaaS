with intermediate_customers as (
    select * from {{ ref('int_stripe__customers') }}
)

select * from intermediate_customers

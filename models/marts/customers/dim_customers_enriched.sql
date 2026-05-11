with engagement as (
    select * from {{ ref('int_product__user_engagement_agg') }}
),
customers as (
    select * from {{ ref('dim_customers') }}
),
joined as (
    select
        customers.*,
        coalesce(engagement.unique_features_used, 0) as unique_features_used,
        coalesce(engagement.total_feature_actions, 0) as total_feature_actions,
        engagement.first_product_activity,
        engagement.last_product_activity
    from customers
    left join engagement on customers.user_id = engagement.user_id
)
select * from joined

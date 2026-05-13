with usage as (
    select * from {{ ref('stg_product__feature_usage') }}
),
agg as (
    select
        user_id,
        count(distinct feature_name) as unique_features_used,
        sum(usage_count) as total_feature_actions,
        min(first_used_at) as first_product_activity,
        max(last_used_at) as last_product_activity
    from usage
    group by 1
),
contacts as (
    select * from {{ ref('stg_hubspot__contacts') }}
),
final as (
    select
        agg.*
    from agg
    inner join contacts on agg.user_id = contacts.user_id
)
select * from final

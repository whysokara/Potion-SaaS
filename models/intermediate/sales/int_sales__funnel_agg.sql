with touches as (
    select * from {{ ref('stg_sales__outbound_touches') }}
),
demos as (
    select * from {{ ref('stg_sales__demo_requests') }}
),
deals as (
    select * from {{ ref('stg_sales__closed_deals') }}
),
joined as (
    select
        touches.user_id,
        count(distinct touches.touch_id) as total_outbound_touches,
        count(distinct demos.demo_id) as total_demos_requested,
        count(distinct case when demos.is_showed_up then demos.demo_id end) as total_demos_attended,
        count(distinct deals.deal_id) as total_deals_closed
    from touches
    left join demos on touches.user_id = demos.user_id
    left join deals on touches.user_id = deals.user_id
    group by 1
)
select * from joined

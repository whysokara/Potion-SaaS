with events as (
    select * from {{ ref('int_product__events_enriched') }}
),
daily_active_users as (
    select
        date_trunc('day', event_at_timestamp::timestamp) as activity_date,
        count(distinct user_id) as dau
    from events
    group by 1
)
select * from daily_active_users

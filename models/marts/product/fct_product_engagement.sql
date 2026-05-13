{{
    config(
        materialized='incremental',
        unique_key='activity_date'
    )
}}

with events as (
    select * from {{ ref('int_product__events_enriched') }}
    {% if is_incremental() %}
    -- 3 day lookback for late arriving events impacting aggregates
    where event_at_timestamp::timestamp >= (select dateadd('day', -3, max(activity_date)) from {{ this }})
    {% endif %}
),
daily_active_users as (
    select
        date_trunc('day', event_at_timestamp::timestamp) as activity_date,
        count(distinct user_id) as dau
    from events
    group by 1
)
select * from daily_active_users

with events as (
    select * from {{ ref('stg_product__events') }}
),
sessions as (
    select * from {{ ref('stg_product__sessions') }}
),
joined as (
    select
        events.*,
        sessions.device,
        sessions.browser,
        sessions.duration_seconds as session_duration
    from events
    left join sessions on events.session_id = sessions.session_id
)
select * from joined

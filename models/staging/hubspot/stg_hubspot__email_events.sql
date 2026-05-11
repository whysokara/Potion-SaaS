with source as (

    select * from {{ source('hubspot', 'hubspot_email_events') }}

),

renamed as (

    select
        event_id as email_event_id,
        hs_contact_id,
        user_id,
        email_type,
        sent_at as sent_at_timestamp,
        opened as is_opened,
        clicked as is_clicked,
        unsubscribed as is_unsubscribed

    from source

)

select * from renamed

{{
    config(
        materialized='incremental',
        unique_key='hs_contact_id'
    )
}}

with source as (

    select * from {{ source('hubspot', 'hubspot_contacts') }}

),

renamed as (

    select
        hs_contact_id,
        user_id,
        email,
        first_name,
        last_name,
        country,
        lifecycle_stage,
        lead_source,
        plan,
        created_date as created_at_timestamp,
        last_activity_date as last_activity_timestamp,
        industry,
        company_size,
        subscribed_to_marketing as is_subscribed_to_marketing

    from source

)

select * from renamed

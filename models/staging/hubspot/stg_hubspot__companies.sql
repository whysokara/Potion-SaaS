with source as (

    select * from {{ source('hubspot', 'hubspot_companies') }}

),

renamed as (

    select
        hs_company_id,
        domain as company_domain,
        company_name,
        industry,
        employee_count_range,
        country,
        created_date as created_at_timestamp,
        num_contacts

    from source

)

select * from renamed

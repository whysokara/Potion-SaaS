with deals as (

    select * from {{ ref('int_hubspot__deals_enriched') }}

),

final as (

    select
        deal_id,
        user_id,
        deal_name,
        amount,
        deal_stage,
        created_at_timestamp,
        closed_at_timestamp,
        deal_type,
        deal_owner,
        lead_source,
        contact_country as country,
        
        -- Calculate Sales Velocity
        datediff('day', created_at_timestamp, closed_at_timestamp) as days_to_close,
        
        -- Categorize Deal Size
        case 
            when amount >= 1000 then 'Enterprise'
            when amount >= 500 then 'Mid-Market'
            else 'SMB'
        end as market_segment

    from deals

)

select * from final

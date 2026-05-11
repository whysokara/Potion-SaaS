with growth_metrics as (
    select * from {{ ref('int_analytics__growth_metrics') }}
),
final as (
    select * from growth_metrics
)
select * from final

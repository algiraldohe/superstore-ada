with bronze_customers_superstore as (
    select * from  {{ source('TF_DAVERSE_' ~ var('environment') | upper, 'bronze_overall_superstore') }}
)

select 
    {{ dbt_utils.generate_surrogate_key(['country', 'region', 'state', 'city', '"' + 'postal code' | upper + '"' ]) }} as geo_id,
    country,
    region,
    state,
    city,
    {{ '"' + 'postal code' | upper + '"' }}
from bronze_customers_superstore
group by all
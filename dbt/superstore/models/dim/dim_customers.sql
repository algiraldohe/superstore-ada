with bronze_customers_superstore as (
    select * from  {{ source('TF_DAVERSE_' ~ var('environment') | upper, 'bronze_overall_superstore') }}
)

select 
    _airbyte_raw_id
    , {{ '"' + 'customer id' | upper + '"' }} as customer_id
    , {{ '"' + 'customer name' | upper + '"' }} as customer_name
    , segment
    , country
    , region
    , state 
    , city
    , {{ '"' + 'postal code' | upper + '"' }} as postal_code

from bronze_customers_superstore
group by all
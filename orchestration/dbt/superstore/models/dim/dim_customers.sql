with bronze_customers_superstore as (
    select * from  {{ source('TF_DAVERSE_' ~ var('environment') | upper, 'bronze_overall_superstore') }}
)

select 
    {{ '"' + 'customer id' | upper + '"' }} as customer_id
    , {{ '"' + 'customer name' | upper + '"' }} as customer_name
    , segment
    , max({{ '"' + 'order date' | upper + '"' }}) as last_transaction_date

from bronze_customers_superstore
group by all
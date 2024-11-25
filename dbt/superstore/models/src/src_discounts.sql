
with bronze_overall_superstore as (
    select * from  {{ source('TF_DAVERSE_' ~ var('environment') | upper, 'bronze_overall_superstore') }}
)

select 
    _airbyte_raw_id
    , {{ '"' + 'row id' | upper + '"' }} as row_id
    , city
    , sales :: number(8,4) as sales_amount
    , state
    , profit
    , segment
    , category
    , {{ '"' + 'sub-category' | upper + '"' }} as sub_category
    , discount :: number(8,2) as discount
    , {{ '"' + 'order id' | upper + '"' }} as order_id
    , quantity :: number(8,0) as quantity
    , {{ '"' + 'customer id' | upper + '"' }}as customer_id

from bronze_overall_superstore
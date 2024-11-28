{{
  config(
    materialized = 'incremental',
    on_schema_change='fail',
    schema='tf_silver'
    )
}}


with bronze_orders_superstore as (
    select * from  {{ source('TF_DAVERSE_' ~ var('environment') | upper, 'bronze_overall_superstore') }}
)

select 
    _airbyte_raw_id
    , _airbyte_extracted_at
    , {{ '"' + 'row id' | upper + '"' }} as row_id
    , {{ '"' + 'order id' | upper + '"' }} as order_id
    , LPAD(row_number() over(partition by {{ '"' + 'order id' | upper + '"' }} order by {{ '"' + 'order date' | upper + '"' }}):: string, 3, 0)  as order_id_item
    , {{ '"' + 'order date' | upper + '"' }} as order_date
    , {{ '"' + 'ship date' | upper + '"' }} as ship_date
    , {{ '"' + 'ship mode' | upper + '"' }} as ship_mode
    , {{ '"' + 'product id' | upper + '"' }} as product_id
    , {{ '"' + 'customer id' | upper + '"' }}as customer_id
    , sales :: double as sales_amount
    , quantity :: number(8,0) as quantity
    , discount :: number(4,2) as discount
    , profit :: double as profit

from bronze_orders_superstore

{% if is_incremental() %}
where _airbyte_extracted_at > (select coalesce(max(_airbyte_extracted_at),'1900-01-01') from {{ this }} )
{% endif %} 
  
{{
  config(
    materialized = 'view',
    )
}}
{%- set orders_alias = 'ord' -%}
{%- set products_alias = 'pdct' -%}

with base_data as (
    select 
        to_char(to_date({{ orders_alias }}.order_date, 'MM/DD/YYYY'), 'YYYY-MM') fiscal_year_month_desc
        , {{ products_alias }}.product_name
        , {{ products_alias }}.category as product_category
        , {{ products_alias }}.sub_category as product_sub_category
        , case when {{ orders_alias }}.discount = 0.00 then 0 else 1 end as is_discount
        , {{ orders_alias }}.customer_id
        , {{ orders_alias }}.profit
        , {{ orders_alias }}.sales_amount
    
    from {{ ref('fct_orders') }} as {{ orders_alias }}
    join {{ ref('dim_products') }} {{ products_alias }} on {{ orders_alias }}.product_id = {{ products_alias }}.product_id
)

select * from base_data
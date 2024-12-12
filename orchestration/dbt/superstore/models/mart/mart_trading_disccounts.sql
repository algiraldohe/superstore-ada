{%- set orders_alias = 'ord' -%}
{%- set products_alias = 'pdct' -%}
{%- set customers_alias = 'cust' -%}
{%- set geo_alias = 'geo' -%}

with base_data as (
    select 
        to_char(to_date({{ orders_alias }}.order_date, 'MM/DD/YYYY'), 'YYYY-MM') fiscal_year_month_desc
        , {{ products_alias }}.product_name
        , {{ products_alias }}.category as product_category
        , {{ products_alias }}.sub_category as product_sub_category
        , {{ orders_alias }}.order_id
        , case when {{ orders_alias }}.discount = 0.00 then 0 else 1 end as is_discount
        , {{ customers_alias }}.customer_id
        , {{ geo_alias }}.region
        , {{ geo_alias }}.state
        , {{ geo_alias }}.city
        , {{ customers_alias }}.segment
        , {{ orders_alias }}.profit
        , {{ orders_alias }}.sales_amount
    
    from {{ ref('fct_orders') }} as {{ orders_alias }}
    join {{ ref('dim_products') }} {{ products_alias }} on {{ orders_alias }}.product_id = {{ products_alias }}.product_id
    join {{ ref('dim_geo') }} {{ geo_alias }} on {{ geo_alias }}.geo_id = {{ orders_alias }}.geo_id
    join {{ ref('dim_customers') }} {{ customers_alias }} on {{ orders_alias }}.customer_id = {{ customers_alias }}.customer_id
),

products_disccounts as (
    select 
        'product-disccounts' as kpi
        , fiscal_year_month_desc
        , product_name
        , product_category
        , product_sub_category
        , is_discount
        , region
        , state
        , city
        , segment
        , sum(profit) as value
    
    from base_data
    {{ dbt_utils.group_by(10) }}
),

customers_disccounts as (
    select 
        'customers-disccounts' as kpi
        , fiscal_year_month_desc
        , product_name
        , product_category
        , product_sub_category
        , is_discount
        , region
        , state
        , city
        , segment
        , count(distinct customer_id) as value
    
    from base_data
    {{ dbt_utils.group_by(10) }}
),

sales_disccounts as (
    select 
        'sales-disccounts' as kpi
        , fiscal_year_month_desc
        , product_name
        , product_category
        , product_sub_category
        , is_discount
        , region
        , state
        , city
        , segment
        , sum(sales_amount) as value
    
    from base_data
    {{ dbt_utils.group_by(10) }}
),

orders_disccounts as (
    select 
        'orders-disccounts' as kpi
        , fiscal_year_month_desc
        , product_name
        , product_category
        , product_sub_category
        , is_discount
        , region
        , state
        , city
        , segment
        , count(distinct order_id) as value
    
    from base_data
    {{ dbt_utils.group_by(10) }}
)

select * from products_disccounts
union all
select * from customers_disccounts
union all
select * from sales_disccounts
union all
select * from orders_disccounts

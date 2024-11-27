with bronze_products_superstore as (
    select 
        {{ '"' + 'product id' | upper + '"' }} as product_id
        , category 
        , {{ '"' + 'sub-category' | upper + '"' }} as sub_category
        , {{ '"' + 'product name' | upper + '"' }} as product_name
        , row_number() over(partition by {{ '"' + 'product id' | upper + '"' }} order by len({{ '"' + 'product name' | upper + '"' }}) desc) row_id

    from  {{ source('TF_DAVERSE_' ~ var('environment') | upper, 'bronze_overall_superstore') }}

)

select
    product_id,
    product_name,
    category,
    sub_category

from bronze_products_superstore
where row_id = 1
group by all
{{ config(materialized="view") }}

with
    src as (select * from {{ source("Sales_sliver", "SALES_NAM") }}),

    standardised as (
        select

            cast(order_id as varchar) as source_order_id,
            1 as source_line_number,

            cast(date as date) as order_date,
            case
                when customer_name = 'PnP'
                then 'Pick n Pay'
                when customer_name = 'Spar Group'
                then 'Spar'
                when customer_name = 'Shoprite Group'
                then 'Shoprite'
                else customer_name
            end as customer_name_std,
            product_code as sku_code,
            brand as brand,
            cast(replace(pack, 'ml', '') as int) as pack_size_ml,
            round(
                (volume * cast(replace(pack, 'ml', '') as float)) / 100000, 4
            ) as volume_hl,
            value as gross_revenue_local,
            0 as discount_amount_local,
            value as net_revenue_local,
            currency as currency_code,
            'NAM' as opco_code,
            'silver_sales_nam' as source_system

        from src
    )

select *
from standardised

{{ config(materialized="view") }}

with

    src as (select * from {{ source("Sales_sliver", "INVOICE_SALES_ZA") }}),

    standardised as (
        select
            invoice_number as source_order_id,
            invoice_line_number as source_line_number,
            cast(invoice_date as date) as order_date,
            customer_name as customer_name_std,
            null as sku_code,
            case
                when product_name ilike '%savannah%'
                then 'Savannah'
                when product_name ilike '%0.0%'
                then 'Heineken 0.0'
                when product_name ilike '%amstel%'
                then 'Amstel'
                when product_name ilike '%windhoek%'
                then 'Windhoek Lager'
                when product_name ilike '%heineken%'
                then 'Heineken'
                else 'Unknown'
            end as brand,
            cast(regexp_substr(product_name, '(\\d+)ml', 1, 1, 'e', 1) as int) as pack_size_ml,
            volume_hl,
            gross_sales_value as gross_revenue_local,
            discount_value as discount_amount_local,
            (gross_sales_value - discount_value) as net_revenue_local,
            currency_code,
            'ZA' as opco_code,
            'silver_sales_invoice_za' as source_system

        from src
    )

select *
from standardised

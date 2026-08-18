{{ config(materialized="view") }}

with
    all_products as (
        select brand, pack_size_ml, sku_code, opco_code
        from {{ ref("stg_Sales_sliver__INVOICE_SALES_ZA") }}
        union
        select brand, pack_size_ml, sku_code, opco_code
        from {{ ref("stg_Sales_sliver__SALES_NAM") }}
    ),

    deduped as (select distinct brand, pack_size_ml, sku_code from all_products)

select
    {{ dbt_utils.generate_surrogate_key(["brand", "pack_size_ml"]) }} as product_key,
    brand,
    pack_size_ml,
    sku_code,
    concat(brand, ' ', pack_size_ml, 'ml') as product_name_std,
    round(pack_size_ml / 1000.0, 3) as litres_per_unit,

    case when brand = 'Savannah' then 'Cider' else 'Beer' end as category,

    case
        when pack_size_ml = 330
        then 'NRB'
        when pack_size_ml = 440
        then 'NRB'
        when pack_size_ml = 500
        then 'NRB'
        when pack_size_ml = 650
        then 'Returnable'
        else 'Unknown'
    end as container_type

from deduped

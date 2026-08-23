{{ config (materialized ='view')}}


WITH za AS (
    SELECT * FROM {{ ref('stg_Sales_sliver__INVOICE_SALES_ZA') }}
),

nam AS (
    SELECT * FROM {{ ref('stg_Sales_sliver__SALES_NAM') }}
),

combined AS (
    SELECT * FROM nam
    UNION ALL
    SELECT * FROM za
),

final AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key([
            'c.source_order_id',
            'c.source_line_number',
            'c.opco_code'
        ]) }}                              AS sales_key,

        d.date_key,
        cu.customer_key,
        p.product_key,
        o.opco_key,
        c.source_order_id,
        c.source_line_number,
        c.source_system,
        c.volume_hl,
        c.volume_hl * 100                  AS volume_litres,
        c.gross_revenue_local,
        c.discount_amount_local,
        c.net_revenue_local,
        c.currency_code

    FROM combined            c
    LEFT JOIN {{ ref('DimDate') }}     d  ON d.date       = c.order_date
    LEFT JOIN {{ ref('Dim_customer') }} cu ON cu.customer_name = c.customer_name_std
    LEFT JOIN {{ ref('Dim_product') }}  p  ON p.brand      = c.brand
                                          AND p.pack_size_ml = c.pack_size_ml
    LEFT JOIN {{ ref('DimOpsCompany') }}     o  ON o.opco_code  = c.opco_code
)

SELECT * FROM final
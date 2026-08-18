SELECT
    o.opco_name,
    o.local_currency,
    pr.brand,
    pr.product_name_std,
    pr.category,
    cu.customer_name,
    d.year,
    d.month_name,
    d.quarter,

    -- Core certified metric
    SUM(f.net_revenue_local)               AS total_sales_revenue

FROM {{ ref('Fact_sales') }}               f
JOIN {{ ref('DimOpsCompany') }}                 o  ON o.opco_key     = f.opco_key
JOIN {{ ref('Dim_product') }}              pr ON pr.product_key = f.product_key
JOIN {{ ref('Dim_customer') }}             cu ON cu.customer_key= f.customer_key
JOIN {{ ref('DimDate') }}                 d  ON d.date_key     = f.date_key

GROUP BY ALL
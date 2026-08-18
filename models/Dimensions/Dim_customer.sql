{{ config(materialized="view") }}



WITH all_customers AS (
    SELECT customer_name_std, opco_code FROM {{ ref('stg_Sales_sliver__SALES_NAM') }}
    UNION
    SELECT customer_name_std, opco_code FROM {{ ref('stg_Sales_sliver__INVOICE_SALES_ZA') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['customer_name_std']) }}
                                           AS customer_key,
    customer_name_std                      AS customer_name,
    MAX(CASE WHEN opco_code = 'NAM' THEN TRUE ELSE FALSE END)
                                           AS trades_with_nam,
    MAX(CASE WHEN opco_code = 'ZA'  THEN TRUE ELSE FALSE END)
                                           AS trades_with_za

FROM all_customers
GROUP BY customer_name_std
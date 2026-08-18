{{ config (materialized ='view')}}


SELECT
    {{ dbt_utils.generate_surrogate_key(['opco_code']) }} AS opco_key,
    opco_code,
    CASE opco_code
        WHEN 'NAM' THEN 'Namibia'
        WHEN 'ZA'  THEN 'South Africa'
    END                                    AS opco_name,
    CASE opco_code
        WHEN 'NAM' THEN 'NAD'
        WHEN 'ZA'  THEN 'ZAR'
    END                                    AS local_currency,
    CASE opco_code
        WHEN 'NAM' THEN 'Africa Middle East'
        WHEN 'ZA'  THEN 'Africa Middle East'
    END                                    AS region

FROM (VALUES ('NAM'), ('ZA')) AS t(opco_code)
{{ config (materialized ='view')}}


WITH datedata AS (
    {{ dbt_utils.date_spine(
        datepart   = "day",
        start_date = "cast('2026-01-01' as date) ",
        end_date   = "cast('2027-01-01' as date)"
    ) }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['date_day']) }}  AS date_key,
    date_day                                              AS date,
    EXTRACT(YEAR  FROM date_day)                          AS year,
    EXTRACT(MONTH FROM date_day)                          AS month_number,
    MONTHNAME(date_day)                                   AS month_name,
    EXTRACT(WEEK  FROM date_day)                          AS week_number,
    EXTRACT(DOW   FROM date_day)                          AS day_of_week,
    QUARTER(date_day)                                     AS quarter

FROM datedata
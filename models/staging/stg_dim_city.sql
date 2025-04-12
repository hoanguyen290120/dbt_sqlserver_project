WITH dim_city_source AS
(
    SELECT *
    FROM WideWorldImporters.Application.Cities
),
dim_city_rename_column AS 
(
    SELECT 
        CityID AS delivery_city_key,
        CityName AS delivery_city_name,
        StateProvinceID AS delivery_stage_province_key
    FROM dim_city_source
),
dim_city_change_type AS 
(
    SELECT 
        CAST(delivery_city_key AS INT) AS delivery_city_key,
        CAST(delivery_city_name AS NVARCHAR(255)) AS delivery_city_name,
        CAST(delivery_stage_province_key AS INT) AS delivery_stage_province_key
    FROM dim_city_rename_column
),
dim_city_add_undefined AS 
(
    SELECT 
        delivery_city_key,
        delivery_city_name,
        delivery_stage_province_key
    FROM dim_city_change_type

    UNION ALL

    SELECT
        0 AS delivery_city_key,
        'Undefined' AS delivery_city_name,
        0 AS delivery_stage_province_key

    UNION ALL

    SELECT
        -1 AS delivery_city_key,
        'Invalid' AS delivery_city_name,
        -1 AS delivery_stage_province_key
)
SELECT
    dim_city.delivery_city_key,
    dim_city.delivery_city_name,
    dim_city.delivery_stage_province_key,
    dim_stage_province.delivery_stage_province_name,
    dim_stage_province.delivery_stage_province_code,
    dim_stage_province.delivery_country_name
FROM dim_city_add_undefined AS dim_city
LEFT JOIN {{ ref('stg_dim_stage_province') }} AS dim_stage_province
    ON dim_city.delivery_stage_province_key = dim_stage_province.delivery_stage_province_key;

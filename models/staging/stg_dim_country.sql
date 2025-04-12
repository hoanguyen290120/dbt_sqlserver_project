WITH dim_country_source AS
(
    SELECT
        CountryID,
        CountryName
    FROM WideWorldImporters.Application.Countries
),
dim_country_rename_column AS 
(
    SELECT 
        CountryID AS delivery_country_key,
        CountryName AS delivery_country_name
    FROM dim_country_source
),
dim_country_change_type AS 
(
    SELECT 
        CAST(delivery_country_key AS INT) AS delivery_country_key,
        CAST(delivery_country_name AS NVARCHAR(255)) AS delivery_country_name
    FROM dim_country_rename_column
),
dim_country_add_undefined AS 
(
    SELECT 
        delivery_country_key,
        delivery_country_name
    FROM dim_country_change_type

    UNION ALL

    SELECT
        0 AS delivery_country_key,
        'Undefined' AS delivery_country_name

    UNION ALL

    SELECT
        -1 AS delivery_country_key,
        'Invalid' AS delivery_country_name
)
SELECT
    delivery_country_key,
    delivery_country_name
FROM dim_country_add_undefined;

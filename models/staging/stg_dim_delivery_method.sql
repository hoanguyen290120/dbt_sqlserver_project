WITH dim_delivery_method_source AS
(
    SELECT *
    FROM WideWorldImporters.Application.DeliveryMethods
),
dim_delivery_method_rename_column AS 
(
    SELECT 
        DeliveryMethodID AS delivery_method_key,
        DeliveryMethodName AS delivery_method_name
    FROM dim_delivery_method_source
),
dim_delivery_method_change_type AS 
(
    SELECT 
        CAST(delivery_method_key AS INT) AS delivery_method_key,
        CAST(delivery_method_name AS NVARCHAR(255)) AS delivery_method_name
    FROM dim_delivery_method_rename_column
),
dim_delivery_method_add_undefined AS 
(
    SELECT 
        delivery_method_key,
        delivery_method_name
    FROM dim_delivery_method_change_type

    UNION ALL

    SELECT
        0 AS delivery_method_key,
        'Undefined' AS delivery_method_name

    UNION ALL

    SELECT
        -1 AS delivery_method_key,
        'Invalid' AS delivery_method_name
)

SELECT
    delivery_method_key,
    delivery_method_name
FROM dim_delivery_method_add_undefined;

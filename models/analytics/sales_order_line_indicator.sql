WITH dim_is_undersupply_backordered AS 
(
    SELECT 
        1 AS is_undersupply_backordered_boolean,
        'Undersupply Backordered' AS is_undersupply_backordered
    UNION ALL
    SELECT 
        0 AS is_undersupply_backordered_boolean,
        'Not Undersupply Backordered' AS is_undersupply_backordered
),
dim_is_undersupply_backordered_change_type AS 
(
    SELECT 
        CAST(is_undersupply_backordered_boolean AS BIT) AS is_undersupply_backordered_boolean,
        CAST(is_undersupply_backordered AS NVARCHAR(255)) AS is_undersupply_backordered
    FROM dim_is_undersupply_backordered
)

SELECT 
    CONCAT(dim_is_undersupply_backordered.is_undersupply_backordered, ',', dim_package_type.package_type_key)
        AS sales_order_line_indicator_key,
    dim_is_undersupply_backordered.is_undersupply_backordered_boolean,
    dim_is_undersupply_backordered.is_undersupply_backordered,
    dim_package_type.package_type_key,
    dim_package_type.package_type_name
FROM dim_is_undersupply_backordered
CROSS JOIN {{ ref('dim_package_type') }} AS dim_package_type;

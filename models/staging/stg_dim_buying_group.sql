WITH dim_buying_group AS 
(
    SELECT 
        BuyingGroupID,
        BuyingGroupName
    FROM WideWorldImporters.Sales.BuyingGroups
),
dim_buying_group_rename_column AS 
(
    SELECT 
        BuyingGroupID AS buying_group_key,
        BuyingGroupName AS buying_group_name
    FROM dim_buying_group
),
dim_buying_group_change_type AS 
(
    SELECT 
        CAST(buying_group_key AS INT) AS buying_group_key,
        CAST(buying_group_name AS NVARCHAR(255)) AS buying_group_name
    FROM dim_buying_group_rename_column
),
dim_buying_group_add_undefined AS 
(
    SELECT 
        buying_group_key,
        buying_group_name
    FROM dim_buying_group_change_type

    UNION ALL

    SELECT 
        0 AS buying_group_key,
        'Undefined' AS buying_group_name

    UNION ALL

    SELECT 
        -1 AS buying_group_key,
        'Invalid' AS buying_group_name
)
SELECT 
    buying_group_key,
    buying_group_name
FROM dim_buying_group_add_undefined;

WITH customer_category_source AS
(
    SELECT *
    FROM WideWorldImporters.Sales.CustomerCategories
),
customer_category_rename_column AS
(
    SELECT 
        CustomerCategoryID AS customer_category_key,
        CustomerCategoryName AS customer_category_name
    FROM customer_category_source
),
customer_category_change_type AS
(
    SELECT
        CAST(customer_category_key AS INT) AS customer_category_key,
        CAST(customer_category_name AS NVARCHAR(255)) AS customer_category_name
    FROM customer_category_rename_column
),
customer_category_add_undefined AS 
(
    SELECT 
        customer_category_key,
        customer_category_name
    FROM customer_category_change_type

    UNION ALL

    SELECT 
        0 AS customer_category_key,
        'Undefined' AS customer_category_name

    UNION ALL

    SELECT
        -1 AS customer_category_key,  
        'Invalid' AS customer_category_name
)

SELECT 
    customer_category_key,
    customer_category_name
FROM customer_category_add_undefined;

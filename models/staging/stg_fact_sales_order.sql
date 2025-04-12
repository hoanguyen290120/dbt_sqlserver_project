WITH sales_order_source AS
(
    SELECT
        *
    FROM WideWorldImporters.Sales.Orders
),
sales_order_rename_column AS
(
    SELECT 
        OrderDate AS order_date,
        OrderID AS sales_order_key,
        CustomerID AS customer_key,
        PickedByPersonID AS picked_by_person_key,
        IsUndersupplyBackordered AS is_undersupply_backordered
    FROM sales_order_source
),
sales_order_change_type AS
(
    SELECT 
        CAST(order_date AS DATE) AS order_date,
        CAST(sales_order_key AS INT) AS sales_order_key,
        CAST(customer_key AS INT) AS customer_key,
        CAST(picked_by_person_key AS INT) AS picked_by_person_key,
        CAST(is_undersupply_backordered AS BIT) AS is_undersupply_backordered_boolean
    FROM sales_order_rename_column
),
sales_order_convert_boolean AS
(
    SELECT 
        *,
        CASE 
            WHEN is_undersupply_backordered_boolean = 1 THEN 'Undersupply Backordered'
            ELSE 'Not Undersupply Backordered'
        END AS is_undersupply_backordered
    FROM sales_order_change_type
)

SELECT 
    order_date,
    sales_order_key,
    customer_key,
    COALESCE(picked_by_person_key, 0) AS picked_by_person_key,
    is_undersupply_backordered
FROM 
    sales_order_convert_boolean;

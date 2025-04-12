WITH purchasing_suppliers_source AS
(
    SELECT 
        *
    FROM WideWorldImporters.Purchasing.Suppliers
),
purchasing_suppliers_rename_column AS
(
    SELECT 
        SupplierID AS supplier_key,
        SupplierName AS supplier_name
    FROM purchasing_suppliers_source
),
purchasing_suppliers_change_type AS 
(
    SELECT
        CAST(supplier_key AS INT) AS supplier_key,
        CAST(supplier_name AS NVARCHAR(255)) AS supplier_name
    FROM purchasing_suppliers_rename_column
),
add_purchasing_suppliers_undefined AS 
(
    SELECT 
        supplier_key,
        supplier_name
    FROM purchasing_suppliers_change_type

    UNION ALL

    SELECT  
        0 AS supplier_key,
        'Undefined' AS supplier_name

    UNION ALL

    SELECT 
        -1 AS supplier_key,
        'Invalid' AS supplier_name
)

SELECT
    supplier_key,
    supplier_name
FROM add_purchasing_suppliers_undefined;

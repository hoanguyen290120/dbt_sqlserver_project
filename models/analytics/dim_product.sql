-- B1: Source lấy data
WITH dim_product_source AS (
    SELECT 
        *
    FROM [WideWorldImporters].[Warehouse].[StockItems]
),

-- B2: Đổi cột
dim_product_rename_column AS (
    SELECT
        StockItemID AS product_key,
        SupplierID AS supplier_key,
        StockItemName AS product_name,
        Brand AS brand_name,
        IsChillerStock AS is_chiller_stock
    FROM dim_product_source
),

-- B3: Chuyển đổi type data
dim_product_change_type AS (
    SELECT  
        CAST(product_key AS INT) AS product_key,
        CAST(product_name AS NVARCHAR(255)) AS product_name,
        CAST(supplier_key AS INT) AS supplier_key,
        CAST(brand_name AS NVARCHAR(255)) AS brand_name,
        CAST(is_chiller_stock AS BIT) AS is_chiller_stock_boolean
    FROM dim_product_rename_column
),

-- B4: Convert_boolean_to_string
dim_product_convert_boolean AS (
    SELECT 
        *,
        CASE
            WHEN is_chiller_stock_boolean = 1 THEN 'Chiller Stock'
            WHEN is_chiller_stock_boolean = 0 THEN 'Non Chiller Stock'
            WHEN is_chiller_stock_boolean IS NULL THEN 'Undefined'
            ELSE 'Invalid'
        END AS is_chiller_stock
    FROM dim_product_change_type
)

-- B5: Chọn cột cần thiết
SELECT
    dim_product.product_key,
    dim_product.product_name,
    COALESCE(dim_product.brand_name, 'Undefined') AS brand_name,
    dim_product.supplier_key,
    COALESCE(dim_supplier.supplier_name, 'Undefined') AS supplier_name,
    dim_product.is_chiller_stock
FROM dim_product_convert_boolean AS dim_product
LEFT JOIN {{ ref('stg_dim_supplier') }} AS dim_supplier
    ON dim_product.supplier_key = dim_supplier.supplier_key;


    --incremental filter
{{ config(
    materialized='incremental',
    unique_key='sales_order_line_key'
) }}

---B1: Source lấy data
WITH fact_sales_order_line_source AS (
    SELECT * 
    FROM [WideWorldImporters].[Sales].[OrderLines]
),
--B2: Đổi tên cột theo đúng chuẩn ngữ nghĩa business
sales_order_line_rename_column AS (
    SELECT
        OrderLineID AS sales_order_line_key,
        OrderID AS sales_order_key,
        StockItemID AS product_key,
        PackageTypeID AS package_type_key,
        Quantity AS quantity,
        UnitPrice AS unit_price
    FROM fact_sales_order_line_source
),
--B2: Đổi định dạng cột dữ liệu
fact_sales_order_line_change_type AS (
    SELECT
        CAST(sales_order_line_key AS INT) AS sales_order_line_key,
        CAST(sales_order_key AS INT) AS sales_order_key,
        CAST(product_key AS INT) AS product_key,
        CAST(package_type_key AS INT) AS package_type_key,
        CAST(quantity AS INT) AS quantity,
        CAST(unit_price AS DECIMAL(18, 2)) AS unit_price
    FROM sales_order_line_rename_column
)
--B4: Chọn các cột cần thiết
SELECT 
    fact_header.order_date,
    fact_line.sales_order_line_key,
    fact_line.sales_order_key,
    COALESCE(fact_header.customer_key, -1) AS customer_key,
    COALESCE(fact_header.picked_by_person_key, -1) AS picked_by_person_key,
        CONCAT(
              COALESCE(fact_header.is_undersupply_backordered, 'Undefined'), 
            ',', fact_line.package_type_key  )
             AS sales_order_line_indicator_key,
    fact_line.product_key,
    fact_line.quantity,
    fact_line.unit_price,
    fact_line.unit_price * fact_line.quantity AS gross_amount
FROM fact_sales_order_line_change_type AS fact_line
LEFT JOIN {{ ref('stg_fact_sales_order') }} AS fact_header 
    ON fact_line.sales_order_key = fact_header.sales_order_key

    --incremental filter
{% if is_incremental() %}
WHERE YEAR(fact_header.order_date) = (
    SELECT MAX(YEAR(order_date)) FROM {{ this }}
)
{% endif %}

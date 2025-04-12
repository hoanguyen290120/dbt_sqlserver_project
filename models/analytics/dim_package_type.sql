WITH package_type_source AS
(
  SELECT 
    *
  FROM [WideWorldImporters].[Warehouse].[PackageTypes]
),
package_type_rename_column AS
(
  SELECT 
    PackageTypeID AS package_type_key,
    PackageTypeName AS package_type_name
  FROM package_type_source
),
package_type_change_type AS 
(
  SELECT
    CAST(package_type_key AS INT) AS package_type_key,
    CAST(package_type_name AS NVARCHAR(255)) AS package_type_name
  FROM package_type_rename_column
),
add_package_type_undefined AS 
(
  SELECT 
    package_type_key,
    package_type_name
  FROM package_type_change_type

  UNION ALL

  SELECT  
    0 AS package_type_key,
    'Undefined' AS package_type_name

  UNION ALL

  SELECT 
    -1 AS package_type_key,
    'Invalid' AS package_type_name
)
SELECT
  package_type_key,
  package_type_name
FROM add_package_type_undefined;

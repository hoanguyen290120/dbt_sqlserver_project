WITH dim_person_source AS (
  SELECT 
    *
  FROM 
    [WideWorldImporters].[Application].[People]
),

dim_person_rename_colum AS (
  SELECT 
    PersonID as person_key,
    FullName as full_name,
    PreferredName as preferred_name,
    SearchName as search_name,
    IsEmployee as is_employee, -- BIT
    IsSalesperson as is_salesperson -- BIT
  FROM dim_person_source
),

dim_person_change_type AS (
  SELECT
    CAST(person_key AS INT) AS person_key,
    CAST(full_name AS NVARCHAR(255)) AS full_name,
    CAST(preferred_name AS NVARCHAR(255)) AS preferred_name,
    CAST(search_name AS NVARCHAR(255)) AS search_name,
    CAST(is_employee AS BIT) AS is_employee_bit,
    CAST(is_salesperson AS BIT) AS is_salesperson_bit
  FROM dim_person_rename_colum
),

dim_person_convert_boolean AS 
(
  SELECT 
    *,
    CASE 
      WHEN is_employee_bit = 1 THEN 'is_employee'
      WHEN is_employee_bit = 0 THEN 'not_is_employee'
      WHEN is_employee_bit IS NULL THEN 'Undefined'
      ELSE 'Invalid' 
    END AS is_employee,

    CASE 
      WHEN is_salesperson_bit = 1 THEN 'is_salesperson'
      WHEN is_salesperson_bit = 0 THEN 'not_is_salesperson'
      WHEN is_salesperson_bit IS NULL THEN 'Undefined'
      ELSE 'Invalid'
    END AS is_salesperson

  FROM dim_person_change_type 
),

dim_person_add_undefined_rows AS (
  SELECT 
    person_key,
    full_name,
    preferred_name,
    search_name,
    is_employee,
    is_salesperson
  FROM dim_person_convert_boolean

  UNION ALL

  SELECT 
    0, 'Undefined', 'Undefined', 'Undefined', 'Undefined', 'Undefined'

  UNION ALL

  SELECT 
    -1, 'Invalid', 'Invalid', 'Invalid', 'Invalid', 'Invalid'
)

SELECT
  person_key,
  full_name,
  preferred_name,
  search_name,
  is_employee,
  is_salesperson
FROM dim_person_add_undefined_rows;

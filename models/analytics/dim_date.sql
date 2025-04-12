WITH dim_date_generate AS (
    SELECT 
        CAST(DATEADD(DAY, number, '2010-01-01') AS DATE) AS [date]
    FROM master.dbo.spt_values
    WHERE type = 'P'
      AND number <= DATEDIFF(DAY, '2010-01-01', '2030-12-31')
)

SELECT
    [date],

    -- Tên ngày đầy đủ (Monday, Tuesday)
    DATENAME(WEEKDAY, [date]) AS day_of_week,

    -- Tên ngày viết tắt (Mon, Tue)
    LEFT(DATENAME(WEEKDAY, [date]), 3) AS day_of_week_short,

    -- Phân biệt weekday và weekend
    CASE 
        WHEN DATEPART(WEEKDAY, [date]) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS is_weekday_or_weekend,

    -- Truncate về đầu tháng
    CAST(DATEFROMPARTS(YEAR([date]), MONTH([date]), 1) AS DATE) AS year_month,

    -- Tên tháng (January, February)
    DATENAME(MONTH, [date]) AS month,

    -- Truncate về đầu năm
    CAST(DATEFROMPARTS(YEAR([date]), 1, 1) AS DATE) AS year,

    -- Năm dạng số
    YEAR([date]) AS year_number

FROM dim_date_generate;

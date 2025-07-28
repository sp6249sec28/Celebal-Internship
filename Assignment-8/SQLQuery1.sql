CREATE TABLE TimeDimension (
    DateValue DATE PRIMARY KEY,      
    CalendarDay TINYINT,             
    CalendarMonth TINYINT,           
    CalendarQuarter TINYINT,         
    CalendarYear INT,                
    DayNameLong VARCHAR(20),         
    DayNameShort CHAR(3),            
    DayNumberOfWeek TINYINT,         
    DayNumberOfYear SMALLINT,        
    DaySuffix VARCHAR(4),            
    FiscalWeek TINYINT,              
    FiscalPeriod TINYINT,            
    FiscalQuarter TINYINT,           
    FiscalYear INT,                  
    FiscalYearPeriod VARCHAR(6)      
);

CREATE PROCEDURE PopulateTimeDimension
    @InputDate DATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Year INT = YEAR(@InputDate);
    DECLARE @StartDate DATE = DATEFROMPARTS(@Year, 1, 1);
    DECLARE @EndDate DATE = DATEFROMPARTS(@Year, 12, 31);

    -- Insert all dates for the year in one statement
    INSERT INTO TimeDimension (
        DateValue,
        CalendarDay,
        CalendarMonth,
        CalendarQuarter,
        CalendarYear,
        DayNameLong,
        DayNameShort,
        DayNumberOfWeek,
        DayNumberOfYear,
        DaySuffix,
        FiscalWeek,
        FiscalPeriod,
        FiscalQuarter,
        FiscalYear,
        FiscalYearPeriod
    )
    SELECT
        DateValue = DATEADD(DAY, n, @StartDate),
        DAY(DATEADD(DAY, n, @StartDate)) AS CalendarDay,
        MONTH(DATEADD(DAY, n, @StartDate)) AS CalendarMonth,
        DATEPART(QUARTER, DATEADD(DAY, n, @StartDate)) AS CalendarQuarter,
        YEAR(DATEADD(DAY, n, @StartDate)) AS CalendarYear,
        DATENAME(WEEKDAY, DATEADD(DAY, n, @StartDate)) AS DayNameLong,
        LEFT(DATENAME(WEEKDAY, DATEADD(DAY, n, @StartDate)), 3) AS DayNameShort,
        DATEPART(WEEKDAY, DATEADD(DAY, n, @StartDate)) AS DayNumberOfWeek,
        DATEPART(DAYOFYEAR, DATEADD(DAY, n, @StartDate)) AS DayNumberOfYear,
        CAST(DAY(DATEADD(DAY, n, @StartDate)) AS VARCHAR(2)) +
            CASE 
                WHEN DAY(DATEADD(DAY, n, @StartDate)) IN (1,21,31) THEN 'st'
                WHEN DAY(DATEADD(DAY, n, @StartDate)) IN (2,22) THEN 'nd'
                WHEN DAY(DATEADD(DAY, n, @StartDate)) IN (3,23) THEN 'rd'
                ELSE 'th'
            END AS DaySuffix,
        DATEPART(WEEK, DATEADD(DAY, n, @StartDate)) AS FiscalWeek,
        DATEPART(MONTH, DATEADD(DAY, n, @StartDate)) AS FiscalPeriod,
        DATEPART(QUARTER, DATEADD(DAY, n, @StartDate)) AS FiscalQuarter,
        YEAR(DATEADD(DAY, n, @StartDate)) AS FiscalYear,
        CAST(YEAR(DATEADD(DAY, n, @StartDate)) AS VARCHAR(4)) +
            RIGHT('0' + CAST(MONTH(DATEADD(DAY, n, @StartDate)) AS VARCHAR(2)), 2) AS FiscalYearPeriod
    FROM (
        SELECT TOP (DATEDIFF(DAY, @StartDate, @EndDate) + 1)
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS n
        FROM master..spt_values
    ) AS Numbers;
END;

EXEC PopulateTimeDimension '2020-07-14';

SELECT TOP 10 * FROM TimeDimension;
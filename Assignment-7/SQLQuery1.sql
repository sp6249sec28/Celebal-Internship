CREATE PROCEDURE Load_SCD_Type0
AS
BEGIN
    INSERT INTO dim_customer (CustomerID, CustomerName, City)
    SELECT s.CustomerID, s.CustomerName, s.City
    FROM stg_customer s
    LEFT JOIN dim_customer d ON s.CustomerID = d.CustomerID
    WHERE d.CustomerID IS NULL;
END;

GO
CREATE PROCEDURE Load_SCD_Type1
AS
BEGIN
    -- Insert new customers
    INSERT INTO dim_customer (CustomerID, CustomerName, City)
    SELECT s.CustomerID, s.CustomerName, s.City
    FROM stg_customer s
    LEFT JOIN dim_customer d ON s.CustomerID = d.CustomerID
    WHERE d.CustomerID IS NULL;

    -- Update existing customers (overwrite changes)
    UPDATE d
    SET d.CustomerName = s.CustomerName,
        d.City = s.City
    FROM dim_customer d
    INNER JOIN stg_customer s ON s.CustomerID = d.CustomerID;
END;

GO
CREATE PROCEDURE Load_SCD_Type2
AS
BEGIN
    DECLARE @Today DATE = GETDATE();

    -- Expire old records where changes detected
    UPDATE d
    SET d.EffectiveEndDate = DATEADD(DAY, -1, @Today),
        d.IsCurrent = 0
    FROM dim_customer d
    INNER JOIN stg_customer s ON s.CustomerID = d.CustomerID
    WHERE d.IsCurrent = 1
      AND (d.CustomerName <> s.CustomerName OR d.City <> s.City);

    -- Insert new records for changed data
    INSERT INTO dim_customer (CustomerID, CustomerName, City, EffectiveStartDate, EffectiveEndDate, IsCurrent)
    SELECT s.CustomerID, s.CustomerName, s.City, @Today, NULL, 1
    FROM stg_customer s
    INNER JOIN dim_customer d ON s.CustomerID = d.CustomerID
    WHERE d.IsCurrent = 0 AND (d.CustomerName <> s.CustomerName OR d.City <> s.City);

    -- Insert new customers
    INSERT INTO dim_customer (CustomerID, CustomerName, City, EffectiveStartDate, EffectiveEndDate, IsCurrent)
    SELECT s.CustomerID, s.CustomerName, s.City, @Today, NULL, 1
    FROM stg_customer s
    LEFT JOIN dim_customer d ON s.CustomerID = d.CustomerID
    WHERE d.CustomerID IS NULL;
END;

GO
CREATE PROCEDURE Load_SCD_Type3
AS
BEGIN
    -- Insert new customers
    INSERT INTO dim_customer (CustomerID, CustomerName, City, PrevCity)
    SELECT s.CustomerID, s.CustomerName, s.City, NULL
    FROM stg_customer s
    LEFT JOIN dim_customer d ON s.CustomerID = d.CustomerID
    WHERE d.CustomerID IS NULL;

    -- Update existing customers, keep previous city
    UPDATE d
    SET d.PrevCity = d.City,
        d.City = s.City
    FROM dim_customer d
    INNER JOIN stg_customer s ON s.CustomerID = d.CustomerID
    WHERE d.City <> s.City;
END;

GO
CREATE PROCEDURE Load_SCD_Type4
AS
BEGIN
    -- Main dimension table
    INSERT INTO dim_customer (CustomerID, CustomerName)
    SELECT s.CustomerID, s.CustomerName
    FROM stg_customer s
    LEFT JOIN dim_customer d ON s.CustomerID = d.CustomerID
    WHERE d.CustomerID IS NULL;

    -- Historical changes go into a history table
    INSERT INTO dim_customer_history (CustomerID, CustomerName, City, ChangeDate)
    SELECT s.CustomerID, s.CustomerName, s.City, GETDATE()
    FROM stg_customer s;
END;

GO
CREATE PROCEDURE Load_SCD_Type6
AS
BEGIN
    DECLARE @Today DATE = GETDATE();

    -- Expire current record and keep history (Type 2)
    UPDATE d
    SET d.EffectiveEndDate = DATEADD(DAY, -1, @Today),
        d.IsCurrent = 0,
        d.PrevCity = d.City  -- Type 3 behavior
    FROM dim_customer d
    INNER JOIN stg_customer s ON s.CustomerID = d.CustomerID
    WHERE d.IsCurrent = 1
      AND (d.CustomerName <> s.CustomerName OR d.City <> s.City);

    -- Insert new record (current)
    INSERT INTO dim_customer (CustomerID, CustomerName, City, PrevCity, EffectiveStartDate, EffectiveEndDate, IsCurrent)
    SELECT s.CustomerID, s.CustomerName, s.City, d.City, @Today, NULL, 1
    FROM stg_customer s
    INNER JOIN dim_customer d ON s.CustomerID = d.CustomerID
    WHERE d.IsCurrent = 0 AND (d.CustomerName <> s.CustomerName OR d.City <> s.City);

    -- Insert new customers
    INSERT INTO dim_customer (CustomerID, CustomerName, City, PrevCity, EffectiveStartDate, EffectiveEndDate, IsCurrent)
    SELECT s.CustomerID, s.CustomerName, s.City, NULL, @Today, NULL, 1
    FROM stg_customer s
    LEFT JOIN dim_customer d ON s.CustomerID = d.CustomerID
    WHERE d.CustomerID IS NULL;
END;

CREATE PROCEDURE InsertOrderDetails
    @OrderID INT,
    @ProductID INT,
    @UnitPrice MONEY = NULL,
    @Quantity INT,
    @Discount FLOAT = 0
AS
BEGIN
    DECLARE @Stock INT, @ReorderLevel INT, @DefaultPrice MONEY

    -- Get stock and reorder info
    SELECT @Stock = SafetyStockLevel, @ReorderLevel = ReorderPoint, @DefaultPrice = ListPrice
    FROM Production.Product
    WHERE ProductID = @ProductID

    IF @Stock < @Quantity
    BEGIN
        PRINT 'Insufficient stock. Order aborted.'
        RETURN
    END

    -- Use default price if not given
    SET @UnitPrice = ISNULL(@UnitPrice, @DefaultPrice)

    -- Insert order detail
    INSERT INTO Sales.SalesOrderDetail (SalesOrderID, ProductID, OrderQty, UnitPrice)
    VALUES (@OrderID, @ProductID, @Quantity, @UnitPrice)

    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'Failed to place the order. Please try again.'
        RETURN
    END

    -- Update stock
    UPDATE Production.Product
    SET SafetyStockLevel = SafetyStockLevel - @Quantity
    WHERE ProductID = @ProductID

    -- Check for reorder warning
    IF EXISTS (
        SELECT 1
        FROM Production.Product
        WHERE ProductID = @ProductID AND SafetyStockLevel < @ReorderLevel
    )
    BEGIN
        PRINT 'Warning: Product stock is below reorder level.'
    END
END;
GO

CREATE PROCEDURE UpdateOrderDetails
    @OrderID INT,
    @ProductID INT,
    @UnitPrice MONEY = NULL,
    @Quantity INT = NULL,
    @Discount FLOAT = NULL
AS
BEGIN
    UPDATE Sales.SalesOrderDetail
    SET
        UnitPrice = ISNULL(@UnitPrice, UnitPrice),
        OrderQty = ISNULL(@Quantity, OrderQty)
    WHERE SalesOrderID = @OrderID AND ProductID = @ProductID;

    -- Adjust inventory if quantity changed (optional: add before/after stock tracking)
    -- Omitted for simplicity
END;
GO

CREATE PROCEDURE GetOrderDetails
    @OrderID INT
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM Sales.SalesOrderDetail
        WHERE SalesOrderID = @OrderID
    )
    BEGIN
        PRINT 'The OrderID ' + CAST(@OrderID AS VARCHAR) + ' does not exist'
        RETURN 1
    END

    SELECT * FROM Sales.SalesOrderDetail
    WHERE SalesOrderID = @OrderID
END;
GO

CREATE PROCEDURE DeleteOrderDetails
    @OrderID INT,
    @ProductID INT
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM Sales.SalesOrderDetail
        WHERE SalesOrderID = @OrderID AND ProductID = @ProductID
    )
    BEGIN
        PRINT 'Invalid OrderID or ProductID'
        RETURN -1
    END

    DELETE FROM Sales.SalesOrderDetail
    WHERE SalesOrderID = @OrderID AND ProductID = @ProductID
END;

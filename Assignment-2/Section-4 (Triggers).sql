CREATE TRIGGER trg_InsteadOfDeleteOrder
ON Sales.SalesOrderHeader
INSTEAD OF DELETE
AS
BEGIN
    DELETE FROM Sales.SalesOrderDetail
    WHERE SalesOrderID IN (SELECT SalesOrderID FROM DELETED);

    DELETE FROM Sales.SalesOrderHeader
    WHERE SalesOrderID IN (SELECT SalesOrderID FROM DELETED);
END;

GO

CREATE TRIGGER trg_CheckStockBeforeInsert
ON Sales.SalesOrderDetail
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM INSERTED i
        JOIN Production.Product p ON i.ProductID = p.ProductID
        WHERE i.OrderQty > p.SafetyStockLevel
    )
    BEGIN
        PRINT 'Insufficient stock. Order rejected.'
        RETURN;
    END

    -- If stock is enough, insert
    INSERT INTO Sales.SalesOrderDetail (SalesOrderID, ProductID, OrderQty, UnitPrice)
    SELECT SalesOrderID, ProductID, OrderQty, UnitPrice
    FROM INSERTED;

    -- Update stock
    UPDATE p
    SET SafetyStockLevel = p.SafetyStockLevel - i.OrderQty
    FROM Production.Product p
    JOIN INSERTED i ON p.ProductID = i.ProductID;
END;

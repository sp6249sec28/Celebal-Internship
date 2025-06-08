Select h.SalesOrderID, p.Name AS ProductName
From Sales.SalesOrderHeader h
JOIN Sales.SalesOrderDetail d ON h.SalesOrderID = d.SalesOrderID
JOIN Production.Product p ON d.ProductID = p.ProductID;

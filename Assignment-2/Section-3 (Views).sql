CREATE VIEW vwCustomerOrders AS
SELECT s.Name AS CompanyName, soh.SalesOrderID AS OrderID, soh.OrderDate,
       sod.ProductID, p.Name AS ProductName,
       sod.OrderQty AS Quantity, sod.UnitPrice,
       sod.OrderQty * sod.UnitPrice AS Total
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
LEFT JOIN Sales.Store s ON c.StoreID = s.BusinessEntityID;

GO

CREATE VIEW vwCustomerOrders_Yesterday AS
SELECT s.Name AS CompanyName, soh.SalesOrderID AS OrderID, soh.OrderDate,
       sod.ProductID, p.Name AS ProductName,
       sod.OrderQty AS Quantity, sod.UnitPrice,
       sod.OrderQty * sod.UnitPrice AS Total
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
LEFT JOIN Sales.Store s ON c.StoreID = s.BusinessEntityID
WHERE CAST(soh.OrderDate AS DATE) = CAST(DATEADD(DAY, -1, GETDATE()) AS DATE);

GO

CREATE VIEW MyProducts AS
SELECT p.ProductID, p.Name AS ProductName, p.Size AS QuantityPerUnit,
       p.ListPrice AS UnitPrice, v.Name AS CompanyName, pc.Name AS CategoryName
FROM Production.Product p
JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
JOIN Purchasing.ProductVendor pv ON p.ProductID = pv.ProductID
JOIN Purchasing.Vendor v ON pv.BusinessEntityID = v.BusinessEntityID
WHERE p.DiscontinuedDate IS NULL;



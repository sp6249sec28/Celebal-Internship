Select p.Name AS ProductName, Sum(d.LineTotal) AS TotalRevenue
From Production.Product p
JOIN Sales.SalesOrderDetail d ON p.ProductID = d.ProductID
GROUP BY p.Name;

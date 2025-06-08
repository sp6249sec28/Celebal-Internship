Select DISTINCT p.Name
From Production.Product p
JOIN Sales.SalesOrderDetail d ON p.ProductID = d.ProductID
JOIN Sales.SalesOrderHeader h ON d.SalesOrderID = h.SalesOrderID
Where p.SellEndDate IS NOT NULL
  AND h.OrderDate BETWEEN '1997-01-01' AND '1998-01-01';

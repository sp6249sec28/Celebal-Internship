Select TOP 1 h.CustomerID, Count(h.SalesOrderID) AS TotalOrders, Sum(d.LineTotal) AS TotalSpent
From Sales.SalesOrderHeader h
JOIN Sales.SalesOrderDetail d ON h.SalesOrderID = d.SalesOrderID
GROUP BY h.CustomerID
ORDER BY TotalSpent DESC;

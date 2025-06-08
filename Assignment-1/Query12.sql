Select TOP 1 soh.SalesOrderID, soh.OrderDate, SUM(sod.LineTotal) AS TotalAmount
From Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY soh.SalesOrderID, soh.OrderDate
ORDER BY TotalAmount DESC;

Select soh.SalesOrderID, Sum(sod.LineTotal) AS TotalAmount
From Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY soh.SalesOrderID
HAVING SUM(sod.LineTotal) > 200;

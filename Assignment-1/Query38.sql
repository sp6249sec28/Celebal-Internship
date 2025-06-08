Select TOP 1 h.OrderDate, Sum(d.LineTotal) AS OrderTotal
From Sales.SalesOrderHeader h
JOIN Sales.SalesOrderDetail d ON h.SalesOrderID = d.SalesOrderID
GROUP BY h.OrderDate
ORDER BY OrderTotal DESC;

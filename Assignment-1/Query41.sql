Select TOP 10 c.CustomerID, Sum(d.LineTotal) AS TotalBusiness
From Sales.SalesOrderHeader h
JOIN Sales.SalesOrderDetail d ON h.SalesOrderID = d.SalesOrderID
JOIN Sales.Customer c ON h.CustomerID = c.CustomerID
GROUP BY c.CustomerID
ORDER BY TotalBusiness DESC;

Select e.BusinessEntityID, Sum(d.LineTotal) AS TotalSales
From Sales.SalesOrderHeader h
JOIN Sales.SalesOrderDetail d ON h.SalesOrderID = d.SalesOrderID
JOIN Sales.SalesPerson s ON h.SalesPersonID = s.BusinessEntityID
JOIN HumanResources.Employee e ON s.BusinessEntityID = e.BusinessEntityID
GROUP BY e.BusinessEntityID;

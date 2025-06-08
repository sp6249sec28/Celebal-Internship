Select DISTINCT c.CustomerID
From Sales.Customer c
JOIN Sales.SalesOrderHeader s ON c.CustomerID = s.CustomerID;

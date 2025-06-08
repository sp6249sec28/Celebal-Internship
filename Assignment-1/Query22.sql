Select p.FirstName + ' ' + p.LastName AS ContactName, Count(s.SalesOrderID) AS OrderCount
From Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader s ON c.CustomerID = s.CustomerID
GROUP BY p.FirstName, p.LastName
HAVING COUNT(s.SalesOrderID) > 3;

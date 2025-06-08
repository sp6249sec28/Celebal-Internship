Select p.FirstName + ' ' + p.LastName AS ContactName, Count(soh.SalesOrderID) AS OrderCount
From Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
GROUP BY p.FirstName, p.LastName;

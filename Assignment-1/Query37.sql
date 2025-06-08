SELECT e.BusinessEntityID AS EmployeeID,
       p.FirstName, p.LastName,
       COUNT(soh.SalesOrderID) AS OrdersTaken
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesPerson sp ON soh.SalesPersonID = sp.BusinessEntityID
JOIN HumanResources.Employee e ON sp.BusinessEntityID = e.BusinessEntityID
JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
WHERE c.AccountNumber BETWEEN 'A' AND 'AO'
GROUP BY e.BusinessEntityID, p.FirstName, p.LastName;

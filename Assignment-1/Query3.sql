Select DISTINCT c.CustomerID, a.City
FROM Sales.Customer c
JOIN Person.BusinessEntityAddress b ON c.PersonID = b.BusinessEntityID
JOIN Person.Address a ON b.AddressID = a.AddressID
WHERE a.City IN ('Berlin', 'London');
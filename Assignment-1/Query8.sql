Select DISTINCT c.CustomerID
From Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Person.BusinessEntityAddress b ON c.PersonID = b.BusinessEntityID
JOIN Person.Address a ON b.AddressID = a.AddressID
Where a.City = 'London' AND p.Name = 'Chai';

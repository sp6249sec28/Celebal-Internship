Select DISTINCT a.PostalCode
From Sales.SalesOrderHeader h
JOIN Sales.SalesOrderDetail d ON h.SalesOrderID = d.SalesOrderID
JOIN Production.Product p ON d.ProductID = p.ProductID
JOIN Person.Address a ON h.ShipToAddressID = a.AddressID
WHERE p.Name = 'Tofu';

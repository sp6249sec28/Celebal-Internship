Select DISTINCT c.CustomerID, cr.Name AS Country
From Sales.Customer c
JOIN Person.BusinessEntityAddress b ON c.PersonID = b.BusinessEntityID
JOIN Person.Address a ON b.AddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
WHERE cr.Name IN ('United Kingdom', 'United States');

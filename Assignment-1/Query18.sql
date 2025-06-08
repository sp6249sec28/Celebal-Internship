Select *
From Sales.SalesOrderHeader
Where ShipToAddressID IN (
    Select AddressID 
	From Person.Address 
	Where PostalCode = 'CA'
);

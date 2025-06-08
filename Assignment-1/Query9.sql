Select CustomerID
From Sales.Customer
Where CustomerID NOT IN (
    Select DISTINCT CustomerID 
	From Sales.SalesOrderHeader
);

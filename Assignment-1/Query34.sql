Select p.ProductID, p.Name
From Production.Product p
Where p.ProductID NOT IN (
    Select DISTINCT ProductID
    From Sales.SalesOrderDetail
);

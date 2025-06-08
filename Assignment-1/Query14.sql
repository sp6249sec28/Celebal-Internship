Select SalesOrderID, Min(OrderQty) AS MinQuantity, Max(OrderQty) AS MaxQuantity
From Sales.SalesOrderDetail
GROUP BY SalesOrderID;

Select SalesOrderID, Sum(OrderQty) AS TotalQty
From Sales.SalesOrderDetail
GROUP BY SalesOrderID
Having Sum(OrderQty) > 300;

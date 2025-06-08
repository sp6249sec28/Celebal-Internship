Select SalesOrderID, AVG(OrderQty) AS AvgQuantity
From Sales.SalesOrderDetail
GROUP BY SalesOrderID;

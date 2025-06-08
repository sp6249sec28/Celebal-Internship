Select ProductID, Name, SafetyStockLevel, ReorderPoint
From Production.Product
Where SafetyStockLevel < 10 AND ReorderPoint = 0;

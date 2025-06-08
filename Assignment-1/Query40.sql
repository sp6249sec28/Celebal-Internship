Select v.BusinessEntityID AS SupplierID, Count(p.ProductID) AS ProductCount
From Purchasing.Vendor v
JOIN Purchasing.ProductVendor p ON v.BusinessEntityID = p.BusinessEntityID
GROUP BY v.BusinessEntityID;

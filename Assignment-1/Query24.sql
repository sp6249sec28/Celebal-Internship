Select e1p.FirstName AS EmpFirst, e1p.LastName AS EmpLast,
       e2p.FirstName AS SupFirst, e2p.LastName AS SupLast
From HumanResources.Employee e1
LEFT JOIN HumanResources.Employee e2 ON e1.OrganizationNode.GetAncestor(1) = e2.OrganizationNode
LEFT JOIN Person.Person e1p ON e1.BusinessEntityID = e1p.BusinessEntityID
LEFT JOIN Person.Person e2p ON e2.BusinessEntityID = e2p.BusinessEntityID;

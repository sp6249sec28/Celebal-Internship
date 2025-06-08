Select m.BusinessEntityID AS ManagerID, p.FirstName + ' ' + p.LastName AS ManagerName, Count(e.BusinessEntityID) AS ReporteeCount
From HumanResources.Employee e
JOIN HumanResources.Employee m ON e.OrganizationNode.GetAncestor(1) = m.OrganizationNode
JOIN Person.Person p ON m.BusinessEntityID = p.BusinessEntityID
GROUP BY m.BusinessEntityID, p.FirstName, p.LastName;

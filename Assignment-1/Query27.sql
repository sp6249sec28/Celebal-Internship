Select m.BusinessEntityID, p.FirstName, p.LastName, Count(e.BusinessEntityID) AS ReportCount
From HumanResources.Employee e
JOIN HumanResources.Employee m ON e.OrganizationNode.GetAncestor(1) = m.OrganizationNode
JOIN Person.Person p ON m.BusinessEntityID = p.BusinessEntityID
GROUP BY m.BusinessEntityID, p.FirstName, p.LastName
HAVING Count(e.BusinessEntityID) > 4;

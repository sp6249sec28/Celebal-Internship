Select *
From Person.Person p
JOIN HumanResources.Employee e ON p.BusinessEntityID = e.BusinessEntityID
Where p.FirstName LIKE '%a%';

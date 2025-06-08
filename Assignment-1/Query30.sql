SELECT c.CustomerID, p.FirstName, p.LastName
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
WHERE p.BusinessEntityID NOT IN (
    SELECT pp.BusinessEntityID
    FROM Person.PersonPhone pp
    JOIN Person.PhoneNumberType pn ON pp.PhoneNumberTypeID = pn.PhoneNumberTypeID
    WHERE pn.Name = 'Fax'
);

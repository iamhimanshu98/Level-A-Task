-- Q1: List of all customers
SELECT 
    c.CustomerID,
    ISNULL(p.FirstName + ' ' + p.LastName, s.Name) AS CustomerName,
    c.PersonID,
    c.StoreID
FROM Sales.Customer c
LEFT JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
LEFT JOIN Sales.Store s ON c.StoreID = s.BusinessEntityID;

-- Q2: List of all customers where company name ends with 'N'
SELECT 
    c.CustomerID,
    s.Name AS CompanyName
FROM Sales.Customer c
JOIN Sales.Store s ON c.StoreID = s.BusinessEntityID
WHERE s.Name LIKE '%N';

-- Q3: List all customers who live in Berlin or London
SELECT DISTINCT 
    c.CustomerID,
    ISNULL(p.FirstName + ' ' + p.LastName, s.Name) AS CustomerName,
    a.City
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Person.Address a ON soh.BillToAddressID = a.AddressID OR soh.ShipToAddressID = a.AddressID
LEFT JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
LEFT JOIN Sales.Store s ON c.StoreID = s.BusinessEntityID
WHERE a.City IN ('Berlin', 'London');

-- Q4: List all customers who live in UK or USA
SELECT DISTINCT 
    c.CustomerID,
    ISNULL(p.FirstName + ' ' + p.LastName, s.Name) AS CustomerName,
    cr.CountryRegionCode
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Person.Address a ON soh.BillToAddressID = a.AddressID OR soh.ShipToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
LEFT JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
LEFT JOIN Sales.Store s ON c.StoreID = s.BusinessEntityID
WHERE cr.CountryRegionCode IN ('GB', 'US');


-- Q5: List of all products sorted by product name
SELECT ProductID, Name
FROM Production.Product
ORDER BY Name;

-- Q6: List of all products where product name starts with 'A'
SELECT ProductID, Name
FROM Production.Product
WHERE Name LIKE 'A%';

-- Q7: List customers who ever placed an order
SELECT DISTINCT 
    c.CustomerID,
    ISNULL(p.FirstName + ' ' + p.LastName, s.Name) AS CustomerName
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
LEFT JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
LEFT JOIN Sales.Store s ON c.StoreID = s.BusinessEntityID;

-- Q8: List Customers who live in London and have bought 'Chai'
SELECT DISTINCT 
    c.CustomerID,
    ISNULL(p.FirstName + ' ' + p.LastName, s.Name) AS CustomerName
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product pProd ON sod.ProductID = pProd.ProductID
JOIN Person.Address a ON soh.BillToAddressID = a.AddressID OR soh.ShipToAddressID = a.AddressID
LEFT JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
LEFT JOIN Sales.Store s ON c.StoreID = s.BusinessEntityID
WHERE a.City = 'London' AND pProd.Name = 'Chai';

-- Q9: List customers who never placed an order
SELECT 
    c.CustomerID,
    ISNULL(p.FirstName + ' ' + p.LastName, s.Name) AS CustomerName
FROM Sales.Customer c
LEFT JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
LEFT JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
LEFT JOIN Sales.Store s ON c.StoreID = s.BusinessEntityID
WHERE soh.SalesOrderID IS NULL;

-- Q10: List customers who ordered 'Tofu'
SELECT DISTINCT 
    c.CustomerID,
    ISNULL(p.FirstName + ' ' + p.LastName, s.Name) AS CustomerName
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product pProd ON sod.ProductID = pProd.ProductID
LEFT JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
LEFT JOIN Sales.Store s ON c.StoreID = s.BusinessEntityID
WHERE pProd.Name = 'Tofu';

-- Q11: Details of first order of the system (earliest orderdate)
SELECT TOP 1 *
FROM Sales.SalesOrderHeader
ORDER BY OrderDate ASC;

-- Q12: Find the details of most expensive order date
SELECT TOP 1 OrderDate, SalesOrderID, TotalDue
FROM Sales.SalesOrderHeader
ORDER BY TotalDue DESC;

-- Q13: For each order get the OrderID and Average quantity of items in that order
SELECT 
    SalesOrderID,
    AVG(OrderQty) AS AvgOrderQuantity
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID;

-- Q14: For each order get the orderID, minimum quantity and maximum quantity for that order
SELECT 
    SalesOrderID,
    MIN(OrderQty) AS MinOrderQuantity,
    MAX(OrderQty) AS MaxOrderQuantity
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID;

-- Q15: Get a list of all managers and total number of employees who report to them.
SELECT 
    JobTitle,
    COUNT(*) AS TotalEmployees
FROM HumanResources.Employee
GROUP BY JobTitle
ORDER BY TotalEmployees DESC;


-- Q16: Get the OrderID and the total quantity for each order that has a total quantity of greater than 300
SELECT 
    SalesOrderID,
    SUM(OrderQty) AS TotalQuantity
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
HAVING SUM(OrderQty) > 300;

-- Q17: List of all orders placed on or after 1996/12/31
SELECT *
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '1996-12-31';

-- Q18: List of all orders shipped to Canada
SELECT *
FROM Sales.SalesOrderHeader soh
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
WHERE sp.CountryRegionCode = 'CA';


-- Q19: List of all orders with order total > 200
SELECT *
FROM Sales.SalesOrderHeader
WHERE TotalDue > 200;

-- Q20: List of countries and sales made in each country
SELECT 
    sp.CountryRegionCode,
    SUM(soh.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader soh
JOIN Person.Address a ON soh.BillToAddressID = a.AddressID OR soh.ShipToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
GROUP BY sp.CountryRegionCode
ORDER BY TotalSales DESC;


-- Q21: List of Customer ContactName and number of orders they placed
SELECT 
    c.CustomerID,
    ISNULL(p.FirstName + ' ' + p.LastName, s.Name) AS ContactName,
    COUNT(soh.SalesOrderID) AS OrderCount
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
LEFT JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
LEFT JOIN Sales.Store s ON c.StoreID = s.BusinessEntityID
GROUP BY c.CustomerID, ISNULL(p.FirstName + ' ' + p.LastName, s.Name);

-- Q22: List of customer contact names who have placed more than 3 orders
SELECT 
    ContactName,
    OrderCount
FROM (
    SELECT 
        c.CustomerID,
        ISNULL(p.FirstName + ' ' + p.LastName, s.Name) AS ContactName,
        COUNT(soh.SalesOrderID) AS OrderCount
    FROM Sales.Customer c
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    LEFT JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    LEFT JOIN Sales.Store s ON c.StoreID = s.BusinessEntityID
    GROUP BY c.CustomerID, ISNULL(p.FirstName + ' ' + p.LastName, s.Name)
) AS CustomerOrders
WHERE OrderCount > 3;

-- Q23: List of discontinued products which were ordered between 1/1/1997 and 1/1/1998
SELECT DISTINCT 
    p.ProductID,
    p.Name
FROM Production.Product p
JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
WHERE p.DiscontinuedDate IS NOT NULL
  AND soh.OrderDate >= '1997-01-01'
  AND soh.OrderDate < '1998-01-01';

-- Q24: List of employee firstname, lastname, supervisor firstname, lastname
SELECT 
    e.BusinessEntityID AS EmployeeID,
    p.FirstName AS FirstName,
    p.LastName AS LastName,
    e.JobTitle
FROM HumanResources.Employee e
JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
ORDER BY e.JobTitle;


-- Q25: List of Employees id and total sale conducted by employee
SELECT 
    e.BusinessEntityID AS EmployeeID,
    ISNULL(SUM(soh.TotalDue),0) AS TotalSales
FROM HumanResources.Employee e
LEFT JOIN Sales.SalesOrderHeader soh ON e.BusinessEntityID = soh.SalesPersonID
GROUP BY e.BusinessEntityID;

-- Q26: List of employees whose FirstName contains character 'a'
SELECT 
    BusinessEntityID,
    FirstName,
    LastName
FROM Person.Person
WHERE FirstName LIKE '%a%';

-- Q27: List of managers who have more than four people reporting to them.
SELECT 
    e.BusinessEntityID AS EmployeeID,
    p.FirstName + ' ' + p.LastName AS EmployeeName,
    e.JobTitle
FROM HumanResources.Employee e
JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
WHERE e.JobTitle LIKE '%Manager%'
ORDER BY e.JobTitle;


-- Q28: List of Orders and ProductNames
SELECT 
    soh.SalesOrderID,
    p.Name AS ProductName
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID;

-- Q29: List of orders placed by the best customer (customer with highest total sales)
WITH CustomerSales AS (
    SELECT 
        soh.CustomerID,
        SUM(soh.TotalDue) AS TotalSales
    FROM Sales.SalesOrderHeader soh
    GROUP BY soh.CustomerID
),
BestCustomer AS (
    SELECT TOP 1 CustomerID
    FROM CustomerSales
    ORDER BY TotalSales DESC
)
SELECT soh.*
FROM Sales.SalesOrderHeader soh
JOIN BestCustomer bc ON soh.CustomerID = bc.CustomerID;

-- Q30: List of orders placed by customers who do not have a Fax number
SELECT 
    soh.*
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
LEFT JOIN Person.PersonPhone pp ON c.PersonID = pp.BusinessEntityID AND pp.PhoneNumberTypeID = 3 
WHERE pp.PhoneNumber IS NULL OR LTRIM(RTRIM(pp.PhoneNumber)) = '';


-- Q31: List of Postal codes where the product 'Tofu' was shipped
SELECT DISTINCT 
    a.PostalCode
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
WHERE p.Name = 'Tofu';

-- Q32: List of product names that were shipped to France
SELECT DISTINCT
    p.Name
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
WHERE sp.CountryRegionCode = 'FR';


-- Q33: List of ProductNames and Categories for the supplier 'Specialty Biscuits, Ltd.'
SELECT 
    p.Name AS ProductName,
    pc.Name AS CategoryName
FROM Production.Product p
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
JOIN Purchasing.ProductVendor pv ON p.ProductID = pv.ProductID
JOIN Purchasing.Vendor v ON pv.BusinessEntityID = v.BusinessEntityID
WHERE v.Name = 'Specialty Biscuits, Ltd.';


-- Q34: List of products that were never ordered
SELECT 
    p.ProductID,
    p.Name
FROM Production.Product p
LEFT JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
WHERE sod.ProductID IS NULL;

-- Q35: List of products where units in stock is less than 10 and units on order are 0.
SELECT 
    p.ProductID,
    p.Name,
    pi.Quantity AS UnitsInStock
FROM Production.Product p
JOIN Production.ProductInventory pi ON p.ProductID = pi.ProductID
WHERE pi.Quantity < 10
AND p.ProductID NOT IN (
    SELECT DISTINCT ProductID
    FROM Purchasing.PurchaseOrderDetail
);


-- Q36: List of top 10 countries by sales
SELECT TOP 10
    cr.Name AS CountryName,
    SUM(soh.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader soh
JOIN Person.Address a ON soh.BillToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
GROUP BY cr.Name
ORDER BY TotalSales DESC;


-- Q37: Number of orders each employee has taken for customers with CustomerIDs between 'A' and 'AO'
-- Assuming CustomerIDs are string type, otherwise adjust condition accordingly.
SELECT 
    e.BusinessEntityID AS EmployeeID,
    COUNT(soh.SalesOrderID) AS NumberOfOrders
FROM HumanResources.Employee e
JOIN Sales.SalesOrderHeader soh ON e.BusinessEntityID = soh.SalesPersonID
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
WHERE c.CustomerID BETWEEN 'A' AND 'AO'
GROUP BY e.BusinessEntityID;

-- Q38: Order date of most expensive order
SELECT TOP 1 OrderDate, TotalDue
FROM Sales.SalesOrderHeader
ORDER BY TotalDue DESC;

-- Q39: Product name and total revenue from that product
SELECT 
    p.ProductID,
    p.Name,
    SUM(sod.LineTotal) AS TotalRevenue
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p ON sod.ProductID = p.ProductID
GROUP BY p.ProductID, p.Name
ORDER BY TotalRevenue DESC;

-- Q40: SupplierID and number of products offered
SELECT 
    BusinessEntityID AS SupplierID,
    COUNT(ProductID) AS NumberOfProducts
FROM Purchasing.ProductVendor
GROUP BY BusinessEntityID;


-- Q41: Top ten customers based on their business (total sales)
SELECT TOP 10 
    c.CustomerID,
    ISNULL(p.FirstName + ' ' + p.LastName, s.Name) AS CustomerName,
    SUM(soh.TotalDue) AS TotalSales
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
LEFT JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
LEFT JOIN Sales.Store s ON c.StoreID = s.BusinessEntityID
GROUP BY c.CustomerID, ISNULL(p.FirstName + ' ' + p.LastName, s.Name)
ORDER BY TotalSales DESC;

-- Q42: What is the total revenue of the company
SELECT SUM(TotalDue) AS TotalCompanyRevenue
FROM Sales.SalesOrderHeader;

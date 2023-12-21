--1/ Display the names of products for which individual elements are defined:
--a. Color
--b. Weight
--c. Size

  --RESP
  -- Products with Color
SELECT ProductID, Name, Color
FROM Production.Product
WHERE Color IS NOT NULL;

-- Products with Weight
SELECT ProductID, Name, Weight
FROM Production.Product
WHERE Weight IS NOT NULL;

-- Products with Size
SELECT ProductID, Name, Size
FROM Production.Product
WHERE Size IS NOT NULL;

--2/ Display the name of the lightest and heaviest product containing "Road" in the name.

  --RESP
  -- Lightest product containing "Road" in the name
SELECT TOP 1 Name, Weight
FROM Production.Product
WHERE Name LIKE '%Road%'
ORDER BY Weight ASC;

-- Heaviest product containing "Road" in the name
SELECT TOP 1 Name, Weight
FROM Production.Product
WHERE Name LIKE '%Road%'
ORDER BY Weight DESC;

  
--3/ Display products whose price is above average.

  --RESP
  -- Display products whose price is above average
SELECT ProductID, Name, ListPrice
FROM Production.Product
WHERE ListPrice > (SELECT AVG(ListPrice) FROM Production.Product);

  
--4/ Display the average price of the product depending on the category (field[Production].[ProductCategory]). To perform a correct join, use the ProductSubcategory table.

  --RESP
  -- Display average price of products by category
SELECT 
    pc.ProductCategoryID,
    pc.Name AS CategoryName,
    ps.ProductSubcategoryID,
    ps.Name AS SubcategoryName,
    AVG(p.ListPrice) AS AveragePrice
FROM 
    Production.Product AS p
JOIN 
    Production.ProductSubcategory AS ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN 
    Production.ProductCategory AS pc ON ps.ProductCategoryID = pc.ProductCategoryID
GROUP BY 
    pc.ProductCategoryID, pc.Name, ps.ProductSubcategoryID, ps.Name
ORDER BY 
    pc.ProductCategoryID, ps.ProductSubcategoryID;

  
--5/ Display the names of all customers and the total amount of their purchases (use theSalesOrderHeader.SubTotal column to determine the total). The list is to be sorted in descendingorder of total purchases.

  --RESP
  -- Display customer names and total purchases
SELECT 
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    SUM(soh.SubTotal) AS TotalPurchases
FROM 
    Sales.Customer AS c
JOIN 
    Sales.SalesOrderHeader AS soh ON c.CustomerID = soh.CustomerID
GROUP BY 
    c.CustomerID, CONCAT(c.FirstName, ' ', c.LastName)
ORDER BY 
    TotalPurchases DESC;

  
--6/ Display the names of all salespeople and their total sales (use the SalesOrderHeader.SubTotalcolumn to determine the total). The list is to be sorted in descending order of total sales.

  --RESP
  -- Display salespeople names and total sales
SELECT 
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS SalespersonName,
    SUM(soh.SubTotal) AS TotalSales
FROM 
    HumanResources.Employee AS e
JOIN 
    Sales.SalesPerson AS sp ON e.EmployeeID = sp.EmployeeID
JOIN 
    Sales.SalesOrderHeader AS soh ON sp.BusinessEntityID = soh.SalesPersonID
GROUP BY 
    e.EmployeeID, CONCAT(e.FirstName, ' ', e.LastName)
ORDER BY 
    TotalSales DESC;

  
--7/ Display categories, subcategories, sellers' names and surnames, and the average discount onproducts (relative to sub-category) that the seller has given to customers. Display only those rows inwhich the average discount is greater than zero.

  --RESP
  -- Display categories, subcategories, sellers' names and surnames, and average discount
SELECT 
    pc.Name AS Category,
    ps.Name AS Subcategory,
    CONCAT(e.FirstName, ' ', e.LastName) AS SellerName,
    AVG(soh.DiscountAmount / soh.SubTotal) AS AverageDiscount
FROM 
    Sales.SalesOrderHeader AS soh
JOIN 
    Sales.SalesPerson AS sp ON soh.SalesPersonID = sp.BusinessEntityID
JOIN 
    HumanResources.Employee AS e ON sp.EmployeeID = e.EmployeeID
JOIN 
    Production.ProductSubcategory AS ps ON soh.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN 
    Production.ProductCategory AS pc ON ps.ProductCategoryID = pc.ProductCategoryID
GROUP BY 
    pc.Name, ps.Name, e.FirstName, e.LastName
HAVING 
    AVG(soh.DiscountAmount / soh.SubTotal) > 0
ORDER BY 
    AverageDiscount DESC;

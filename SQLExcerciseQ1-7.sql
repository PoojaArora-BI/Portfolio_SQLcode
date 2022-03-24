 /*Find all products in the Product Category 'Accessories' */
 
    SELECT p.ProductId,
	       pc.name,
		   p.Name ProductName,
		   ps.Name ProductSubCategoryName
  FROM [Production].[Product] p
  join PRODUCTION.ProductSubcategory ps  on p.ProductSubcategoryID =  ps.ProductSubcategoryID
  Join [Production].[ProductCategory] pc on ps.ProductCategoryID = pc.ProductCategoryID
  where pc.name = 'Accessories';
  ---------------------------
 /* Find all products that have 'seat' in its name */
 SELECT p.ProductId,
		   p.Name ProductName,
		   ps.Name ProductSubcategoryName
  FROM [Production].[Product] p
  join PRODUCTION.ProductSubcategory ps  on p.ProductSubcategoryID =  ps.ProductSubcategoryID
  Join [Production].[ProductCategory] pc on ps.ProductCategoryID = pc.ProductCategoryID
  where p.name LIKE '%seat%' or ps.name like '%seat%' or pc.name like '%seat%'; 
---------------------------------------------------------------------------------------------------------------------------------------------
/* Find the No of products in each product category  */
SELECT ps.ProductCategoryID,
       pc.Name,
	   COUNT(*) Products
FROM Production.ProductCategory pc
JOIN Production.ProductSubcategory ps ON pc.ProductCategoryID = ps.ProductCategoryID
Join Production.Product p ON ps.ProductSubcategoryID = p.ProductSubcategoryID
Group By ps.ProductCategoryID,pc.Name;
---------------------------------------------------------------------------------------------------------------------------------------------
/* Find the average price of the products in each product subcategory*/
SELECT ps.ProductCategoryID,AVG(listPrice) AS AveragePrice
	FROM
	Production.ProductSubcategory ps
	Join Production.Product p ON ps.ProductSubcategoryID = p.ProductSubcategoryID
	Group By ProductCategoryID;
--------------------------------------------------------------------------------------------------------------------------------------------
/* Find the highest price of order for each customer in 2011*/
SELECT c.CustomerID,
		MAX(sod.UnitPrice) AS MaxPrice
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
WHERE YEAR(soh.OrderDate) = 2011
GROUP BY c.CustomerID;


---------------------------------------------------------------------------------------------------------------------------------------------

/* Find which customer have made the most orders in terms of product quantity; and which customers have made orders in terms of the 
   product total price */

SELECT soh.CustomerID,
		SUM(sod.OrderQty) AS OrderQty
FROM  Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY soh.CustomerID;
ORDER BY OrderQty DESC;

SELECT soh.CustomerID
		SUM(sod.LineTotal) AS TotalPrice
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY soh.CustomerID
ORDER BY TotalPrice DESC;

   ----------------------------------------------------------------------------------------------------------------------------------------------

/******find the orders that were made between the dates '2011-06-13' to '2011-06-18'  ******/
SELECT SalesOrderID 'ORDER MADE'
  
FROM [Sales].[SalesOrderHeader]

WHERE OrderDate BETWEEN '2011-06-13' and '2011-06-18';

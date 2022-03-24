INSERT INTO [dbo].[DimProduct]
           ([ProductID]
           ,[ProductName]
           ,[ListPrice]
           ,[Color]
           ,[Size]
           ,[SellStartDate]
           ,[SellEndDate]
           ,[ProductCategory]
           ,[ProductSubcategory])
SELECT  p.ProductID,
		p.Name As ProductName,
		p.ListPrice,
		CASE WHEN ISNULL (p.Color,'') = '' THEN 'Not Defined'
			 ELSE ISNULL (p.Color,'')
		END AS Color,
		
		CASE WHEN TRY_CAST(ISNULL(p.size,'') AS INT) <= 50 then 'S'
			 WHEN TRY_CAST(ISNULL(p.size,'') AS INT) > 50 AND TRY_CAST(ISNULL(p.size,'') AS INT) <= 60 THEN 'M'
			 WHEN TRY_CAST(ISNULL(p.size,'') AS INT) > 60 AND TRY_CAST(ISNULL(p.size,'') AS INT) <= 70 THEN 'L'
			 WHEN TRY_CAST(ISNULL(p.size,'') AS INT) > 70 THEN 'XL'
		ELSE ISNULL(p.size,'')
		END AS Size_New,
		p.SellStartDate,
		p.SellEndDate,
		CASE WHEN ISNULL(pc.Name,'') = '' THEN 'Not Defined'
			ELSE ISNULL(pc.Name,'')
		END AS ProductCategory,
		CASE WHEN ISNULL(ps.Name,'') = '' THEN 'Not Defined'
			 ELSE ISNULL(ps.Name,'')
		END AS ProductSubcategory
FROM AdventureWorks2019.Production.Product p
LEFT JOIN AdventureWorks2019.Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
LEFT JOIN AdventureWorks2019.Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID

INSERT INTO [dbo].[DimCustomer]
           ([CustomerID]
           ,[AccountNumber]
           ,[CustomerName]
           ,[TerritoryName]
           ,[TerritoryGroup]
           ,[CountryRegion]
           ,[CustomerType])
SELECT c.CustomerID,
		c.AccountNumber,
		CASE WHEN st.Name IS NULL THEN CONCAT(pr.FirstName,' ',pr.LastName)
			 WHEN st.Name IS NOT NULL THEN st.Name
		END AS CustomerName,
		t.Name AS TerritoryName,
		t.[Group] As TerritoryGroup,
		cr.Name As CountryRegion,
		CASE WHEN c.StoreID IS NOT NULL THEN 'Store'
		ELSE 'Person'
		END AS CustomerType
FROM AdventureWorks2019.Sales.Customer c
Left Join AdventureWorks2019.Sales.Store st ON c.StoreID = st.BusinessEntityID
LEFT JOIN AdventureWorks2019.Person.Person pr ON c.PersonID = pr.BusinessEntityID
LEFT JOIN AdventureWorks2019.Sales.SalesTerritory t ON c.TerritoryID = t.TerritoryID
LEFT JOIN AdventureWorks2019.Person.CountryRegion cr ON t.CountryRegionCode = cr.CountryRegionCode


INSERT INTO [dbo].[FactSales]
           ([SalesOrderID]
           ,[SaledOrderDetailID]
           ,[OrderQty]
           ,[LineTotal]
           ,[UnitPrice]
           ,[CustomerKey]
           ,[ProductKey]
           ,[OrderDateKey]
           ,[DueDateKey]
           ,[ShipDateKey])

Select  sd.SalesOrderID,
		sd.SalesOrderDetailID,
		sd.OrderQty,
		sd.LineTotal,
		sd.UnitPrice,
		dc.CustomerKey,
		dp.ProductKey,
		dimorderdate.DateKey,
		dimduedate.DateKey,
		dimshipdate.DateKey
From AdventureWorks2019.Sales.SalesOrderHeader sh
Inner Join AdventureWorks2019.Sales.SalesOrderDetail sd On sh.SalesOrderID = sd.SalesOrderID
INNER JOIN DimCustomer dc ON sh.CustomerID = dc.CustomerID
INNER JOIN DimProduct dp ON sd.ProductID = dp.ProductID
INNER JOIN DimDate dimorderdate ON sh.OrderDate = dimorderdate.FullDate
INNER JOIN DimDate dimduedate ON sh.DueDate = dimduedate.FullDate
INNER JOIN DimDate dimshipdate ON sh.ShipDate = dimshipdate.FullDate
--Group BY 
--dc.CustomerKey,
--dp.ProductKey,
--dimorderdate.DateKey
-- dimdue

SELECT * FROM DimProduct
Select * FROM DimDate
Select * FROM DimCustomer
Select * FROM FactSales
--Truncate table [dbo].[DimProduct1]

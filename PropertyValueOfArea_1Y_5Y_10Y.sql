
/* Given Suburb and City, display property value of the area of 1Year, 5Year and 10 Year */


SELECT Suburb, City, State, PropertyType, Year, CapitalGrowthValue, [TimeFrame]
FROM (SELECT g.Suburb,g.city,g.State,p.PropertyType,p.Year,
CAST (MedianValue AS money) AS [CurrentMedian],
CAST (MedianValue*(1+(0.05*1)) AS money) AS [Value1Y],
CAST (MedianValue *(1+(0.05*5)) AS money) AS [Value5Y],
CAST (MedianValue*(1+(0.05*10)) AS money)AS [Value10Y]
FROM [Fact_MedianPropertyValueByYear] AS p INNER JOIN DimGeography AS g
     ON p.GeographyID = g.GeographyKey) p
UNPIVOT
(CapitalGrowthValue FOR [TimeFrame] IN 
([CurrentMedian], [Value1Y], [Value5Y], [Value10Y]))
AS unpvt;

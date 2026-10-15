select Top 10 * from dbo.Products

select Top 10 * from dbo.Sales

select Top 10 * from dbo.Stores

--------------------------------------------------------------------------------------

--- Total Revenue - Profit and Units

SELECT
	S.Sale_ID,
	S.Date,
	S.Units,
	P.Product_Name,
	P.Product_Cost,
	P.Product_Price,
	S.Units * P.Product_Price AS Revenue,
	S.Units * (P.Product_Price - P.Product_Cost) AS Profit
FROM Sales S JOIN Products P
ON S.Product_ID = P.Product_ID

SELECT
	SUM(S.Units * P.Product_Price) AS [Total of Revenue],
	SUM(S.Units * (P.Product_Price - P.Product_Cost)) AS [Total of Profit],
	SUM(S.Units) AS [Total of Units]
FROM Sales S JOIN Products P 
ON S.Product_ID = P.Product_ID

--- Total of Profit / Total of Revenue = Profit Margin
--- 40140290 / 144445723.5 * 100 = %27,7 

-------------------------------------------------------------------------------------

--- Annual Profit, Revenue and Units Report
--- CAUTION: This is a misleading comparison - 2022 has full 12 months of data,
--- but 2023 only has 9 months (Jan-Sep). Comparing raw annual totals makes 2023
--- look like a decline (696M vs 748M), when it's actually an apples-to-oranges comparison.
--- See the month-over-month query below for a fair (like-for-like) comparison,
--- which shows 2023 actually outperformed 2022 in every matching month (~46% growth).


SELECT 
	YEAR(S.Date) AS [Sale of Year],
	SUM(S.Units * P.Product_Price) [Total of Revenue],
	SUM(S.Units * (P.Product_Price - P.Product_Cost)) [Total of Profit]
FROM Sales S
JOIN Products P
ON S.Product_ID = P.Product_ID
GROUP BY Year(S.DATE)
ORDER BY YEAR(S.DATE)
--------------------------------------------------------------------------------------
-- Monthly Revenue and Profit Analysis
-- This query calculates total revenue and total profit for each month and year.
-- It helps identify sales trends, seasonal patterns, and profitability over time.


SELECT 
	YEAR(S.DATE) AS [Sale of Year],
	MONTH(S.Date) AS [Sale of Month],
	SUM(S.Units * P.Product_Price) AS [Total of Revenue],
	SUM(S.Units * (P.Product_Price - P.PRoduct_Cost)) [Total of Profit]
FROM Sales S
INNER JOIN Products P 
ON S.Product_ID = P.Product_ID
GROUP BY Year(S.Date),Month(S.DATE) 
Order BY Year(S.Date),Month(S.DATE) 

--- Seasonal Revenue and Profit Analysis
--- CAUTION: 2023 Winter only includes Jan-Feb (no Dec 2023 in the data - partial, 2/3 months)
--- 2023 Autumn only includes Sep (no Oct-Nov - partial, 1/3 months). Do NOT compare

SELECT 
	YEAR(S.DATE) AS [Sale of Year],
	CASE
		WHEN MONTH(S.Date) IN (12,1,2) THEN 'Winter'
		WHEN MONTH(S.Date) IN (3,4,5) THEN 'Spring'
		WHEN MONTH(S.Date) IN (6,7,8) THEN 'Summer'
		WHEN MONTH(S.Date) IN (9,10,11) THEN 'Autumn'
END AS [Season],
	SUM(S.Units * P.Product_Price) AS [Total of Revenue],
	SUM(S.Units * (P.Product_Price - P.PRoduct_Cost)) AS [Total of Profit]
FROM Sales S
INNER JOIN Products P
ON S.Product_ID = P.Product_ID
GROUP BY CASE
		WHEN MONTH(S.Date) IN (12,1,2) THEN 'Winter'
		WHEN MONTH(S.Date) IN (3,4,5) THEN 'Spring'
		WHEN MONTH(S.Date) IN (6,7,8) THEN 'Summer'
		WHEN MONTH(S.Date) IN (9,10,11) THEN 'Autumn'
END,YEAR(S.DATE)
ORDER BY [Season], [Sale of Year]

--------------------------------------------------------------------------------------
--- Profit Margin of all products
SELECT 
	S.Product_ID,
	P.Product_Name,
	Sum(S.Units * P.Product_Price) AS [Product of Revenue],
	Sum(S.Units * (P.Product_Price - P.Product_Cost)) AS [Product of Profit],
	ROUND(
		SUM(S.Units * (P.Product_Price - P.Product_Cost)) 
		/ SUM(S.Units * P.Product_Price) * 100
	, 1) AS [Profit Margin %]
FROM Sales S
JOIN Products P 
ON S.Product_ID = P.Product_ID
GROUP BY S.Product_ID, P.Product_Name
ORDER BY [Profit Margin %];


--------------------------------------------------------------------------------------
--- TOP 10 products by REVENUE
--- Ranks products purely by total sales volume x price, regardless of margin.

SELECT TOP 10
	S.Product_ID,
	P.Product_Name,
	SUM(S.Units * P.Product_Price) AS [Product Revenue],
	SUM(S.Units * (P.Product_Price - P.Product_Cost)) AS [Product Profit]
FROM Sales S
JOIN Products P 
	ON S.Product_ID = P.Product_ID
GROUP BY S.Product_ID, P.Product_Name
ORDER BY [Product Revenue] DESC;


--- TOP 10 products by PROFIT
--- FINDING: Revenue and Profit rankings do NOT fully match.
SELECT TOP 10
	S.Product_ID,
	P.Product_Name,
	SUM(S.Units * P.Product_Price) AS [Product Revenue],
	SUM(S.Units * (P.Product_Price - P.Product_Cost)) AS [Product Profit]
FROM Sales S
JOIN Products P 
	ON S.Product_ID = P.Product_ID
GROUP BY S.Product_ID, P.Product_Name
ORDER BY [Product Profit] DESC;

--- - Lego Bricks is #1 in revenue but drops to #3 in profit - lower margin.
--- - Splash Balls and Magic Sand are top-10 in revenue but fall OUT of the profit top-10 - high volume, thin margin.
--- - Glass Marbles, Barrel O' Slime and Dart Gun are NOT in the revenue top-10 but ARE in the profit top-10 - low volume, high margin (worth promoting more?).
--- - Colorbuds is #2 by revenue but #1 by profit - strong margin performer.
--- Action item: review pricing/cost structure on high-revenue, low-margin items (Splash Balls, Magic Sand).


------------------------------------------------------------------------------------

--- Profits and Revenue of all Category

SELECT 
	P.Product_Category AS [Category_Name],
	SUM(S.Units * P.Product_Price) AS [Category Revenue],
	SUM(S.Units * (P.Product_Price - P.Product_Cost)) AS [Category Profit]
FROM Sales S
INNER JOIN Products P 
	ON S.Product_ID = P.Product_ID
Group BY P.PRODUCT_CATEGORY
ORDER BY [Category Revenue] DESC;


SELECT
	P.Product_Category AS [Category_Name],
	SUM(S.Units * P.Product_Price) AS [Category Revenue],
	SUM(S.Units * (P.Product_Price - P.Product_Cost)) AS [Category Profit]
FROM Sales S
INNER JOIN Products P 
	ON S.Product_ID = P.Product_ID
Group BY P.PRODUCT_CATEGORY
ORDER BY [Category Profit] DESC;


---- Category's Profit Margin(%) 

SELECT
	P.Product_Category AS [Category_Name],
	SUM(S.Units * P.Product_Price) AS [Category Revenue],
	SUM(S.Units * (P.Product_Price - P.Product_Cost)) AS [Category Profit],
	ROUND(
		SUM(S.Units * (P.Product_Price - P.Product_Cost)) 
		/ SUM(S.Units * P.Product_Price) * 100
	, 1) AS [Profit Margin %]
FROM Sales S
INNER JOIN Products P 
	ON S.Product_ID = P.Product_ID
GROUP BY P.Product_Category
ORDER BY [Profit Margin %] DESC;

------------------------------------------------------------------------------------

--- Store-level Revenue and Profit, sorted ascending by revenue
--- Range: lowest store (Campeche, 20.6M) to highest (Ciudad de Mexico, 55.5M) - 

SELECT 
	ST.Store_City,
	SUM(S.Units * P.Product_Price) AS [Store Revenue],
	SUM(S.Units * (P.Product_Price - P.Product_Cost)) AS [Store Profit]
FROM Sales S
INNER JOIN Products P 
	ON S.Product_ID = P.Product_ID
INNER JOIN Stores ST
	ON S.Store_ID = St.Store_ID
GROUP BY ST.Store_City
ORDER BY [Store Revenue] DESC;

---

--- Store_Location Performance, per-store average (using Store_Count to normalize)
--- ACTION ITEM: Consider whether future store expansion should weight toward
--- Airport locations given their strong per-store economics.
SELECT
	COUNT(DISTINCT ST.Store_ID) AS [Store_Count],
	ST.Store_Location,
	SUM(S.Units * P.Product_Price) / COUNT(DISTINCT ST.Store_ID) AS [Avarage Store Revenue],
	SUM(S.Units * (P.Product_Price - P.Product_Cost)) / COUNT(DISTINCT ST.Store_ID) AS [Avarage Store Profit]
FROM Sales S
INNER JOIN Products P 
	ON S.Product_ID = P.Product_ID
INNER JOIN Stores ST
	ON S.Store_ID = ST.Store_ID
GROUP BY ST.Store_Location
ORDER BY [Avarage Store Revenue] DESC;


--- Store Performance: New (2010+) vs Established (pre-2010), per-store average
--- FINAL FINDING: New stores average 29.18M revenue / 8.18M profit per store,


SELECT
	COUNT(DISTINCT ST.Store_ID) AS [Store_Count],
	CASE 
		WHEN YEAR(ST.Store_Open_Date) < 2010 THEN 'Established'
		WHEN YEAR(ST.Store_Open_Date) >= 2010 THEN 'New'
	END AS [Store_Open_Time],
	SUM(S.Units * P.Product_Price) / COUNT(DISTINCT ST.Store_ID) AS [Avarage Store Revenue],
	SUM(S.Units * (P.Product_Price - P.Product_Cost)) / COUNT(DISTINCT ST.Store_ID) AS  [Avarage Store Profit]
FROM Sales S
INNER JOIN Products P 
	ON S.Product_ID = P.Product_ID
INNER JOIN Stores ST
	ON S.Store_ID = St.Store_ID
GROUP BY CASE 
		WHEN YEAR(ST.Store_Open_Date) < 2010 THEN 'Established'
		WHEN YEAR(ST.Store_Open_Date) >= 2010 THEN 'New'
	END
ORDER BY [Avarage Store Revenue] DESC;

----------------------------------------------------------------------

--- Stockout Analysis: How many stores are out of stock (Stock_On_Hand = 0) per product

SELECT 
	P.Product_ID,
	P.Product_Name,
	COUNT(*) AS [Stockout Count]
FROM Inventory I 
INNER JOIN Products P
ON I.Product_ID = p.Product_ID
WHERE Stock_On_Hand = 0 
GROUP BY P.Product_ID, P.Product_Name
ORDER BY [Stockout Count] DESC;

--- FINDING: Playfoam is out of stock in 13/50 stores (26%), Hot Wheels 5-Pack in
--- 12/50 (24%) - the two worst stockout products by a wide margin over the rest.
--- CRITICAL: Cross-referencing with the profit margin analysis - Playfoam has a
--- 63.7% margin (one of the highest in the catalog) and Etch A Sketch (7 stockouts)
--- has 47.6% margin. These are high-margin products losing potential sales due to
--- stockouts - likely a direct, quantifiable profit leak.
--- ACTION ITEM: Prioritize restocking Playfoam and Hot Wheels 5-Pack first - both
--- high stockout frequency AND high margin means highest opportunity cost.


--- Stock Health Classification: Dead Stock vs Star vs Normal
--- Ratio = Stock_On_Hand / Total_Units_Sold. Since this dataset's ratios mostly
--- stay below 1.0 (max observed ~1.6), thresholds are set relative to that range
--- rather than using arbitrary large numbers like 100.
--- - Ratio > 0.5  → stock exceeds total units sold → Dead Stock (overstocked, slow-moving)
--- - Ratio < 0.05  → stock is a small fraction of units sold → Star (fast-moving, stockout risk)
--- - In between   → Normal (healthy balance)
--- - Never sold at all (Total_Units_Sold IS NULL) → Dead Stock (worst case, zero movement)

SELECT
    I.Store_ID,
    I.Product_ID,
    P.Product_Name,
    I.Stock_On_Hand,
    ISNULL(SalesSummary.Total_Units_Sold, 0) AS Total_Units_Sold,
    CAST(I.Stock_On_Hand AS FLOAT) / NULLIF(SalesSummary.Total_Units_Sold, 0) AS Stock_to_Sales_Ratio,
    CASE
        WHEN SalesSummary.Total_Units_Sold IS NULL THEN 'Dead Stock'
        WHEN CAST(I.Stock_On_Hand AS FLOAT) / NULLIF(SalesSummary.Total_Units_Sold, 0) > 0.5 THEN 'Dead Stock'
        WHEN CAST(I.Stock_On_Hand AS FLOAT) / NULLIF(SalesSummary.Total_Units_Sold, 0) < 0.05 THEN 'Star'
        ELSE 'Normal'
    END AS Stock_Health
FROM Inventory I
INNER JOIN Products P 
    ON I.Product_ID = P.Product_ID
LEFT JOIN (
    SELECT Store_ID, Product_ID, SUM(Units) AS Total_Units_Sold
    FROM Sales
    GROUP BY Store_ID, Product_ID
) AS SalesSummary
    ON I.Store_ID = SalesSummary.Store_ID 
    AND I.Product_ID = SalesSummary.Product_ID
WHERE I.Stock_On_Hand > 0
ORDER BY Stock_to_Sales_Ratio DESC;
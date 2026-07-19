USE superstore;
SELECT DATABASE();
DESCRIBE superstore;
SELECT COUNT(*)
FROM superstore;
SELECT *
FROM superstore
LIMIT 10;
SELECT COUNT(*) AS Total_Records
FROM superstore;
SELECT DISTINCT Category
FROM superstore;
SELECT DISTINCT Region
FROM superstore;
SELECT
COUNT(*) AS Missing_Sales
FROM superstore
WHERE Sales IS NULL;
SELECT
`Product ID`,
COUNT(*)
FROM superstore
GROUP BY `Product ID`
HAVING COUNT(*)>1;
SELECT *
FROM superstore
WHERE Sales>1000;
SELECT *
FROM superstore
WHERE Category='Furniture';
SELECT *
FROM superstore
WHERE Region='West';
SELECT *
FROM superstore
WHERE State='California';
SELECT *
FROM superstore
WHERE Category='Technology';
SELECT
SUM(Sales) AS Total_Sales
FROM superstore;
SELECT
AVG(Sales) AS Average_Sales
FROM superstore;
SELECT
SUM(Profit) AS Total_Profit
FROM superstore;
SELECT
AVG(Profit) AS Average_Profit
FROM superstore;
SELECT
MAX(Sales)
FROM superstore;
SELECT
MIN(Sales)
FROM superstore;
SELECT
Category,
SUM(Sales) AS Total_Sales
FROM superstore
GROUP BY Category;
SELECT
Region,
SUM(Sales) AS Total_Sales
FROM superstore
GROUP BY Region;
SELECT
State,
SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY State
ORDER BY Total_Profit DESC;
SELECT
Segment,
AVG(Sales) AS Average_Sales
FROM superstore
GROUP BY Segment;
SELECT
`Product Name`,
Sales
FROM superstore
ORDER BY Sales DESC
LIMIT 10;
SELECT
`Customer Name`,
SUM(Sales) AS Total_Sales
FROM superstore
GROUP BY `Customer Name`
ORDER BY Total_Sales DESC
LIMIT 10;
SELECT
`Product Name`,
SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY `Product Name`
ORDER BY Total_Profit DESC
LIMIT 10;
SELECT
MONTH(`Order Date`) AS Month,
SUM(Sales) AS Total_Sales
FROM superstore
GROUP BY MONTH(`Order Date`)
ORDER BY Month;
SELECT
Segment,
SUM(Sales)
FROM superstore
GROUP BY Segment;
SELECT
Category,
SUM(Profit)
FROM superstore
GROUP BY Category;
SELECT
`Sub-Category`,
SUM(Sales)
FROM superstore
GROUP BY `Sub-Category`
ORDER BY SUM(Sales) DESC;
SELECT Category,
       ROUND(SUM(Sales),2) AS Total_Sales
FROM superstore
GROUP BY Category
ORDER BY Total_Sales DESC;


-- ==========================================================
-- BUSINESS INSIGHTS
-- ==========================================================

-- 1. The dataset contains 9,694 sales records, providing a comprehensive view of sales transactions.

-- 2. Technology is the highest-performing product category with total sales of ₹835,900.07,
--    followed by Furniture (₹733,046.86) and Office Supplies (₹703,502.93).

-- 3. Phones emerged as the highest-selling sub-category, indicating strong customer demand
--    for communication devices.

-- 4. Customer and regional analysis shows that sales are concentrated among a few high-performing
--    customers and regions, which can help in planning targeted marketing campaigns.

-- 5. Monthly sales trend analysis highlights fluctuations in sales throughout the year,
--    helping the business identify seasonal demand and improve inventory planning.

-- 6. Aggregate functions such as COUNT(), SUM(), AVG(), MIN(), and MAX() were used to
--    evaluate sales performance, revenue, and pricing across different categories.

-- 7. Filtering, grouping, sorting, and business queries helped identify top-performing
--    products, categories, and customers, enabling better business decision-making.

-- 8. Data validation confirmed that the dataset was imported successfully and analyzed
--    using SQL queries without any major issues.
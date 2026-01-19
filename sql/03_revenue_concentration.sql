-- 03 Revenue Concentration Analysis
-- Analyzes revenue distribution using customer ranking and deciles
-- Identifies top revenue-contributing customers
-- Database: RetailAnalyticsDW

USE RetailAnalyticsDW;
GO

WITH customer_revenueAS (
SELECT
        CustomerKey,
SUM(NetSalesAmount)AS TotalRevenue
FROM dbo.FactSales
GROUPBY CustomerKey
),
rankedAS (
SELECT
        CustomerKey,
        TotalRevenue,
RANK()OVER (ORDERBY TotalRevenueDESC)AS RevenueRank,
COUNT(*)OVER ()AS TotalCustomers
FROM customer_revenue
)
SELECT
*,
CAST(1.0* RevenueRank/ TotalCustomersASdecimal(6,4))AS CustomerPercentile
FROM ranked
ORDERBY RevenueRank;

--- Top 10% ---

USE RetailAnalyticsDW;
GO

WITH customer_revenueAS (
SELECT
        CustomerKey,
SUM(NetSalesAmount)AS TotalRevenue
FROM dbo.FactSales
GROUPBY CustomerKey
),
rankedAS (
SELECT
        CustomerKey,
        TotalRevenue,
NTILE(10)OVER (ORDERBY TotalRevenueDESC)AS RevenueDecile
FROM customer_revenue
)
SELECT
    RevenueDecile,
COUNT(*)AS Customers,
SUM(TotalRevenue)AS Revenue
FROM ranked
GROUPBY RevenueDecile
ORDERBY RevenueDecile;


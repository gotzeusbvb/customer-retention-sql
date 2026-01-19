-- 02 Purchase Frequency Segmentation
-- Segments customers into frequency quartiles using active months
-- Technique: NTILE window function
-- Database: RetailAnalyticsDW

USE RetailAnalyticsDW;
GO

WITH customer_monthsAS (
SELECT
        CustomerKey,
COUNT(DISTINCT DATEFROMPARTS(
LEFT(CONVERT(varchar(8), DateKey),4),
SUBSTRING(CONVERT(varchar(8), DateKey),5,2),
1
        ))AS ActiveMonths
FROM dbo.FactSales
GROUPBY CustomerKey
),
segmentedAS (
SELECT
        CustomerKey,
        ActiveMonths,
NTILE(4)OVER (ORDERBY ActiveMonths)AS FrequencyQuartile
FROM customer_months
)
SELECT
CASE FrequencyQuartile
WHEN1THEN'Q1 (Lowest frequency)'
WHEN2THEN'Q2'
WHEN3THEN'Q3'
WHEN4THEN'Q4 (Highest frequency)'
ENDAS FrequencySegment,
COUNT(*)AS Customers,
MIN(ActiveMonths)AS MinActiveMonths,
MAX(ActiveMonths)AS MaxActiveMonths,
AVG(1.0* ActiveMonths)AS AvgActiveMonths
FROM segmented
GROUPBY FrequencyQuartile
ORDERBY FrequencyQuartile;


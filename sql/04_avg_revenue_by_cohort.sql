-- 04 Average Revenue per Customer by Cohort
-- Calculates average customer value by acquisition cohort
-- Database: RetailAnalyticsDW

USE RetailAnalyticsDW;
GO

WITH customer_cohortAS (
SELECT
        dc.CustomerKey,
        DATEFROMPARTS(YEAR(dc.FirstPurchaseDate),MONTH(dc.FirstPurchaseDate),1)AS CohortMonth
FROM dbo.DimCustomer dc
WHERE dc.FirstPurchaseDateISNOT NULL
),
customer_revenueAS (
SELECT
        fs.CustomerKey,
SUM(fs.NetSalesAmount)AS TotalRevenue
FROM dbo.FactSales fs
GROUPBY fs.CustomerKey
),
cohort_rollupAS (
SELECT
        cc.CohortMonth,
COUNT(DISTINCT cc.CustomerKey)AS CohortCustomers,
SUM(cr.TotalRevenue)AS CohortRevenue
FROM customer_cohort cc
JOIN customer_revenue cr
ON cr.CustomerKey= cc.CustomerKey
GROUPBY cc.CohortMonth
)
SELECT
    CohortMonth,
    CohortCustomers,
    CohortRevenue,
CAST(1.0* CohortRevenue/NULLIF(CohortCustomers,0)ASdecimal(12,2))AS AvgRevenuePerCustomer
FROM cohort_rollup
ORDERBY CohortMonth;

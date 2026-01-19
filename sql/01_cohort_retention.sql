-- 01 Cohort Retention Analysis
-- Measures customer retention by lifecycle month
-- Database: RetailAnalyticsDW

WITH ordersAS (
SELECTDISTINCT
        fs.CustomerKey,
        fs.OrderID,
CONVERT(date,CONVERT(varchar(8), fs.DateKey))AS OrderDate
FROM FactSales fs
),
customer_cohortAS (
SELECT
        dc.CustomerKey,
        DATEFROMPARTS(YEAR(dc.FirstPurchaseDate),MONTH(dc.FirstPurchaseDate),1)AS CohortMonth
FROM DimCustomer dc
WHERE dc.FirstPurchaseDateISNOT NULL
),
activityAS (
SELECT
        o.CustomerKey,
        DATEFROMPARTS(YEAR(o.OrderDate),MONTH(o.OrderDate),1)AS ActivityMonth
FROM orders o
),
cohort_activityAS (
SELECT
        cc.CohortMonth,
        a.ActivityMonth,
        DATEDIFF(MONTH, cc.CohortMonth, a.ActivityMonth)AS MonthNumber,
        a.CustomerKey
FROM customer_cohort cc
JOIN activity a
ON a.CustomerKey= cc.CustomerKey
WHERE a.ActivityMonth>= cc.CohortMonth
)
SELECT
    CohortMonth,
    MonthNumber,
COUNT(DISTINCT CustomerKey)AS ActiveCustomers
FROM cohort_activity
GROUPBY CohortMonth, MonthNumber
ORDERBY CohortMonth, MonthNumber;

--- Retention % ---

USE RetailAnalyticsDW;
GO

WITH ordersAS (
SELECTDISTINCT
        fs.CustomerKey,
        fs.OrderID,
CONVERT(date,CONVERT(varchar(8), fs.DateKey))AS OrderDate
FROM dbo.FactSales fs
),
customer_cohortAS (
SELECT
        dc.CustomerKey,
        DATEFROMPARTS(YEAR(dc.FirstPurchaseDate),MONTH(dc.FirstPurchaseDate),1)AS CohortMonth
FROM dbo.DimCustomer dc
WHERE dc.FirstPurchaseDateISNOT NULL
),
cohort_sizesAS (
SELECT
        CohortMonth,
COUNT(DISTINCT CustomerKey)AS CohortCustomers
FROM customer_cohort
GROUPBY CohortMonth
),
activityAS (
SELECT
        o.CustomerKey,
        DATEFROMPARTS(YEAR(o.OrderDate),MONTH(o.OrderDate),1)AS ActivityMonth
FROM orders o
),
cohort_activityAS (
SELECT
        cc.CohortMonth,
        a.ActivityMonth,
        DATEDIFF(MONTH, cc.CohortMonth, a.ActivityMonth)AS MonthNumber,
        a.CustomerKey
FROM customer_cohort cc
JOIN activity a
ON a.CustomerKey= cc.CustomerKey
WHERE a.ActivityMonth>= cc.CohortMonth
),
retention_countsAS (
SELECT
        CohortMonth,
        MonthNumber,
COUNT(DISTINCT CustomerKey)AS ActiveCustomers
FROM cohort_activity
GROUPBY CohortMonth, MonthNumber
)
SELECT
    rc.CohortMonth,
    rc.MonthNumber,
    rc.ActiveCustomers,
    cs.CohortCustomers,
CAST(1.0* rc.ActiveCustomers/NULLIF(cs.CohortCustomers,0)ASdecimal(6,4))AS RetentionRate
FROM retention_counts rc
JOIN cohort_sizes cs
ON cs.CohortMonth= rc.CohortMonth
ORDERBY rc.CohortMonth, rc.MonthNumber;



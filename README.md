# Customer Retention & Revenue Analysis (SQL)

## Project Overview

This project analyzes **customer retention, purchasing behavior, and revenue distribution** using advanced SQL techniques.

The goal is to answer **business-critical questions about customer value** without relying on dashboards or BI tools, focusing purely on SQL-driven analytics.

The analysis reuses a retail data warehouse (`RetailAnalyticsDW`) previously built for a BI project, demonstrating the ability to **extend and reuse an existing data model**.

---

## Business Questions Answered

- How well do customers retain over time after their first purchase?
- How does purchasing frequency relate to revenue generation?
- Is revenue concentrated among a small subset of customers?
- Does customer value differ by acquisition cohort?

---

## Data Model

### Tables Used

**DimCustomer**
- `CustomerKey`
- `FirstPurchaseDate`
- Customer attributes (segment, geography)

**FactSales**
- `CustomerKey`
- `OrderID`
- `DateKey` (YYYYMMDD)
- `NetSalesAmount`

All revenue metrics are based on **NetSalesAmount**.

---

## Analytical Approach

### 1️ Customer Cohort Retention
- Customers grouped by **first purchase month**
- Retention measured across lifecycle months
- Retention percentages calculated per cohort

**Techniques:** CTEs, date logic, aggregations

---

### 2️ Purchase Frequency Segmentation
- Customers segmented into **quartiles** based on number of active months
- Frequency segments compared by revenue contribution

**Techniques:** `NTILE`, window functions

---

### 3 Revenue Concentration (Pareto Analysis)
- Customers ranked by total revenue
- Revenue deciles calculated
- Top 10% revenue contribution analyzed

**Techniques:** `RANK`, `NTILE`, aggregations

---

### 4 Average Revenue per Customer by Cohort
- Revenue aggregated by acquisition cohort
- Average revenue per customer calculated
- Customer value compared across cohorts

---

## Key Insights

- Customer retention is strong across lifecycle months
- Higher purchase frequency correlates with higher revenue
- Revenue is evenly distributed (no extreme whale dependency)
- Average customer value is stable across acquisition cohorts

---

## SQL Techniques 

- Common Table Expressions (CTEs)
- Window functions (`NTILE`, `RANK`)
- Cohort analysis
- Behavioral segmentation
- Revenue aggregation

---

## Repository Structure

```text
sql/
├── 01_cohort_retention.sql
├── 02_frequency_segmentation.sql
├── 03_revenue_concentration.sql
└── 04_avg_revenue_by_cohort.sql

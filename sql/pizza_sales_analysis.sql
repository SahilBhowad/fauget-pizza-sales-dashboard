-- =========================================================================
-- Pizza Sales Analysis 2015: SQL
-- =========================================================================
-- Author : Sahil Bhowad
-- Tool : SQL Server (SSMS)
-- Table : pizza_sales (48,620 order lines, from the original source CSV)
-- Purpose :
--	1. Validate the Excel dashboard: recompute the KPI cards and chart
--  numbers in SQL and confirm they match.
--	2. Check every finding on the Insights sheet with a query.
-- =========================================================================

-- Create Database
CREATE DATABASE pizza_sales_2015 ;

USE pizza_sales_2015 ;

-- NOTE: The table pizza_sales was created with the SSMS Import Flat File wizard
-- from the original source CSV (no Excel edits), so SQL is an independent check.

-- View the entire data
SELECT * FROM pizza_sales ;


-- Questions:-

-- -------------------------------------------------------------------------
-- Q1. How many order lines (rows) are in the data ?
-- -------------------------------------------------------------------------

SELECT COUNT(*) AS total_orders 
FROM pizza_sales 
;

-- Insight: There are 48620 rows (order lines) in the dataset, matching the Excel Data sheet.


-- -------------------------------------------------------------------------
-- Q2. What are the headline numbers (dashboard KPI cards)?
-- -------------------------------------------------------------------------
SELECT 
	ROUND(SUM(total_price),0) AS total_revenue,
	COUNT(DISTINCT order_id) AS total_orders,
	SUM(CAST(quantity AS INT)) AS pizzas_sold,
	ROUND(SUM(total_price) / COUNT(DISTINCT order_id),2) AS avg_order_value,
	ROUND(SUM(CAST(quantity AS FLOAT)) / COUNT(DISTINCT order_id),2) AS pizzas_per_order
FROM pizza_sales
;

-- Insight: Revenue is $817,860 from 21,350 orders and 49,574 pizzas. Average order value is $38.31
-- with 2.32 pizzas per order.


-- -------------------------------------------------------------------------
-- Q3. How does revenue change by month?
-- -------------------------------------------------------------------------

SELECT
	DATENAME(MONTH,CONVERT(DATE,order_date,105)) AS month_name,
	ROUND(SUM(total_price), 0) AS total_revenue
FROM pizza_sales
GROUP BY
	DATENAME(MONTH,CONVERT(DATE,order_date,105)),
	MONTH(CONVERT(DATE,order_date,105))
ORDER BY
	MONTH(CONVERT(DATE,order_date,105))
;

-- Insight: Revenue is almost the same every month. This supports the "Steady all year" finding.


-- -------------------------------------------------------------------------
-- Q4. Which weekday earns the most revenue?
-- -------------------------------------------------------------------------

SELECT
	DATENAME(WEEKDAY,CONVERT(DATE,order_date,105)) AS day_name,
	ROUND(SUM(total_price), 0) AS total_revenue
FROM pizza_sales
GROUP BY
	DATENAME(WEEKDAY,CONVERT(DATE,order_date,105)),
	DATEPART(WEEKDAY,CONVERT(DATE,order_date,105))
ORDER BY
	total_revenue DESC
;

-- Insight: Friday ranks 1st with $136074 ; the slowest day is Sunday with $99203.


-- -------------------------------------------------------------------------
-- Q5. Which hours of the day are the busiest?
-- -------------------------------------------------------------------------

SELECT
	DATEPART(HOUR,order_time) AS hour_of_day ,
	ROUND(SUM(total_price),0) AS total_revenue
FROM pizza_sales
GROUP BY
	DATEPART(HOUR,order_time)
ORDER BY
	hour_of_day ASC
;

-- Insight: Revenue peaks at 12 (12 PM) and 18 (6 PM) with $111878 and $89297.
-- Hours before 11 AM and after 9 PM are the quietest.


-- -------------------------------------------------------------------------
-- Q6. What share of revenue comes from each pizza size?
-- -------------------------------------------------------------------------

SELECT
	pizza_size,
	ROUND(SUM(total_price),0) AS total_revenue,
	ROUND(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales),0) AS pct_share
FROM pizza_sales
GROUP BY pizza_size
ORDER BY 
	total_revenue DESC
;

-- Insight: Large (L) leads with 46% of revenue ($375319), followed by Medium (M) at 30%.


-- -------------------------------------------------------------------------
-- Q7. What share of revenue comes from each pizza category?
-- -------------------------------------------------------------------------

SELECT
	pizza_category,
	ROUND(SUM(total_price),0) AS total_revenue,
	ROUND(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales),0) AS pct_share
FROM pizza_sales
GROUP BY pizza_category
ORDER BY total_revenue DESC
;


-- Insights:- Classic leads with about 27% of revenue ($220,053), followed by Supreme (25%),
-- Chicken (24%) and Veggie (24%). No single category dominates.


-- -------------------------------------------------------------------------
-- Q8. Which 5 pizzas earn the most revenue
-- -------------------------------------------------------------------------

SELECT TOP 5
	pizza_name,
	ROUND(SUM(total_price),0) AS total_revenue
FROM pizza_sales
GROUP BY
	pizza_name
ORDER BY
	total_revenue DESC
;


-- Insight: The Thai Chicken Pizza leads at about $43k, followed by The Barbecue Chicken Pizza ($43k).


-- -------------------------------------------------------------------------
-- Q9. Which 5 pizzas earn the least revenue?
-- -------------------------------------------------------------------------

SELECT TOP 5
	pizza_name,
	ROUND(SUM(total_price),0) AS total_revenue
FROM pizza_sales
GROUP BY
	pizza_name
ORDER BY
	total_revenue ASC
;


-- Insight: The Brie Carre Pizza is lowest at about $12k, so the bottom 5 sit between $12k and $16k.

-- -------------------------------------------------------------------------
-- Q10. Does the data pass the same quality checks as the Validation sheet?
-- -------------------------------------------------------------------------

SELECT
	COUNT(*) AS row_count,
	SUM(CASE 
			WHEN pizza_id IS NULL 
			  OR order_id IS NULL 
			  OR pizza_name_id IS NULL 
			  OR quantity IS NULL 
			  OR order_date IS NULL 
			  OR order_time IS NULL 
			  OR unit_price IS NULL 
			  OR total_price IS NULL 
			  OR pizza_size IS NULL 
			  OR pizza_category IS NULL 
			  OR pizza_ingredients IS NULL 
			  OR pizza_name IS NULL 
			THEN 1 
		ELSE 0 END) AS total_rows_with_any_null,
	COUNT(*) - COUNT(DISTINCT pizza_id) AS duplicate_pizza_ids,
	SUM(CASE WHEN quantity < 1 THEN 1 ELSE 0 END) AS quantity_below_1,
	SUM(CASE WHEN unit_price <=0 THEN 1 ELSE 0 END) AS price_zero_or_less
FROM pizza_sales
;

-- Insight: 48620 rows, with 0 blanks, 0 duplicate pizza_id, 0 rows with quantity below 1 and
-- 0 rows with unit_price of 0 or less. SQL and the Excel Validation sheet agree.
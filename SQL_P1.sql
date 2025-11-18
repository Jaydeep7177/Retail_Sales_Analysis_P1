-- SQL Retail Sales Analysis - P1
--======================================================================
-- CREATE Table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
	(
		transactions_id INT PRIMARY KEY,
		sale_date DATE,
		sale_time TIME,
		customer_id INT,
		gender VARCHAR(15),
		age INT,
		category VARCHAR(15),
		quantity INT,
		price_per_unit FLOAT,
		cogs FLOAT,
		total_sale FLOAT
	);

SELECT * FROM retail_sales

SELECT COUNT(*)
FROM retail_sales

--======================================================================
-- Data Cleaning
-- Removing the NULL values from the data.
SELECT * 
FROM retail_sales
WHERE 	
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR 
	customer_id IS NULL
	OR 
	gender IS NULL
	OR 
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR 
	total_sale IS NULL;

--after running above query we got three rows havings transactions_id(679,746, 1225) with null values in
-- quantity, price_per_unit, cogs, total_sale columns.

--======================================================================
-- Delete Null records
DELETE FROM retail_sales
WHERE transactions_id IN (679,746,1225)


--======================================================================
--Data Exploration

-- How many transactions we have?
SELECT
	COUNT(*) AS total_transactions
FROM retail_sales	


-- How many unique customers we have?
SELECT
	COUNT(DISTINCT customer_id) AS total_customers
FROM retail_sales	

-- How many categories we have?
SELECT DISTINCT
	category AS all_categories
FROM retail_sales


--======================================================================
/*
-- Data Analysis & Business Key Problems & Answers
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in
	the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <= 12, Afternoon Between 12 & 17, Evening >17)
*/


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT
	*
FROM retail_sales
WHERE sale_date = '2022-11-05'


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in
--	the month of Nov-2022
SELECT
	*
FROM retail_sales
WHERE category = 'Clothing' 
	AND quantity >= 4
	AND sale_date BETWEEN '2022-11-01' AND '2022-11-30'
	-- TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT
	category,
	SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
	ROUND(AVG(age),1) average_age
FROM retail_sales
WHERE category = 'Beauty'



-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT
	*
FROM retail_sales	
WHERE total_sale > 1000


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT
	gender,
	category,
	COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY 1,2
ORDER BY 1,2


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT 
	*
FROM (
	SELECT 
		EXTRACT(YEAR FROM sale_date) AS year,
		EXTRACT(MONTH FROM sale_date) AS month,
		ROUND(AVG(total_sale)::numeric, 2) AS avg_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY ROUND(AVG(total_sale)::numeric, 2) DESC) AS rank
	FROM retail_sales	
	GROUP BY 1,2
) AS t1
WHERE rank = 1


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
SELECT 
	customer_id,
	SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5



-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
WITH total_transactions AS 
(
	SELECT
		customer_id,
		category,
		COUNT(*) AS total_transaction
	FROM retail_sales	
	GROUP BY customer_id, category
	ORDER BY customer_id, category
), unique_customers AS 
(
	SELECT
		customer_id,
		COUNT(customer_id) AS category_count
	FROM total_transactions
	GROUP BY customer_id
)

SELECT 
	COUNT(*) total_unique_customers
FROM unique_customers
WHERE category_count = 3



-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <= 12, Afternoon Between 12 & 17, Evening >17)
SELECT
	shift,
	COUNT(*) AS total_orders
FROM (	
	SELECT
		*,
		CASE
			WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
			WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END AS shift	
	FROM retail_sales
) AS shift_seg
GROUP BY shift











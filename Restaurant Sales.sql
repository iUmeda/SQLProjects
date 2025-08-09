
-- Title: Restaurants Sales Data
-- Source: https://www.kaggle.com/datasets/rohitgrewal/restaurant-sales-data

-- I cleaned the data before running the SQL queries. Please check the steps to clean data below after the queries. 

-- Let's analyze the data (after it was cleaned) and answer some questions a manager may ask:

-- However, before running a script it is important to pull the entire table get familiar with data / various columns: 

SELECT *
FROM `restaurant sales`;


-- creating a temp column 'revenue'

SELECT
`Order ID`, 
Quantity,
Price,
(Quantity * Price) AS revenue
FROM `restaurant sales`;

-- Revenue result was 0.

-- Getting rid of $ sign (it may be causing an error):

UPDATE `restaurant sales`
SET Price = replace (REPLACE(Price, '$', ""), ',', '');

-- ran the query again to create a new column: 

SELECT
`Order ID`, 
Quantity,
Price,
(Quantity * Price) AS revenue
FROM `restaurant sales`;

-- Decimal numbers are too long. Rounding it to the hundredth place:

SELECT `Order ID`,
Quantity, 
Price, 
ROUND(Quantity*Price, 1) AS revenue
FROM `restaurant sales`;

-- 1. Pulling total revenue for the month of November:

SELECT `Order ID`,
sum(Quantity*Price) AS total_revenue
FROM `restaurant sales`
WHERE month(Date) = 11
GROUP BY `Order ID`
ORDER BY total_revenue DESC
Limit 1;

-- result: empty cells. Why? Let's make sure there is a value for November

SELECT count(*)
FROM `restaurant sales`
WHERE month(Date) = 11;
-- answer: 0 rows returned. The reason for that is the date is saved as MM/DD/YYYY, therefore, the query above would not work. 

-- let's try a different way:

SELECT 
`Order ID`,
Product,
sum(Quantity*Price) AS total_revenue
FROM `restaurant sales`
WHERE MONTH (str_to_date(Date, '%m/%d/%Y')) = 11
GROUP BY `Order ID`,Product
ORDER BY total_revenue DESC
Limit 1;

-- It worked. The query pulled the data for the month of November. 
-- Fries brought in the highest revenue for the month of November with total revenue of $16,065

-- 2. Let's find out what city sold the most beverages:

SELECT City,
SUM(Quantity) AS total_beverage_sold
FROM `restaurant sales`
WHERE Product = 'Beverages'
GROUP BY city
ORDER BY total_beverage_sold DESC
LIMIT 1;

-- Most beverages were sold in Lisbon.

-- 3. Let's find out what amount of revenue that was generated from gift card:

SELECT
`Payment Method`,
	ROUND (sum(Quantity*Price), 2) AS total_revenue
    FROM `restaurant sales`
    WHERE `Payment Method` = 'Gift Card';
    
-- Gift cards generated $168,569 revenue


-- 4. What purchase method was most effective?

SELECT 
	`Purchase Type`, 
    round(sum(Quantity*Price), 2) AS total_revenue
FROM `restaurant sales`
GROUP BY `Purchase Type`
ORDER BY total_revenue DESC
LIMIT 1;

-- Online was the most effective purchase method 
-- It generated $305,133.43 in revenue. 


-- 5. What manager had the most / least amount of revenue?

SELECT
Manager, 
round(SUM(Quantity*Price), 2) AS total_revenue
FROM `restaurant sales`
GROUP BY Manager
ORDER BY total_revenue DESC
Limit 1;

-- manager with most revenue is Joao Silva with $241,635.49 in total

SELECT
Manager, 
round(SUM(Quantity*Price), 2) AS total_revenue
FROM `restaurant sales`
GROUP BY Manager
ORDER BY total_revenue
Limit 1;
-- Manager with the least revenue is Remy Monet with $79,777.33 in total. 


-- 6. What product is the most /least expensive:

SELECT 
	Product, 
    Price
FROM `restaurant sales`
ORDER BY Price DESC
Limit 1;

-- It keeps giving me product: 'chicken sandwiches' at the price of 9.95. That answer is incorrect. It should be 
-- 'chicken sandwiches' at $29.05. I think there may be a data type discrepancy. 

SELECT Product,
	max(CAST(REPLACE(REPLACE(trim(Price), '$', ''), ',', '') AS DECIMAL (10,2))) AS max_unit_price
FROM `restaurant sales`
GROUP BY Product
ORDER BY max_unit_price DESC
Limit 1;

-- Now I am getting a correct answer. The priciest item on the menu is 'chicken sandwiches' at $29.05


SELECT Product,
	max(CAST(REPLACE(REPLACE(trim(Price), '$', ''), ',', '') AS DECIMAL (10,2))) AS max_unit_price
FROM `restaurant sales`
GROUP BY Product
ORDER BY max_unit_price
Limit 1;
-- the least expensive item on the menu is 'beverages' at $2.95



-- I 'sliced and diced' the data in various ways to answer questions any restaurant manager may ask. 
-- I believe the most important part of analyzing something is being familiar with data. 
-- Familiarity should help interpret the data and deliver accurate analysis to the decision-makers. 

-- Below I included the steps to clean the data before upload it into MySQL:

-- Restaurants Sales Data:

-- https://www.kaggle.com/datasets/rohitgrewal/restaurant-sales-data

-- The file is a CSV file with 9 columns

-- Checking data for errors and inconsistencies before exporting it:

-- The date column has an inconsistent format so I couldn't just change the data type by just right clicking. 
-- I ran 'Text to columns' twice -- once for dates with '-', and again with '/'. 
-- Then, after splitting one column into three I used the formula =date(F2, E2, D2)   for date (year, month, date). Dragged it down. 
-- Removed the formula. Removed date / month / year columns (the three newly created columns after 'text_to_column'.) 

-- Column "manager" has misaligned text. To avoid extra space in "manager" column and all the other hidden spaces in the rest of the table 
-- I ran a "trim" formula on the entire table. 

-- Converted digits to numbers, dates, and currency (in hindside, I should not have added $ in the Price column). 
-- Removed decimals from the quantity column.

-- No other errors were noticed. The file is ready to be analyzed. 



-- Capstone 1: Sales Territory Analysis
-- Territory: Maryland(In-Store), Northeast Region
-- Author: Ephrata Mulugeta
-- To Shruti Reddy(Sales manager)
USE sample_sales;
-- shows the list of all states that have stores
SELECT DISTINCT state
FROM store_locations;
-- shows us the store locations in maryland
SELECT *
FROM store_locations
WHERE State = 'Maryland';
-- this shows us how we join the 2 tables and their relationship(Store_ID=Storeid)
SELECT *
FROM store_sales S
JOIN store_locations L
ON S.Store_ID = L.StoreId
WHERE L.State = 'Maryland'
LIMIT 10;
-- Q1: what is the total revenue overall sales,plus the start date and end date that tell you what period the data covers?
SELECT SUM(sale_amount) AS total_revenue,
DATE_FORMAT(MIN(Transaction_date), '%Y-%M-%D') AS start_date,
DATE_FORMAT(MAX(Transaction_date), '%Y-%M-%D') AS end_date
FROM store_sales S
JOIN store_locations L
ON S.Store_ID = L.StoreId
WHERE State = 'Maryland';
-- Q2 what is the revenue breakdown by year and month for the sales territory?
-- findings: I found 48 rows,First row: 2022,1,190064.90,Last row: 2025,12,332129.99 that means   -- Findings: Revenue grew every year
SELECT YEAR(Transaction_date) AS sales_year,
MONTH(Transaction_date) AS sales_month,
SUM(Sale_amount) AS monthly_revenue
FROM store_sales S
JOIN store_locations L
ON S.Store_ID = L.StoreId
WHERE State = 'Maryland'
GROUP BY 1,2
ORDER BY 1,2;
--  Q3 Provide a comparision of total revenue for the specific sales territory and the region it belongs to(Maryland revenue to Northeast region)
-- First find the region's states and the management table shows which region each state is
SELECT *
FROM management
WHERE Region = 'Northeast';
-- region total--- which is 24237526.98
SELECT SUM(Sale_Amount) AS region_revenue
FROM store_sales S
JOIN store_locations L ON S.Store_ID = L.StoreId
JOIN management M ON L.State = M.State
WHERE region = 'Northeast';
-- Put both in one result by using UNION
SELECT 'Maryland' AS area, SUM(S.Sale_Amount) AS total_revenue
FROM store_sales S
JOIN store_locations L ON S.Store_ID = L.StoreId
WHERE L.State = 'Maryland'

UNION

SELECT 'Northeast' AS area, SUM(S.Sale_Amount) AS total_revenue
FROM store_sales S
JOIN store_locations L ON S.Store_ID = L.StoreId
JOIN management M      ON L.State = M.State
WHERE M.Region = 'Northeast';
-- Finding Maryland earns about 47% of Northeast's revenue with only 9 stores(18%)

-- Q4 Transaction per month and average transaction amount by product category
 SELECT Category ,
 COUNT(*) AS num_transactions,
 ROUND(AVG(S.Sale_Amount), 2) AS avg_transaction
FROM store_sales S
JOIN store_locations L       ON S.Store_ID = L.StoreId
JOIN products P              ON S.Prod_Num = P.ProdNum
JOIN inventory_categories C  ON P.Categoryid = C.Categoryid
WHERE L.State = 'Maryland'
GROUP BY 1
ORDER BY 2 DESC;
-- Findings: it shows Technology & accessories has the most transactions(16836)and the highest avg(464.89)
-- Textbooks have fewest transaction(11639) but 2nd highest avg(173.66)
-- Stationary is very busy(16655) but each sale is small(avg 10.45)
-- Q4(by month): transactions and average amount per category, per month
SELECT  EXTRACT(YEAR FROM S.Transaction_Date)  AS sales_year,
 EXTRACT(MONTH FROM S.Transaction_Date) AS sales_month,
 Category,
 COUNT(*)                     AS num_transactions,
ROUND(AVG(S.Sale_Amount), 2) AS avg_transaction
FROM store_sales S
JOIN store_locations L       ON S.Store_ID = L.StoreId
JOIN products P              ON S.Prod_Num = P.ProdNum
JOIN inventory_categories C  ON P.Categoryid = C.Categoryid
WHERE L.State = 'Maryland'
GROUP BY 1, 2, 3
ORDER BY 1, 2, 3;


-- Q5 Ranking of in-store sales performance by store in Maryland

SELECT SUM(sale_Amount) AS store_revenue ,storelocation , Store_ID
FROM store_sales S
JOIN store_locations L ON S.Store_ID = L.StoreId
WHERE State = 'Maryland'
GROUP BY 2,3
ORDER BY 1 DESC ;
-- Finding: North Harford is the top store with $8.7M(about76% of Maryland revenue,8.71M/$11.45M)
-- Germantown is the 2nd (about$585k);the other 7 stores are each about $290k-$320k

-- Q6 Recommendation for the next quarter
-- My recommendation is to keep North Harford strong by protecting its technology sales since most revenue is  from technology and accessories
-- and identify why its growing rate is low and try to improve that( In 2025 North Harford grew only about 8%, while the other 8 stores grew about 65% combined.)
-- Put more sales attention on the growing smaller stores too , like Germantown because growing them will reduce the risk of relying on one store
-- Look into why textbook sales are falling each year( from 3254 in 2022 to 2419 in 2025)

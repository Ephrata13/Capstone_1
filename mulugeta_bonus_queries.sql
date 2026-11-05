-- Capstone 1: Bonus Queries
-- Author: Ephrata Mulugeta
USE sample_sales;

-- Bonus 1: Create a list  of all transactions that took place on Jan 15, 2024,
-- sorted by sale amount from highest to lowest.
SELECT *
FROM store_sales
WHERE Transaction_Date = '2024-01-15'
ORDER BY Sale_Amount DESC; 
-- Findngs: There were 223 transactions. the largest sale was $1317.70(store 810, product 105336-IT)and the samllest was $2.40

-- Bonus 2: Which transactions had a sale amount greater than $500? Display the transaction date, store ID, product number, and sale amount
SELECT Transaction_Date, Store_ID, Prod_Num, Sale_Amount
FROM store_sales
WHERE Sale_Amount > 500;
-- Finding: the tool onlys shows 1000 rows if we want to check there is more we can use count as below

SELECT COUNT(*) AS num_over_500
FROM store_sales
WHERE Sale_Amount > 500;
-- Finding: 23,243 transactions were over $500 and most of them are technology products(product numbers ending in -IT)

-- Bonus 4: What is the total sales revenue across all transactions? what is the average transaction amount?
SELECT SUM(sale_Amount) AS total_revenue, avg(sale_Amount) AS avg_transaction
FROM store_sales;
-- Finding: total instore revenue is $ 45,370,048.85(about $45.4M)
-- The average transaction amount is $135.38
-- Maryland revenue is about 25% of the whole company's in store ($11.45M/$45.37M= 0.25)

-- Bonus 7: What is the total revenue for each category, sorted from highest to lowest?
SELECT SUM(sale_Amount) AS total_revenue, category
FROM store_sales S
JOIN products P
ON S.Prod_Num = P.ProdNum
JOIN inventory_categories C ON P.Categoryid = C.categoryid
GROUP BY 2
ORDER BY 1 DESC;
-- Finding: There are 6 categories. Technology & Accessories has the highest revenue
-- (about $31.9M, about 70% of all in-store revenue), and Stationery has the lowest(about $0.7M), Textbooks are 2nd($8M)
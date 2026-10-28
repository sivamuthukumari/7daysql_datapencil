USE datapencil_store;


--- DAY 2 DATA PENCIL SQL 7 DAY FREE CLASS

--- MINI PROJECT 

--- PROJECT: ORDER PERFORMANCE AND BUSINESS INSIGHTS 

--1. COUNT THE NUMBER ORDERS 

  SELECT COUNT(*) as Total_Orders
  FROM orders;

--2. COUNT HOW MANY ORDERS   EXITS FOR  ORDER STATUS 

SELECT
status, COUNT(*) as Total_Orders 
FROM orders
group by status  ;

-- 3.10 MOST RECENT ORDERS 

SELECT top 10 order_id,order_date
FROM orders
order by order_date desc ;

--4. FIND 10 HIGHEST VALUE ORDER 

SELECT  TOP 10 
order_id,
SUM(quantity*unit_price) as total_amount  
FROM order_items 
GROUP BY order_id 
ORDER BY sum(quantity*unit_price) desc



--5.COUNT ORDERS PLACED FOR DAY IN CHRONOLOGICAL

SELECT  
order_date  ,
COUNT(*) as total_order_Byday
FROM orders
GROUP BY order_date  
ORDER BY order_date asc

-- 6. COUNT MONTH ORDER TREND 

SELECT 
MONTH(order_date) as month ,
COUNT(*) as order_count_byMonth
FROM orders
GROUP BY month(order_date)  
ORDER BY month(order_date)  asc 

--7.AVARAGE ORDER VALUE 

SELECT
ROUND(AVG(total_amount),2)  as avarage_value 
FROM (
			SELECT 
			order_id,
			SUM(quantity*unit_price) as total_amount 
			FROM order_items
			GROUP BY order_id ) as t


--- 8. RANK THE TOP 10 CUSTOMER BY ORDER COUNT 
SELECT 
ROW_NUMBER() OVER( ORDER BY  count_ofCustomers) as RANK,
t.customer_id
FROM(
		SELECT TOP 10 customer_id , 
		COUNT(order_id) as count_ofCustomers
		FROM orders
		GROUP BY customer_id
		ORDER BY  count(order_id) desc
) t 


/*
## Key Insights – Day 2 SQL Mini Project
1. **Total Orders:** The store recorded a total of 3,000 orders, providing an overview of the overall order volume during the analysis period.

2. **Order Status Analysis:** Delivered orders are the highest at 1,796, accounting for approximately 59.9% of the 3,000 total orders. Meanwhile, 280 orders were returned and 236 were cancelled.
     (I) **Order Status Distribution:** The business has 385 shipped orders and 303 processing orders, in addition to delivered, returned, and cancelled orders. Monitoring orders still in progress can help improve fulfilment efficiency.

3. **Recent Order Activity:** The results show orders dated September 29 and September 30, 2026. Tracking recent order activity can help monitor current sales trends and operational performance.

4. **Order Value Analysis:** The highest order totals shown in the results include 62,489.96, 62,409.52, and 59,828.72. These orders represent the highest-value transactions in the displayed output.

5. **Daily Order Trends:** Daily order volume fluctuates, with some days recording higher order counts than others, indicating variations in customer purchasing activity.

6. **Monthly Order Trends:** August recorded the highest number of orders at 300,  November has lowest only 130 orders .

7. **Average Order Value:** The average value shown in the query result is approximately 20,886.06. This indicates the average order value if the query calculates the average total amount per order.

8. **Top Customers:** Customer IDs 344, 244, and 736 appear in the top three positions in the displayed ranking result. These customers are the leading customers according to the ranking metric used in the query.

*/


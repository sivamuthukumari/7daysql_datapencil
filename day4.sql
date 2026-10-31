use datapencil_store

select * from customers


-- PROJECT 4

       -- BUSINESS SCENARIO AND CUSTOMER LOYALTY
       
-- 1 TOTAL CUSTOMERS

SELECT 
    COUNT(*) as total_customers  
FROM customers

-- 2. COUNT THE CUSTOMERS BY CITY 
--- GENARATE THE TOP 5 CITY

SELECT TOP 5
    city,
    count(*) as total_customer
FROM customers 
GROUP BY city
ORDER BY total_customer DESC 

-- 3.TOP 10 CUSTOMER BY  ORDER COUNT OF NON-CANCELLED ORDERS

SELECT TOP 10 
customer_id,
COUNT(order_id) as order_count
FROM orders
WHERE status<> 'cancelled'
GROUP BY customer_id
ORDER BY order_count DESC

--4. CALCULATE THE TOTAL SPENDING AMOUNT OF EACH CUSTOMER

          SELECT 
            o.customer_id,
            sum(oi.quantity*oi.unit_price)  as spendamount
            from orders as o 
             join order_items  as oi
            on oi.order_id=o.order_id
            WHERE status <> 'cancelled' 
            GROUP BY o.customer_iD
            ORDER BY spendamount desc


SELECT 
    o.customer_id ,
    SUM(oi.price) customer_price
    FROM orders as o 
      left join (
            SELECT o.order_id,
            sum(oi.quantity*oi.unit_price) as price 
            from order_items as oi 
            left join orders  as o
            on oi.order_id=o.order_id
            WHERE status <> 'cancelled' 
            GROUP BY o.order_id
             ) as oi
on o.order_id=oi.order_id
GROUP BY  o.customer_id 
ORDER BY customer_id

--5.AVRAGE SPENDING THE CUSTOMER

SELECT 
avg(isnull(t.price,0)) AS  AVARAGE_PRICE
from 
( SELECT 
            c.customer_id,s.spendprice as price
            from customers as c 
            left join(
            select o.customer_id,sum(oi.quantity*oi.unit_price) as spendprice
            from orders as o
             left join order_items  as oi
            on oi.order_id=o.order_id
            WHERE status <> 'cancelled' 
            GROUP BY o.customer_id
            ) as s 
            on c.customer_id=s.customer_id
     ) as t




--6. FIND THE CUSTOMER PLACED MORE THEN FIVE ORDERS

SELECT 
    customer_id,
    COUNT(order_id) as order_count
FROM orders
where status<>'cancelled'
GROUP BY customer_id
having  COUNT(order_id) > 5 
ORDER BY order_count 

--7. COUNT THE CUSTOMER BY SEGMENT

SELECT 
    segment,
    COUNT(*) customer_count 
from customers
GROUP BY segment
ORDER BY customer_count desc ;

-- 8 AVARAGE ORDER PER CUSTOMER

SELECT 
avg(cast( isnull(t.order_count,0) as decimal(10,4)))
 from(
select c.customer_id,o.order_count from customers as c 
left join (
select 
customer_id,
COUNT(order_id) as order_count
FROM orders
WHERE status<> 'cancelled'
GROUP BY customer_id
) as o
on c.customer_id=o.customer_id
) as t 



-- 9.TOP 10 CUSTOMERS GENERATE HIGHEST SPENDING VALUE
SELECT TOP 10
o.customer_id ,
SUM(oi.price) customer_price
FROM orders as o 
left join (
            SELECT o.order_id,
            sum(oi.quantity*oi.unit_price) as price 
            from order_items as oi 
            left join orders  as o
            on oi.order_id=o.order_id
            WHERE status <> 'cancelled' 
            GROUP BY o.order_id
             ) as oi
on o.order_id=oi.order_id
GROUP BY  o.customer_id 
ORDER BY customer_price desc

--10 MONTH WISE NEW CUSTOMER REGIGESTRATION COUNT 

SELECT 
format(signup_date,'yyyy-MM') month,
count(customer_id) customer_count
FROM customers
GROUP BY format(signup_date,'yyyy-MM')
ORDER BY month DESC


/*
DAY 4 – CUSTOMER ANALYSIS
INSIGHTS

Q1. Total Customers
- The database contains 1,000 registered customers.

Q2. Customers by City
- Lucknow has the highest number of customers, with 65.
- Faridabad has 60 customers, followed by Gurugram with 59.
- Hyderabad has 57 customers and Kolkata has 55.
- Customer distribution varies across cities.

Q3. Top 10 Customers by Order Count
- Customers 503 and 434 have the highest visible non-cancelled order count, with 9 orders each.
- Customers 509, 344, 736, and 298 have 8 orders each.
- These customers show higher purchase frequency compared with other customers.

Q4. Customer Spending
- Customer spending varies significantly.
- Among the visible results, Customer 298 has spending of 2,63,767.46  
- Customer 178 has the lowest spending , at 1,918.55

Q5. Average Spending per Customer
- The average spending per qualifying customer is approximately 57,624.82.

Q6. Customers with More Than 5 Orders
- Multiple customers have placed more than 5 non-cancelled orders.

Q7. Customer Segment Analysis
- Regular customers form the largest segment, with 564 customers.
- New customers account for 256 customers.
- Premium customers account for 180 customers.
- Regular customers represent the majority of the customer base.

Q8. Average Orders per Customer
- The average number of non-cancelled orders per customer is approximately 2.764.
- This calculation includes customers with zero qualifying orders.

Q9. Top 10 Customers by Spending
- Customer spending results help identify high-value customers.
- These customers can be targeted with loyalty programs and personalized offers.

Q10. Customer Signups by Month
- In September 2025, 29 new customers registered.
*/
use DATAPENCIL_STORE

-- 1. TOTAL ORDERS AND ORDER STATUS DISTRIBUTION


    SELECT
        status,
        COUNT(*) AS order_count
    FROM orders
    GROUP BY status

--2. total sales value from non cancelled orders

    SELECT 
        SUM(oi.quantity * oi.unit_price) AS total_sales
    FROM order_items AS oi
    JOIN orders AS o ON oi.order_id = o.order_id
    WHERE o.status <> 'cancelled'

--3.month with lowest and highest sales volume


    SELECT top 1
        format(o.order_date, 'yyyy-MMMM') AS order_year_month,
        count(order_id) AS maximum_order_count
    FROM orders AS o
    GROUP BY format(o.order_date, 'yyyy-MMMM')
    order BY maximum_order_count DESC

 SELECT top 1 
        format(o.order_date, 'yyyy-MMMM') AS order_year_month,
        count(order_id) AS minimum_order_count
    FROM orders AS o
    GROUP BY format(o.order_date, 'yyyy-MMMM')
    order BY minimum_order_count ASC



--4.sales value by sales channel

    SELECT 
        o.channel,
        SUM(oi.quantity * oi.unit_price) AS total_sales
    FROM orders AS o
    JOIN order_items AS oi ON o.order_id = oi.order_id
    WHERE o.status <> 'cancelled'
    GROUP BY o.channel
   
--5.sales value by product category

    SELECT 
        p.category,
        SUM(oi.quantity * oi.unit_price) AS total_sales
    FROM order_items AS oi
    JOIN products AS p ON oi.product_id = p.product_id
    JOIN orders AS o ON oi.order_id = o.order_id
    WHERE o.status <> 'cancelled'
    GROUP BY p.category

-- 6.top 10 products by sales value

    SELECT top 10 
       p.product_id,
        p.product_name,
        SUM(oi.quantity * oi.unit_price) AS total_sales
    FROM order_items AS oi
    JOIN products AS p ON oi.product_id = p.product_id
    JOIN orders AS o ON oi.order_id = o.order_id
    WHERE o.status <> 'cancelled'
    GROUP BY p.product_name,p.product_id
    ORDER BY total_sales DESC

-- 7.products with no.of sales with non cancelled orders

    SELECT 
        p.product_name,
        SUM(oi.quantity )AS total_sales
    FROM products AS p
    LEFT JOIN order_items AS oi ON p.product_id = oi.product_id
    LEFT JOIN orders AS o ON oi.order_id = o.order_id 
    where  o.status <> 'cancelled'
    GROUP BY p.product_name



-- 8.estimate profit by product category

    SELECT 
        p.category,
        SUM((oi.unit_price - p.cost) * oi.quantity) AS estimated_profit
    FROM order_items AS oi
    JOIN products AS p ON oi.product_id = p.product_id
    JOIN orders AS o ON oi.order_id = o.order_id
    WHERE o.status <> 'cancelled'
    GROUP BY p.category

-- 9.top 10 customers by non cancelled order count

    SELECT TOP 10
        o.customer_id,
        COUNT( o.order_id) AS order_count
    FROM orders AS o
    WHERE o.status <> 'cancelled'
    GROUP BY o.customer_id
    ORDER BY order_count DESC

--10,top 10 customers by calculated spending value

    SELECT TOP 10
        o.customer_id,
        SUM(oi.quantity * oi.unit_price) AS total_spending
    FROM orders AS o
    JOIN order_items AS oi ON o.order_id = oi.order_id
    WHERE o.status <> 'cancelled'
    GROUP BY o.customer_id
    ORDER BY total_spending DESC

--11.cities with the largest customer base

    SELECT 
        c.city,
        COUNT(DISTINCT c.customer_id) AS customer_count
    FROM customers AS c
    GROUP BY c.city
    ORDER BY customer_count DESC

--12.avarage customer spending by segment

    SELECT 
        c.segment,
        AVG(spending.total_spending) AS average_spending
    FROM customers AS c
    JOIN (
        SELECT 
            o.customer_id,
            SUM(oi.quantity * oi.unit_price) AS total_spending
        FROM orders AS o
        JOIN order_items AS oi ON o.order_id = oi.order_id
        WHERE o.status <> 'cancelled'
        GROUP BY o.customer_id
    ) AS spending ON c.customer_id = spending.customer_id
    GROUP BY c.segment


    
    --13.payment status distribution
    SELECT 
        p.payment_status,
        COUNT(*) AS payment_count
    FROM payments AS p
    GROUP BY p.payment_status

    --14.avarage delivery time
    SELECT 
        AVG(
            cast(
            DATEDIFF(day, o.order_date, p.delivery_date) as decimal(10,4)))
         AS average_delivery_time 
         from orders as o 
         left join deliveries as p
         on o.order_id=p.order_id
         where  p.delivery_status in ('delivered','delayed') 

--15.orders taking more than 5 days to deliver

    SELECT 
        o.order_id,
        DATEDIFF(day, o.order_date, p.delivery_date) AS delivery_time
    FROM orders AS o
    JOIN deliveries AS p ON o.order_id = p.order_id
    WHERE p.delivery_status in('delivered','delayed') AND 
    DATEDIFF(day, o.order_date, p.delivery_date) > 5


  
/*
PROJECT 7 – FINAL PROJECT
KEY BUSINESS INSIGHTS

1. A total of 3,000 orders were recorded, with 1,796 orders delivered.
   Delivered orders represent approximately 59.87% of total orders.

2. Non-cancelled orders generated a calculated sales value of
   ₹57,624,820.18, highlighting the overall sales performance.

3. April 2025 recorded the highest order volume with 161 orders,
   while February 2025 recorded the lowest with 123 orders.

4. Social Commerce generated the highest sales value among the
   three sales channels, followed by Mobile App and Marketplace.

5. Sports & Fitness was the highest revenue-generating product
   category, while Electronics recorded the lowest category sales.

6. Storage Box 26 was the top-selling product by sales value,
   generating ₹941,213.73.

8. Sports & Fitness generated the highest estimated profit of
   ₹5,941,610.07 among all product categories.

9. Customer IDs 503, 434, and 509 recorded the highest
   non-cancelled order count, with 9 orders each.

10. Customer ID 298 recorded the highest calculated spending
    value of ₹263,767.46.

11. Lucknow had the largest customer base with 65 customers,
    patna is lowest customer base 38 customers only

12. The Regular customer segment recorded the highest average
    spending of ₹63,055.46.

13. Paid payments accounted for 2,542 records,  failed payments 222 and 
     refunded payments 236

14. The average delivery time was approximately 7.43 days,
    indicating opportunities to improve delivery efficiency.

15. Several orders took more than five days to arrive.
    Monitoring delayed orders can help improve logistics
    and customer satisfaction.
*/
USE datapencil_store;


---1.TOTAL SALES VALUE OF ALL ORDER ITEM
SELECT 
SUM(quantity*unit_price) as [Total Sales] 
FROM order_items
WHERE order_id  not in   
                ( SELECT 
                order_id FROM orders 
                WHERE STATUS='cancelled')


SELECT SUM(quantity*unit_price)
FROM orders as o
left join order_items as oi 
ON o.order_id=oi.order_id
WHERE o.status != 'cancelled'


--2.REVENUE BY THE PRODUCT CATAGORY 
-- WHICH PRODUCT CATEGORY GENERATING HIGHEST SALES


SELECT 
p.category, 
SUM(oi.quantity*oi.unit_price) as [revenue of category] 
FROM orders as o
left join order_items as oi 
 on o.order_id=oi.order_id
left join products as p 
 on oi.product_id=p.product_id
WHERE o.status<> 'cancelled'
GROUP BY p.category 
ORDER BY [revenue of category] desc

--3.FIND THE 10 PRODUCT GENERATE THE HIGHEST  REVENUE

SELECT top 10
p.product_name, 
SUM(oi.quantity*oi.unit_price) as [revenue by product] 
FROM orders as o
left join order_items as oi 
 on o.order_id=oi.order_id
left join products as p 
 on oi.product_id=p.product_id
where o.status<>'cancelled'
GROUP BY p.product_name 
ORDER BY [revenue by product] desc


---4. MONTHLY REVENUE TREND

SELECT 
DATENAME(month,o.order_date) as month,
SUM(quantity*unit_price) [month  wise revenue]
FROM orders as o
left join order_items as oi
on o.order_id=oi.order_id
WHERE o.status<>'cancelled'
GROUP BY DATENAME(month,o.order_date)
ORDER BY [month  wise revenue] desc

--5. REVENUE BY THE SALES CHANNEL 
-- WHICH SALES CHANNEL GENARATE THE HIGHEST REVENUE

SELECT o.channel,
sum(oi.quantity*oi.unit_price) as Revenue  
FROM orders as o
left join order_items as oi
on o.order_id=oi.order_id
WHERE o.status<> 'cancelled'
GROUP BY o.channel
ORDER BY Revenue desc

--6.TOTAL QUANTITY SOLD BY PRODUCT CATEGORY


select p.category,sum(oi.quantity) [category wise total quantity] from products as p
left join order_items as oi
on p.product_id=oi.product_id
left join orders as o 
on o.order_id=oi.order_id
where o.status <>'cancelled'
group by p.category




--7. COUNT HOW MANY PAYMENT WERE MADE  USING EACH PAYMENT METHOD


SELECT  
payment_method,
COUNT(payment_id) [payment method count] 
  from payments 
GROUP BY payment_method 
ORDER BY [payment method count]  

--8. COUNT THE PAYMENT BY THEIR STATUS

SELECT  
payment_status,
COUNT(payment_id) [payment status count] 
FROM payments 
GROUP BY payment_status 

--9.AVARAGE PAYMENT AMOUNT

 SELECT 
 avg(amount)  as avrage_payment 
 FROM payments


--10 PAYMENT AMOUNT   BY PAYMENT METHOD
-- CALCULATE THE TOTAL RECORDED PAYMENT FOR EACH PAYMENT METHOD 

    SELECT 
    payment_method,
    SUM(amount)payment_amount
    FROM payments
    GROUP BY payment_method


    
/*
DAY 3 - SALES AND PAYMENT ANALYSIS
==================================

KEY INSIGHTS

1. TOTAL SALES:
   Calculated total sales value using quantity multiplied by unit price.

2. REVENUE BY PRODUCT CATEGORY:
   Compared revenue across product categories to identify
   the category generating the highest revenue.

3. TOP 10 PRODUCTS:
   Ranked products by revenue to identify the top-performing products.

4. MONTHLY REVENUE TREND:
   Analyzed monthly revenue to understand changes in sales performance.

5. REVENUE BY SALES CHANNEL:
   Compared revenue across sales channels to identify
   the channel generating the highest revenue.

6. QUANTITY BY PRODUCT CATEGORY:
   Calculated the total quantity for each product category
   to compare product category performance.

7. PAYMENT METHOD COUNT:
   Counted payments by payment method to understand
   customer payment preferences.

8. PAYMENT STATUS ANALYSIS:
   Counted payments by status to understand payment outcomes.

9. AVERAGE PAYMENT AMOUNT:
   Calculated the average recorded payment amount.

10. TOTAL PAYMENT AMOUNT BY METHOD:
    Compared recorded payment amounts across payment methods.


*/

-- BikeStore management is trying to analyze their business performance and need your help to get some answers. Please write your SQL queries to find out the answers on below business questions from BikeStore database-
-- 1. Create a Function named as "udfn_cust_full_name" that would return Customer Full Name
-- 2. Find out Top 10 products by sales quantity
-- 3. Find out all the Store names and product wise stock quantities where stock quantities are more than 25
-- 4. Create a VIEW named as "vw_product_stock_qty_below15" that would show the Products that are low (below 15) in stock
-- 5. Find out Top 3 performing Stores with the highest number of orders and Total Revenue
-- 6. List down all customers full name, phone, email and the number of Orders they have placed along with Total Revenue of their Orders. Use "udfn_cust_full_name" to get full name.

use BikeStores;
-- 1. Create a Function named as "udfn_cust_full_name" that would return Customer Full Name
CREATE FUNCTION sales.udfn_cust_full_name (
    @first_name varchar,
    @last_name varchar
)

returns table 
as
return
SELECT 
    first_name, 
    last_name, 
    CONCAT_WS(
        ' ', 
       first_name, 
        last_name
    ) full_name
FROM  sales.customers
;

SELECT *
FROM sales.udfn_cust_full_name('John', 'Doe');


-- without parameter
CREATE FUNCTION sales.udfn_customers_full_name ()
RETURNS TABLE
AS
RETURN
(
    SELECT
    	first_name,
    	last_name,
        CONCAT_WS(' ', first_name, last_name) AS full_name
    FROM sales.customers
);

SELECT *
FROM sales.udfn_customers_full_name();

-- 2. Find out Top 10 products by sales quantity

select TOP 10
pd.product_name,
sum(oi.quantity) sales_quantity
from production.products pd left join sales.order_items oi on pd.product_id =oi.product_id 
group by pd.product_name 
order by sales_quantity desc
;

-- 3. Find out all the Store names and product wise stock quantities where stock quantities are more than 25

SELECT 
    st.store_name,
    p.product_name,
    SUM(sk.quantity) AS stock_quantity
FROM sales.stores st
LEFT JOIN production.stocks sk 
    ON st.store_id = sk.store_id
LEFT JOIN production.products p 
    ON sk.product_id = p.product_id
GROUP BY 
    st.store_name,
    p.product_name
HAVING 
    SUM(sk.quantity) > 25;

-- 4. Create a VIEW named as "vw_product_stock_qty_below15" that would show the Products that are low (below 15) in stock
 create view production.vw_product_stock_qty_below15
 as 
 select
 p.product_name,
 sum(st.quantity) stock_quantity
 from production.products p left join production.stocks st on p.product_id=st.product_id
 group by p.product_name
 having sum(st.quantity)<15;

select * from production.vw_product_stock_qty_below15;


 -- 5. Find out Top 3 performing Stores with the highest number of orders and Total Revenue

select TOP 3
	s.store_name,
	sum(oi.quantity) as order_quantity,
	SUM(oi.quantity * (oi.list_price - (oi.list_price * oi.discount / 100))) as Total_Revenue
from 
	sales.stores s left join sales.orders o
	on s.store_id =o.store_id join 
	sales.order_items oi 
	on o.order_id = oi.order_id
group by 
	s.store_name 
ORDER BY 
    order_quantity DESC,
    Total_Revenue DESC;

-- 6. List down all customers full name, phone, email and the number of Orders they have placed along with Total Revenue of their Orders. Use "udfn_cust_full_name" to get full name.


SELECT 
    fn.full_name,
    c.phone,
    c.email,
    COUNT(DISTINCT o.order_id) AS number_of_orders,
    SUM(oi.quantity * (oi.list_price - (oi.list_price * oi.discount / 100))) AS total_revenue
FROM sales.customers c
JOIN sales.udfn_customers_full_name() fn
    ON c.first_name = fn.first_name AND c.last_name = fn.last_name
LEFT JOIN sales.orders o 
    ON c.customer_id = o.customer_id
LEFT JOIN sales.order_items oi
    ON o.order_id = oi.order_id
GROUP BY 
    fn.full_name,
    c.phone,
    c.email;





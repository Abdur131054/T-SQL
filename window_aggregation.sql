-- Find the total sales across all orders
select sales from Sales.Orders;

select
sum(sales) TotalSales
from Sales.Orders;

-- Find the total sales for each product 
select 
	o.ProductID,
	sum(o.Sales) as Total_Sales
from Sales.Orders as o
group by o.ProductID;

-- Find the total sales for each product additionally provide OrderID,OrderDate
select 
o.OrderID,
o.OrderDate,
o.ProductID,
sum(o.Sales) as total_sales
from Sales.Orders o
group by o.ProductID; --this will give error

-- Find the total sales for each product additionally provide OrderID,OrderDate
select 
	o.OrderID,
	o.OrderDate,
	o.ProductID,	
sum(o.Sales) as total_sales
from Sales.Orders o
group by 
	o.OrderID,
	o.OrderDate,
	o.ProductID; -- this will not aggregate sales

-- so here we need window function
select 
	o.OrderID,
	o.OrderDate,
	o.ProductID,	
sum(o.Sales) over(partition by o.ProductID) as total_sales
from Sales.Orders o

-- Find the total sales for each product
-- additionally provide details such as OrderID, OrderDate
select 
	OrderID,
	OrderDate,
	sum(Sales) over() TotalSales
from Sales.Orders;
-------
select 
	OrderID,
	OrderDate,
	ProductID,
	sum(Sales) over(partition by ProductID) TotalSales
from Sales.Orders;

-- Find the total sales across all orders 
-- Find the total sales for each product
-- additionally provide details such as OrderID, OrderDate
select 
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	sum(Sales) over() TotalSales,
	sum(Sales) over(partition by ProductID) TotalSalesByProduct
from Sales.Orders;
-- Find the total sales across all orders 
-- Find the total sales for each product
-- Find the total sales for each combination of product and order status
-- additionally provide details such as OrderID, OrderDate

select 
	OrderID,
	OrderDate,
	ProductID,
	OrderStatus,
	Sales,
	sum(Sales) over() TotalSales,
	sum(Sales) over(partition by ProductID) SalesByProduct,
	sum(Sales) over(partition by ProductID,OrderStatus) SalesByProductandStatus
from Sales.Orders;

--Rank each order by Sales from highest to lowest
SELECT
    OrderID,
    OrderDate,
    Sales,
    RANK() OVER (ORDER BY Sales DESC) AS Rank_Sales
FROM Sales.Orders;
-------------------------------------------------------
SELECT
    OrderID,
    OrderDate,
    Sales,
    DENSE_RANK() OVER (ORDER BY Sales DESC) AS Rank_Sales
FROM Sales.Orders;

-------------------------------------
-- Calculate Total Sales by Order Status for current and next two orders 
select 
	OrderID,
    OrderDate,
    OrderStatus,
    Sales,
	SUM(Sales) over (partition by OrderStatus order by OrderDate
	rows between current row and 2 following) TotalSales
from Sales.Orders;

-- Calculate Total Sales by Order Status for current and previous two orders 
SELECT
    OrderID,
    OrderDate,
    ProductID,
    OrderStatus,
    Sales,
    SUM(Sales) OVER (
        PARTITION BY OrderStatus 
        ORDER BY OrderDate 
        ROWS BETWEEN  2 PRECEDING  AND CURRENT ROW
    ) AS Total_Sales
FROM Sales.Orders;

-- order by always uses a frame 
SELECT
    OrderID,
    OrderDate,
    ProductID,
    OrderStatus,
    Sales,
    SUM(Sales) OVER (
        PARTITION BY OrderStatus 
        ORDER BY OrderDate 
    ) AS Total_Sales
FROM Sales.Orders;
------------------------
-- below code give result as previous
SELECT
    OrderID,
    OrderDate,
    ProductID,
    OrderStatus,
    Sales,
    SUM(Sales) OVER (
        PARTITION BY OrderStatus 
        ORDER BY OrderDate 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW 
    ) AS Total_Sales
FROM Sales.Orders;

-- Calculate Total Sales by Order Status from previous two orders only 

SELECT
    OrderID,
    OrderDate,
    ProductID,
    OrderStatus,
    Sales,
    SUM(Sales) OVER (
        PARTITION BY OrderStatus 
        ORDER BY OrderDate 
        ROWS 2 PRECEDING
    ) AS Total_Sales
FROM Sales.Orders;
-- Calculate cumulative Total Sales by Order Status up to the current order 
SELECT
    OrderID,
    OrderDate,
    ProductID,
    OrderStatus,
    Sales,
    SUM(Sales) OVER (
        PARTITION BY OrderStatus 
        ORDER BY OrderDate 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS Total_Sales
FROM Sales.Orders

--  Calculate cumulative Total Sales by Order Status from the start to the current row 
SELECT
    OrderID,
    OrderDate,
    ProductID,
    OrderStatus,
    Sales,
    SUM(Sales) OVER (
        PARTITION BY OrderStatus 
        ORDER BY OrderDate 
        ROWS UNBOUNDED PRECEDING
    ) AS Total_Sales
FROM Sales.Orders;

/* RULE 1: 
   Window functions can only be used in SELECT or ORDER BY clauses 
*/
SELECT
    OrderID,
    OrderDate,
    ProductID,
    OrderStatus,
    Sales,
    SUM(Sales) OVER (PARTITION BY OrderStatus) AS Total_Sales
FROM Sales.Orders
WHERE SUM(Sales) OVER (PARTITION BY OrderStatus) > 100;  -- Invalid: window function in WHERE clause

/* RULE 2: 
   Window functions cannot be nested 
*/
SELECT
    OrderID,
    OrderDate,
    ProductID,
    OrderStatus,
    Sales,
    SUM(SUM(Sales) OVER (PARTITION BY OrderStatus)) OVER (PARTITION BY OrderStatus) AS Total_Sales  -- Invalid nesting
FROM Sales.Orders;


-- Rank customers by their total sales 
SELECT
    CustomerID,
    SUM(Sales) AS Total_Sales,
    RANK() OVER (ORDER BY SUM(Sales) DESC) AS Rank_Customers
FROM Sales.Orders
GROUP BY CustomerID;

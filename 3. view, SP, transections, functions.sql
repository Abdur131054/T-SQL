--1 ==================== VIEW ==================== 
What is View?
	- A view is a named query stored in the database catalog that allows you to refer to it later.
	- Acts like a virtual table but data is not physically stored in the database.
What is Database Catalog?
	-A centralized metadata repository that stores detailed information about all objects within a database system.

--Creating a View:
CREATE VIEW view_name 
AS
	SELECT column1, column2, ...
	FROM table_name
	WHERE condition
	;
--Sample Table Join Query
--Get product name, brand, and list price of all products from the products and brands tables:

select 
p.product_name,
b.brand_name,
p.list_price
from production.products p
join production.brands b
on p.brand_id=b.brand_id;

--Context: Next time, to get the same result set, you can save this query in the database catalog through a view.
--CREATE A VIEW
create view production.vw_product_info
AS 
select 
p.product_name,
b.brand_name,
p.list_price
from production.products p
join production.brands b
on p.brand_id=b.brand_id;

--SELECT
SELECT * FROM production.vw_product_info;

-- ALTER VIEW
ALTER view production.vw_product_info
AS 
select 
p.product_name as product,
b.brand_name,
p.model_year,
p.list_price
from production.products p
join production.brands b
on p.brand_id=b.brand_id;


SELECT * FROM production.vw_product_info;

-- DROP VIEW
drop view
	 production.vw_product_info;

-- will give error as view is deleted 
SELECT * FROM production.vw_product_info;


--Advantages of using VIEWS:
	-Re-usability: Use existing View instead of rewriting same sql code and logics everytime. Write one time, use every time.
	-Data Abstraction: Views can simplify complex queries by encapsulating joins, aggregations, and filtering logic into a single, reusable object.
	-Security Mechanism: Views can be used to restrict user access to specific columns or rows of underlying tables, providing a layer of security.
	-Data Presentation: Views allow for customized presentations of data.
	-Up-to-Date Data: Always reflects the most current data in the base tables. If table is updated, view automatically takes updated data.
	-Simplicity: A relational database may have many tables with complex relationships. However, you can simplify the complex queries with joins and conditions using a set of views.

--2 ==================== STORED PROCEDURE ==================== 	
What is STORED PROCEDURE?
	- A set of statement(s) that perform some defined actions. We make stored procedures so that we can reuse statements that are used frequently.
	- Stored procedures are thus similar to functions in programming. They can perform specified operations when we call them.
	
--Creating a simple stored procedure: Returns a list of products from the products
SELECT 
	product_name, 
	list_price
FROM 
	production.products
ORDER BY 
	product_name
;
use BikeStores;
SELECT DB_NAME() AS CurrentDatabase;

select
p.product_name,
p.list_price
from production.products p
order by p.product_name;

--Creating a STORED PROCEDURE
CREATE PROCEDURE usp_product_list
AS
BEGIN
    select
	p.product_name,
	p.list_price
	from production.products p
	order by p.product_name;
END;

EXECUTE usp_product_list;
	
-- Altering procedure
ALTER PROCEDURE usp_product_list
AS
BEGIN
    SELECT 
        p.product_name,
        p.list_price
	    FROM production.products AS p
	    ORDER BY p.list_price;
END;

EXECUTE usp_product_list;

--Context: A sample query that returns result based on specific filtering condition:
select 
product_name,
list_price
from production.products 
where list_price >= 900
and list_price <= 1000
order by list_price ;

-- drop procedure
drop procedure usp_product_list;

create procedure usp_find_product(
	@min_list_price as decimal,
	@max_list_price as decimal,
	@name as varchar(max)
	)
AS
BEGIN
	SELECT 
		product_name,
		list_price
	FROM
		production.products
	where
		list_price>=@min_list_price AND
		list_price<=@max_list_price AND
		product_name like '%' + @name + '%'
	order by list_price
END;

EXECUTE usp_find_product 900,1000,'Trek';


--or
EXECUTE usp_find_product 
    @min_list_price = 900, 
    @max_list_price = 1000,
    @name = 'Trek'
;


--Advantages of SP:
	1. Encapsulation and Reusability
	2. Performance Enhancement: When a stored procedure is executed for the first time, SQL Server compiles it and creates an execution plan, which is then cached and reused for subsequent calls. This pre-compilation and plan reuse can significantly improve performance compared to executing ad-hoc SQL queries.
	3. Maintainability
	4. Parameterization
	5. Error Handling: Using TRY...CATCH

-------------SQL Server BEGIN END
	- The BEGIN...END statement is used to define a statement block. A statement block consists of a set of SQL statements that execute together. 
	A statement block is also known as a batch.

--Structure:
BEGIN
    --{ sql_statement | statement_block}
	--SELECT 1;
END
	
--3 ==================== TRANSACTION ====================
What is Transaction?
	- A single unit of work that typically contains multiple T-SQL statements.
	- If a transaction is successful, the changes are committed to the database. However, if a transaction has an error, the changes have to be rolled back.
	- When executing a single statement such as INSERT, UPDATE, and DELETE, SQL Server uses the autocommit transaction.
	*** Summary: transaction is a sequence of operations that are either all successfully completed and committed to the database, or all rolled back, leaving the database in its state before the transaction began.

--Structure:
-- start a transaction
BEGIN TRANSACTION;

-- other statements

-- commit the transaction
COMMIT;
--or rollback the transaction
ROLLBACK;

--Example:
BEGIN TRANSACTION;

	-- Perform data modifications
	INSERT INTO Employees (FirstName, LastName) VALUES ('John', 'Doe');
	
	UPDATE Orders 
	SET TotalAmount = 100.00 
	WHERE OrderID = 123;
	
	DELETE FROM Products WHERE ProductID = 456;
	
	-- Check for errors and commit or rollback
	IF @@ERROR <> 0
		BEGIN
		    ROLLBACK TRANSACTION;
		    PRINT 'Transaction rolled back due to an error.';
		END
	ELSE
		BEGIN
		    COMMIT TRANSACTION;
		    PRINT 'Transaction committed successfully.';
		END
	;
--@@ERROR function
	- In Transact-SQL (T-SQL), it returns the error number for the last executed T-SQL statement within the current user session.
	- If the previous Transact-SQL statement executed successfully without any errors, @@ERROR will return 0.

--SQL Server Transactions Properties:
	1. Atomicity: All operations within a transaction either succeed or fail as a single unit. There is no partial completion.
	2. Consistency: Transactions ensure that the database remains in a consistent state before and after the transaction. (Example for account transfer)
	3. Isolation: The effects of one transaction are isolated from other concurrent transactions until the first transaction is committed.
	4. Durability: Once a transaction is committed, its changes are permanently stored.

	
--SQL Server OFFSET FETCH
select 
	product_name,
	list_price
from production.products
order by 
	list_price ,
	product_name 
offset 4 rows
fetch next 5 rows only;

-- sql server WHILE example
declare @counter int = 1;

while @counter<=5
begin
	print @counter;
	set @counter = @counter+ 1;
end;

Categories of SQL Server functions:	
	1. Built-in Functions: These are pre-defined functions provided by SQL Server for common operations. 
		-Aggregate Functions: Perform calculations on a set of values and return a single value. Common examples are COUNT(), AVG(), SUM(), MIN(),  MAX().
		-Date and Time Functions: Manipulate and extract information from date and time values. Examples include GETDATE(), DATEDIFF(), DATEADD(), YEAR(), MONTH(),  DAY().
		-String Functions: Perform operations on string data. Examples include SUBSTRING(), LEN(), REVERSE(), UPPER(),  LOWER().
		-Mathematical Functions: Perform mathematical calculations. Examples include ROUND(), ABS(), SQRT(),  POWER().
		-Conversion Functions: Convert data from one data type to another, such as CAST()  CONVERT().
		-System Functions: Return information about the database, objects, or system settings. [DB_NAME(), HOST_NAME(), USER_NAME(), SUSER_NAME()SUSER_NAME(), OBJECT_ID(), OBJECT_NAME()]
		
	2. User-Defined Functions (UDFs): These are functions created by users to address specific application requirements.
		- Scalar Functions: Return a single, scalar value
		- TABLE-Valued  Functions: Return a result set in the form of a table by SELECT Statement.	
		
--Advantages of FN:
	1. Encapsulation 
	2. Reusability		
	2. Simplified Queries
	
-------------------- Creating a Scalar Function --------------------
--Calculates the net sales based on the quantity, list price, and discount	
	
create function sales.udfNetSales (
	@quantity int,
	@list_price dec(10,2),
	@discount dec(4,2)
)
returns dec(10,2)
as
begin
	return @quantity * @list_price * (1 - @discount);
end;

--Calling a Scalar Function
SELECT sales.udfNetSales(10,100,0.1) net_sale;

--Implementation in Query
select order_id,
sum(sales.udfNetSales(quantity,list_price,discount)) net_amount
FROM 
sales.order_items 
group BY 
order_id 
order by 
net_amount desc;


-- drop function
drop function sales.udfNetSales;

-------------------- Creating a Table-Valued Function --------------------
--Returns a list of products including product name, model year and the list price for a specific model year:


create function sales.udfProductInYear(
	@start_year int,
	@end_year int
)
returns table
as
return
	SELECT 
		product_name,
		model_year,
		list_price
	from production.products
	where model_year between @start_year and @end_year
;


--Calling a Table-Valued Function or Implementation in Query

SELECT 
	product_name,
	model_year,
	list_price
FROM 
	sales.udfProductInYear(2017,2018)
order by 
	product_name ;


SELECT *
FROM 
	sales.udfProductInYear(2017,2018)
order by 
	product_name ;
	
--DROP FN
DROP FUNCTION sales.udfProductInYear;
	
------------------- SQL Server System Functions ------------------- 
SELECT DB_NAME();
	
--What is the Lenght of a String?
SELECT LEN('SQL Server SUBSTRING') AS Length;

--Find out a Specific word from known length
SELECT SUBSTRING('SQL Server SUBSTRING', 5, 6) AS result;
SELECT SUBSTRING('SQL Server SUBSTRING', 5, LEN('SQL Server SUBSTRING')) AS result;
	
SELECT  email
	,LEN(email) Total_Len
	,CHARINDEX('@', email) Position_Of_@
	,CHARINDEX('@', email)-1 Len_Before_@
    ,LEN(email)-CHARINDEX('@', email) Len_After_@
FROM sales.customers
;	
	
SELECT 
    product_name,
    RIGHT(product_name, 4) last_4_characters
FROM     production.products
ORDER BY     product_name
;
	
SELECT 
    first_name, 
    last_name, 
    UPPER(first_name), 
    LOWER(last_name),
    CONCAT_WS(
        '_', 
        UPPER(first_name), 
        LOWER(last_name)
    ) full_name
    ,CONCAT(first_name,'.',last_name,'@','gmail.com') emails
FROM  sales.customers
ORDER BY 
    first_name, 
    last_name
;


SELECT 
	GETDATE() Current_DateTime 
	,CONVERT(DATE, GETDATE()) AS [Current Date]
;

SELECT CURRENT_TIMESTAMP AS current_date_time;

SELECT 
	SYSDATETIME()
    ,CONVERT(DATE, SYSDATETIME())
    ,CONVERT(TIME, SYSDATETIME())
;

SELECT 
	order_id
    ,order_date
    ,DATEADD(day, 5, order_date) expected_delivery_date	
    ,DATEADD(month, 1, order_date) max_date_of_complain_acceptance	
	,shipped_date
    ,DAY(shipped_date) [day]
    ,MONTH(shipped_date) [mon]
    ,YEAR(shipped_date) [year]
FROM sales.orders
;

SELECT
	product_id
	,product_name
	,list_price
	,ROW_NUMBER () OVER (ORDER BY list_price DESC) row_number 
	,DENSE_RANK () OVER (ORDER BY list_price DESC) price_dense_rank 
	,RANK () OVER (ORDER BY list_price DESC) price_rank 	
FROM production.products
ORDER BY list_price DESC
;

SELECT * 
FROM (
	SELECT
		product_id
		,product_name
		,brand_id
		,list_price
		,RANK () OVER ( PARTITION BY brand_id ORDER BY list_price DESC ) price_rank 
	FROM production.products
) sub_query
WHERE price_rank <= 3
ORDER BY list_price DESC
;
CREATE VIEW sales.vw_netsales_brands
AS
	SELECT 
		c.brand_name, 
		MONTH(o.order_date) month, 
		YEAR(o.order_date) year, 
		CONVERT(DEC(10, 0), SUM((i.list_price * i.quantity) * (1 - i.discount))) AS net_sales
	FROM sales.orders AS o
	JOIN sales.order_items AS i ON i.order_id = o.order_id
	JOIN production.products AS p ON p.product_id = i.product_id
	JOIN production.brands AS c ON c.brand_id = p.brand_id
	GROUP BY c.brand_name, 
			MONTH(o.order_date), 
			YEAR(o.order_date)
;
-----
SELECT * 
FROM sales.vw_netsales_brands
ORDER BY 
	year, 
	month, 
	brand_name, 
	net_sales
;

WITH cte_netsales_2017 AS
(
	SELECT 
		month, 
		SUM(net_sales) net_sales
	FROM sales.vw_netsales_brands
	WHERE year = 2017
	GROUP BY 
		month
)
SELECT 
	month,
	net_sales,
	LAG(net_sales,1) OVER (ORDER BY month) prev_month_sales,
	LEAD(net_sales,1) OVER (ORDER BY month) next_month_sales
FROM cte_netsales_2017
;

-----------------------------------------------------------
--Few Convertion or Casting examples:

SELECT CAST(10.3496847 AS money);

SELECT GETDATE(), CAST(GETDATE() as VARCHAR(50));
SELECT GETDATE(), CAST(GETDATE() as CHAR(30));


SELECT CONVERT(DATETIME,'13/12/2019',103);
SELECT GETDATE(), CONVERT(VARCHAR, GETDATE(),101);


SELECT CAST(GETDATE() AS VARCHAR(11));
SELECT CAST('11/09/2025' AS DATE);


SELECT CONVERT(VARCHAR(10), GETDATE(), 101); -- MM/DD/YYYY format
SELECT CONVERT(VARCHAR(10), GETDATE(), 108); -- 
SELECT CONVERT(VARCHAR(30), GETDATE(), 113); -- 








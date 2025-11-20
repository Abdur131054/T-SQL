--CREATE DATABASE 
CREATE DATABASE TEST_DB;

--Switch to Specific Database
USE TEST_DB;

--CREATE TABLE in Default Schema (dbo)
CREATE TABLE Product(
	product_id int
	,product_name varchar
);

--CREATE SCHEMA 
CREATE SCHEMA test_schema;

--------------DDL Examples--------------
--Create Table
CREATE TABLE test_schema.Product(
	product_id int
	,product_name varchar(MAX)
	,price decimal
);

drop TABLE 
--Alter Table
ALTER TABLE test_schema.Product 
ADD quantity float;

--Truncate Table
TRUNCATE TABLE test_schema.Product; -- All row/data


--DROP Table
DROP TABLE test_schema.Product; --Whole Table

--------------DQL Examples--------------
--SELECT
SELECT * 
FROM test_schema.Product;

--------------DML Examples--------------
--INSERT
INSERT INTO test_schema.Product 
VALUES (1,'Book',100,5)
;

--INSERT
INSERT INTO test_schema.Product 
(product_id,product_name,quantity)
VALUES (2,'Pen',10)
;

select * from test_schema.Product;

--UPDATE
UPDATE test_schema.Product  
SET price = 10.5 
WHERE product_id = 2;

--DELETE
DELETE FROM test_schema.Product --Specific row/records
WHERE product_id = 2
;

--------------DCL Examples--------------
USE test_db;
CREATE LOGIN user1 WITH PASSWORD = 'StrongPassword@123';
CREATE USER user1 FOR LOGIN user1; --DDL
--GRANT Access
GRANT 
	SELECT, UPDATE 
ON Product TO user1;



--REVOKE Access
REVOKE 
	UPDATE 
ON Product FROM user1;

--------------TCL Examples--------------

--COMMIT 
UPDATE test_schema.Product  
SET price = 10.5 
WHERE product_id = 2
;
COMMIT;

select * from test_schema.Product;

DELETE FROM test_schema.Product   
WHERE product_id = 2
;
ROLLBACK;



--Scenario - Copy data from Source table to Destination table: [Source] AdventureWorks2014.Production.Product ->> [Destination] TEST_DB.test_schema.ProductAdvWDB2014

--While inserting, create destination table on the fly 


SELECT *
INTO TEST_DB.test_schema.ProductAdvWDB2014
FROM AdventureWorks2014.Production.Product p 
WHERE p.StandardCost > 0
;

select * from test_schema.ProductAdvWDB2014;


SELECT *
FROM TEST_DB.test_schema.ProductAdvWDB2014
WHERE StandardCost > 0

DROP TABLE TEST_DB.test_schema.ProductAdvWDB2014;

--Inserting in existing table
create table test_schema.Product1
(
	product_id int
	,product_name varchar(MAX)
	,price decimal
	,quantity float
);
USE TEST_DB;
--Inserting in existing table
INSERT INTO test_schema.Product1
SELECT *
FROM test_schema.Product
WHERE product_id = 1;


select * from test_schema.Product1;


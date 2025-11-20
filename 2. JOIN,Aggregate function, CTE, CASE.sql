USE AdventureWorks2014;
------------------------------------1 JOIN
--INNER JOIN(Equi JOIN, Theta JOIN), FULL OUTER JOIN, LEFT JOIN, RIGHT JOIN, CROSS JOIN, SELF JOIN< 
--NATURAL JOIN, ANTI JOIN

--1 Male employees’ job titles and dates of department change

select 
e.BusinessEntityID,
e.JobTitle,
e.HireDate,
edh.DepartmentID,
edh.StartDate
FROM AdventureWorks2014.HumanResources.Employee e
JOIN AdventureWorks2014.HumanResources.EmployeeDepartmentHistory edh ON E.BusinessEntityID =edh.BusinessEntityID;

--2 Employees hired after 2010 
SELECT
	e.BusinessEntityID,
	d.Name,
	s.Name
FROM HumanResources.Employee AS e
JOIN HumanResources.EmployeeDepartmentHistory AS edh ON	e.BusinessEntityID = edh.BusinessEntityID
JOIN HumanResources.Department AS d ON edh.DepartmentID = d.DepartmentID
JOIN HumanResources.Shift AS s ON edh.ShiftID = s.ShiftID
WHERE e.HireDate > '2010-01-01'
	AND d.GroupName IN ('Manufacturing', 'Quality Assurance')
;

------------------------------------ ,3 AGGREGATE FUNCTIONS and GROUP BY, HAVING & ORDER BY


--AGGREGATE FUNCTIONS:

--1 Highest and lowest sick leave hours
SELECT MIN(SickLeaveHours) AS MinSickLeaveHours,
       MAX(SickLeaveHours) AS MaxSickLeaveHours
FROM HumanResources.Employee
;

--2 Average number of vacation hours per job title
SELECT JobTitle, AVG(VacationHours) AS AvgVacationHours
FROM HumanResources.Employee
GROUP BY JobTitle
;

--3 Count of employees based on their gender
SELECT 
	Gender
	, COUNT(*) AS Count
FROM HumanResources.Employee
GROUP BY Gender
;

--4 Count of departments in each group
SELECT GroupName, COUNT(*) AS DepartmentsCount
FROM HumanResources.Department
GROUP BY GroupName
HAVING COUNT(*) > 2
;

--5 Sum of sick leave hours for Top 5 department
SELECT TOP 5 
	d.Name
	, SUM(e.SickLeaveHours) AS SumSickLeaveHours
FROM HumanResources.Employee AS e
JOIN HumanResources.EmployeeDepartmentHistory AS edh 
ON e.BusinessEntityID = edh.BusinessEntityID
JOIN HumanResources.Department AS d
ON edh.DepartmentID = d.DepartmentID
WHERE edh.EndDate IS NULL
GROUP BY d.Name
ORDER BY SumSickLeaveHours DESC 
--LIMIT 5 OFFSET 2
;


------------------------------------4 SET OPERATORS
UNION: Combines the result sets of two or more SELECT statements and returns all distinct rows. Duplicate rows are eliminated.
UNION ALL: Combines the result sets of two or more SELECT statements and returns all rows, including duplicates. No duplicate elimination occurs.
INTERSECT: Returns the distinct rows that are present in both the first and second SELECT statements. In other words, it returns the common rows between the two result sets.
EXCEPT: Returns the distinct rows from the first SELECT statement that are not present in the second SELECT statement. It effectively finds the difference between the two result sets.


--1 Employee IDs with their out-of-office hours
--So the UNION result gives all unique employees who have either
--Vacation hours > 60
--or Sick leave hours > 60
--or both.

SELECT BusinessEntityID
FROM HumanResources.Employee
GROUP BY BusinessEntityID
HAVING SUM(VacationHours) > 60
UNION 
SELECT BusinessEntityID
FROM HumanResources.Employee
GROUP BY BusinessEntityID
HAVING SUM(SickLeaveHours) > 60
;


--2 Employee IDs with certain job titles and departments
SELECT e.BusinessEntityID
FROM HumanResources.Employee AS e
WHERE e.JobTitle IN ('Sales Representative', 'Tool Designer')
INTERSECT
SELECT edh.BusinessEntityID
FROM HumanResources.EmployeeDepartmentHistory AS edh
JOIN HumanResources.Department AS d
ON edh.DepartmentID = d.DepartmentID
WHERE d.Name IN ('Sales', 'Marketing')
;
------------------------------------5 SUB QUERY
--1 Select employees with their current pay rate
SELECT e.BusinessEntityID, e.Rate AS CurrentPayRate
FROM HumanResources.EmployeePayHistory AS e
WHERE e.RateChangeDate = (
            SELECT MAX(e2.RateChangeDate)
            FROM HumanResources.EmployeePayHistory AS e2
            WHERE e2.BusinessEntityID = e.BusinessEntityID
        )
;

------------------------------------6 CTE
USE AdventureWorksDW2022;

WITH CTE_Employee
AS 
(
	SELECT * 
	FROM HumanResources.Employee e 
	)
SELECT *
FROM CTE_Employee 
;

WITH Sum_OrderQuantity_CTE
AS (
	SELECT ProductKey
	,EnglishMonthName
	,SUM(OrderQuantity) AS TotalOrdersByMonth
	FROM [dbo].[FactInternetSales] fs
	INNER JOIN [dbo].[DimDate] dd ON dd.DateKey = fs.OrderDateKey
	GROUP BY ProductKey, EnglishMonthName
)
SELECT 
	ProductKey
	, AVG(TotalOrdersByMonth) AS 'Average Total Orders By Month'
FROM Sum_OrderQuantity_CTE
GROUP BY ProductKey
ORDER BY ProductKey
;

WITH Update_CTE
AS (
   SELECT *
   FROM dbo.DimCustomerBakUpdate
   WHERE AddressLine2 IS NULL
   )
UPDATE Update_CTE
SET AddressLine2 = 'Unknown'
;
------------------------------------9 CASE Statement
USE AdventureWorks2014;
SELECT 
	e.JobTitle 
	--,e.Gender 
	,CASE WHEN e.Gender = 'M' THEN 'MALE'
		WHEN e.Gender = 'F' THEN 'FEMALE'
		ELSE 'Unknown'
	END	AS Gender_FullForm
	,CASE WHEN e.HireDate > '2011-01-01' THEN 'New Joiner'
		ELSE 'Old Employee'
	END AS Emp_Type	
FROM AdventureWorks2014.HumanResources.Employee e 
;
























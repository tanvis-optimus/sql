use db1_sqlbasic;


--#######################    RANKS          ######################################--
SELECT TOP 5 fname , salary , RANK() OVER(ORDER BY salary DESC) AS rank 
    FROM employee ;

SELECT TOP 5 fname , salary , DENSE_RANK() OVER(ORDER BY salary DESC) AS rank 
    FROM employee ;

SELECT TOP 5 fname , salary , ROW_NUMBER() OVER(ORDER BY salary DESC) AS rank 
    FROM employee ;


--#######################    CTE          ######################################--

WITH cte_alternatesal
AS (
        SELECT  fname , salary , ROW_NUMBER() OVER(ORDER BY salary DESC) AS ranks 
        FROM employee 
	)
SELECT TOP 5 fname , salary ,ranks  
  FROM cte_alternatesal WHERE ranks % 2 <>0 ;



WITH cte_alternatesal
AS (
        SELECT  fname , salary , ROW_NUMBER() OVER(ORDER BY salary DESC) AS ranks 
        FROM employee 
	)
SELECT TOP 5 fname , salary ,DENSE_RANK() OVER(ORDER BY salary DESC) AS rank  
  FROM cte_alternatesal WHERE ranks % 2 <>0 ;

  --#######################    ROLL UP AND CUBE          ######################################--

SELECT fname,designation,SUM(salary)
FROM employee
GROUP BY  ROLLUP(fname,designation);

SELECT fname,designation,SUM(salary)
FROM employee
GROUP BY  CUBE(fname,designation);

--#######################    AGGREGATE FUNCTIONS          ######################################--

SELECT MAX(salary)AS max_sal FROM employee
SELECT AVG(salary)AS avg_sal FROM employee
SELECT MIN(salary)AS min_sal FROM employee

--#######################    EXCEPT AND EXISTS          ######################################--
SELECT fname , designation
FROM   employee
EXCEPT
SELECT fname , designation
FROM   employee 
WHERE date_of_joining <= '2017-07-24'
ORDER BY fname

SELECT fname , lname
FROM employee
WHERE EXISTS (SELECT eid FROM employee WHERE eid IN (1,2,3) AND salary > 20000) ;








  
  select * from employee;
  select * from department
  
  
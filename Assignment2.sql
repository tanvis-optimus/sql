--**************************** CREATING TABLES *********************************
use db3_assignments;

CREATE TABLE t_emp
( 
Emp_id INT  IDENTITY(1001,2 ) PRIMARY KEY ,
Emp_Code VARCHAR(50),
Emp_f_name  VARCHAR(50) NOT NULL,
Emp_m_name VARCHAR(50),
Emp_l_name VARCHAR(50),
Emp_DOB DATE ,
Emp_DOJ   DATE NOT NULL,
CONSTRAINT chk_age CHECK (year(Emp_DOJ)-year(Emp_DOB) >=18 )
);



CREATE TABLE t_activity 
( 
Activity_id INT IDENTITY(1,1) PRIMARY KEY ,
Activity_description VARCHAR(40) 
);


CREATE TABLE t_atten_det
( 
Atten_id INT IDENTITY(1001,1),
Emp_id INT FOREIGN KEY REFERENCES t_emp(EMP_id),
Activity_id INT FOREIGN KEY REFERENCES t_activity(Activity_id),
Atten_start_datetime DATETIME,
Atten_end_hrs INT );


CREATE TABLE t_salary
( Salary_id INT,
EMP_id INT,
Changed_date DATE,
New_Salary INT );

--**************************** INSERTING VALUES *********************************

INSERT INTO t_emp (Emp_Code,Emp_f_name,Emp_l_name,Emp_DOB,Emp_DOJ ) 
VALUES ('OPT20110105','Manmohan','Singh','1983-02-10','2010-05-25');


-- ERROR IN THIS LINE AS DOJ CANT BE NULL
INSERT INTO t_emp (Emp_Code,Emp_f_name,Emp_m_name ,Emp_l_name,Emp_DOB ) 
VALUES('OPT20100915','Alfred','Joseph','Lawrence','1988-02-28');

-- ASSUMING DOJ AND INSERTING IT
INSERT INTO t_emp (Emp_Code,Emp_f_name,Emp_m_name ,Emp_l_name,Emp_DOB,Emp_DOJ ) 
VALUES('OPT20100915','Alfred','Joseph','Lawrence','1988-02-28','2011-06-12');
--ADDING DATA FOR QUERY 1
INSERT INTO t_emp (Emp_Code,Emp_f_name,Emp_l_name,Emp_DOB,Emp_DOJ ) 
VALUES('OPT20100915','Parul','Chauhan','1988-02-29','2012-07-17');

INSERT INTO t_activity (Activity_description) VALUES
('Code Analysis'),
('Lunch'),
('Coding'),
('Knowledge Transition'),
('Database');


INSERT INTO t_atten_det(Emp_id,Activity_id,Atten_start_datetime,Atten_end_hrs) 
VALUES 
(1001,5,'2011-02-13 10:00:00',2),
(1001,1,'2011-01-14 10:00:00',3),
(1001,3,'2011-01-14 13:00:00',5),
(1003,5,'2011-02-16 10:00:00',8),
(1003,5,'2011-02-17 10:00:00',8),
(1003,5,'2011-02-19 10:00:00',7);


INSERT INTO t_salary VALUES (1001,1003,'2011-2-16',20000);
INSERT INTO t_salary VALUES (1002,1003,'2011-1-5',25000);
INSERT INTO t_salary VALUES (1003,1001,'2011-2-16',26000);



SELECT * FROM t_emp
SELECT * FROM t_activity
SELECT * FROM t_atten_det
SELECT * FROM t_salary

DROP TABLE t_emp
DROP TABLE t_activity
DROP TABLE t_atten_det


--Display full name and date of birth those employees whose birth date falls in the last day of any month.


SELECT CONCAT(emp_f_name, ' ', (emp_m_name), ' ', emp_l_name) AS Name ,Emp_DOB
FROM t_emp WHERE Emp_DOB = EOMONTH(Emp_DOB)



--Display employee full name, got increment in salary?, previous salary, current salary, total worked hours , last worked activity and hours worked in that.



SELECT  TEMP.Name, TEMP.[Total Worked Hours], T5.Activity_description AS [Last Worked Activity], 
 		T4.Atten_end_hrs AS [Hours Worked ] FROM t_atten_det T4 INNER JOIN
(
SELECT T1.Emp_id ,CONCAT(T1.emp_f_name, ' ', (T1.emp_m_name), ' ', T1.emp_l_name) AS Name,
SUM(T2.Atten_end_hrs) AS [Total Worked Hours], MAX(T2.Atten_start_datetime) AS [Last Worked On]
FROM t_emp T1 
INNER JOIN t_atten_det T2 ON T1.Emp_id = T2.Emp_id
GROUP BY CONCAT(T1.emp_f_name, ' ', (T1.emp_m_name), ' ', T1.emp_l_name),T1.Emp_id
) TEMP
ON T4.Atten_start_datetime = TEMP.[Last Worked On]
INNER JOIN t_activity T5 ON T4.Activity_id = T5.Activity_id;



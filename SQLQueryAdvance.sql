use db1_sqlbasic;

insert into employee (fname,lname,gender,active,designation,salary) 
            values ('Danish','Zafar','M',1,'Tech lead',60000);
insert into employee (fname,lname,gender,active,designation,salary) 
            values ('Ali','Zafar','M',0,'Manager',75000);
insert into employee (fname,lname,gender,active,designation,salary) 
            values ('Akash','Goel','M',1,'Intern',20000);


--#######################    TOP SALARIES         ######################################--

--FIRST HIGHEST
select top 3 salary from employee order by salary desc;
--SECIND HIGHEST
select MAX(salary) from employee where salary < ( select MAX(salary) from employee ) ;
--THIRD HIGHEST
SELECT TOP 1 salary 
       FROM (select top 3 salary from employee order by salary desc) 
	   AS SAL ORDER BY salary ASC;
--#######################    LIKE,DISTINCT,IN,BETWEEN      ######################################--

SELECT * FROM employee WHERE fname LIKE 'A%' ; 
SELECT * FROM employee WHERE salary IN (15000,30000,45000) ;
SELECT * FROM employee WHERE salary BETWEEN 25000 AND 60000 ; 
SELECT DISTINCT salary AS EMPSAL FROM employee ; 


--**************************************************************************--

use db1_sqlbasic;

create table department(
dept_id int ,
dept_name varchar(50),
location varchar(50),
);

INSERT INTO DEPARTMENT VALUES (486,'Development','Canada');
INSERT INTO DEPARTMENT VALUES (556,'Accounts','Delhi');
INSERT INTO DEPARTMENT VALUES (332,'Testing','Bangalore');
INSERT INTO DEPARTMENT VALUES (119,'HR','Delhi');

select * from department;

alter table employee add dept_id int ;

update employee set dept_id = '486' where designation = 'Intern' ;
update employee set dept_id = '332' where designation = 'Trainee' ;
update employee set dept_id = '332' where fname = 'Danish' ;
update employee set dept_id = '556' where designation = 'Manager' ;
update employee set dept_id = null where designation = 'Manager' ;

--**************************************************************************--
--#######################    JOINS          ######################################--
SELECT e.fname , e.lname , d.dept_name 
FROM employee e LEFT JOIN department d ON e.dept_id = d.dept_id;

SELECT e.fname , e.lname , d.dept_name 
FROM employee e RIGHT JOIN department d ON e.dept_id = d.dept_id;


SELECT e.fname , e.lname , d.dept_name 
FROM employee e FULL OUTER JOIN department d ON e.dept_id = d.dept_id;

--**************************************************************************--
use db1_sqlbasic;

create table ABC(
emp_name varchar(50),
branch varchar(50),
);

create table XYZ(
emp_name varchar(50),
branch varchar(50),
);

create table LMN(
emp_name varchar(50),
branch varchar(50)
);

INSERT INTO ABC VALUES('Arnav','Delhi');
INSERT INTO ABC VALUES('Ankur','Noida');
INSERT INTO ABC VALUES('Tina','Canada');
INSERT INTO ABC VALUES('Natasha','Europe');

INSERT INTO XYZ VALUES('Ali','Dubai');
INSERT INTO XYZ VALUES('Momina','Iran');
INSERT INTO XYZ VALUES('Arijit','Indonesia');
INSERT INTO XYZ VALUES('Natasha','Canada');

INSERT INTO LMN VALUES('Sana','Europe');
INSERT INTO LMN VALUES('Parul','Delhi');
INSERT INTO LMN VALUES('Sneh','China');
INSERT INTO ABC VALUES('Tina','Europe');

--**************************************************************************--
--#######################  UNION AND JOINS        ######################################--
SELECT emp_name FROM ABC
UNION ALL
SELECT emp_name FROM XYZ
UNION ALL
SELECT emp_name FROM LMN
ORDER BY emp_name;


SELECT d.dept_name, COUNT(e.fname) AS NumberOfEmployees FROM department d
LEFT JOIN employee e ON e.dept_id = d.dept_id
GROUP BY d.dept_name;

SELECT d.dept_name, COUNT(e.fname) AS NumberOfEmployees FROM department d
LEFT JOIN employee e ON e.dept_id = d.dept_id
GROUP BY d.dept_name  HAVING COUNT(e.fname) >3;

--#######################    COPYING A TABLE         ######################################--

Select * into backupdb.dbo.EmployeeBackup from db1_sqlbasic.dbo.employee ;

--#######################   CONSTRAINTS        ######################################--
ALTER TABLE department ALTER COLUMN dept_id  INTEGER NOT NULL;

ALTER TABLE department
ADD PRIMARY KEY (dept_id);


CREATE TABLE cnst_table (
    id int NOT NULL  PRIMARY KEY,
    lname varchar(255) NOT NULL,
    fname varchar(255),
    age int CHECK (Age>=18),
	email varchar(100) UNIQUE,
	dept_id int,
	City varchar(50) DEFAULT 'Delhi',
	FOREIGN KEY (dept_id) REFERENCES department(dept_id)
);

CREATE UNIQUE INDEX u_index
ON employee (fname, lname);

--#######################    VIEWS         ######################################--

CREATE VIEW view1 AS
SELECT fname, salary
FROM employee
WHERE salary>=60000 AND designation = 'Manager';


SELECT * FROM view1 ;


ALTER TABLE employee
ADD date_of_joining DATE;

update employee set date_of_joining = '2018-01-24' where designation = 'Intern' ;
update employee set date_of_joining = '2017-10-19' where designation = 'Trainee' ;
update employee set date_of_joining = '2012-07-14' where designation = 'Tech Lead' ;
update employee set date_of_joining = '2015-04-30' where salary = 50000 AND active = 0;
update employee set date_of_joining = '2016-11-22' where fname = 'ALi';
update employee set date_of_joining = '2016-01-22' where fname = 'Divyank';
                                

ALTER VIEW view1 AS
SELECT fname, salary,date_of_joining
FROM employee
WHERE salary>=60000 AND designation = 'Manager';

SELECT * FROM view1 ;

create table designation(
name varchar(50),
id int
);

drop table designation;

alter table employee add designation_id int ;

update employee set designation_id = 4589 where designation = 'Intern';
update employee set designation_id = 4901 where designation = 'Trainee';
update employee set designation_id = 3773 where designation = 'Tech Lead';
update employee set designation_id = 5241 where designation = 'Manager';

create table designation(
name varchar(50),
des_id int
PRIMARY KEY (des_id)
);

INSERT INTO designation VALUES ('Intern',4589);
INSERT INTO designation VALUES ('Trainee',4901);
INSERT INTO designation VALUES ('Tech Lead',3773);
INSERT INTO designation VALUES ('Manager',5241);

select * from designation;


ALTER TABLE employee
ADD CONSTRAINT FK_employee
FOREIGN KEY (designation_id) REFERENCES designation(des_id);

SELECT FORMAT (GETDATE(), 'ddd  dd MMM yy , hh:mm tt');

ALTER TABLE employee ADD pf DECIMAL(10,2) ;
update employee set pf = (salary*0.1275 );





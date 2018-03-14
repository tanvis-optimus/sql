use db1_sqlbasic;

create table employee(
eid int IDENTITY(1,1),
fname varchar(50),
lname varchar(50),
gender character,
active bit);

select * from employee;

insert into employee (fname,lname,gender,active) 
             values ('Maya','Sabharwal','F',1);

alter table employee add designation varchar(50) ;

update employee set designation = 'Trainee' where active = 0 ;

select fname,lname,designation from employee;

select DISTINCT designation from employee ;

alter table employee add salary int ;

update employee set salary = 15000 where designation = 'Intern';

update employee set salary = 30000 where designation = 'Trainee';

insert into employee (fname,lname,gender,active,designation,salary)  
              values ('Sonal','Bhatia','F',1,'Trainee',45000);

insert into employee (fname,lname,gender,active,designation,salary) 
            values ('Charul','Kumar','F',0,'Developer',50000);

insert into employee (fname,lname,gender,active,designation,salary) 
            values ('Divyank','Chhabra','M',1,'Manager',60000);

select * from employee where salary < 20000;

alter table employee add age int ;

update employee set age = 24 where designation = 'Intern';

update employee set age = 36 where designation = 'Developer';

update employee set age = 27 where designation = 'Trainee';

update employee set age = 32 where fname = 'Divyank';

select * from employee where salary > 50000 AND age < 35;

select * from employee where salary > 50000 AND designation IN ('Manager','Tech Lead');

select top 5 * from employee order by salary desc;

alter table employee add constraint df_age DEFAULT 18 for age ; 

alter table employee add constraint df_desg DEFAULT 'Trainee' for designation ; 

insert into employee (fname,lname,gender,active,salary) 
            values ('Sakshi','Hans','M',1,60000);

update employee set salary = 50000 , designation = 'Manager' where salary >40000 ;


delete from employee where designation = 'Trainee' And active= 1;
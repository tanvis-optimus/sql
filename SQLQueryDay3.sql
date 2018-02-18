use db1_sqlbasic;

SELECT fname,lname,age ,salary ,"Verdict" = 
CASE 
       WHEN salary >= 50000 THEN 'Yes'
	   WHEN age < 35  THEN 'Yes' 
	   ELSE 'No' 
END
FROM employee


UPDATE employee
SET age = 
( CASE 
      WHEN salary > = 50000 THEN age +1 
	  ELSE age-2
END)

--#############################################################################################--

CREATE TABLE product
( 
 productid INT NOT NULL PRIMARY KEY,
 name VARCHAR(50),
 unitprice INT,
 qty_available INT
)

sp_Rename 'SALE.productid','s_productid','Column';


Insert into product values(1, 'Laptops', 2340, 100)
Insert into product values(2, 'Desktops', 3467, 50)


CREATE TABLE sale
( 
 salesid INT NOT NULL PRIMARY KEY,
 productid INT,
 qty_sold INT
)

select * from sale
select * from product

Alter PROCEDURE spSellProduct
@ProductId int,
@QuantityToSell int
AS
BEGIN
 
 Declare @StockAvailable int
 Select @StockAvailable = qty_available
 from product where productid = @ProductId
 

 IF(@StockAvailable < @QuantityToSell)
   BEGIN
  RAISERROR('Not enough stock available',16,1)
   END

 ELSE
   BEGIN
    Begin Try
     Begin Transaction
         
          Update product set qty_available= (qty_available - @QuantityToSell)
          where productid = @ProductId
  
          Declare @MaxProductSalesId int

           Select @MaxProductSalesId = 
             Case 
               When MAX(s_productid) IS NULL Then 0 
               else MAX(s_productid) 
             end 
            from sale
            --Set @MaxProductSalesId = @MaxProductSalesId + 1

            Insert into sale values(@MaxProductSalesId, @ProductId, @QuantityToSell)
       Commit Transaction
     End Try
    Begin Catch 
       Rollback Transaction
         Select 
          ERROR_NUMBER() as ErrorNumber,
          ERROR_MESSAGE() as ErrorMessage,
          ERROR_PROCEDURE() as ErrorProcedure,
          ERROR_STATE() as ErrorState,
          ERROR_SEVERITY() as ErrorSeverity,
          ERROR_LINE() as ErrorLine
    End Catch 
   End
End

spSellProduct 1,10

--#############################################################################################--


SELECT eid , fname,CONVERT(NVARCHAR , date_of_joining , 103 )AS jdate FROM employee

SELECT fname,SALARY , CONVERT(NVARCHAR , date_of_joining , 105 )AS jdate FROM employee

SELECT eid , fname,cast(eid AS NVARCHAR(10) )AS EMPID FROM employee

ALTER TABLE employee ADD projects int;
update employee set projects= 1 where designation = 'Intern';
update employee set projects = 2 where designation = 'Trainee';
update employee set projects = 5 where designation = 'Manager';



SELECT ISNULL(SUM(employee.projects), 0) FROM employee


CREATE FUNCTION fn_leapyear(@year int)
RETURNS varchar(50)
AS
BEGIN
    IF(@year%4 = 0)
	  RETURN 'leap year'
    
	  RETURN 'not a leap year'
END

SELECT dbo.fn_leapyear(2001) AS type_of_year


CREATE PROCEDURE sp_empinfo
@emloyee_id int
AS 
BEGIN
 SELECT * FROM employee e FULL OUTER JOIN department d ON e.dept_id = d.dept_id 
       WHERE e.eid = @emloyee_id
END

sp_empinfo 1


SELECT fname ,TechLead,Intern,Trainee,Manager 
FROM employee 
PIVOT
(
   COUNT(eid)
  FOR designation
  IN(TechLead,Intern,Trainee,Manager  ) 
)AS pivot_table


ALTER TABLE employee ADD PF_2 int;

DECLARE @ProductId int

DECLARE cursor_updateemployee CURSOR FOR 
SELECT eid FROM	employee

OPEN cursor_updateemployee

FETCH NEXT FROM cursor_updateemployee INTO @ProductId
While(@@FETCH_STATUS = 0)
Begin
 
 update employee set PF_2= 2*pf ;
 
 Fetch Next from cursor_updateemployee into @ProductId 
End

CLOSE cursor_updateemployee 
DEALLOCATE cursor_updateemployee

select * from employee;


ALTER TABLE employee ADD gross int;



CREATE TRIGGER tr_EMployee_Insert
ON employee
FOR INSERT
AS
BEGIN
 Declare @Id int
 Select @Id = eid from inserted
 
  update employee set gross= pf+PF_2 WHERE eid = @Id ;

END


insert into employee 
  (fname,lname,gender,active,designation,salary,dept_id,date_of_joining,designation_id,pf,projects,pf_2) 
  values ('Mark','Mars','M',1,'TechLead',77000,119,'2000-07-29',3773,9432.5,3,18865)

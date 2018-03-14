--**************************** CREATING TABLES *********************************

use db3_assignments;

--TABLE : PRODUCT
CREATE TABLE t_product_master
( Product_ID VARCHAR(10),
Product_Name VARCHAR(30),
Cost_Per_Item INT );

-- TABLE : USER
CREATE TABLE t_user_master
( 
userID VARCHAR(10),
UserName VARCHAR(40) );

--TABLE : TRANSACTION
CREATE TABLE t_transaction
( UserID VARCHAR(10), 
Product_ID VARCHAR(10),
Transaction_date DATE,
Transaction_Type VARCHAR(30),
Transaction_Amount INT );

drop table t_transaction
drop table t_user_master
drop table t_product_master

--**************************** INSERTING VALUES *********************************

INSERT INTO t_product_master VALUES ('P1','Pen',10);
INSERT INTO t_product_master VALUES ('P2','Scale',15);
INSERT INTO t_product_master VALUES ('P3','Note Book',25);

INSERT INTO t_user_master VALUES ('U1','Alfred Lawrence');
INSERT INTO t_user_master VALUES ('U2','William Paul');
INSERT INTO t_user_master VALUES ('U3','Edward Fillip');

INSERT INTO t_transaction VALUES ('U1','P1','2010-10-25','Order',150);
INSERT INTO t_transaction VALUES ('U1','P1','2010-11-20','Payment',750);
INSERT INTO t_transaction VALUES ('U1','P1','2010-11-20','Order',200);
INSERT INTO t_transaction VALUES ('U1','P3','2010-11-25','Order',50);
INSERT INTO t_transaction VALUES ('U3','P2','2010-11-26','Order',100);
INSERT INTO t_transaction VALUES ('U2','P1','2010-12-15','Order',75);
INSERT INTO t_transaction VALUES ('U3','P2','2011-01-15','Payment',250);


SELECT * FROM t_transaction;

SELECT * FROM t_product_master;

SELECT * FROM t_user_master;



--**************************** QUESTION 1 *********************************

CREATE TABLE TEMP1
 (
 Uid varchar(50),
 Pid varchar(50),
 Pname varchar(50),
 Orderqty int,
 totalamt int,
 Last_Transaction_Date date
 );
 

INSERT INTO TEMP1 
SELECT T.UserID , T.Product_ID, P.Product_Name,SUM(T.Transaction_Amount) AS QUANTITY , 
SUM (T.Transaction_Amount * P.Cost_Per_Item) AS TOTAL_AMOUNT,
max(Transaction_date) AS Last_Transaction_Date
FROM t_transaction T INNER JOIN t_product_master P ON
T.Product_ID =  P.Product_ID
WHERE T.Transaction_Type = 'Order'
GROUP BY UserID,T.Product_ID,P.Product_Name ;

SELECT * FROM TEMP1;

CREATE TABLE TEMP2
 (
 uid varchar(50),
 pid varchar(50),
payment int
 );


insert into temp2
SELECT T.UserID , TP.PID ,T.Transaction_Amount 
FROM t_transaction T INNER JOIN TEMP1 TP on
 T.Product_ID = TP.PID AND T.UserID = TP.UID AND
T.Transaction_Type = 'Payment';

select * from temp2


CREATE TABLE TEMP3
 (
 Uid varchar(50),
 Product_Name varchar(50),
 Ordered_Quantity int,
 Amount_Paid int,
  Last_Transaction_Date date,
 balance int
 );
 

INSERT into temp3 
 select temp1.uid,temp1.pname,temp1.Orderqty,coalesce(temp2.payment,0),temp1.Last_Transaction_Date,
 coalesce(temp1.totalamt-temp2.payment,temp1.totalamt)
 from temp1 left join temp2 
 on temp1.uid =temp2.uid and temp1.pid =temp2.pid;
 
 select * from temp3;

 --**********************FINAL ANSWER***************************

SELECT U.UserName ,T.Product_Name,T.Ordered_Quantity,T.Amount_Paid,
 FORMAT(T.Last_Transaction_Date, 'dd-MM-yyyy')AS Last_Transaction_Date,T.balance 
 FROM TEMP3 T INNER JOIN t_user_master U ON 
 T.UID = U.userID ;






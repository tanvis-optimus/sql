use db2_sqlTest;
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ SECTION A @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

--  creating tables

CREATE TABLE TRAIN_DETAILS (
TRAIN_ID INT NOT NULL PRIMARY KEY,
TRAIN_NAME VARCHAR(50)
)


CREATE TABLE STATION_DETAILS (
STATION_ID INT NOT NULL PRIMARY KEY,
STATION_NAME VARCHAR(50)
)


CREATE TABLE JOURNEY_DETAILS (
TRAIN_ID INT NOT NULL,
STATION_ID INT NOT NULL,
DISTANCE INT,
SCHEDULED_ARRIVAL SMALLDATETIME,
DEPARTURE SMALLDATETIME
)


-- INSERTING VALUES

INSERT INTO TRAIN_DETAILS VALUES
     (11404 , 'Shatabdi'),
	 (22505,'Rajdhani'),
	 (33606,'Passenger') ;

INSERT INTO STATION_DETAILS VALUES
     (101 , 'Delhi'),
	 (102,'Aligarh'),
	 (103,'Lucknow'),
	 (104,'Kanpur')  ;
	 	
INSERT INTO JOURNEY_DETAILS (TRAIN_ID,STATION_ID,DISTANCE,DEPARTURE)
   VALUES (11404,101,0,'2012-01-25 03:00:00')
INSERT INTO JOURNEY_DETAILS (TRAIN_ID,STATION_ID,DISTANCE,SCHEDULED_ARRIVAL)
     VALUES (11404,103,750,'2012-01-25 09:30:00')
INSERT INTO JOURNEY_DETAILS (TRAIN_ID,STATION_ID,DISTANCE,DEPARTURE)
   VALUES (22505,101,0,'2012-01-25 15:04:00')
INSERT INTO JOURNEY_DETAILS (TRAIN_ID,STATION_ID,DISTANCE,SCHEDULED_ARRIVAL,DEPARTURE)
    VALUES (22505,102,225,'2012-01-25 05:30:00','2012-01-25 06:00:00')
INSERT INTO JOURNEY_DETAILS (TRAIN_ID,STATION_ID,DISTANCE,SCHEDULED_ARRIVAL,DEPARTURE)
    VALUES (22505,104,150,'2012-01-25 07:10:00','2012-01-25 07:50:00')
INSERT INTO JOURNEY_DETAILS (TRAIN_ID,STATION_ID,DISTANCE,SCHEDULED_ARRIVAL)
     VALUES (22505,103,100,'2012-01-25 08:30:00')
INSERT INTO JOURNEY_DETAILS (TRAIN_ID,STATION_ID,DISTANCE,DEPARTURE)
   VALUES (33606,102,0,'2012-01-25 10:45:00')
INSERT INTO JOURNEY_DETAILS (TRAIN_ID,STATION_ID,DISTANCE,SCHEDULED_ARRIVAL,DEPARTURE)
    VALUES (33606,104,150,'2012-01-25 13:20:00','2012-01-25 13:45:00')
INSERT INTO JOURNEY_DETAILS (TRAIN_ID,STATION_ID,DISTANCE,SCHEDULED_ARRIVAL)
     VALUES (33606,103,100,'2012-01-25 17:20:00')

--DISPLAYING VALUES 

SELECT * FROM TRAIN_DETAILS 
SELECT * FROM STATION_DETAILS
SELECT * FROM JOURNEY_DETAILS



 SELECT TRAIN_ID,STATION_ID,DISTANCE,        
	   FORMAT(SCHEDULED_ARRIVAL, 'dd/MM/yyyy hh:mm:ss')AS SCHEDULED_ARRIVAL,
	   FORMAT(DEPARTURE, 'dd/MM/yyyy hh:mm:ss')AS DEPARTURE
 FROM JOURNEY_DETAILS


 --************** QUESTION 1
-- Write an SQL which gives the route map for each train and also the total distance (in KM) covered by each train 
--and their average speed (In Km/hr) during the journey, as shown below
--  TrainName  StationName  Distance  Avg.Speed
--   XYZ           A,B,C       120       25.6





 SELECT TRAIN_NAME  ,
(SELECT SUM(DISTANCE) FROM JOURNEY_DETAILS WHERE TRAIN_ID = TRAIN_DETAILS.TRAIN_ID) AS DISTANCE ,
(SELECT dbo.fn_ROUTE(TRAIN_DETAILS.TRAIN_ID) )AS T_ROUTE
FROM TRAIN_DETAILS 




CREATE FUNCTION fn_ROUTE(@TRAIN int)
RETURNS varchar(150)
AS
BEGIN
DECLARE @STN VARCHAR(8000) 
SELECT @STN = COALESCE(@STN + ', ', '') +  (SELECT STATION_NAME FROM STATION_DETAILS WHERE STATION_ID =JOURNEY_DETAILS.STATION_ID) 
FROM JOURNEY_DETAILS
WHERE TRAIN_ID = @TRAIN


    RETURN (@STN) 
END
 

 --***************************************ROUGH**************************
----ROUTE


DECLARE @STN VARCHAR(8000) 
SELECT @STN=COALESCE(@STN + ', ', '') +  CAST(STATION_ID as varchar(10)) 
FROM JOURNEY_DETAILS
WHERE TRAIN_ID = 11404

PRINT @STN
---------------------------------
DECLARE @STN VARCHAR(8000) 
SELECT @STN = COALESCE(@STN + ', ', '') +  (SELECT STATION_NAME FROM STATION_DETAILS WHERE STATION_ID =JOURNEY_DETAILS.STATION_ID) 
FROM JOURNEY_DETAILS
WHERE TRAIN_ID = 11404

PRINT @STN
-----------------------------------------
 SELECT DISTINCT J.STATION_ID ,S.STATION_NAME 
FROM JOURNEY_DETAILS J INNER JOIN STATION_DETAILS S
 ON J.STATION_ID = S.STATION_ID


 
-------

WITH cte_TIME
AS (
         SELECT TRAIN_ID  , 
		 CONVERT(VARCHAR(8),SCHEDULED_ARRIVAL , 108)  as TIME1 ,
		 CONVERT(VARCHAR(8),DEPARTURE , 108)  as TIME2 
FROM JOURNEY_DETAILS 

	)
SELECT TRAIN_ID ,
 DATEDIFF(HOUR, ISNULL(TIME2, 0), ISNULL(TIME1, 0)) as TTH ,
 DATEDIFF(MINUTE, ISNULL(TIME2, 0), ISNULL(TIME1, 0)) as TTM 
  FROM cte_TIME WHERE TRAIN_ID=33606 ;

  --*****************************************ROUGH END*******************************

  ---------question 2 -------------------------------------------------------
  --Write an SQL query which gives following result.

-----1---------
--Name of the train which covered the maximum distance during its journey.

WITH cte_max (TRAIN_NAME,DISTANCE,T_ROUTE)
AS (
          SELECT TRAIN_NAME  ,
(SELECT SUM(DISTANCE) FROM JOURNEY_DETAILS WHERE TRAIN_ID = TRAIN_DETAILS.TRAIN_ID) AS DISTANCE ,
(SELECT dbo.fn_ROUTE(TRAIN_DETAILS.TRAIN_ID) )AS T_ROUTE
FROM TRAIN_DETAILS 


	)
 SELECT TRAIN_NAME ,Max(DISTANCE)   AS Max_DISTANCE
FROM cte_max  

-----3------------------
--Name those trains which stop at least at three stations.

SELECT TRAIN_NAME 
FROM 
(SELECT J.TRAIN_ID AS TEMP ,COUNT (J.TRAIN_ID) AS NO_OF_STNS 
  FROM JOURNEY_DETAILS J INNER JOIN TRAIN_DETAILS T 
  ON J.TRAIN_ID = T.TRAIN_ID GROUP BY J.TRAIN_ID ) Y
INNER JOIN TRAIN_DETAILS X ON X.TRAIN_ID = Y.TEMP WHERE Y.NO_OF_STNS >=3;


-----4---------------------
--Name those trains whose stoppage is not Aligarh and Kanpur.


WITH cte_STOPPAGE
AS (
          SELECT TRAIN_NAME  ,
(SELECT SUM(DISTANCE) FROM JOURNEY_DETAILS WHERE TRAIN_ID = TRAIN_DETAILS.TRAIN_ID) AS DISTANCE ,
(SELECT dbo.fn_ROUTE(TRAIN_DETAILS.TRAIN_ID) )AS T_ROUTE
FROM TRAIN_DETAILS 	)
 SELECT DISTINCT TRAIN_NAME   
FROM cte_STOPPAGE 
WHERE T_ROUTE NOT like'%Aligarh%Kanpur%'



  ------------------------QUESTION 3 ---------------------
 -- Write an SQL query which results out the boarding and destination station name for each train as shown below.
 
--     TrainID  TrainName  Boarding   Destination
--       111         A         Delhi    Aligarh
--       222         B        Aligarh     Delhi


  --INDIVIDUAL COLUMNS
  SELECT DISTINCT J.TRAIN_ID , T.TRAIN_NAME 
  FROM JOURNEY_DETAILS J INNER JOIN TRAIN_DETAILS T
 ON J.TRAIN_ID = T.TRAIN_ID
 
 SELECT DISTINCT J.STATION_ID , J.TRAIN_ID ,S.STATION_NAME AS BOARDING
FROM JOURNEY_DETAILS J INNER JOIN STATION_DETAILS S
 ON J.STATION_ID = S.STATION_ID
  WHERE J.SCHEDULED_ARRIVAL IS NULL
  ----------------------
 SELECT DISTINCT J.STATION_ID , J.TRAIN_ID ,S.STATION_NAME AS DESTINATION
FROM JOURNEY_DETAILS J INNER JOIN STATION_DETAILS S
 ON J.STATION_ID = S.STATION_ID
  WHERE J.DEPARTURE IS NULL

  --------------------------------
  --TRYING TO JOIN

  SELECT J.TRAIN_ID, T.TRAIN_NAME, S.STATION_NAME AS BOARDING ,S.STATION_NAME AS DESTINATION
FROM (( JOURNEY_DETAILS J INNER JOIN TRAIN_DETAILS T
 ON J.TRAIN_ID = T.TRAIN_ID)
INNER JOIN STATION_DETAILS S
 ON J.STATION_ID = S.STATION_ID)
  WHERE J.SCHEDULED_ARRIVAL IS NULL and  J.DEPARTURE IS NULL ;

  --TRYING TO JOIN

  SELECT J.TRAIN_ID, T.TRAIN_NAME, S.STATION_NAME AS BOARDING ,
  (SELECT S.STATION_NAME   WHERE J.DEPARTURE IS NULL) AS DESTINATION
FROM (( JOURNEY_DETAILS J INNER JOIN STATION_DETAILS S
 ON J.STATION_ID = S.STATION_ID)
INNER JOIN TRAIN_DETAILS T
 ON J.TRAIN_ID = T.TRAIN_ID)
  WHERE  J.DEPARTURE IS NULL  ;

  ---------------------------------------------------------------------------------------
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ SECTION B @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@




--An organization names “Optimus  Information Inc.”, has 3 department , HR, Development and Testing.
--Each Department work around several activities for which they are assigned. In Development and testing, 
--each department has at least 3 projects and each project have at least 2 Engineers. 
--Every engineer updates the total number of hours spends in each project daily.

--Based on the above scenario answer the following:
--Create a schema for this scenario which covers all the information related 
--to each department in Optimus.


 create table Department(
Dept_id int Primary Key NOT null,
Dept_name varchar(20),
Num_of_Projects int not null check (Num_of_Projects>2)
);

create table Project(
Project_id int Primary key not null,
Project_name varchar(50) not null,
Project_Dept varchar(20)
)

create table Engineer(
Eng_id int  not null,
Eng_name varchar(30),
proj_id int,
Num_of_hrs int ,
Dept_id int
)



Insert into Department values(101, 'HR', 3);
Insert into Department values(102, 'Developer', 4);
Insert into Department values(103, 'Testing', 3);
Insert into Project values(1, 'Logo', 'HR');
Insert into Project values(2, 'Enigma', 'HR');
Insert into Project values(3, 'Captum', 'Developer');
Insert into Engineer values(301, 'Paul', 1, 76,101);
Insert into Engineer values(302, 'Niel', 2, 90,102);
Insert into Engineer values(303, 'John', 3, 82 , 103);
Insert into Engineer values(301, 'Paul', 2, 4,102);
Insert into Engineer values(301, 'Paul', 3, 2,103);

SELECT * FROM Engineer
SELECT * FROM Department
SELECT * FROM Project


--One day the manager of the company ask you to write an SQL query which displays the 
--total number of hours spent as

--Each engineer in their respective project.
--no of hours by each employee

SELECT Eng_name ,SUM(Num_of_hrs) as hrs 
FROM Engineer GROUP BY  Eng_name

--Each project in their respective department
--no of hrs on each project

SELECT proj_id ,SUM(Num_of_hrs) as hrs 
FROM Engineer GROUP BY  proj_id



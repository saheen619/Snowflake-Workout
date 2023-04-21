CREATE DATABASE MASTER_DB;

USE DATABASE MASTER_DB;

CREATE SCHEMA IF NOT EXISTS MASTER_SCHEMA
WITH MANAGED ACCESS
MAX_DATA_EXTENSION_TIME_IN_DAYS = 14;


---------------------------------------------------------------------------------------------------------
CREATE OR REPLACE TABLE COMPLAINS
(
 ID INT,
 ComplainDate VARCHAR(10),
 CompletionDate	VARCHAR(10),
 CustomerID	INT,
 BrokerID	INT,
 ProductID	INT,
 ComplainPriorityID	INT,
 ComplainTypeID	INT,
 ComplainSourceID	INT,
 ComplainCategoryID	INT,
 ComplainStatusID	INT,
 AdministratorID	STRING,
 ClientSatisfaction	VARCHAR(20),
 ExpectedReimbursement INT
);
---------------------------------------------------------------------------------------------------------


CREATE OR REPLACE TABLE CUSTOMER
(
CustomerID	INT,
LastName VARCHAR(60),
FirstName VARCHAR(60),
BirthDate VARCHAR(20) ,
Gender VARCHAR(20),
ParticipantType	VARCHAR(20),
RegionID	INT,
MaritalStatus VARCHAR(15));

---------------------------------------------------------------------------------------------------------
CREATE OR REPLACE TABLE BROKER
(
  BrokerID	INT,
  BrokerCode VARCHAR(70),
  BrokerFullName	VARCHAR(60),
  DistributionNetwork	VARCHAR(60),
  DistributionChannel	VARCHAR(60),
  CommissionScheme VARCHAR(50)
);

---------------------------------------------------------------------------------------------------------
CREATE OR REPLACE TABLE CATAGORIES
(
ID	INT,
Description_Categories VARCHAR2(200),
Active INT
);
---------------------------------------------------------------------------------------------------------

CREATE OR REPLACE TABLE PRIORITIES
(
ID	INT,
Description_Priorities VARCHAR(10)
);

---------------------------------------------------------------------------------------------------------
CREATE OR REPLACE TABLE PRODUCT
(
ProductID	INT,
ProductCategory	VARCHAR(60),
ProductSubCategory	VARCHAR(60),
Product VARCHAR(30)
);

---------------------------------------------------------------------------------------------------------
CREATE OR REPLACE TABLE REGION
(
  id INT,
  name	VARCHAR(50) ,
  county	VARCHAR(100),
  state_code	CHAR(5),
  state	VARCHAR (60),
  type	VARCHAR(50),
  latitude	NUMBER(11,4),
  longitude	NUMBER(11,4),
  area_code	INT,
  population	INT,
  Households	INT,
  median_income	INT,
  land_area	INT,
  water_area	INT,
  time_zone VARCHAR(70)
);

---------------------------------------------------------------------------------------------------------
CREATE OR REPLACE TABLE SOURCES
(
ID	INT,
Description_Source VARCHAR(20)
);

---------------------------------------------------------------------------------------------------------
CREATE OR REPLACE TABLE STATE_REGION
(
  State_Code VARCHAR(20),	
  State	 VARCHAR(20),
  Region VARCHAR(20)
);
---------------------------------------------------------------------------------------------------------
CREATE OR REPLACE TABLE STATUSES
(
  ID	INT,
  Description_Status VARCHAR(40)
);

---------------------------------------------------------------------------------------------------------
CREATE OR REPLACE TABLE TYPE
(
  ID INT	,
  Description_Type VARCHAR(20)
);


-------------------------------------------------------------------------------------------------------
-- Loaded Data into respective tables
-------------------------------------------------------------------------------------------------------
DESCRIBE TABLE COMPLAINS;

SELECT * FROM COMPLAINS LIMIT 5;    -- PK ID
SELECT * FROM CUSTOMER;     -- CUSTOMERID
SELECT * FROM BROKER;       -- BROCKERID
SELECT * FROM CATAGORIES;   -- ID
SELECT * FROM PRIORITIES;   -- ID
SELECT * FROM PRODUCT;      -- PRODUCTID
SELECT * FROM REGION;       -- ID
SELECT * FROM SOURCES;      -- ID
SELECT * FROM STATE_REGION; -- STATE_CODE
SELECT * FROM STATUSES;     -- ID
SELECT * FROM TYPE;         -- ID

-------------------------------------------------------------------------------------------------------
CREATE OR REPLACE TABLE CUST_MASTER AS
SELECT COM.ID, COM.ComplainDate, COM.CompletionDate,
CUS.FirstName, CUS.LastName, CUS.Gender, 
BR.BrokerFullName, BR.CommissionScheme,
CAT.Description_Categories, ST.Description_Status,
SR.Region, REG.state, PR.Product, PRI.Description_Priorities, 
SUR.Description_Source, TY.Description_Type
FROM COMPLAINS COM 
LEFT OUTER JOIN CUSTOMER CUS ON COM.CustomerID = CUS.CustomerID
LEFT OUTER JOIN REGION REG ON CUS.RegionID = REG.id
LEFT OUTER JOIN STATE_REGION SR ON REG.state_code = SR.State_Code
LEFT OUTER JOIN BROKER BR ON COM.BrokerID = BR.BrokerID
LEFT OUTER JOIN CATAGORIES CAT ON COM.ComplainCategoryID = CAT.ID
LEFT OUTER JOIN PRIORITIES PRI ON COM.ComplainPriorityID = PRI.ID
LEFT OUTER JOIN PRODUCT PR ON COM.ProductID = PR.ProductID
LEFT OUTER JOIN SOURCES SUR ON COM.ComplainSourceID = SUR.ID
LEFT OUTER JOIN STATUSES ST ON COM.ComplainStatusID = ST.ID
LEFT OUTER JOIN TYPE TY ON COM.ComplainTypeID = TY.ID;


SELECT * FROM CUST_MASTER LIMIT 50;

SELECT * FROM CUST_MASTER WHERE CompletionDate IS NULL;
SELECT * FROM CUST_MASTER WHERE CompletionDate = 'NULL';            -- Its a Hardcoded value of NULL
SELECT COUNT(*) FROM CUST_MASTER WHERE CompletionDate = 'NULL'; 


SELECT * FROM CUST_MASTER WHERE FirstName IS NULL;                  -- Here, the NULL is a dynamic value, which came because of the joining operation.
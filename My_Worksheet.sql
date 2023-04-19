USE WAREHOUSE COMPUTE_WH;


SHOW DATABASES;


USE DATABASE SAHEEN_DB;


--THIS IS A SINGLE LINE COMMENT 

/* THIS IS A MULTI LINE COMMENT.
IT CAN GO MULTIPLE LINES
THUS ENHANCES CODE READIBILITY  */


CREATE TABLE AGENTS 
   (	
    "AGENT_CODE" CHAR(6) NOT NULL PRIMARY KEY, 
	"AGENT_NAME" CHAR(40), 
	"WORKING_AREA" CHAR(35), 
	"COMMISSION" NUMBER(10,2) DEFAULT 0.05, 
	"PHONE_NO" CHAR(15), 
	"COUNTRY" VARCHAR2(25)
	 );
     
DROP TABLE AGENTS;

SELECT * FROM AGENTS;

-- Approch 1
INSERT INTO AGENTS VALUES ('A007', 'Ramasundar', 'Bangalore', '0.15', '077-25814763', ''),('A003', 'Alex ', 'London', '0.13', '075-12458969', '');

-- Approch 2
INSERT INTO AGENTS VALUES ('A008', 'Alford', 'New York', '0.12', '044-25874365', '');
INSERT INTO AGENTS VALUES ('A011', 'Ravi Kumar', 'Bangalore', '0.15', '077-45625874', '');
INSERT INTO AGENTS VALUES ('A010', 'Santakumar', 'Chennai', '0.14', '007-22388644', '');
INSERT INTO AGENTS VALUES ('A012', 'Lucida', 'San Jose', '0.12', '044-52981425', '');
INSERT INTO AGENTS VALUES ('A005', 'Anderson', 'Brisban', '0.13', '045-21447739', '');
INSERT INTO AGENTS VALUES ('A001', 'Subbarao', 'Bangalore', '0.14', '077-12346674', '');
INSERT INTO AGENTS VALUES ('A002', 'Mukesh', 'Mumbai', '0.11', '029-12358964', '');
INSERT INTO AGENTS VALUES ('A004', 'Ivan', 'Torento', '0.15', '008-22544166', '');
INSERT INTO AGENTS VALUES ('A009', 'Benjamin', 'Hampshair', '0.11', '008-22536178', '');

-- Inserting values without giving the commission field to see if the default value has been inserted.
INSERT INTO AGENTS("AGENT_CODE","AGENT_NAME","WORKING_AREA","PHONE_NO","COUNTRY") VALUES ('A619', 'SAHEEN', 'KOCHI', '008-22565281', '');

--Partial insertion of selected columns only.
INSERT INTO AGENTS("AGENT_CODE","AGENT_NAME","WORKING_AREA") VALUES ('A916', 'AHZAN', 'TVM');


-- CREATE A TABLE AND UPLOAD DATA FROM YOUR COMPUTER


CREATE OR REPLACE TABLE CONSUMER_COMPLAINTS
(
DATE_RECEIVED STRING,
PRODUCT_NAME VARCHAR2(50),
SUB_PRODUCT VARCHAR2(100),
ISSUE VARCHAR2(100),
SUB_ISSUE VARCHAR2(100),
CONSUMER_COMPLAINT_NARRATIVE VARCHAR2,
Company_Public_Response STRING,
Company VARCHAR(100),
State_Name CHAR(4),
Zip_Code string,
Tags VARCHAR(50),
Consumer_Consent_Provided CHAR(25),
Submitted_via STRING,
Date_Sent_to_Company STRING,
Company_Response_to_Consumer VARCHAR(40),
Timely_Response CHAR(4),
CONSUMER_DISPUTED CHAR(4),
COMPLAINT_ID NUMBER(12,0) NOT NULL PRIMARY KEY
);

--CSV file has been loaded into the created table in the database

DROP TABLE CONSUMER_COMPLAINTS;

SELECT * FROM CONSUMER_COMPLAINTS LIMIT 5;

SELECT COUNT(DISTINCT PRODUCT_NAME) FROM CONSUMER_COMPLAINTS;

SELECT DISTINCT PRODUCT_NAME FROM CONSUMER_COMPLAINTS;

SELECT * FROM CONSUMER_COMPLAINTS WHERE COMPANY = 'Wells Fargo & Company';

SELECT COUNT(*) FROM CONSUMER_COMPLAINTS WHERE COMPANY = 'Wells Fargo & Company';

SELECT * FROM CONSUMER_COMPLAINTS WHERE COMPANY = 'Wells Fargo & Company';

SELECT COUNT(*) FROM CONSUMER_COMPLAINTS WHERE COMPANY = 'Wells Fargo & Company';

SELECT COMPANY, MIN(DATE_RECEIVED), MAX(DATE_RECEIVED) FROM CONSUMER_COMPLAINTS GROUP BY (COMPANY) ORDER BY 1;

SELECT SUBMITTED_VIA, COUNT(SUBMITTED_VIA) FROM CONSUMER_COMPLAINTS GROUP BY 1;



-- WRITE A QUERY TO FIND THE COUNT OF COMPLAINTS RECIEVED IN EACH PRODUCT FOR ALL THE COMPANIES

SELECT PRODUCT_NAME, COUNT(DISTINCT COMPLAINT_ID) FROM CONSUMER_COMPLAINTS GROUP BY 1;



-- WRITE A QUERY TO FIND THE COUNT OF COMPLAINTS RECIEVED IN EACH PRODUCT FOR ALL THE COMPANIES WHERE COUNT OPF COMPLAINTS IS MORE THAN 30

SELECT COMPANY, PRODUCT_NAME, COUNT(DISTINCT COMPLAINT_ID) AS COMPLAINT_COUNT
FROM CONSUMER_COMPLAINTS 
GROUP BY 1,2 
HAVING COMPLAINT_COUNT > 30
ORDER BY COMPANY DESC;



-- WRITE A QUERY TO FIND THE COUNT OF COMPLAINTS RECIEVED IN EACH PRODUCT FOR ALL THE COMPANIES WHERE COUNT OPF COMPLAINTS IS MORE THAN 30 AND WAS SUBMITTED VIA PHONE AND WEB

SELECT COMPANY, PRODUCT_NAME, SUBMITTED_VIA, COUNT(DISTINCT COMPLAINT_ID) AS COMPLAINT_COUNT
FROM CONSUMER_COMPLAINTS
WHERE SUBMITTED_VIA IN ('Phone','Web')
GROUP BY 1,2,3
HAVING COMPLAINT_COUNT > 30
ORDER BY COMPANY DESC;




-- WRITE A QUERY TO FIND THE COUNT OF COMPLAINTS RECIEVED IN EACH PRODUCT FOR ALL THE COMPANIES WHERE COUNT OPF COMPLAINTS IS MORE THAN 30 AND WAS SUBMITTED VIA PHONE AND WEB
-- AND FROM THE FOLLOWING STATES - VA, CA, NY

SELECT COMPANY, PRODUCT_NAME, SUBMITTED_VIA, STATE_NAME, COUNT(DISTINCT COMPLAINT_ID) AS COMPLAINT_COUNT
FROM CONSUMER_COMPLAINTS
WHERE SUBMITTED_VIA IN ('Phone','Web') AND STATE_NAME IN('VA','CA','NY')
GROUP BY 1,2,3,4
HAVING COMPLAINT_COUNT > 30
ORDER BY 1 DESC;




--CASE WHEN STATEMENT

--The SQL CASE statement allows you to perform IF-THEN-ELSE functionality within an SQL statement. 

-- The CASE statement allows you to perform an IF-THEN-ELSE check within an SQL statement.

/* It’s good for displaying a value in the SELECT query based on logic that you have defined. 
   As the data for columns can vary from row to row, using a CASE SQL expression can help make your data more readable and useful to the user or to the application. "*/

-- It’s quite common if you’re writing complicated queries or doing any kind of ETL work.

-- SYNTAX
/* The syntax of the SQL CASE expression is:

CASE [expression]
WHEN condition_1 THEN result_1
WHEN condition_2 THEN result_2 ...
WHEN condition_n THEN result_n
ELSE result
END case_name 
*/

/*
The CASE statement and comparison operator
In this format of a CASE statement in SQL, we can evaluate a condition using comparison operators. 
Once this condition is satisfied, we get an expression from corresponding THEN in the output.
*/


CREATE OR REPLACE TABLE EMPLOYEE
( 
EMPLOYEE_ID INT  PRIMARY KEY, 
EMPLOYEE_NAME VARCHAR(100) NOT NULL, 
GENDER VARCHAR(1) NOT NULL, 
STATECODE VARCHAR(20) NOT NULL, 
SALARY NUMBER(10,2) NOT NULL
);


DESCRIBE TABLE EMPLOYEE;

--INSERTING RECORDS

INSERT INTO EMPLOYEE VALUES (201, 'Jerome', 'M', 'FL', 83000.0000),(202, 'Ray', 'M', 'AL', 88000.0000),(203, 'Stella', 'F', 'AL', 76000.0000),(204, 'Gilbert', 'M', 'Ar', 42000.0000),
(205, 'Edward', 'M', 'FL', 93000.0000),(206, 'Ernest', 'F', 'Al', 64000.0000),(207, 'Jorge', 'F', 'IN', 75000.0000),(208, 'Nicholas', 'F', 'Ge', 71000.0000),
(209, 'Lawrence', 'M', 'IN', 95000.0000),(210, 'Salvador', 'M', 'Co', 75000.0000),(211, 'Manisha', 'F', 'IN', 80000.0000),(212, 'Vikas', 'M', 'IN', 5000.0000);

SELECT * FROM EMPLOYEE;


/*
Suppose we have a salary band for each designation. 
If employee salary is in between a particular range, 
we want to get designation using a Case statement.

In the following query, we are using a comparison operator and evaluate an expression.
*/

SELECT *,
CASE
    WHEN Salary >=10000 AND Salary < 30000 THEN 'Data Analyst Trainee'
    WHEN Salary >=30000 AND Salary < 50000 THEN 'Data Analyst'
    WHEN Salary >=50000 AND Salary < 80000 THEN 'Data Engineer'
    WHEN Salary >=80000 AND Salary < 100000 THEN 'Data Scientist'
    WHEN Salary >= 100000 THEN 'Senior Consultant'
ELSE 'Trainee'
END AS DESIGNATION
FROM EMPLOYEE;


-- To have this query result with DESIGNATION BUCKET to be visible as a TABLE, then,

CREATE OR REPLACE TABLE EMPLOYEE_DESIGNATION_BUCKET AS
SELECT *,
CASE
    WHEN Salary >=10000 AND Salary < 30000 THEN 'Data Analyst Trainee'
    WHEN Salary >=30000 AND Salary < 50000 THEN 'Data Analyst'
    WHEN Salary >=50000 AND Salary < 80000 THEN 'Data Engineer'
    WHEN Salary >=80000 AND Salary < 100000 THEN 'Data Scientist'
    WHEN Salary >= 100000 THEN 'Senior Consultant'
ELSE 'Trainee'
END AS DESIGNATION
FROM EMPLOYEE;


SELECT * FROM EMPLOYEE_DESIGNATION_BUCKET;

GRANT USAGE ON SCHEMA SAHEEN_SCHEMA TO ROLE USERADMIN;

GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE USERADMIN;

GRANT SELECT ON EMPLOYEE_DESIGNATION_BUCKET to USERADMIN;   -- Now this table will be accessible for all SELECT querying operations to the ROLE -> USERADMIN


/* Case Statement with ORDER BY clause
We can use Case statement with order by clause as well. 

Suppose in the below example; we want to sort result in the following method.

For Female employee, employee salaries should come in descending order.
For Male employee, we should get employee salaries in ascending order.
We can define this condition with a combination of Order by and Case statement. 

In the following query, you can see we specified Order By and Case together. */


SELECT *
FROM EMPLOYEE
ORDER BY CASE GENDER                        --Approch 1 for a CASE STATEMENT
            WHEN 'F' THEN SALARY
            END DESC,
         CASE                               --Approch 2 for a CASE STATEMENT
            WHEN GENDER ='M' THEN SALARY 
            END;


/*
Case Statement in SQL with Group by clause.

Suppose we want to group employees based on their salary. 
We further want to calculate the minimum and maximum salary for a particular range of employees.

In the following query, you can see that we have Group By clause and it contains i with the condition to get the required output.
*/

DESCRIBE TABLE EMPLOYEE;


SELECT
    CASE
        WHEN Salary >=10000 AND Salary < 30000 THEN 'Data Analyst Trainee'
        WHEN Salary >=30000 AND Salary < 50000 THEN 'Data Analyst'
        WHEN Salary >=50000 AND Salary < 80000 THEN 'Data Engineer'
        WHEN Salary >=80000 AND Salary < 100000 THEN 'Data Scientist'
        WHEN Salary >= 100000 THEN 'Senior Consultant'
        ELSE 'Trainee'
    END AS DESIGNATION,
    MIN(SALARY) AS MINIMUM_SALARY,
    MAX(SALARY) AS MAXIMUM_SALARY
FROM EMPLOYEE
GROUP BY
    CASE
        WHEN Salary >=10000 AND Salary < 30000 THEN 'Data Analyst Trainee'
        WHEN Salary >=30000 AND Salary < 50000 THEN 'Data Analyst'
        WHEN Salary >=50000 AND Salary < 80000 THEN 'Data Engineer'
        WHEN Salary >=80000 AND Salary < 100000 THEN 'Data Scientist'
        WHEN Salary >= 100000 THEN 'Senior Consultant'
        ELSE 'Trainee'
    END;

/* Case Statement limitations
We cannot control the execution flow of stored procedures, functions using a Case statement in SQL
We can have multiple conditions in a Case statement; 
however, it works in a sequential model. If one condition is satisfied, it stops checking further conditions
We cannot use a Case statement for checking NULL values in a table
*/

-- COPYING TABLES
SELECT * FROM EMPLOYEE_DESIGNATION_BUCKET LIMIT 5;

-- Copy only table schema, not data:
CREATE TABLE "SAHEEN_DB"."SAHEEN_SCHEMA"."COPY____EMPLOYEE" LIKE "SAHEEN_DB"."SAHEEN_SCHEMA"."EMPLOYEE";

SELECT * FROM COPY____EMPLOYEE;

--Copy both the entire table schema and all the data inside:
--method 1
CREATE TABLE COPY_EMPLOYEE_METHOD1 CLONE EMPLOYEE;
SELECT * FROM COPY_EMPLOYEE_METHOD1 LIMIT 5;

--method 2
CREATE OR REPLACE TABLE COPY_EMPLOYEE_METHOD2 AS
SELECT * FROM "SAHEEN_DB"."SAHEEN_SCHEMA"."EMPLOYEE";

SELECT * FROM COPY_EMPLOYEE_METHOD2;

--Copy entire table structure along with particular data set:
CREATE OR REPLACE TABLE INDIAN_EMPLOYEES AS 
SELECT * FROM EMPLOYEE
WHERE STATECODE IN('IN');

SELECT * FROM INDIAN_EMPLOYEES;

-- GET_DDL function to retrieve a DDL statement that could be executed to recreate the specified table. 
-- The statement includes the constraints currently set on a table.

SELECT GET_DDL('table','EMPLOYEE');

/*
In the real work environment, if our team wants a new column on the existing table, we wont be able to add a column on the BASE TABLE 
Instead, we clone a table and do the necessary operatons for a new column and then grand access to public, so the BD team will update or replace the BASE TABLE.
*/




/* What is Snowflake TRUNCATE Table?
The Snowflake TRUNCATE Table component is a Feature offered by snowflake that 
deletes all existing rows from a table or partition while maintaining the table’s integrity. 
However, you can’t use it on a view, an external, or a temporary table. 
Depending on whether the flow of current is in the midst of a database transaction, 

Snowflake TRUNCATE Table is executed in one of two ways. 
The first is to use the TRUNCATE command. 

The second option is to use a DELETE FROM statement, which itself is recommended 
if the current job is a transaction. 
It eliminates all rows from a table while maintaining the table’s integrity. 

After the command completes, the load metadata for the table is deleted, 
allowing the same files to be uploaded into the table again. 

For the duration of the data retention term, 
Snowflake TRUNCATE Table keeps deleted data for archival purposes (e.g., utilizing Time Travel). 
The load metadata, on the other hand, cannot be restored when a table is truncated.

Snowflake TRUNCATE Table is used to delete all records from a table while keeping the 
table’s schema or structure. 

Despite the fact that Snowflake TRUNCATE Table is regarded as a DDL command, 
rather than a DML statement so it can’t be undone, 
truncate procedures, especially for large tables, drop and recreate the table, 
which is much quicker than deleting rows one by one. 
Truncate operations result in an implicit commit, therefore they can’t be undone

Delete or Truncate: Which is better?
TRUNCATE is quicker than DELETE since it does not check all records before deleting them. 
Snowflake TRUNCATE Table locks the entire table to drop the data from the table. 
As a result, this command needs significantly low transaction space than DELETE. 
TRUNCATE, unlike DELETE, does not revive the no. of rows that have been deleted from the table.

Syntax: TRUNCATE [ TABLE ] [ IF EXISTS ] <name>

Usage Notes:

Snowflake TRUNCATE Table keep deleted data for future reuse for the duration of the data 
retention period; however, the load information cannot be restored when the table is truncated.
If the table name is completely qualified or the database schema is presently in use for the 
session, the table keyword is not required.

The Snowflake TRUNCATE Table command is a DML (Data Manipulation Language) command. A DML command is used to add (insert), 
delete (delete), and alter (update) data in a database. */

CREATE OR REPLACE TABLE EMPLOYEE_COPY CLONE EMPLOYEE;

SELECT * FROM EMPLOYEE_COPY;

TRUNCATE TABLE EMPLOYEE_COPY;

DROP TABLE EMPLOYEE_COPY;

UNDROP TABLE EMPLOYEE_COPY;         -- Undropping a table will be available for 24 HRs

DELETE FROM EMPLOYEE_COPY WHERE EMPLOYEE_ID = 212;


CREATE OR REPLACE TABLE CUSTOMER
(
cust_id INT NOT NULL UNIQUE,
cust_name VARCHAR(100) NOT NULL,
cust_address TEXT NOT NULL,
cust_aadhaar_number VARCHAR(50) DEFAULT NULL,
cust_pan_number VARCHAR(50) NOT NULL
);


--ALTER <object>
--Modifies the metadata of an account-level or database object, or the parameters for a session
ALTER TABLE CUSTOMER
ADD PRIMARY KEY (CUST_ID);

-- EVEN THOUGH SNOWFLAKE ACCEPTS PRIMARY KEY, IT DOESN'T ENFORCE THEM. SNOWFLAKE ONLY ENFORCES NOT NULL AS A CONSTRAINT.

DESCRIBE TABLE CUSTOMER;

ALTER TABLE CUSTOMER
ADD UNIQUE(CUST_ID);

ALTER TABLE CUSTOMER
ADD COLUMN AGE INT;

DESCRIBE TABLE CUSTOMER;

--UPDATE
--Updates specified rows in the target table with new values.
/*UPDATE <target_table>
       SET <col_name> = <value> [ , <col_name> = <value> , ... ]
        [ FROM <additional_tables> ]
        [ WHERE <condition> ] */


/*
Required Parameters
target_table
Specifies the table to update.

col_name
Specifies the name of a column in target_table. Do not include the table name. For example, UPDATE t1 SET t1.col = 1 is invalid.

value
Specifies the new value to set in col_name.
*/

DESCRIBE TABLE CUSTOMER;

INSERT INTO CUSTOMER VALUES (123,'anand','Ambika homes ashraya layout mahadevapura banaglore','988042369887','ALZTR645R',31);
INSERT INTO CUSTOMER VALUES (143,'MANISHA','PATNA BIHAR','988045672345','ALPJ8769R',23);    
INSERT INTO CUSTOMER VALUES (123,'SHANMUKH','Whitefiled Bangalore','988042364567','ALZPJ567R',27);


UPDATE CUSTOMER
SET AGE = 31 WHERE CUST_ID = 123;

UPDATE CUSTOMER
SET CUST_PAN_NUMBER = 'AZAZAZA12' WHERE CUST_NAME = 'SHANMUKH';

UPDATE CUSTOMER
SET AGE = 24 WHERE CUST_NAME = 'MANISHA';

SELECT * FROM CUSTOMER;



/*
Referential integrity constraints in Snowflake are informational and, with the exception of NOT NULL, 
not enforced. Constraints other than NOT NULL are created as disabled.

However, constraints provide valuable metadata. 
The primary keys and foreign keys enable members of your project team to orient themselves to the schema design 
and familiarize themselves with how the tables relate with one another.

Additionally, most business intelligence (BI) and visualization tools import the foreign key definitions with the tables and 
build the proper join conditions. 
This approach saves you time and is potentially less prone to error than someone 
later having to guess how to join the tables and then manually configuring the tool. 

Basing joins on the primary and foreign keys also helps ensure integrity to the design, 
since the joins are not left to different developers to interpret. 

Some BI and visualization tools also take advantage of constraint information to rewrite queries 
into more efficient forms, e.g. join elimination.

Specify a constraint when creating or modifying a table using the CREATE | ALTER TABLE … CONSTRAINT commands.

In the following example, the CREATE TABLE statement for the second table (salesorders) 
defines an out-of-line foreign key constraint that references a column in the first table (salespeople):
*/

CREATE OR REPLACE TABLE SALESPEOPLE 
(
  sp_id INT NOT NULL UNIQUE,
  name VARCHAR DEFAULT NULL,
  region VARCHAR,
  CONSTRAINT PK_SP_ID PRIMARY KEY (sp_id)
);


CREATE OR REPLACE TABLE SALESORDER
(
  order_id INT NOT NULL UNIQUE,
  quantity INT DEFAULT NULL,
  description VARCHAR,
  sp_id INT NOT NULL UNIQUE,
  CONSTRAINT pk_order_id PRIMARY KEY (order_id),
  CONSTRAINT fk_sp_id FOREIGN KEY (sp_id) REFERENCES SALESPEOPLE(sp_id)
);

DESCRIBE TABLE SALESPEOPLE;
DESCRIBE TABLE SALESORDER;


SELECT GET_DDL('table', '"SAHEEN_DB"."SAHEEN_SCHEMA"."SALESORDER"');
SELECT GET_DDL('table', '"SAHEEN_DB"."SAHEEN_SCHEMA"."SALESPEOPLE"');




-- SUBSTRING
SELECT SUBSTR('SAHEEN AHZAN',0,2);
SELECT SUBSTR('SAHEEN AHZAN',-2,2);
SELECT SUBSTR('SAHEEN AHZAN',2,7);

-- SUBSTR(STARTING INDEX,NUMBER OF INDEXES TO MOVE AHEAD)

--EXAMPLE 2
SELECT AGENT_CODE,AGENT_NAME, SUBSTR(AGENT_NAME,0,2) AS AGENT_INITIALS FROM AGENTS;



-- CAST FUNCTION 

/*
Snowflake CAST is a data-type conversion command. Snowflake CAST works similar to the TO_ datatype conversion functions. 
If a particular data type conversion is not possible,
it raises an error. Let’s understand the Snowflake CAST in detail via the syntax and a few examples.
*/

SELECT CAST('1.6845' AS DECIMAL(5,2));
-- SYNTAX -> SELECT CAST('1.6845' AS DECIMAL(precision-total digits,total number of decimal places));

-- :: is the small exp which we could use for typecasting/cast
SELECT '1.6845'::DECIMAL(6,4);

SELECT CAST('10-Sep-2021' AS timestamp);
SELECT '10-Sep-2021':: DATE;

-- When the provided precision is insufficient to hold the input value, the Snowflake CAST command raises an error as follows:
SELECT CAST('123.12' AS DECIMAL(4,2)); -- ERROR
--Here, precision is set as 4 but the input value has a total of 5 digits, thereby raising the error.
SELECT CAST('123.12' AS DECIMAL(5,2));


--TRY_CAST( <source_string_expr> AS <target_data_type> )
SELECT TRY_CAST('05-Mar-2016' AS TIMESTAMP);
--The Snowflake TRY_CAST command returns NULL as the input value 
--has more characters than the provided precision in the target data type.
SELECT TRY_CAST('ANAND' AS CHAR(4)); -- returns NULL
SELECT TRY_CAST('ANAND' AS CHAR(5));

--Trim function
SELECT TRIM('❄-❄❄❄❄❄----ABC-❄-','❄-') AS trimmed_string;
SELECT TRIM('❄---❄ABC-❄-','-') AS trimmed_string;
SELECT TRIM('********T E S T I N G 1 2 3 4********','*') AS TRIMMED_SPACE;

--ltrim
SELECT LTRIM('#000000123', '0#');
SELECT LTRIM('#0000AISHWARYA', '0#');
SELECT LTRIM('      ANAND JHA', ' ');

--RTRIM
SELECT RTRIM('$125.00', '0.');
SELECT RTRIM('ANAND JHA*****', '*');

--To remove the white spaces or the blank spaces from the string TRIM function can be used. 
--It can remove the whitespaces from the start and end both.
SELECT TRIM('  Snwoflake Space Remove  ', ' ');

--To remove the first character from the string you can pass the string in the RTRIM function.
SELECT LTRIM('Snowflake Remove  ', 'S');
--To remove the last character from the string you can pass the string in the RTRIM function.
SELECT RTRIM('Snwoflake Remove  ', 'e');

SELECT BTRIM('  Snwoflake Space Remove  ', ' ');

--LENGTH FUNCTION
SELECT LEN('Snowflake Space Remove') AS length_string;
SELECT LEN(trim('  Snowflake Space Remove  ')) AS length_string;
SELECT LENGTH(trim('  Snowflake Space Remove  ')) AS length_string;

--concat
SELECT * FROM AGENTS;
SELECT CONCAT('KA',', ','India') AS state_country;
SELECT *,CONCAT(AGENT_CODE, '-', AGENT_NAME) AS agent_details FROM agents;

--Snowflake CONCAT_WS Function
/* The concat_ws function concatenates two or more strings, or concatenates two or more binary values 
and adds separator between those strings.
The CONCAT_WS operator requires at least two arguments, and uses the first argument to separate all following arguments
Following is the concat_ws function syntax
CONCAT_WS( <separator> , <expression1> [ , <expressionN> ... ] ) */

SELECT CONCAT_WS('-', 'KA','India') AS state_country;

/*
Snowflake Concat Operator (||)
The concatenation operator concatenates two strings on either side of the || symbol and returns the concatenated string. 
The || operator provides alternative syntax for CONCAT and requires at least two arguments.
For example,
*/
SELECT 'Nested'||' CONCAT'||' example!'AS Concat_operator;


--Handling NULL Values in CONCAT function and the Concatenation operator
--For both the CONCAT function and the concatenation operator,
--if one or both strings are null, the result of the concatenation is null.
--For example,

SELECT CONCAT('Bangalore, ', NULL) AS null_example;
SELECT 'Bangalore, '|| NULL AS null_example;

--how to handle it?
SELECT CONCAT('Bangalore', NVL(NULL,'_')) AS null_example;
SELECT 'Bangalore'|| NVL(NULL, '') AS null_example;

-- EXAMPLE
-- WHEN fee = NULL 
NVL(fee,0) + NVL(net_fx,0) AS TOTAL_REVENUE;


-- REVERSE IN STRING
SELECT REVERSE('Hello, world!');

-- SPLIT
SELECT SPLIT('127.0.0.1','.');
SELECT SPLIT('ANAND-KUMAR-JHA','-');

SELECT SPLIT_PART('11.22.33', '.', 0);
SELECT SPLIT_PART('11.22.33', '.', 1);
SELECT SPLIT_PART('11.22.33', '.', 2);
SELECT SPLIT_PART('ANAND-KUMAR-JHA','-',1);
SELECT SPLIT_PART('ANAND-KUMAR-JHA','-',2);

SELECT SPLIT_PART('aaa--bbb--BBB--ccc', '--',1);
SELECT SPLIT_PART('aaa--bbb--BBB--ccc', '--',2);
SELECT SPLIT_PART('aaa--bbb--BBB--ccc', '--',3);
SELECT SPLIT_PART('aaa--bbb--BBB--ccc', '--',4);



SELECT *, 
        SPLIT_PART(AGENT_DETAILS,'-',1) AS AGENT_ID,
        SPLIT_PART(AGENT_DETAILS,'-',2) AS AGENT_NAME
FROM
(SELECT *,CONCAT(AGENT_CODE, '-', AGENT_NAME) AS agent_details FROM agents);



SELECT LOWER('India Is My Country') as lwr_strng;
SELECT UPPER('India Is My Country') as upr_strng;


-- REPLACE COMMAND
-- REPLACE( <subject> , <pattern> [ , <replacement> ] )

SELECT REPLACE( '   ANAND KUMAR JHA   ' ,' ','*');
SELECT REPLACE( '   ANAND KUMAR JHA   ' ,' ','');
SELECT REPLACE('   T  E S T I N G 1 2 3 4   ',' ',',');
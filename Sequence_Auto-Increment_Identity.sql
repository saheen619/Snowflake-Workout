-- AUTO INCREMENT - IDENTITY

-- Add identity or autoincrement to table in Snowflake

/* In Snowflake, you can set the default value for a column, 
which is typically used to set an autoincrement or identity as the default value, 
so that each time a new row is inserted a unique id for that row is generated and stored and can be used as a primary key. 

You can specify the default value for a column using create table or alter table.

However, if you try to alter a table to add an autoincrement column that already has data in it, we will get an error in Snowflake. 
This is not supported in Snowflake, due to the underlying architecture.

It’s not as easy as altering the existing table, but there are two ways we can add an identity or autoincrement column to an existing table. */

--Method 1: Using autoincrement or identity as a default value.
--First we are going to create a simple table that we want to add an identity/autoincrement field to:

CREATE OR REPLACE TABLE COLORS AS
    SELECT NAME
    FROM (VALUES ('blue'),('red'),('green')) COLORS (NAME);
    
SELECT name FROM colors;
    
-- Next we create a new table with the same structure as the existing table and add an idenity column.    
CREATE OR REPLACE TABLE identity_column_example LIKE COLORS;

SELECT * FROM identity_column_example;

ALTER TABLE identity_column_example ADD COLUMN id int identity(1,1);

INSERT INTO identity_column_example(name)
SELECT name FROM colors;

/* The identityautoincrement columns take two optional parameters:
         -> start the starting value of the column
          -> increment the specific amount to increment each row
          
In the example above we set the column to start at 1 and increment by 1.

autoincrement and identity are synonymous with each other and the default value for start and increment, if not specified, is 1 for both*/

--To replace our existing colors table with the new table:
ALTER TABLE IDENTITY_COLUMN_EXAMPLE RENAME TO colors_copy;







-- Method 2: Using sequences
/*
In the example above we only had one column, so specifying the column manually in the insert worked fine for our use case. 
But, sometimes existing tables have a lot of columns and we don’t want to have to specify each column, either to save time or also to avoid errors.

We can programatically add an autoincrement or identity field to a wide table, but we have to do it a little differently.
*/

--CREATING A SEQUENCE
CREATE OR REPLACE SEQUENCE employeeid
START = 1
INCREMENT = 1
COMMENT = "This sequence will be used to generate employee id's";

DESCRIBE SEQUENCE employeeid;

-- Lets now use this sequence on a table
CREATE OR REPLACE TABLE employee_for_sequence_testing
(
  emp_number int DEFAULT employeeid.NEXTVAL,                   --- Here, we apply the sequence to be executed, which we will solve later in this file
  employee_id number,
  salary number,
  age number
);

INSERT INTO employee_for_sequence_testing VALUES(56,001,50000,26);
INSERT INTO employee_for_sequence_testing(employee_id,salary,age) VALUES(002,52000,25);
INSERT INTO employee_for_sequence_testing(employee_id,salary,age) VALUES(003,57000,23);
INSERT INTO employee_for_sequence_testing(employee_id,salary,age) VALUES(004,53000,28);
INSERT INTO employee_for_sequence_testing(employee_id,salary,age) VALUES(005,58000,31);

INSERT INTO employee_for_sequence_testing VALUES(5,006,55000,26);
INSERT INTO employee_for_sequence_testing(employee_id,salary,age) VALUES(008,69000,35);

SELECT * FROM employee_for_sequence_testing;
-- Here, after inserting the data, we could crearly see that the sequence failed, because the id valuies repeeated, which we will correct later.

CREATE OR REPLACE TABLE employee_for_sequence_testing2
(
  emp_number int DEFAULT employeeid.NEXTVAL,                   --- Here, we apply the sequence to be executed, which we will solve later in this file
  employee_id number,
  salary number,
  age number
);

SELECT * FROM employee_for_sequence_testing2;

INSERT INTO employee_for_sequence_testing2(employee_id,salary,age) VALUES(002,52000,25);
INSERT INTO employee_for_sequence_testing2 VALUES(employeeid.NEXTVAL,001,50000,26);

SELECT * FROM employee_for_sequence_testing2;

-- NOW IT WORKS


-- Let’s use an existing Snowflake sample data table to see why we can’t just alter the existing table:

CREATE OR REPLACE TABLE identity_column_example LIKE "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."CUSTOMER";

ALTER TABLE identity_column_example ADD COLUMN id int identity(1,1) NOT NULL;

INSERT INTO identity_column_example
SELECT * FROM "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."CUSTOMER" LIMIT 20;

SELECT * FROM identity_column_example;

-- ERROR CASE 1 - SQL compilation error: Insert value list does not match column list expecting 9 but got 8
-- ERROR CASE 2 - SQL compilation error: Non-nullable column 'ID' cannot be added to non-empty table 'IDENTITY_COLUMN_EXAMPLE' unless it has a non-null default value.

-- The main problem here and the reason we get an error is when we use * the number of columns returned is one less than the new table we created. 
-- We can’t specify an empty value in a select statement, so we can’t force the identity column to populate in the way we want. 
-- We could specifiy the columns we want to populate manually, leaving out only the id column, but that’s what we are trying to avoid.


-- Let’s see what happens when we fill that column with an expression that auto-increments.


DROP TABLE identity_column_example;

CREATE OR REPLACE TABLE identity_column_example LIKE "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."CUSTOMER";
ALTER TABLE identity_column_example ADD COLUMN id int identity(1,1) NOT NULL;

INSERT INTO identity_column_example 
SELECT *, ROW_NUMBER() OVER (ORDER BY NULL)
FROM "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."CUSTOMER";

SELECT * FROM identity_column_example LIMIT 20;



-- BINGOOOOOOOOO It works!!! BUT WAIT, let’s take a look at what happens when we insert a new record into the table:

INSERT INTO identity_column_example(c_custkey, c_name, c_address, c_nationkey, c_phone, c_acctbal, c_mktsegment, c_comment)
VALUES (219874, 'Customer#000219874', 'sadhjekj', 9, '19-505-461-2873', 999.99, 'asjdasgdj', 'sdadtyhkjer');

SELECT * FROM identity_column_example ORDER BY id LIMIT 50;

-- As you can see we have a duplicate value in our id field, because the identity column counter was never triggered, 
-- so when we insert a new record it starts over at 1.

-- In this case, we have to use a sequence. The identity and autoincrement default values use sequences under the hood, 
-- so we will be essentially recreating that functionality.

-- When we create our own sequence we have access to the next value in the sequence. 
-- This allows us to add the next incremental value when we backfill the new table with the old table.

-- First, we create a sequence that starts at 1 and increments by 1 and name it seq1:
CREATE OR REPLACE SEQUENCE seq1 START=1 INCREMENT=1;

CREATE OR REPLACE SEQUENCE seq2 START=100 INCREMENT=2;

--Next, we’ll recreate our table and add a column id with the nextval of the seq1 sequence as the default:
CREATE OR REPLACE TABLE identity_column_example LIKE "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."CUSTOMER";

SELECT GET_DDL('table','identity_column_example');

--ADDING COLUMN ID
ALTER TABLE identity_column_example 
ADD COLUMN id int DEFAULT seq1.NEXTVAL;

--SYNTAX : alter table <table-name> modify column <column-name> default <new-sequence-name>.nextval;
ALTER TABLE identity_column_example 
ADD COLUMN id2 int DEFAULT seq2.NEXTVAL; 

-- Remove the default value
-- alter table <table-name> modify column <column-name> drop default;


--Then, we can backfill the new table using nextval:
INSERT INTO identity_column_example 
SELECT *, seq1.NEXTVAL, seq2.nextval
FROM "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."CUSTOMER";


SELECT * FROM identity_column_example;


-- Now, when we add a new record, the id column autoincrements properly and will remain unique:
INSERT INTO identity_column_example(c_custkey, c_name, c_address, c_nationkey, c_phone, c_acctbal, c_mktsegment, c_comment)
VALUES (219874, 'Customer#000219874', 'sadhjekj', 9, '19-505-461-2873', 999.99, 'asjdasgdj', 'sdadtyhkjer');

SELECT * FROM identity_column_example;

--where c_custkey = 219874;
SELECT * FROM identity_column_example
ORDER BY id DESC;





















--SYNTAX : alter table <table-name> modify column <column-name> default <new-sequence-name>.nextval;
alter table identity_column_example MODIFY COLUMN id  DEFAULT seq1.NEXTVAL;





UPDATE table identity_column_example 
SET id  default seq1.nextvalue;

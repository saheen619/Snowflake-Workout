-- What's my current user, role, warehouse, database, etc?
SELECT CURRENT_USER();
SELECT CURRENT_ROLE();
SELECT CURRENT_WAREHOUSE();
SELECT CURRENT_DATABASE();

--How do I use a specific role, warehouse, database, etc?
SHOW ROLES;
USE ROLE {role};

--How do I set my default warehouse?
SHOW WAREHOUSES;
USE WAREHOUSE COMPUTE_WH;

--Determine your current warehouse:
SELECT CURRENT_WAREHOUSE();

--WH's
SHOW DATABASES;
SELECT * FROM INFORMATION_SCHEMA.DATABASES;
USE DATABASE SAHEEN_DB;

--Alter your default warehouse:
ALTER USER SAHEENDECATHLON SET DEFAULT_WAREHOUSE = COMPUTE_WH;

--How do I create a new warehouse?
--Check if the warehouse already exists:
SHOW WAREHOUSES;
DESCRIBE WAREHOUSE COMPUTE_WH;

--Create (or replace) the warehouse:
CREATE OR REPLACE WAREHOUSE ANALYTICS
    WITH WAREHOUSE_SIZE = 'SMALL'
    MAX_CLUSTER_COUNT = 1
    AUTO_SUSPEND = 300
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE;
    

--However, with a simple SQL query you can set whatever timeout you need. The timeout value is in seconds.
ALTER WAREHOUSE IF EXISTS COMPUTE_WH SET AUTO_SUSPEND = 300;

ALTER WAREHOUSE IF EXISTS ANALYTICS SET AUTO_SUSPEND = 3600;

--How do I create a new database user?
SHOW ROLES;
USE ROLE ACCOUNTADMIN;

-- USE ROLE SECURITYADMIN;
CREATE USER {username} PASSWORD = '{password}' MUST_CHANGE_PASSWORD = TRUE;

-- Grant usage on a database and warehouse to a role
SHOW GRANTS TO ROLE USERADMIN;
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE USERADMIN;
GRANT USAGE ON DATABASE SAHEEN_DB TO ROLE USERADMIN;

--How to create a role that allows 'create warehouse'
USE DATABASE ANALYTICS;
USE WAREHOUSE ANALYTICS;
CREATE ROLE ADMINISTRATOR;
GRANT CREATE WAREHOUSE ON ACCOUNT TO ROLE ADMINISTRATOR;
GRANT USAGE ON DATABASE ANALYTICS TO ROLE ADMINISTRATOR;
SHOW GRANTS ON ROLE ADMINISTRATOR;
GRANT ROLE ADMINISTRATOR TO USER <username>;
SHOW GRANTS ON USER <username>;

--Snowflake provides a full set of SQL commands for managing users and security. 
-- These commands can only be executed by users who are granted roles that have the OWNERSHIP privilege on the managed object. 
--This is usually restricted to the ACCOUNTADMIN and SECURITYADMIN roles.









--------------------
----ANALYST ROLE----
--------------------


SHOW WAREHOUSES;

CREATE DATABASE accesscontrol;

USE accesscontrol;

USE ROLE accountadmin;

CREATE ROLE analyst;

SHOW GRANTS TO ROLE analyst;

GRANT ROLE analyst TO USER co2trading;     -- co2trading is my temporary username on snowflake

SHOW GRANTS TO USER co2trading;




--Creating a Large warehouse and giving access to the role analyst

CREATE WAREHOUSE large_wh
WITH WAREHOUSE_SIZE = LARGE;

SHOW WAREHOUSES;

SHOW GRANTS TO ROLE analyst;

GRANT USAGE ON WAREHOUSE large_wh TO ROLE analyst;

SHOW GRANTS TO ROLE analyst;



-- Add read access to DB snowflake_sample_data
USE ROLE accountadmin;
CREATE DATABASE test_db;
USE DATABASE test_db;
CREATE OR REPLACE TABLE PRODUCT
(
ProductID	INT,
ProductCategory	VARCHAR(60),
ProductSubCategory	VARCHAR(60),
Product VARCHAR(30)
);

GRANT USAGE ON DATABASE test_db TO ROLE analyst;
GRANT USAGE ON SCHEMA test_db.public TO ROLE analyst;

--Granting access to all the tables in a particular schema to a role
GRANT SELECT ON ALL TABLES IN SCHEMA test_db.public TO ROLE analyst;

USE ROLE analyst;


--------------------
---DEVELOPER ROLE---
--------------------

USE ROLE ACCOUNTADMIN;

CREATE ROLE DEVELOPER;

SHOW GRANTS TO ROLE developer;



-- Granting role to my user
GRANT ROLE developer TO USER co2trading;

USE ROLE developer;



-- Inherit analyst permissions to developer
USE ROLE accountadmin;

GRANT ROLE ANALYST TO ROLE developer; 


-- Give permissions to MASTER_DB to developer
GRANT USAGE ON DATABASE MASTER_DB TO ROLE developer;
USE ROLE developer;
USE ROLE accountadmin;
GRANT USAGE ON SCHEMA MASTER_DB.MASTER_SCHEMA TO ROLE developer;
-- Give Access to only the COMPLAINS TABLE to the ROLE Developer
GRANT SELECT ON MASTER_DB.MASTER_SCHEMA.COMPLAINS TO ROLE developer;

-- Compare Roles
USE ROLE developer;
USE ROLE analyst;
USE ROLE accountadmin;



--------------------
----MANAGER ROLE----
--------------------

USE ROLE accountadmin;
CREATE ROLE manager;

-- Grant role to my user
GRANT ROLE manager to USER co2trading;
USE ROLE manager;

--Inherit analyst and developer permissions to manager
USE ROLE accountadmin;
GRANT ROLE developer TO ROLE manager;

-- Grant permissions to use all tables in master_db
USE ROLE accountadmin;
GRANT USAGE ON DATABASE MASTER_DB TO ROLE manager;
GRANT USAGE ON SCHEMA MASTER_DB.MASTER_SCHEMA TO ROLE manager;
USE ROLE manager;

--Grant SELECT permissions on the same
USE ROLE accountadmin;
GRANT SELECT ON ALL TABLES IN SCHEMA MASTER_DB.MASTER_SCHEMA TO ROLE manager;
USE ROLE manager;

-- Give INSERT/UPDATE permissions to the role manager
USE ROLE accountadmin;
GRANT INSERT ON ALL TABLES IN SCHEMA MASTER_DB.MASTER_SCHEMA TO ROLE manager;
GRANT UPDATE ON ALL TABLES IN SCHEMA MASTER_DB.MASTER_SCHEMA TO ROLE manager;

-- Compare Roles
USE ROLE manager;
USE ROLE developer;
USE ROLE analyst;
USE ROLE accountadmin;

SHOW GRANTS TO ROLE analyst;
SHOW GRANTS TO ROLE developer;
SHOW GRANTS TO ROLE manager;
SHOW GRANTS TO ROLE accountadmin;
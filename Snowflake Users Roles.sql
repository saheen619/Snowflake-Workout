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

// READER ACCOUNT
// An account for those clients or stakeholders to use the account with limited privileges without having to have an actual snowflake account.

USE ROLE accountadmin;

CREATE MANAGED ACCOUNT TEST_READER 
admin_name='test', 
admin_password='Test@123', 
type=reader, 
COMMENT='A reader account for the clients to view the data';

-- {"accountName":"DK76243","loginUrl":"https://dk76243.ap-southeast-1.snowflakecomputing.com"}

SHOW MANAGED ACCOUNTS;

-- CReating an outbount share
CREATE SHARE "DEMO_SHARE" COMMENT='';
GRANT USAGE ON DATABASE "MASTER_DB" TO SHARE "DEMO_SHARE";
GRANT USAGE ON SCHEMA "MASTER_DB"."MASTER_SCHEMA" TO SHARE "DEMO_SHARE";
GRANT SELECT ON VIEW "MASTER_DB"."MASTER_SCHEMA"."CUST_MASTER" TO SHARE "DEMO_SHARE";

DESC SHARE JDLWTDM.JX25008."DEMO_SHARE";

ALTER SHARE "DEMO_SHARE" ADD ACCOUNTS = DK76243;

// Login (as ACCOUNTADMIN) and create a database from the Share so that your data consumers can access the shared data.
// TEST_READER (https://dk76243.ap-southeast-1.snowflakecomputing.com)




-- On GOING TO THE TEST_READER ACCOUNT,
CREATE DATABASE "MASTER_DB" FROM SHARE JDLWTDM.JX25008."DEMO_SHARE";
GRANT IMPORTED PRIVILEGES ON DATABASE "MASTER_DB" TO ROLE "ACCOUNTADMIN";
GRANT IMPORTED PRIVILEGES ON DATABASE "MASTER_DB" TO ROLE "SYSADMIN";
-- Now you will have access to the shared table as CUST_MASTER from MASTER_DB



-- To share more tables, or views, go to the actual Snowflake account and share your tables using the share option.
/*========
USER Stage
========*/

-- We use SnowSQL CLI to perform the below operations

-- To get the list of user stage which is by default created for each user:
-- Even accountadmin can access only his user stage and not for any other roles.

co2trading#COMPUTE_WH@RAW.PUBLIC> list @~ ;
+-----------------------------------------------------+------+----------------------------------+------------------------------+
| name                                                | size | md5                              | last_modified                |
|-----------------------------------------------------+------+----------------------------------+------------------------------|
| worksheet_data/c754e581-f285-4fac-8a7a-5a3a8801251e |  640 | e14b204ff50310fdb5102ecb12954ccb | Mon, 8 May 2023 12:13:46 GMT |
| worksheet_data/metadata                             |  416 | 195d15420fadd8eddfac2ce585797365 | Mon, 8 May 2023 12:13:47 GMT |
+-----------------------------------------------------+------+----------------------------------+------------------------------+

-- One user can load data from the local machine to the user stage using SnowSQL CLI using PUT command and with @~ 







/*=========
Table Stage
=========*/

-- Created by default for all tables
-- One can load load data here using the SnowSQL CLI and PUT command with @%<Table Name>
co2trading#COMPUTE_WH@RAW.PUBLIC> show tables;
co2trading#COMPUTE_WH@RAW.PUBLIC> list @%incode_band;

+------+------+-----+---------------+
| name | size | md5 | last_modified |
|------+------+-----+---------------|
+------+------+-----+---------------+







/*=========
NAMED Stage
=========*/

SHOW stages;
LIST @STAGE01;  -- STAGE01 is the name of the stage

/*============
Internal Stage
============*/

-- To create an internal stage 
CREATE STAGE "RAW"."PUBLIC"."DEMO_STAGE" COMMENT = "This is a Demo Stage"

SHOW STAGES LIKE 'DEMO%';








/*========================================
Ingest data via User Stage and SnowSQL CLI
========================================*/

LIST @~ ;

// Now lets load data into the user stage

co2trading#COMPUTE_WH@RAW.PUBLIC>PUT file:///C:/Users/sahee/OneDrive/Desktop/Repositories/Snowflake/Datasets/ConsumerComplaints_cleaned.csv @~/consumers_stage/;
+--------------------------------+-----------------------------------+-------------+-------------+--------------------+--------------------+----------+---------+
| source                         | target                            | source_size | target_size | source_compression | target_compression | status   | message |
|--------------------------------+-----------------------------------+-------------+-------------+--------------------+--------------------+----------+---------|
| ConsumerComplaints_cleaned.csv | ConsumerComplaints_cleaned.csv.gz |    15139545 |     2483696 | NONE               | GZIP               | UPLOADED |         |
+--------------------------------+-----------------------------------+-------------+-------------+--------------------+--------------------+----------+---------+


co2trading#COMPUTE_WH@RAW.PUBLIC> list @~ ;
+-----------------------------------------------------+---------+----------------------------------+-------------------------------+
| name                                                |    size | md5                              | last_modified                 |
|-----------------------------------------------------+---------+----------------------------------+-------------------------------|
| consumers_stage/ConsumerComplaints_cleaned.csv.gz   | 2483696 | 4bc5a16f8fa61fc7027ee0445386eefa | Wed, 10 May 2023 14:40:43 GMT |
| worksheet_data/c754e581-f285-4fac-8a7a-5a3a8801251e |     640 | e14b204ff50310fdb5102ecb12954ccb | Mon, 8 May 2023 12:13:46 GMT  |
| worksheet_data/metadata                             |     416 | 195d15420fadd8eddfac2ce585797365 | Mon, 8 May 2023 12:13:47 GMT  |
+-----------------------------------------------------+---------+----------------------------------+-------------------------------+


co2trading#COMPUTE_WH@RAW.PUBLIC> LIST @~/consumers_stage;
+---------------------------------------------------+---------+----------------------------------+-------------------------------+
| name                                              |    size | md5                              | last_modified                 |
|---------------------------------------------------+---------+----------------------------------+-------------------------------|
| consumers_stage/ConsumerComplaints_cleaned.csv.gz | 2483696 | 4bc5a16f8fa61fc7027ee0445386eefa | Wed, 10 May 2023 14:40:43 GMT |
+---------------------------------------------------+---------+----------------------------------+-------------------------------+


// Trying to upload the same csv file to the same stage where AUTO COMPRESS = FALSE

co2trading#COMPUTE_WH@RAW.PUBLIC>PUT file:///C:/Users/sahee/OneDrive/Desktop/Repositories/Snowflake/Datasets/ConsumerComplaints_cleaned.csv @~/consumers_stage/ AUTO_COMPRESS = FALSE;
+--------------------------------+--------------------------------+-------------+-------------+--------------------+--------------------+----------+---------+
| source                         | target                         | source_size | target_size | source_compression | target_compression | status   | message |
|--------------------------------+--------------------------------+-------------+-------------+--------------------+--------------------+----------+---------|
| ConsumerComplaints_cleaned.csv | ConsumerComplaints_cleaned.csv |    15139545 |    15139552 | NONE               | NONE               | UPLOADED |         |
+--------------------------------+--------------------------------+-------------+-------------+--------------------+--------------------+----------+---------+


co2trading#COMPUTE_WH@RAW.PUBLIC> LIST @~/consumers_stage;
+---------------------------------------------------+----------+----------------------------------+-------------------------------+
| name                                              |     size | md5                              | last_modified                 |
|---------------------------------------------------+----------+----------------------------------+-------------------------------|
| consumers_stage/ConsumerComplaints_cleaned.csv    | 15139552 | 4a4e64c2a616326eb586fd8ec3d0039e | Wed, 10 May 2023 14:46:27 GMT |
| consumers_stage/ConsumerComplaints_cleaned.csv.gz |  2483696 | 4bc5a16f8fa61fc7027ee0445386eefa | Wed, 10 May 2023 14:40:43 GMT |
+---------------------------------------------------+----------+----------------------------------+-------------------------------+


-- To search something within a folder or subfolder, we have to use the PATTERN clause instead of LIKE clause

co2trading#COMPUTE_WH@RAW.PUBLIC> LIST @~ PATTERN = '.*.gz';
+---------------------------------------------------+---------+----------------------------------+-------------------------------+
| name                                              |    size | md5                              | last_modified                 |
|---------------------------------------------------+---------+----------------------------------+-------------------------------|
| consumers_stage/ConsumerComplaints_cleaned.csv.gz | 2483696 | 4bc5a16f8fa61fc7027ee0445386eefa | Wed, 10 May 2023 14:40:43 GMT |
+---------------------------------------------------+---------+----------------------------------+-------------------------------+









/*==========================
LOADING DATA TO TABLE STAGES
==========================*/

// Placing file to table stages

CREATE OR REPLACE TABLE CONSUMER_COMPLAINTS
(
DATE_RECEIVED STRING,
PRODUCT_NAME VARCHAR2(50),
SUB_PRODUCT VARCHAR2(100),
ISSUE VARCHAR2(100),
SUB_ISSUE VARCHAR2(100),
CONSUMER_COMPLAINT_NARRATIVE STRING,
Company_Public_Response STRING,
Company VARCHAR(100),
State_Name CHAR(4),
Zip_Code STRING,
Tags VARCHAR(60),
Consumer_Consent_Provided CHAR(25),
Submitted_via STRING,
Date_Sent_to_Company STRING,
Company_Response_to_Consumer VARCHAR(80),
Timely_Response CHAR(4),
CONSUMER_DISPUTED CHAR(4),
COMPLAINT_ID NUMBER(12,0) NOT NULL PRIMARY KEY
);


co2trading#COMPUTE_WH@RAW.PUBLIC> LIST @%CONSUMER_COMPLAINTS;
+------+------+-----+---------------+
| name | size | md5 | last_modified |
|------+------+-----+---------------|
+------+------+-----+---------------+
0 Row(s) produced. Time Elapsed: 0.861s


co2trading#COMPUTE_WH@RAW.PUBLIC>PUT file:///C:/Users/sahee/OneDrive/Desktop/Repositories/Snowflake/Datasets/ConsumerComplaints_cleaned.csv @%CONSUMER_COMPLAINTS;
+--------------------------------+-----------------------------------+-------------+-------------+--------------------+--------------------+----------+---------+
| source                         | target                            | source_size | target_size | source_compression | target_compression | status   | message |
|--------------------------------+-----------------------------------+-------------+-------------+--------------------+--------------------+----------+---------|
| ConsumerComplaints_cleaned.csv | ConsumerComplaints_cleaned.csv.gz |    15139545 |     2483696 | NONE               | GZIP               | UPLOADED |         |
+--------------------------------+-----------------------------------+-------------+-------------+--------------------+--------------------+----------+---------+


LIST @%CONSUMER_COMPLAINTS;

/*RESLT
name	                            size	    md5	                                last_modified
ConsumerComplaints_cleaned.csv.gz	2,483,696	a69132aa9b00e3d4304a9c29a5654b05	Wed, 10 May 2023 15:05:07 GMT
*/








/*==========================
LOAD DATA INTO A NAMED STAGE
==========================*/

// INTERNAL STAGE - Stores data files internally within Snowflake. Internal stages can be either permanent or temporary.

SHOW STAGES;

CREATE OR REPLACE STAGE demo_internal_stage;



co2trading#COMPUTE_WH@RAW.PUBLIC>PUT file:///C:/Users/sahee/OneDrive/Desktop/Repositories/Snowflake/Datasets/ConsumerComplaints_cleaned.csv @demo_internal_stage;
+--------------------------------+-----------------------------------+-------------+-------------+--------------------+--------------------+----------+---------+
| source                         | target                            | source_size | target_size | source_compression | target_compression | status   | message |
|--------------------------------+-----------------------------------+-------------+-------------+--------------------+--------------------+----------+---------|
| ConsumerComplaints_cleaned.csv | ConsumerComplaints_cleaned.csv.gz |    15139545 |     2483696 | NONE               | GZIP               | UPLOADED |         |
+--------------------------------+-----------------------------------+-------------+-------------+--------------------+--------------------+----------+---------+
1 Row(s) produced. Time Elapsed: 3.850s





co2trading#COMPUTE_WH@RAW.PUBLIC> LIST  @demo_internal_stage;
+-------------------------------------------------------+---------+----------------------------------+----------------------------+
| name                                                  |    size | md5                              | last_modified                 |
|-------------------------------------------------------+---------+----------------------------------+----------------------------|
| demo_internal_stage/ConsumerComplaints_cleaned.csv.gz | 2483696 | 20614aa1699a09e055766a1c00fcd972 | Wed, 10 May 2023 15:16:18 GMT |
+-------------------------------------------------------+---------+----------------------------------+----------------------------+
1 Row(s) produced. Time Elapsed: 0.168s



// How to REMOVE stages or files from the stages
// Stages are temporary storage. Thus it must be removed after the files are moved to permanent locations.

REMOVE @~consumers_stage;          -- For user stage
REMOVE @%CONSUMER_COMPLAINTS;      -- For table stages





/*=============================================
NOT POSSIBLE - LOAD DATA INTO AN EXTERNAL STAGE
=============================================*/

-- External stage is designed not to be ingested with data, but to be pointed to an external data source like object storage.
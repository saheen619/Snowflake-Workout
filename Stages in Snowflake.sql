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
LOAD DATA INTO A NAMED - INETERNAL STAGE
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









/*==============================
LOAD AND QUERY DATA FROM STAGES
==============================*/

/*==============
FROM TABLE STAGE
==============*/

-- Table stages are un-named stages
-- It cannot be modified, so it is hard to associate a file format with it.
-- Easy to work with csv but hard to work with Semi-Structured Data

-- Create a PARQUET Table in the name of cites_parquet and add a file format while creating the table

CREATE or REPLACE TABLE cites_parquet
(
    my_data VARIANT    -- Note that the datatype used is VARIANT in cities
)
STAGE_FILE_FORMAT = (TYPE=PARQUET)
;

// Load parquet file into the TABLE STAGE
co2trading#COMPUTE_WH@RAW.PUBLIC> PUT file:///C:/Users/sahee/OneDrive/Desktop/Repositories/Snowflake/Datasets/cities.parquet @%cites_parquet;
+----------------+----------------+-------------+-------------+--------------------+--------------------+----------+---------+
| source         | target         | source_size | target_size | source_compression | target_compression | status   | message |
|----------------+----------------+-------------+-------------+--------------------+--------------------+----------+---------|
| cities.parquet | cities.parquet |         866 |         880 | PARQUET            | PARQUET            | UPLOADED |         |
+----------------+----------------+-------------+-------------+--------------------+--------------------+----------+---------+
1 Row(s) produced. Time Elapsed: 2.176s



co2trading#COMPUTE_WH@RAW.PUBLIC>LIST @%cites_parquet;
+----------------+------+----------------------------------+-------------------------------+
| name           | size | md5                              | last_modified                 |
|----------------+------+----------------------------------+-------------------------------|
| cities.parquet |  880 | 5a29804b213be5e95d0f88cb4146759e | Thu, 11 May 2023 16:18:02 GMT |
+----------------+------+----------------------------------+-------------------------------+

SELECT * FROM cites_parquet;

// Now lets query the data using the $ notation

SELECT
    metadata$filename,
    metadata$file_row_number,
    $1:continent::VARCHAR,
    $1:country:name::VARCHAR,
    $1:country:city::VARIANT
FROM @%cites_parquet;

/* RESULT
METADATA$FILENAME 				METADATA$FILE_ROW_NUMBER	$1:CONTINENT::VARCHAR	$1:COUNTRY:NAME::VARCHAR	$1:COUNTRY:CITY::VARIANT
@CITES_PARQUET/cities.parquet	1							Europe					France						[   "Paris",   "Nice",   "Marseilles",   "Cannes" ]
@CITES_PARQUET/cities.parquet	2							Europe					Greece						[   "Athens",   "Piraeus",   "Hania",   "Heraklion",   "Rethymnon",   "Fira" ]
@CITES_PARQUET/cities.parquet	3							North America			Canada						[   "Toronto",   "Vancouver",   "St. John's",   "Saint John",   "Montreal",   "Halifax",   "Winnipeg",   "Calgary",   "Saskatoon",   "Ottawa",   "Yellowknife" ]
*/
-- In the above query, you could see that the data is not copied into the table from the stage.
-- Instead, the data in the stage is directly being queried by pointing to the stage @%cites_parquet using TABLE STAGE

-- PARQUET file format will only have one column named as $1
-- If we have loaded additional files into the stage, the metadata$filename and row_number will give additional info on each record
-- If we remove the stage from the table definition, the query wont work.
-- Even if you give a file format properties to the table, the query wont work for a table stage



// Now lets run the copy command to load the data into the table, so that we can view the content of the parquet file in JSON format
COPY INTO cites_parquet FROM @%cites_parquet/cities.parquet;

SELECT * FROM cites_parquet; -- Here, it shows the result in JSON format because the file is parquet

/*
MY_DATA
{   "continent": "Europe",   "country": {     "city": [       "Paris",       "Nice",       "Marseilles",       "Cannes"     ],     "name": "France"   } }
{   "continent": "Europe",   "country": {     "city": [       "Athens",       "Piraeus",       "Hania",       "Heraklion",       "Rethymnon",       "Fira"     ],     "name": "Greece"   } }
{   "continent": "North America",   "country": {     "city": [       "Toronto",       "Vancouver",       "St. John's",       "Saint John",       "Montreal",       "Halifax",       "Winnipeg",       "Calgary",       "Saskatoon",       "Ottawa",       "Yellowknife"     ],     "name": "Canada"   } }
*/

-- Once the data is loaded, you can see the LOAD_HISTORY table to see the history
-- Copy + Tables has metadata which remembers last 64 days of data load history

-- You may use the option "FORCE = TRUE | FALSE" to re-load the same data. By default, this flag is flase.
-- Also, if you TRUNCATE or DELETE all the data, without FORCE = TRUE, the data cannot be loaded.

--Lets try to load the data again to the same table
COPY INTO cites_parquet FROM @%cites_parquet/cities.parquet;
/* RESULT
status
Copy executed with 0 files processed.
*/

--Lets try to load the data again to the same table using FORCE = TRUE
COPY INTO cites_parquet 
FROM @%cites_parquet/cities.parquet 
FORCE=TRUE; 
/*
file	        status	rows_parsed	rows_loaded	error_limit	errors_seen
cities.parquet	LOADED	3	        3	        1	        0
*/ -- Making it TRUE will produce data redundancy







/*==============
VIEW ACCNT USAGE
==============*/
-- To view the account usage,
USE ROLE ACCOUNTADMIN;
-- SELECT on COPY_HISTORY Table
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.COPY_HISTORY;
-- LOAD_HISTORY
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.LOAD_HISTORY;
-- ACCOUNT_STAGES
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.STAGES; -- UNNAMED STAGES WON'T BE VISIBLE HERE






/*===============
VIEW FILE FORMATS
===============*/
CREATE OR REPLACE FILE FORMAT parquet_ff TYPE = 'PARQUET';

CREATE OR REPLACE FILE FORMAT json_ff TYPE = 'JSON';

CREATE OR REPLACE FILE FORMAT csv_ff TYPE = 'CSV';



SHOW FILE FORMATS;






/*=======================================
DEFINE FILE FORMATS WHILE CREATING STAGES
========================================*/

-- You can specify the file format while defining the stage and dont have to use file format while copying.
CREATE OR REPLACE stage_with_csv
FILE_FORMAT = csv_ff
COMMENT = 'STAGE WILL USE csv_ff AS THE FILE FORMAT BY DEFAULT'


CREATE OR REPLACE stage_with_csv
COMMENT = 'NO FILE FILE FORMAT SET'










/*======================================================
LOAD AND QUERY PARQUET DATA FROM A NAMED INTERNAL STAGES
======================================================*/

CREATE OR REPLACE TEMPORARY TABLE cities 
(
    continent varchar default null,
    country varchar default null,
    city VARIANT default null
);


-- Create a file format
CREATE OR REPLACE FILE FORMAT parquet_ff 
TYPE = 'PARQUET';


-- Create a stage
CREATE OR REPLACE STAGE cities_parquet_stage
FILE_FORMAT = parquet_ff;


-- Stage the data
co2trading#COMPUTE_WH@RAW.PUBLIC> PUT file:///C:/Users/sahee/OneDrive/Desktop/Repositories/Snowflake/Datasets/cities.parquet @cities_parquet_stage;
+----------------+----------------+-------------+-------------+--------------------+--------------------+----------+---------+
| source         | target         | source_size | target_size | source_compression | target_compression | status   | message |
|----------------+----------------+-------------+-------------+--------------------+--------------------+----------+---------|
| cities.parquet | cities.parquet |         866 |         880 | PARQUET            | PARQUET            | UPLOADED |         |
+----------------+----------------+-------------+-------------+--------------------+--------------------+----------+---------+
1 Row(s) produced. Time Elapsed: 2.997s


-- the staged data into the target table

COPY INTO cities
FROM 
    (SELECT $1:continent::VARCHAR,
            $1:country:name::VARCHAR,
            $1:country:city::VARIANT
    FROM @cities_parquet_stage/cities.parquet
    );


SELECT * FROM cities;

/* RESULT
CONTINENT		COUNTRY		CITY
Europe			France		[   "Paris",   "Nice",   "Marseilles",   "Cannes" ]
Europe			Greece		[   "Athens",   "Piraeus",   "Hania",   "Heraklion",   "Rethymnon",   "Fira" ]
North America	Canada		[   "Toronto",   "Vancouver",   "St. John's",   "Saint John",   "Montreal",   "Halifax",   "Winnipeg",   "Calgary",   "Saskatoon",   "Ottawa",   "Yellowknife" ]
*/


// ADDITIONALLY, We could Unload the CITIES table into another Parquet file.

COPY INTO @cities_parquet_stage/OUT/parquet_
FROM 
    (SELECT continent,
            country,
            c.value::STRING AS city
     FROM cities,
     LATERAL FLATTEN(input => city) AS c)
FILE_FORMAT = (type = 'parquet')
HEADER = true;
-- The header=true option directs the command to retain the column 
-- In the nested SELECT query: The FLATTEN function first flattens the city column array elements into separate columns.
-- The LATERAL modifier joins the output of the FLATTEN function with information outside of the object - in this example, the continent and country.
-- You could also have PARSE = TRUE to have the files removed after successful copying

LIST @cities_parquet_stage;
/*
name	size	md5	last_modified
cities_parquet_stage/OUT/parquet__0_0_0.snappy.parquet	1,136	51009c7c21f3b8c152a0a55bfd672c1c	Thu, 11 May 2023 18:21:09 GMT
cities_parquet_stage/cities.parquet	                      880	d459820bb13b9da4d885e1840f2d9ada	Thu, 11 May 2023 18:11:17 GMT
*/

-- HERE in the above result, the parquet file is suffiixed by snappy, where snappy is a compression mode.

-- OR

SELECT t.$1 FROM @cities_parquet_stage/OUT/ t;
 
/* RESULT
$1
{   "CITY": "Paris",   "CONTINENT": "Europe",   "COUNTRY": "France" }
{   "CITY": "Nice",   "CONTINENT": "Europe",   "COUNTRY": "France" }
{   "CITY": "Marseilles",   "CONTINENT": "Europe",   "COUNTRY": "France" }
{   "CITY": "Cannes",   "CONTINENT": "Europe",   "COUNTRY": "France" }
{   "CITY": "Athens",   "CONTINENT": "Europe",   "COUNTRY": "Greece" }
{   "CITY": "Piraeus",   "CONTINENT": "Europe",   "COUNTRY": "Greece" }
{   "CITY": "Hania",   "CONTINENT": "Europe",   "COUNTRY": "Greece" }
{   "CITY": "Heraklion",   "CONTINENT": "Europe",   "COUNTRY": "Greece" }
{   "CITY": "Rethymnon",   "CONTINENT": "Europe",   "COUNTRY": "Greece" }
{   "CITY": "Fira",   "CONTINENT": "Europe",   "COUNTRY": "Greece" }
{   "CITY": "Toronto",   "CONTINENT": "North America",   "COUNTRY": "Canada" }
{   "CITY": "Vancouver",   "CONTINENT": "North America",   "COUNTRY": "Canada" }
{   "CITY": "St. John's",   "CONTINENT": "North America",   "COUNTRY": "Canada" }
{   "CITY": "Saint John",   "CONTINENT": "North America",   "COUNTRY": "Canada" }
{   "CITY": "Montreal",   "CONTINENT": "North America",   "COUNTRY": "Canada" }
{   "CITY": "Halifax",   "CONTINENT": "North America",   "COUNTRY": "Canada" }
{   "CITY": "Winnipeg",   "CONTINENT": "North America",   "COUNTRY": "Canada" }
{   "CITY": "Calgary",   "CONTINENT": "North America",   "COUNTRY": "Canada" }
{   "CITY": "Saskatoon",   "CONTINENT": "North America",   "COUNTRY": "Canada" }
{   "CITY": "Ottawa",   "CONTINENT": "North America",   "COUNTRY": "Canada" }
{   "CITY": "Yellowknife",   "CONTINENT": "North America",   "COUNTRY": "Canada" }
*/


// REMOVE THE SUCCESSFULLY COPIED DATA FILES
-- After you verify that you successfully copied data from your stage into the tables, you can remove data files from the internal stage using the REMOVE command to save on data storage.
REMOVE @cities_parquet_stage/cities.parquet;
REMOVE @cities_parquet_stage/OUT/;

LIST @cities_parquet_stage;









/*========================
FILE PATTERN WHILE LOADING
=========================*/

-- CASE01
COPY INTO table1 FROM @t1/region/state/city/2023/05/02/
FILES = ('mydata1.csv', 'mydata2.csv');

-- CASE02
COPY INTO table2 FROM @t1/region/state/city/2023/05/02/
PATTERN = '.*mydata[^[0-9]{1,3}$$].csv';

-- CASE03
COPY INTO people_data FROM @%people_data/data1/
PATTERN = '.*person_data[^0-9{1,3}$$].csv';






/*=================================================================
TO VIEW THE CONTENT OF A FILE IN A STAGE, WITHOUT LOADING THE DATA
=================================================================*/

SELECT $1, $2, $3, $4, $5, $6 FROM @my_stage/my_data/custromer_complains.csv;






/*=================================================
COPYING MULTIPLE SPECIFIC FILES FROM STAGE TO TABLE
==================================================*/
COPY INTO my_customer_csv FROM
@my_stage/my_data/
FILES=('customer_000.csv', 'customer_001.csv');








/*==============
LOAD PERFORMANCE
==============*/

/*
On testing to load data to an internal stage and then to a table, where the data is a combination of multiple csv files of 64 mb each in case1 and GZIP compressed csv files in case 2,
Loading the data to the table did not show much difference in time taken in both the cases;
*/


/*
On testing to load parquet data to an internal stage and then to a table, where the data is a parquet files of 64 mb each in case1 and SNAPPY compressed PARQUET files in case 2,
Loading the data to the table showed much efficient in time taken in both the cases;
*/

-- CONCLUSION - PARQUET SNAPPY GIVES THE BEST PERFORMANCE
-- Even though Snowflake recommends using the CSV or CSV GZIP files for loading.
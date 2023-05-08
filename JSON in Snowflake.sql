/*
-- JSON Basics

Upload sample JSON data from a public S3 bucket into a column of the variant type in a Snowflake table. 

Test simple queries for JSON data in the table.

Explore the FLATTEN function to flatten JSON data into a relational representation and save it in another table.

Explore ways to ensure uniqueness as you insert rows in the flattened version of the data.
*/

CREATE OR REPLACE DATABASE jsondb;

USE SCHEMA jsondb.public;

CREATE OR REPLACE TABLE raw_source (SRC VARIANT);

CREATE OR REPLACE STAGE json_stage
URL = 's3://snowflake-docs/tutorials/json';

SHOW STAGES;

COPY INTO raw_source
  FROM @json_stage/server/2.6/2016/07/15/15
  FILE_FORMAT = (TYPE = JSON);

SELECT * FROM raw_source;



/* RESULT IS AS FOLLOWS:

+-----------------------------------------------------------------------------------+
| SRC                                                                               |
|-----------------------------------------------------------------------------------|
| {                                                                                 |
|   "device_type": "server",                                                        |
|   "events": [                                                                     |
|     {                                                                             |
|       "f": 83,                                                                    |
|       "rv": "15219.64,783.63,48674.48,84679.52,27499.78,2178.83,0.42,74900.19",   |
|       "t": 1437560931139,                                                         |
|       "v": {                                                                      |
|         "ACHZ": 42869,                                                            |
|         "ACV": 709489,                                                            |
|         "DCA": 232,                                                               |
|         "DCV": 62287,                                                             |
|         "ENJR": 2599,                                                             |
|         "ERRS": 205,                                                              |
|         "MXEC": 487,                                                              |
|         "TMPI": 9                                                                 |
|       },                                                                          |
|       "vd": 54,                                                                   |
|       "z": 1437644222811                                                          |
|     },                                                                            |
|     {                                                                             |
|       "f": 1000083,                                                               |
|       "rv": "8070.52,54470.71,85331.27,9.10,70825.85,65191.82,46564.53,29422.22", |
|       "t": 1437036965027,                                                         |
|       "v": {                                                                      |
|         "ACHZ": 6953,                                                             |
|         "ACV": 346795,                                                            |
|         "DCA": 250,                                                               |
|         "DCV": 46066,                                                             |
|         "ENJR": 9033,                                                             |
|         "ERRS": 615,                                                              |
|         "MXEC": 0,                                                                |
|         "TMPI": 112                                                               |
|       },                                                                          |
|       "vd": 626,                                                                  |
|       "z": 1437660796958                                                          |
|     }                                                                             |
|   ],                                                                              |
|   "version": 2.6                                                                  |
| }                                                                                 |
+-----------------------------------------------------------------------------------+

+-----------------------------------------------------------------------------------+
| SRC                                                                               |
|-----------------------------------------------------------------------------------|
| {                                                                                 |
|   "device_type": "server",                                                        |
|   "events": [                                                                     |
|     {                                                                             |
|       "f": 83,                                                                    |
|       "rv": "15219.64,783.63,48674.48,84679.52,27499.78,2178.83,0.42,74900.19",   |
|       "t": 1437560931139,                                                         |
|       "v": {                                                                      |
|         "ACHZ": 42869,                                                            |
|         "ACV": 709489,                                                            |
|         "DCA": 232,                                                               |
|         "DCV": 62287,                                                             |
|         "ENJR": 2599,                                                             |
|         "ERRS": 205,                                                              |
|         "MXEC": 487,                                                              |
|         "TMPI": 9                                                                 |
|       },                                                                          |
|       "vd": 54,                                                                   |
|       "z": 1437644222811                                                          |
|     },                                                                            |
|     {                                                                             |
|       "f": 1000083,                                                               |
|       "rv": "8070.52,54470.71,85331.27,9.10,70825.85,65191.82,46564.53,29422.22", |
|       "t": 1437036965027,                                                         |
|       "v": {                                                                      |
|         "ACHZ": 6953,                                                             |
|         "ACV": 346795,                                                            |
|         "DCA": 250,                                                               |
|         "DCV": 46066,                                                             |
|         "ENJR": 9033,                                                             |
|         "ERRS": 615,                                                              |
|         "MXEC": 0,                                                                |
|         "TMPI": 112                                                               |
|       },                                                                          |
|       "vd": 626,                                                                  |
|       "z": 1437660796958                                                          |
|     }                                                                             |
|   ],                                                                              |
|   "version": 2.6                                                                  |
| }                                                                                 |
+-----------------------------------------------------------------------------------+

In this sample JSON data, there are two events. The device_type, and version key values identify a data source and version for events from a specific device.
*/


SELECT src:device_type::string AS device_type
FROM raw_source;



/*
Retrieve repeating f keys nested within the array event objects.
The sample JSON data includes events array. Each event object in the array has the f field as shown.

{
"device_type": "server",
"events": [
  {
    "f": 83,
    ..
  }
  {
    "f": 1000083,
    ..
  }
]}

-- To retrieve these nested keys, you can use the FLATTEN function. The function flattens the events into separate rows.
*/

SELECT value:f::number
FROM raw_source,
LATERAL FLATTEN( INPUT => SRC:events );
-- The "LATERAL FLATTEN" function is used to transform the JSON data in the "SRC:events" column into a table format so that it can be queried using SQL.


SELECT src:device_type::string,
    src:version::String,
    VALUE
FROM
    raw_source,
    LATERAL FLATTEN( INPUT => SRC:events );




-- Using a CREATE TABLE AS statement to store the preceding query result in a table:
CREATE OR REPLACE TABLE flattened_source AS
  SELECT
    src:device_type::string AS device_type,
    src:version::string     AS version,
    VALUE                   AS src
  FROM
    raw_source,
    LATERAL FLATTEN( INPUT => SRC:events );


SELECT * FROM flattened_source;


-- Flattening the raw content in seperate columns.
--In the preceding example, you flattened the event objects in the events array into separate rows. The resulting flattened_source table retained the event structure in the src column of the VARIANT type. One benefit of retaining the event objects in the src column of the VARIANT type is that when event format changes, you don’t have to recreate and repopulate such tables. 
CREATE OR REPLACE TABLE events AS
  SELECT
    src:device_type::string       as device_type,
    src:version::string           as version,
    value:f::number               as f,
    value:rv::variant             as rv,
    value:t::number               as t,
    value:v.ACHZ::number          as achz,
    value:v.ACV::number           as acv,
    value:v.DCA::number           as dca,
    value:v.DCV::number           as dcv,
    value:v.ENJR::number          as enjr,
    value:v.ERRS::number          as errs,
    value:v.MXEC::number          as mxec,
    value:v.TMPI::number          as tmpi,
    value:vd::number              as vd,
    value:z::number               as z
  FROM
    raw_source,
    LATERAL FLATTEN ( input => SRC:events );


SELECT * FROM events;

/*
Update Data -
So far,
We copied sample JSON event data from an S3 bucket into the RAW_SOURCE table and explored simple queries.
We also explored the FLATTEN function to flatten the JSON data and obtain a relational representation of the data. For example, we extracted event keys and stored the keys in separate columns in another EVENTS table.

The application scenario where multiple sources generate events and a web endpoint saves it to your S3 bucket. As new events are added to the S3 bucket, we might use a script to continuously copy new data into the RAW_SOURCE table. But how do insert only new event data into the EVENTS table.

There are numerous ways to maintain data consistency. 

1. Use Primary Key Columns for Comparison
Examine our JSON data for any values that are naturally unique and would be good candidates for a primary key. For example, assume that the combination of src:device_type and value:rv can be a primary key. These two JSON keys correspond to the DEVICE_TYPE and RV columns in the EVENTS table.

Here in Snowflake, Snowflake does not enforce the primary key constraint. Rather, the constraint serves as metadata that identifies the natural key in the Information Schema.
*/

ALTER TABLE events ADD CONSTRAINT pk_DeviceType PRIMARY KEY (device_type, rv);


-- Insert a new JSON event record into the RAW_SOURCE table:
INSERT INTO raw_source
  SELECT
  PARSE_JSON ('{                                           
    "device_type": "cell_phone",
    "events": [
      {
        "f": 79,
        "rv": "786954.67,492.68,3577.48,40.11,343.00,345.8,0.22,8765.22",
        "t": 5769784730576,
        "v": {
          "ACHZ": 75846,
          "ACV": 098355,
          "DCA": 789,
          "DCV": 62287,
          "ENJR": 2234,
          "ERRS": 578,
          "MXEC": 999,
          "TMPI": 9
        },
        "vd": 54,
        "z": 1437644222811
      }
    ],
    "version": 3.2
  }');


-- Insert the new record that you added to the RAW_SOURCE table into the EVENTS table based on a comparison of the primary key values:
INSERT INTO events
SELECT
      src:device_type::string,
      src:version::string,
      value:f::number,
      value:rv::variant,
      value:t::number,
      value:v.ACHZ::number,
      value:v.ACV::number,
      value:v.DCA::number,
      value:v.DCV::number,
      value:v.ENJR::number,
      value:v.ERRS::number,
      value:v.MXEC::number,
      value:v.TMPI::number,
      value:vd::number,
      value:z::number
    FROM
      raw_source,
      LATERAL FLATTEN( input => src:events )
    WHERE NOT EXISTS
    (SELECT 'x'                                    --Here, x acts as a dummy value
      FROM events
      WHERE events.device_type = src:device_type
      AND events.rv = value:rv);

SELECT * FROM events;




/*
2. Use All Columns for Comparison
If the JSON data does not have fields that can be primary key candidates, you could compare all repeating JSON keys in the RAW_SOURCE table with the corresponding column values in the EVENTS table.
No changes to your existing EVENTS table are required.

Insert a new JSON event record into the RAW_SOURCE table:
*/

INSERT INTO raw_source
  SELECT
  PARSE_JSON ('{
    "device_type": "web_browser",
    "events": [
      {
        "f": 79,
        "rv": "122375.99,744.89,386.99,12.45,78.08,43.7,9.22,8765.43",
        "t": 5769784730576,
        "v": {
          "ACHZ": 768436,
          "ACV": 9475,
          "DCA": 94835,
          "DCV": 88845,
          "ENJR": 8754,
          "ERRS": 567,
          "MXEC": 823,
          "TMPI": 0
        },
        "vd": 55,
        "z": 8745598047355
      }
    ],
    "version": 8.7
  }');

SELECT * FROM raw_source;
DELETE FROM raw_source WHERE SRC:"device_type"::VARCHAR = 'web_browser';

INSERT INTO events
SELECT
      src:device_type::string
    , src:version::string
    , value:f::number
    , value:rv::variant
    , value:t::number
    , value:v.ACHZ::number
    , value:v.ACV::number
    , value:v.DCA::number
    , value:v.DCV::number
    , value:v.ENJR::number
    , value:v.ERRS::number
    , value:v.MXEC::number
    , value:v.TMPI::number
    , value:vd::number
    , value:z::number
    FROM
      raw_source,
      LATERAL FLATTEN( input => src:events )
    WHERE NOT EXISTS
    (SELECT 'x'
      from events
      WHERE events.device_type = src:device_type
      AND events.version = src:version
      AND events.f = value:f
      AND events.rv = value:rv
      AND events.t = value:t
      AND events.achz = value:v.ACHZ
      AND events.acv = value:v.ACV
      AND events.dca = value:v.DCA
      AND events.dcv = value:v.DCV
      AND events.enjr = value:v.ENJR
      AND events.errs = value:v.ERRS
      AND events.mxec = value:v.MXEC
      AND events.tmpi = value:v.TMPI
      AND events.vd = value:vd
      AND events.z = value:z);

SELECT * FROM events;

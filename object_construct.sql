/*==============
Object Construct
==============*/

// Creating a custom JSON on Snowflake

-- Specify the keys and values directly
SELECT object_construct('key1','value1','key2','value2','key3','value3','key4','value4');
 
/* RESULT
{
  "key1": "value1",
  "key2": "value2",
  "key3": "value3",
  "key4": "value4"
}
*/

-- Working with NULLS:
SELECT object_construct('key1','value1','key2',NULL);

/* RESULT
{
  "key1": "value1"
}
*/

SELECT object_construct('key1','value1','key2',NULL,'key3','NULL','key4',parse_json('null'));

/* RESULT
{
  "key1": "value1",
  "key3": "NULL",
  "key4": null
}
*/




-- Infer the keys and values from the FROM clause
-- Or you could say, create a JSON OBJECT from a query

WITH mock_data AS
(
    SELECT
        seq8() AS seq_int,                                         -- auto_increment from 0
        uuid_string() AS uuid,                                     -- random universally unique identifier
        uniform(1, 10, random()) AS rand_int,                      -- adjust min/max value as needed 
        uniform(0, 1::decimal(18,2), random()) AS random_decimal,  -- Adjust scale/precision
        RANDSTR(15, random()) AS rand_string,                      --adjust length as needed
        DATEADD(day, seq8(), '2021-01-01')::date AS incr_date     -- auto-increment by day, adjust start date as needed 
    FROM TABLE(generator(rowcount => 50))                          -- adjust of records as ndeed
)         
SELECT object_construct(*) FROM mock_data;

/* RESULT of a single record
{
  "INCR_DATE": "2021-01-01",
  "RANDOM_DECIMAL": 0.02,
  "RAND_INT": 1,
  "RAND_STRING": "li1N2k2qDsrMPWF",
  "SEQ_INT": 0,
  "UUID": "a38af7f2-5521-4b11-929f-4e4274f8a4f1"
}
*/


-- Hardcode values only
SELECT object_construct(*) FROM VALUES('1','2'),('2','abc');

/* RESULT
OBJECT_CONSTRUCT(*)
{   "COLUMN1": "1",   "COLUMN2": "2" }
{   "COLUMN1": "2",   "COLUMN2": "abc" }
*/


-- Using Expressions or functions
SELECT
    object_construct(
    'created at', current_timestamp(),
    'table_row_count', (SELECT COUNT(*) FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF100.CUSTOMER),
    'row_number', (SELECT ROW_NUMBER() OVER(ORDER BY SEQ8()))
    );

/* RESULT
{
  "created at": "2023-05-09 04:17:21.712 -0700",
  "row_number": 1,
  "table_row_count": 15000000
}
*/
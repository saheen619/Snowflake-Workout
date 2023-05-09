create or replace transient table customer_csv (
	customer_pk number(38,0),
	salutation varchar(10),
	first_name varchar(20),
	last_name varchar(30),
	gender varchar(1),
	marital_status varchar(1),
	day_of_birth date,
	birth_country varchar(60),
	email_address varchar(50),
	city_name varchar(60),
	zip_code varchar(10),
	country_name varchar(20),
	gmt_timezone_offset number(10,2),
	preferred_cust_flag boolean,
	registration_time timestamp_ltz(9)
);

create or replace file format customer_csv_ff 
    type = 'csv' 
    compression = 'none' 
    field_delimiter = ','
    skip_header = 1 ;

-- field optionally enclosed
create or replace file format customer_csv_ff2
    type = 'csv' 
    compression = 'none' 
    field_delimiter = ','
    field_optionally_enclosed_by = '\042'
    skip_header = 1 ;

-- Default File format Create Script
CREATE FILE FORMAT customer_csv_ff
    TYPE = 'CSV'
    COMPRESSION = 'AUTO'
        -- AUTO | GZIP | BZ2 | BROTLI | ZSTD | DEFLATE | RAW_DEFLATE | NONE
    FIELD_DELIMITER = ','
    RECORD_DELIMITER =  '\n'
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = 'NONE'
    DATE_FORMAT = 'AUTO'
    TIMESTAMP_FORMAT = 'AUTO'
    NULL_ID = ('\\N')
        -- \\N or NULL or Nul or Other



-- File Format for PSV & TSV Delimited Data File

create or replace file format customer_tsv_ff 
    type = 'csv' 
    compression = 'none' 
    field_delimiter = '\t'
    field_optionally_enclosed_by = '\042'
    skip_header = 1 ;

create or replace file format customer_tsv_ff 
    type = 'csv' 
    compression = 'none' 
    field_delimiter = '|'
    field_optionally_enclosed_by = '\042'
    skip_header = 1 ;




-- Copy Into Table Parameters
-- Option-1
-- On Error => Skip The file

COPY INTO "TTIPS"."CH01"."CUSTOMER_CSV" 
    FROM @/ui1664948747495 
    FILE_FORMAT = '"TTIPS"."CH01"."CUSTOMER_CSV_FF"' 
    ON_ERROR = 'SKIP_FILE' 
    PURGE = TRUE;
  
-- Option-2
-- On Error => Abort Statement

COPY INTO "TTIPS"."CH01"."CUSTOMER_CSV" 
    FROM @/ui1664948747495 
    FILE_FORMAT = '"TTIPS"."CH01"."CUSTOMER_CSV_FF"' 
    ON_ERROR = 'ABORT_STATEMENT' 
    PURGE = TRUE;

-- Option-3
-- On Error => Skip upto 10 error records
COPY INTO "TTIPS"."CH01"."CUSTOMER_CSV" 
    FROM @/ui1664948747495 
    FILE_FORMAT = '"TTIPS"."CH01"."CUSTOMER_CSV_FF"' 
    ON_ERROR = 'SKIP_FILE_10' 
    PURGE = TRUE;
    
-- Option-4
-- On Error => Continue even if there is an error
COPY INTO "TTIPS"."CH01"."CUSTOMER_CSV" 
    FROM @/ui1664948747495 
    FILE_FORMAT = '"TTIPS"."CH01"."CUSTOMER_CSV_FF"' 
    ON_ERROR = 'CONTINUE' 
    PURGE = TRUE;



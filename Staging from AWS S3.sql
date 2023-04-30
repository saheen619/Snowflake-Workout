USE saheen_db.public;

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




CREATE OR REPLACE STORAGE INTEGRATION s3_storage_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::168690745982:role/mySnowflakeRole'
  STORAGE_ALLOWED_LOCATIONS = ('s3://snowflake-stage-bucket/Consumer Complaints/');



  
DESC STORAGE INTEGRATION s3_storage_integration;




CREATE OR REPLACE STAGE s3_stage_consumer_complaints
  STORAGE_INTEGRATION = s3_storage_integration
  URL = 's3://snowflake-stage-bucket/Consumer Complaints/'
  FILE_FORMAT = CSV;




SHOW STAGES;



LIST @SAHEEN_DB.PUBLIC.s3_stage_consumer_complaints;




COPY INTO SAHEEN_DB.PUBLIC.CONSUMER_COMPLAINTS
FROM  @SAHEEN_DB.PUBLIC.s3_stage_consumer_complaints
FILES = ('ConsumerComplaints_cleaned.csv')
FILE_FORMAT = (FORMAT_NAME='csv');




SELECT * FROM SAHEEN_DB.PUBLIC.CONSUMER_COMPLAINTS;
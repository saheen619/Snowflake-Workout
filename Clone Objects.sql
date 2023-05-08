/* A clone creates a copy of an existing object in the Snowflake System. The command 'CREATE <object> CLONE' is used primarily to make 'Zero Copy Clone'
of a Database, Schema, Tables; However, It can also be used to quickly create clones of other schema objects like external stages, file formats and sequences;

Snowflake has three layers, namely, the access layer. compute layer and storage layer.
When there is a DB, Table or Schema in the storage layer, basically, in the access layer it's just a pointer to the object in the storage layer.
So, when we clone, we are just adding another pointer and not any new data. 

While insert or update operations, the actual object will do the job and the clone will not have any access to it.
*/

USE TEST_DB;

// To make a clone out of an existing DB, the user and role should have the 'Create database' permission.
SHOW GRANTS ON ACCOUNT;

USE role accountadmin;
CREATE DATABASE TEST_DB_CLONE CLONE TEST_DB;

-- Clone table at a specific time
CREATE TABLE test_db_clone.public.product_clone CLONE test_db_clone.public.product BEFORE (TIMESTAMP => to_timestamp_ltz('2023-05-07','YYYY-MM-DD'));


-- Grants are not copied by default to the SOURCE OBJECT, but it does get copied to the children (Schemas/Tables)
SHOW GRANTS ON DATABASE test_db;
SHOW GRANTS ON DATABASE test_db_clone;

SHOW GRANTS ON SCHEMA test_db.public;
SHOW GRANTS ON SCHEMA test_db_clone.public;


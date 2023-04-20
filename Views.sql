-- create the required table 
CREATE OR REPLACE TABLE hospital_table 
(
patient_id integer,
patient_name varchar, 
billing_address varchar,
diagnosis varchar, 
treatment varchar,
cost number(10,2)
);

-- insert the data 
INSERT INTO hospital_table (patient_id, patient_name, billing_address, diagnosis, treatment, cost) 
VALUES
        (1, 'Mark Knopfler', '1982 Telegraph Road', 'Industrial Disease', 
            'a week of peace and quiet', 2000.00),
        (2, 'Guido van Rossum', '37 Florida St.', 'python bite', 'anti-venom', 
            70000.00),
        (3, 'Devin', '197 Brigade Road Texas', 'dog bite', 'Rabies Injection', 
            40000.00),
        (4, 'Mark', '38 denver St Chicago', 'Dengue', 'Malaria', 
            50000.00),
        (5, 'Peter', '78 New Yor City', 'Accident', 'Operation', 
            340000.00);
            
--check the tablke and its contents            
DESCRIBE TABLE hospital_table;    
SELECT * FROM hospital_table; 

--create view and --check its contents                      
CREATE OR REPLACE VIEW doctor_view AS
SELECT patient_id, patient_name, diagnosis, treatment FROM hospital_table;

DESCRIBE VIEW doctor_view;
SELECT * FROM doctor_view;

CREATE OR REPLACE VIEW accountant_view AS
SELECT patient_id, patient_name, billing_address, cost FROM hospital_table;

DESCRIBE VIEW accountant_view;
SELECT * FROM accountant_view;

-- A view can be used almost anywhere that a table can be used (joins, subqueries, etc.). 
-- For example, using the views created above:

-- Show all of the types of medical problems for each patient:
SELECT DISTINCT diagnosis FROM doctor_view;
    
   
-- A view can be used almost anywhere that a table can be used (joins, subqueries, etc.). 
-- For example, using the views created above:
--Show all of the types of medical problems for each patient:
SELECT DISTINCT diagnosis FROM doctor_view;

--Show the cost of each treatment (without showing personally identifying information about specific patients):
SELECT treatment, cost 
FROM doctor_view AS dv, accountant_view AS av
WHERE av.patient_id = dv.patient_id;


---A CREATE VIEW command can use a fully-qualified, partly-qualified, or unqualified table name. 
--For example:

--create view v1 as select ... from my_database.my_schema.my_table;
CREATE OR REPLACE VIEW v1 AS 
SELECT S_STORE_NAME,S_NUMBER_EMPLOYEES,S_HOURS 
FROM "SNOWFLAKE_SAMPLE_DATA"."TPCDS_SF100TCL"."STORE";

SELECT * FROM V1 LIMIT 30;

--FROM RESPECTIVE SCHEMAS
CREATE VIEW v1 AS SELECT ... FROM my_schema.my_table;
--FROM RESPECTIVE TABLE
CREATE VIEW v1 AS SELECT ... FROM my_table;

--For example, you can create one view for the doctors, and one for the nurses, 
-- and then create the medical_staff view by referring to the doctors view and nurses view:

CREATE OR REPLACE TABLE employees_for_views (id integer, title varchar);
INSERT INTO employees_for_views (id, title) VALUES
    (1, 'doctor'),
    (2, 'nurse'),
    (3, 'janitor');

CREATE VIEW doctors AS SELECT * FROM employees_for_views WHERE title = 'doctor';
CREATE VIEW nurses AS SELECT * FROM employees_for_views WHERE title = 'nurse';
CREATE VIEW medical_staff AS
    SELECT * FROM doctors
    UNION
    SELECT * FROM nurses;


SELECT * 
FROM medical_staff
ORDER BY id;
    
/*
Views Allow Granting Access to a Subset of a Table
Views allow you to grant access to just a portion of the data in a table(s). 
For example, suppose that you have a table of medical patient records. 
The medical staff should have access to all of the medical information (for example, diagnosis) but not the financial information 
(for example, the patient'92s credit card number). 
The accounting staff should have access to the billing-related information, such as the costs of 
each of the prescriptions given to the patient, but not to the private medical data, 
such as diagnosis of a mental health condition. You can create two separate views, 
one for the medical staff, and one for the billing staff, so that each of those roles sees only the information 
needed to perform their jobs. Views allow this because you can grant privileges 
on a particular view to a particular role, without the grantee role having privileges on the table(s) underlying the view.
In the medical example:
The medical staff would not have privileges on the data table(s), but would have privileges on the view showing diagnosis and treatment.
The accounting staff would not have privileges on the data table(s), but would have privileges on the view showing billing information.
Limitations on Views
The definition for a view cannot be updated 
(i.e. you cannot use ALTER VIEW or ALTER MATERIALIZED VIEW to change the definition of a view). 
To change a view definition, you must recreate the view with the new definition.
Changes to a table are not automatically propagated to views created on that table. 
For example, if you drop a column in a table, the views on that table might become invalid.
Views are read-only (i.e. you cannot execute DML commands directly on a view). 
However, you can use a view in a subquery within a DML statement that updates the underlying base table. For example:
*/

SELECT AVG(cost) FROM accountant_view;

DELETE FROM hospital_table 
WHERE cost > (SELECT AVG(cost) FROM accountant_view;);

-- The above query doesnt work because the sub query from the accountant view is not stored anywhere.

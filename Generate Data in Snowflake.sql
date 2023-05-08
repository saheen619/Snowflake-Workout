/*------------
GENERATE DATA
------------*/

-- Random() function

SELECT random();


/*-------
UNIFORM()
-------*/

-- Generates a uniformly-distributed pseudo-random number in the inclusive range [min, max].
-- UNIFORM( <min> , <max> , <gen>)

SELECT uniform(1,19,random());

SELECT uniform(1,19,2);

SELECT uniform(1,19,random()), uniform(1,19,3);


/*---------
RANDOMSTR()
---------*/

SELECT RANDSTR(5,RANDOM());

SELECT RANDSTR(5,5);


/*---------
UUID_STRING()
---------*/
-- This generated string will be unique
-- Generates either a version 4 (random) or version 5 (named) RFC 4122(Uniform Resource Name URN namespace)-compliant UUID as a formatted string.
-- UUID_STRING( <uuid> , <name> )

SELECT UUID_STRING();


/*---------
GENERATOR()
---------*/
-- Creates rows of data based either on a specified number of rows, a specified generation period (in seconds), or both. This system-defined table function enables synthetic row generation.

SELECT random() FROM TABLE(GENERATOR(ROWCOUNT => 5));

SELECT UUID_STRING() FROM TABLE(GENERATOR(ROWCOUNT => 5));




/*---
SEQ8()
---*/

// This function uses sequences to produce a unique set of increasing integers but does not necessarily produce a gap-free sequence. When operating on a large quantity of data, gaps can appear in a sequence. If a fully ordered, gap-free sequence is required, consider using the ROW_NUMBER window function.

SELECT SEQ1(),  SEQ2(),  SEQ4(),  SEQ8(),  
ROW_NUMBER() OVER(ORDER BY SEQ8())
FROM TABLE(GENERATOR(ROWCOUNT => 10));

/*----------------------------------------------------------------
SEQ1()	SEQ2()	SEQ4()	SEQ8()	ROW_NUMBER() OVER(ORDER BY SEQ8())
0		0		0		0		1
1		1		1		1		2
2		2		2		2		3
3		3		3		3		4
4		4		4		4		5
5		5		5		5		6
6		6		6		6		7
7		7		7		7		8
8		8		8		8		9
9		9		9		9		10
------------------------------------------------------------------*/

SELECT SEQ8(1), 
ROW_NUMBER() OVER(ORDER BY SEQ8()),
DATEADD('day', SEQ8(), '2023-05-02')
FROM TABLE(GENERATOR(ROWCOUNT => 10));


/*----------------------------------------------------------------------------------
SEQ8(1)	    ROW_NUMBER() OVER(ORDER BY SEQ8())	DATEADD('DAY', SEQ8(), '2023-05-02')
0			1									2023-05-02 00:00:00.000
1			2									2023-05-03 00:00:00.000
2			3									2023-05-04 00:00:00.000
3			4									2023-05-05 00:00:00.000
4			5									2023-05-06 00:00:00.000
5			6									2023-05-07 00:00:00.000
6			7									2023-05-08 00:00:00.000
7			8									2023-05-09 00:00:00.000
8			9									2023-05-10 00:00:00.000
9			10									2023-05-11 00:00:00.000
----------------------------------------------------------------------------------*/



/*-------------------------------------
PUTTING IT ALL TOGETHER - GENERATE DATA
---------*/----------------------------

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
SELECT * FROM mock_data;


/*-------------------------------------------------------------------------------------------------------
SEQ_INT	 UUID									RAND_INT	RANDOM_DECIMAL	RAND_STRING		  INCR_DATE
0	     bc75e3a8-4d21-4438-8635-421b964b6a03	2			0.09	 		kbZnuGB4d0pgCip	  2021-01-01
1	     5879ab45-5085-4a20-bfcb-6d47cc90ab7e	2			0.33	 		5DTMJ5CDGUBoFWt	  2021-01-02
2	     0d107bf4-3831-4dfb-84a6-f0246189099e	2			1	     		uC12oBV9Jnywo6W	  2021-01-03
3	     d5b65912-ef0c-4386-bf86-af6f8aa6c263	9			0.78	 		78FqDoDtKgMN1bn	  2021-01-04
4	     02895be6-f83a-4741-a704-10a143894528	2			0.85	 		F91sEVR0nw9vLo5	  2021-01-05
5	     f56bccaf-2a83-4314-8c1d-7677fbc13cf1	3			0.54	 		03SKpE2vdvIUT9y	  2021-01-06
6	     11ad5cad-e98f-4258-9599-055a67879a08	9			0.33	 		3zaKpDHLpYG2Eon	  2021-01-07
7	     84c446fd-218b-4c31-b973-4e4fe3f6c36d	1			0.71	 		pH4FAr24RILUsdW	  2021-01-08
8	     05aa6dc1-ae2a-41b6-8d90-3bb2ce19b925	9			0.83	 		DwRqc6mTIXiJD44	  2021-01-09
9	     d5a7d2fa-de96-4a6f-8e57-231010b50c48	6			0.44	 		nIUJUweMA19lYyv	  2021-01-10
10	     56ace379-dd14-447d-b67e-bd8a02fc1ab5	7			0.77	 		66q1JMMlsQkFGEv	  2021-01-11
-------------------------------------------------------------------------------------------------------*/
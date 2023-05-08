--- VARIABLES
/*
WHY WOULD WE USE VARIABLES??
1. Reuse the same value in multiple places (ORY)
2. Make code more dynamic
3. Readability/Maintainability
*/

-- HOW TO SET VARIABLES
-- Set a single variable

SET team_name = 'Heat';

SELECT FROM "FIVETRAN_DATABASE"."GOOGLE_SHEETS"."NBA_PLAYERS" WHERE team = $team_name;

-- Set multiple variables at once

SET team_name ='Heat':
SET first_name = 'Kyrie':
SET last_name = 'James';

-- Instead
SET(team_name, first_name, last_name) = ('Heat", "Kyrie, James');

SELECT * 
FROM "FIVETRAN_DATABASE"."GOOGLE_SHEETS"."NBA_PLAYERS" 
WHERE team = $team name OR first_name = $first_name OR last_name = $last_name;


/*-------------
SHOW VARIABLES
-------------*/

SHOW VARIABLES;

SHOW VARIABLES LIKE '%NAME%';

SELECT $team_name;

-- These variables will be accessible on the same worksheet and sessions. Its not stored in memory.

/*-------------
UNSET VARIABLES
-------------*/

UNSET team_name;
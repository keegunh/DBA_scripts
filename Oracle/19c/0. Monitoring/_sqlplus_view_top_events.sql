TTITLE "[DBName] Database|Oracle Top Events";

SET LINESIZE 200
SET PAGESIZE 1000
SET HEADING ON

SELECT EVENT
     , COUNT(*)
  FROM GV$SESSION
 GROUP BY EVENT
 ORDER BY 2 DESC;

TTITLE OFF
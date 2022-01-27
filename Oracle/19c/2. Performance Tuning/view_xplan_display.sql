SELECT *
  FROM TABLE(DBMS_XPLAN.DISPLAY);
  
/* USAGE
EXPLAIN PLAN FOR
SELECT *
  FROM PMPBADM.TB_STC_MMS_AUTH_DTL_ERR;

SELECT *
  FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 2466785827
 
---------------------------------------------------------------------------------------------
| Id  | Operation         | Name                    | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |                         |     1 |   296 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS FULL| TB_STC_MMS_AUTH_DTL_ERR |     1 |   296 |     2   (0)| 00:00:01 |
---------------------------------------------------------------------------------------------




**Must truncate PLAN_TABLE from time to time for optimal performance.**
*/
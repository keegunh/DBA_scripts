WITH DBA_WITH_SNAPSHOT AS 
(SELECT MIN(SNAP_ID) AS BEGIN_SNAP_ID
      , MAX(SNAP_ID) AS END_SNAP_ID
  FROM DBA_HIST_SNAPSHOT
 WHERE 1=1
--   AND BEGIN_INTERVAL_TIME >= TO_DATE('2022-01-20 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
--   AND END_INTERVAL_TIME   <= TO_DATE('2022-01-20 23:59:59', 'YYYY-MM-DD HH24:MI:SS') 
   AND BEGIN_INTERVAL_TIME >= SYSDATE-1
   AND END_INTERVAL_TIME   <= SYSDATE
),
DBA_WITH_SQLSTAT AS 
(SELECT A.*
   FROM DBA_HIST_SQLSTAT A
      , DBA_WITH_SNAPSHOT X
  WHERE 1 = 1
    AND A.SNAP_ID >= X.BEGIN_SNAP_ID
    AND A.SNAP_ID <= X.END_SNAP_ID
)       
SELECT /*+ LEADING(A, B) USE_HASH(A, B) FULL(B) NO_MERGE(A) NO_MERGE(B) */ 
       A.SQL_ID
--     , A.PARSING_SCHEMA_NAME
--     , A.MODULE
--     , NULL "화명 ID"
--     , NULL "대상 업무"
     , ROW_NUMBER() OVER (ORDER BY ROUND(A.ELAPSED_TIME, 4) DESC)                             AS "합계실행시간 순위"
     , ROUND(A.ELAPSED_TIME,  4)                                                              AS "합계실행시간(초)"     
     , ROUND(A.ELAPSED_TIME     / (CASE WHEN EXECUTIONS = 0 THEN 1 ELSE A.EXECUTIONS END), 4) AS "평균실행시간(초)"
     , ROUND(A.CPU_TIME         / (CASE WHEN EXECUTIONS = 0 THEN 1 ELSE A.EXECUTIONS END), 4) AS "평균CPU시간(초)"
     , A.EXECUTIONS                                                                           AS "실행횟수"
     , A.ROWS_PROCESSED                                                                       AS "총로우수"
     , ROUND(A.ROWS_PROCESSED   / (CASE WHEN EXECUTIONS = 0 THEN 1 ELSE A.EXECUTIONS END), 0) AS "평균로우수"
     , ROUND(A.BUFFER_GETS      / (CASE WHEN EXECUTIONS = 0 THEN 1 ELSE A.EXECUTIONS END), 0) AS "평균블록I/O(개수)"
     , ROUND(A.DISK_READS       / (CASE WHEN EXECUTIONS = 0 THEN 1 ELSE A.EXECUTIONS END), 1) AS "평균DISK_READS"
     , A.CPU_TIME                                                                             AS "총CPU시간(초)"
     , B.SQL_TEXT
  FROM (SELECT /*+ LEADING(B, A) USE_HASH(A) FULL(B) FULL(A) NO_MERGE(B) NO_MERGE(A) */         
               A.SQL_ID
             , A.PARSING_SCHEMA_NAME
             , A.MODULE
             , SUM(EXECUTIONS_DELTA)             AS EXECUTIONS
             , SUM(DISK_READS_DELTA)             AS DISK_READS
             , SUM(BUFFER_GETS_DELTA)            AS BUFFER_GETS
             , SUM(ROWS_PROCESSED_DELTA)         AS ROWS_PROCESSED
             , SUM(CPU_TIME_DELTA)     / 1000000 AS CPU_TIME
             , SUM(ELAPSED_TIME_DELTA) / 1000000 AS ELAPSED_TIME
             , SUM(IOWAIT_DELTA)       / 1000000 AS IOWAIT
             , SUM(CLWAIT_DELTA)       / 1000000 AS CLWAIT
             , SUM(APWAIT_DELTA)       / 1000000 AS APWAIT
             , SUM(CCWAIT_DELTA)       / 1000000 AS CCWAIT
          FROM DBA_WITH_SQLSTAT A
             , DBA_HIST_SNAPSHOT B
         WHERE A.SNAP_ID = B.SNAP_ID
           AND A.DBID = B.DBID
           AND A.INSTANCE_NUMBER = B.INSTANCE_NUMBER
           AND A.PARSING_SCHEMA_NAME =''
         GROUP BY A.SQL_ID, A.PARSING_SCHEMA_NAME, A.MODULE ) A
     , DBA_HIST_SQLTEXT B
 WHERE A.SQL_ID = B.SQL_ID
--   AND A.MODULE = 'JDBC Thin Client'
-- ORDER BY "합계실행시간(초)" DESC
 ORDER BY "평균블록I/O(개수)"+"평균DISK_READS" DESC
;
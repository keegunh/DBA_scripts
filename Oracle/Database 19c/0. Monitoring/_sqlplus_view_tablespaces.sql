TTITLE "[DBName] Database|Oracle Tablespace Storage Info";

SET PAGESIZE 500
SET LINESIZE 200
SET HEADING ON
COL TS_NAME FORMAT A15
COL TOTAL_GB FORMAT 999,999
COL USED_GB FORMAT 999,999
COL FREE_GB FORMAT 999,999
COL USED_PCT FORMAT 999.99
COL AUTOEXTENSIBLE FORMAT A15
COL TS_NAME FORMAT A15
COL EXT_MGMT FORMAT A15
COL ALLOC_TYPE FORMAT A15
COL MIN_EXTEN_MB FORMAT 999,999
COL "ADD_DATAFILE_DDL (USED_PCT >= 90%)" FORMAT A70
SELECT A.TABLESPACE_NAME TS_NAME
     , B.GB AS TOTAL_GB
     , ROUND(C.GB, 2) AS USED_GB
     , ROUND(B.GB - C.GB, 2) AS FREE_GB
	 , TO_CHAR(ROUND(C.GB/B.GB, 4) * 100,'fm990D00','NLS_NUMERIC_CHARACTERS = ''.,''') || '%' AS USED_PCT
     , A.STATUS
     , B.AUTOEXTENSIBLE
     , A.EXTENT_MANAGEMENT AS EXT_MGMT
     , A.ALLOCATION_TYPE AS ALLOC_TYPE
     , A.MIN_EXTLEN/1024/1024 AS MIN_EXTEN_MB
     , CASE
           WHEN ROUND(C.GB/B.GB, 4) * 100 >= 90 THEN 'ALTER TABLESPACE ' || A.TABLESPACE_NAME || ' ADD DATAFILE ''+DATA'' SIZE 30G;'
           ELSE NULL
       END AS "ADD_DATAFILE_DDL (USED_PCT >= 90%)"
  FROM DBA_TABLESPACES A
     , (SELECT TABLESPACE_NAME
             , SUM(BYTES/1024/1024/1024) AS GB
             , AUTOEXTENSIBLE
          FROM DBA_DATA_FILES
         GROUP BY TABLESPACE_NAME, AUTOEXTENSIBLE) B
     , (SELECT TABLESPACE_NAME
             , SUM(BYTES/1024/1024/1024) AS GB
          FROM DBA_SEGMENTS
         GROUP BY TABLESPACE_NAME) C
 WHERE A.TABLESPACE_NAME = B.TABLESPACE_NAME (+)
   AND B.TABLESPACE_NAME = C.TABLESPACE_NAME (+)
   AND A.TABLESPACE_NAME NOT IN (SELECT TABLESPACE_NAME FROM DBA_TEMP_FILES)
 UNION ALL
SELECT A.TABLESPACE_NAME TS_NAME
     , B.GB AS TOTAL_GB
     , C.USED_GB AS USED_GB
     , C.FREE_GB AS FREE_GB
	 , TO_CHAR(C.USED_PCT,'fm990D00','NLS_NUMERIC_CHARACTERS = ''.,''') || '%' AS USED_PCT
     , A.STATUS
     , B.AUTOEXTENSIBLE
     , A.EXTENT_MANAGEMENT AS EXT_MGMT
     , A.ALLOCATION_TYPE AS ALLOC_TYPE
     , A.MIN_EXTLEN/1024/1024 AS MIN_EXTEN_MB
     , CASE
           WHEN C.USED_PCT >= 90 THEN 'ALTER TABLESPACE ' || A.TABLESPACE_NAME || ' ADD TEMPFILE ''+DATA'' SIZE 30G;'
           ELSE NULL
       END AS "ADD_DATAFILE_DDL (USED_PCT >= 90%)"
  FROM DBA_TABLESPACES A
     , (SELECT TABLESPACE_NAME
             , SUM(BYTES/1024/1024/1024) AS GB
             , AUTOEXTENSIBLE
          FROM DBA_TEMP_FILES
         GROUP BY TABLESPACE_NAME, AUTOEXTENSIBLE) B
     , (SELECT A.TABLESPACE_NAME
             , D.TOTAL_BYTES/1024/1024/1024 AS TOTAL_GB
             , SUM(A.USED_BLOCKS*D.BLOCK_SIZE)/1024/1024/1024 AS USED_GB
             , D.TOTAL_BYTES/1024/1024/1024 - SUM(A.USED_BLOCKS*D.BLOCK_SIZE)/1024/1024/1024 AS FREE_GB
             , ROUND(SUM(A.USED_BLOCKS*D.BLOCK_SIZE) / D.TOTAL_BYTES * 100, 4) AS USED_PCT
          FROM V$SORT_SEGMENT A,
               (SELECT B.NAME
                     , C.BLOCK_SIZE
                     , SUM(C.BYTES) AS TOTAL_BYTES
                  FROM V$TABLESPACE B
                     , V$TEMPFILE C
                 WHERE B.TS# = C.TS#
                 GROUP BY B.NAME, C.BLOCK_SIZE) D
         WHERE A.TABLESPACE_NAME = D.NAME
         GROUP BY A.TABLESPACE_NAME, D.TOTAL_BYTES) C
 WHERE A.TABLESPACE_NAME = B.TABLESPACE_NAME (+)
   AND A.TABLESPACE_NAME = C.TABLESPACE_NAME
 ORDER BY 1;

TTITLE OFF

TTITLE "[DBName] Database|Oracle Copy Table Partition Statistics"

SET PAGESIZE 1000
SET LINESIZE 250
SET HEADING ON
COL OWNER FORMAT A10
COL TABLE_NAME FORMAT A35
COL PART_NAME FORMAT A10
COL PART_POS FORMAT 999
COL SUBPART_NAME FORMAT A16
COL SUBPART_POS FORMAT 999
COL OBJ_TYPE FORMAT A12
COL FIRST_PART_NAME FORMAT A10 HEADING FIRST|PART_NAME
COL FIRST_SUBPART_NAME FORMAT A16 HEADING FIRST|SUBPART_NAME
COL LAST_ANALYZED_PART FORMAT A10 HEADING LAST_ANALYZED|PART_NAME
COL LAST_ANALYZED_SUBPART FORMAT A16 HEADING LAST_ANALYZED|SUBPART_NAME
COL LAST_ANALYZED FORMAT A19
COL COPY_STATS_DDL FORMAT A250

WITH TEMP_TAB_STATS AS (
   SELECT *
     FROM DBA_TAB_STATISTICS
    WHERE OWNER IN ('')
      AND OBJECT_TYPE = 'PARTITION'
--      AND OBJECT_TYPE = 'SUBPARTITION'
)
SELECT 
       -- A.OWNER
     -- , A.TABLE_NAME
     -- , A.PARTITION_NAME AS PART_NAME
     -- , A.PARTITION_POSITION AS PART_POS
     -- , A.SUBPARTITION_NAME AS SUBPART_NAME
     -- , A.SUBPARTITION_POSITION AS SUBPART_POS
     -- , A.OBJECT_TYPE AS OBJ_TYPE
     -- , C.FIRST_PART_NAME
     -- , C.FIRST_SUBPART_NAME
     -- , B.LAST_ANALYZED_PART
     -- , B.LAST_ANALYZED_SUBPART
	 -- , TO_CHAR(B.LAST_ANALYZED, 'YYYY/MM/DD HH24:MM:SS') AS LAST_ANALYZED
       CASE WHEN A.OBJECT_TYPE = 'PARTITION' AND B.LAST_ANALYZED IS NOT NULL
            THEN 'EXEC DBMS_STATS.COPY_TABLE_STATS(OWNNAME=>''' || A.OWNER || ''', TABNAME=>''' || A.TABLE_NAME || ''', SRCPARTNAME=> ''' || B.LAST_ANALYZED_PART || ''', DSTPARTNAME=>''' || A.PARTITION_NAME    || ''');' 
            WHEN A.OBJECT_TYPE = 'PARTITION' AND B.LAST_ANALYZED IS NULL AND PARTITION_POSITION = 1
            THEN 'EXEC DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>''' || A.OWNER || ''', TABNAME=>''' || A.TABLE_NAME || ''', GRANULARITY=>''PARTITION'', PARTNAME=>''' || A.PARTITION_NAME || ''', DEGREE=>8, CASCADE=>TRUE, METHOD_OPT=>''FOR ALL COLUMNS SIZE 1'', NO_INVALIDATE=>FALSE, ESTIMATE_PERCENT=>DBMS_STATS.AUTO_SAMPLE_SIZE);'
            WHEN A.OBJECT_TYPE = 'PARTITION' AND B.LAST_ANALYZED IS NULL AND PARTITION_POSITION < > 1
            THEN 'EXEC DBMS_STATS.COPY_TABLE_STATS(OWNNAME=>''' || A.OWNER || ''', TABNAME=>''' || A.TABLE_NAME || ''', SRCPARTNAME=> ''' || C.FIRST_PART_NAME || ''', DSTPARTNAME=>''' || A.PARTITION_NAME    || ''');' 
            WHEN A.OBJECT_TYPE = 'SUBPARTITION' AND B.LAST_ANALYZED IS NOT NULL
            THEN 'EXEC DBMS_STATS.COPY_TABLE_STATS(OWNNAME=>''' || A.OWNER || ''', TABNAME=>''' || A.TABLE_NAME || ''', SRCPARTNAME=> ''' || B.LAST_ANALYZED_SUBPART || ''', DSTPARTNAME=>''' || A.SUBPARTITION_NAME || ''');'
            WHEN A.OBJECT_TYPE = 'SUBPARTITION' AND B.LAST_ANALYZED IS NULL AND SUBPARTITION_POSITION = 1
            THEN 'EXEC DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>''' || A.OWNER || ''', TABNAME=>''' || A.TABLE_NAME || ''', GRANULARITY=>''SUBPARTITION'', PARTNAME=>''' || A.SUBPARTITION_NAME || ''', DEGREE=>8, CASCADE=>TRUE, METHOD_OPT=>''FOR ALL COLUMNS SIZE 1'', NO_INVALIDATE=>FALSE, ESTIMATE_PERCENT=>DBMS_STATS.AUTO_SAMPLE_SIZE);'
            WHEN A.OBJECT_TYPE = 'SUBPARTITION' AND B.LAST_ANALYZED IS NULL AND SUBPARTITION_POSITION < > 1
            THEN 'EXEC DBMS_STATS.COPY_TABLE_STATS(OWNNAME=>''' || A.OWNER || ''', TABNAME=>''' || A.TABLE_NAME || ''', SRCPARTNAME=> ''' || C.FIRST_SUBPART_NAME || ''', DSTPARTNAME=>''' || A.SUBPARTITION_NAME || ''');'
            ELSE NULL
       END COPY_STATS_DDL
          FROM (SELECT OWNER
             , TABLE_NAME
             , PARTITION_NAME
             , PARTITION_POSITION
             , SUBPARTITION_NAME
             , SUBPARTITION_POSITION
             , OBJECT_TYPE
          FROM TEMP_TAB_STATS
         WHERE LAST_ANALYZED IS NULL) A
     , (SELECT OWNER
             , TABLE_NAME
             , MAX(PARTITION_NAME) AS LAST_ANALYZED_PART
             , MAX(SUBPARTITION_NAME) AS LAST_ANALYZED_SUBPART
             , MAX(LAST_ANALYZED) AS LAST_ANALYZED
          FROM TEMP_TAB_STATS
         WHERE LAST_ANALYZED IS NOT NULL
         GROUP BY OWNER, TABLE_NAME
       ) B
     , (SELECT OWNER
             , TABLE_NAME
             , MIN(PARTITION_NAME) AS FIRST_PART_NAME
             , MIN(SUBPARTITION_NAME) AS FIRST_SUBPART_NAME
          FROM TEMP_TAB_STATS
         WHERE LAST_ANALYZED IS NULL
         GROUP BY OWNER, TABLE_NAME) C
 WHERE 1=1
   AND A.OWNER = B.OWNER (+)
   AND A.TABLE_NAME = B.TABLE_NAME (+)
   AND A.OWNER = C.OWNER 
   AND A.TABLE_NAME = C.TABLE_NAME
 ORDER BY A.OWNER, A.TABLE_NAME, DECODE(A.OBJECT_TYPE, 'TABLE', 1, 'PARTITION', 2, 'SUBPARTITION', 3), A.PARTITION_NAME, A.SUBPARTITION_NAME
;
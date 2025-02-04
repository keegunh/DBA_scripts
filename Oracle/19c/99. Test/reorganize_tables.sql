-- NEEDS TESTING! --

TTITLE "[DBName] Database|Oracle Reorganize Tables"

SET PAGESIZE 1000
SET LINESIZE 250
SET HEADING ON
COL OWNER FORMAT A10
COL TABLE_NAME FORMAT A35
COL PARTITIONED FORMAT A11

SELECT OWNER
     , TABLE_NAME
     , PARTITIONED
     , 'ALTER TABLE ' || OWNER || '.' || TABLE_NAME || ' ENABLE ROW MOVEMENT;' AS DDL1
     , 'ALTER TABLE ' || OWNER || '.' || TABLE_NAME || ' SHRINK SPACE COMPACT;' AS DDL2
     , 'ALTER TABLE ' || OWNER || '.' || TABLE_NAME || ' SHRINK SPACE;' AS DDL3
  FROM DBA_TABLES
 WHERE OWNER IN ('')
;
  
TTITLE OFF






-- 1. 테이블 통계 업데이트 후 
SELECT OWNER
     , TABLE_NAME
     , PARTITION_NAME
     , PARTITION_POSITION
     , SUBPARTITION_NAME
     , SUBPARTITION_POSITION
     , OBJECT_TYPE
     , DECODE(OBJECT_TYPE, 'TABLE', 'EXEC DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>''' || OWNER || ''', TABNAME=>''' || TABLE_NAME || ''', GRANULARITY=>''ALL'', DEGREE=>8, CASCADE=>TRUE, METHOD_OPT=>''FOR ALL COLUMNS SIZE 1'', NO_INVALIDATE=>FALSE, ESTIMATE_PERCENT=>DBMS_STATS.AUTO_SAMPLE_SIZE);'
                         , 'PARTITION', 'EXEC DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>''' || OWNER || ''', TABNAME=>''' || TABLE_NAME || ''', GRANULARITY=>''PARTITION'', PARTNAME=>''' || PARTITION_NAME || ''', DEGREE=>8, CASCADE=>TRUE, METHOD_OPT=>''FOR ALL COLUMNS SIZE 1'', NO_INVALIDATE=>FALSE, ESTIMATE_PERCENT=>DBMS_STATS.AUTO_SAMPLE_SIZE);'
                         , 'SUBPARTITION', 'EXEC DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>''' || OWNER || ''', TABNAME=>''' || TABLE_NAME || ''', GRANULARITY=>''SUBPARTITION'', PARTNAME=>''' || SUBPARTITION_NAME || ''', DEGREE=>8, CASCADE=>TRUE, METHOD_OPT=>''FOR ALL COLUMNS SIZE 1'', NO_INVALIDATE=>FALSE, ESTIMATE_PERCENT=>DBMS_STATS.AUTO_SAMPLE_SIZE);' 
       ) GATHER_STATS_DDL
  FROM DBA_TAB_STATISTICS
 WHERE 1=1
   AND OWNER IN ('')
--   AND LAST_ANALYZED IS NULL
   AND OBJECT_TYPE = 'TABLE'
--   AND OBJECT_TYPE = 'PARTITION'
--   AND OBJECT_TYPE = 'SUBPARTITION'
--   AND TABLE_NAME = ''
 ORDER BY OWNER, TABLE_NAME, DECODE(OBJECT_TYPE, 'TABLE', 1, 'PARTITION', 2, 'SUBPARTITION', 3), PARTITION_NAME, SUBPARTITION_NAME
;


-- 2. FRAGMENTATION PERCENTAGE가 20% 이상인 것을 MOVE
SELECT TABLE_NAME
     , AVG_ROW_LEN
     , ROUND(((BLOCKS*16/1024)),2)||'MB' AS TOTAL_SIZE
     , ROUND((NUM_ROWS*AVG_ROW_LEN/1024/1024),2)||'MB' AS ACTUAL_SIZE
     , ROUND(((BLOCKS*16/1024)-(NUM_ROWS*AVG_ROW_LEN/1024/1024)),2) ||'MB' AS FRAGMENTED_SPACE
     , ROUND((((BLOCKS*16/1024)-(NUM_ROWS*AVG_ROW_LEN/1024/1024))/((BLOCKS*16/1024)))*100,2) AS PERCENTAGE
     , TABLESPACE_NAME
     , PARTITIONED 
     , 'ALTER TABLE ' || OWNER || '.' || TABLE_NAME || ' MOVE TABLESPACE ' || TABLESPACE_NAME || ';' AS REORG_DDL
  FROM DBA_TABLES 
 WHERE BLOCKS < > 0
   AND OWNER IN ('')
;


-- ************************** CHECK FOR UNUSABLE INDEXES AFTER MOVING TABLESPACES OF TABLES **************************
SELECT TABLE_OWNER
     , TABLE_NAME
     , TABLE_TYPE
     , INDEX_NAME
     , INDEX_TYPE
     , TABLESPACE_NAME
     , STATUS
     , 'ALTER INDEX ' || OWNER || '.' || INDEX_NAME || ' REBUILD;' AS REBUILD_DDL
  FROM DBA_INDEXES
 WHERE OWNER = ''
   AND STATUS = 'UNUSABLE';
 
SELECT INDEX_OWNER
     , INDEX_NAME
     , PARTITION_NAME
     , TABLESPACE_NAME
     , STATUS
     , 'ALTER INDEX ' || INDEX_OWNER || '.' || INDEX_NAME || ' REBUILD PARTITION ' || PARTITION_NAME || ';' AS REBUILD_DDL
  FROM DBA_IND_PARTITIONS
 WHERE INDEX_OWNER = ''
   AND STATUS = 'UNUSABLE';
   
SELECT INDEX_OWNER
     , INDEX_NAME
     , SUBPARTITION_NAME
     , TABLESPACE_NAME
     , STATUS
     , 'ALTER INDEX ' || INDEX_OWNER || '.' || INDEX_NAME || ' REBUILD PARTITION ' || SUBPARTITION_NAME || ';' AS REBUILD_DDL
  FROM DBA_IND_SUBPARTITIONS
 WHERE INDEX_OWNER = ''
   AND STATUS = 'UNUSABLE'; 





/* 참고
SELECT * FROM (DBMS_SPACE.ASA_RECOMMENDATIONS());
*/
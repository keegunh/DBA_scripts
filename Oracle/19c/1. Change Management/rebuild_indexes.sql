/*
* Indexes are typically rebuilt when their BLEVEL (branch level) exceeds 4
* or when their PCT_DELETE exceeds 20%
*/
SELECT 
       A.TABLE_OWNER AS TAB_OWNER
     , A.TABLE_NAME
     , A.INDEX_NAME
     , A.INDEX_TYPE
     , A.BLEVEL
     , A.UNIQUENESS
     , A.PARTITIONED
     , B.LOCALITY
     , NVL(A.TABLESPACE_NAME, B.DEF_TABLESPACE_NAME) AS TS_NAME
     , A.STATUS
     , NVL(A.PCT_FREE, B.DEF_PCT_FREE) AS PCT_FREE
     , NVL(A.LOGGING, B.DEF_LOGGING) AS LOGGING
     , A.DEGREE
     , A.VISIBILITY
     , TO_CHAR(A.LAST_ANALYZED, 'YYYY/MM/DD HH24:MM:SS') AS LAST_ANALYZED
     , 'ANALYZE INDEX ' || A.OWNER || '.' || A.INDEX_NAME || ' VALIDATE STRUCTURE;' ANALYZE_DDL
     , 'SELECT DEL_LF_ROWS * 100 / DECODE(LF_ROWS, 0, 1, LF_ROWS) PCT_DELETED FROM INDEX_STATS WHERE NAME = ''' || A.INDEX_NAME || '''' AS "QRY_PCT_DELETE (REBUILD IF PCT_DELETE > 20)"
	 , 'ALTER INDEX ' || A.OWNER || '.' || A.INDEX_NAME || ' REBUILD;' AS REBUILD_DDL
  FROM DBA_INDEXES A
     , DBA_PART_INDEXES B
 WHERE A.OWNER = B.OWNER (+)
   AND A.INDEX_NAME = B.INDEX_NAME (+)
   AND TABLE_OWNER IN ('PMPBADM'
                     , 'BLCP01ADM'
                     , 'BLCP02ADM'
                     , 'BLCP03ADM'
                     , 'BLCP04ADM'
                     , 'BLCP05ADM'
                     , 'BLCP06ADM'
                     , 'BLCP07ADM'
                     , 'BLCP08ADM'
                     , 'BLCP09ADM'
                     , 'BLCP10ADM')
   AND A.INDEX_TYPE < > 'LOB'
   AND A.BLEVEL > 3
 ORDER BY A.TABLE_OWNER, A.TABLE_NAME, A.INDEX_NAME
;
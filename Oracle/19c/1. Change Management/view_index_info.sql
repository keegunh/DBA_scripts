SELECT /*+FULL(A) PARALLEL(A 8) */
       A.OWNER
     , A.TABLE_NAME
     , A.INDEX_NAME
     , A.INDEX_TYPE
     , NVL(A.TABLESPACE_NAME, B.DEF_TABLESPACE_NAME) AS TABLESPACE_NAME
     , A.PARTITIONED
     , B.LOCALITY
     , A.UNIQUENESS
     , NVL(A.LOGGING, B.DEF_LOGGING) AS LOGGING
     , A.DEGREE
     , A.BLEVEL
     , LISTAGG(C.COLUMN_NAME, ', ') WITHIN GROUP (ORDER BY COLUMN_POSITION) AS COLUMNS
  FROM DBA_INDEXES A
     , DBA_PART_INDEXES B
     , DBA_IND_COLUMNS C
 WHERE A.OWNER = B.OWNER (+)
   AND A.INDEX_NAME = B.INDEX_NAME (+)
   AND A.OWNER = C.INDEX_OWNER
   AND A.INDEX_NAME = C.INDEX_NAME
   AND NOT EXISTS (SELECT 1 FROM DBA_CONSTRAINTS D WHERE A.OWNER = D.OWNER AND A.INDEX_NAME = D.INDEX_NAME AND D.CONSTRAINT_TYPE = 'P')
   AND A.OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM')
   AND A.INDEX_NAME NOT LIKE 'SYS\_%' ESCAPE '\'
 GROUP BY A.OWNER, A.TABLE_NAME, A.INDEX_NAME, A.INDEX_TYPE, A.TABLESPACE_NAME, B.DEF_TABLESPACE_NAME, A.PARTITIONED, B.LOCALITY, A.UNIQUENESS, A.LOGGING, B.DEF_LOGGING, A.DEGREE, A.BLEVEL
 ORDER BY 1,2,3
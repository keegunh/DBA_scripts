SELECT A.OWNER
     , A.TABLE_NAME
     , NVL(A.TABLESPACE_NAME, B.DEF_TABLESPACE_NAME) AS TABLESPACE_NAME
     , C.COMMENTS
     , B.PARTITIONING_TYPE
     , E.PART_KEY
     , MIN(D.PARTITION_NAME) AS MIN_PART
     , MAX(D.PARTITION_NAME) AS MAX_PART
     , B.SUBPARTITIONING_TYPE
     , MAX(D.SUBPARTITION_COUNT) AS SUBPARTITION_COUNT
  FROM DBA_TABLES A
     , DBA_PART_TABLES B
     , DBA_TAB_COMMENTS C
     , DBA_TAB_PARTITIONS D
     , (SELECT OWNER
             , NAME
             , LISTAGG(COLUMN_NAME, ',') WITHIN GROUP (ORDER BY COLUMN_POSITION) AS PART_KEY
          FROM DBA_PART_KEY_COLUMNS
         WHERE OWNER IN (
                        'PMPBADM'
                      , 'BLCP01ADM'
                      , 'BLCP02ADM'
                      , 'BLCP03ADM'
                      , 'BLCP04ADM'
                      , 'BLCP05ADM'
                      , 'BLCP06ADM'
                      , 'BLCP07ADM'
                      , 'BLCP08ADM'
                      , 'BLCP09ADM'
                      , 'BLCP10ADM'
                      )
           AND OBJECT_TYPE = 'TABLE'
         GROUP BY OWNER, NAME) E
 WHERE A.OWNER = B.OWNER (+)
   AND A.TABLE_NAME = B.TABLE_NAME (+)
   AND A.OWNER = C.OWNER (+)
   AND A.TABLE_NAME = C.TABLE_NAME (+)
   AND A.OWNER = D.TABLE_OWNER (+)
   AND A.TABLE_NAME = D.TABLE_NAME (+)
   AND A.OWNER = E.OWNER (+)
   AND A.TABLE_NAME = E.NAME (+)
   AND A.OWNER IN (
                  'PMPBADM'
                , 'BLCP01ADM'
                , 'BLCP02ADM'
                , 'BLCP03ADM'
                , 'BLCP04ADM'
                , 'BLCP05ADM'
                , 'BLCP06ADM'
                , 'BLCP07ADM'
                , 'BLCP08ADM'
                , 'BLCP09ADM'
                , 'BLCP10ADM'
                )
 GROUP BY A.OWNER, A.TABLE_NAME, A.TABLESPACE_NAME, B.DEF_TABLESPACE_NAME, C.COMMENTS, B.PARTITIONING_TYPE, E.PART_KEY, B.SUBPARTITIONING_TYPE
 ORDER BY A.OWNER,A.TABLE_NAME;
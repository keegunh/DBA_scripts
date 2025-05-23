SELECT A.OWNER
     , A.TABLE_NAME
     --, B.COMMENTS
     , C.COLUMN_NAME
     , D.COMMENTS
     , C.DATA_TYPE
     , C.DATA_LENGTH
     , C.DATA_PRECISION
     , C.DATA_SCALE
     , C.NULLABLE
     , C.COLUMN_ID
     , C.DATA_DEFAULT
     --, C.DEFAULT_LENGTH
     , C.NUM_DISTINCT
     , C.LAST_ANALYZED
  FROM DBA_TABLES A
     , DBA_TAB_COMMENTS B
     , DBA_TAB_COLS C
     , DBA_COL_COMMENTS D
 WHERE A.OWNER = B.OWNER (+)
   AND A.TABLE_NAME = B.TABLE_NAME (+)
   AND A.OWNER = C.OWNER (+)
   AND A.TABLE_NAME = C.TABLE_NAME (+)
   AND A.OWNER = D.OWNER (+)
   AND A.TABLE_NAME = D.TABLE_NAME (+)
   AND A.OWNER IN ('')
   AND A.TABLE_NAME NOT LIKE 'DR$%'
 ORDER BY A.OWNER, A.TABLE_NAME, C.COLUMN_ID
;
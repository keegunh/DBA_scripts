-- PARALLEL TABLE 확인
SELECT OWNER
     , TABLE_NAME
     , DEGREE
     , 'ALTER TABLE ' || OWNER || '.' || TABLE_NAME || ' NOPARALLEL;' AS DDL
  FROM DBA_TABLES
 WHERE OWNER IN ('')
   AND TRIM(DEGREE) <> '1';
 
-- PARALLEL INDEX 확인
SELECT OWNER
     , TABLE_NAME
     , INDEX_NAME
     , DEGREE
     , 'ALTER INDEX ' || OWNER || '.' || INDEX_NAME || ' NOPARALLEL;' AS DDL
  FROM DBA_INDEXES
 WHERE OWNER IN ('')
   AND TRIM(DEGREE) <> '1'
   AND INDEX_TYPE <> 'LOB';
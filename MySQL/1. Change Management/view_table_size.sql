-- 각 테이블 실 데이터 사이즈 (테이블 + 인덱스)
SELECT TABLE_SCHEMA "DB_NAME"
     , TABLE_NAME 
     , ROUND(SUM(DATA_LENGTH + INDEX_LENGTH)/1024/1024/1024, 2) "DB_SIZE_GB" 
  FROM INFORMATION_SCHEMA.TABLES 
 WHERE TABLE_SCHEMA NOT IN ( 
  'mysql'
, 'information_schema'
, 'performance_schema'
, 'sys'
)
 GROUP BY TABLE_SCHEMA, TABLE_NAME
 ORDER BY 1,2
;

-- 각 테이블 ROW COUNT
SELECT TABLE_SCHEMA "DB_NAME"
     , TABLE_NAME 
     , CONCAT('SELECT ''', TABLE_SCHEMA, '.', TABLE_NAME, ''' AS TABLE_NAME, COUNT(1) AS CNT FROM ', TABLE_SCHEMA, '.', TABLE_NAME, ' UNION ALL ') AS SELECT_CNT
  FROM INFORMATION_SCHEMA.TABLES 
 WHERE TABLE_SCHEMA NOT IN ( 
       'mysql'
     , 'information_schema'
     , 'performance_schema'
     , 'sys'
     )
 ORDER BY 1,2
;

-- 테이블 당 할당된 TABLESPACE 확인
SELECT
       NAME
     , ROUND(FILE_SIZE/POW(1024,3),2) AS FILE_SIZE_GIB
     , ROUND(ALLOCATED_SIZE/POW(1024,3),2) AS ALLOCATED_SIZE_GIB
--      , PAGE_SIZE
--      , SPACE
--      , FLAG
--      , ROW_FORMAT
--      , ZIP_PAGE_SIZE
--      , SPACE_TYPE
--      , FS_BLOCK_SIZE
--      , SERVER_VERSION
--      , SPACE_VERSION
--      , ENCRYPTION
--      , STATE
  FROM INFORMATION_SCHEMA.INNODB_TABLESPACES
 WHERE NAME NOT REGEXP 'mysql|information_schema|performance_schema|sys'
   AND ROW_FORMAT NOT IN ('Undo', 'Compact or Redundant')
 ORDER BY 3 DESC
;
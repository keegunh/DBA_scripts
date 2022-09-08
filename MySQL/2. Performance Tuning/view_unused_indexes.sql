-- MySQL 서버가 구동된 시점부터 현재까지 사용되지 않은 인덱스 목록
-- 제거할 때는 안전하게 인덱스가 쿼리에 사용되지 앟는 INVISIBLE 상태로 먼저 변경해서 일정 기간 동안 문제가 없음을 확인한 후 제거
SELECT object_schema
     , object_name
     , index_name
     , CONCAT('ALTER TABLE ', object_schema, '.', object_name, ' ALTER INDEX ', index_name, ' INVISIBLE;') as invisible_ddl
     , CONCAT('ALTER TABLE ', object_schema, '.', object_name, ' DROP INDEX ', index_name, ';') as drop_ddl
  FROM sys.schema_unused_indexes
 WHERE object_schema not in ('information_schema', 'performance_schema', 'mysql', 'sys')
;

-- 인덱스 INVISIBLE 상태 확인
SELECT TABLE_NAME, INDEX_NAME, IS_VISIBLE
  FROM INFORMATION_SCHEMA.STATISTICS;
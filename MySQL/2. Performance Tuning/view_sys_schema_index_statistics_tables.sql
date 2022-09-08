-- 테이블에 존재하는 각 인덱스의 통계 정보 확인
-- x$schema_index_statistics
SELECT table_schema
     , table_name
     , index_name
     , rows_selected
     , select_latency
     , rows_inserted
     , insert_latency
     , rows_updated
     , update_latency
     , rows_deleted
     , delete_latency
  FROM sys.schema_index_statistics;

-- 인덱스 칼럼 구성이 동일한 테이블 내 다른 인덱스의 칼럼 구성과 중복되는 인덱스에 대한 정보 확인
-- 인덱스를 구성하는 칼럼들의 순서가 동일해야 중복된 인덱스루 간주
-- 칼럼 구성이 오나전히 동일해야 하는 것이 아니라 포함 관계인 경우도 해당
SELECT table_schema
     , table_name
     , redundant_index_name
     , redundant_index_columns
     , redundant_index_non_unique
     , dominant_index_name
     , dominant_index_columns
     , dominant_index_non_unique
     , subpart_exists
     , sql_drop_index
  FROM sys.schema_redundant_indexes;

-- 사용자가 생성한 테이블들에 존재하는 인덱스들의 목록 확인
-- 인덱스 이름 및 유니크 속성, 구성 칼럼 등의 정보 확인
SELECT table_schema
     , table_name
     , index_name
     , non_unique
     , subpart_exists
     , index_columns
  FROM sys.x$schema_flattened_keys;

-- MySQL 서버가 구동 중인 기간 동안 테이블에서 사용되지 않은 인덱스들의 목록 확인
SELECT object_schema
     , object_name
     , index_name
  FROM sys.schema_unused_indexes;
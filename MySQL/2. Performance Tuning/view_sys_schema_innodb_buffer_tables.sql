-- DB별로 사용 중인 메모리 및 데이터 양, 페이지 수 등에 대한 정보 확인.
-- 이 뷰는 information_schema.INNODB_BUFFER_PAGE 테이블 데이터를 조회하는데,
-- 이 때 MySQL 서버 성능에 영향을 주므로 서비스에서 사용 중인 MySQL 서버에서 해당 뷰를 조회할 때 주의 필요
-- x$innodb_buffer_stats_by_schema
SELECT object_schema
     , allocated
     , data
     , pages
     , pages_hashed
     , pages_old
     , rows_cached
  FROM sys.innodb_buffer_stats_by_schema;

-- 테이블별로 사용 중인 메모리 및 데이터 양, 페이지 수 등에 대한 정보 확인.
-- 이 뷰는 information_schema.INNODB_BUFFER_PAGE 테이블 데이터를 조회하는데,
-- 이 때 MySQL 서버 성능에 영향을 주므로 서비스에서 사용 중인 MySQL 서버에서 해당 뷰를 조회할 때 주의 필요
-- x$innodb_buffer_stats_by_table
SELECT object_schema
     , object_name
     , allocated
     , data
     , pages
     , pages_hashed
     , pages_old
     , rows_cached
  FROM sys.innodb_buffer_stats_by_table;
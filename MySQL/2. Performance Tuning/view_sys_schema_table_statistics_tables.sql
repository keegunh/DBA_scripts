-- 각 테이블에 대해 데이터 작업 유형별(Fetched/Inserted/Updated/Deleted) 수행 횟수와 지연 시간;I/O 발생량 및 지연 시간 등을 포함하는 통계 정보 확인
-- I/O 관련된 정보들은 x$ps_schema_table_statistics_io 뷰에서 제공하는 데이터를 참조
-- x$schema_table_statistics
SELECT table_schema
     , table_name
     , total_latency
     , rows_fetched
     , fetch_latency
     , rows_inserted
     , insert_latency
     , rows_updated
     , update_latency
     , rows_deleted
     , delete_latency
     , io_read_requests
     , io_read
     , io_read_latency
     , io_write_requests
     , io_write
     , io_write_latency
     , io_misc_requests
     , io_misc_latency
  FROM sys.schema_table_statistics;

-- 테이블 또는 파일별로 발생한 I/O에 대해 읽기 및 쓰기의 발생 횟수;발생량;처리 시간의 총 합에 대한 정보를 로우 형식으로 확인
SELECT table_schema
     , table_name
     , count_read
     , sum_number_of_bytes_read
     , sum_timer_read
     , count_write
     , sum_number_of_bytes_write
     , sum_timer_write
     , count_misc
     , sum_timer_misc
  FROM sys.x$ps_schema_table_statistics_io

-- schema_table_statistics 뷰에서 제공하는 정보와 더불어 각 테이블의 InnoDB 버퍼풀 사용에 대한 통계 정보를 함께 확인
-- 뷰 실행 시 information_schema.INNODB_BUFFER_PAGE 테이블 데이터를 조회하므로 서비스에서 사용 중인 MySQL 서버에서 해당 뷰를 조회할 때 주의 필요
-- x$schema_table_statistics_with_buffer
SELECT table_schema
     , table_name
     , rows_fetched
     , fetch_latency
     , rows_inserted
     , insert_latency
     , rows_updated
     , update_latency
     , rows_deleted
     , delete_latency
     , io_read_requests
     , io_read
     , io_read_latency
     , io_write_requests
     , io_write
     , io_write_latency
     , io_misc_requests
     , io_misc_latency
     , innodb_buffer_allocated
     , innodb_buffer_data
     , innodb_buffer_free
     , innodb_buffer_pages
     , innodb_buffer_pages_hashed
     , innodb_buffer_pages_old
     , innodb_buffer_rows_cached
  FROM sys.schema_table_statistics_with_buffer;

-- 전체 테이블 스캔이 발생한 테이블들의 목록 확인
-- x$schema_tables_with_full_table_scans
SELECT object_schema
     , object_name
     , rows_full_scanned
     , latency
  FROM sys.schema_tables_with_full_table_scans;
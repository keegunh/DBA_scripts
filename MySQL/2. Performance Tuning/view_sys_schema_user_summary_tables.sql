-- 유저별로 처리 쿼리 및 파일 I/O 관련된 정보;그리고 커넥션 수 및 메모리 사용량 등의 종합적인 정보를 확인
-- x$user_summary
SELECT user
     , statements
     , statement_latency
     , statement_avg_latency
     , table_scans
     , file_ios
     , file_io_latency
     , current_connections
     , total_connections
     , unique_hosts
     , current_memory
     , total_memory_allocated
  FROM sys.user_summary;

-- 유저별로 발생한 파일 I/O 이벤트 총수와 대기 시간 총합에 대한 정보 확인
-- x$user_summary_by_file_io
SELECT user
     , ios
     , io_latency
  FROM sys.user_summary_by_file_io;

-- 유저 및 파일 I/O 이벤트 유형별로 발생한 파일 I/O 이벤트 총수 및 대기 시간에 대한 정보 확인
-- x$user_summary_by_file_io_type
SELECT user
     , event_name
     , total
     , latency
     , max_latency
  FROM sys.user_summary_by_file_io_type;

-- 유저별로 실행된 쿼리들의 처리 단계(Stage)별 이벤트 총수와 대기 시간에 대한 정보 확인
-- x$user_summary_by_stages
SELECT user
     , event_name
     , total
     , total_latency
     , avg_latency
  FROM sys.user_summary_by_stages;

-- 유저별로 쿼리 처리와 관련해서 지연 시간;접근한 로우 수;풀스캔으로 처리된 횟수 등에 대한 정보 확인
-- x$user_summary_by_statement_latency
SELECT user
     , total
     , total_latency
     , max_latency
     , lock_latency
     , rows_sent
     , rows_examined
     , rows_affected
     , full_scans
  FROM sys.user_summary_by_statement_latency;

-- 유저별로 실행된 명령문 유형별 지연 시간;접근한 로우 수;풀스캔으로 처리된 횟수 등에 대한 정보 확인
-- x$user_summary_by_statement_type
SELECT user
     , statement
     , total
     , total_latency
     , max_latency
     , lock_latency
     , rows_sent
     , rows_examined
     , rows_affected
     , full_scans
  FROM sys.user_summary_by_statement_type;
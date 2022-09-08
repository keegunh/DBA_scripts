-- 스레드별로 I/O 대기 시간에 대한 정보 확인
-- x$io_by_thread_by_latency
SELECT user
     , total
     , total_latency
     , min_latency
     , avg_latency
     , max_latency
     , thread_id
     , processlist_id
  FROM sys.io_by_thread_by_latency;

-- MySQL에서 접근했던 파일별로 읽기 및 쓰기 양에 대한 정보 확인
-- x$io_global_by_file_by_bytes
SELECT file
     , count_read
     , total_read
     , avg_read
     , count_write
     , total_written
     , avg_write
     , total
     , write_pct
  FROM sys.io_global_by_file_by_bytes;

-- MySQL에서 접근했던 파일별로 ㅇ릭기 및 쓰기 지연 시간에 대한 정보 확인
-- x$io_global_by_file_by_latency
SELECT file
     , total
     , total_latency
     , count_read
     , read_latency
     , count_write
     , write_latency
     , count_misc
     , misc_latency
  FROM sys.io_global_by_file_by_latency;

-- 발생한 I/O 이벤트별로 지연 시간 통계 및 읽기, 쓰기 양에 대한 정보 확인
-- x$io_global_by_wait_by_bytes
SELECT event_name
     , total
     , total_latency
     , min_latency
     , avg_latency
     , max_latency
     , count_read
     , total_read
     , avg_read
     , count_write
     , total_written
     , avg_written
     , total_requested
  FROM sys.io_global_by_wait_by_bytes;

-- 발생한 I/O이벤트별로 I/O 읽기 및 쓰기 각각에 대한 총 지연 시간과 지연 시간 통계 및 읽기, 쓰기 양에 대한 정보 확인
-- x$io_global_by_wait_by_latency
SELECT event_name
     , total
     , total_latency
     , avg_latency
     , max_latency
     , read_latency
     , write_latency
     , misc_latency
     , count_read
     , total_read
     , avg_read
     , count_write
     , total_written
     , avg_written
  FROM sys.io_global_by_wait_by_latency;

-- 스레드 및 파일별로 최근 발생한 I/O 유형과 지연 시간, 처리량에 대한 정보 확인
-- x$latest_file_io
SELECT thread
     , file
     , latency
     , operation
     , requested
  FROM sys.latest_file_io;
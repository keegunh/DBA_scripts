-- 호스트별로 메모리 사용량에 대한 정보 확인
-- x$memory_by_host_by_current_bytes
SELECT host
     , current_count_used
     , current_allocated
     , current_avg_alloc
     , current_max_alloc
     , total_allocated
  FROM sys.memory_by_host_by_current_bytes
 ORDER BY current_allocated DESC;

-- 스레드별로 메모리 사용량에 대한 정보 확인
-- x$memory_by_thread_by_current_bytes
SELECT thread_id
     , user
     , current_count_used
     , current_allocated
     , current_avg_alloc
     , current_max_alloc
     , total_allocated
  FROM sys.memory_by_thread_by_current_bytes
 ORDER BY current_allocated DESC;
 
-- 유저별 메모리 사용량에 대한 정보 확인
-- x$memory_by_user_by_current_bytes
SELECT user
     , current_count_used
     , current_allocated
     , current_avg_alloc
     , current_max_alloc
     , total_allocated
  FROM sys.memory_by_user_by_current_bytes
 ORDER BY current_allocated DESC;

-- 발생한 메모리 할당 이벤트별로 메모리 사용량에 대한 정보 확인
-- x$memory_global_by_current_bytes
SELECT event_name
     , current_count
     , current_alloc
     , current_avg_alloc
     , high_count
     , high_alloc
     , high_avg_alloc
  FROM sys.memory_global_by_current_bytes;
  

-- MySQL 서버가 사용 중인 메모리 총량 확인
-- x$memory_global_total
SELECT total_allocated
  FROM sys.memory_global_total;

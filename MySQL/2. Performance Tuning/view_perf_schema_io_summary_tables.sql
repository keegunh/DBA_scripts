-- 인덱스별로 분류해서 집계한 I/O 작업 관련 소요 시간 통계 정보 확인
SELECT object_type
     , object_schema
     , object_name
     , index_name
     , count_star
     -- , sum_timer_wait
     -- , min_timer_wait
     -- , avg_timer_wait
     -- , max_timer_wait
     , count_read
     -- , sum_timer_read
     -- , min_timer_read
     -- , avg_timer_read
     -- , max_timer_read
     , count_write
     -- , sum_timer_write
     -- , min_timer_write
     -- , avg_timer_write
     -- , max_timer_write
     , count_fetch
     -- , sum_timer_fetch
     -- , min_timer_fetch
     -- , avg_timer_fetch
     -- , max_timer_fetch
     , count_insert
     -- , sum_timer_insert
     -- , min_timer_insert
     -- , avg_timer_insert
     -- , max_timer_insert
     , count_update
     -- , sum_timer_update
     -- , min_timer_update
     -- , avg_timer_update
     -- , max_timer_update
     , count_delete
     -- , sum_timer_delete
     -- , min_timer_delete
     -- , avg_timer_delete
     -- , max_timer_delete
  FROM performance_schema.table_io_waits_summary_by_index_usage;

-- 테이블별로 분류해서 집계한 I/O 작업 관련 소요 시간 통계 정보 확인
SELECT object_type
     , object_schema
     , object_name
     , count_star
     , sum_timer_wait
     , min_timer_wait
     , avg_timer_wait
     , max_timer_wait
     , count_read
     , sum_timer_read
     , min_timer_read
     , avg_timer_read
     , max_timer_read
     , count_write
     , sum_timer_write
     , min_timer_write
     , avg_timer_write
     , max_timer_write
     , count_fetch
     , sum_timer_fetch
     , min_timer_fetch
     , avg_timer_fetch
     , max_timer_fetch
     , count_insert
     , sum_timer_insert
     , min_timer_insert
     , avg_timer_insert
     , max_timer_insert
     , count_update
     , sum_timer_update
     , min_timer_update
     , avg_timer_update
     , max_timer_update
     , count_delete
     , sum_timer_delete
     , min_timer_delete
     , avg_timer_delete
     , max_timer_delete
  FROM performance_schema.table_io_waits_summary_by_table;

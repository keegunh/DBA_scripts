/*
*	Summary 테이블들은 Performance 스키마가 수집한 이벤트들을 특정 기준별로 집계한 후 요약한 정보를 제공함.
*	이벤트 타입별로, 집계 기준별로 다양한 Summary 테이블들이 존재함.
*	
*	events_waits_summary_by_account_by_event_name
*	events_waits_summary_by_host_by_event_name
*	events_waits_summary_by_thread_by_event_name
*	events_waits_summary_by_user_by_event_name
*	events_waits_summary_global_by_event_name
*	events_waits_summary_by_instance
*	
*	events_stages_summary_by_account_by_event_name
*	events_stages_summary_by_host_by_event_name
*	events_stages_summary_by_thread_by_event_name
*	events_stages_summary_by_user_by_event_name
*	events_stages_summary_global_by_event_name
*	
*	events_statements_summary_by_account_by_event_name
*	events_statements_summary_by_host_by_event_name
*	events_statements_summary_by_thread_by_event_name
*	events_statements_summary_by_user_by_event_name
*	events_statements_summary_global_by_event_name
*	events_statements_summary_by_digest
*	events_statements_summary_by_program
*	
*	events_transactions_summary_by_account_by_event_name
*	events_transactions_summary_by_host_by_event_name
*	events_transactions_summary_by_thread_by_event_name
*	events_transactions_summary_by_user_by_event_name
*	events_transactions_summary_global_by_event_name
*/

-- DB 계정별, 이벤트 클래스별로 분류해서 집계한 Wait 이벤트 통계 정보 확인
SELECT user
     , host
     , event_name
     , count_star
     , sum_timer_wait
     , min_timer_wait
     , avg_timer_wait
     , max_timer_wait
  FROM performance_schema.events_waits_summary_by_account_by_event_name;

-- 호스트별, 이벤트 클래스별로 분류해서 집계한 Wait 이벤트 통계 정보 확인
SELECT host
     , event_name
     , count_star
     , sum_timer_wait
     , min_timer_wait
     , avg_timer_wait
     , max_timer_wait
  FROM performance_schema.events_waits_summary_by_host_by_event_name;

-- 스레드별, 이벤트 클래스별로 분류해서 집계한 Wait 이벤트 통계 정보 확인
SELECT thread_id
     , event_name
     , count_star
     , sum_timer_wait
     , min_timer_wait
     , avg_timer_wait
     , max_timer_wait
  FROM performance_schema.events_waits_summary_by_thread_by_event_name;

-- DB 계정명별, 이벤트 클래스별로 분류해서 집계한 Wait 이벤트 통계 정보 확인
SELECT user
     , event_name
     , count_star
     , sum_timer_wait
     , min_timer_wait
     , avg_timer_wait
     , max_timer_wait
  FROM performance_schema.events_waits_summary_by_user_by_event_name;

-- 이벤트 클래스별로 분류해서 집계한 Wait 이벤트 통계 정보 확인
SELECT event_name
     , count_star
     , sum_timer_wait
     , min_timer_wait
     , avg_timer_wait
     , max_timer_wait
  FROM performance_schema.events_waits_summary_global_by_event_name;

-- 이벤트 인스턴스별로 분류해서 집계한 Wait 이벤트 통계 정보 확인.
SELECT event_name
     , object_instance_begin
     , count_star
     , sum_timer_wait
     , min_timer_wait
     , avg_timer_wait
     , max_timer_wait
  FROM performance_schema.events_waits_summary_by_instance;

-- DB 계정별, 이벤트 클래스별로 분류해서 집계한 Stage 이벤트 통계 정보 확인
SELECT user
     , host
     , event_name
     , count_star
     , sum_timer_wait
     , min_timer_wait
     , avg_timer_wait
     , max_timer_wait
  FROM performance_schema.events_stages_summary_by_account_by_event_name;

-- 호스트별, 이벤트 클래스별로 분류해서 집계한 Stage 이벤트 통계 정보 확인
SELECT host
     , event_name
     , count_star
     , sum_timer_wait
     , min_timer_wait
     , avg_timer_wait
     , max_timer_wait
  FROM performance_schema.events_stages_summary_by_host_by_event_name;

-- 스레드별, 이벤트 클래스별로 분류해서 집계한 Stage 이벤트 통계 정보 확인
SELECT thread_id
     , event_name
     , count_star
     , sum_timer_wait
     , min_timer_wait
     , avg_timer_wait
     , max_timer_wait
  FROM performance_schema.events_stages_summary_by_thread_by_event_name;

-- DB 계정명별, 이벤트 클래스별로 분류해서 집계한 Stage 이벤트 통계 정보 확인
SELECT user
     , event_name
     , count_star
     , sum_timer_wait
     , min_timer_wait
     , avg_timer_wait
     , max_timer_wait
  FROM performance_schema.events_stages_summary_by_user_by_event_name;

-- 이벤트 클래스별로 분류해서 집계한 Stage 이벤트 통계 정보 확인
SELECT event_name
     , count_star
     , sum_timer_wait
     , min_timer_wait
     , avg_timer_wait
     , max_timer_wait
  FROM performance_schema.events_stages_summary_global_by_event_name;

-- DB 계정별, 이벤트 클래스별로 분류해서 집계한 Statement 이벤트 통계 정보 확인
SELECT user
     , host
     , event_name
     , count_star
     , sum_timer_wait
     , min_timer_wait
     , avg_timer_wait
     , max_timer_wait
  FROM performance_schema.events_statements_summary_by_account_by_event_name;

-- 호스트별, 이벤트 클래스별로 분류해서 집계한 Statement 이벤트 통계 정보 확인
SELECT host
     , event_name
     , count_star
     , sum_timer_wait
     , min_timer_wait
     , avg_timer_wait
     , max_timer_wait
  FROM performance_schema.events_statements_summary_by_host_by_event_name;

-- 스레드별, 이벤트 클래스별로 분류해서 집계한 Statement 이벤트 통계 정보 확인
SELECT thread_id
     , event_name
     , count_star
     , sum_timer_wait
     , min_timer_wait
     , avg_timer_wait
     , max_timer_wait
  FROM performance_schema.events_statements_summary_by_thread_by_event_name;

-- DB 계정명별, 이벤트 클래스별로 분류해서 집계한 Statement 이벤트 통계 정보 확인
SELECT user
     , event_name
     , count_star
     , sum_timer_wait
     , min_timer_wait
     , avg_timer_wait
     , max_timer_wait
  FROM performance_schema.events_statements_summary_by_user_by_event_name;

-- 이벤트 클래스별로 분류해서 집계한 Statement 이벤트 통계 정보 확인
SELECT event_name
     , count_star
     , sum_timer_wait
     , min_timer_wait
     , avg_timer_wait
     , max_timer_wait
  FROM performance_schema.events_statements_summary_global_by_event_name;

-- DB 계정별, 이벤트 클래스별로 분류해서 집계한 Transaction 이벤트 통계 정보 확인
SELECT user
     , host
     , event_name
     , count_star
     , sum_timer_wait
     , min_timer_wait
     , avg_timer_wait
     , max_timer_wait
  FROM performance_schema.events_transactions_summary_by_account_by_event_name;

-- 호스트별, 이벤트 클래스별로 분류해서 집계한 Transaction 이벤트 통계 정보 확인
SELECT host
     , event_name
     , count_star
     , sum_timer_wait
     , min_timer_wait
     , avg_timer_wait
     , max_timer_wait
  FROM performance_schema.events_transactions_summary_by_host_by_event_name;

-- 스레드별, 이벤트 클래스별로 분류해서 집계한 Transaction 이벤트 통계 정보 확인
SELECT thread_id
     , event_name
     , count_star
     , sum_timer_wait
     , min_timer_wait
     , avg_timer_wait
     , max_timer_wait
  FROM performance_schema.events_transactions_summary_by_thread_by_event_name;

-- DB 계정명별, 이벤트 클래스별로 분류해서 집계한 Transaction 이벤트 통계 정보 확인
SELECT user
     , event_name
     , count_star
     , sum_timer_wait
     , min_timer_wait
     , avg_timer_wait
     , max_timer_wait
  FROM performance_schema.events_transactions_summary_by_user_by_event_name;

-- 이벤트 클래스별로 분류해서 집계한 Transaction 이벤트 통계 정보 확인
SELECT event_name
     , count_star
     , sum_timer_wait
     , min_timer_wait
     , avg_timer_wait
     , max_timer_wait
  FROM performance_schema.events_transactions_summary_global_by_event_name;










-- 스키마별, 쿼리 다이제스트별로 분류해서 집계한 Statement 이벤트 통계 정보 확인
SELECT schema_name
     , digest
     , digest_text
     , count_star
     , sum_timer_wait
     , min_timer_wait
     , avg_timer_wait
     , max_timer_wait
     , sum_lock_time
     , sum_errors
     , sum_warnings
     , sum_rows_affected
     , sum_rows_sent
     , sum_rows_examined
     , sum_created_tmp_disk_tables
     , sum_created_tmp_tables
     , sum_select_full_join
     , sum_select_full_range_join
     , sum_select_range
     , sum_select_range_check
     , sum_select_scan
     , sum_sort_merge_passes
     , sum_sort_range
     , sum_sort_rows
     , sum_sort_scan
     , sum_no_index_used
     , sum_no_good_index_used
     , first_seen
     , last_seen
     , quantile_95
     , quantile_99
     , quantile_999
     , query_sample_text
     , query_sample_seen
     , query_sample_timer_wait
  FROM performance_schema.events_statements_summary_by_digest;

-- stored program (procedure, function, trigger, event, etc) 별로 분류해서 집계한 Statement 이벤트 통계 정보 확인
SELECT object_type
     , object_schema
     , object_name
     , count_star
     , sum_timer_wait
     , min_timer_wait
     , avg_timer_wait
     , max_timer_wait
     , count_statements
     , sum_statements_wait
     , min_statements_wait
     , avg_statements_wait
     , max_statements_wait
     , sum_lock_time
     , sum_errors
     , sum_warnings
     , sum_rows_affected
     , sum_rows_sent
     , sum_rows_examined
     , sum_created_tmp_disk_tables
     , sum_created_tmp_tables
     , sum_select_full_join
     , sum_select_full_range_join
     , sum_select_range
     , sum_select_range_check
     , sum_select_scan
     , sum_sort_merge_passes
     , sum_sort_range
     , sum_sort_rows
     , sum_sort_scan
     , sum_no_index_used
     , sum_no_good_index_used
  FROM performance_schema.events_statements_summary_by_program;
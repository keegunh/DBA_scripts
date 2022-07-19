/*
*	Summary 테이블들은 Performance 스키마가 수집한 이벤트들을 특정 기준별로 집계한 후 요약한 정보를 제공함.
*	이벤트 타입별로, 집계 기준별로 다양한 Summary 테이블들이 존재함.
*	
*	memory_summary_by_account_by_event_name
*	memory_summary_by_host_by_event_name
*	memory_summary_by_thread_by_event_name
*	memory_summary_by_user_by_event_name
*	memory_summary_global_by_event_name
*/

-- DB 계정별, 이벤트 클래스별로 분류해서 집계한 메몸리 할당 및 해제에 대한 통게 정보 확인
SELECT user
     , host
     , event_name
     , count_alloc
     , count_free
     , sum_number_of_bytes_alloc
     , sum_number_of_bytes_free
     , low_count_used
     , current_count_used
     , high_count_used
     , low_number_of_bytes_used
     , current_number_of_bytes_used
     , high_number_of_bytes_used
  FROM performance_schema.memory_summary_by_account_by_event_name;

-- 호스트별, 이벤트 클래스별로 분류해서 집계한 메몸리 할당 및 해제에 대한 통게 정보 확인
SELECT host
     , event_name
     , count_alloc
     , count_free
     , sum_number_of_bytes_alloc
     , sum_number_of_bytes_free
     , low_count_used
     , current_count_used
     , high_count_used
     , low_number_of_bytes_used
     , current_number_of_bytes_used
     , high_number_of_bytes_used
  FROM performance_schema.memory_summary_by_host_by_event_name;

-- 스레드별, 이벤트 클래스별로 분류해서 집계한 메몸리 할당 및 해제에 대한 통게 정보 확인
SELECT thread_id
     , event_name
     , count_alloc
     , count_free
     , sum_number_of_bytes_alloc
     , sum_number_of_bytes_free
     , low_count_used
     , current_count_used
     , high_count_used
     , low_number_of_bytes_used
     , current_number_of_bytes_used
     , high_number_of_bytes_used
  FROM performance_schema.memory_summary_by_thread_by_event_name;

-- DB 계정명별, 이벤트 클래스별로 분류해서 집계한 메몸리 할당 및 해제에 대한 통게 정보 확인
SELECT user
     , event_name
     , count_alloc
     , count_free
     , sum_number_of_bytes_alloc
     , sum_number_of_bytes_free
     , low_count_used
     , current_count_used
     , high_count_used
     , low_number_of_bytes_used
     , current_number_of_bytes_used
     , high_number_of_bytes_used
  FROM performance_schema.memory_summary_by_user_by_event_name;

-- 이벤트 클래스별로 분류해서 집계한 메몸리 할당 및 해제에 대한 통게 정보 확인
SELECT event_name
     , count_alloc
     , count_free
     , sum_number_of_bytes_alloc
     , sum_number_of_bytes_free
     , low_count_used
     , current_count_used
     , high_count_used
     , low_number_of_bytes_used
     , current_number_of_bytes_used
     , high_number_of_bytes_used
  FROM performance_schema.memory_summary_global_by_event_name;
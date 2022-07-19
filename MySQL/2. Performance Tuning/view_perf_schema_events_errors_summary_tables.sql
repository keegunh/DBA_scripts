/*
*	Summary 테이블들은 Performance 스키마가 수집한 이벤트들을 특정 기준별로 집계한 후 요약한 정보를 제공함.
*	이벤트 타입별로, 집계 기준별로 다양한 Summary 테이블들이 존재함.
*	
*	events_errors_summary_by_account_by_error
*	events_errors_summary_by_host_by_error
*	events_errors_summary_by_thread_by_error
*	events_errors_summary_by_user_by_error
*	events_errors_summary_global_by_error
*/

-- DB 계정별, 에러 코드별로 분류해서 집계한 MySQL 에러 발생 및 처리에 대한 통계 정보 확인
SELECT user
     , host
     , error_number
     , error_name
     , sql_state
     , sum_error_raised
     , sum_error_handled
     , first_seen
     , last_seen
  FROM performance_schema.events_errors_summary_by_account_by_error;

-- 호스트별, 에러 코드별로 분류해서 집계한 MySQL 에러 발생 및 처리에 대한 통계 정보 확인
SELECT host
     , error_number
     , error_name
     , sql_state
     , sum_error_raised
     , sum_error_handled
     , first_seen
     , last_seen
  FROM performance_schema.events_errors_summary_by_host_by_error;

-- 스레드별, 에러 코드별로 분류해서 집계한 MySQL 에러 발생 및 처리에 대한 통계 정보 확인
SELECT thread_id
     , error_number
     , error_name
     , sql_state
     , sum_error_raised
     , sum_error_handled
     , first_seen
     , last_seen
  FROM performance_schema.events_errors_summary_by_thread_by_error;

-- DB 계정명별, 에러 코드별로 분류해서 집계한 MySQL 에러 발생 및 처리에 대한 통계 정보 확인
SELECT user
     , error_number
     , error_name
     , sql_state
     , sum_error_raised
     , sum_error_handled
     , first_seen
     , last_seen
  FROM performance_schema.events_errors_summary_by_user_by_error;

-- 에러 코드별로 분류해서 집계한 MySQL 에러 발생 및 처리에 대한 통계 정보 확인
SELECT error_number
     , error_name
     , sql_state
     , sum_error_raised
     , sum_error_handled
     , first_seen
     , last_seen
  FROM performance_schema.events_errors_summary_global_by_error;
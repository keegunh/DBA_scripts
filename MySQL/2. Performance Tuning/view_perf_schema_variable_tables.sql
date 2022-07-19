/*
*	Variable 테이블들은 MySQL 서버의 시스템 변수 및 사용자 정의 변수와 상태 변수들에 대한 정보를 제공.
*/

-- 전역 시스템 변수들에 대한 정보 확인
SELECT variable_name
     , variable_value
  FROM performance_schema.global_variables
;

-- 현재 세션에 대한 세션 범위의 시스템 변수들의 정보 확인. 현재 세션에서 설정한 값들 확인.
SELECT variable_name
     , variable_value
  FROM performance_schema.session_variables
;

-- 현재 MySQL에 연결돼 있는 전체 세션에 대한 세션 범위의 시스템 변수들의 정보 확인
SELECT thread_id
     , variable_name
     , variable_value
  FROM performance_schema.variables_by_thread;
;

-- SET PERSIST 또는 SET PERSIST ONLY 구문을 통해 영구적으로 설정된 시스템 변수에 대한 정보 저장.
-- persisted_variables 테이블은 mysqld-auto.cnf 파일에 저장돼 있는 내용을 테이블 형태로 나타낸 것.
-- 사용자가 SQL문을 사용해 해당 파일의 내용을 수정할 수 있음.
SELECT variable_name
     , variable_value
  FROM performance_schema.persisted_variables
;

-- 전체 시스템 변수에 대해 설정 가능한 값 범위 및 가장 최근에 변수의 값을 변경한 계정 정보 확인
SELECT variable_name
     , variable_source
     , variable_path
     , min_value
     , max_value
     , set_time
     , set_user
     , set_host
  FROM performance_schema.variables_info
;

-- 현재 MySQL연결돼 있는 세션들에서 생성한 사용자 정의 변수들에 대한 정보(변수명 및 값) 확인
SELECT thread_id
     , variable_name
     , variable_value
  FROM performance_schema.user_variables_by_thread
;

-- 전역 상태 변수들에 대한 정보 확인
SELECT variable_name
     , variable_value
  FROM performance_schema.global_status
;

-- 현재 세션에 대한 세션 범위의 상태 변수들에 정보 확인
SELECT variable_name
     , variable_value
  FROM performance_schema.session_status
;

-- 현재 MySQL에 연결돼 있는 전체 세션들에 대한 세션 범위의 상태 변수들에 정보 확인. 
-- 세션 별로 구분될 수 있는 상태 변수만 확인 가능.
SELECT thread_id
     , variable_name
     , variable_value
  FROM performance_schema.status_by_thread;
;
-- MySQL 서버 내부의 백그라운드 스레드 및 클라이언트 연결에 해당하는 포그라운드 스레드들에 대한 정보가 저장돼 있음.
-- 스레드별로 모니터링 및 과거 이벤트 데이터 보관 설정 여부도 확인 가능
SELECT thread_id
     , name
     , type
     , processlist_id
     , processlist_user
     , processlist_host
     , processlist_db
     , processlist_command
     , processlist_time
     , processlist_state
     , processlist_info
     , parent_thread_id
     , role
     , instrumented
     , history
     , connection_type
     , thread_os_id
     , resource_group
  FROM performance_schema.threads;

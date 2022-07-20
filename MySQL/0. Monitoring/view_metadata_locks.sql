-- performance_schema 스키마 활용해서 전체 metadata lock 확인
SELECT object_type
     , object_schema
     , object_name
     , column_name
     , object_instance_begin
     , lock_type
     , lock_duration
     , lock_status
     , source
     , owner_thread_id
     , owner_event_id
  FROM performance_schema.metadata_locks
;
 
-- metadata lock 대기 확인 (alter table이 대기 중일 때 확인 필요)
SELECT waiting_query_secs
     , waiting_pid
     , waiting_account
     , waiting_lock_type
     , waiting_query
     , blocking_pid
     , blocking_account
     , blocking_lock_type
     , object_schema
     , object_name
     , sql_kill_blocking_query
     , sql_kill_blocking_connection
  FROM sys.schema_table_lock_waits
 WHERE waiting_pid <> blocking_pid
 ORDER BY 1 DESC
;
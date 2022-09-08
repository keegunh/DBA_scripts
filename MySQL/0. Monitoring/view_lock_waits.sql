-- performance_schema 스키마 활용해서 data lock 대기 확인
SELECT 
       TIMEDIFF(NOW(), CONVERT_TZ(r.trx_started, 'UTC', '+09:00')) AS wait_age
     , CONVERT_TZ(r.trx_started, 'UTC', '+09:00') AS wait_trx_started
     , rp.user AS wait_user
     , rp.host AS wait_host
     , rp.db AS wait_db
     , rp.command AS wait_command
     , r.trx_id wait_trx_id
     , r.trx_mysql_thread_id wait_thread
     , r.trx_query wait_query
     , bp.user AS block_user
     , bp.host AS block_host
     , bp.db AS block_db
     , bp.command AS block_command
     , b.trx_id block_trx_id
     , b.trx_mysql_thread_id block_thread
     , b.trx_query block_query
     , l.object_schema
     , l.object_name
     , l.index_name
     , l.lock_type
     , l.lock_mode
     , CONCAT('KILL ', b.trx_mysql_thread_id, ';') AS kill_session
     , CONCAT('KILL QUERY ', b.trx_mysql_thread_id, ';') AS kill_session_query
  FROM performance_schema.data_locks l
 INNER JOIN performance_schema.data_lock_waits w
    ON l.engine = w.engine
   AND l.engine_lock_id = w.blocking_engine_lock_id
   AND l.engine_transaction_id = w.blocking_engine_transaction_id
   AND l.thread_id = w.blocking_thread_id
   AND l.event_id = w.blocking_event_id
 INNER JOIN information_schema.innodb_trx b
    ON b.trx_id = w.blocking_engine_transaction_id
 INNER JOIN information_schema.innodb_trx r
    ON r.trx_id = w.requesting_engine_transaction_id
 INNER JOIN information_schema.processlist bp
    ON bp.id = b.trx_mysql_thread_id
 INNER JOIN information_schema.processlist rp
    ON rp.id = r.trx_mysql_thread_id
 ORDER BY 1
;

 
-- sys 스키마 활용해서 data lock 대기 확인
-- 현재 실행 중인 트랜잭션에서 획득하기 위해 기다리고 있는 InnoDB 잠금에 대한 정보 확인
-- x$innodb_lock_waits
SELECT
       CONVERT_TZ(wait_started, 'UTC', '+09:00') AS wait_started
     , TIMEDIFF(NOW(), CONVERT_TZ(wait_started, 'UTC', '+09:00')) AS wait_age
     , waiting_pid
     , waiting_query
     , waiting_lock_mode
     , blocking_pid
     , blocking_query
     , blocking_lock_mode
     , blocking_trx_started
     , locked_table
     , locked_index
     , locked_type
     , CONCAT(sql_kill_blocking_query, ';') AS sql_kill_blocking_query
     , CONCAT(sql_kill_blocking_connection, ';') AS sql_kill_blocking_connection
  FROM sys.innodb_lock_waits
 ORDER BY 1
;

-- 메타데이터 잠금을 획득하기 위해 대기 중인 세션과 해당 세션을 대기시킨 세션에 대한 정보 확인
-- x$schema_table_lock_waits
SELECT object_schema
     , object_name
     , waiting_thread_id
     , waiting_pid
     , waiting_account
     , waiting_lock_type
     , waiting_lock_duration
     , waiting_query
     , waiting_query_secs
     , waiting_query_rows_affected
     , waiting_query_rows_examined
     , blocking_thread_id
     , blocking_pid
     , blocking_account
     , blocking_lock_type
     , blocking_lock_duration
     , sql_kill_blocking_query
     , sql_kill_blocking_connection
  FROM sys.schema_table_lock_waits;
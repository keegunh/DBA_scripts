-- performance_schema 스키마 활용해서 data lock 대기 확인
SELECT TIMEDIFF(NOW(), CONVERT_TZ(r.trx_started, 'UTC', '+09:00')) AS wait_age
     , r.trx_id waiting_trx_id
     , r.trx_mysql_thread_id waiting_thread
     , CONVERT_TZ(r.trx_started, 'UTC', '+09:00') AS wait_trx_started
     , r.trx_query waiting_query
     , b.trx_id blocking_trx_id
     , b.trx_mysql_thread_id blocking_thread
     , b.trx_query blocking_query
     , l.object_schema
     , l.object_name
     , l.index_name
     , l.lock_type
     , l.lock_mode
     , CONCAT('KILL ', w.blocking_thread_id, ';') AS kill_session
     , CONCAT('KILL QUERY', w.blocking_thread_id, ';') AS kill_session_query
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
 ORDER BY 1
;
 
-- sys 스키마 활용해서 data lock 대기 확인
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
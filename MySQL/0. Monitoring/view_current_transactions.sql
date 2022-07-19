-- INFORMATION_SCHEMA 스키마 사용해서 현재 트랜잭션 조회
SELECT
       t.trx_mysql_thread_id
     , CONVERT_TZ(t.trx_started, 'UTC', '+09:00') as trx_started
     , p.user
     -- , p.time
     , p.host
     , p.db
     , p.command
     -- , p.state
     , t.trx_query
     -- , p.info
     -- , t.trx_id
     , t.trx_state
     , t.trx_operation_state
     , t.trx_tables_in_use
     , t.trx_tables_locked
     , t.trx_isolation_level
     -- , t.trx_requested_lock_id
     -- , t.trx_wait_started
     -- , t.trx_weight
     -- , t.trx_lock_structs
     -- , t.trx_lock_memory_bytes
     -- , t.trx_rows_locked
     -- , t.trx_rows_modified
     -- , t.trx_concurrency_tickets
     -- , t.trx_unique_checks
     -- , t.trx_foreign_key_checks
     -- , t.trx_last_foreign_key_error
     -- , t.trx_adaptive_hash_latched
     -- , t.trx_adaptive_hash_timeout
     -- , t.trx_is_read_only
     -- , t.trx_autocommit_non_locking
     , CONCAT('KILL QUERY ', t.trx_mysql_thread_id, ';') AS kill_query
     , CONCAT('KILL ', t.trx_mysql_thread_id, ';') AS kill_session
  FROM information_schema.innodb_trx t
 INNER JOIN information_schema.processlist p
    ON p.id = t.trx_mysql_thread_id
 ORDER BY 3 DESC
;
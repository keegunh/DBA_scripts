-- INNODB 테이블의 경우
SELECT
       WAITING_TRX_ID
     , WAITING_PID
     , WAITING_QUERY
     , WAIT_STARTED
     , WAIT_AGE
     , BLOCKING_TRX_ID
     , BLOCKING_PID
     , BLOCKING_QUERY
     , LOCKED_TABLE
     , LOCKED_TYPE
     , SQL_KILL_BLOCKING_QUERY
     , SQL_KILL_BLOCKING_CONNECTION
  FROM sys.innodb_lock_waits;
  
select* from performance_schema.data_locks;
select* from performance_schema.data_lock_waits;
  
## Lock 조회
SELECT
  r.trx_id waiting_trx_id,
  r.trx_mysql_thread_id waiting_thread,
  r.trx_query waiting_query,
  b.trx_id blocking_trx_id,
  b.trx_mysql_thread_id blocking_thread,
  b.trx_query blocking_query
FROM       performance_schema.data_lock_waits w
INNER JOIN information_schema.innodb_trx b
  ON b.trx_id = w.blocking_engine_transaction_id
INNER JOIN information_schema.innodb_trx r
  ON r.trx_id = w.requesting_engine_transaction_id;
 
## Lock을 잡고있는 SQL조회
SELECT straight_join
    dl.THREAD_ID
  , est.SQL_TEXT
  , dl.OBJECT_SCHEMA
  , dl.OBJECT_NAME
  , dl.INDEX_NAME
  , dl.LOCK_TYPE
  , dl.LOCK_MODE
  , dl.LOCK_STATUS
  , dl.LOCK_DATA
FROM
  performance_schema.data_locks dl
inner join performance_schema.events_statements_current est
on dl.THREAD_ID = est.THREAD_ID
ORDER BY est.TIMER_START,dl.OBJECT_INSTANCE_BEGIN;

0	39	10:38:51	SELECT
        WAITING_TRX_ID
      , WAITING_PID
      , WAITING_QUERY
      , WAIT_STARTED
      , WAIT_AGE
      , BLOCKING_TRX_ID
      , BLOCKING_PID
      , BLOCKING_QUERY
      , LOCKED_TABLE
      , LOCKED_TYPE
      , SQL_KILL_BLOCKING_QUERY
      , SQL_KILL_BLOCKING_CONNECTION
   FROM sys.innodb_lock_waits
 LIMIT 0, 1000	Error Code: 1100. Table 'innodb_lock_waits' was not locked with LOCK TABLES	0.016 sec
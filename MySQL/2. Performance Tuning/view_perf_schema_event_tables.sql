/*
*	Event 테이블은 크게 Wait, Stage, Statement, Transaction 이벤트 테이블로 구분
*	이벤트 계층 구조
*	-------------------------------------------------------------------
*   |  Transcation Events                                             |
*   |       --------------------------------------------------------| |
*   |       |  Statement Events                                     | |
*   |       |    -------------------------------------------------- | |
*   |       |    | Stage Events                                   | | |
*   |       |    |      ---------------------------------------   | | |
*   |       |    |      | Wait Events                         |   | | |
*   |       |    |      |       io, lock, synch ...           |   | | |
*   |       |    |      |                                     |   | | |
*   |       |    |      ---------------------------------------   | | |
*   |       |    -------------------------------------------------- | |
*   |       --------------------------------------------------------- |
*   -------------------------------------------------------------------
*
*	각 Event 테이블은 아래와 같이 계층 구조를 가짐.
*   SELECT *
*	  FROM performance_schema.events_waits_current A
*    INNER JOIN performance_schema.events_stages_current B
*       ON A.nesting_event_id = B.event_id
*    INNER JOIN performance_schema.events_statements_current C
*       ON B.nesting_event_id = C.event_id
*    INNER JOIN performance_schema.events_transactions_current D
*       ON C.nesting_event_id = D.event_id
*
*
*	각 이벤트는 세 가지 유형의 테이블을 가짐.
*	1. current : 스레드별로 가장 최신의 이벤트 1건만 저장. 
*                스레드가 종료되면 해당 스레드의 이벤트 데이터는 바로 삭제됨.
*	2. history : 스레드별로 가장 최신의 이벤트가 지정된 최대 개수만큼 저장.
*                스레드가 종료되면 해당 스레드의 이벤트 데이터는 바로 삭제되며, 
*                스레드가 계속 사용 중이면서 스레드별 최대 저장 개수를 넘은 경우 이전 이벤트를 삭제하고 최근 이벤트를 새로 저장.
*	3. history_long : 전체 스레드에 대한 최근 이벤트들을 모두 저장하며, 지정된 전체 최대 개수만큼 데이터가 저장.
*                     스레드가 종료되는 것과 관계없이 지정된 최대 개수만큼 데이터를 가지고 있으며, 
*                     저장된 이벤트 데이터가 전체 최대 저장 개수를 넘어가면 이전 이벤트들을 삭제하고 최근 이벤트를 새로 저장.
*/

-- Wait Event 테이블 : 각 스레드에서 대기하고 있는 이벤트들에 대한 정보 확인. 일반적으로 잠금 경합 또는 I/O 작업 등으로 인해 스레드가 대기함.
SELECT thread_id
     , event_id
     , end_event_id
     , event_name
     , source
     , timer_start
     , timer_end
     , timer_wait
     , spins
     , object_schema
     , object_name
     , index_name
     , object_type
     , object_instance_begin
     , nesting_event_id
     , nesting_event_type
     , operation
     , number_of_bytes
     , flags
FROM performance_schema.events_waits_current;

SELECT thread_id
     , event_id
     , end_event_id
     , event_name
     , source
     , timer_start
     , timer_end
     , timer_wait
     , spins
     , object_schema
     , object_name
     , index_name
     , object_type
     , object_instance_begin
     , nesting_event_id
     , nesting_event_type
     , operation
     , number_of_bytes
     , flags
  FROM performance_schema.events_waits_history;
  
SELECT thread_id
     , event_id
     , end_event_id
     , event_name
     , source
     , timer_start
     , timer_end
     , timer_wait
     , spins
     , object_schema
     , object_name
     , index_name
     , object_type
     , object_instance_begin
     , nesting_event_id
     , nesting_event_type
     , operation
     , number_of_bytes
     , flags
  FROM performance_schema.events_waits_history_long;

-- Stage Event 테이블 : 각 스레드에서 실행한 쿼리들의 처리 단계에 대한 정보를 확인. 
-- 이를 통해 실행된 쿼리가 구문 분석, 테이블 열기, 정렬 등과 같은 쿼리 처리 단계 중 현재 어느 단계를 수행하고 있는지와 처리 단계별 소요 시간을 확인 가능.
SELECT thread_id
     , event_id
     , end_event_id
     , event_name
     , source
     , timer_start
     , timer_end
     , timer_wait
     , work_completed
     , work_estimated
     , nesting_event_id
     , nesting_event_type
  FROM performance_schema.events_stages_current;
  
SELECT thread_id
     , event_id
     , end_event_id
     , event_name
     , source
     , timer_start
     , timer_end
     , timer_wait
     , work_completed
     , work_estimated
     , nesting_event_id
     , nesting_event_type
  FROM performance_schema.events_stages_history;
  
SELECT thread_id
     , event_id
     , end_event_id
     , event_name
     , source
     , timer_start
     , timer_end
     , timer_wait
     , work_completed
     , work_estimated
     , nesting_event_id
     , nesting_event_type
  FROM performance_schema.events_stages_history_long;

-- Statement Event 테이블 : 각 스레드에서 실행한 쿼리들에 대한 정보를 확인. 
-- 실행된 쿼리와 쿼리에서 반환된 레코드 수, 인덱스 사용 유무 및 처리된 방식 등의 다양한 정보를 함께 확인 가능.
SELECT thread_id
     , event_id
     , end_event_id
     , event_name
     , source
     , timer_start
     , timer_end
     , timer_wait
     , lock_time
     , sql_text
     , digest
     , digest_text
     , current_schema
     , object_type
     , object_schema
     , object_name
     , object_instance_begin
     , mysql_errno
     , returned_sqlstate
     , message_text
     , errors
     , warnings
     , rows_affected
     , rows_sent
     , rows_examined
     , created_tmp_disk_tables
     , created_tmp_tables
     , select_full_join
     , select_full_range_join
     , select_range
     , select_range_check
     , select_scan
     , sort_merge_passes
     , sort_range
     , sort_rows
     , sort_scan
     , no_index_used
     , no_good_index_used
     , nesting_event_id
     , nesting_event_type
     , nesting_event_level
     , statement_id
  FROM performance_schema.events_statements_current;

SELECT thread_id
     , event_id
     , end_event_id
     , event_name
     , source
     , timer_start
     , timer_end
     , timer_wait
     , lock_time
     , sql_text
     , digest
     , digest_text
     , current_schema
     , object_type
     , object_schema
     , object_name
     , object_instance_begin
     , mysql_errno
     , returned_sqlstate
     , message_text
     , errors
     , warnings
     , rows_affected
     , rows_sent
     , rows_examined
     , created_tmp_disk_tables
     , created_tmp_tables
     , select_full_join
     , select_full_range_join
     , select_range
     , select_range_check
     , select_scan
     , sort_merge_passes
     , sort_range
     , sort_rows
     , sort_scan
     , no_index_used
     , no_good_index_used
     , nesting_event_id
     , nesting_event_type
     , nesting_event_level
     , statement_id
  FROM performance_schema.events_statements_history;

SELECT thread_id
     , event_id
     , end_event_id
     , event_name
     , source
     , timer_start
     , timer_end
     , timer_wait
     , lock_time
     , sql_text
     , digest
     , digest_text
     , current_schema
     , object_type
     , object_schema
     , object_name
     , object_instance_begin
     , mysql_errno
     , returned_sqlstate
     , message_text
     , errors
     , warnings
     , rows_affected
     , rows_sent
     , rows_examined
     , created_tmp_disk_tables
     , created_tmp_tables
     , select_full_join
     , select_full_range_join
     , select_range
     , select_range_check
     , select_scan
     , sort_merge_passes
     , sort_range
     , sort_rows
     , sort_scan
     , no_index_used
     , no_good_index_used
     , nesting_event_id
     , nesting_event_type
     , nesting_event_level
     , statement_id
  FROM performance_schema.events_statements_history_long;

-- Transaction Event 테이블 : 각 스레드에서 실행한 트랜잭션에 대한 정보를 확인. 트랜잭션별로 트랜잭션 종류와 현재 상태, 격리 수준 등을 확인 가능.
SELECT thread_id
     , event_id
     , end_event_id
     , event_name
     , state
     , trx_id
     , gtid
     , xid_format_id
     , xid_gtrid
     , xid_bqual
     , xa_state
     , source
     , timer_start
     , timer_end
     , timer_wait
     , access_mode
     , isolation_level
     , autocommit
     , number_of_savepoints
     , number_of_rollback_to_savepoint
     , number_of_release_savepoint
     , object_instance_begin
     , nesting_event_id
     , nesting_event_type
  FROM performance_schema.events_transactions_current;

SELECT thread_id
     , event_id
     , end_event_id
     , event_name
     , state
     , trx_id
     , gtid
     , xid_format_id
     , xid_gtrid
     , xid_bqual
     , xa_state
     , source
     , timer_start
     , timer_end
     , timer_wait
     , access_mode
     , isolation_level
     , autocommit
     , number_of_savepoints
     , number_of_rollback_to_savepoint
     , number_of_release_savepoint
     , object_instance_begin
     , nesting_event_id
     , nesting_event_type
  FROM performance_schema.events_transactions_history;

SELECT thread_id
     , event_id
     , end_event_id
     , event_name
     , state
     , trx_id
     , gtid
     , xid_format_id
     , xid_gtrid
     , xid_bqual
     , xa_state
     , source
     , timer_start
     , timer_end
     , timer_wait
     , access_mode
     , isolation_level
     , autocommit
     , number_of_savepoints
     , number_of_rollback_to_savepoint
     , number_of_release_savepoint
     , object_instance_begin
     , nesting_event_id
     , nesting_event_type
  FROM performance_schema.events_transactions_history_long;
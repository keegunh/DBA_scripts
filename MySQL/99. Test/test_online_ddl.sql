/*
TEST#1
테스트 배경 : 
     실제 DDL 배포할 때 장애 발생한 상황 재현.
     특정 테이블 ROW에 트랜잭션이 진행되고 있는 상태에서 ALTER문이 수행 가능한지 테스트.
수행 순서 :
     SESSION1 -> SESSION2 -> SESSION3
테스트 DDL 유형 :
     ALTER TABLE ... ADD KEY;
     ALTER TABLE ... ADD KEY... , ALGORITHM=INPLACE, LOCK=NONE;
테스트 결과 : 
     ADD KEY는 ALGORITHM=INPLACE, LOCK=NONE 옵션과 상관없이 똑같이 동작한다.
     SESSION1에서 특정 TABLE이 TRANSACTION에 포함되어 있으면
     SESSION2의 ADD KEY는 해당 테이블에 대해 EXCLUSIVE METADATA LOCK을 잡아야 하기 때문에 SESSION2는 무조건 SESSION1을 대기한다.
     (START TRANSACTION 안에서 특정 테이블에 대해 UPDATE가 아닌 SELECT만 해도 ALTER문이 대기하게 된다.)
     이 때 SESSION2 이후에 실행되는 모든 트랜잭션(예를 들면 SESSION3)은 SESSION2를 대기하게 된다.        
     모든 ONLINE DDL은 결국에는 EXCLUSIVE METADATA LOCK을 걸어야 한다. 그래서 트랜잭션이 진행 중인 테이블에 DDL 수행 시 대형 장애로 이어질 수 있다.
*/
#SESSION1
	SELECT CONNECTION_ID();	-- 154854
 	USE ERPAPP;
	show tables LIKE 'CM_USER_LOGIN';
	SHOW KEYS FROM CM_USER_LOGIN;
	select * from CM_USER_LOGIN LIMIT 100;

	START TRANSACTION;
    SELECT * FROM CM_USER_LOGIN WHERE AUTO_INC_SEQ_ID = 3; 
	UPDATE CM_USER_LOGIN SET USER_ID = 33333 WHERE AUTO_INC_SEQ_ID = 3;
	-- ROLLBACK; 

#SESSION2
	SELECT CONNECTION_ID();	-- 154918
	USE ERPAPP;
	SHOW KEYS FROM CM_USER_LOGIN; 

	ALTER TABLE CM_USER_LOGIN ADD KEY CM_USER_LOGIN_N01(USER_ID), ALGORITHM=INPLACE, LOCK=NONE;
	ALTER TABLE CM_USER_LOGIN DROP KEY CM_USER_LOGIN_N01;

	ALTER TABLE CM_USER_LOGIN ADD KEY CM_USER_LOGIN_N02(CLIENT_IP), ALGORITHM=INPLACE, LOCK=NONE;
	ALTER TABLE CM_USER_LOGIN DROP KEY CM_USER_LOGIN_N02;

#SESSION3
	SELECT CONNECTION_ID();	-- 154919
	USE ERPAPP;
	select * from CM_USER_LOGIN LIMIT 100;
	
	
/*
테스트 배경 : 
     이번에는 반대로 ALTER문이 수행되는 상태에서 해당 테이블에 DML이 수행되는지 확인해봤다.
     HR_IF_USER_SEND 테이블은 아래 ALTER문 수행 시간이 7-10초 정도 걸릴 정도로 데이터가 많은 테이블이다.
수행 순서 :
     SESSION2 -> SESSION1
테스트 DDL 유형 :
     ALTER TABLE ... ADD KEY;
     ALTER TABLE ... ADD KEY... , ALGORITHM=INPLACE, LOCK=NONE;

테스트 결과 : 
     ADD KEY는 ALGORITHM=INPLACE, LOCK=NONE 옵션과 상관없다.
     ADD KEY 중에도 TABLE에 SELECT 및 DML 수행 가능하다. 수행 가능한 쿼리는 DDL별로 다르다.
     하지만 SESSION2의 ALTER문이 종료되는 시점(인덱스를 다 생성하고 METADATA를 수정하는 시점)에는
     EXCLUSIVE METADATA LOCK이 필요하므로 SESSION1의 TRANSACTION이 종료되어 있지 않으면 대기가 발생한다. (SESSION2가 SESSION1을 대기)
     그리고 TEST#1과 같이 SESSION3에서 동일 테이블에 대해 SELECT 쿼리를 수행하면 이 또한 SESSION2를 대기하게 된다.
     따라서 이 경우에도 대형 장애로 이어질 수 있다.
*/
#SESSION1
	SELECT CONNECTION_ID();	-- 154854
	USE ERPAPP;
    SELECT COUNT(1) FROM ERPAPP.HR_IF_USER_SEND;
    SELECT * FROM ERPAPP.HR_IF_USER_SEND LIMIT 100;
    SHOW KEYS FROM ERPAPP.HR_IF_USER_SEND;
    DESC ERPAPP.HR_IF_USER_SEND;
 
    START TRANSACTION;
    SELECT * FROM ERPAPP.HR_IF_USER_SEND WHERE SEQ_ID = 4209328;
    UPDATE ERPAPP.HR_IF_USER_SEND SET USER_NM='ALLO' WHERE SEQ_ID = 4209328;
    -- ROLLBACK;
 
#SESSION2
	SELECT CONNECTION_ID();	-- 154918
	USE ERPAPP;
    SHOW KEYS FROM ERPAPP.HR_IF_USER_SEND;
 
    ALTER TABLE HR_IF_USER_SEND ADD KEY HR_IF_USER_SEND_N05(USER_NM), ALGORITHM=INPLACE, LOCK=NONE;
    ALTER TABLE HR_IF_USER_SEND DROP KEY HR_IF_USER_SEND_N05;
 
    ALTER TABLE HR_IF_USER_SEND ADD KEY HR_IF_USER_SEND_N05(USER_NM);
    ALTER TABLE HR_IF_USER_SEND DROP KEY HR_IF_USER_SEND_N05;
 
#SESSION3
	SELECT CONNECTION_ID();	-- 154919
	USE ERPAPP;
    select * from HR_IF_USER_SEND LIMIT 100;




/*
FLYWAY로 수행하면 안되는 DDL
1. 테이블
	- 테이블 생성 및 테이블명 변경을 제외한 모든 테이블 작업

2. 인덱스
	- FULLTEXT INDEX 추가 (CREATE FULLTEXT INDEX 인덱스명 ON 테이블명(컬럼명);)
	- SPATIAL INDEX 추가 (ALTER TABLE 테이블명 ADD SPATIAL INDEX(인덱스명);)

3. 컬럼
	- 컬럼 추가
	- 컬럼 제거
	- 컬럼 순서 변경
	- 컬럼 데이터 타입 변경 (VARCHAR -> DATETIME, 등)
	- 컬럼 NOT NULL 여부 변경

4. PK
	- PK 제거
	- PK 추가

FLYWAY로 작업 가능한 DDL
1. 테이블
	- 테이블 생성
	- 테이블명 변경
	
2. 인덱스
	- FULLTEXT INDEX, SPATIAL INDEX를 제외한 모든 인덱스 생성, 삭제, 변경 작업

3. 컬럼 
	- 컬럼명 변경
	- 컬럼 DEFAULT값 변경
	- 컬럼 DEFAULT값 제거
	- 컬럼 사이즈 증가 

4. PK
	- 없음
*/






#MONITORING SESSION
-- INFORMATION_SCHEMA 스키마 사용해서 현재 트랜잭션 조회
SELECT
       t.trx_mysql_thread_id
     , CONVERT_TZ(t.trx_started, 'UTC', '+09:00') as trx_started
     , CONVERT_TZ(t.trx_wait_started, 'UTC', '+09:00') as trx_wait_started
     , t.trx_state
     , p.user
     -- , p.time
     , p.host
     , p.db
     , p.command
     -- , p.state
     , t.trx_query
     -- , p.info
     -- , t.trx_id
     , t.trx_operation_state
     , t.trx_tables_in_use
     , t.trx_tables_locked
     , t.trx_rows_locked
     , t.trx_rows_modified
     , t.trx_isolation_level
     -- , t.trx_requested_lock_id
     -- , t.trx_weight
     -- , t.trx_lock_structs
     -- , t.trx_lock_memory_bytes
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
 ORDER BY 2
;

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
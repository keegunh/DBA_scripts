/*
TEST#1
테스트 배경 : 
     실제 DDL 배포할 때 장애 발생한 상황 재현.
     특정 테이블 ROW에 트랜잭션이 진행되고 있는 상태에서 ALTER TABLE ... ADD KEY문이 수행 가능한지 테스트.
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
#SESSION1 - LOCK 생성 세션
	SELECT CONNECTION_ID();	-- 154854
    USE ERPAPP;
    SELECT COUNT(1) FROM ERPAPP.HR_IF_USER_SEND;
    SELECT * FROM ERPAPP.HR_IF_USER_SEND LIMIT 100;
    SHOW KEYS FROM ERPAPP.HR_IF_USER_SEND;
    DESC ERPAPP.HR_IF_USER_SEND;

    START TRANSACTION;
    SELECT * FROM ERPAPP.HR_IF_USER_SEND WHERE SEQ_ID = 4209328;
    UPDATE ERPAPP.HR_IF_USER_SEND SET USER_NM='ALLO' WHERE SEQ_ID = 4209328;
    ROLLBACK;

#SESSION2 - 유형별 ALTER문 작업
	SELECT CONNECTION_ID();	-- 154918
	USE ERPAPP;
    DESC ERPAPP.HR_IF_USER_SEND;
    SHOW KEYS FROM ERPAPP.HR_IF_USER_SEND;
 
    -- 인덱스 추가 : 시작, 끝
    ALTER TABLE HR_IF_USER_SEND ADD KEY HR_IF_USER_SEND_N05(USER_NM);

    -- 인덱스 제거 : 끝
    ALTER TABLE HR_IF_USER_SEND DROP KEY HR_IF_USER_SEND_N05;

	-- 컬럼 추가 : 시작, 끝
    ALTER TABLE HR_IF_USER_SEND ADD COLUMN COL_TEST VARCHAR(100) NULL AFTER USER_ID;

    -- 컬럼 데이터타입 변경 (VARCHAR -> DECIMAL): 끝
    ALTER TABLE HR_IF_USER_SEND MODIFY COL_TEST DECIMAL(10,2) NULL AFTER USER_ID;
    ALTER TABLE HR_IF_USER_SEND MODIFY COL_TEST DECIMAL(10,3) NULL AFTER USER_ID;

    -- 컬럼 삭제 : 시작, 끝
    ALTER TABLE HR_IF_USER_SEND DROP COLUMN COL_TEST;    
    
   	-- 컬럼 사이즈 증가 (VARCHAR) : 끝
    ALTER TABLE HR_IF_USER_SEND MODIFY USER_NM VARCHAR(200) NOT NULL;

	-- 컬럼 사이즈 감소 (VARCHAR) : 끝
    ALTER TABLE HR_IF_USER_SEND MODIFY USER_NM VARCHAR(100) NOT NULL;

#SESSION3 - 일반 세션 (테이블 조회 세션)
	SELECT CONNECTION_ID();	-- 154919
	USE ERPAPP;
    select NOW(), SEQ_ID from HR_IF_USER_SEND LIMIT 100;
	
	
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






#MONITORING SESSION
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

-- ALTER 작업 진행률 확인
SELECT estc.NESTING_EVENT_ID
     , esmc.SQL_TEXT
     , estc.EVENT_NAME
     , estc.WORK_COMPLETED
     , estc.WORK_ESTIMATED
     , ROUND((estc.WORK_COMPLETED/estc.WORK_ESTIMATED)*100,2) as `PROGRESS(%)`
  FROM performance_schema.events_stages_current estc
 INNER JOIN performance_schema.events_statements_current esmc
    ON estc.NESTING_EVENT_ID = esmc.EVENT_ID
 WHERE estc.EVENT_NAME LIKE 'stage/innodb/alter%'
    OR estc.EVENT_NAME = 'stage/sql/copy to tmp table';


-- 자주 쓰는 테이블 조회 (자주 쓰는 테이블의 경우, FLYWAY를 통한 자동배포 진행하지 않도록 가이드 필요)	
SELECT table_schema
     , table_name
     , rows_fetched
     , rows_inserted
     , rows_updated
     , rows_deleted
     , io_read
     , io_write
  FROM sys.schema_table_statistics
 WHERE table_schema NOT IN ('mysql','performance_schema','information_schema','sys')
 ORDER BY rows_fetched DESC;
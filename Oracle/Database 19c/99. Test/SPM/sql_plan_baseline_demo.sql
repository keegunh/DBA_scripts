---------------------------------------------------------------------------------------------------
-- 0. 테스트 데이터 생성
---------------------------------------------------------------------------------------------------

CREATE USER SCOTT IDENTIFIED BY 1;
GRANT CONNECT, RESOURCE ,DBA TO SCOTT;

CONN SCOTT/1

-- 테이블1 생성
create table sales_area1 (
    sale_code number(10), 
    b varchar2(2000), 
    amount number(10,2), 
    sale_type number(10), 
    c varchar2(1000));
-- 데이터 생성
insert /*+ APPEND */ into sales_area1
select mod(rn,1000), 
   dbms_random.string('u',2000), 
   dbms_random.value(1,5), 
   mod(rn,100),
   dbms_random.string('u',50)
from (
    select trunc((rownum+1)/2) as rn, mod(rownum+1,2) as parity
    from (select null from dual connect by level <= 150)
       , (select null from dual connect by level <= 500)
);
commit;

-- 테이블2 생성
create table sales_area2 as 
select sale_code,
   b,
   dbms_random.value(1,3) amount,
   sale_type,c 
from sales_area1;

-- 인덱스 생성
create index sales_area2i on sales_area2 (sale_code,c);
create index sales_typ1i on sales_area1 (sale_type,c);

-- 통계정보 생성
begin
    dbms_stats.gather_table_stats(user,'sales_area1', method_opt=>'for all columns size 254',no_invalidate=>false);
    dbms_stats.gather_table_stats(user,'sales_area2', method_opt=>'for all columns size 254',no_invalidate=>false);
end;
/



---------------------------------------------------------------------------------------------------
-- 1. SQL_PLAN_BASELINE에 쿼리 플랜이 등록되는 과정 / 초기작업
---------------------------------------------------------------------------------------------------

-- 공유 풀 비우기 (이전 실행 계획을 제거하여 새로운 플랜이 생성되도록 유도)
ALTER SYSTEM FLUSH SHARED_POOL;

-- ALTER SYSTEM FLUSH BUFFER_CACHE;
-- ALTER SESSION SET STATISTICS_LEVEL=ALL;

-- SQL PLAN BASELINE에 자동 캡쳐 파라미터 활성화
ALTER SYSTEM SET optimizer_capture_sql_plan_baselines = TRUE;

-- SQL PLAN BASELINE 사용 파라미터 활성화
ALTER SYSTEM SET optimizer_use_sql_plan_baselines = TRUE;

SELECT NAME, VALUE, DEFAULT_VALUE, ISDEFAULT FROM V$PARAMETER WHERE NAME IN (
'optimizer_capture_sql_plan_baselines',
'optimizer_use_sql_plan_baselines'
);



---------------------------------------------------------------------------------------------------
-- 2.1 SQL Baseline Capture 테스트 (자동)
---------------------------------------------------------------------------------------------------

-- SQL STATEMENT LOG가 처음에는 비어있으나 테스트 쿼리를 (SELECT /* aaa */ ...) 1번 수행했을 떄 기록이 됨.
-- 실행하는 모든 쿼리는 SQL STATEMENT LOG에 기록이 되는 듯 함.
SELECT * FROM SYS.SQLLOG$;

-- 나쁜 플랜으로 풀림 (NL JOIN 사용)
alter session set optimizer_ignore_hints = false;
-- 좋은 플랜으로 풀림 (HASH JOIN 사용)
alter session set optimizer_ignore_hints = true;

select /* zzz */ /*+ USE_NL(t1) LEADING(t2 t1) */ sum(t2.amount)
  from SCOTT.sales_area1 t1, 
       SCOTT.sales_area2 t2
 where t1.sale_code = t2.sale_code
   and t1.sale_type  = 1;

SELECT * FROM SYS.SQLLOG$;

-- optimizer_capture_sql_plan_baselines 파라미터가 활성화된 상태에서 2번 이상 같은 쿼리를 수행하면 쿼리 및 플랜 정보가 DBA_SQL_PLAN_BASELINES에 등록됨.
SELECT SQL_HANDLE, PLAN_NAME, SQL_TEXT, ENABLED, ACCEPTED, FIXED, REPRODUCED, AUTOPURGE, ADAPTIVE, ORIGIN, CREATED, LAST_MODIFIED, LAST_EXECUTED, LAST_VERIFIED
  FROM DBA_SQL_PLAN_BASELINES;
 WHERE SQL_TEXT LIKE '%/* zzz */%';

-- Check SQL Plan Baseline
SELECT SQL_HANDLE, PLAN_NAME, SQL_TEXT, ENABLED, ACCEPTED, FIXED, REPRODUCED, AUTOPURGE, ADAPTIVE, ORIGIN, CREATED, LAST_MODIFIED, LAST_EXECUTED, LAST_VERIFIED
  FROM DBA_SQL_PLAN_BASELINES;
 WHERE SQL_TEXT LIKE '%/* zzz */%';
SELECT PLAN_HASH_VALUE, CHILD_NUMBER, SQL_PLAN_BASELINE
  FROM V$SQL 
 WHERE SQL_TEXT LIKE '%/* zzz */%'
   AND SQL_PLAN_BASELINE IS NOT NULL;

-- SQL PLAN BASELINE에 등록된 플랜 조회
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_SQL_PLAN_BASELINE('SQL_403225c7937a2ce6', 'SQL_PLAN_40cj5sy9rnb76169efe64' ,'ADVANCED')) -- BASIC / ADVANCED



-- 주의: DBA_SQL_PLAN_BASELINES에 2번 이상 실행된 쿼리가 바로 등록되지 않는 경우가 있음.
-- 특히, DBMS_SPM.DROP_SQL_PLAN_BASELINE 등을 통해 dba_sql_plan_baslines 내용을 삭제한 경우 autotask job이 돌면서 한꺼번에 baseline이 생성되기도 함.

-- AutoTask 클라이언트 상태 확인
SELECT *
FROM dba_autotask_client WHERE client_name = 'sql tuning advisor';

SELECT * 
FROM
    dba_autotask_client_history
WHERE
    client_name = 'sql tuning advisor'
ORDER BY
    window_start_time DESC;

SELECT * 
FROM
    dba_autotask_job_history
WHERE
    client_name = 'sql tuning advisor'
ORDER BY
    window_start_time DESC;

SELECT * FROM DBA_SCHEDULER_JOB_RUN_DETAILS WHERE JOB_NAME LIKE 'ORA$AT_SQ_SQL_SW%';
SELECT * FROM DBA_SCHEDULER_JOB_LOG WHERE JOB_NAME LIKE 'ORA$AT_SQ_SQL_SW%';









---------------------------------------------------------------------------------------------------
-- 2.2 SQL Baseline Capture 테스트 (수동)
---------------------------------------------------------------------------------------------------


-- CURSOR CACHE -- 
SELECT * FROM v$sql
 WHERE SQL_TEXT LIKE '%/* zzz */%';

DECLARE A_RETURN PLS_INTEGER;
BEGIN
    A_RETURN := DBMS_SPM.LOAD_PLANS_FROM_CURSOR_CACHE(SQL_ID=>'9szd5ynmpcg4r');
END;

-- Check SQL Plan Baseline
SELECT SQL_HANDLE, PLAN_NAME, SQL_TEXT, ENABLED, ACCEPTED, FIXED, REPRODUCED, AUTOPURGE, ADAPTIVE, ORIGIN, CREATED, LAST_MODIFIED, LAST_EXECUTED, LAST_VERIFIED
  FROM DBA_SQL_PLAN_BASELINES;
 WHERE SQL_TEXT LIKE '%/* zzz */%';
SELECT PLAN_HASH_VALUE, CHILD_NUMBER, SQL_PLAN_BASELINE
  FROM V$SQL 
 WHERE SQL_TEXT LIKE '%/* zzz */%'
   AND SQL_PLAN_BASELINE IS NOT NULL;



   
   
-- STS --
DECLARE A_RETURN PLS_INTEGER;
BEGIN
    A_RETURN := DBMS_SPM.LOAD_PLANS_FROM_SQLSET(
                SQLSET_NAME=>'SQLT_WKLD_STS_TEST', 
                SQLSET_OWNER=>'SCOTT');
END;

-- Check SQL Plan Baseline
SELECT SQL_HANDLE, PLAN_NAME, SQL_TEXT, ENABLED, ACCEPTED, FIXED, REPRODUCED, AUTOPURGE, ADAPTIVE, ORIGIN, CREATED, LAST_MODIFIED, LAST_EXECUTED, LAST_VERIFIED
  FROM DBA_SQL_PLAN_BASELINES
 WHERE SQL_TEXT LIKE '%/* zzz */%';
SELECT PLAN_HASH_VALUE, CHILD_NUMBER, SQL_PLAN_BASELINE
  FROM V$SQL 
 WHERE SQL_TEXT LIKE '%/* zzz */%'
   AND SQL_PLAN_BASELINE IS NOT NULL;




-- STAGING TABLE --        # 오류 발생하는데 확인 필요. 그런데 이걸로 안 해도 Staging table에서 STS 만든 후 STS에서 baseline으로 옮기면 되기 때문에 문제 없음.
DECLARE A_RETURN PLS_INTEGER;
BEGIN
    A_RETURN := DBMS_SPM.UNPACK_STGTAB_BASELINE (
       table_name=>'my_11g_staging_table',
       table_owner=>'SYSTEM',
       creator=>'SYSTEM');
END;
/





-- AWR -- 

-- AWR추출용 DBID, INSTANCE_NUMBER, SNAP_ID 확인
SELECT DBID
     , INSTANCE_NUMBER
     , MIN(SNAP_ID) AS START_SNAP_ID
     , MAX(SNAP_ID) AS END_SNAP_ID
  FROM DBA_HIST_SNAPSHOT
 GROUP BY DBID, INSTANCE_NUMBER
 ORDER BY DBID, INSTANCE_NUMBER
;
-- AWR Snapshot 간격 및 보관기간 확인
SELECT SNAP_INTERVAL, RETENTION FROM DBA_HIST_WR_CONTROL;

-- AWR 리포트 추출
SELECT OUTPUT FROM TABLE(DBMS_WORKLOAD_REPOSITORY.AWR_REPORT_TEXT(1729659184, 1, 32, 33));

-- AWR 내 SQL Baseline Capture 
DECLARE A_RETURN PLS_INTEGER;
BEGIN
    A_RETURN := DBMS_SPM.LOAD_PLANS_FROM_AWR(BEGIN_SNAP=>32, END_SNAP=>33);
END;

-- Check SQL Plan Baseline
--SELECT SQL_HANDLE, ORIGIN, SQL_TEXT, ENABLED, ACCEPTED, FIXED, AUTOPURGE
SELECT *
  FROM DBA_SQL_PLAN_BASELINES
 WHERE 1=1
   AND ORIGIN LIKE '%AWR%'
   AND SQL_TEXT LIKE '%/* cursorcache */%'
SELECT PLAN_HASH_VALUE, CHILD_NUMBER, SQL_PLAN_BASELINE
  FROM V$SQL 
 WHERE SQL_TEXT LIKE '%/* zzz */%'
   AND SQL_PLAN_BASELINE IS NOT NULL;








   
   
---------------------------------------------------------------------------------------------------
-- 3. SQL PLan Baseline 속성 변경하기 (ENABLED, FIXED, AUTOPURGE 등)
---------------------------------------------------------------------------------------------------

-- FIXED로 변경
DECLARE A_RETURN PLS_INTEGER;
BEGIN
A_RETURN := DBMS_SPM.ALTER_SQL_PLAN_BASELINE(sql_handle=> 'SQL_896b0353d0a7cb72'
                                           , plan_name=>'SQL_PLAN_8kus3ag8agkvk169efe64'
                                           , attribute_name=>'FIXED'
                                           , attribute_value=>'YES') ;
END;

-- 원복
DECLARE A_RETURN PLS_INTEGER;
BEGIN
A_RETURN := DBMS_SPM.ALTER_SQL_PLAN_BASELINE(sql_handle=> 'SQL_896b0353d0a7cb72'
                                           , plan_name=>'SQL_PLAN_8kus3ag8agkvk169efe64'
                                           , attribute_name=>'FIXED'
                                           , attribute_value=>'NO') ;
END;   

-- Check SQL Plan Baseline
SELECT SQL_HANDLE, PLAN_NAME, ORIGIN, SQL_TEXT, ENABLED, ACCEPTED, FIXED, AUTOPURGE, REPRODUCED, ADAPTIVE
  FROM DBA_SQL_PLAN_BASELINES
 WHERE 1=1
   AND SQL_TEXT LIKE '%/* zzz */%';





---------------------------------------------------------------------------------------------------
-- 4 SQL Plan Evolve (자동) - Automatic SPM 
-- (19c 이후. Evolve 배치가 매시간 수행되고 30분(TIME_LIMIT)을 넘기지 않음. Automatic STS 활성화 필요)
---------------------------------------------------------------------------------------------------
-- high-frequency SPM evolve task
-- 19c 전에는 Auto Task 스케쥴에 맞춰서 SPM 이 자동수행되었으나, 19c 부터는 매시간마다 수행.

/*
1. 시스템자원을 많이 소모하는 SQL 실행계획이 있는지 AWR/ASTS 를 검사한다.
2. ASTS 에서 대체 SQL 실행계획을 찾는다.
3. SPM evolve advisor 가 대체 실행계획들을 실행하여 성능을 비교한다.
4. SPM evolve advisor 는 가장 성능이 좋은 실행 계획을 선택하여 SQL plan baseline 에 추가한다.
5. SQL plan baseline 은 성능이 안좋은 실행 계획이 사용되는 것을 방지한다.

※ 19c 부터는 Automatic SPM 에서 ASTS 를 사용할 수 있음. ASTS 는 기존 Plan History 보다 효율성이 높음.

*/

-- automatic SPM On 변경
BEGIN
  DBMS_SPM.CONFIGURE('AUTO_SPM_EVOLVE_TASK','ON');
END;
/

BEGIN
   DBMS_SPM.SET_EVOLVE_TASK_PARAMETER(
      task_name => 'SYS_AUTO_SPM_EVOLVE_TASK',
      parameter => 'ALTERNATE_PLAN_SOURCE',
      value     => 'SQL_TUNING_SET');
END;

/
BEGIN
   DBMS_SPM.SET_EVOLVE_TASK_PARAMETER(
      task_name => 'SYS_AUTO_SPM_EVOLVE_TASK' ,
      parameter => 'ACCEPT_PLANS',
      value     => 'TRUE');
END;
/

-- automatic SPM Off 변경
-- BEGIN
   -- DBMS_SPM.CONFIGURE('AUTO_SPM_EVOLVE_TASK','OFF');
-- END;
-- /

-- BEGIN 
   -- DBMS_SPM.SET_EVOLVE_TASK_PARAMETER( 
      -- task_name => 'SYS_AUTO_SPM_EVOLVE_TASK' ,
      -- parameter => 'ALTERNATE_PLAN_BASELINE', 
      -- value     => 'EXISTING');
-- END; 
-- /
-- BEGIN
    -- DBMS_SPM.SET_EVOLVE_TASK_PARAMETER(
        -- task_name => 'SYS_AUTO_SPM_EVOLVE_TASK',
        -- parameter => 'ALTERNATE_PLAN_SOURCE',
        -- value     => 'AUTO');
-- END;
/

-- automatic SPM On/Off 상태 체크
SELECT PARAMETER_VALUE
  FROM DBA_SQL_MANAGEMENT_CONFIG
 WHERE PARAMETER_NAME = 'AUTO_SPM_EVOLVE_TASK';

-- automatic SPM 파라미터 조회
SELECT PARAMETER_NAME, PARAMETER_VALUE, IS_DEFAULT, DESCRIPTION
  FROM DBA_ADVISOR_PARAMETERS
 WHERE TASK_NAME = 'SYS_AUTO_SPM_EVOLVE_TASK'
   AND PARAMETER_VALUE != 'UNUSED';



-- Automatic evolution task 기능 활성화
BEGIN
  DBMS_AUTO_TASK_ADMIN.ENABLE (
    client_name => 'sql tuning advisor'
,   operation   => NULL
,   window_name => NULL
);
END;
/

-- Automatic evolution task 기능 비활성화
-- BEGIN
  -- DBMS_AUTO_TASK_ADMIN.DISABLE (
    -- client_name => 'sql tuning advisor'
-- ,   operation   => NULL
-- ,   window_name => NULL
-- );
-- END;
/

-- Automatic evolution task 활성화 상태 조회
SELECT CLIENT_NAME, STATUS
  FROM DBA_AUTOTASK_CLIENT
 WHERE CLIENT_NAME = 'sql tuning advisor';


-- automatic SPM 스케쥴 Enable/Disable 상태 조회
SELECT TASK_NAME, STATUS, INTERVAL, ENABLED 
  FROM DBA_AUTOTASK_SCHEDULE_CONTROL 
 WHERE TASK_NAME = 'Auto SPM Task';



-- Automatic STS 활성화
Begin
    DBMS_Auto_Task_Admin.Enable(
        Client_Name => 'Auto STS Capture Task',
        Operation => NULL,
        Window_name => NULL);
End;
/

-- Automatic STS 비활성화
-- Begin
    -- DBMS_Auto_Task_Admin.Disable(
        -- Client_Name => 'Auto STS Capture Task',
        -- Operation => NULL,
        -- Window_name => NULL);
-- End;
-- /

-- Automatic STS 상태 조회
SELECT TASK_NAME, STATUS, INTERVAL, ENABLED 
  FROM DBA_AUTOTASK_SCHEDULE_CONTROL
 WHERE TASK_NAME = 'Auto STS Capture Task';










-- PLAN BASELINE 확인 - 테스트 쿼리(/* zzz */)가 2개 플랜을 가지고 있음
SELECT SQL_HANDLE, PLAN_NAME, SQL_TEXT, ENABLED, ACCEPTED, FIXED, REPRODUCED, AUTOPURGE, ADAPTIVE, ORIGIN, CREATED, LAST_MODIFIED, LAST_EXECUTED, LAST_VERIFIED
  FROM DBA_SQL_PLAN_BASELINES
 WHERE SQL_TEXT LIKE '%/* zzz */%'
   AND SQL_HANDLE = 'SQL_f371c8c1443b184f';


-- 플랜 확인 - 좋은 플랜(HASH)
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_SQL_PLAN_BASELINE('SQL_f371c8c1443b184f', 'SQL_PLAN_g6wf8s523q62g169efe64' ,'ADVANCED'));
-- 플랜 확인 - 나쁜 플랜(NL)
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_SQL_PLAN_BASELINE('SQL_f371c8c1443b184f', 'SQL_PLAN_g6wf8s523q62g55c864d5' ,'ADVANCED'));

-- SQL plan baseline에서 테스트 쿼리 삭제
DECLARE
  dr PLS_INTEGER;
BEGIN
  dr := DBMS_SPM.DROP_SQL_PLAN_BASELINE(
    sql_handle => 'SQL_f371c8c1443b184f'
  );
END;
/

-- CURSOR CACHE에서 나쁜 플랜 BASELINE으로 로딩 
SELECT SQL_TEXT, SQL_ID, PLAN_HASH_VALUE FROM v$sql
 WHERE SQL_TEXT LIKE '%/* zzz */%';

DECLARE A_RETURN PLS_INTEGER;
BEGIN
    A_RETURN := DBMS_SPM.LOAD_PLANS_FROM_CURSOR_CACHE(SQL_ID=>'9szd5ynmpcg4r', PLAN_HASH_VALUE=>339492458);
END;

-- Check SQL Plan Baseline
SELECT SQL_HANDLE, PLAN_NAME, SQL_TEXT, ENABLED, ACCEPTED, FIXED, REPRODUCED, AUTOPURGE, ADAPTIVE, ORIGIN, CREATED, LAST_MODIFIED, LAST_EXECUTED, LAST_VERIFIED
  FROM DBA_SQL_PLAN_BASELINES
 WHERE SQL_TEXT LIKE '%/* zzz */%'
   AND SQL_HANDLE = 'SQL_f371c8c1443b184f';

-- 플랜 확인 - 나쁜 플랜(NL)
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_SQL_PLAN_BASELINE('SQL_f371c8c1443b184f', 'SQL_PLAN_g6wf8s523q62g55c864d5' ,'ADVANCED'));

-- 현재 테스트 쿼리는 나쁜 플랜(NL)으로 풀림
alter session set optimizer_ignore_hints = false;
select /* zzz */ /*+ USE_NL(t1) LEADING(t2 t1) */ sum(t2.amount)
  from SCOTT.sales_area1 t1, 
       SCOTT.sales_area2 t2
 where t1.sale_code = t2.sale_code
   and t1.sale_type  = 1;

-- PLAN BASELINE 확인 - 테스트 쿼리(/* zzz */)가 1개 나쁜 플랜(NL) 밖에 없음
SELECT SQL_HANDLE, PLAN_NAME, SQL_TEXT, ENABLED, ACCEPTED, FIXED, REPRODUCED, AUTOPURGE, ADAPTIVE, ORIGIN, CREATED, LAST_MODIFIED, LAST_EXECUTED, LAST_VERIFIED
  FROM DBA_SQL_PLAN_BASELINES
 WHERE SQL_TEXT LIKE '%/* zzz */%'
   AND SQL_HANDLE = 'SQL_f371c8c1443b184f';

-- 아래 테스트 쿼리 수행 시 좋은 플랜(HASH)으로 풀려야 하지만 기존 안 좋은 플랜(NL)이 ACCEPTED 상태이므로 안 좋은 플랜으로 실행됨.
-- 하지만 아래 테스트 쿼리 2번 이상 수행 시 좋은 플랜도 PLAN BASELINE에 ACCEPTED=NO 상태로 올라감.
alter session set optimizer_ignore_hints = true;
select /* zzz */ /*+ USE_NL(t1) LEADING(t2 t1) */ sum(t2.amount)
  from SCOTT.sales_area1 t1, 
       SCOTT.sales_area2 t2
 where t1.sale_code = t2.sale_code
   and t1.sale_type  = 1;

-- PLAN BASELINE 확인 - 테스트 쿼리(/* zzz */)가 2개. 나쁜 플랜 ACCEPTED='YES', 좋은 플랜 ACCEPTED='NO'. 두 플랜 다 ENABLED='YES' 상태.
SELECT SQL_HANDLE, PLAN_NAME, SQL_TEXT, ENABLED, ACCEPTED, FIXED, REPRODUCED, AUTOPURGE, ADAPTIVE, ORIGIN, CREATED, LAST_MODIFIED, LAST_EXECUTED, LAST_VERIFIED
  FROM DBA_SQL_PLAN_BASELINES
 WHERE SQL_TEXT LIKE '%/* zzz */%'
   AND SQL_HANDLE = 'SQL_f371c8c1443b184f';


---------------------------- ORA$_ATSK_AUTOSPMT 배치 대기 (1시간마다 실행됨) ----------------------------
-- 배치 상태 확인
SELECT
    JOB_NAME,
    STATE,
    LAST_START_DATE,
    LAST_RUN_DURATION,
    NEXT_RUN_DATE,
    ENABLED
FROM
    DBA_SCHEDULER_JOBS
WHERE
    JOB_NAME LIKE '%SPMT%';

SELECT JOB_NAME
     , STATUS
     , TO_CHAR(ACTUAL_START_DATE, 'YYYY-MM-DD HH24:MI:SS') AS START_DATE
     , RUN_DURATION
     , ADDITIONAL_INFO
  FROM DBA_SCHEDULER_JOB_RUN_DETAILS
 WHERE JOB_NAME LIKE '%SPMT%'   
 ORDER BY ACTUAL_START_DATE DESC;

SELECT OWNER
     , JOB_NAME
     , JOB_CLASS
     , STATUS
     , TO_CHAR(LOG_DATE, 'YYYY-MM-DD HH24:MI:SS') AS LOG_DATE
     , ADDITIONAL_INFO
  FROM DBA_SCHEDULER_JOB_LOG
 WHERE JOB_NAME LIKE '%SPMT%'
 ORDER BY LOG_DATE DESC;


-- Automatic Evolution Task Report
SELECT DBMS_SPM.REPORT_AUTO_EVOLVE_TASK FROM DUAL;

DECLARE
    report clob;
BEGIN
    report := DBMS_SPM.REPORT_AUTO_EVOLVE_TASK(TYPE => 'TEXT', LEVEL => 'ALL', section => 'ALL');
    DBMS_OUTPUT.PUT_LINE(report);
END;
/

-- PLAN BASELINE 확인 - 테스트 쿼리(/* zzz */)가 2개. 나쁜 플랜, 좋은 플랜 모두 ACCEPTED='YES' 상태로 변경됨. 좋은 플랜이 evolve 함.
SELECT SQL_HANDLE, PLAN_NAME, SQL_TEXT, ENABLED, ACCEPTED, FIXED, REPRODUCED, AUTOPURGE, ADAPTIVE, ORIGIN, CREATED, LAST_MODIFIED, LAST_EXECUTED, LAST_VERIFIED
  FROM DBA_SQL_PLAN_BASELINES
 WHERE SQL_TEXT LIKE '%/* zzz */%'
   AND SQL_HANDLE = 'SQL_f371c8c1443b184f';

























































---------------------------------------------------------------------------------------------------
-- 5. SQL Plan Evolve (수동)
---------------------------------------------------------------------------------------------------

-- PLAN BASELINE 확인 - 테스트 쿼리(/* zzz */)가 2개 플랜을 가지고 있음
SELECT SQL_HANDLE, PLAN_NAME, SQL_TEXT, ENABLED, ACCEPTED, FIXED, REPRODUCED, AUTOPURGE, ADAPTIVE, ORIGIN, CREATED, LAST_MODIFIED, LAST_EXECUTED, LAST_VERIFIED
  FROM DBA_SQL_PLAN_BASELINES
 WHERE SQL_TEXT LIKE '%/* zzz */%'
   AND SQL_HANDLE = 'SQL_f371c8c1443b184f';


-- 플랜 확인 - 좋은 플랜(HASH)
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_SQL_PLAN_BASELINE('SQL_f371c8c1443b184f', 'SQL_PLAN_g6wf8s523q62g169efe64' ,'ADVANCED'));
-- 플랜 확인 - 나쁜 플랜(NL)
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_SQL_PLAN_BASELINE('SQL_f371c8c1443b184f', 'SQL_PLAN_g6wf8s523q62g55c864d5' ,'ADVANCED'));

-- SQL plan baseline에서 테스트 쿼리 삭제
DECLARE
  dr PLS_INTEGER;
BEGIN
  dr := DBMS_SPM.DROP_SQL_PLAN_BASELINE(
    sql_handle => 'SQL_f371c8c1443b184f'
  );
END;
/

-- CURSOR CACHE에서 나쁜 플랜 BASELINE으로 로딩 
SELECT SQL_TEXT, SQL_ID, PLAN_HASH_VALUE FROM v$sql
 WHERE SQL_TEXT LIKE '%/* zzz */%';

DECLARE A_RETURN PLS_INTEGER;
BEGIN
    A_RETURN := DBMS_SPM.LOAD_PLANS_FROM_CURSOR_CACHE(SQL_ID=>'9szd5ynmpcg4r', PLAN_HASH_VALUE=>339492458);
END;

-- Check SQL Plan Baseline
SELECT SQL_HANDLE, PLAN_NAME, SQL_TEXT, ENABLED, ACCEPTED, FIXED, REPRODUCED, AUTOPURGE, ADAPTIVE, ORIGIN, CREATED, LAST_MODIFIED, LAST_EXECUTED, LAST_VERIFIED
  FROM DBA_SQL_PLAN_BASELINES
 WHERE SQL_TEXT LIKE '%/* zzz */%'
   AND SQL_HANDLE = 'SQL_f371c8c1443b184f';

-- 플랜 확인 - 나쁜 플랜(NL)
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_SQL_PLAN_BASELINE('SQL_f371c8c1443b184f', 'SQL_PLAN_g6wf8s523q62g55c864d5' ,'ADVANCED'));

-- 현재 테스트 쿼리는 나쁜 플랜(NL)으로 풀림
alter session set optimizer_ignore_hints = false;
select /* zzz */ /*+ USE_NL(t1) LEADING(t2 t1) */ sum(t2.amount)
  from SCOTT.sales_area1 t1, 
       SCOTT.sales_area2 t2
 where t1.sale_code = t2.sale_code
   and t1.sale_type  = 1;

-- PLAN BASELINE 확인 - 테스트 쿼리(/* zzz */)가 1개 나쁜 플랜(NL) 밖에 없음
SELECT SQL_HANDLE, PLAN_NAME, SQL_TEXT, ENABLED, ACCEPTED, FIXED, REPRODUCED, AUTOPURGE, ADAPTIVE, ORIGIN, CREATED, LAST_MODIFIED, LAST_EXECUTED, LAST_VERIFIED
  FROM DBA_SQL_PLAN_BASELINES
 WHERE SQL_TEXT LIKE '%/* zzz */%'
   AND SQL_HANDLE = 'SQL_f371c8c1443b184f';

-- 아래 테스트 쿼리 수행 시 좋은 플랜(HASH)으로 풀려야 하지만 기존 안 좋은 플랜(NL)이 ACCEPTED 상태이므로 안 좋은 플랜으로 실행됨.
-- 하지만 아래 테스트 쿼리 2번 이상 수행 시 좋은 플랜도 PLAN BASELINE에 ACCEPTED=NO 상태로 올라감.
alter session set optimizer_ignore_hints = true;
select /* zzz */ /*+ USE_NL(t1) LEADING(t2 t1) */ sum(t2.amount)
  from SCOTT.sales_area1 t1, 
       SCOTT.sales_area2 t2
 where t1.sale_code = t2.sale_code
   and t1.sale_type  = 1;

-- PLAN BASELINE 확인 - 좋은 플랜(HASH)이 PLAN BASELINE에 ACCEPTED=NO 상태로 추가됨
SELECT SQL_HANDLE, PLAN_NAME, SQL_TEXT, ENABLED, ACCEPTED, FIXED, REPRODUCED, AUTOPURGE, ADAPTIVE, ORIGIN, CREATED, LAST_MODIFIED, LAST_EXECUTED, LAST_VERIFIED
  FROM DBA_SQL_PLAN_BASELINES
 WHERE SQL_TEXT LIKE '%/* zzz */%'
   AND SQL_HANDLE = 'SQL_f371c8c1443b184f';

-- 여기까지 왔으면 좋은 플랜(HASH)가 ACCEPTED=NO, 나쁜 플랜(NL)이 ACCEPTED=YES 상태임.
-- EVOLVE_SQL_PLAN_BASELINE 함수로 좋은 플랜(HASH)을 ACCEPTED=YES로 변경하면 추후 테스트 쿼리 수행 시 좋은 플랜으로만 수행됨.
-- 아래 프로시저 수행 시 evolve를 하는 게 좋을 지, 한다면 얼마나 개선될지 report를 출력해줌.
DECLARE
    report clob;
BEGIN
    report := DBMS_SPM.EVOLVE_SQL_PLAN_BASELINE(
        sql_handle=>'SQL_f371c8c1443b184f',
        plan_name=>'SQL_PLAN_g6wf8s523q62g169efe64',
        time_limit=>DBMS_SPM.AUTO_LIMIT,    -- 타임아웃 시간
        verify=>'YES',    -- YES: non-accepted 플랜을 직접 실행/검증. NO: 검증 없음
        commit=>'YES'    -- YES: DBA_SQL_PLAN_BASELINES에서 ACCEPTED=YES로 FLAG 변경. NO: FLAG 변경 없음
    );
    DBMS_OUTPUT.PUT_LINE(report);
END;
/

-- 이제 테스트 쿼리 수행 시 좋은 플랜(HASH)으로도 실행이 됨. 좋은 플랜도 PLAN BASELINE이 ACCEPTED='YES' 상태이기 때문임.
alter session set optimizer_ignore_hints = true;
select /* zzz */ /*+ USE_NL(t1) LEADING(t2 t1) */ sum(t2.amount)
  from SCOTT.sales_area1 t1, 
       SCOTT.sales_area2 t2
 where t1.sale_code = t2.sale_code
   and t1.sale_type  = 1;

-- 아래는 나쁜 플랜이 baseline에 accepted=yes인 상황에서 더 나은 플랜을 수동 EVOLVE 시도했을 떄
-- 성공한 EVOLVE_SQL_PLAN_BASELINE REPORT 예시임
-- #############################################################################################
-- GENERAL INFORMATION SECTION
-- ---------------------------------------------------------------------------------------------
-- 
--  Task Information:                             
--  --------------------------------------------- 
--  Task Name            : TASK_306            
--  Task Owner           : SYSTEM              
--  Execution Name       : EXEC_346            
--  Execution Type       : SPM EVOLVE          
--  Scope                : COMPREHENSIVE       
--  Status               : COMPLETED           
--  Started              : 06/23/2025 16:45:39 
--  Finished             : 06/23/2025 16:45:55 
--  Last Updated         : 06/23/2025 16:45:55 
--  Global Time Limit    : 2147483646          
--  Per-Plan Time Limit  : UNUSED              
--  Number of Errors     : 0                   
-- ---------------------------------------------------------------------------------------------
-- 
-- SUMMARY SECTION
-- ---------------------------------------------------------------------------------------------
--   Number of plans processed  : 1  
--   Number of findings         : 2  
--   Number of recommendations  : 1  
--   Number of errors           : 0  
-- ---------------------------------------------------------------------------------------------
-- 
-- DETAILS SECTION
-- ---------------------------------------------------------------------------------------------
--  Object ID          : 2                                                         
--  Test Plan Name     : SQL_PLAN_g6wf8s523q62g169efe64                            
--  Base Plan Name     : SQL_PLAN_g6wf8s523q62g55c864d5                            
--  SQL Handle         : SQL_f371c8c1443b184f                                      
--  Parsing Schema     : SYSTEM                                                    
--  Test Plan Creator  : SYSTEM                                                    
--  SQL Text           : select /* zzz */ /*+ USE_NL(t1) LEADING(t2 t1) */         
--                     sum(t2.amount) from SCOTT.sales_area1 t1, SCOTT.sales_area2 
--                     t2 where t1.sale_code = t2.sale_code and t1.sale_type = 1   
-- 
-- Execution Statistics:
-- -----------------------------
--                     Base Plan                     Test Plan                    
--                     ----------------------------  ---------------------------- 
--  Elapsed Time (s):  0                             .026573                      
--  CPU Time (s):      0                             .025973                      
--  Buffer Gets:       0                             25771                        
--  Optimizer Cost:    56889611                      7603                         
--  Disk Reads:        0                             0                            
--  Direct Writes:     0                             0                            
--  Rows Processed:    0                             1                            
--  Executions:        0                             10                           
-- 
-- 
-- FINDINGS SECTION
-- ---------------------------------------------------------------------------------------------
-- 
-- Findings (2):
-- -----------------------------
--  1. The plan was verified in 15.68700 seconds. It passed the benefit criterion  
--     because its verified performance was 1288.36128 times better than that of   
--     the baseline plan.                                                          
--  2. The plan is adaptive and matches the final executed plan. Implementing the  
--     recommendation will change the plan to static and accepted.                 
-- 
-- Recommendation:
-- -----------------------------
--  Consider accepting the plan.                                                   
-- 
-- 
-- EXPLAIN PLANS SECTION
-- ---------------------------------------------------------------------------------------------
-- 
-- Baseline Plan
-- -----------------------------
--  Plan Id          : 847        
--  Plan Hash Value  : 1439196373 
-- 
-- --------------------------------------------------------------------------------------------------
-- | Id  | Operation                       | Name        | Rows     | Bytes   | Cost     | Time     |
-- --------------------------------------------------------------------------------------------------
-- |   0 | SELECT STATEMENT                |             |        1 |      33 | 56889611 | 00:37:03 |
-- |   1 |   SORT AGGREGATE                |             |        1 |      33 |          |          |
-- |   2 |    NESTED LOOPS                 |             |    56250 | 1856250 | 56889611 | 00:37:03 |
-- |   3 |     NESTED LOOPS                |             | 56250000 | 1856250 | 56889611 | 00:37:03 |
-- |   4 |      TABLE ACCESS FULL          | SALES_AREA2 |    75000 | 1950000 |     6843 | 00:00:01 |
-- | * 5 |      INDEX RANGE SCAN           | SALES_TYP1I |      750 |         |        8 | 00:00:01 |
-- | * 6 |     TABLE ACCESS BY INDEX ROWID | SALES_AREA1 |        1 |       7 |      758 | 00:00:01 |
-- --------------------------------------------------------------------------------------------------
-- 
-- Predicate Information (identified by operation id):
-- ------------------------------------------
-- * 5 - access("T1"."SALE_TYPE"=1)
-- * 6 - filter("T1"."SALE_CODE"="T2"."SALE_CODE")
-- 
-- Hint Report (identified by operation id / Query Block Name / Object Alias):
-- Total hints for statement: 2 (U - Unused (2))
-- -------------------------------------------------------------------------------
--                                                                       
--  1 -  SEL$1                                                           
--        U -  LEADING(t2 t1) / rejected by IGNORE_OPTIM_EMBEDDED_HINTS  
--                                                                       
--  5 -  SEL$1 / T1@SEL$1                                                
--        U -  USE_NL(t1) / rejected by IGNORE_OPTIM_EMBEDDED_HINTS      
-- 
-- Test Plan
-- -----------------------------
--  Plan Id          : 848       
--  Plan Hash Value  : 379518564 
-- 
-- ---------------------------------------------------------------------------------------------------
-- | Id  | Operation                               | Name        | Rows  | Bytes   | Cost | Time     |
-- ---------------------------------------------------------------------------------------------------
-- |   0 | SELECT STATEMENT                        |             |     1 |      33 | 7603 | 00:00:01 |
-- |   1 |   SORT AGGREGATE                        |             |     1 |      33 |      |          |
-- | * 2 |    HASH JOIN                            |             | 56250 | 1856250 | 7603 | 00:00:01 |
-- |   3 |     TABLE ACCESS BY INDEX ROWID BATCHED | SALES_AREA1 |   750 |    5250 |  759 | 00:00:01 |
-- | * 4 |      INDEX RANGE SCAN                   | SALES_TYP1I |   750 |         |    9 | 00:00:01 |
-- |   5 |     TABLE ACCESS FULL                   | SALES_AREA2 | 75000 | 1950000 | 6843 | 00:00:01 |
-- ---------------------------------------------------------------------------------------------------
-- 
-- Predicate Information (identified by operation id):
-- ------------------------------------------
-- * 2 - access("T1"."SALE_CODE"="T2"."SALE_CODE")
-- * 4 - access("T1"."SALE_TYPE"=1)
-- 
-- Hint Report (identified by operation id / Query Block Name / Object Alias):
-- Total hints for statement: 2 (U - Unused (2))
-- -------------------------------------------------------------------------------
--                                                                       
--  1 -  SEL$1                                                           
--        U -  LEADING(t2 t1) / rejected by IGNORE_OPTIM_EMBEDDED_HINTS  
--                                                                       
--  3 -  SEL$1 / T1@SEL$1                                                
--        U -  USE_NL(t1) / rejected by IGNORE_OPTIM_EMBEDDED_HINTS      
-- ---------------------------------------------------------------------------------------------
-- #############################################################################################

-- 이제 반대로 좋은 플랜이 BASELINE으로 먼저 등록되어 있고 나쁜 플랜이 이후 BASELINE으로 등록되는 경우를 살펴보자.
-- SQL plan baseline에서 테스트 쿼리 삭제
DECLARE
  dr PLS_INTEGER;
BEGIN
  dr := DBMS_SPM.DROP_SQL_PLAN_BASELINE(
    sql_handle => 'SQL_f371c8c1443b184f'
  );
END;
/

-- CURSOR CACHE에서 좋은 플랜 BASELINE으로 로딩 
SELECT SQL_TEXT, SQL_ID, PLAN_HASH_VALUE FROM v$sql
 WHERE SQL_TEXT LIKE '%/* zzz */%';

DECLARE A_RETURN PLS_INTEGER;
BEGIN
    A_RETURN := DBMS_SPM.LOAD_PLANS_FROM_CURSOR_CACHE(SQL_ID=>'9szd5ynmpcg4r', PLAN_HASH_VALUE=>2727377809);
END;

-- PLAN BASELINE 확인 - 테스트 쿼리(/* zzz */)가 1개 좋은 플랜(HASH) 밖에 없음
SELECT SQL_HANDLE, PLAN_NAME, SQL_TEXT, ENABLED, ACCEPTED, FIXED, REPRODUCED, AUTOPURGE, ADAPTIVE, ORIGIN, CREATED, LAST_MODIFIED, LAST_EXECUTED, LAST_VERIFIED
  FROM DBA_SQL_PLAN_BASELINES
 WHERE SQL_TEXT LIKE '%/* zzz */%'
   AND SQL_HANDLE = 'SQL_f371c8c1443b184f';

-- 플랜 확인 - 좋은 플랜(HASH)
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_SQL_PLAN_BASELINE('SQL_f371c8c1443b184f', 'SQL_PLAN_g6wf8s523q62g169efe64' ,'ADVANCED'));

-- 현재 테스트 쿼리는 좋은 플랜(HASH)으로 풀림
alter session set optimizer_ignore_hints = true;
select /* zzz */ /*+ USE_NL(t1) LEADING(t2 t1) */ sum(t2.amount)
  from SCOTT.sales_area1 t1, 
       SCOTT.sales_area2 t2
 where t1.sale_code = t2.sale_code
   and t1.sale_type  = 1;

-- 아래 테스트 쿼리 수행 시 나쁜 플랜(NL)으로 풀려야 하지만 기존 좋은 플랜(HASH)이 ACCEPTED 상태이므로 좋은 플랜으로 실행됨.
-- 하지만 아래 테스트 쿼리 2번 이상 수행 시 나쁜 플랜도 PLAN BASELINE에 ACCEPTED=NO 상태로 올라감.
alter session set optimizer_ignore_hints = false;
select /* zzz */ /*+ USE_NL(t1) LEADING(t2 t1) */ sum(t2.amount)
  from SCOTT.sales_area1 t1, 
       SCOTT.sales_area2 t2
 where t1.sale_code = t2.sale_code
   and t1.sale_type  = 1;

-- PLAN BASELINE 확인 - 좋은 플랜(HASH)이 PLAN BASELINE에 ACCEPTED=NO 상태로 추가됨
SELECT SQL_HANDLE, PLAN_NAME, SQL_TEXT, ENABLED, ACCEPTED, FIXED, REPRODUCED, AUTOPURGE, ADAPTIVE, ORIGIN, CREATED, LAST_MODIFIED, LAST_EXECUTED, LAST_VERIFIED
  FROM DBA_SQL_PLAN_BASELINES
 WHERE SQL_TEXT LIKE '%/* zzz */%'
   AND SQL_HANDLE = 'SQL_f371c8c1443b184f';

-- 플랜 확인 - 나쁜 플랜(NL)
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_SQL_PLAN_BASELINE('SQL_f371c8c1443b184f', 'SQL_PLAN_g6wf8s523q62g55c864d5' ,'ADVANCED'));

-- 여기까지 왔으면 좋은 플랜(HASH)가 ACCEPTED=YES, 나쁜 플랜(NL)이 ACCEPTED=NO 상태임.
-- EVOLVE_SQL_PLAN_BASELINE 함수로 나쁜 플랜(HASH)을 EVOLVE 시도하면 EVOLVE 되지 않음. (ACCEPTED=YES로 변경되지 않음)
-- 아래 프로시저 수행 시 evolve를 하는 게 좋을 지, 한다면 얼마나 개선될지 report를 출력해줌.
DECLARE
    report clob;
BEGIN
    report := DBMS_SPM.EVOLVE_SQL_PLAN_BASELINE(
        sql_handle=>'SQL_f371c8c1443b184f',
        plan_name=>'SQL_PLAN_g6wf8s523q62g55c864d5',
        time_limit=>DBMS_SPM.AUTO_LIMIT,    -- 타임아웃 시간
        verify=>'YES',    -- YES: non-accepted 플랜을 직접 실행/검증. NO: 검증 없음
        commit=>'YES'    -- YES: DBA_SQL_PLAN_BASELINES에서 ACCEPTED=YES로 FLAG 변경. NO: FLAG 변경 없음
    );
    DBMS_OUTPUT.PUT_LINE(report);
END;
/

-- 아래는 좋은 플랜이 baseline에 accepted=yes인 상태에서 나쁜 플랜을 evolve 시도했을 때 
-- evolve 시키지 않고 accepted=NO 상태로 유지한 EVOLVE_SQL_PLAN_BASELINE REPORT 예시임
-- GENERAL INFORMATION SECTION
-- ---------------------------------------------------------------------------------------------
-- 
--  Task Information:                             
--  --------------------------------------------- 
--  Task Name            : TASK_318            
--  Task Owner           : SYSTEM              
--  Execution Name       : EXEC_359            
--  Execution Type       : SPM EVOLVE          
--  Scope                : COMPREHENSIVE       
--  Status               : COMPLETED           
--  Started              : 06/23/2025 17:43:33 
--  Finished             : 06/23/2025 17:43:49 
--  Last Updated         : 06/23/2025 17:43:49 
--  Global Time Limit    : 2147483646          
--  Per-Plan Time Limit  : UNUSED              
--  Number of Errors     : 0                   
-- ---------------------------------------------------------------------------------------------
-- 
-- SUMMARY SECTION
-- ---------------------------------------------------------------------------------------------
--   Number of plans processed  : 1  
--   Number of findings         : 1  
--   Number of recommendations  : 0  
--   Number of errors           : 0  
-- ---------------------------------------------------------------------------------------------
-- 
-- DETAILS SECTION
-- ---------------------------------------------------------------------------------------------
--  Object ID          : 2                                                         
--  Test Plan Name     : SQL_PLAN_g6wf8s523q62g55c864d5                            
--  Base Plan Name     : SQL_PLAN_g6wf8s523q62g169efe64                            
--  SQL Handle         : SQL_f371c8c1443b184f                                      
--  Parsing Schema     : SYSTEM                                                    
--  Test Plan Creator  : SYSTEM                                                    
--  SQL Text           : select /* zzz */ /*+ USE_NL(t1) LEADING(t2 t1) */         
--                     sum(t2.amount) from SCOTT.sales_area1 t1, SCOTT.sales_area2 
--                     t2 where t1.sale_code = t2.sale_code and t1.sale_type = 1   
-- 
-- Execution Statistics:
-- -----------------------------
--                     Base Plan                     Test Plan                    
--                     ----------------------------  ---------------------------- 
--  Elapsed Time (s):  .026561                       0                            
--  CPU Time (s):      .025992                       0                            
--  Buffer Gets:       25771                         0                            
--  Optimizer Cost:    7603                          56889611                     
--  Disk Reads:        0                             0                            
--  Direct Writes:     0                             0                            
--  Rows Processed:    1                             0                            
--  Executions:        10                            0                            
-- 
-- 
-- FINDINGS SECTION
-- ---------------------------------------------------------------------------------------------
-- 
-- Findings (1):
-- -----------------------------
--  1. The plan was verified in 15.48500 seconds. It failed the benefit criterion  
--     because its verified performance was 0.00171 times worse than that of the   
--     baseline plan.                                                              
-- 
-- 
-- EXPLAIN PLANS SECTION
-- ---------------------------------------------------------------------------------------------
-- 
-- Baseline Plan
-- -----------------------------
--  Plan Id          : 953       
--  Plan Hash Value  : 379518564 
-- 
-- ---------------------------------------------------------------------------------------------------
-- | Id  | Operation                               | Name        | Rows  | Bytes   | Cost | Time     |
-- ---------------------------------------------------------------------------------------------------
-- |   0 | SELECT STATEMENT                        |             |     1 |      33 | 7603 | 00:00:01 |
-- |   1 |   SORT AGGREGATE                        |             |     1 |      33 |      |          |
-- | * 2 |    HASH JOIN                            |             | 56250 | 1856250 | 7603 | 00:00:01 |
-- |   3 |     TABLE ACCESS BY INDEX ROWID BATCHED | SALES_AREA1 |   750 |    5250 |  759 | 00:00:01 |
-- | * 4 |      INDEX RANGE SCAN                   | SALES_TYP1I |   750 |         |    9 | 00:00:01 |
-- |   5 |     TABLE ACCESS FULL                   | SALES_AREA2 | 75000 | 1950000 | 6843 | 00:00:01 |
-- ---------------------------------------------------------------------------------------------------
-- 
-- Predicate Information (identified by operation id):
-- ------------------------------------------
-- * 2 - access("T1"."SALE_CODE"="T2"."SALE_CODE")
-- * 4 - access("T1"."SALE_TYPE"=1)
-- 
-- Hint Report (identified by operation id / Query Block Name / Object Alias):
-- Total hints for statement: 2 (U - Unused (2))
-- -------------------------------------------------------------------------------
--                                                                       
--  1 -  SEL$1                                                           
--        U -  LEADING(t2 t1) / rejected by IGNORE_OPTIM_EMBEDDED_HINTS  
--                                                                       
--  3 -  SEL$1 / T1@SEL$1                                                
--        U -  USE_NL(t1) / rejected by IGNORE_OPTIM_EMBEDDED_HINTS      
-- 
-- Test Plan
-- -----------------------------
--  Plan Id          : 954        
--  Plan Hash Value  : 1439196373 
-- 
-- --------------------------------------------------------------------------------------------------
-- | Id  | Operation                       | Name        | Rows     | Bytes   | Cost     | Time     |
-- --------------------------------------------------------------------------------------------------
-- |   0 | SELECT STATEMENT                |             |        1 |      33 | 56889611 | 00:37:03 |
-- |   1 |   SORT AGGREGATE                |             |        1 |      33 |          |          |
-- |   2 |    NESTED LOOPS                 |             |    56250 | 1856250 | 56889611 | 00:37:03 |
-- |   3 |     NESTED LOOPS                |             | 56250000 | 1856250 | 56889611 | 00:37:03 |
-- |   4 |      TABLE ACCESS FULL          | SALES_AREA2 |    75000 | 1950000 |     6843 | 00:00:01 |
-- | * 5 |      INDEX RANGE SCAN           | SALES_TYP1I |      750 |         |        8 | 00:00:01 |
-- | * 6 |     TABLE ACCESS BY INDEX ROWID | SALES_AREA1 |        1 |       7 |      758 | 00:00:01 |
-- --------------------------------------------------------------------------------------------------
-- 
-- Predicate Information (identified by operation id):
-- ------------------------------------------
-- * 5 - access("T1"."SALE_TYPE"=1)
-- * 6 - filter("T1"."SALE_CODE"="T2"."SALE_CODE")
-- 
-- Hint Report (identified by operation id / Query Block Name / Object Alias):
-- Total hints for statement: 2 (U - Unused (2))
-- -------------------------------------------------------------------------------
--                                                                       
--  1 -  SEL$1                                                           
--        U -  LEADING(t2 t1) / rejected by IGNORE_OPTIM_EMBEDDED_HINTS  
--                                                                       
--  5 -  SEL$1 / T1@SEL$1                                                
--        U -  USE_NL(t1) / rejected by IGNORE_OPTIM_EMBEDDED_HINTS      
-- ---------------------------------------------------------------------------------------------













-- 급할 경우 SQL_ID만 가지고 ADD_VERIFIED_SQL_PLAN_BASELINE을 사용하면
-- 오라클이 Cursor Cache, Auto STS, AWR 등을 뒤져서 이전 검증된 플랜들을 baseline으로 가져옴.

-- SQL plan baseline에서 테스트 쿼리 삭제
DECLARE
  dr PLS_INTEGER;
BEGIN
  dr := DBMS_SPM.DROP_SQL_PLAN_BASELINE(
    sql_handle => 'SQL_f371c8c1443b184f'
  );
END;
/

-- SQL_ID 조회
SELECT SQL_ID FROM V$SQL WHERE SQL_TEXT LIKE '/* zzz */';

-- ADD_VERIFIED_SQL_PLAN_BASELINE 실행
DECLARE
    report clob;
BEGIN
    report := DBMS_SPM.ADD_VERIFIED_SQL_PLAN_BASELINE(
        SQL_ID=>'9szd5ynmpcg4r'
    );
    DBMS_OUTPUT.PUT_LINE(report);
END;
/

-- PLAN BASELINE 확인
SELECT SQL_HANDLE, PLAN_NAME, SQL_TEXT, ENABLED, ACCEPTED, FIXED, REPRODUCED, AUTOPURGE, ADAPTIVE, ORIGIN, CREATED, LAST_MODIFIED, LAST_EXECUTED, LAST_VERIFIED
  FROM DBA_SQL_PLAN_BASELINES
 WHERE SQL_TEXT LIKE '%/* zzz */%'
   AND SQL_HANDLE = 'SQL_f371c8c1443b184f';
   

-- ADD_VERIFIED_SQL_PLAN_BASELINE REPORT 예시
-- SQL Plan Baselines verified for SQL ID: 9szd5ynmpcg4r
-- ------------------------------------------------------------------------------------------
-- 
-- Plan Hash Value   Plan Name                        Reproduced   Accepted   Source        
-- ---------------   ------------------------------   ----------   --------   --------------
-- 2727377809        SQL_PLAN_g6wf8s523q62g169efe64   YES          YES        CURSOR CACHE  
-- 339492458         SQL_PLAN_g6wf8s523q62g55c864d5   YES          NO         AWR           
-- -----------------------------------------------------------------------------------------
-- 
-- SQL Handle    : SQL_f371c8c1443b184f
-- SQL Text      : select /* zzz */ /*+ USE_NL(t1) LEADING(t2 t1) */ sum(t2.amount)
--   from SCOTT.sales_area1 t1, 
--        SCOTT.sales_area2 t2
--  where t1.sale_code = t2.sale_code
--    and t1.sale_type  = 1
-- -----------------------------------------------------------------------------------------











---------------------------------------------------------------------------------------------------
-- 98. SQL Plan Baseline 관리
---------------------------------------------------------------------------------------------------

-- SQL Management Base SYSAUX 내 스토리지 사용량 확인
SELECT OCCUPANT_DESC, SPACE_USAGE_KBYTES FROM V$SYSAUX_OCCUPANTS WHERE OCCUPANT_NAME='SQL_MANAGEMENT_BASE';

--Configure a retention period for unused baselines (default 53)
dbms_spm.configure('plan_retention_weeks', 53);

--Percentage of space in SYSAUX (default 10)
dbms_spm.configure ('space_budget_percent', 10);
--Alert log: SPM: SMB space usage (99215979) exceeds 10.000000% of SYSAUX size (1018594954).

--Initiate purge manually
DECLARE ret NUMBER;
BEGIN
ret := sys.dbms_spm_internal.auto_purge_sql_plan_baseline;
--DBMS_OUTPUT.PUT_LINE('Number of baselines purged: ' || ret);
END;
--SMB를 통째로 지우는게 아니라, Purge 대상만 삭제함. 
--위 조건에 만족하는 대상들은 자동으로 삭제되나 강제로 즉시 Purge 하고 싶을때 사용.
;

-- IDENTIFYING WHEN BASELINES WHERE LAST USED
SELECT FLOOR(EXTRACT(DAY FROM (SYSDATE - last_executed)) / 7) AS "Weeks Since Last Execute",
       COUNT(*) AS "Num Baselines"
FROM   dba_sql_plan_baselines
WHERE  accepted = 'YES'
AND    autopurge = 'YES'
GROUP BY FLOOR(EXTRACT(DAY FROM (SYSDATE - last_executed)) / 7)
ORDER BY 1;

-- PURGEABLE BASELINE 확인
SELECT count(*) AS " Purgeable Baselines Count"
FROM   dba_sql_plan_baselines
WHERE  autopurge = 'YES'
AND    EXTRACT(DAY FROM (SYSDATE - last_executed)) / 7 >
         (SELECT parameter_value
          FROM   dba_sql_management_config
          WHERE  parameter_name = 'PLAN_RETENTION_WEEKS');











---------------------------------------------------------------------------------------------------
-- 99. 정리 작업
---------------------------------------------------------------------------------------------------

-- Delete sql plan baseline 
DECLARE
  dr PLS_INTEGER;
BEGIN
  dr := DBMS_SPM.DROP_SQL_PLAN_BASELINE(
    sql_handle => 'SQL_403225c7937a2ce6'
--  , plan_name => ''
  );
END;`
/

-- Delete all plans in the baseline
DECLARE
  l_cnt PLS_INTEGER;
BEGIN
  FOR i IN (SELECT DISTINCT plan_name FROM dba_sql_plan_baselines)
  LOOP
    l_cnt := DBMS_SPM.DROP_SQL_PLAN_BASELINE(sql_handle => NULL, plan_name => i.plan_name);
  END LOOP;
END;
/

SELECT * FROM DBA_SQL_PLAN_BASELINES;
 WHERE SQL_TEXT LIKE '%SCOTT.sales_area1 t1%';
 
-- SQL Plan Management (SPM) 관련 파라미터 초기화
ALTER SYSTEM RESET OPTIMIZER_CAPTURE_SQL_PLAN_BASELINES SCOPE=BOTH;
ALTER SYSTEM RESET OPTIMIZER_USE_SQL_PLAN_BASELINES SCOPE=BOTH;
ALTER SYSTEM RESET OPTIMIZER_AUTO_SPM_EVOLVE SCOPE=BOTH; -- 19c default is TRUE
ALTER SYSTEM RESET OPTIMIZER_MODE SCOPE=BOTH;

-- 테스트용 스키마 및 테이블 삭제 (존재할 경우)
DROP USER SCOTT CASCADE;













































-- 여기까지 왔으면 좋은 플랜(HASH)가 ACCEPTED=NO, 나쁜 플랜(NL)이 ACCEPTED=YES 상태임.
-- EVOLVE_SQL_PLAN_BASELINE 함수로 HASH도 ACCEPTED 상태로 만들 수 있으나, 
-- sql tuning advisor이 정해진 MAINTENANCE WINDOW에 EVOLVE를 시킬지 기다려보자. 다음 날 확인
DECLARE
    report clob;
BEGIN
    report := DBMS_SPM.EVOLVE_SQL_PLAN_BASELINE(
        sql_handle=>'SQL_f371c8c1443b184f',
        plan_name=>'SQL_PLAN_g6wf8s523q62g169efe64',
        time_limit=>DBMS_SPM.AUTO_LIMIT,    -- 타임아웃 시간
        verify=>'YES',    -- YES: non-accepted 플랜을 직접 실행/검증. NO: 검증 없음
        commit=>'NO'    -- YES: DBA_SQL_PLAN_BASELINES에서 ACCEPTED=YES로 FLAG 변경. NO: FLAG 변경 없음
    );
    DBMS_OUTPUT.PUT_LINE(report);
END;
/







-- Automatic evolution task 기능 활성화/비활성화
-- SQL Tuning Advisor 와 SPM Evolve Advisor 는 같이 쓰인다. (동일 client 사용)
BEGIN
  DBMS_AUTO_TASK_ADMIN.ENABLE (
    client_name => 'sql tuning advisor'
,   operation   => NULL
,   window_name => NULL
);
END;
/

SELECT CLIENT_NAME, STATUS
FROM   DBA_AUTOTASK_CLIENT
WHERE  CLIENT_NAME = 'sql tuning advisor';




-- SPM Evolve Advisor 설정 변경
SELECT PARAMETER_NAME, PARAMETER_VALUE AS "VALUE"
FROM   DBA_ADVISOR_PARAMETERS
WHERE  TASK_NAME = 'SYS_AUTO_SPM_EVOLVE_TASK'
  AND  ( (PARAMETER_NAME = 'ACCEPT_PLANS') 
   OR    (PARAMETER_NAME = 'TIME_LIMIT') );

BEGIN
    DBMS_SPM.SET_EVOLVE_TASK_PARAMETER(
    task_name => 'SYS_AUTO_SPM_EVOLVE_TASK'
,   parameter => 'ACCEPT_PLANS'
,   value     => 'TRUE'
);
END;
/


-- Automatic Evolution Task Report
DECLARE
    report clob;
BEGIN
    report := DBMS_SPM.REPORT_AUTO_EVOLVE_TASK(type=> 'TEXT');
    DBMS_OUTPUT.PUT_LINE(report);
END;
/

-- 아래는 나쁜 플랜이 baseline에 accepted=yes인 상황에서 더 나은 플랜을 *자동으로* EVOLVE 시도했을 떄
-- 성공한 REPORT_AUTO_EVOLVE_TASK REPORT 예시임
-- 
-- GENERAL INFORMATION SECTION
-- ---------------------------------------------------------------------------------------------
-- 
--  Task Information:                             
--  --------------------------------------------- 
--  Task Name            : SYS_AUTO_SPM_EVOLVE_TASK    
--  Task Owner           : SYS                         
--  Description          : Automatic SPM Evolve Task   
--  Execution Name       : SYS_SPM_2025-06-24/14:18:02 
--  Execution Type       : SPM EVOLVE                  
--  Scope                : COMPREHENSIVE               
--  Status               : COMPLETED                   
--  Started              : 06/24/2025 14:18:02         
--  Finished             : 06/24/2025 14:18:17         
--  Last Updated         : 06/24/2025 14:18:17         
--  Global Time Limit    : 3600                        
--  Per-Plan Time Limit  : UNUSED                      
--  Number of Errors     : 0                           
-- ---------------------------------------------------------------------------------------------
-- 
-- SUMMARY SECTION
-- ---------------------------------------------------------------------------------------------
--   Number of plans processed  : 1  
--   Number of findings         : 3  
--   Number of recommendations  : 1  
--   Number of errors           : 0  
-- ---------------------------------------------------------------------------------------------
-- 
-- DETAILS SECTION
-- ---------------------------------------------------------------------------------------------
--  Object ID          : 21                                                        
--  Test Plan Name     : SQL_PLAN_0nw3nt0u05v95169efe64                            
--  Base Plan Name     : SQL_PLAN_0nw3nt0u05v9555c864d5                            
--  SQL Handle         : SQL_0a7074c83402ed25                                      
--  Parsing Schema     : SCOTT                                                     
--  Test Plan Creator  : SCOTT                                                     
--  SQL Text           : select /* ddd */ /*+ USE_NL(t1) LEADING(t2 t1) */         
--                     sum(t2.amount) from sales_area1 t1, sales_area2 t2 where    
--                     t1.sale_code = t2.sale_code and t1.sale_type = 1            
-- 
-- Execution Statistics:
-- -----------------------------
--                     Base Plan                     Test Plan                    
--                     ----------------------------  ---------------------------- 
--  Elapsed Time (s):  0                             .037786                      
--  CPU Time (s):      0                             .038119                      
--  Buffer Gets:       0                             25771                        
--  Optimizer Cost:    56889611                      7603                         
--  Disk Reads:        0                             0                            
--  Direct Writes:     0                             0                            
--  Rows Processed:    0                             1                            
--  Executions:        0                             10                           
-- 
-- 
-- FINDINGS SECTION
-- ---------------------------------------------------------------------------------------------
-- 
-- Findings (3):
-- -----------------------------
--  1. The plan was verified in 14.76600 seconds. It passed the benefit criterion  
--     because its verified performance was 828.49809 times better than that of    
--     the baseline plan.                                                          
--  2. The plan is adaptive and matches the final executed plan. Implementing the  
--     recommendation will change the plan to static and accepted.                 
--  3. The plan was automatically accepted.                                        
-- 
-- Recommendation:
-- -----------------------------
--  Consider accepting the plan. Execute                                           
--  dbms_spm.accept_sql_plan_baseline(task_name => 'SYS_AUTO_SPM_EVOLVE_TASK',     
--  object_id => 21, task_owner => 'SYS');                                         
-- 
-- 
-- EXPLAIN PLANS SECTION
-- ---------------------------------------------------------------------------------------------
-- 
-- Baseline Plan
-- -----------------------------
--  Plan Id          : 1247       
--  Plan Hash Value  : 1439196373 
-- 
-- --------------------------------------------------------------------------------------------------
-- | Id  | Operation                       | Name        | Rows     | Bytes   | Cost     | Time     |
-- --------------------------------------------------------------------------------------------------
-- |   0 | SELECT STATEMENT                |             |        1 |      33 | 56889611 | 00:37:03 |
-- |   1 |   SORT AGGREGATE                |             |        1 |      33 |          |          |
-- |   2 |    NESTED LOOPS                 |             |    56250 | 1856250 | 56889611 | 00:37:03 |
-- |   3 |     NESTED LOOPS                |             | 56250000 | 1856250 | 56889611 | 00:37:03 |
-- |   4 |      TABLE ACCESS FULL          | SALES_AREA2 |    75000 | 1950000 |     6843 | 00:00:01 |
-- | * 5 |      INDEX RANGE SCAN           | SALES_TYP1I |      750 |         |        8 | 00:00:01 |
-- | * 6 |     TABLE ACCESS BY INDEX ROWID | SALES_AREA1 |        1 |       7 |      758 | 00:00:01 |
-- --------------------------------------------------------------------------------------------------
-- 
-- Predicate Information (identified by operation id):
-- ------------------------------------------
-- * 5 - access("T1"."SALE_TYPE"=1)
-- * 6 - filter("T1"."SALE_CODE"="T2"."SALE_CODE")
-- 
-- Hint Report (identified by operation id / Query Block Name / Object Alias):
-- Total hints for statement: 11 (U - Unused (2))
-- -------------------------------------------------------------------------------
--                                                                                         
--  0 -  STATEMENT                                                                         
--          -  ALL_ROWS                                                                    
--          -  DB_VERSION('19.1.0')                                                        
--          -  IGNORE_OPTIM_EMBEDDED_HINTS                                                 
--          -  OPTIMIZER_FEATURES_ENABLE('19.1.0')                                         
--                                                                                         
--  1 -  SEL$1                                                                             
--        U -  LEADING(t2 t1) / rejected by IGNORE_OPTIM_EMBEDDED_HINTS                    
--          -  LEADING(@"SEL$1" "T2"@"SEL$1" "T1"@"SEL$1")                                 
--                                                                                         
--  4 -  SEL$1 / T2@SEL$1                                                                  
--          -  FULL(@"SEL$1" "T2"@"SEL$1")                                                 
--                                                                                         
--  5 -  SEL$1 / T1@SEL$1                                                                  
--        U -  USE_NL(t1) / rejected by IGNORE_OPTIM_EMBEDDED_HINTS                        
--          -  INDEX(@"SEL$1" "T1"@"SEL$1" ("SALES_AREA1"."SALE_TYPE" "SALES_AREA1"."C"))  
--          -  NLJ_BATCHING(@"SEL$1" "T1"@"SEL$1")                                         
--          -  USE_NL(@"SEL$1" "T1"@"SEL$1")                                               
-- 
-- Test Plan
-- -----------------------------
--  Plan Id          : 1248      
--  Plan Hash Value  : 379518564 
-- 
-- ---------------------------------------------------------------------------------------------------
-- | Id  | Operation                               | Name        | Rows  | Bytes   | Cost | Time     |
-- ---------------------------------------------------------------------------------------------------
-- |   0 | SELECT STATEMENT                        |             |     1 |      33 | 7603 | 00:00:01 |
-- |   1 |   SORT AGGREGATE                        |             |     1 |      33 |      |          |
-- | * 2 |    HASH JOIN                            |             | 56250 | 1856250 | 7603 | 00:00:01 |
-- |   3 |     TABLE ACCESS BY INDEX ROWID BATCHED | SALES_AREA1 |   750 |    5250 |  759 | 00:00:01 |
-- | * 4 |      INDEX RANGE SCAN                   | SALES_TYP1I |   750 |         |    9 | 00:00:01 |
-- |   5 |     TABLE ACCESS FULL                   | SALES_AREA2 | 75000 | 1950000 | 6843 | 00:00:01 |
-- ---------------------------------------------------------------------------------------------------
-- 
-- Predicate Information (identified by operation id):
-- ------------------------------------------
-- * 2 - access("T1"."SALE_CODE"="T2"."SALE_CODE")
-- * 4 - access("T1"."SALE_TYPE"=1)
-- 
-- Hint Report (identified by operation id / Query Block Name / Object Alias):
-- Total hints for statement: 11 (U - Unused (2))
-- -------------------------------------------------------------------------------
--                                                                                                
--  0 -  STATEMENT                                                                                
--          -  ALL_ROWS                                                                           
--          -  DB_VERSION('19.1.0')                                                               
--          -  IGNORE_OPTIM_EMBEDDED_HINTS                                                        
--          -  OPTIMIZER_FEATURES_ENABLE('19.1.0')                                                
--                                                                                                
--  1 -  SEL$1                                                                                    
--        U -  LEADING(t2 t1) / rejected by IGNORE_OPTIM_EMBEDDED_HINTS                           
--          -  LEADING(@"SEL$1" "T1"@"SEL$1" "T2"@"SEL$1")                                        
--                                                                                                
--  3 -  SEL$1 / T1@SEL$1                                                                         
--        U -  USE_NL(t1) / rejected by IGNORE_OPTIM_EMBEDDED_HINTS                               
--          -  BATCH_TABLE_ACCESS_BY_ROWID(@"SEL$1" "T1"@"SEL$1")                                 
--          -  INDEX_RS_ASC(@"SEL$1" "T1"@"SEL$1" ("SALES_AREA1"."SALE_TYPE" "SALES_AREA1"."C"))  
--                                                                                                
--  5 -  SEL$1 / T2@SEL$1                                                                         
--          -  FULL(@"SEL$1" "T2"@"SEL$1")                                                        
--          -  USE_HASH(@"SEL$1" "T2"@"SEL$1")                                                    
-- ---------------------------------------------------------------------------------------------

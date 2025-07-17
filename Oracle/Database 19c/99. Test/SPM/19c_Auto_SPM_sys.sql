/*
	시나리오: 
		1. 테스트 쿼리의 좋은 플랜이 먼저 SQL Baseline Plan으로 등록되어 있다. (Automatic STS Capture로 Baseline 등록함)
			좋은 플랜은 맨 처음 Baseline plan으로 등록됐기 때문에 ACCEPTED='YES' 상태임.
		2. 테스트 쿼리의 나쁜 플랜이 이후 실행돼서 Baseline plan에 등록된다.
			이 때 나쁜 플랜은 ACCEPTED='NO' 상태로 추가됨.
			쿼리 ID가 동일한 PLAN이 Baseline에 2개 있으면 해당 쿼리 실행 시 ACCEPTED='YES' 상태의 플랜을 따라간다.
		
		결론적으로 특정 SQL의 좋은 플랜이 dba_sql_plan_baselines에 기 등록되어 있다면 이후 환경이 바뀌어 나쁜 플랜으로 실행되더라도 
		나쁜 플랜 쿼리가 2번 이상 수행되거나 Auto STS Capture Task JOB으로 인해 dba_sql_plan_baselines에 등록되기만 한다면
		그 SQL은 무조건 ACCEPTED='YES' 상태인 좋은 플랜으로 풀림.
			
		* Baseline plan에 등록된다는 것은 해당 쿼리의 플랜이 DBA_SQL_PLAN_BASELINES에 ENABLED='YES' 상태로 입력된다는 것.
*/



SELECT NAME, VALUE, DEFAULT_VALUE, ISDEFAULT FROM V$PARAMETER WHERE NAME IN (
'optimizer_capture_sql_plan_baselines',
'optimizer_use_sql_plan_baselines'
);

--------------------------------------------------------------------------
-- #00. High Frequency SPM 을 이용하기 위해서는 19.22 RU 이상이어야 함.
--------------------------------------------------------------------------
select banner_full from v$version;

--------------------------------------------------------------------------
-- #01. Auto STS 를 On
--------------------------------------------------------------------------
Begin
    DBMS_Auto_Task_Admin.Enable(
        Client_Name => 'Auto STS Capture Task',
        Operation => NULL,
        Window_name => NULL);
End;
/

--------------------------------------------------------------------------
-- #02. Auto STS Enable 상태 확인
--------------------------------------------------------------------------
select Task_Name, Enabled
from DBA_AutoTask_Schedule_Control
where Task_Name = 'Auto STS Capture Task';

--------------------------------------------------------------------------
-- #03. Enable Auto SPM
--------------------------------------------------------------------------
BEGIN
    dbms_spm.configure('AUTO_SPM_EVOLVE_TASK','ON');
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


-- 자동 캡처를 SCOTT 스키마로 제한
-- BEGIN
    -- DBMS_SPM.CONFIGURE('AUTO_CAPTURE_PARSING_SCHEMA_NAME', 'SCOTT', TRUE);
-- END;
-- /

-- BEGIN
  -- DBMS_SPM.CONFIGURE(
    -- parameter_name  => 'AUTO_CAPTURE_PARSING_SCHEMA_NAME',
    -- parameter_value => NULL,
    -- allow           => TRUE  -- This 'allow' parameter becomes irrelevant when parameter_value is NULL
  -- );
-- END;
/

--------------------------------------------------------------------------
-- #04. Auto SPM Enable 상태 확인
--------------------------------------------------------------------------
select PARAMETER_NAME, PARAMETER_VALUE
from   DBA_SQL_MANAGEMENT_CONFIG
where  parameter_name IN ('AUTO_SPM_EVOLVE_TASK', 'AUTO_CAPTURE_PARSING_SCHEMA_NAME');

--------------------------------------------------------------------------
-- #05. Auto SPM 관련 파라메터 확인
--------------------------------------------------------------------------
select owner, task_name, parameter_name, parameter_value
from DBA_ADVISOR_PARAMETERS
where task_name = 'SYS_AUTO_SPM_EVOLVE_TASK'
  and parameter_value != 'UNUSED'
order by task_name, parameter_name;

--------------------------------------------------------------------------
-- #08. Auto STS 캡쳐 간격을 900초(15분) -> 120초(2분) 으로 변경 (빠른 테스트를 위해서)
--------------------------------------------------------------------------
begin
    dbms_auto_task_admin.modify_autotask_setting('Auto STS Capture Task', 'INTERVAL', 120);
end;
/


--------------------------------------------------------------------------
-- #09. Auto STS 캡쳐가 이루어질때까지 루핑돌면서 기다린다. (상태: RUNNING -> SUCCEEDED)
--------------------------------------------------------------------------
declare
    lasttime timestamp ;
    thistime timestamp ;
    executed boolean := false;
    sts varchar2(20);
    n number := 0;
    cursor c1 is
        select last_schedule_time, status
        into   thistime, sts
        from   dba_autotask_schedule_control 
        where  dbid = sys_context('userenv','con_dbid')
        and    task_name = 'Auto STS Capture Task';
begin
    open c1;
    fetch c1 into lasttime, sts;
    close c1;
    while not executed
    loop 
        open c1;
        fetch c1 into thistime, sts;
        close c1;
        if thistime>lasttime and sts = 'SUCCEEDED' and n > 0
        then
            executed := true;
        else
            dbms_lock.sleep(2);
        end if;
        n := n + 1;
    end loop;
end;
/


--------------------------------------------------------------------------
-- #10. Auto STS 캡쳐 간격을 원복 120초(2분) -> 900초(15분)
--------------------------------------------------------------------------
begin
    dbms_auto_task_admin.modify_autotask_setting('Auto STS Capture Task', 'INTERVAL', 900);
end;
/

--------------------------------------------------------------------------
-- #11. Auto STS 캡쳐 작업이 잘 끝났는지 확인
--------------------------------------------------------------------------
select task_name, interval, status, last_schedule_time, systimestamp-last_schedule_time ago
from  dba_autotask_schedule_control 
where dbid = sys_context('userenv','con_dbid')
and   task_name = 'Auto STS Capture Task';

SELECT * FROM DBA_SCHEDULER_JOB_LOG WHERE JOB_NAME = 'ORA$_ATSK_AUTOSTS' ORDER BY LOG_DATE DESC;
SELECT * FROM DBA_SCHEDULER_JOB_RUN_DETAILS WHERE JOB_NAME = 'ORA$_ATSK_AUTOSTS';
SELECT * FROM DBA_SCHEDULER_JOBS WHERE JOB_NAME = 'ORA$_ATSK_AUTOSTS';



--------------------------------------------------------------------------
-- #12. Auto STS 에 Test 쿼리가 잘 캡쳐되었는지 확인
--------------------------------------------------------------------------
select substr(sql_text,1,50) txt,
       executions,decode(executions,0,-1,round(buffer_gets/executions)) bget_per_exec,
       plan_hash_value
from dba_sqlset_statements 
where sqlset_name = 'SYS_AUTO_STS' 
and sql_text like 'select /* ddd */%';


--------------------------------------------------------------------------
-- #14. baseline 이 등록되었는지 확인
--------------------------------------------------------------------------
SELECT sql_handle, plan_name, enabled, accepted, fixed, origin, sql_text
FROM dba_sql_plan_baselines
WHERE sql_text like 'select /* ddd */%'
  and parsing_schema_name not in ('SYS');

   ---> !!! 여기에서 1시간 정도 기다려야 함. !!!



--------------------------------------------------------------------------
-- #16. v$sql 뷰에서 Test SQL 이 baseline 을 사용하는지 확인할 수 있음.
--------------------------------------------------------------------------
select plan_hash_value,child_number, sql_plan_baseline
from  v$sql 
where sql_text like 'select /* ddd */%'
and   sql_plan_baseline is not null;






-- 기타 확인 쿼리들
SELECT * FROM DBA_AUTOTASK_CLIENT;
SELECT * FROM DBA_AUTOTASK_SCHEDULE_CONTROL;
SELECT * FROM DBA_SQL_MANAGEMENT_CONFIG;
where  parameter_name IN ('AUTO_SPM_EVOLVE_TASK', 'AUTO_CAPTURE_PARSING_SCHEMA_NAME');

SELECT * FROM DBA_SCHEDULER_JOBS;
SELECT * FROM DBA_SCHEDULER_JOB_CLASSES;
SELECT * FROM DBA_AUTOTASK_CLIENT_HISTORY;
SELECT * FROM DBA_AUTOTASK_JOB_HISTORY;
SELECT * FROM DBA_AUTOTASK_OPERATION;
SELECT * FROM DBA_AUTOTASK_SCHEDULE;
SELECT * FROM DBA_AUTOTASK_TASK;
SELECT * FROM DBA_AUTOTASK_WINDOW_CLIENTS;
SELECT * FROM DBA_AUTOTASK_WINDOW_HISTORY;

SELECT * FROM DBA_AUTOTASK
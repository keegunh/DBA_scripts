/*
	�ó�����: 
		1. �׽�Ʈ ������ ���� �÷��� ���� SQL Baseline Plan���� ��ϵǾ� �ִ�. (Automatic STS Capture�� Baseline �����)
			���� �÷��� �� ó�� Baseline plan���� ��ϵƱ� ������ ACCEPTED='YES' ������.
		2. �׽�Ʈ ������ ���� �÷��� ���� ����ż� Baseline plan�� ��ϵȴ�.
			�� �� ���� �÷��� ACCEPTED='NO' ���·� �߰���.
			���� ID�� ������ PLAN�� Baseline�� 2�� ������ �ش� ���� ���� �� ACCEPTED='YES' ������ �÷��� ���󰣴�.
		
		��������� Ư�� SQL�� ���� �÷��� dba_sql_plan_baselines�� �� ��ϵǾ� �ִٸ� ���� ȯ���� �ٲ�� ���� �÷����� ����Ǵ��� 
		���� �÷� ������ 2�� �̻� ����ǰų� Auto STS Capture Task JOB���� ���� dba_sql_plan_baselines�� ��ϵǱ⸸ �Ѵٸ�
		�� SQL�� ������ ACCEPTED='YES' ������ ���� �÷����� Ǯ��.
			
		* Baseline plan�� ��ϵȴٴ� ���� �ش� ������ �÷��� DBA_SQL_PLAN_BASELINES�� ENABLED='YES' ���·� �Էµȴٴ� ��.
*/



SELECT NAME, VALUE, DEFAULT_VALUE, ISDEFAULT FROM V$PARAMETER WHERE NAME IN (
'optimizer_capture_sql_plan_baselines',
'optimizer_use_sql_plan_baselines'
);

--------------------------------------------------------------------------
-- #00. High Frequency SPM �� �̿��ϱ� ���ؼ��� 19.22 RU �̻��̾�� ��.
--------------------------------------------------------------------------
select banner_full from v$version;

--------------------------------------------------------------------------
-- #01. Auto STS �� On
--------------------------------------------------------------------------
Begin
    DBMS_Auto_Task_Admin.Enable(
        Client_Name => 'Auto STS Capture Task',
        Operation => NULL,
        Window_name => NULL);
End;
/

--------------------------------------------------------------------------
-- #02. Auto STS Enable ���� Ȯ��
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


-- �ڵ� ĸó�� SCOTT ��Ű���� ����
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
-- #04. Auto SPM Enable ���� Ȯ��
--------------------------------------------------------------------------
select PARAMETER_NAME, PARAMETER_VALUE
from   DBA_SQL_MANAGEMENT_CONFIG
where  parameter_name IN ('AUTO_SPM_EVOLVE_TASK', 'AUTO_CAPTURE_PARSING_SCHEMA_NAME');

--------------------------------------------------------------------------
-- #05. Auto SPM ���� �Ķ���� Ȯ��
--------------------------------------------------------------------------
select owner, task_name, parameter_name, parameter_value
from DBA_ADVISOR_PARAMETERS
where task_name = 'SYS_AUTO_SPM_EVOLVE_TASK'
  and parameter_value != 'UNUSED'
order by task_name, parameter_name;

--------------------------------------------------------------------------
-- #08. Auto STS ĸ�� ������ 900��(15��) -> 120��(2��) ���� ���� (���� �׽�Ʈ�� ���ؼ�)
--------------------------------------------------------------------------
begin
    dbms_auto_task_admin.modify_autotask_setting('Auto STS Capture Task', 'INTERVAL', 120);
end;
/


--------------------------------------------------------------------------
-- #09. Auto STS ĸ�İ� �̷���������� ���ε��鼭 ��ٸ���. (����: RUNNING -> SUCCEEDED)
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
-- #10. Auto STS ĸ�� ������ ���� 120��(2��) -> 900��(15��)
--------------------------------------------------------------------------
begin
    dbms_auto_task_admin.modify_autotask_setting('Auto STS Capture Task', 'INTERVAL', 900);
end;
/

--------------------------------------------------------------------------
-- #11. Auto STS ĸ�� �۾��� �� �������� Ȯ��
--------------------------------------------------------------------------
select task_name, interval, status, last_schedule_time, systimestamp-last_schedule_time ago
from  dba_autotask_schedule_control 
where dbid = sys_context('userenv','con_dbid')
and   task_name = 'Auto STS Capture Task';

SELECT * FROM DBA_SCHEDULER_JOB_LOG WHERE JOB_NAME = 'ORA$_ATSK_AUTOSTS' ORDER BY LOG_DATE DESC;
SELECT * FROM DBA_SCHEDULER_JOB_RUN_DETAILS WHERE JOB_NAME = 'ORA$_ATSK_AUTOSTS';
SELECT * FROM DBA_SCHEDULER_JOBS WHERE JOB_NAME = 'ORA$_ATSK_AUTOSTS';



--------------------------------------------------------------------------
-- #12. Auto STS �� Test ������ �� ĸ�ĵǾ����� Ȯ��
--------------------------------------------------------------------------
select substr(sql_text,1,50) txt,
       executions,decode(executions,0,-1,round(buffer_gets/executions)) bget_per_exec,
       plan_hash_value
from dba_sqlset_statements 
where sqlset_name = 'SYS_AUTO_STS' 
and sql_text like 'select /* ddd */%';


--------------------------------------------------------------------------
-- #14. baseline �� ��ϵǾ����� Ȯ��
--------------------------------------------------------------------------
SELECT sql_handle, plan_name, enabled, accepted, fixed, origin, sql_text
FROM dba_sql_plan_baselines
WHERE sql_text like 'select /* ddd */%'
  and parsing_schema_name not in ('SYS');

   ---> !!! ���⿡�� 1�ð� ���� ��ٷ��� ��. !!!



--------------------------------------------------------------------------
-- #16. v$sql �信�� Test SQL �� baseline �� ����ϴ��� Ȯ���� �� ����.
--------------------------------------------------------------------------
select plan_hash_value,child_number, sql_plan_baseline
from  v$sql 
where sql_text like 'select /* ddd */%'
and   sql_plan_baseline is not null;






-- ��Ÿ Ȯ�� ������
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
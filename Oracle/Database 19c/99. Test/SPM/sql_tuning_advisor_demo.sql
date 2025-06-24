----------------------------------------------------------------------------------
-- Analyzing SQL with SQL Tuning Advisor
-- https://docs.oracle.com/database/121/TGSQL/tgsql_sqltune.htm#TGSQL540
----------------------------------------------------------------------------------

-- SQL Tuning Advisor Packages 는 2가지로 구성
-- - DBMS_AUTO_SQLTUNE		: SQL Tuning Advisor 실행, SQL Profile 관리, STS 관리 시 사용
-- - DBMS_AUTO_TASK_ADMIN	: Automatic SQL Tuning Task 활성화/비활성화 시 사용


-- # 1. Managing the Automatic SQL Tuning Task

-- To enable or disable Automatic SQL Tuning using DBMS_AUTO_TASK_ADMIN:
BEGIN
  DBMS_AUTO_TASK_ADMIN.ENABLE (
    client_name => 'sql tuning advisor'
,   operation   => NULL
,   window_name => NULL
);
END;
/

BEGIN
  DBMS_AUTO_TASK_ADMIN.DISABLE (
    client_name => 'sql tuning advisor'
,   operation   => NULL
,   window_name => NULL
);
END;
/

SELECT CLIENT_NAME, STATUS
FROM   DBA_AUTOTASK_CLIENT
WHERE  CLIENT_NAME = 'sql tuning advisor';





-- To disable collection of all advisories and statistics:
ALTER SYSTEM SET STATISTICS_LEVEL ='BASIC';	--DISABLE
ALTER SYSTEM SET STATISTICS_LEVEL ='ALL';	--ENABLE
SHOW PARAMETER STATISTICS_LEVEL



-- To set Automatic SQL Tuning task parameters:

SELECT PARAMETER_NAME, PARAMETER_VALUE AS "VALUE"
FROM   DBA_ADVISOR_PARAMETERS
WHERE  ( (TASK_NAME = 'SYS_AUTO_SQL_TUNING_TASK') AND
         ( (PARAMETER_NAME LIKE '%PROFILE%') OR 
           (PARAMETER_NAME = 'LOCAL_TIME_LIMIT') OR
           (PARAMETER_NAME = 'EXECUTION_DAYS_TO_EXPIRE') ) );

/*
PARAMETER_NAME            VALUE
------------------------- ----------
EXECUTION_DAYS_TO_EXPIRE  30
LOCAL_TIME_LIMIT          1000
ACCEPT_SQL_PROFILES       FALSE
MAX_SQL_PROFILES_PER_EXEC 20
MAX_AUTO_SQL_PROFILES     10000
*/

BEGIN
  DBMS_SQLTUNE.SET_TUNING_TASK_PARAMETER (
    task_name => 'SYS_AUTO_SQL_TUNING_TASK'
,   parameter => parameter_name
,   value     => value
);
END;
/

BEGIN
  DBMS_SQLTUNE.SET_TUNING_TASK_PARAMETER('SYS_AUTO_SQL_TUNING_TASK',
    'LOCAL_TIME_LIMIT', 1200);
  DBMS_SQLTUNE.SET_TUNING_TASK_PARAMETER('SYS_AUTO_SQL_TUNING_TASK',
    'ACCEPT_SQL_PROFILES', 'true');
  DBMS_SQLTUNE.SET_TUNING_TASK_PARAMETER('SYS_AUTO_SQL_TUNING_TASK',
    'MAX_SQL_PROFILES_PER_EXEC', 50);
  DBMS_SQLTUNE.SET_TUNING_TASK_PARAMETER('SYS_AUTO_SQL_TUNING_TASK',
    'MAX_AUTO_SQL_PROFILES', 10002);
END;
/


-- To create and access an Automatic SQL Tuning Advisor report:

VARIABLE my_rept CLOB;
BEGIN
  :my_rept :=DBMS_SQLTUNE.REPORT_AUTO_TUNING_TASK (
    begin_exec   => NULL
,   end_exec     => NULL
,   type         => 'TEXT'
,   level        => 'TYPICAL'
,   section      => 'ALL'
,   object_id    => NULL
,   result_limit => NULL
);
END;
/

PRINT :my_rept




-- # 2. Running SQL Tuning Advisor On Demand

-- Create SQL Tuning Task
DECLARE
  my_task_name VARCHAR2(30);
  my_sqltext   CLOB;
BEGIN
  my_sqltext := 'SELECT /*+ ORDERED */ * '                      ||
                'FROM employees e, locations l, departments d ' ||
                'WHERE e.department_id = d.department_id AND '  ||
                      'l.location_id = d.location_id AND '      ||
                      'e.employee_id < :bnd';

  my_task_name := DBMS_SQLTUNE.CREATE_TUNING_TASK (
          sql_text    => my_sqltext
,         bind_list   => sql_binds(anydata.ConvertNumber(100))
,         user_name   => 'HR'
,         scope       => 'COMPREHENSIVE'
,         time_limit  => 60
,         task_name   => 'STA_SPECIFIC_EMP_TASK'
,         description => 'Task to tune a query on a specified employee'
);
END;
/

SELECT TASK_ID, TASK_NAME, STATUS, STATUS_MESSAGE
  FROM DBA_ADVISOR_LOG
 WHERE TASK_NAME = 'STA_SPECIFIC_EMP_TASK';
 
 

-- Configure SQL Tuning Task
BEGIN
  DBMS_SQLTUNE.SET_TUNING_TASK_PARAMETER (
    task_name => 'STA_SPECIFIC_EMP_TASK'
,   parameter => 'TIME_LIMIT'
,   value     => 300
);
END;
/

SELECT PARAMETER_NAME, PARAMETER_VALUE AS "VALUE"
FROM   USER_ADVISOR_PARAMETERS
WHERE  TASK_NAME = 'STA_SPECIFIC_EMP_TASK'
AND    PARAMETER_VALUE != 'UNUSED'
ORDER BY PARAMETER_NAME;



-- Execute a Tuning Task
BEGIN
  DBMS_SQLTUNE.EXECUTE_TUNING_TASK(task_name=>'STA_SPECIFIC_EMP_TASK');
END;
/

SELECT TASK_ID, TASK_NAME, STATUS, STATUS_MESSAGE
  FROM DBA_ADVISOR_LOG
 WHERE TASK_NAME = 'STA_SPECIFIC_EMP_TASK';
 
 
 
-- To monitor a SQL tuning task:
SELECT TASK_ID, TASK_NAME, STATUS 
FROM   USER_ADVISOR_TASKS
WHERE  TASK_NAME = 'STA_SPECIFIC_EMP_TASK';

SELECT TASK_ID, ADVISOR_NAME, SOFAR, TOTALWORK, 
       ROUND(SOFAR/TOTALWORK*100,2) "%_COMPLETE"
FROM   V$ADVISOR_PROGRESS
WHERE  TASK_ID = :my_tid;




-- Displaying the Results of a SQL Tuning Task
SELECT DBMS_SQLTUNE.REPORT_TUNING_TASK( 'STA_SPECIFIC_EMP_TASK' )
FROM   DUAL;



GENERAL INFORMATION SECTION
-------------------------------------------------------------------------------
Tuning Task Name   : STA_SPECIFIC_EMP_TASK
Tuning Task Owner  : SCOTT
Workload Type      : Single SQL Statement
Scope              : COMPREHENSIVE
Time Limit(seconds): 300
Completion Status  : COMPLETED
Started at         : 06/10/2025 14:28:33
Completed at       : 06/10/2025 14:28:34

-------------------------------------------------------------------------------
Schema Name: HR
SQL ID     : fzf61z52zh4sk
SQL Text   : SELECT /*+ ORDERED */ * FROM employees e, locations l,
             departments d WHERE e.department_id = d.department_id AND
             l.location_id = d.location_id AND e.employee_id < :bnd
Bind Variables :
 1 -  (NUMBER):100

-------------------------------------------------------------------------------
FINDINGS SECTION (1 finding)
-------------------------------------------------------------------------------

1- Restructure SQL finding (see plan 1 in explain plans section)
----------------------------------------------------------------
  An expensive cartesian product operation was found at line ID 2 of the
  execution plan.

  Recommendation
  --------------
  - Consider removing the "ORDERED" hint.

-------------------------------------------------------------------------------
EXPLAIN PLANS SECTION
-------------------------------------------------------------------------------

1- Original
-----------
Plan hash value: 4162796140

-------------------------------------------------------------------------------------------------------
| Id  | Operation                             | Name          | Rows  | Bytes | Cost (%CPU)| Time     |
-------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                      |               |     1 |   139 |     8   (0)| 00:00:01 |
|*  1 |  HASH JOIN                            |               |     1 |   139 |     8   (0)| 00:00:01 |
|   2 |   MERGE JOIN CARTESIAN                |               |    23 |  2714 |     5   (0)| 00:00:01 |
|   3 |    TABLE ACCESS BY INDEX ROWID BATCHED| EMPLOYEES     |     1 |    69 |     2   (0)| 00:00:01 |
|*  4 |     INDEX RANGE SCAN                  | EMP_EMP_ID_PK |     1 |       |     1   (0)| 00:00:01 |
|   5 |    BUFFER SORT                        |               |    23 |  1127 |     3   (0)| 00:00:01 |
|   6 |     TABLE ACCESS FULL                 | LOCATIONS     |    23 |  1127 |     3   (0)| 00:00:01 |
|   7 |   TABLE ACCESS FULL                   | DEPARTMENTS   |    27 |   567 |     3   (0)| 00:00:01 |
-------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("E"."DEPARTMENT_ID"="D"."DEPARTMENT_ID" AND "L"."LOCATION_ID"="D"."LOCATION_ID")
   4 - access("E"."EMPLOYEE_ID"<:BND)

-------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- SQL PLAN이 변경됐을 때 이전 PLAN으로 되돌리는 방법 (SPM 기능 사용)
---------------------------------------------------------------------------------------------------



-- 방법1: 사용하려는 예전 plan이 baseline에 있는 경우 사용
-- Baseline에 있는 다른(신규) plan을 fix 및 evolve하고 기존 사용되고 있는 plan을 baseline에서 disable한다.
SELECT sql_handle, plan_name, enabled, accepted, fixed, created, last_modified, last_executed, origin
     , 'SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_SQL_PLAN_BASELINE(''' || sql_handle || ''', ''' || plan_name || ''', ''OUTLINE''));' AS view_plan
     , 'DECLARE A_RETURN PLS_INTEGER;' || CHR(13) || 'BEGIN' || CHR(13) || '    A_RETURN := DBMS_SPM.ALTER_SQL_PLAN_BASELINE(sql_handle=>'''|| sql_handle || ''', plan_name=>''' || plan_name || ''', attribute_name=>''ENABLED'', attribute_value=>''YES'');' || CHR(13) || 'END;' AS enable_plan
     , 'DECLARE A_RETURN PLS_INTEGER;' || CHR(13) || 'BEGIN' || CHR(13) || '    A_RETURN := DBMS_SPM.ALTER_SQL_PLAN_BASELINE(sql_handle=>''' || sql_handle || ''', plan_name=>''' || plan_name || ''', attribute_name=>''ENABLED'', attribute_value=>''NO'');' || CHR(13) || 'END;' AS disable_plan
     , 'DECLARE A_RETURN PLS_INTEGER;' || CHR(13) || 'BEGIN' || CHR(13) || '    A_RETURN := DBMS_SPM.ALTER_SQL_PLAN_BASELINE(sql_handle=>''' || sql_handle || ''', plan_name=>''' || plan_name || ''', attribute_name=>''FIXED'', attribute_value=>''YES'');' || CHR(13) || 'END;' AS fix_plan
     , 'DECLARE A_RETURN PLS_INTEGER;' || CHR(13) || 'BEGIN' || CHR(13) || '    A_RETURN := DBMS_SPM.ALTER_SQL_PLAN_BASELINE(sql_handle=>''' || sql_handle || ''', plan_name=>''' || plan_name || ''', attribute_name=>''FIXED'', attribute_value=>''NO'');' || CHR(13) || 'END;' AS unfix_plan
     , 'DECLARE REPORT CLOB;' || CHR(13) || 'BEGIN' || CHR(13) || '    REPORT := DBMS_SPM.EVOLVE_SQL_PLAN_BASELINE(sql_handle=>''' || sql_handle || ''', plan_name=>''' || plan_name || ''', time_limit=>DBMS_SPM.AUTO_LIMIT, verify=>''YES'', COMMIT=>''YES'');' || CHR(13) || '    DBMS_OUTPUT.PUT_LINE(REPORT);' || CHR(13) || 'END;' AS evolve_plan
     -- , 'DECLARE A_RETURN PLS_INTEGER;' || CHR(13) || 'BEGIN' || CHR(13) || '    A_RETURN := DBMS_SPM.DROP_SQL_PLAN_BASELINE(sql_handle=>''' || sql_handle || ''', plan_name=>''' || plan_name || ''');' || CHR(13) || 'END;' AS drop_plan
  FROM dba_sql_plan_baselines
 WHERE 1=1
   -- AND sql_handle = ''
   -- AND plan_name = ''	-- v$sql.sql_plan_baseline
   AND sql_text LIKE '%%'
 ORDER BY created DESC;


-- 방법2: 사용하려는 예전 plan이 baseline에 없는 경우 사용
-- 오라클이 Cursor Cache, Auto STS, AWR을 탐색하여 해당 SQL_ID의 plan들을 ENABLED='YES', ACCEPTED='NO' 상태로 baseline에 적재하고
-- 내부적으로 SPM evolve advisor를 사용해서 가장 좋은 plan을 baseline에서 evolve 시킨다.
-- 필요 시 이전 plan을 disable 한다.
-- https://docs.oracle.com/en/database/oracle/oracle-database/19/arpls/DBMS_SPM.html#GUID-3B5BEFD9-DBF2-490C-A8D6-2295CC3B8AD9
SELECT sql_id, child_number, executions, elapsed_time, buffer_gets, last_active_time, sql_plan_baseline, sql_text
     , 'SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(''' || sql_id || ''', ' || child_number || ', ''ALLSTATS LAST ALL +OUTLINE''));' AS view_plan
     , 'DECLARE REPORT CLOB;' || CHR(13) || 'BEGIN' || CHR(13) || '    REPORT := DBMS_SPM.ADD_VERIFIED_SQL_PLAN_BASELINE(sql_id=>''' || sql_id || ''');' || CHR(13) || 'DBMS_OUTPUT.PUT_LINE(REPORT);' || CHR(13) || 'END;' AS add_verified_plan
     -- , 'DECLARE A_RETURN PLS_INTEGER;' || CHR(13) || 'BEGIN' || CHR(13) || '    A_RETURN := DBMS_SPM.LOAD_PLANS_FROM_CURSOR_CACHE(sql_id=>''' || sql_id || ''', plan_hash_value=>' || plan_hash_value || ', fixed=>''YES'', enabled=>''YES'');' || CHR(13) || 'END;' AS cc_load_plan
  FROM v$sql
 WHERE 1=1
   -- AND sql_id = ''
   AND sql_text LIKE '%%'
 ORDER BY last_active_time DESC;

-- ADD_VERIFIED_SQL_PLAN_BASELINE REPORT 예시
--		 SQL Plan Baselines verified for SQL ID: 9szd5ynmpcg4r
--		 ------------------------------------------------------------------------------------------
--		 
--		 Plan Hash Value   Plan Name                        Reproduced   Accepted   Source        
--		 ---------------   ------------------------------   ----------   --------   --------------
--		 2727377809        SQL_PLAN_g6wf8s523q62g169efe64   YES          YES        CURSOR CACHE  
--		 339492458         SQL_PLAN_g6wf8s523q62g55c864d5   YES          NO         AWR           
--		 -----------------------------------------------------------------------------------------
--		 
--		 SQL Handle    : SQL_f371c8c1443b184f
--		 SQL Text      : select /* zzz */ /*+ USE_NL(t1) LEADING(t2 t1) */ sum(t2.amount)
--		   from SCOTT.sales_area1 t1, 
--		        SCOTT.sales_area2 t2
--		  where t1.sale_code = t2.sale_code
--		    and t1.sale_type  = 1
--		 -----------------------------------------------------------------------------------------




 
-- 방법3: 사용하려는 예전 plan이 baseline에 없는 경우 사용
-- Cursor Cache에서 과거 plan을 확인 후 baseline에 enabled='YES', fixed='YES' 상태로 적재한다.
-- 적재가 완료되면 해당 plan을 evolve 시킨다.
-- 필요 시 이전 plan을 disable 한다.
SELECT sql_id, child_number, executions, elapsed_time, buffer_gets, last_active_time, sql_plan_baseline, sql_text
     , 'SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(''' || sql_id || ''', ' || child_number || ', ''ALLSTATS LAST ALL +OUTLINE''));' AS view_plan
     -- , 'DECLARE REPORT CLOB;' || CHR(13) || 'BEGIN' || CHR(13) || '    REPORT := DBMS_SPM.ADD_VERIFIED_SQL_PLAN_BASELINE(sql_id=>''' || sql_id || ''');' || CHR(13) || 'DBMS_OUTPUT.PUT_LINE(REPORT);' || CHR(13) || 'END;' AS add_verified_plan
     , 'DECLARE A_RETURN PLS_INTEGER;' || CHR(13) || 'BEGIN' || CHR(13) || '    A_RETURN := DBMS_SPM.LOAD_PLANS_FROM_CURSOR_CACHE(sql_id=>''' || sql_id || ''', plan_hash_value=>' || plan_hash_value || ', fixed=>''YES'', enabled=>''YES'');' || CHR(13) || 'END;' AS cc_load_plan
  FROM v$sql
 WHERE 1=1
   -- AND sql_id = ''
   AND sql_text LIKE '%%'
 ORDER BY last_active_time DESC;

SELECT sql_handle, plan_name, enabled, accepted, fixed, created, last_modified, last_executed, origin
     , 'SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_SQL_PLAN_BASELINE(''' || sql_handle || ''', ''' || plan_name || ''', ''OUTLINE''));' AS view_plan
     -- , 'DECLARE A_RETURN PLS_INTEGER;' || CHR(13) || 'BEGIN' || CHR(13) || '    A_RETURN := DBMS_SPM.ALTER_SQL_PLAN_BASELINE(sql_handle=>'''|| sql_handle || ''', plan_name=>''' || plan_name || ''', attribute_name=>''ENABLED'', attribute_value=>''YES'');' || CHR(13) || 'END;' AS enable_plan
     -- , 'DECLARE A_RETURN PLS_INTEGER;' || CHR(13) || 'BEGIN' || CHR(13) || '    A_RETURN := DBMS_SPM.ALTER_SQL_PLAN_BASELINE(sql_handle=>''' || sql_handle || ''', plan_name=>''' || plan_name || ''', attribute_name=>''ENABLED'', attribute_value=>''NO'');' || CHR(13) || 'END;' AS disable_plan
     -- , 'DECLARE A_RETURN PLS_INTEGER;' || CHR(13) || 'BEGIN' || CHR(13) || '    A_RETURN := DBMS_SPM.ALTER_SQL_PLAN_BASELINE(sql_handle=>''' || sql_handle || ''', plan_name=>''' || plan_name || ''', attribute_name=>''FIXED'', attribute_value=>''YES'');' || CHR(13) || 'END;' AS fix_plan
     -- , 'DECLARE A_RETURN PLS_INTEGER;' || CHR(13) || 'BEGIN' || CHR(13) || '    A_RETURN := DBMS_SPM.ALTER_SQL_PLAN_BASELINE(sql_handle=>''' || sql_handle || ''', plan_name=>''' || plan_name || ''', attribute_name=>''FIXED'', attribute_value=>''NO'');' || CHR(13) || 'END;' AS unfix_plan
     , 'DECLARE REPORT CLOB;' || CHR(13) || 'BEGIN' || CHR(13) || '    REPORT := DBMS_SPM.EVOLVE_SQL_PLAN_BASELINE(sql_handle=>''' || sql_handle || ''', plan_name=>''' || plan_name || ''', time_limit=>DBMS_SPM.AUTO_LIMIT, verify=>''YES'', COMMIT=>''YES'');' || CHR(13) || '    DBMS_OUTPUT.PUT_LINE(REPORT);' || CHR(13) || 'END;' AS evolve_plan
     -- , 'DECLARE A_RETURN PLS_INTEGER;' || CHR(13) || 'BEGIN' || CHR(13) || '    A_RETURN := DBMS_SPM.DROP_SQL_PLAN_BASELINE(sql_handle=>''' || sql_handle || ''', plan_name=>''' || plan_name || ''');' || CHR(13) || 'END;' AS drop_plan
  FROM dba_sql_plan_baselines
 WHERE 1=1
   -- AND sql_handle = ''
   -- AND plan_name = ''	-- v$sql.sql_plan_baseline
   AND sql_text LIKE '%%'
 ORDER BY created DESC;
 

-- DBMS_SPM.EVOLVE_SQL_PLAN_BASELINE 예시
--     DECLARE
--         report clob;
--     BEGIN
--         report := DBMS_SPM.EVOLVE_SQL_PLAN_BASELINE(
--             sql_handle=>'SQL_f371c8c1443b184f',
--             plan_name=>'SQL_PLAN_g6wf8s523q62g55c864d5',
--             time_limit=>DBMS_SPM.AUTO_LIMIT,    -- 타임아웃 시간
--             verify=>'YES',    -- YES: non-accepted 플랜을 직접 실행/검증. NO: 검증 없음
--             commit=>'YES'    -- YES: DBA_SQL_PLAN_BASELINES에서 ACCEPTED=YES로 FLAG 변경. NO: FLAG 변경 없음
--         );
--         DBMS_OUTPUT.PUT_LINE(report);
--     END;
--     /

-- 아래는 나쁜 플랜이 baseline에 accepted=yes인 상황에서 더 나은 플랜을 수동 EVOLVE 시도했을 떄 성공한 EVOLVE_SQL_PLAN_BASELINE REPORT 예시임
--     GENERAL INFORMATION SECTION
--     ---------------------------------------------------------------------------------------------
--     
--      Task Information:                             
--      --------------------------------------------- 
--      Task Name            : TASK_306            
--      Task Owner           : SYSTEM              
--      Execution Name       : EXEC_346            
--      Execution Type       : SPM EVOLVE          
--      Scope                : COMPREHENSIVE       
--      Status               : COMPLETED           
--      Started              : 06/23/2025 16:45:39 
--      Finished             : 06/23/2025 16:45:55 
--      Last Updated         : 06/23/2025 16:45:55 
--      Global Time Limit    : 2147483646          
--      Per-Plan Time Limit  : UNUSED              
--      Number of Errors     : 0                   
--     ---------------------------------------------------------------------------------------------
--     
--     SUMMARY SECTION
--     ---------------------------------------------------------------------------------------------
--       Number of plans processed  : 1  
--       Number of findings         : 2  
--       Number of recommendations  : 1  
--       Number of errors           : 0  
--     ---------------------------------------------------------------------------------------------
--     
--     DETAILS SECTION
--     ---------------------------------------------------------------------------------------------
--      Object ID          : 2                                                         
--      Test Plan Name     : SQL_PLAN_g6wf8s523q62g169efe64                            
--      Base Plan Name     : SQL_PLAN_g6wf8s523q62g55c864d5                            
--      SQL Handle         : SQL_f371c8c1443b184f                                      
--      Parsing Schema     : SYSTEM                                                    
--      Test Plan Creator  : SYSTEM                                                    
--      SQL Text           : select /* zzz */ /*+ USE_NL(t1) LEADING(t2 t1) */         
--                         sum(t2.amount) from SCOTT.sales_area1 t1, SCOTT.sales_area2 
--                         t2 where t1.sale_code = t2.sale_code and t1.sale_type = 1   
--     
--     Execution Statistics:
--     -----------------------------
--                         Base Plan                     Test Plan                    
--                         ----------------------------  ---------------------------- 
--      Elapsed Time (s):  0                             .026573                      
--      CPU Time (s):      0                             .025973                      
--      Buffer Gets:       0                             25771                        
--      Optimizer Cost:    56889611                      7603                         
--      Disk Reads:        0                             0                            
--      Direct Writes:     0                             0                            
--      Rows Processed:    0                             1                            
--      Executions:        0                             10                           
--     
--     
--     FINDINGS SECTION
--     ---------------------------------------------------------------------------------------------
--     
--     Findings (2):
--     -----------------------------
--      1. The plan was verified in 15.68700 seconds. It passed the benefit criterion  
--         because its verified performance was 1288.36128 times better than that of   
--         the baseline plan.                                                          
--      2. The plan is adaptive and matches the final executed plan. Implementing the  
--         recommendation will change the plan to static and accepted.                 
--     
--     Recommendation:
--     -----------------------------
--      Consider accepting the plan.                                                   
--     
--     
--     EXPLAIN PLANS SECTION
--     ---------------------------------------------------------------------------------------------
--     
--     Baseline Plan
--     -----------------------------
--      Plan Id          : 847        
--      Plan Hash Value  : 1439196373 
--     
--     --------------------------------------------------------------------------------------------------
--     | Id  | Operation                       | Name        | Rows     | Bytes   | Cost     | Time     |
--     --------------------------------------------------------------------------------------------------
--     |   0 | SELECT STATEMENT                |             |        1 |      33 | 56889611 | 00:37:03 |
--     |   1 |   SORT AGGREGATE                |             |        1 |      33 |          |          |
--     |   2 |    NESTED LOOPS                 |             |    56250 | 1856250 | 56889611 | 00:37:03 |
--     |   3 |     NESTED LOOPS                |             | 56250000 | 1856250 | 56889611 | 00:37:03 |
--     |   4 |      TABLE ACCESS FULL          | SALES_AREA2 |    75000 | 1950000 |     6843 | 00:00:01 |
--     | * 5 |      INDEX RANGE SCAN           | SALES_TYP1I |      750 |         |        8 | 00:00:01 |
--     | * 6 |     TABLE ACCESS BY INDEX ROWID | SALES_AREA1 |        1 |       7 |      758 | 00:00:01 |
--     --------------------------------------------------------------------------------------------------
--     
--     Predicate Information (identified by operation id):
--     ------------------------------------------
--     * 5 - access("T1"."SALE_TYPE"=1)
--     * 6 - filter("T1"."SALE_CODE"="T2"."SALE_CODE")
--     
--     Hint Report (identified by operation id / Query Block Name / Object Alias):
--     Total hints for statement: 2 (U - Unused (2))
--     -------------------------------------------------------------------------------
--                                                                           
--      1 -  SEL$1                                                           
--            U -  LEADING(t2 t1) / rejected by IGNORE_OPTIM_EMBEDDED_HINTS  
--                                                                           
--      5 -  SEL$1 / T1@SEL$1                                                
--            U -  USE_NL(t1) / rejected by IGNORE_OPTIM_EMBEDDED_HINTS      
--     
--     Test Plan
--     -----------------------------
--      Plan Id          : 848       
--      Plan Hash Value  : 379518564 
--     
--     ---------------------------------------------------------------------------------------------------
--     | Id  | Operation                               | Name        | Rows  | Bytes   | Cost | Time     |
--     ---------------------------------------------------------------------------------------------------
--     |   0 | SELECT STATEMENT                        |             |     1 |      33 | 7603 | 00:00:01 |
--     |   1 |   SORT AGGREGATE                        |             |     1 |      33 |      |          |
--     | * 2 |    HASH JOIN                            |             | 56250 | 1856250 | 7603 | 00:00:01 |
--     |   3 |     TABLE ACCESS BY INDEX ROWID BATCHED | SALES_AREA1 |   750 |    5250 |  759 | 00:00:01 |
--     | * 4 |      INDEX RANGE SCAN                   | SALES_TYP1I |   750 |         |    9 | 00:00:01 |
--     |   5 |     TABLE ACCESS FULL                   | SALES_AREA2 | 75000 | 1950000 | 6843 | 00:00:01 |
--     ---------------------------------------------------------------------------------------------------
--     
--     Predicate Information (identified by operation id):
--     ------------------------------------------
--     * 2 - access("T1"."SALE_CODE"="T2"."SALE_CODE")
--     * 4 - access("T1"."SALE_TYPE"=1)
--     
--     Hint Report (identified by operation id / Query Block Name / Object Alias):
--     Total hints for statement: 2 (U - Unused (2))
--     -------------------------------------------------------------------------------
--                                                                           
--      1 -  SEL$1                                                           
--            U -  LEADING(t2 t1) / rejected by IGNORE_OPTIM_EMBEDDED_HINTS  
--                                                                           
--      3 -  SEL$1 / T1@SEL$1                                                
--            U -  USE_NL(t1) / rejected by IGNORE_OPTIM_EMBEDDED_HINTS      
--     ---------------------------------------------------------------------------------------------





-- 방법4: 사용하려는 예전 plan이 baseline에 없고 cursor cache에도 없는 경우 사용
-- AWR에서 과거 plan을 확인 후 baseline에 enabled='YES', fixed='NO' 상태로 적재한다.
-- 아래 쿼리는 AWR에서 특정 plan이 아니라 begin_snap과 end_snap 사이 전체 plan을 적재한다. (basic_filter 기능이 있으나 추가 테스트 필요)
-- 적재가 완료되면 해당 plan 확인 후 evolve 시킨다.
-- 필요 시 이전 plan을 disable 한다.
SELECT sql_id, child_number, executions, elapsed_time, buffer_gets, last_active_time, sql_plan_baseline, sql_text
     , 'SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(''' || sql_id || ''', ' || child_number || ', ''ALLSTATS LAST ALL +OUTLINE''));' AS view_plan
     -- , 'DECLARE REPORT CLOB;' || CHR(13) || 'BEGIN' || CHR(13) || '    REPORT := DBMS_SPM.ADD_VERIFIED_SQL_PLAN_BASELINE(sql_id=>''' || sql_id || ''');' || CHR(13) || 'DBMS_OUTPUT.PUT_LINE(REPORT);' || CHR(13) || 'END;' AS add_verified_plan
     -- , 'DECLARE A_RETURN PLS_INTEGER;' || CHR(13) || 'BEGIN' || CHR(13) || '    A_RETURN := DBMS_SPM.LOAD_PLANS_FROM_CURSOR_CACHE(sql_id=>''' || sql_id || ''', plan_hash_value=>' || plan_hash_value || ', fixed=>''YES'', enabled=>''YES'');' || CHR(13) || 'END;' AS cc_load_plan
     , 'DECLARE A_RETURN PLS_INTEGER;' || CHR(13) || 'BEGIN' || CHR(13) || '    A_RETURN := DBMS_SPM.LOAD_PLANS_FROM_AWR(begin_snap=>''' || START_SNAP_ID || ''', end_snap=>''' || END_SNAP_ID || ''', fixed=>''NO'', enabled=>''YES'');' || CHR(13) || 'END;' AS awr_load_plan
  FROM v$sql
     , (SELECT DBID
             , INSTANCE_NUMBER
             , MIN(SNAP_ID) AS START_SNAP_ID
             , MAX(SNAP_ID) AS END_SNAP_ID
          FROM DBA_HIST_SNAPSHOT
         WHERE INSTANCE_NUMBER = SYS_CONTEXT('USERENV', 'INSTANCE')
         GROUP BY DBID, INSTANCE_NUMBER) S
 WHERE 1=1
   -- AND sql_id = ''
   AND sql_text LIKE '%%'
 ORDER BY last_active_time DESC;

SELECT sql_handle, plan_name, enabled, accepted, fixed, created, last_modified, last_executed, origin
     , 'SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_SQL_PLAN_BASELINE(''' || sql_handle || ''', ''' || plan_name || ''', ''OUTLINE''));' AS view_plan
     -- , 'DECLARE A_RETURN PLS_INTEGER;' || CHR(13) || 'BEGIN' || CHR(13) || '    A_RETURN := DBMS_SPM.ALTER_SQL_PLAN_BASELINE(sql_handle=>'''|| sql_handle || ''', plan_name=>''' || plan_name || ''', attribute_name=>''ENABLED'', attribute_value=>''YES'');' || CHR(13) || 'END;' AS enable_plan
     -- , 'DECLARE A_RETURN PLS_INTEGER;' || CHR(13) || 'BEGIN' || CHR(13) || '    A_RETURN := DBMS_SPM.ALTER_SQL_PLAN_BASELINE(sql_handle=>''' || sql_handle || ''', plan_name=>''' || plan_name || ''', attribute_name=>''ENABLED'', attribute_value=>''NO'');' || CHR(13) || 'END;' AS disable_plan
     -- , 'DECLARE A_RETURN PLS_INTEGER;' || CHR(13) || 'BEGIN' || CHR(13) || '    A_RETURN := DBMS_SPM.ALTER_SQL_PLAN_BASELINE(sql_handle=>''' || sql_handle || ''', plan_name=>''' || plan_name || ''', attribute_name=>''FIXED'', attribute_value=>''YES'');' || CHR(13) || 'END;' AS fix_plan
     -- , 'DECLARE A_RETURN PLS_INTEGER;' || CHR(13) || 'BEGIN' || CHR(13) || '    A_RETURN := DBMS_SPM.ALTER_SQL_PLAN_BASELINE(sql_handle=>''' || sql_handle || ''', plan_name=>''' || plan_name || ''', attribute_name=>''FIXED'', attribute_value=>''NO'');' || CHR(13) || 'END;' AS unfix_plan
     , 'DECLARE REPORT CLOB;' || CHR(13) || 'BEGIN' || CHR(13) || '    REPORT := DBMS_SPM.EVOLVE_SQL_PLAN_BASELINE(sql_handle=>''' || sql_handle || ''', plan_name=>''' || plan_name || ''', time_limit=>DBMS_SPM.AUTO_LIMIT, verify=>''YES'', COMMIT=>''YES'');' || CHR(13) || '    DBMS_OUTPUT.PUT_LINE(REPORT);' || CHR(13) || 'END;' AS evolve_plan
     -- , 'DECLARE A_RETURN PLS_INTEGER;' || CHR(13) || 'BEGIN' || CHR(13) || '    A_RETURN := DBMS_SPM.DROP_SQL_PLAN_BASELINE(sql_handle=>''' || sql_handle || ''', plan_name=>''' || plan_name || ''');' || CHR(13) || 'END;' AS drop_plan
  FROM dba_sql_plan_baselines
 WHERE 1=1
   -- AND sql_handle = ''
   -- AND plan_name = ''	-- v$sql.sql_plan_baseline
   AND sql_text LIKE '%%'
 ORDER BY created DESC;



















--------------------------------------- 기타 참고용 SQL ---------------------------------------

-- AWR추출용 DBID, INSTANCE_NUMBER, SNAP_ID 확인
SELECT DBID
     , INSTANCE_NUMBER
     , MIN(SNAP_ID) AS START_SNAP_ID
     , MAX(SNAP_ID) AS END_SNAP_ID
  FROM DBA_HIST_SNAPSHOT
 WHERE INSTANCE_NUMBER = SYS_CONTEXT('USERENV', 'INSTANCE')
 GROUP BY DBID, INSTANCE_NUMBER
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
   AND SQL_TEXT LIKE '%/* cursorcache */%';
SELECT PLAN_HASH_VALUE, CHILD_NUMBER, SQL_PLAN_BASELINE
  FROM V$SQL 
 WHERE SQL_TEXT LIKE '%/* zzz */%'
   AND SQL_PLAN_BASELINE IS NOT NULL;

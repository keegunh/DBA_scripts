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



ALTER SYSTEM FLUSH BUFFER_CACHE;
ALTER SYSTEM FLUSH SHARED_POOL;
ALTER SESSION SET STATISTICS_LEVEL=ALL;


--------------------------------------------------------------------------
-- #06. Test 쿼리 1번째 수행 (Good Performance)
--------------------------------------------------------------------------
alter session set optimizer_ignore_hints = true; --> 아래 SQL문의 힌트는 나쁜 Plan 으로 풀리는 것이고, 이를 제거하기 위해 ignore ..

select /* ddd */ /*+ USE_NL(t1) LEADING(t2 t1) */ sum(t2.amount)
  from sales_area1 t1, 
       sales_area2 t2
 where t1.sale_code = t2.sale_code
   and t1.sale_type = 1;


--------------------------------------------------------------------------
-- #07. 앞서 실행한 SQL의 Plan 을 확인
--------------------------------------------------------------------------
SELECT SQL_ID, CHILD_NUMBER, SQL_TEXT, SQL_PLAN_BASELINE
  FROM V$SQL 
 WHERE SQL_TEXT LIKE '%/* ddd */%'
   AND SQL_TEXT NOT LIKE '%V$SQL%';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR('bttmzny8pwuhm', NULL, 'ADVANCED ALLSTATS LAST'));








--------------------------------------------------------------------------
-- #13. Test 쿼리를 2번째 수행 (안좋은 성능으로 실행)
--------------------------------------------------------------------------
alter session set optimizer_ignore_hints = false; --> 안좋은 Plan 으로 수행되도록 ...

select /* ddd */ /*+ USE_NL(t1) LEADING(t2 t1) */ sum(t2.amount)
  from sales_area1 t1, 
       sales_area2 t2
 where t1.sale_code = t2.sale_code
   and t1.sale_type = 1;
        ---> !!! Auto SPM 실행간격이 1시간단위이기 때문에 1시간이 지나야 baseline 으로 등록되고 그때부터 빨라짐.
        ---> !!! baseline 으로 등록되었는지 dba_sql_plan_baselines 에서 주기적으로 확인한 후에 다음을 실행하면 됨.

--------------------------------------------------------------------------
-- #15. Test 쿼리를 3번째 수행 (baseline 이 등록되어서 좋은 성능으로 실행)
--------------------------------------------------------------------------
select /* ddd */ /*+ USE_NL(t1) LEADING(t2 t1) */ sum(t2.amount)
  from sales_area1 t1, 
       sales_area2 t2
 where t1.sale_code = t2.sale_code
   and t1.sale_type = 1;
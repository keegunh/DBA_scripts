SELECT *
  FROM TABLE(DBMS_XPLAN.DISPLAY)

/* USAGE
DBMS_XPLAN.DISPLAY : 현 세션 내에서 가장 마지막에 수행한 EXPLAIN PLAN 내 저장된 계획 정보 출력
DBMS_XPLAN.DISPLAY_CURSOR : 현 SQL AREA에 저장된 특정 CURSOR에 대한 실행 계획 정보 출력. 이미 실행이 완료된 SQL에 대한 성능 정보 분석 용도
DBMS_XPLAN.DISPLAY_AWR : AWR에 저장된 특정 SQL ID에 대한 실행 계획 정보 출력. SQL AREA에서도 소멸된 과거 특정 시점의 SQL의 성능 정보 분석 용도

EXPLAIN PLAN FOR
SELECT *
  FROM ....; -- QUERY
  
SELECT *
  FROM TABLE(DBMS_XPLAN.DISPLAY)

Plan hash value : 24667981789

--------------------------------------------------------------------------------------
| Id  | Operation          | Name                | Rows | Bytes | Cost (%CPU) | Time |
....
--------------------------------------------------------------------------------------

** Must truncate PLAN_TABLE from time to time for optimal performance

*/
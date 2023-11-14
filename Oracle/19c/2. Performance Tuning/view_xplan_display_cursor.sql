ALTER SESSION SET STATISTICS_LEVEL = 'ALL';

SELECT /*+ GATHER_PLAN_STATISTICS SQL01 */
  FROM ... -- 튜닝할 쿼리 실행
;

SELECT S.SQL_ID
     , S.CHILD_NUMBER
     , X.*
  FROM V$SQL S
     , TABLE(DBMS_XPLAN.DISPLAY_CURSOR(SQL_ID=>S.SQL_ID, CURSOR_CHILD_NO=>S.CHILD_NUMBER, FORMAT=>'ALLSTATS LAST')) X
 WHERE S.SQL_TEXT LIKE '%SQL01%'
   AND S.SQL_TEXT NOT LIKE '%V$SQL%';
   
-- 또는 
SELECT * FROM V$SQL WHERE SQL_TEXT LIKE '%SQL01%' AND SQL_TEXT NOT LIKE '%V$SQL%';
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(SQL_ID=>'V$SQL에서의 SQL_ID', 0, 'ALLSTATS LAST');
   
   
/*
FORMAT : 
	- BASIC				: 실행계획의 단계별 Operation과 Object Name를 제공함
	- TYPICAL (DEFAULT)	: BASIC 정보에 추가적인 정보로 예측 Rows, Result Set의 크기(Bytes), Cost와 예측 실행 시간, Predicate 등의 정보를 제공함
	- ALL				: TYPICAL에 추가적인 정보로 Query Block, Column Project를 제공함. 상세 튜닝 분석 유형으로 적합
	- ALLSTATS LAST		: GATHER_PLAN_STATISTICS 힌트와 함께 사용하여 예측 정보(Estimated Rows)와 함께 실 정보(Actual Rows)를 제공함
	- SERIAL
	- ADAPTIVE

DBMS_XPLAN.DISPLAY : 현 세션 내에서 가장 마지막에 수행한 EXPLAIN PLAN 내 저장된 계획 정보 출력
DBMS_XPLAN.DISPLAY_CURSOR : 현 SQL AREA에 저장된 특정 CURSOR에 대한 실행 계획 정보 출력. 이미 실행이 완료도니 SQL에 대한 성능 정보 분석 용도
DBMS_XPLAN.DISPLAY_AWR : AWR에 저장된 특정 SQL ID에 대한 실행 계획 정보 출력. SQL AREA에서도 소멸된 과거 특정 시점의 SQL의 성능 정보 분석 용도

*/
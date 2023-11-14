SET AUTOTRACE TRACEONLY;
SELECT * FROM ... -- QUERY

/*
	Must execute in sqlplus
	1. SET AUTOTRACE ON
		SQL을 실제 수행하고 그 결과와 함께 실행계획 및 실행통계를 출력
	2. SET AUTOTRACE ON EXPLAIN
		SQL을 실제 수행하고 그 결과와 함께 실행계획을 출력
	3. SET AUTOTRACE ON STATISTICS
		SQL을 실제 수행하고 그 결과와 함께 실행통계를 출력
	4. SET AUTOTRACE TRACEONLY
		SQL을 실제 수행하지만 그 결과는 출력하지 않고 실행계획과 통계만 출력
	5. SET AUTOTRACE TRACEONLY EXPLAIN
		SQL을 실제 수행하지 않고 실행계획만 출력
	6. SET AUTOTRACE TRACEONLY STATISTICS
		SQL을 실제 수행하지만 그 결과는 출력하지 않고 실행통계만 출력
	
	1,2,3 은 SQL 결과를 출력
	4,5,6 은 SQL 결과 미출력
	5는 실제 쿼리를 실행하지 않음. 나머지는 실제 쿼리를 실행함

*/
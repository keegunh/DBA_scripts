/*
	DOCUMENTATION : https://dev.mysql.com/doc/refman/8.0/en/performance-schema-events-statements-current-table.html
*/

SELECT THREAD_ID
     , SQL_TEXT
	 , ROWS_SENT
	 , ROWS_EXAMINED
     , ROWS_AFFECTED
	 , ERRORS 
	 , CREATED_TMP_DISK_TABLES 
	 , CREATED_TMP_TABLES 
	 , SELECT_FULL_JOIN 
	 , SELECT_FULL_RANGE_JOIN 
	 , SELECT_RANGE 
	 , SELECT_RANGE_CHECK 
	 , SELECT_SCAN 
	 , SORT_MERGE_PASSES 
	 , SORT_RANGE 
	 , SORT_ROWS 
	 , SORT_SCAN 
	 , NO_INDEX_USED 
	 , NO_GOOD_INDEX_USED 
  FROM performance_schema.events_statements_history
 WHERE ROWS_EXAMINED > ROWS_SENT
    OR ROWS_EXAMINED > ROWS_AFFECTED
	OR ERRORS > 0						-- SQL 문법 오류
	OR CREATED_TMP_DISK_TABLES > 0		-- 디스크 임시 테이블 -> 메모리 임시 테이블 최대 크기 늘리거나 쿼리 튜닝 필요
	OR CREATED_TMP_TABLES > 0			-- 메모리 임시 테이블 -> 테이블이 커지면 디스크 임시 테이블이 될 수도 있음
	OR SELECT_FULL_JOIN > 0				-- JOIN 시 FULL TABLE SCAN -> 인덱스 생성 필요
	OR SELECT_FULL_RANGE_JOIN > 0		-- JOIN 시 범위 검색 사용
	OR SELECT_RANGE > 0					-- JOIN이 첫 번째 테이블의 행을 확인하기 위해 범위 검색 사용 (큰 문제 아님)
	OR SELECT_RANGE_CHECK > 0			-- JOIN에 사용할 인덱스 없음 -> 인덱스 생성 필요
	OR SELECT_SCAN > 0					-- JOIN이 첫 번째 테이블의 FULL TABLE SCAN
	OR SORT_MERGE_PASSES > 0			-- 정렬 수행 시 merge 횟수 -> sort_buffer_size 조정 필요
	OR SORT_RANGE > 0					-- 범위를 지정하고 정렬 수행
	OR SORT_ROWS > 0					-- 정렬된 행의 수. 반환된 행의 값보다 크면 쿼리 최적화 필요
	OR SORT_SCAN > 0					-- 정렬이 인덱스를 사용하지 않고 테이블을 스캔해서 수행된 경우 -> 인덱스 조정 필요
	OR NO_INDEX_USED > 0				-- 인덱스가 사용되지 않ㅇ느 경우 -> 인덱스 생성 / 조정 필요
	OR NO_GOOD_INDEX_USED > 0			-- 최적의 인덱스가 사용되지 않은 경우 -> 인덱스 생성 / 조정 필요
	OR TIMER_WAIT > 3000000000			-- 3초 이상 수행
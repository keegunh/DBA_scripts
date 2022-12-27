-- 워크로드가 읽기 바운드 작업인지 쓰기 바운드 작업인지 확인
SELECT EVENT_NAME
     , COUNT(EVENT_NAME)
  FROM performance_schema.events_statements_history_long
 GROUP BY EVENT_NAME;


-- 구문의 LOCK 대기 시간 확인
SELECT EVENT_NAME
     , COUNT(EVENT_NAME)
	 , SUM(LOCK_TIME/1000000) AS LATENCY_MS
  FROM performance_schema.events_statements_history
 GROUP BY EVENT_NAME;
 ORDER BY LATENCY_MS DESC;

-- READ / WRITE BYTE 확인
WITH ROWS_READ AS (
	SELECT ROUND(SUM(VARIABLE_VALUE) / POW(1024,3), 2) AS ROWS_READ_GB
	  FROM performance_schema.global_status
	 WHERE VARIABLE_NAME IN ('Handler_read_first', 'Handler_read_key', 'Handler_read_next', 'Handler_read_last', 'Handler_read_prev', 'Handler_read_rnd', 'Handler_read_rnd_next')
), ROWS_WRITTEN AS (
	SELECT ROUND(SUM(VARIABLE_VALUE) / POW(1024,3), 2) AS ROWS_WRITTEN_GB
	  FROM performance_schema.global_status
	 WHERE VARIABLE_NAME IN ('Handler_write')
) SELECT * FROM ROWS_READ, ROWS_WRITTEN;
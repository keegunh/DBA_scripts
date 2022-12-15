/*
	Performance_schema를 통해 압축된 트랜잭셔늗ㄹ의 통계 정보와 압축 성능 확인
	show variables like 'binlog_transaction_compression=ON
	show variables like 'binlog_transaction_level_zstd=3
*/
SELECT LOG_TYPE
     , COMPRESSION_TYPE
	 , TRANSACTION_COUNTER
	 , COMPRESSED_BYTES
	 , COMPRESSION_PERCENTAGE
	 , FIRST_TRANSACTION_ID
	 , FIRST_TRANSACTION_COMPRESSED_BYTES
	 , FIRST_TRANSACTION_UNCOMPRESSED_BYTES
	 , LAST_TRANSACTION_TIMESTAMP
  FROM performance_schema.binary_log_transaction_compression_stats;

-- 테이블에 저장되는 통계 정보는 일반적으로 MySQL 서버가 시작되면 자동으로 수집되며, 
-- TRUNCATE 구문을 사용해 MySQL 서버가 구동 중인 상태에서 테이블 데이터를 초기화할 수 있음.  
-- TRUNCATE TABLE performance_schema.binary_log_transaction_compression_stats;






/*
	MySQL 서버가 트랜잭션을 압축하고 압축을 해제하는 데 소요한 시간에 대한 통계 확인
*/
UPDATE performance_schema.setup_instruments
   SET ENABLED='YES', TIMED='YES'
 WHERE NAME IN ('stage/sql/Compression transaction changes.', 'stage/sql/Decompressing transaction changes.');
UPDATE performance_schema.setup_instruments
   SET ENABLED='NO', TIMED='NO'
 WHERE NAME IN ('stage/sql/Compression transaction changes.', 'stage/sql/Decompressing transaction changes.');

SELECT EVENT_NAME
     , COUNT_STAR
	 , FORMAT_PICO_TIME(SUM_TIMER_WAIT) AS total_latency
	 , FORMAT_PICO_TIME(MIN_TIMER_WAIT) AS min_latency
	 , FORMAT_PICO_TIME(AVG_TIMER_WAIT) AS avg_latency
	 , FORMAT_PICO_TIME(MAX_TIMER_WAIT) AS max_latency
  FROM performance_schema.events_stages_summary_global_by_event_name
 WHERE EVENT_NAME LIKE 'stage/sql/%transaction changes.';
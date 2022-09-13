-- 전체 테이블 스캔이 발생한 테이블들의 목록 확인
SELECT object_schema
     , object_name
     , rows_full_scanned
     , latency
  FROM sys.schema_tables_with_full_table_scans
 ORDER BY total_latency DESC;

SELECT db
     , query
	 , exec_count
	 , sys.format_time(total_latency) as 'formatted_total_latency'
	 , rows_sent_avg
	 , rows_examined_avg
	 , last_seen
  FROM sys.x$statements_with_full_table_scans
 ORDER BY total_latency DESC;
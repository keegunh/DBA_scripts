-- MySQL 서버가 구동된 시점부터 현재까지 쓰기가 발생하지 않은 테이블 목록
SELECT t.table_schema
     , t.table_name
	 , t.table_rows
	 , tio.count_read
	 , tio.count_write
  FROM information_schema.tables t
  JOIN performance_schema.table_io_waits_summary_by_table tio
    ON tio.object_schema = t.table_schema
   AND tio.object_name = t.table_name
 WHERE t.table_schema NOT IN ('mysql', 'performance_schema', 'sys')
   AND tio.count_write = 0
 ORDER BY t.table_schema, t.table_name;
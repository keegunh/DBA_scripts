SELECT SUBSTRING_INDEX(EVENT_NAME, '/', -1) AS EVENT
     , CURRENT_NUMBER_OF_BYTES_USED/1024/1024 AS CURRENT_MB
	 , HIGH_NUMBER_OF_BYTES_USED/1024/1024 AS HIGH_MB
  FROM performance_schema.memory_summary_global_by_event_name
 WHERE EVENT_NAME LIKE 'memory/performance_schema/%'
 ORDER BY CURRENT_NUMBER_OF_BYTES_USED DESC LIMIT 10;
 
 
SELECT SUBSTRING_INDEX(event_name, '/', -1) AS EVENT
     , current_alloc AS CURRENT_ALLOC
  FROM sys.memory_global_by_current_bytes
 WHERE event_name LIKE 'memory/performance_schema/%' LIMIT 10;
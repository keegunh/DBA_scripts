/*
	MySQL 서버에 존재하는 각 테이블에 대해 데이터 작업 유형 및 I/O 유형별 전체 통계 정보 확인
	이 정보를 바탕으로 테이블의 대략적인 사용 형태를 파악 가능.
	각 테이블의 주된 사용 형태는 MySQL 서버의 현재 상태를 분서갛고 튜닝하는 데 있어 사용자가 기본적으로 파악해야 하는 부분 중 하나.

	각 테이블에 대해 데이터 작업 유형별(Fetched/Inserted/Updated/Deleted) 수행 횟수와 지연 시간;I/O 발생량 및 지연 시간 등을 포함하는 통계 정보 확인
	I/O 관련된 정보들은 x$ps_schema_table_statistics_io 뷰에서 제공하는 데이터를 참조
	x$schema_table_statistics
*/

SELECT table_schema
     , table_name
     , total_latency
     , rows_fetched
     , fetch_latency
     , rows_inserted
     , insert_latency
     , rows_updated
     , update_latency
     , rows_deleted
     , delete_latency
     , io_read_requests
     , io_read
     , io_read_latency
     , io_write_requests
     , io_write
     , io_write_latency
     , io_misc_requests
     , io_misc_latency
  FROM sys.schema_table_statistics
 WHERE table_schema not in ('information_schema', 'performance_schema', 'sys', 'mysql');
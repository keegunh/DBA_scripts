-- MySQL 서버에서 실행된 전체 쿼리들에 대해 데이터베이스 및 쿼리 다이제스트(Digest)별로 쿼리 처리와 관련된 통계 정보 확인
-- x$statement_analysis
SELECT query
     , db
     , full_scan
     , exec_count
     , err_count
     , warn_count
     , total_latency
     , max_latency
     , avg_latency
     , lock_latency
     , rows_sent
     , rows_sent_avg
     , rows_examined
     , rows_examined_avg
     , rows_affected
     , rows_affected_avg
     , tmp_tables
     , tmp_disk_tables
     , rows_sorted
     , sort_merge_passes
     , digest
     , first_seen
     , last_seen
  FROM sys.statement_analysis;

-- 쿼리 실행 시 경고 또는 에러를 발생한 쿼리들에 대해 데이터베이스 및 쿼리 다이제스트(Digest)별로 경고 및 에러에 대한 통계 정보 확인
-- x$statements_with_errors_or_warnings
SELECT query
     , db
     , exec_count
     , errors
     , error_pct
     , warnings
     , warning_pct
     , first_seen
     , last_seen
     , digest
  FROM sys.statements_with_errors_or_warnings;

-- 전체 테이블 스캔을 수행한 쿼리들에 대해 데이터베이스 및 쿼리 다이제스트(Digest)별로 인덱스 미사용 횟수;접근 및 반환도니 총 데이터 수 등을 포함하는 통계 정보 확인
-- x$statements_with_full_table_scans
SELECT query
     , db
     , exec_count
     , total_latency
     , no_index_used_count
     , no_good_index_used_count
     , no_index_used_pct
     , rows_sent
     , rows_examined
     , rows_sent_avg
     , rows_examined_avg
     , first_seen
     , last_seen
     , digest
  FROM sys.statements_with_full_table_scans;

-- 평균 실행 시간이 95 백분위수 이상에 해당하는 쿼리들(즉;평균 실행 시간이 상위 5%에 속함)에 대해 실행 횟수와 실행 시간;반환한 로우 수 등 쿼리 실행 내역과 관련된 통계 정보 확인
-- x$statements_with_runtimes_with_95th_percentile
SELECT query
     , db
     , full_scan
     , exec_count
     , err_count
     , warn_count
     , total_latency
     , max_latency
     , avg_latency
     , rows_sent
     , rows_sent_avg
     , rows_examined
     , rows_examined_avg
     , first_seen
     , last_seen
     , digest
  FROM sys.statements_with_runtimes_in_95th_percentile;

-- 실행된 쿼리들의 평균 실행 시간을 기준으로 95 백분위수에 해당하는 평균 실행 시간 값을 확인
SELECT avg_us
     , percentile
  FROM sys.x$ps_digest_95th_percentile_by_avg_us;

-- 평균 실행 시간별 쿼리들의 분포도를 확인
SELECT cnt
     , avg_us
  FROM sys.x$ps_digest_avg_latency_distribution;

-- 정렬 작업을 수행한 쿼리들에 대해 데이터베이스 및 쿼리 다이제스트(Digest)별로 정렬 작업과 관련된 통계 정보를 확인
-- x$statements_with_sorting
SELECT query
     , db
     , exec_count
     , total_latency
     , sort_merge_passes
     , avg_sort_merges
     , sorts_using_scans
     , sort_using_range
     , rows_sorted
     , avg_rows_sorted
     , first_seen
     , last_seen
     , digest
  FROM sys.statements_with_sorting;

-- 처리 과정 중에 임시 테이블이 사용된 쿼리들에 대해 데이터베이스 및 쿼리 다이제스트(Digest)별로 임시 테이블과 관련된 통계 정보 확인
-- x$statements_with_temp_tables
SELECT query
     , db
     , exec_count
     , total_latency
     , memory_tmp_tables
     , disk_tmp_tables
     , avg_tmp_tables_per_query
     , tmp_tables_to_disk_pct
     , first_seen
     , last_seen
     , digest
  FROM sys.statements_with_temp_tables;
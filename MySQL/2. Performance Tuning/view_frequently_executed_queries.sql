-- 자주 실행되는 쿼리 확인
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
  FROM sys.statement_analysis
 ORDER BY exec_count DESC;
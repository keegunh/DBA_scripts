-- 자주 실행되는 쿼리 확인
-- 슬로으 쿼리 로그 파일에서는 같은 형태의 쿼리라도 실행된 쿼리들이 모두 개별적으로 기록되므로 사용자가 오래 실행되는 쿼리들에 대해 유형별로 종합적인 정보를 얻긴 어렵다.
-- sys 스키마에서는 오래 실행된 쿼리들에 대해 쿼리 유형별로 누적 실행 횟수와 평균 실행 시간 등의 통계 정보를 함꼐 제공하므로 사용자가 오랫동안 실행된 쿼리들을 확인 및 분석하기가 매우 용이하다.
-- MySQL 서버에서 실행된 전체 쿼리들에 대해 데이터베이스 및 쿼리 다이제스트(Digest)별로 쿼리 처리와 관련된 통계 정보 확인
-- x$statement_analysis
SELECT query
     , exec_count
     , sys.format_time(avg_latency) as 'formatted_avg_latency'
     , rows_sent_avg
     , rows_examined_avg
     , last_seen
     -- , full_scan
     -- , err_count
     -- , warn_count
     -- , total_latency
     -- , max_latency
     -- , lock_latency
     -- , rows_sent
     -- , rows_examined
     -- , rows_affected
     -- , rows_affected_avg
     -- , tmp_tables
     -- , tmp_disk_tables
     -- , rows_sorted
     -- , sort_merge_passes
     -- , digest
     -- , first_seen
  FROM sys.x$statement_analysis
 ORDER BY avg_latency DESC;
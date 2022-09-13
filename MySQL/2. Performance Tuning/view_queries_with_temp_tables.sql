-- 실행 시 임시 테이블을 생성하는 쿼리들의 목록 확인.
-- statements_with_temp_tables 뷰에서는 임시 테이블을 생성하는 쿼리들에 대해 쿼리 형태별로 해당 쿼리에서 생성한 임시 테이블 종류와 개수 등에 대한 통계 정보를 함께 제공.

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
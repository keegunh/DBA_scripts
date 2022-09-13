-- 많은 양의 데이터를 읽은 후 내부적으로 정렬 자겅ㅂ을 수행하는 쿼리들의 경우 서버의 CPU 자원을 많이 소모한다.
-- 이러한 쿼리들이 갑자기 대량으로 MySQL 서버에 유입되면 서버에 부하를 주어 문제가 발생할 수 있다.
-- 따라서 정렬 작업을 수행하는 쿼리들을 확인해서 정렬이 발생하지 않게 쿼리를 수정하거나 테이블 인덱스를 조정해 새로운 인덱스를 추가하는 방안을 고려해보는 것이 좋다.

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
  FROM sys.statements_with_sorting
 ORDER BY last_seen DESC;

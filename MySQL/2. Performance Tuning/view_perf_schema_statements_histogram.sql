-- 스키마별, 쿼리 다이제스트별로 쿼리 실행 시간에 대한 히스토그램 정보 확인
SELECT schema_name
     , digest
     , bucket_number
     , bucket_timer_low
     , bucket_timer_high
     , count_bucket
     , count_bucket_and_lower
     , bucket_quantile
  FROM performance_schema.events_statements_histogram_by_digest;

-- MySQL 서버에서 실행된 전체 쿼리들에 대한 실행 시간 히스토그램 정보 확인
SELECT bucket_number
     , bucket_timer_low
     , bucket_timer_high
     , count_bucket
     , count_bucket_and_lower
     , bucket_quantile  
  FROM performance_schema.events_statements_histogram_global;

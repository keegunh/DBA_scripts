-- DB 오브젝트별로 분류해서 집계한 대기 시간 통계 정보 확인
SELECT object_type
     , object_schema
     , object_name
     , count_star
     , sum_timer_wait
     , min_timer_wait
     , avg_timer_wait
     , max_timer_wait
  FROM performance_schema.objects_summary_global_by_type;
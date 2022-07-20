-- performance_schema에서 사용 가능한 이벤트 타이머들과 그 특성에 대한 정보 확인
-- 관련된 정보가 모두 NULL 값으로 표시되는 타이머는 현재 MySQL이 동작 중인 서버에서는 지원하지 않음을 의미
SELECT timer_name
     , timer_frequency
     , timer_resolution
     , timer_overhead
  FROM performance_schema.performance_timers;

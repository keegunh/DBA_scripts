-- Wait 이벤트별로 평균 지연 시간에 대한 통계 정보 및 총 발생 횟수 확인
-- Wait 이벤트명은 기존의 Wait 이벤트들을 상위 세 번쨰 분류 기준에서 그룹화한 값으로 표시
-- x$wait_classes_global_by_avg_latency
SELECT event_class
     , total
     , total_latency
     , min_latency
     , avg_latency
     , max_latency
  FROM sys.wait_classes_global_by_avg_latency;

-- Wait 이벤트별로 총 지연 시간에 대한 토예 정보 및 총 발생 횟수 확인
-- Wait 이벤트명은 기존의 Wait 이벤트들을 상위 세 번째 분류 기준에서 그룹화한 기준으로 표시
-- x$wait_classes_by_global_by_latency
SELECT event_class
     , total
     , total_latency
     , min_latency
     , avg_latency
     , max_latency
  FROM sys.wait_classes_global_by_latency;

-- 호스트별로 발생한 Wait 이벤트별 지연 시간 통계 정보 확인
-- x$wait_by_host_by_latency
SELECT host
     , event
     , total
     , total_latency
     , avg_latency
     , max_latency
  FROM sys.waits_by_host_by_latency;

-- 유저별로 발생한 Wait 이벤트별 지연 시간 통계 정보 확인
-- x$wait_by_user_by_latency
SELECT user
     , event
     , total
     , total_latency
     , avg_latency
     , max_latency
  FROM sys.waits_by_user_by_latency;

-- MySQL 서버에서 발생한 전체 Wait 이벤트별 지연 시간 통계 정보 확인
-- x$waits_global_by_latency
SELECT events
     , total
     , total_latency
     , avg_latency
     , max_latency
  FROM sys.waits_global_by_latency;
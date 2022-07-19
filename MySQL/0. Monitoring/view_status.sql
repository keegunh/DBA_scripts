-- DB 계정별 상태 변숫값 확인
SELECT user
     , host
     , variable_name
     , variable_value
  FROM performance_schema.status_by_account;

-- 호스트별 상태 변숫값 확인
SELECT host
     , variable_name
     , variable_value
  FROM performance_schema.status_by_host;

-- DB 계정명별 상태 변숫값 확인
SELECT user
     , variable_name
     , variable_value
  FROM performance_schema.status_by_user;
-- performance_schema에서 최대로 수집할 수 있는 이벤트 수를 제한하는 시스템 변수에 설정된 값으로 인해 실제로 performance_schema에서 수집이 제외된 이벤트들이 존재하는지에 대한 정보 확인
SELECT variable_name
     , variable_value
  FROM sys.ps_check_lost_instrumentation;
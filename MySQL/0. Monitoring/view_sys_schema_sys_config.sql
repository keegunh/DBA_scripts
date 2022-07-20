-- Sys 스키마의 함수 및 프로시저에서 참조되는 옵션들이 저장돼 있는 테이블.
SELECT variable
     , value
     , set_time
     , set_by
  FROM sys.sys_config;
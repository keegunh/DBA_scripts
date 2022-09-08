-- Sys 스키마 버전과 MySQL 서버 버전 정보 확인
SELECT sys_version
     , mysql_version
  FROM sys.version;
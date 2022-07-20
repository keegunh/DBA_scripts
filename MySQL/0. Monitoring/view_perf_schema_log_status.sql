-- MySQL 서버 로그 파일들의 포지션 정보 확인
-- 이는 온라인 백업 시 활용 가능
SELECT server_uuid
     , local
     , replication
     , storage_engines
  FROM performance_schema.log_status;
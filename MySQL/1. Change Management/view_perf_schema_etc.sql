-- MySQL 연결 인터페이스별 TLS(SSL) 속성 정보 저장
desc performance_schema.tls_channel_status;


-- MySQL 에러 로그 파일의 내용 확인
desc performance_schema.error_log;

-- MySQL 서버에 연결된 세션 목록과 각 세션의 현재 상태, 세션에서 실행 중인 쿼리 정보 확인
-- processlist 테이블에서 보여지는 데이터는 show processlist 명령문을 실행하거나 information_schema의 processlist 테이블을 조회해서 얻은 결과 데이터와 동일
desc performance_schema.processlist;
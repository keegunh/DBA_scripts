/*
*	Connection 테이블들은 MySQL에서 생성된 커넥션들에 대한 통계 및 속성 정보를 제공한다.
*/

-- DB 계정명과 MySQL 서버로 연결한 클라이언트 호스트 단위의 커넥션 통계 정보 확인
SELECT user
     , host
     , current_connections
     , total_connections
  FROM performance_schema.accounts
;

-- 호스트별 커넥션 통계 정보 확인
SELECT host
     , current_connections
     , total_connections
  FROM performance_schema.hosts 
;

-- DB 계정명별 커넥션 통계 정보 확인
SELECT processlist_id
     , attr_name
     , attr_value
     , ordinal_position
  FROM performance_schema.session_account_connect_attrs 
;

-- 현재 세션 및 현재 세션에서 MySQL에 접속하기 위해 사용한 DB 계정과 동일한 계정으로 접속한 다른 세션들의 커넥션 속성 정보 확인.
SELECT processlist_id
     , attr_name
     , attr_value
     , ordinal_position
  FROM performance_schema.session_connect_attrs 
;
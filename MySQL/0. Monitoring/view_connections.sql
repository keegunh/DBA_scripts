-- MySQL 서버가 구동된 시점부터 현재까지 MySQL에 접속했던 호스트들의 전체 목록
-- HOST 칼럼이 NULL인 데이터에는 MySQL 내부 스레드 및 연결 시 인증에 실패한 커넥션들이 포함됨.
-- CURRENT_CONNECTIONS 칼럼은 현재 연결된 커넥션 수
-- TOTAL_CONNECTIONS 칼럼은 연결됐던 커넥션의 총 수
SELECT HOST
     , CURRENT_CONNECTIONS
     , TOTAL_CONNECTIONS
  FROM performance_schema.hosts;

-- MySQL에 원격으로 접속한 호스트들에 대해 호스트별로 현재 연결된 커넥션 수 확인.
SELECT HOST
     , CURRENT_CONNECTIONS
     , TOTAL_CONNECTIONS
  FROM performance_schema.hosts
 WHERE CURRENT_CONNECTIONS > 0
   AND HOST NOT IN ('NULL', '127.0.0.1')
 ORDER BY HOST;
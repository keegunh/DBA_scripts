/*
	로그의 전체 사이즈 + 전체 테이블스페이스 사이즈 = DB인스턴스 운영에 필요한 전체 사이즈
*/

-- 전체 실 데이터(테이블 + 인덱스) 사이즈
SELECT TABLE_SCHEMA "DB_NAME"
     , ROUND(SUM(DATA_LENGTH + INDEX_LENGTH)/1024/1024/1024, 2) "DB_SIZE_GB" 
  FROM INFORMATION_SCHEMA.TABLES 
 GROUP BY TABLE_SCHEMA
; 

-- 전체 할당된 테이블스페이스 사이즈 
SELECT ROUND(SUM(FILE_SIZE/POW(1024,3)),2) AS FILE_SIZE_GIB
     , ROUND(SUM(ALLOCATED_SIZE/POW(1024,3)),2) AS ALLOCATED_SIZE_GIB
  FROM INFORMATION_SCHEMA.INNODB_TABLESPACES
;


-- binary log 사이즈만 보는 쿼리는 별도로 없다. 이 명령어로 전체 목록 구한 뒤 사이즈는 직접 sum 해야 함.
SHOW BINARY LOGS;


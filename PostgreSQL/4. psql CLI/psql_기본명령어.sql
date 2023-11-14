psql 명령어
-- 참고: https://www.postgresql.org/docs/current/app-psql.html

1. psql 접속
	PGPASSWORD=myPassword psql -hHostnameOrIP -pPort -UUsername -dDBName
	예시) PGPASSWORD=postgres psql -hlocalhost -p5432 -Upostgres -dtest

2. database 목록 조회
	\l
	\l+
	\list
	\list+

3. database 접속 변경
	\c DBName
	\connect DBName

4. table 목록 (+는 사이즈 등의 추가 정보 조회 가능, S는 시스템 테이블까지 조회)
	\dt
	\dt+
	\dtS
	\dtS+

5. index 목록
	\di
	\di+
	\diS
	\diS+
	
6. foreign table 목록
	\dE
	\dE+
	\dES
	\dES+

7. materialized view 목록
	\dm
	\dm+
	\dmS
	\dmS+

8. sequence 목록
	\ds
	\ds+

9. view 목록
	\dv
	\dv+
	\dvS
	\dvS+

10. 현재 접속정보 출력
	\conninfo

11. 패스워드 변경
	\password [USERNAME]
	
12. 프로그램 종류
	\q
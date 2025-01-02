-- psql 명령어
-- 참고: https://www.postgresql.org/docs/current/app-psql.html

1. psql 접속 (PGPASSWORD는 환경변수로 입력하면 아래 명령어에서는 password옵션 제외해도 됨)
	PGPASSWORD=myPassword psql -hHostnameOrIP -pPort -UUsername -dDBName
	예시) PGPASSWORD=postgres psql -hlocalhost -p5432 -Upostgres -dtest
	
	psql --host=localhost --port=5432 --username=postgres --password

2. database 목록 조회
	\l
	\l+
	\list
	\list+

3. database 접속 변경
	\c [DBNAME]
	\connect [DBNAME]

4. USER/ROLE 확인 (+는 '설명' 추가 정보 조회 가능, S는 시스템 사용자까지 조회)
	\du
	\du+
	\duS
	\duS+

5. 테이블, 뷰, 인덱스 목록
	\d
	\d+
	\dS
	\dS+
	\d *
	\d [TABLENAME]

4. table 목록 (+는 사이즈 등의 추가 정보 조회 가능, S는 시스템 테이블까지 조회)
	\dt
	\dt+
	\dtS
	\dtS+
	\dt *
	\dt [TABLENAME]

5. index 목록
	\di
	\di+
	\diS
	\diS+
	\di *
	\di [INDEXNAME]
	
6. foreign table 목록
	\dE
	\dE+
	\dES
	\dES+
	\dE *
	\dE [FOREIGNTABLENAME]

7. materialized view 목록
	\dm
	\dm+
	\dmS
	\dmS+
	\dm *
	\dm [MVNAME]

8. sequence 목록
	\ds
	\ds+
	\ds *
	\ds [SEQNAME]

9. view 목록
	\dv
	\dv+
	\dvS
	\dvS+
	\dv *
	\dv [VIEWNAME]

function 목록
	\df
	\df+
	\df *
	\df [FUNCNAME]

10. 현재 접속정보 출력
	\conninfo

11. 패스워드 변경
	\password [USERNAME]
	
12. 프로그램 종류
	\q
	
13. Command History 확인 (또는 파일로 저장)
	\s
	\s [FILENAME] 
	
14. 이전 명령 재실행
	\g
	
15. psql 도움말 확인
	\?
	
16. 이전 statement 에디터에서 수정 (\ef는 function 수정)
	\e
	\ef

17. 쿼리 실행 시간 toggle
	\timing

18. 실행 결과를 파일로 출력
	\o [FILENAME]

19. 쿼리 버퍼를 파일로 출력
	\w [FILENAME]
	
20. AUTOCOMMIT toggle
	\set AUTOCOMMIT on
	\set AUTOCOMMIT off
	
21. format output to HTML format
	\H
	
22. set output from non-aligned to aligned column output
	\a
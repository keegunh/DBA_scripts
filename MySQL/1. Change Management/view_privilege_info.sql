/*
정적 권한
mysql.user			: 계정 정보 & 계정이나 역할에 부여된 글로벌 권한
mysql.db			: 계정이나 역할에 DB 단위로 부여된 권한
mysql.tables_priv	: 계정이나 역할에 테이블 단위로 부여된 권한
mysql.columns_priv	: 계정이나 역할에 칼럼 단위로 부여된 권한
mysql.procs_priv	: 계정이나 역할에 스토어드 프로그램 단위로 부여된 권한

동적 권한
mysql.global_grants	: 계정이나 역할에 부여되는 동적 글로벌 권한




역할 권한
mysql.default_roles	: 계정별 기본 역할
mysql.role_edges	: 역할에 부여된 역할 관계 그래프
*/



select current_role();
show privileges;
show grants;
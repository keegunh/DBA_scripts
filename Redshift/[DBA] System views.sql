select * from pg_catalog.pg_database;
select * from pg_catalog.pg_database_info;

select * from pg_catalog.pg_user;
select * from pg_catalog.pg_tables;
select * from pg_catalog.pg_proc;
select * from pg_catalog.pg_proc_info;

select * from pg_catalog.svl_user_info;

select * from pg_catalog.svv_redshift_databases;
select * from pg_catalog.svv_redshift_schemas;
select * from pg_catalog.svv_redshift_tables;
select * from pg_catalog.svv_redshift_columns;
select * from pg_catalog.svv_redshift_functions;

select * from pg_catalog.svv_all_schemas;
select * from pg_catalog.svv_all_tables;
select * from pg_catalog.svv_all_columns;

select * from pg_catalog.svv_tables st;
select * from pg_catalog.svv_table_info;

select * from pg_table_def; -- DDL 추출할 때 유용

select * from pg_catalog.svv_transactions;

select * from pg_catalog.pg_proc;
select * from pg_catalog.pg_proc_info; -- 가장 상세함. 권한도 조회 가능 (proacl 컬럼 확인. {[권한 피부여자]=[권한]/[권한 부여자], ...} 형식으로 되어 있음)
select * from information_schema.routines;
select * from information_schema.routine_privileges; --이 뷰는 admin으로 조회할 때랑 다른 유저로 조회할 때 결과가 상이함


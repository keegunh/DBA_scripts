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

select * from pg_table_def; -- DDL ������ �� ����

select * from pg_catalog.svv_transactions;

select * from pg_catalog.pg_proc;
select * from pg_catalog.pg_proc_info; -- ���� ����. ���ѵ� ��ȸ ���� (proacl �÷� Ȯ��. {[���� �Ǻο���]=[����]/[���� �ο���], ...} �������� �Ǿ� ����)
select * from information_schema.routines;
select * from information_schema.routine_privileges; --�� ��� admin���� ��ȸ�� ���� �ٸ� ������ ��ȸ�� �� ����� ������


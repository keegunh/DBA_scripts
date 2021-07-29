-- check assumerole privileges
/*
 * PRD arn : arn:aws:iam::1:role/redshift-role
 * QA arn  : arn:aws:iam::2:role/redshift-role
*/
SELECT 
       u.usename
--     , has_assumerole_privilege(u.usename, 'arn:aws:iam::1:role/redshift-role', 'all') AS user_has_all_permission_PRD
     , has_assumerole_privilege(u.usename, 'arn:aws:iam::1:role/redshift-role', 'copy') AS user_has_copy_permission_PRD
     , has_assumerole_privilege(u.usename, 'arn:aws:iam::1:role/redshift-role', 'unload') AS user_has_unload_permission_PRD
--     , has_assumerole_privilege(u.usename, 'arn:aws:iam::2:role/redshift-role', 'all') AS user_has_all_permission_QA
     , has_assumerole_privilege(u.usename, 'arn:aws:iam::2:role/redshift-role', 'copy') AS user_has_copy_permission_QA
     , has_assumerole_privilege(u.usename, 'arn:aws:iam::2:role/redshift-role', 'unload') AS user_has_unload_permission_QA
  FROM pg_user u;


-- check database privileges
SELECT 
       u.usesysid
     , u.usename
     , d.database_owner
     , d.database_name
     , d.database_type
     , has_database_privilege(u.usename, d.database_name, 'create') AS user_has_create_permission
     , has_database_privilege(u.usename, d.database_name, 'temp') AS user_has_temp_permission
  FROM svv_redshift_databases d
 CROSS JOIN pg_user u;


-- check schema privileges
SELECT
       u.usename
     , s.schemaname
     , has_schema_privilege(u.usename,s.schemaname,'create') AS user_has_select_permission
     , has_schema_privilege(u.usename,s.schemaname,'usage') AS user_has_usage_permission
  FROM pg_user u
 CROSS JOIN (SELECT distinct schemaname FROM pg_tables where schemaname = 'public') s
 WHERE u.usename in (
	''
     )
;


-- check table privileges
SELECT
       u.usename
     , s.table_name
     , has_table_privilege(u.usename,s.table_name,'insert') AS user_has_insert_permission
     , has_table_privilege(u.usename,s.table_name,'select') AS user_has_select_permission
     , has_table_privilege(u.usename,s.table_name,'update') AS user_has_update_permission
     , has_table_privilege(u.usename,s.table_name,'delete') AS user_has_delete_permission
     , has_table_privilege(u.usename,s.table_name,'references') AS user_has_references_permission
     , '' as DDL
  FROM pg_user u
 CROSS JOIN svv_tables s
 WHERE s.table_schema = 'public'
   AND u.usename in (
	''
     )
--   AND has_table_privilege(u.usename,s.table_name,'select') = 1
 ORDER BY u.usename, s.table_name;


-- check function/procedure privileges
SELECT proname
     , prolang
     , prokind
     , pronargs
     , proargtypes     
     , prorettype
     , proacl
  FROM pg_proc_info 
 WHERE proowner = 1 (pg_user 참고)
--   AND proname = '' --프로시저/함수 명 조회
;


-- grant / revoke DDL view
select object_type, grantee, object_name, object_owner, ddl 
from v_generate_user_grant_revoke_ddl 
where schema_name = 'public' 
and ddltype = 'grant' 
order by object_type, grantee, object_name
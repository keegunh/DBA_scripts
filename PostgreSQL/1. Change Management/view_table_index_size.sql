-- https://www.postgresql.org/docs/current/functions-admin.html#FUNCTIONS-ADMIN-DBSIZE
-- 주의: information_schema에 있는 정보에 있는 tablename에 quote_ident 등의 함수 적용 시 조회 시 오류 발생

select schemaname
     , tablename
     , tableowner
     , tablespace
     , pg_size_pretty(pg_table_size(quote_ident(tablename))) as table_size
     , pg_size_pretty(pg_relation_size(quote_ident(tablename))) as relation_size
     , pg_size_pretty(pg_total_relation_size(quote_ident(tablename))) as total_relation_size
     , pg_size_pretty(pg_indexes_size(quote_ident(tablename))) as indexes_size
     , hasindexes
     , hasrules
     , hastriggers
     , rowsecurity
  from pg_catalog.pg_tables
 where schemaname in('pg_catalog', 'myDatabase')
 order by schemaname, tablename;
  
select table_catalog
     , table_schema
     , table_name
     , table_type
     , pg_size_pretty(pg_table_size(quote_ident(table_name))) as table_size
     , pg_size_pretty(pg_relation_size(quote_ident(table_name))) as relation_size
     , pg_size_pretty(pg_total_relation_size(quote_ident(table_name))) as total_relation_size
     , pg_size_pretty(pg_indexes_size(quote_ident(table_name))) as indexes_size
     , self_referencing_column_name
     , reference_generation
     , user_defined_type_catalog
     , user_defined_type_schema
     , user_defined_type_name
     , is_insertable_into
     , is_typed
     , commit_action
  from information_schema.tables
 where table_schema in ('pg_catalog', 'myDatabase') 
 order by 1,2,3;
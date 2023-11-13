-- https://www.postgresql.org/docs/current/functions-admin.html#FUNCTIONS-ADMIN-DBSIZE

select spcname as tablespace_name
     , pg_size_pretty(pg_tablespace_size(spcname)) as size
	 , pg_tablespace_location(oid)
  from pg_catalog.pg_tablespace;
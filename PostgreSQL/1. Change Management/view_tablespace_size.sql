-- https://www.postgresql.org/docs/current/functions-admin.html#FUNCTIONS-ADMIN-DBSIZE

select spcname as tablespace_name
     , pg_size_pretty(pg_tablespace_size(spcname)) as size
	 , pg_tablespace_location(oid)
  from pg_catalog.pg_tablespace;
  
SELECT spcname
     , pg_get_userbyid(spcowner) AS owner
     , CASE WHEN length(pg_tablespace_location(oid)) = 0 THEN (SELECT setting FROM pg_settings WHERE name='data_directory')
            ELSE pg_tablespace_location(oid)
       END AS spclocation
     , spcacl
     , spcoptions
     , pg_size_pretty(pg_tablespace_size(spcname)) AS size
  FROM pg_tablespace
 ORDER BY spcname;
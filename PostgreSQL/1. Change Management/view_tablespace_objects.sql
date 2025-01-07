SELECT pg_get_userbyid(spcowner) AS rolname
     , spcname
	 , CASE WHEN relkind='r' THEN 'Tables' 
	        ELSE 'Index'
       END AS kind
     , count(*) AS total
  FROM pg_class
     , pg_tablespace
 WHERE pg_tablespace.oid=reltablespace
   AND relkind IN ('r', 'i')
 GROUP BY 1, 2, 3
 ORDER BY 1, 2, 3;

-- Move tablespace  
alter table [TABLENAME] set tablespace [NEW_TABLESPACE];
-- Check whether the table is moved successfully to another tablespae
select * from pg_tables where tablename='[TABLENAME]'
-- Find physical location of the table
select pg_relation_filepath('[TABLENAME]');
-- Find physical location of the tablespace
/dt


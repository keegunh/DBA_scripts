SELECT pg_get_userbyid(relowner) AS owner
     , nspname
	 , relname
	 , pg_size_pretty(pg_relation_size(pg_class.oid)) AS size
  FROM pg_class
     , pg_namespace
 WHERE relkind='r'
   AND relhaspkey IS false
   AND relnamespace = pg_namespace.oid
 ORDER BY relowner, relname;
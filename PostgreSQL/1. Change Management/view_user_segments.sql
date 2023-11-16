SELECT pg_get_userbyid(relowner) AS rolname
     , CASE WHEN relkind='r' THEN 'table' 
            WHEN relkind='i' THEN 'index' 
            WHEN relkind='S' THEN 'sequence' 
            WHEN relkind='t' THEN 'TOAST table' 
            ELSE '' 
       END AS kind
	 , pg_size_pretty(SUM(pg_relation_size(pg_class.oid))::int8) AS size 
  FROM pg_class
 WHERE relkind IN ('r', 't', 'i', 'S')
 GROUP BY 1, 2
 ORDER BY 1, 2;
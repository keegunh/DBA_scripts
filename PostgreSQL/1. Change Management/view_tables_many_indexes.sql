SELECT schemaname
     , tablename
	 , count(*) as total
  FROM pg_indexes
 GROUP BY 1, 2
HAVING count(*)>=5
 ORDER BY 1, 2;
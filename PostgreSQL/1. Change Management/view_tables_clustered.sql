SELECT s.relname
     , s.indexrelname
     , a.attname
     , p.correlation
  FROM pg_stats p
     , pg_stat_user_indexes s
     , pg_index i
     , pg_attribute a
 WHERE i.indisclustered
   AND s.indexrelid = i.indexrelid
   AND p.tablename = s.relname
   AND a.attnum = ANY (indkey)
   AND a.attrelid = i.indrelid
   AND p.attname = a.attname
 ORDER BY 1, 2, 3;
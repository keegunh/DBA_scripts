SELECT n.nspname AS schemaname
     , c.relname AS tablerelname
     , i.relname AS indexrelname
     , pg_size_pretty(pg_relation_size(c.oid)) AS tablesize
     , pg_size_pretty(pg_relation_size(i.oid)) AS indexsize
  FROM pg_class c
  JOIN pg_index x
    ON c.oid = x.indrelid
  JOIN pg_class i
    ON i.oid = x.indexrelid
  LEFT JOIN pg_namespace n
    ON n.oid = c.relnamespace
 WHERE c.relkind IN ('r', 't')
   AND pg_relation_size(c.oid) < pg_relation_size(i.oid)
   AND pg_relation_size(c.oid) > 1048576
 ORDER BY 1, 2, 3;
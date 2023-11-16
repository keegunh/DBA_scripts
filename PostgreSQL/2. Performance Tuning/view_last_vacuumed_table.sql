SELECT schemaname
     , relname
     , max(greatest(last_vacuum, last_autovacuum)) as lastvac
  FROM pg_stat_all_tables
 WHERE last_vacuum IS NOT NULL
    OR last_autovacuum IS NOT NULL
 GROUP BY 1, 2
 ORDER BY 3 DESC;
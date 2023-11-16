SELECT schemaname
     , relname
     , max(greatest(last_analyze, last_autoanalyze)) as lastanalyze
  FROM pg_stat_all_tables
 WHERE last_analyze IS NOT NULL
    OR last_autoanalyze IS NOT NULL
 GROUP BY 1, 2
 ORDER BY 3 DESC;
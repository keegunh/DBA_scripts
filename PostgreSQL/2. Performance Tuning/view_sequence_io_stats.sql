SELECT schemaname
     , relname
     , blks_read
     , blks_hit
  FROM pg_statio_all_sequences
 ORDER BY schemaname, relname;
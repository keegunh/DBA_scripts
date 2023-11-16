SELECT schemaname
     , relname
     , indexrelname
     , blks_read
     , blks_hit
  FROM pg_statio_all_indexes
 ORDER BY schemaname, relname;
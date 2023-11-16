SELECT schemaname
     , relname
     , indexrelname
     , idx_blks_read
     , idx_blks_hit
  FROM pg_statio_all_indexes
 ORDER BY schemaname, relname;
SELECT schemaname
     , relname
     , heap_blks_read
     , heap_blks_hit
     , idx_blks_read
     , idx_blks_hit
     , toast_blks_read
     , toast_blks_hit
     , tidx_blks_read
     , tidx_blks_hit
  FROM pg_statio_all_tables
 ORDER BY schemaname, relname;
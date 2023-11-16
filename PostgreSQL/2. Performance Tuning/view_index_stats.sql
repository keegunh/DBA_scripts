SELECT schemaname
     , relname
     , indexrelname
     , idx_scan
     , idx_tup_read
     , idx_tup_fetch
  FROM pg_stat_all_indexes
 ORDER BY schemaname, relname;
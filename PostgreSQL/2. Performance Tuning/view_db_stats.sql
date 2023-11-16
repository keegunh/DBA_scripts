SELECT datname
     , numbackends
     , xact_commit
     , xact_rollback
     , blks_read
     , blks_hit
     , tup_returned
     , tup_fetched
     , tup_inserted
     , tup_updated
     , tup_deleted
     , conflicts
     , date_trunc('second', stats_reset) as stats_reset
  FROM pg_stat_database
 ORDER BY datname;
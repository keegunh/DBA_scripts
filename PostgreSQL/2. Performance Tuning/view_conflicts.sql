SELECT datname
     , confl_tablespace
     , confl_lock
     , confl_snapshot
     , confl_bufferpin
     , confl_deadlock
  FROM pg_stat_database_conflicts
 ORDER BY datname;
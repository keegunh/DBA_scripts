SELECT pid
     , usename
     , application_name
     , client_addr
     , client_hostname
     , client_port
     , date_trunc('second', backend_start) as backend_start
     , state
     , sent_lsn
     , write_lsn
     , flush_lsn
     , replay_lsn
     , sync_priority
     , sync_state
     , date_trunc('second', reply_time) as reply_time
  FROM pg_stat_replication
 ORDER BY application_name, pid;
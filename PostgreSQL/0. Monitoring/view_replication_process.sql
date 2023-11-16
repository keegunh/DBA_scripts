SELECT pid
     , usename
     , application_name
     , client_addr
     , client_hostname
     , client_port
     , date_trunc('second', backend_start) as backend_start
     , state
     , sent_location
     , write_location
     , flush_location
     , replay_location
     , sync_priority
     , sync_state
  FROM pg_stat_replication
 ORDER BY application_name, pid;
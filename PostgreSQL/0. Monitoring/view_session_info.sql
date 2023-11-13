select pid
     , datname
     , usename
     , application_name
     , client_hostname
     , client_port
     , backend_start
     , query_start
     , query
     , state
     , 'select pg_terminate_backend(' || pid || ');' kill_cmd
  from pg_stat_activity
 where 1=1
--   and state = 'active'
   and pid <> pg_backend_pid()
--   and datname = 'myDatabase'
 order by 1,2,3; 
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

-- view sessions
SELECT name
     , setting
  FROM pg_settings
 WHERE name IN ('max_connections', 'autovacuum_max_workers')
 UNION ALL
SELECT 'actual sessions'
     , COUNT(*)::text
  FROM pg_stat_activity;

-- view all processes
SELECT datname
     , pid
     , usename
     , query
     , date_trunc('second', query_start) as query_start
     , client_hostname
     , client_addr
     , waiting
     , date_trunc('second', xact_start) as xact_start
     , date_trunc('second', backend_start) as backend_start
     , application_name
  FROM pg_stat_activity
 ORDER BY datname, pid;
 
-- view active sessions
SELECT extract(epoch FROM (now() - query_start))::numeric(10,2) AS age
     , pid
     , usename
     , client_addr
     , application_name
     , query
  FROM pg_stat_activity
 WHERE query <> ''
 ORDER BY 1; 
SELECT pid
     , datname
     , usename
     , application_name
     , client_hostname
     , client_port
     , backend_start
     , query_start
     , query
     , state
     , 'select pg_cancel_backend(' || pid || ');' kill_cmd1 --graceful
     , 'select pg_terminate_backend(' || pid || ');' kill_cmd2 --forceful
  FROM pg_stat_activity
 WHERE 1=1
--   and state = 'active'
   AND pid <> pg_backend_pid()
--   and datname = 'myDatabase'
 ORDER BY 1,2,3; 

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
     -- , wait_event_type
	 , wait_event
	 , state
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
 
-- find slow, long-running, and Blocked Queries
SELECT pid
     , user
     , pg_stat_activity.query_start
     , now() - pg_stat_activity.query_start AS query_time
     , query
     , state
     , wait_event_type
     , wait_event
  FROM pg_stat_activity
 WHERE (now() - pg_stat_activity.query_start) > interval '10 minutes';

-- find blocking session
SELECT activity.pid
     , activity.usename
     , activity.query
     , blocking.pid AS blocking_id
     , blocking.query AS blocking_query
  FROM pg_stat_activity AS activity
  JOIN pg_stat_activity AS blocking
    ON blocking.pid = ANY(pg_blocking_pids(activity.pid));
  
  
-- terminate all queries
-- If you want to terminate all running queries, the following statement can be executed:
SELECT pg_cancel_backend(pid) 
  FROM pg_stat_activity
 WHERE state = 'active'
   AND pid <> pg_backend_pid();
   
-- find high cpu usage and which query is causing it.
SELECT 
  (total_time / 1000 / 3600) as total_hours,
  (total_time / 1000) as total_seconds,
  (total_time / calls) as avg_millis, 
  calls num_calls,
  query 
  FROM pg_stat_statements 
 ORDER BY 1 DESC
 LIMIT 10;

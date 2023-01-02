show variables like 'max_connections';
show status like 'threads_connected';
show status like 'threads_running';
show status like 'threads_created';
show status like 'threads_cached';

select variable_value into @t_running from performance_schema.global_status where variable_name = 'threads_running';
select variable_value into @t_connected from performance_schema.global_status where variable_name = 'threads_connected';
select variable_value into @t_created from performance_schema.global_status where variable_name = 'threads_created';
select variable_value into @t_cached from performance_schema.global_status where variable_name = 'threads_cached';
select variable_value into @max_conn from performance_schema.global_variables where variable_name = 'max_connections';

SELECT CONCAT(ROUND(@t_running / @max_conn * 100, 2),' %') AS Running_Thread_Pct
     , CONCAT(ROUND(@t_connected / @max_conn * 100, 2), ' %') AS Connected_Thread_Pct
     , CONCAT(ROUND(@t_created / @max_conn * 100, 2), ' %') AS Created_Thread_Pct
     , CONCAT(ROUND(@t_cached / @max_conn * 100, 2), ' %') AS Cached_Thread_Pct
     ;
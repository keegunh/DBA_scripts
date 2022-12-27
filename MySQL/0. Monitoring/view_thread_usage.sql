show variables like 'max_connections';
show status like 'threads_connected';
show status like 'threads_running';

select variable_value into @t_running from performance_schema.global_status where variable_name = 'threads_running';
select variable_value into @t_connected from performance_schema.global_status where variable_name = 'threads_connected';
select variable_value into @max_conn from performance_schema.global_variables where variable_name = 'max_connections';

SELECT CONCAT(ROUND(@t_running / @max_conn * 100, 2),' %') AS Running_Thread_Pct
     , CONCAT(ROUND(@t_connected / @max_conn * 100, 2), ' %') AS Connected_Thread_Pct;